# SQL and Database Projects

This repository is a curated SQL Server portfolio focused on practical database design and query development. The projects are written to show how I model relational data, enforce integrity with keys and constraints, seed realistic sample data, and expose useful business queries through joins, stored procedures, and aggregate reports.

## Suggested GitHub Metadata

Repository name:
`sql-and-database-projects`

Repository description:
`Portfolio-ready SQL Server projects covering database design, joins, stored procedures, reporting queries, and relational modeling.`

About blurb:
`A curated SQL Server portfolio with practical database projects for operations, ticketing, inventory, and business reporting.`

Suggested topics:

- `sql`
- `tsql`
- `sql-server`
- `database-design`
- `stored-procedures`
- `relational-database`
- `data-modeling`
- `portfolio-project`
- `database-projects`
- `ssms`

## What This Repository Demonstrates

- Relational schema design for small business and operational systems
- Primary keys, foreign keys, identity columns, and composite keys
- Seed scripts that create reproducible demo datasets
- Multi-table joins for reporting and data retrieval
- Stored procedures for reusable business logic
- Basic validation and error handling in T-SQL

## Featured Projects

| Project | Focus | Highlights | Files |
| --- | --- | --- | --- |
| Zoo Database | Normalized entity model for animals, habitats, nutrition, and care workflows | Multi-table joins, lookup design, stored procedure for animal lookup, aggregate cost reporting | `projects/zoo-database` |
| Bookstore Database | Simple one-to-many author and book relationship | Clean schema design, insert procedure, filtered reporting procedure | `projects/bookstore-database` |
| Library Management Database | Lending workflow across books, borrowers, copies, loans, and branches | Composite keys, operational reporting, inventory procedures, borrower activity checks | `projects/library-management` |
| Inventory and Supply Chain Database | Operational warehouse and replenishment workflow | Low-stock reporting, purchase orders, receiving workflow, inventory valuation | `projects/inventory-supply-chain` |
| Event Ticketing Database | Transactional booking and payment workflow | Seat availability rules, booking procedures, payment capture, revenue reporting | `projects/event-ticketing` |

## Why These Projects Matter

Each project is designed to answer a real operational question rather than only demonstrate syntax.

- The zoo project shows how normalized data supports animal care, habitat planning, and cost visibility.
- The bookstore project shows a compact example of relationship design and procedure-based inserts.
- The library project shows a broader transaction-oriented schema with reporting use cases that resemble day-to-day business operations.
- The inventory project shows operational planning, replenishment logic, and warehouse reporting.
- The event ticketing project shows transactional booking logic, constraint-driven seat protection, and customer-facing workflows.

## Recommended Review Order

If you are reviewing this repository quickly, start here:

1. `projects/zoo-database/README.md`
2. `projects/zoo-database/01_zoo_schema_and_seed.sql`
3. `projects/zoo-database/02_zoo_queries_and_procedures.sql`
4. `projects/bookstore-database/README.md`
5. `projects/library-management/README.md`
6. `projects/inventory-supply-chain/README.md`
7. `projects/event-ticketing/README.md`

## Repository Structure

- `projects/`: Curated portfolio-ready projects
- `archive/original-scripts/`: Earlier practice scripts preserved for reference

## Environment

- SQL Server
- SQL Server Management Studio or Azure Data Studio

## How To Run

Run the scripts in numeric order within each project folder.

Example for the zoo project:

1. Run `01_zoo_schema_and_seed.sql`
2. Run `02_zoo_queries_and_procedures.sql`

The scripts are written so a reviewer can open a folder, run the SQL in sequence, and understand the project without additional setup files.

## Notes For Reviewers

- The curated versions live under `projects/`.
- The `archive/` folder keeps earlier drafts and practice work for transparency, but it is not the primary portfolio surface.
- The emphasis here is on database fundamentals, clean SQL organization, and readable business-oriented examples.

## Publishing Notes

If you are preparing this repository for GitHub, see `docs/github-publishing.md` for copy-ready metadata and a short launch checklist.
