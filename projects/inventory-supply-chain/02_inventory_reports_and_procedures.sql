USE InventorySupplyChainDB;
GO

CREATE OR ALTER PROCEDURE dbo.usp_CreateBackorder
    @WarehouseID INT,
    @ProductID INT,
    @RequestedQty INT,
    @RequestedBy VARCHAR(50),
    @PriorityLevel VARCHAR(10) = 'MEDIUM'
AS
BEGIN
    SET NOCOUNT ON;

    IF @RequestedQty <= 0
    BEGIN
        RAISERROR('Requested quantity must be greater than zero.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.inventory_stock
        WHERE warehouse_id = @WarehouseID
          AND product_id = @ProductID
    )
    BEGIN
        RAISERROR('The selected warehouse and product combination was not found.', 16, 1);
        RETURN;
    END;

    INSERT INTO dbo.backorders (
        warehouse_id,
        product_id,
        requested_qty,
        requested_by,
        priority_level,
        requested_date,
        backorder_status
    )
    VALUES (
        @WarehouseID,
        @ProductID,
        @RequestedQty,
        @RequestedBy,
        @PriorityLevel,
        CAST(GETDATE() AS DATE),
        'OPEN'
    );
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_CreateReorderPurchaseOrder
    @WarehouseID INT,
    @SupplierID INT,
    @CreatedBy VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.warehouses
        WHERE warehouse_id = @WarehouseID
    )
    BEGIN
        RAISERROR('The selected warehouse does not exist.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.suppliers
        WHERE supplier_id = @SupplierID
    )
    BEGIN
        RAISERROR('The selected supplier does not exist.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.inventory_stock AS stock
        INNER JOIN dbo.products AS products
            ON products.product_id = stock.product_id
        WHERE stock.warehouse_id = @WarehouseID
          AND products.primary_supplier_id = @SupplierID
          AND stock.on_hand_qty < stock.reorder_level
    )
    BEGIN
        RAISERROR('No low-stock products were found for the selected warehouse and supplier.', 16, 1);
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @PurchaseOrderID INT;

        INSERT INTO dbo.purchase_orders (
            supplier_id,
            warehouse_id,
            order_date,
            expected_delivery_date,
            order_status,
            created_by
        )
        SELECT
            @SupplierID,
            @WarehouseID,
            CAST(GETDATE() AS DATE),
            DATEADD(DAY, suppliers.lead_time_days, CAST(GETDATE() AS DATE)),
            'OPEN',
            @CreatedBy
        FROM dbo.suppliers AS suppliers
        WHERE suppliers.supplier_id = @SupplierID;

        SET @PurchaseOrderID = SCOPE_IDENTITY();

        INSERT INTO dbo.purchase_order_items (
            purchase_order_id,
            line_number,
            product_id,
            ordered_qty,
            unit_cost
        )
        SELECT
            @PurchaseOrderID,
            ROW_NUMBER() OVER (ORDER BY products.product_id),
            products.product_id,
            CASE
                WHEN products.reorder_quantity < supplier_products.minimum_order_qty THEN supplier_products.minimum_order_qty
                ELSE products.reorder_quantity
            END,
            supplier_products.contract_price
        FROM dbo.inventory_stock AS stock
        INNER JOIN dbo.products AS products
            ON products.product_id = stock.product_id
        INNER JOIN dbo.supplier_products AS supplier_products
            ON supplier_products.product_id = products.product_id
           AND supplier_products.supplier_id = @SupplierID
        WHERE stock.warehouse_id = @WarehouseID
          AND products.primary_supplier_id = @SupplierID
          AND stock.on_hand_qty < stock.reorder_level;

                UPDATE backorders
                SET linked_purchase_order_id = @PurchaseOrderID
                FROM dbo.backorders AS backorders
                INNER JOIN dbo.products AS products
                        ON products.product_id = backorders.product_id
                WHERE backorders.warehouse_id = @WarehouseID
                    AND backorders.backorder_status = 'OPEN'
                    AND products.primary_supplier_id = @SupplierID
                    AND backorders.linked_purchase_order_id IS NULL;

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        THROW;
    END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_ReceivePurchaseOrder
    @PurchaseOrderID INT,
    @ReceivedBy VARCHAR(50),
    @Notes VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.purchase_orders
        WHERE purchase_order_id = @PurchaseOrderID
          AND order_status = 'OPEN'
    )
    BEGIN
        RAISERROR('The purchase order was not found or is not open for receiving.', 16, 1);
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE items
        SET received_qty = ordered_qty
        FROM dbo.purchase_order_items AS items
        WHERE items.purchase_order_id = @PurchaseOrderID;

        UPDATE stock
        SET stock.on_hand_qty = stock.on_hand_qty + items.ordered_qty,
            stock.last_counted_at = CAST(GETDATE() AS DATE)
        FROM dbo.inventory_stock AS stock
        INNER JOIN dbo.purchase_orders AS orders
            ON orders.warehouse_id = stock.warehouse_id
        INNER JOIN dbo.purchase_order_items AS items
            ON items.purchase_order_id = orders.purchase_order_id
           AND items.product_id = stock.product_id
        WHERE orders.purchase_order_id = @PurchaseOrderID;

        INSERT INTO dbo.inventory_stock (
            warehouse_id,
            product_id,
            on_hand_qty,
            reorder_level,
            safety_stock,
            last_counted_at
        )
        SELECT
            orders.warehouse_id,
            items.product_id,
            items.ordered_qty,
            0,
            0,
            CAST(GETDATE() AS DATE)
        FROM dbo.purchase_orders AS orders
        INNER JOIN dbo.purchase_order_items AS items
            ON items.purchase_order_id = orders.purchase_order_id
        WHERE orders.purchase_order_id = @PurchaseOrderID
          AND NOT EXISTS (
              SELECT 1
              FROM dbo.inventory_stock AS stock
              WHERE stock.warehouse_id = orders.warehouse_id
                AND stock.product_id = items.product_id
          );

        INSERT INTO dbo.shipment_receipts (purchase_order_id, received_date, received_by, notes)
        VALUES (@PurchaseOrderID, CAST(GETDATE() AS DATE), @ReceivedBy, @Notes);

        UPDATE dbo.purchase_orders
        SET order_status = 'RECEIVED'
        WHERE purchase_order_id = @PurchaseOrderID;

        UPDATE backorders
        SET backorder_status = 'FULFILLED'
        FROM dbo.backorders AS backorders
        INNER JOIN dbo.purchase_order_items AS items
            ON items.product_id = backorders.product_id
        INNER JOIN dbo.purchase_orders AS orders
            ON orders.purchase_order_id = items.purchase_order_id
        WHERE orders.purchase_order_id = @PurchaseOrderID
          AND backorders.warehouse_id = orders.warehouse_id
          AND backorders.backorder_status = 'OPEN';

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        THROW;
    END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_InventoryRiskDashboard
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        warehouses.warehouse_name,
        products.sku,
        products.product_name,
        stock.on_hand_qty,
        stock.reorder_level,
        stock.safety_stock,
        CASE
            WHEN stock.on_hand_qty <= stock.safety_stock THEN 'CRITICAL'
            WHEN stock.on_hand_qty < stock.reorder_level THEN 'REORDER'
            ELSE 'HEALTHY'
        END AS stock_health,
        suppliers.supplier_name,
        suppliers.lead_time_days
    FROM dbo.inventory_stock AS stock
    INNER JOIN dbo.warehouses AS warehouses
        ON warehouses.warehouse_id = stock.warehouse_id
    INNER JOIN dbo.products AS products
        ON products.product_id = stock.product_id
    INNER JOIN dbo.suppliers AS suppliers
        ON suppliers.supplier_id = products.primary_supplier_id
    ORDER BY
        CASE
            WHEN stock.on_hand_qty <= stock.safety_stock THEN 1
            WHEN stock.on_hand_qty < stock.reorder_level THEN 2
            ELSE 3
        END,
        warehouses.warehouse_name,
        products.product_name;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_BackorderDashboard
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        backorders.backorder_id,
        warehouses.warehouse_name,
        products.sku,
        products.product_name,
        backorders.requested_qty,
        backorders.priority_level,
        backorders.requested_date,
        DATEDIFF(DAY, backorders.requested_date, CAST(GETDATE() AS DATE)) AS days_open,
        backorders.backorder_status,
        suppliers.supplier_name,
        backorders.linked_purchase_order_id
    FROM dbo.backorders AS backorders
    INNER JOIN dbo.warehouses AS warehouses
        ON warehouses.warehouse_id = backorders.warehouse_id
    INNER JOIN dbo.products AS products
        ON products.product_id = backorders.product_id
    INNER JOIN dbo.suppliers AS suppliers
        ON suppliers.supplier_id = products.primary_supplier_id
    ORDER BY
        CASE backorders.priority_level
            WHEN 'HIGH' THEN 1
            WHEN 'MEDIUM' THEN 2
            ELSE 3
        END,
        backorders.requested_date;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_SupplierPerformanceDashboard
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        suppliers.supplier_name,
        COUNT(orders.purchase_order_id) AS total_purchase_orders,
        SUM(CASE WHEN orders.order_status = 'RECEIVED' THEN 1 ELSE 0 END) AS received_orders,
        AVG(CASE
            WHEN receipts.receipt_id IS NOT NULL THEN DATEDIFF(DAY, orders.order_date, receipts.received_date)
        END) AS avg_days_to_receive,
        SUM(CASE
            WHEN receipts.receipt_id IS NOT NULL AND receipts.received_date <= orders.expected_delivery_date THEN 1
            ELSE 0
        END) AS on_time_receipts
    FROM dbo.suppliers AS suppliers
    LEFT JOIN dbo.purchase_orders AS orders
        ON orders.supplier_id = suppliers.supplier_id
    LEFT JOIN dbo.shipment_receipts AS receipts
        ON receipts.purchase_order_id = orders.purchase_order_id
    GROUP BY suppliers.supplier_name
    ORDER BY total_purchase_orders DESC, suppliers.supplier_name;
END;
GO

EXEC dbo.usp_InventoryRiskDashboard;

SELECT
    warehouses.warehouse_name,
    SUM(stock.on_hand_qty * products.unit_cost) AS inventory_value
FROM dbo.inventory_stock AS stock
INNER JOIN dbo.warehouses AS warehouses
    ON warehouses.warehouse_id = stock.warehouse_id
INNER JOIN dbo.products AS products
    ON products.product_id = stock.product_id
GROUP BY warehouses.warehouse_name
ORDER BY inventory_value DESC;

SELECT
    orders.purchase_order_id,
    suppliers.supplier_name,
    warehouses.warehouse_name,
    orders.order_status,
    SUM(items.ordered_qty * items.unit_cost) AS order_total
FROM dbo.purchase_orders AS orders
INNER JOIN dbo.suppliers AS suppliers
    ON suppliers.supplier_id = orders.supplier_id
INNER JOIN dbo.warehouses AS warehouses
    ON warehouses.warehouse_id = orders.warehouse_id
INNER JOIN dbo.purchase_order_items AS items
    ON items.purchase_order_id = orders.purchase_order_id
GROUP BY
    orders.purchase_order_id,
    suppliers.supplier_name,
    warehouses.warehouse_name,
    orders.order_status
ORDER BY orders.purchase_order_id;

EXEC dbo.usp_BackorderDashboard;

EXEC dbo.usp_SupplierPerformanceDashboard;

EXEC dbo.usp_CreateBackorder
    @WarehouseID = 1,
    @ProductID = 1,
    @RequestedQty = 12,
    @RequestedBy = 'ops.jobe',
    @PriorityLevel = 'HIGH';

EXEC dbo.usp_CreateReorderPurchaseOrder
    @WarehouseID = 1,
    @SupplierID = 2,
    @CreatedBy = 'planner.sainey';

EXEC dbo.usp_ReceivePurchaseOrder
    @PurchaseOrderID = 1,
    @ReceivedBy = 'receiving.aisha',
    @Notes = 'Received in full and moved to staging.';

EXEC dbo.usp_InventoryRiskDashboard;

EXEC dbo.usp_BackorderDashboard;

EXEC dbo.usp_SupplierPerformanceDashboard;
GO
