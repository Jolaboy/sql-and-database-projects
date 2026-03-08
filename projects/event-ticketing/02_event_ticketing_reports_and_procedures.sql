USE EventTicketingDB;
GO

CREATE OR ALTER PROCEDURE dbo.usp_CreateSeatBooking
    @EventID INT,
    @CustomerID INT,
    @SeatID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.customers
        WHERE customer_id = @CustomerID
    )
    BEGIN
        RAISERROR('The selected customer does not exist.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.events
        WHERE event_id = @EventID
          AND status = 'SCHEDULED'
    )
    BEGIN
        RAISERROR('The selected event is not available for booking.', 16, 1);
        RETURN;
    END;

    IF EXISTS (
        SELECT 1
        FROM dbo.tickets
        WHERE event_id = @EventID
          AND seat_id = @SeatID
          AND ticket_status IN ('RESERVED', 'PAID')
    )
    BEGIN
        RAISERROR('The selected seat is already reserved for this event.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.events AS events
        INNER JOIN dbo.seats AS seats
            ON seats.venue_id = events.venue_id
        WHERE events.event_id = @EventID
          AND seats.seat_id = @SeatID
    )
    BEGIN
        RAISERROR('The selected seat does not belong to the event venue.', 16, 1);
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @BookingID INT;
        DECLARE @TicketPrice DECIMAL(10,2);
        DECLARE @BookingReference VARCHAR(20);

        SELECT @TicketPrice = sections.base_price
        FROM dbo.seats AS seats
        INNER JOIN dbo.seat_sections AS sections
            ON sections.section_id = seats.section_id
        WHERE seats.seat_id = @SeatID;

        SET @BookingReference = CONCAT('BK-', RIGHT(CONVERT(VARCHAR(20), ABS(CHECKSUM(NEWID()))), 8));

        INSERT INTO dbo.bookings (customer_id, event_id, booking_reference, booking_status, booked_at)
        VALUES (@CustomerID, @EventID, @BookingReference, 'HELD', SYSDATETIME());

        SET @BookingID = SCOPE_IDENTITY();

        INSERT INTO dbo.tickets (booking_id, event_id, seat_id, ticket_price, ticket_status)
        VALUES (@BookingID, @EventID, @SeatID, @TicketPrice, 'RESERVED');

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        THROW;
    END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_RecordBookingPayment
    @BookingID INT,
    @PaymentMethod VARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM dbo.payments
        WHERE booking_id = @BookingID
          AND payment_status = 'PAID'
    )
    BEGIN
        RAISERROR('A completed payment already exists for this booking.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.bookings
        WHERE booking_id = @BookingID
          AND booking_status IN ('HELD', 'CONFIRMED')
    )
    BEGIN
        RAISERROR('The booking was not found or cannot be paid.', 16, 1);
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @Amount DECIMAL(10,2);

        SELECT @Amount = SUM(ticket_price)
        FROM dbo.tickets
        WHERE booking_id = @BookingID
          AND ticket_status IN ('RESERVED', 'PAID');

        INSERT INTO dbo.payments (booking_id, payment_date, amount_paid, payment_method, payment_status)
        VALUES (@BookingID, SYSDATETIME(), @Amount, @PaymentMethod, 'PAID');

        UPDATE dbo.bookings
        SET booking_status = 'CONFIRMED'
        WHERE booking_id = @BookingID;

        UPDATE dbo.tickets
        SET ticket_status = 'PAID'
        WHERE booking_id = @BookingID;

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        THROW;
    END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_CancelBookingAndRefund
    @BookingID INT,
    @ProcessedBy VARCHAR(50),
    @RefundReason VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.bookings
        WHERE booking_id = @BookingID
          AND booking_status IN ('HELD', 'CONFIRMED')
    )
    BEGIN
        RAISERROR('The booking was not found or is already cancelled.', 16, 1);
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @PaymentID INT;
        DECLARE @RefundAmount DECIMAL(10,2);

        SELECT TOP (1)
            @PaymentID = payment_id,
            @RefundAmount = amount_paid
        FROM dbo.payments
        WHERE booking_id = @BookingID
          AND payment_status = 'PAID'
        ORDER BY payment_date DESC;

        IF @PaymentID IS NOT NULL
        BEGIN
            UPDATE dbo.payments
            SET payment_status = 'REFUNDED'
            WHERE payment_id = @PaymentID;

            INSERT INTO dbo.refund_transactions (
                payment_id,
                refund_date,
                refund_amount,
                refund_reason,
                processed_by
            )
            VALUES (
                @PaymentID,
                SYSDATETIME(),
                @RefundAmount,
                @RefundReason,
                @ProcessedBy
            );
        END;

        UPDATE dbo.bookings
        SET booking_status = 'CANCELLED'
        WHERE booking_id = @BookingID;

        UPDATE dbo.tickets
        SET ticket_status = 'CANCELLED'
        WHERE booking_id = @BookingID;

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        THROW;
    END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_EventSalesDashboard
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        events.event_name,
        venues.venue_name,
        COUNT(DISTINCT seats.seat_id) AS venue_seat_count,
        COUNT(DISTINCT CASE WHEN tickets.ticket_status IN ('RESERVED', 'PAID') THEN tickets.ticket_id END) AS committed_tickets,
        SUM(CASE WHEN tickets.ticket_status = 'PAID' THEN tickets.ticket_price ELSE 0 END) AS paid_revenue,
        CAST(
            100.0 * COUNT(DISTINCT CASE WHEN tickets.ticket_status IN ('RESERVED', 'PAID') THEN tickets.ticket_id END)
            / NULLIF(COUNT(DISTINCT seats.seat_id), 0)
            AS DECIMAL(5,2)
        ) AS sell_through_pct
    FROM dbo.events AS events
    INNER JOIN dbo.venues AS venues
        ON venues.venue_id = events.venue_id
    INNER JOIN dbo.seats AS seats
        ON seats.venue_id = venues.venue_id
    LEFT JOIN dbo.tickets AS tickets
        ON tickets.event_id = events.event_id
       AND tickets.seat_id = seats.seat_id
    GROUP BY events.event_name, venues.venue_name
    ORDER BY paid_revenue DESC, events.event_name;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_CustomerValueDashboard
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        customers.full_name,
        customers.loyalty_tier,
        COUNT(DISTINCT bookings.booking_id) AS total_bookings,
        COUNT(DISTINCT CASE WHEN bookings.booking_status = 'CANCELLED' THEN bookings.booking_id END) AS cancelled_bookings,
        SUM(CASE WHEN payments.payment_status = 'PAID' THEN payments.amount_paid ELSE 0 END) AS total_paid,
        SUM(CASE WHEN refunds.refund_id IS NOT NULL THEN refunds.refund_amount ELSE 0 END) AS total_refunded
    FROM dbo.customers AS customers
    LEFT JOIN dbo.bookings AS bookings
        ON bookings.customer_id = customers.customer_id
    LEFT JOIN dbo.payments AS payments
        ON payments.booking_id = bookings.booking_id
    LEFT JOIN dbo.refund_transactions AS refunds
        ON refunds.payment_id = payments.payment_id
    GROUP BY customers.full_name, customers.loyalty_tier
    ORDER BY total_paid DESC, customers.full_name;
END;
GO

SELECT
    events.event_name,
    sections.section_name,
    COUNT(*) AS available_seats
FROM dbo.events AS events
INNER JOIN dbo.seats AS seats
    ON seats.venue_id = events.venue_id
INNER JOIN dbo.seat_sections AS sections
    ON sections.section_id = seats.section_id
LEFT JOIN dbo.tickets AS tickets
    ON tickets.event_id = events.event_id
   AND tickets.seat_id = seats.seat_id
   AND tickets.ticket_status IN ('RESERVED', 'PAID')
WHERE events.event_id = 1
  AND tickets.ticket_id IS NULL
GROUP BY events.event_name, sections.section_name
ORDER BY sections.section_name;

SELECT
    events.event_name,
    COUNT(tickets.ticket_id) AS tickets_issued,
    SUM(CASE WHEN tickets.ticket_status = 'PAID' THEN tickets.ticket_price ELSE 0 END) AS paid_revenue
FROM dbo.events AS events
LEFT JOIN dbo.tickets AS tickets
    ON tickets.event_id = events.event_id
GROUP BY events.event_name
ORDER BY paid_revenue DESC;

SELECT
    customers.full_name,
    events.event_name,
    bookings.booking_reference,
    bookings.booking_status,
    SUM(tickets.ticket_price) AS booking_value
FROM dbo.bookings AS bookings
INNER JOIN dbo.customers AS customers
    ON customers.customer_id = bookings.customer_id
INNER JOIN dbo.events AS events
    ON events.event_id = bookings.event_id
INNER JOIN dbo.tickets AS tickets
    ON tickets.booking_id = bookings.booking_id
GROUP BY
    customers.full_name,
    events.event_name,
    bookings.booking_reference,
    bookings.booking_status
ORDER BY customers.full_name, events.event_name;

EXEC dbo.usp_EventSalesDashboard;

EXEC dbo.usp_CustomerValueDashboard;

EXEC dbo.usp_CreateSeatBooking
    @EventID = 1,
    @CustomerID = 4,
    @SeatID = 3;

EXEC dbo.usp_RecordBookingPayment
    @BookingID = 2,
    @PaymentMethod = 'Mobile Money';

EXEC dbo.usp_CancelBookingAndRefund
    @BookingID = 4,
    @ProcessedBy = 'boxoffice.kumba',
    @RefundReason = 'Headline speaker cancellation.';

EXEC dbo.usp_EventSalesDashboard;

EXEC dbo.usp_CustomerValueDashboard;
GO
