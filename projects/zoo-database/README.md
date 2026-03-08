# Zoo Database

## Project Summary

This project models a small zoo system using normalized lookup tables for animal classification, habitat, nutrition, care instructions, and care specialists. It demonstrates how relational design makes it easier to retrieve a complete animal profile and calculate operating cost information from multiple linked tables.

## Skills Demonstrated

- Schema design with foreign keys
- Identity-based primary keys
- Lookup table normalization
- Join-heavy reporting queries
- Stored procedure design with validation
- Aggregate cost reporting

## Files

- `01_zoo_schema_and_seed.sql`: Creates the database objects and inserts sample data
- `02_zoo_queries_and_procedures.sql`: Adds reporting queries and the stored procedure for animal lookup

## Business Questions Answered

- What habitat, nutrition plan, and care routine belong to a specific animal?
- Which specialist is associated with a given animal's care plan?
- What are the total habitat and nutrition costs in the sample zoo setup?

## How To Run

1. Run `01_zoo_schema_and_seed.sql`
2. Run `02_zoo_queries_and_procedures.sql`

## Portfolio Talking Points

- The schema separates descriptive lookup data from the main species table to reduce duplication.
- The stored procedure shows reusable query logic rather than one-off ad hoc SQL.
- The sample queries demonstrate how to turn normalized records into readable operational reports.
