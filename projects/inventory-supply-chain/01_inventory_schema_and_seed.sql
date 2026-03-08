USE master;
GO

IF DB_ID('InventorySupplyChainDB') IS NULL
BEGIN
    CREATE DATABASE InventorySupplyChainDB;
END;
GO

USE InventorySupplyChainDB;
GO

IF OBJECT_ID('dbo.shipment_receipts', 'U') IS NOT NULL DROP TABLE dbo.shipment_receipts;
IF OBJECT_ID('dbo.backorders', 'U') IS NOT NULL DROP TABLE dbo.backorders;
IF OBJECT_ID('dbo.purchase_order_items', 'U') IS NOT NULL DROP TABLE dbo.purchase_order_items;
IF OBJECT_ID('dbo.purchase_orders', 'U') IS NOT NULL DROP TABLE dbo.purchase_orders;
IF OBJECT_ID('dbo.inventory_stock', 'U') IS NOT NULL DROP TABLE dbo.inventory_stock;
IF OBJECT_ID('dbo.supplier_products', 'U') IS NOT NULL DROP TABLE dbo.supplier_products;
IF OBJECT_ID('dbo.products', 'U') IS NOT NULL DROP TABLE dbo.products;
IF OBJECT_ID('dbo.warehouses', 'U') IS NOT NULL DROP TABLE dbo.warehouses;
IF OBJECT_ID('dbo.suppliers', 'U') IS NOT NULL DROP TABLE dbo.suppliers;
GO

CREATE TABLE dbo.suppliers (
    supplier_id INT IDENTITY(1,1) PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    supplier_category VARCHAR(50) NOT NULL,
    contact_email VARCHAR(100) NOT NULL,
    lead_time_days INT NOT NULL CHECK (lead_time_days >= 1)
);

CREATE TABLE dbo.warehouses (
    warehouse_id INT IDENTITY(1,1) PRIMARY KEY,
    warehouse_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    warehouse_type VARCHAR(50) NOT NULL
);

CREATE TABLE dbo.products (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    sku VARCHAR(30) NOT NULL UNIQUE,
    product_name VARCHAR(100) NOT NULL,
    product_category VARCHAR(50) NOT NULL,
    unit_cost DECIMAL(10,2) NOT NULL CHECK (unit_cost > 0),
    reorder_quantity INT NOT NULL CHECK (reorder_quantity > 0),
    primary_supplier_id INT NOT NULL,
    CONSTRAINT fk_products_supplier FOREIGN KEY (primary_supplier_id)
        REFERENCES dbo.suppliers(supplier_id)
);

CREATE TABLE dbo.supplier_products (
    supplier_id INT NOT NULL,
    product_id INT NOT NULL,
    contract_price DECIMAL(10,2) NOT NULL CHECK (contract_price > 0),
    minimum_order_qty INT NOT NULL CHECK (minimum_order_qty >= 1),
    CONSTRAINT pk_supplier_products PRIMARY KEY (supplier_id, product_id),
    CONSTRAINT fk_supplier_products_supplier FOREIGN KEY (supplier_id)
        REFERENCES dbo.suppliers(supplier_id),
    CONSTRAINT fk_supplier_products_product FOREIGN KEY (product_id)
        REFERENCES dbo.products(product_id)
);

CREATE TABLE dbo.inventory_stock (
    warehouse_id INT NOT NULL,
    product_id INT NOT NULL,
    on_hand_qty INT NOT NULL CHECK (on_hand_qty >= 0),
    reorder_level INT NOT NULL CHECK (reorder_level >= 0),
    safety_stock INT NOT NULL CHECK (safety_stock >= 0),
    last_counted_at DATE NOT NULL,
    CONSTRAINT pk_inventory_stock PRIMARY KEY (warehouse_id, product_id),
    CONSTRAINT fk_inventory_stock_warehouse FOREIGN KEY (warehouse_id)
        REFERENCES dbo.warehouses(warehouse_id),
    CONSTRAINT fk_inventory_stock_product FOREIGN KEY (product_id)
        REFERENCES dbo.products(product_id)
);

CREATE TABLE dbo.purchase_orders (
    purchase_order_id INT IDENTITY(1,1) PRIMARY KEY,
    supplier_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    order_date DATE NOT NULL,
    expected_delivery_date DATE NOT NULL,
    order_status VARCHAR(20) NOT NULL CHECK (order_status IN ('OPEN', 'RECEIVED', 'CANCELLED')),
    created_by VARCHAR(50) NOT NULL,
    CONSTRAINT fk_purchase_orders_supplier FOREIGN KEY (supplier_id)
        REFERENCES dbo.suppliers(supplier_id),
    CONSTRAINT fk_purchase_orders_warehouse FOREIGN KEY (warehouse_id)
        REFERENCES dbo.warehouses(warehouse_id)
);

CREATE TABLE dbo.purchase_order_items (
    purchase_order_id INT NOT NULL,
    line_number INT NOT NULL,
    product_id INT NOT NULL,
    ordered_qty INT NOT NULL CHECK (ordered_qty > 0),
    received_qty INT NOT NULL DEFAULT 0 CHECK (received_qty >= 0),
    unit_cost DECIMAL(10,2) NOT NULL CHECK (unit_cost > 0),
    CONSTRAINT pk_purchase_order_items PRIMARY KEY (purchase_order_id, line_number),
    CONSTRAINT fk_purchase_order_items_order FOREIGN KEY (purchase_order_id)
        REFERENCES dbo.purchase_orders(purchase_order_id),
    CONSTRAINT fk_purchase_order_items_product FOREIGN KEY (product_id)
        REFERENCES dbo.products(product_id)
);

CREATE TABLE dbo.shipment_receipts (
    receipt_id INT IDENTITY(1,1) PRIMARY KEY,
    purchase_order_id INT NOT NULL,
    received_date DATE NOT NULL,
    received_by VARCHAR(50) NOT NULL,
    notes VARCHAR(255) NULL,
    CONSTRAINT fk_shipment_receipts_order FOREIGN KEY (purchase_order_id)
        REFERENCES dbo.purchase_orders(purchase_order_id)
);

CREATE TABLE dbo.backorders (
    backorder_id INT IDENTITY(1,1) PRIMARY KEY,
    warehouse_id INT NOT NULL,
    product_id INT NOT NULL,
    requested_qty INT NOT NULL CHECK (requested_qty > 0),
    linked_purchase_order_id INT NULL,
    requested_by VARCHAR(50) NOT NULL,
    priority_level VARCHAR(10) NOT NULL CHECK (priority_level IN ('LOW', 'MEDIUM', 'HIGH')),
    requested_date DATE NOT NULL,
    backorder_status VARCHAR(20) NOT NULL CHECK (backorder_status IN ('OPEN', 'FULFILLED', 'CANCELLED')),
    CONSTRAINT fk_backorders_warehouse FOREIGN KEY (warehouse_id)
        REFERENCES dbo.warehouses(warehouse_id),
    CONSTRAINT fk_backorders_product FOREIGN KEY (product_id)
        REFERENCES dbo.products(product_id),
    CONSTRAINT fk_backorders_purchase_order FOREIGN KEY (linked_purchase_order_id)
        REFERENCES dbo.purchase_orders(purchase_order_id)
);
GO

INSERT INTO dbo.suppliers (supplier_name, supplier_category, contact_email, lead_time_days)
VALUES ('Northwind Industrial', 'Electronics', 'ops@northwind.example', 5),
       ('BlueRiver Packaging', 'Packaging', 'supply@blueriver.example', 3),
       ('FreshRoute Logistics', 'Cold Chain', 'support@freshroute.example', 4),
       ('Metro Components', 'Mechanical Parts', 'sales@metrocomponents.example', 6);

INSERT INTO dbo.warehouses (warehouse_name, city, warehouse_type)
VALUES ('Central Fulfillment Hub', 'Dallas', 'Regional'),
       ('Coastal Distribution Center', 'Atlanta', 'Regional'),
       ('Cold Storage Annex', 'Chicago', 'Specialized');

INSERT INTO dbo.products (sku, product_name, product_category, unit_cost, reorder_quantity, primary_supplier_id)
VALUES ('ELEC-1001', 'Barcode Scanner', 'Electronics', 85.00, 20, 1),
       ('ELEC-1002', 'Label Printer', 'Electronics', 210.00, 10, 1),
       ('PACK-2001', 'Shipping Carton', 'Packaging', 2.10, 200, 2),
       ('PACK-2002', 'Insulated Mailer', 'Packaging', 4.50, 120, 2),
       ('COLD-3001', 'Temperature Sensor', 'Cold Chain', 32.00, 30, 3),
       ('MECH-4001', 'Conveyor Belt Motor', 'Mechanical Parts', 540.00, 4, 4);

INSERT INTO dbo.supplier_products (supplier_id, product_id, contract_price, minimum_order_qty)
VALUES (1, 1, 82.00, 5),
       (1, 2, 205.00, 2),
       (2, 3, 1.95, 50),
       (2, 4, 4.10, 30),
       (3, 5, 30.00, 10),
       (4, 6, 525.00, 1);

INSERT INTO dbo.inventory_stock (warehouse_id, product_id, on_hand_qty, reorder_level, safety_stock, last_counted_at)
VALUES (1, 1, 12, 15, 6, '2026-03-01'),
       (1, 2, 11, 8, 3, '2026-03-01'),
       (1, 3, 90, 150, 50, '2026-03-01'),
       (1, 4, 65, 80, 20, '2026-03-01'),
       (2, 1, 25, 15, 6, '2026-03-02'),
       (2, 3, 260, 180, 60, '2026-03-02'),
       (2, 4, 20, 60, 20, '2026-03-02'),
       (3, 5, 14, 20, 8, '2026-03-03'),
       (3, 6, 2, 3, 1, '2026-03-03');

INSERT INTO dbo.purchase_orders (supplier_id, warehouse_id, order_date, expected_delivery_date, order_status, created_by)
VALUES (2, 1, '2026-03-01', '2026-03-04', 'OPEN', 'planner.musa'),
       (3, 3, '2026-03-02', '2026-03-06', 'OPEN', 'planner.fatou'),
       (1, 2, '2026-02-24', '2026-02-28', 'RECEIVED', 'planner.amie');

INSERT INTO dbo.purchase_order_items (purchase_order_id, line_number, product_id, ordered_qty, received_qty, unit_cost)
VALUES (1, 1, 3, 200, 0, 1.95),
       (1, 2, 4, 100, 0, 4.10),
       (2, 1, 5, 30, 0, 30.00),
       (3, 1, 1, 10, 10, 82.00),
       (3, 2, 2, 3, 3, 205.00);

INSERT INTO dbo.shipment_receipts (purchase_order_id, received_date, received_by, notes)
VALUES (3, '2026-02-28', 'receiving.khady', 'Received on time and cleared for picking.');

INSERT INTO dbo.backorders (
    warehouse_id,
    product_id,
    requested_qty,
    linked_purchase_order_id,
    requested_by,
    priority_level,
    requested_date,
    backorder_status
)
VALUES (1, 3, 80, 1, 'ops.sarr', 'HIGH', '2026-03-03', 'OPEN'),
       (3, 5, 18, 2, 'ops.darboe', 'HIGH', '2026-03-03', 'OPEN'),
       (2, 4, 25, NULL, 'ops.touray', 'MEDIUM', '2026-03-04', 'OPEN');
GO

SELECT sku, product_name, reorder_quantity
FROM dbo.products
ORDER BY product_name;
