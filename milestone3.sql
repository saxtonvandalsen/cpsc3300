-- 1. Creating tables for database
create table User (
    User_ID varchar(10) primary key,
    Username varchar(20),
    User_Password varchar(20) 
);

create table Book (
    Book_ID varchar(20) primary key,
    Book_Title varchar(60),
    Book_Description varchar(60),
    Book_Price varchar(10)
);

create table Publication (
    Publication_ID varchar(10) primary key,
    Publication_Date date,
	Book_ID VARCHAR(20),
    Author_ID VARCHAR(10),
    foreign key (Book_ID) references Book(Book_ID),
    foreign key (Author_ID) references Author(Author_ID)
);

create table Author (
    Author_ID varchar(10) primary key,
    Author_First_Name varchar(20),
    Author_Last_Name varchar(20),
    Author_Bio varchar(40)
);

create table Purchases (
    Publication_ID varchar(10),
    User_ID varchar(10),
    Price decimal(10, 2),
    Purchase_Date date,
    Purchase_Quantity int,
    PRIMARY KEY (Publication_ID, User_ID),
    FOREIGN KEY (Publication_ID) REFERENCES Publication(Publication_ID),
    FOREIGN KEY (User_ID) REFERENCES User(User_ID)
);

-- 2. inserting values into each table
insert into User (User_ID, Username, User_Password) values 
('User1', 'alice', 'password1'),
('User2', 'bob', 'password2'),
('User3', 'charlie', 'password3'),
('User4', 'david', 'password4'),
('User5', 'eve', 'password5'),
('User6', 'frank', 'password6'),
('User7', 'grace', 'password7'),
('User8', 'hank', 'password8'),
('User9', 'ivy', 'password9'),
('User10', 'jack', 'password10');

insert into Book (Book_ID, Book_Title, Book_Description, Book_Price) values
('978-3-16-148410-0', '1984', 'Dystopian novel by George Orwell.', '9.99'),
('978-0-596-52068-7', 'To Kill a Mockingbird', 'Classic novel by Harper Lee.', '12.50'),
('978-92-95055-02-5', 'The Great Gatsby', 'Novel by F. Scott Fitzgerald.', '10.99'),
('978-7-19-1704998-1', 'Moby Dick', 'Epic tale by Herman Melville.', '15.00'),
('978-3-16-791260-0', 'Pride and Prejudice', 'Romantic novel by Jane Austen.', '7.99'),
('978-1-86197-876-9', 'The Catcher in the Rye', 'Novel by J.D. Salinger.', '8.99'),
('978-0-306-40615-7', 'The Hobbit', 'Fantasy novel by J.R.R. Tolkien.', '14.50'),
('978-0-14-044913-6', 'Fahrenheit 451', 'Dystopian novel by Ray Bradbury.', '13.00'),
('978-1-4028-9462-6', 'Jane Eyre', 'Novel by Charlotte Bronte.', '11.75'),
('978-0-19-852663-3', 'Brave New World', 'Dystopian novel by Aldous Huxley.', '9.50');

INSERT INTO Author (Author_ID, Author_First_Name, Author_Last_Name, Author_Bio) VALUES
('Author1', 'George', 'Orwell', 'Author of 1984'),
('Author2', 'Harper', 'Lee', 'Author of To Kill a Mockingbird'),
('Author3', 'F. Scott', 'Fitzgerald', 'Author of The Great Gatsby'),
('Author4', 'Herman', 'Melville', 'Author of Moby Dick'),
('Author5', 'Jane', 'Austen', 'Author of Pride and Prejudice'),
('Author6', 'J.D.', 'Salinger', 'Author of The Catcher in the Rye'),
('Author7', 'J.R.R.', 'Tolkien', 'Author of The Hobbit'),
('Author8', 'Ray', 'Bradbury', 'Author of Fahrenheit 451'),
('Author9', 'Charlotte', 'Bronte', 'Author of Jane Eyre'),
('Author10', 'Aldous', 'Huxley', 'Author of Brave New World');

INSERT INTO Publication (Publication_ID, Publication_Date, Book_ID, Author_ID) VALUES
('P154', '1949-06-08', '978-3-16-148410-0', 'Author1'),
('P902', '1960-07-11', '978-0-596-52068-7', 'Author2'),
('P743', '1925-04-10', '978-92-95055-02-5', 'Author3'),
('P996', '1851-10-18', '978-7-19-1704998-1', 'Author4'),
('P115', '1813-01-28', '978-3-16-791260-0', 'Author5'),
('P023', '1951-07-16', '978-1-86197-876-9', 'Author6'),
('P724', '1937-09-21', '978-0-306-40615-7', 'Author7'),
('P865', '1953-10-19', '978-0-14-044913-6', 'Author8'),
('P109', '1847-10-16', '978-1-4028-9462-6', 'Author9'),
('P233', '1932-08-01', '978-0-19-852663-3', 'Author10');

INSERT INTO Purchases (Publication_ID, User_ID, Price, Purchase_Date, Purchase_Quantity) VALUES
('P109', 'User10', 9.99, '2023-09-21', '9'),
('P724', 'User2', 12.50, '2020-12-10', '6'),
('P865', 'User5', 10.99, '2024-01-01', '4'),
('P902', 'User5', 15.00, '2023-04-09', '2'),
('P996', 'User7', 7.99, '2023-05-27', '3'),
('P743', 'User3', 8.99, '2021-10-11', '11'),
('P154', 'User1', 14.50, '2022-07-10', '2'),
('P233', 'User2', 13.00, '2023-08-01', '5'),
('P115', 'User4', 11.75, '2021-09-15', '2'),
('P023', 'User1', 9.50, '2022-07-06', '3');

-- 3. Five different queries on the database
-- Query 1: This query retrieves details about purchases and the usernames of the users
-- who made those purchases
SELECT
    Purchases.Publication_ID,
    Purchases.User_ID,
    User.Username,
    Purchases.Price,
    Purchases.Purchase_Date,
    Purchases.Purchase_Quantity
FROM Purchases
INNER JOIN User ON Purchases.User_ID = User.User_ID;

-- Query 2: This query counts the number of books that were published before the year 1940
SELECT COUNT(*) AS NumBooksPublishedBefore1940
FROM Publication
WHERE Publication_Date < '1940-01-01';

-- Query 3: This query retrieves each of the users, if any, that have purchased more than 
-- 5 books
SELECT Username
FROM User
WHERE User_ID IN (
    SELECT User_ID
    FROM Purchases
    GROUP BY User_ID
    HAVING SUM(Purchase_Quantity) > 5
);

-- Query 4: This query finds the title of books that have been purchased by users
-- with the username 'alice'
SELECT Book_Title
FROM Book
WHERE Book_ID IN (
    SELECT Publication.Book_ID
    FROM Publication
    INNER JOIN Purchases ON Publication.Publication_ID = Purchases.Publication_ID
    INNER JOIN User ON Purchases.User_ID = User.User_ID
    WHERE User.Username = 'alice'
);

-- Query 5: This query retrieves average price of all books purchased after 2022.
SELECT avg(Price) AS AveragePriceBefore2022
FROM Purchases
WHERE Purchase_Date > '2022-12-31';