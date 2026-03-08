# Bookstore Database

## Project Summary

This project models a small bookstore database with authors and books in a one-to-many relationship. It is intentionally compact and useful as a clean example of basic relational modeling, seed data insertion, and stored procedure usage.

## Skills Demonstrated

- One-to-many relationship design
- Identity primary keys
- Foreign key enforcement
- Stored procedures for inserts and filtered retrieval
- Readable query structure for reporting

## Files

- `01_bookstore_schema_and_seed.sql`: Creates tables, constraints, sample data, and a join query
- `02_bookstore_stored_procedures.sql`: Adds reusable procedures for inserting new records and filtering books by nationality

## Business Questions Answered

- Which books belong to authors from a selected nationality?
- How can a new author and book be inserted in a single repeatable workflow?

## How To Run

1. Run `01_bookstore_schema_and_seed.sql`
2. Run `02_bookstore_stored_procedures.sql`

## Portfolio Talking Points

- This project shows that I can present a small database cleanly without unnecessary complexity.
- The procedures are simple, but they show parameter handling and repeatable database operations.
