# Event Ticketing Database

## Project Summary

This project models an event ticketing workflow across venues, seat sections, seats, events, customers, bookings, tickets, and payments. It is designed to demonstrate transactional logic for seat reservation, ticket sales, and booking payments while keeping the schema compact enough for portfolio review.

## Skills Demonstrated

- User-facing transactional schema design
- Unique constraints to protect seat availability
- Stored procedures for booking and payment workflows
- Cancellation and refund workflows
- Revenue and availability reporting queries
- Practical business rules in T-SQL
- Dashboard-style event sales and customer value reporting

## Files

- `01_event_ticketing_schema_and_seed.sql`: Creates the ticketing schema and inserts sample venue, event, customer, booking, ticket, and payment data
- `02_event_ticketing_reports_and_procedures.sql`: Adds booking, payment, cancellation, refund, and reporting procedures

## Business Questions Answered

- Which seats are still available for a given event?
- How much paid revenue has each event generated?
- What is a customer's booking history and total booking value?
- How can a seat be reserved only if it is still available?
- How can a paid booking be cancelled while preserving a refund trail?
- Which customers generate the most value and how much has been refunded?

## How To Run

1. Run `01_event_ticketing_schema_and_seed.sql`
2. Run `02_event_ticketing_reports_and_procedures.sql`

## Portfolio Talking Points

- This project shows transactional and user-facing logic rather than only static reference data.
- The seat reservation rules demonstrate how constraints and procedures work together to protect data integrity.
- The schema supports both customer activity reporting and event revenue analysis.
- The refund workflow adds a more realistic lifecycle than a basic booking demo and makes the project stronger in live walkthroughs.
