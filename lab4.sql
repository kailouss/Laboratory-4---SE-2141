/////////////////////////////////////////////////////////////////////////////////////////////////////

CREATE TABLE IF NOT EXISTS Books (
    isbn VARCHAR(17) UNIQUE PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    genre VARCHAR(100) NOT NULL,
    published_year INT NOT NULL,
    quantity_available INT NOT NULL CHECK (quantity_available >= 0)
);

/////////////////////////////////////////////////////////////////////////////////////////////////////

CREATE TABLE IF NOT EXISTS Users (
    id SERIAL UNIQUE PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email_address VARCHAR(255) UNIQUE NOT NULL,
    membership_date DATE NOT NULL
);

/////////////////////////////////////////////////////////////////////////////////////////////////////

CREATE TABLE IF NOT EXISTS BookLoans (
    user_id INT NOT NULL,
    isbn VARCHAR(17) NOT NULL,
    loan_date DATE DEFAULT now() NOT NULL,
    return_date DATE DEFAULT now() + '30 days'::interval NOT NULL,
    status VARCHAR(20)DEFAULT 'borrowed' NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE,
    FOREIGN KEY (isbn) REFERENCES Books(isbn) ON DELETE CASCADE
);

/////////////////////////////////////////////////////////////////////////////////////////////////////

INSERT INTO Books (isbn, title, author, genre, published_year, quantity_available)
VALUES 
	('978-1-60309-502-0', 'Animal Stories', 'Maria Hoey', 'Comics', 2022, 3),
	('978-1-60309-517-4', 'Ashes', 'Álvaro Ortiz', 'Fiction', 2019, 8),
	('978-1-60309-442-9', 'Belzebubs', 'J.P. Ahonen', 'Comics', 2019, 6),
	('978-1-60309-542-6', 'Belzebubs (Vol 2): No Rest for the Wicked', 'J.P. Ahonen', 'Comics', 2022, 9),
	('978-1-60309-527-3', 'But You Have Friends', 'Hélène Becquelin', 'Graphic Novel', 2021, 5);

SELECT * FROM Books;

/////////////////////////////////////////////////////////////////////////////////////////////////////

INSERT INTO Users (full_name, email_address, membership_date) 
VALUES
	('Jose Suoberon', 'jose@example.com', '2024-10-02'),
	('Rofer Casio', 'rofer@example.com', '2024-09-21'),
	('Nicholae Sara', 'nich@example.com', '2024-11-11'),
	('Paul Ardiente', 'paul@example.com', '2024-12-25'),
	('Dainz Trasadas', 'dainz@example.com', '2024-09-11');

SELECT * FROM Users;

/////////////////////////////////////////////////////////////////////////////////////////////////////

INSERT INTO BookLoans (user_id, isbn, loan_date, return_date, status) 
VALUES
    (3, '978-1-60309-442-9', '2024-11-12', '2024-11-19', 'returned'),
    (4, '978-1-60309-542-6', '2024-12-09', '2025-01-02', 'borrowed'),
    (5, '978-1-60309-527-3', '2024-09-12', '2024-09-19', 'returned');


INSERT INTO BookLoans (user_id, isbn) 
VALUES
    (1, '978-1-60309-502-0'),
    (2, '978-1-60309-517-4');

SELECT * FROM BookLoans;

/////////////////////////////////////////////////////////////////////////////////////////////////////

-- '978-1-60309-502-0' quantity_available = 0
UPDATE Books
SET quantity_available = quantity_available - 1
WHERE ISBN = '978-1-60309-502-0';

SELECT quantity_available
FROM Books 
WHERE ISBN = '978-1-60309-502-0';

/////////////////////////////////////////////////////////////////////////////////////////////////////

SELECT * FROM BookLoans WHERE status = 'overdue';

/////////////////////////////////////////////////////////////////////////////////////////////////////

SELECT U.full_name, B.title, B.author, BL.loan_date, BL.return_date, BL.status, B.quantity_available
FROM BookLoans BL
JOIN Books B ON BL.isbn = B.isbn
JOIN Users U ON BL.user_id = U.id
WHERE U.id = 5;


/////////////////////////////////////////////////////////////////////////////////////////////////////

CREATE INDEX idx_return_date ON BookLoans(return_date);
CREATE INDEX idx_status ON BookLoans(status);

SELECT * FROM BookLoans WHERE return_date < CURRENT_DATE;


/////////////////////////////////////////////////////////////////////////////////////////////////////




