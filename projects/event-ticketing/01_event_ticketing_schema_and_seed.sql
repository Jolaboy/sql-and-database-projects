USE master;
GO

IF DB_ID('EventTicketingDB') IS NULL
BEGIN
    CREATE DATABASE EventTicketingDB;
END;
GO

USE EventTicketingDB;
GO

IF OBJECT_ID('dbo.refund_transactions', 'U') IS NOT NULL DROP TABLE dbo.refund_transactions;
IF OBJECT_ID('dbo.payments', 'U') IS NOT NULL DROP TABLE dbo.payments;
IF OBJECT_ID('dbo.tickets', 'U') IS NOT NULL DROP TABLE dbo.tickets;
IF OBJECT_ID('dbo.bookings', 'U') IS NOT NULL DROP TABLE dbo.bookings;
IF OBJECT_ID('dbo.customers', 'U') IS NOT NULL DROP TABLE dbo.customers;
IF OBJECT_ID('dbo.events', 'U') IS NOT NULL DROP TABLE dbo.events;
IF OBJECT_ID('dbo.seats', 'U') IS NOT NULL DROP TABLE dbo.seats;
IF OBJECT_ID('dbo.seat_sections', 'U') IS NOT NULL DROP TABLE dbo.seat_sections;
IF OBJECT_ID('dbo.venues', 'U') IS NOT NULL DROP TABLE dbo.venues;
GO

CREATE TABLE dbo.venues (
    venue_id INT IDENTITY(1,1) PRIMARY KEY,
    venue_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    capacity INT NOT NULL CHECK (capacity > 0)
);

CREATE TABLE dbo.seat_sections (
    section_id INT IDENTITY(1,1) PRIMARY KEY,
    venue_id INT NOT NULL,
    section_name VARCHAR(50) NOT NULL,
    base_price DECIMAL(10,2) NOT NULL CHECK (base_price > 0),
    CONSTRAINT fk_sections_venue FOREIGN KEY (venue_id)
        REFERENCES dbo.venues(venue_id)
);

CREATE TABLE dbo.seats (
    seat_id INT IDENTITY(1,1) PRIMARY KEY,
    venue_id INT NOT NULL,
    section_id INT NOT NULL,
    row_label VARCHAR(10) NOT NULL,
    seat_number INT NOT NULL,
    CONSTRAINT uq_seat UNIQUE (venue_id, section_id, row_label, seat_number),
    CONSTRAINT fk_seats_venue FOREIGN KEY (venue_id)
        REFERENCES dbo.venues(venue_id),
    CONSTRAINT fk_seats_section FOREIGN KEY (section_id)
        REFERENCES dbo.seat_sections(section_id)
);

CREATE TABLE dbo.events (
    event_id INT IDENTITY(1,1) PRIMARY KEY,
    venue_id INT NOT NULL,
    event_name VARCHAR(100) NOT NULL,
    event_category VARCHAR(50) NOT NULL,
    event_date DATE NOT NULL,
    event_time TIME NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('SCHEDULED', 'SOLD_OUT', 'COMPLETED', 'CANCELLED')),
    CONSTRAINT fk_events_venue FOREIGN KEY (venue_id)
        REFERENCES dbo.venues(venue_id)
);

CREATE TABLE dbo.customers (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email_address VARCHAR(100) NOT NULL UNIQUE,
    loyalty_tier VARCHAR(20) NOT NULL CHECK (loyalty_tier IN ('STANDARD', 'SILVER', 'GOLD'))
);

CREATE TABLE dbo.bookings (
    booking_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    event_id INT NOT NULL,
    booking_reference VARCHAR(20) NOT NULL UNIQUE,
    booking_status VARCHAR(20) NOT NULL CHECK (booking_status IN ('HELD', 'CONFIRMED', 'CANCELLED')),
    booked_at DATETIME2 NOT NULL,
    CONSTRAINT fk_bookings_customer FOREIGN KEY (customer_id)
        REFERENCES dbo.customers(customer_id),
    CONSTRAINT fk_bookings_event FOREIGN KEY (event_id)
        REFERENCES dbo.events(event_id)
);

CREATE TABLE dbo.tickets (
    ticket_id INT IDENTITY(1,1) PRIMARY KEY,
    booking_id INT NOT NULL,
    event_id INT NOT NULL,
    seat_id INT NOT NULL,
    ticket_price DECIMAL(10,2) NOT NULL CHECK (ticket_price > 0),
    ticket_status VARCHAR(20) NOT NULL CHECK (ticket_status IN ('RESERVED', 'PAID', 'CANCELLED')),
    CONSTRAINT uq_event_seat UNIQUE (event_id, seat_id),
    CONSTRAINT fk_tickets_booking FOREIGN KEY (booking_id)
        REFERENCES dbo.bookings(booking_id),
    CONSTRAINT fk_tickets_event FOREIGN KEY (event_id)
        REFERENCES dbo.events(event_id),
    CONSTRAINT fk_tickets_seat FOREIGN KEY (seat_id)
        REFERENCES dbo.seats(seat_id)
);

CREATE TABLE dbo.payments (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    booking_id INT NOT NULL,
    payment_date DATETIME2 NOT NULL,
    amount_paid DECIMAL(10,2) NOT NULL CHECK (amount_paid > 0),
    payment_method VARCHAR(30) NOT NULL,
    payment_status VARCHAR(20) NOT NULL CHECK (payment_status IN ('PENDING', 'PAID', 'REFUNDED')),
    CONSTRAINT fk_payments_booking FOREIGN KEY (booking_id)
        REFERENCES dbo.bookings(booking_id)
);

CREATE TABLE dbo.refund_transactions (
    refund_id INT IDENTITY(1,1) PRIMARY KEY,
    payment_id INT NOT NULL,
    refund_date DATETIME2 NOT NULL,
    refund_amount DECIMAL(10,2) NOT NULL CHECK (refund_amount > 0),
    refund_reason VARCHAR(100) NOT NULL,
    processed_by VARCHAR(50) NOT NULL,
    CONSTRAINT fk_refund_transactions_payment FOREIGN KEY (payment_id)
        REFERENCES dbo.payments(payment_id)
);
GO

INSERT INTO dbo.venues (venue_name, city, capacity)
VALUES ('Harbor Arena', 'Seattle', 10),
       ('Metro Live Hall', 'Houston', 8),
       ('Skyline Theater', 'Austin', 12);

INSERT INTO dbo.seat_sections (venue_id, section_name, base_price)
VALUES (1, 'VIP', 180.00),
       (1, 'General', 95.00),
       (2, 'Front Floor', 140.00),
       (2, 'Balcony', 75.00),
       (3, 'Premium', 160.00),
       (3, 'Standard', 90.00);

INSERT INTO dbo.seats (venue_id, section_id, row_label, seat_number)
VALUES (1, 1, 'A', 1),
       (1, 1, 'A', 2),
       (1, 1, 'A', 3),
       (1, 2, 'B', 1),
       (1, 2, 'B', 2),
       (1, 2, 'B', 3),
       (2, 3, 'A', 1),
       (2, 3, 'A', 2),
       (2, 4, 'C', 1),
    (2, 4, 'C', 2),
    (3, 5, 'A', 1),
    (3, 5, 'A', 2),
    (3, 6, 'B', 1),
    (3, 6, 'B', 2);

INSERT INTO dbo.events (venue_id, event_name, event_category, event_date, event_time, status)
VALUES (1, 'Future of Data Summit', 'Conference', '2026-05-14', '18:00', 'SCHEDULED'),
       (1, 'Indie Night Live', 'Concert', '2026-05-21', '20:00', 'SCHEDULED'),
    (2, 'City Tech Expo', 'Expo', '2026-06-03', '10:00', 'SCHEDULED'),
    (3, 'Startup Demo Night', 'Pitch Event', '2026-06-11', '19:00', 'SCHEDULED');

INSERT INTO dbo.customers (full_name, email_address, loyalty_tier)
VALUES ('Awa Jallow', 'awa@example.com', 'GOLD'),
       ('Musa Sonko', 'musa@example.com', 'STANDARD'),
       ('Fatou Ceesay', 'fatou@example.com', 'SILVER'),
    ('Pa Modou Bah', 'pamodou@example.com', 'STANDARD'),
    ('Mariama Sowe', 'mariama@example.com', 'GOLD'),
    ('Alieu Njie', 'alieu@example.com', 'SILVER');

INSERT INTO dbo.bookings (customer_id, event_id, booking_reference, booking_status, booked_at)
VALUES (1, 1, 'BK-10001', 'CONFIRMED', '2026-03-08T10:00:00'),
       (2, 1, 'BK-10002', 'HELD', '2026-03-08T10:15:00'),
    (3, 2, 'BK-10003', 'CONFIRMED', '2026-03-08T11:00:00'),
    (5, 3, 'BK-10004', 'CONFIRMED', '2026-03-08T11:30:00'),
    (6, 4, 'BK-10005', 'HELD', '2026-03-08T12:00:00');

INSERT INTO dbo.tickets (booking_id, event_id, seat_id, ticket_price, ticket_status)
VALUES (1, 1, 1, 180.00, 'PAID'),
       (2, 1, 2, 180.00, 'RESERVED'),
    (3, 2, 4, 95.00, 'PAID'),
    (4, 3, 7, 140.00, 'PAID'),
    (5, 4, 11, 160.00, 'RESERVED');

INSERT INTO dbo.payments (booking_id, payment_date, amount_paid, payment_method, payment_status)
VALUES (1, '2026-03-08T10:03:00', 180.00, 'Card', 'PAID'),
    (3, '2026-03-08T11:05:00', 95.00, 'Card', 'PAID'),
    (4, '2026-03-08T11:35:00', 140.00, 'Card', 'PAID');
GO

SELECT event_name, event_date, status
FROM dbo.events
ORDER BY event_date;
