# Library Management Database

## Project Summary

This project models a library lending system with books, borrowers, publishers, branches, copies, and loans. It demonstrates a wider relational model than the bookstore example and includes reporting procedures tied to common business questions.

## Skills Demonstrated

- Multi-table relational design
- Composite primary keys
- Referential integrity across operational tables
- Stored procedures for inventory and borrower reporting
- Query design for transactional data

## Files

- `01_library_schema_seed_and_reports.sql`: Creates the full schema, inserts sample data, adds procedures, and runs example reports

## Business Questions Answered

- How many copies of a specific title are available at a target branch?
- How many copies of a title exist across all branches?
- Which borrowers currently have no books checked out?

## How To Run

1. Run `01_library_schema_seed_and_reports.sql`

## Portfolio Talking Points

- This project shows a broader operational schema with both reference and transaction-like tables.
- The reporting procedures are aimed at questions a branch manager or operations user might actually ask.
