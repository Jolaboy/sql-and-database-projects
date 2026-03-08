# Inventory and Supply Chain Database

## Project Summary

This project models a warehouse inventory and replenishment workflow across suppliers, products, warehouses, stock positions, purchase orders, and shipment receipts. It is designed to show how database structure can support operational decisions such as identifying low stock, creating replenishment orders, and receiving inbound shipments.

## Skills Demonstrated

- Operational schema design for inventory systems
- Foreign keys and composite primary keys
- Reorder and replenishment logic in stored procedures
- Backorder lifecycle handling for shortage scenarios
- Inventory valuation and purchasing reports
- Transaction handling for supply chain workflows
- Dashboard-style supplier and inventory risk reporting

## Files

- `01_inventory_schema_and_seed.sql`: Creates the schema and inserts sample supplier, warehouse, product, stock, and purchase order data
- `02_inventory_reports_and_procedures.sql`: Adds replenishment procedures, backorder logic, and dashboard-style operational reporting queries

## Business Questions Answered

- Which products are below reorder level at each warehouse?
- What is the current inventory value by warehouse?
- What open purchase orders exist and what is their total value?
- How can a replenishment purchase order be created automatically for low-stock items?
- Which backorders are still open, how old are they, and which supplier is tied to them?
- How reliably are suppliers delivering purchase orders on time?

## How To Run

1. Run `01_inventory_schema_and_seed.sql`
2. Run `02_inventory_reports_and_procedures.sql`

## Portfolio Talking Points

- This project demonstrates business-oriented database design rather than simple reference data modeling.
- The stored procedures simulate operational workflows that planners and warehouse teams would actually use.
- The schema supports both reporting and transactional updates, which makes it a strong portfolio example for real-world operations data.
- The dashboard procedures make it easy to demo this project live with management-style views instead of isolated ad hoc queries.
