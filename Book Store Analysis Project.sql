CREATE DATABASE OnlineBookstore;

USE OnlineBookstore;
--Added Flat CSV Files--

select * from books;
select * from customers;
select * from orders;

--Q1-Fiction Books-
SELECT * FROM Books
WHERE Genre = 'Fiction';

--Q2-Books After 1950-
SELECT * FROM Books
WHERE Published_Year > 1950;

---Q3-Customers from Canada-
SELECT * FROM Customers
WHERE Country = 'Canada';


--Q4-Orders in Nov 2023-
SELECT * FROM Orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

--Q5-Total Stock-
SELECT SUM(Stock) AS Total_Stock
FROM Books;

--Q6-Most Expensive Book-
SELECT TOP 1 *
FROM Books
ORDER BY Price DESC;

--Q7-Customers Ordering More Than 1 Quantity-
SELECT *
FROM Orders
WHERE Quantity > 1;

--Q8-Orders Over $20-
SELECT *
FROM Orders
WHERE Total_Amount > 20;

--Q9-Distinct Genres-
SELECT DISTINCT Genre
FROM Books;

--Q10-Lowest Stock Book-
SELECT TOP 1 *
FROM Books
ORDER BY Stock ASC;

--Q11-Total Revenue-
SELECT SUM(Total_Amount) AS Revenue
FROM Orders;





/* Advance Questions Solved */


--Q1-Total Books Sold per Genre-
SELECT b.Genre, SUM(o.Quantity) AS Total_Books_Sold
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Genre;

--Q2-Average Price of Fantasy Books-
SELECT AVG(Price) AS Average_Price
FROM Books
WHERE Genre = 'Fantasy';

--Q3-Customers with at Least 2 Orders-
SELECT o.Customer_ID, c.Name, COUNT(o.Order_ID) AS Order_Count
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY o.Customer_ID, c.Name
HAVING COUNT(o.Order_ID) >= 2;

--Q4-Most Frequently Ordered Book-
SELECT TOP 1 o.Book_ID, b.Title, COUNT(o.Order_ID) AS Order_Count
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY o.Book_ID, b.Title
ORDER BY Order_Count DESC;


--Q5-Top 3 Most Expensive Fantasy Books-
SELECT TOP 3 *
FROM Books
WHERE Genre = 'Fantasy'
ORDER BY Price DESC;

--Q6-Total Quantity Sold per Author-
SELECT b.Author, SUM(o.Quantity) AS Total_Books_Sold
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Author;

--Q7-Cities of Customers Who Spent Over $30-
SELECT DISTINCT c.City
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
WHERE o.Total_Amount > 30;

--Q8-Customer Who Spent the Most-
SELECT TOP 1 c.Customer_ID, c.Name, SUM(o.Total_Amount) AS Total_Spent
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Name
ORDER BY Total_Spent DESC;


--Q9-Stock Remaining After Orders-
SELECT 
    b.Book_ID,
    b.Title,
    b.Stock AS Initial_Stock,
    COALESCE(SUM(o.Quantity), 0) AS Ordered_Quantity,
    b.Stock - COALESCE(SUM(o.Quantity), 0) AS Remaining_Quantity
FROM Books b
LEFT JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title, b.Stock
ORDER BY b.Book_ID;



/* Most Advanced Analysis  */


--1) Find the top 5 customers who spent the most overall-
SELECT TOP 5 
    c.Customer_ID,
    c.Name,
    SUM(o.Total_Amount) AS Total_Spent
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Name
ORDER BY Total_Spent DESC;


--2) Find monthly sales revenue (Month-wise breakup)
SELECT 
    FORMAT(Order_Date, 'yyyy-MM') AS Month,
    SUM(Total_Amount) AS Revenue
FROM Orders
GROUP BY FORMAT(Order_Date, 'yyyy-MM')
ORDER BY Month;

--3) Find the best-selling genre (most quantity sold)
SELECT TOP 1 
    b.Genre,
    SUM(o.Quantity) AS Total_Sold
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Genre
ORDER BY Total_Sold DESC;

--4) Find average order value (AOV)
SELECT 
    AVG(Total_Amount) AS Average_Order_Value
FROM Orders;


--5) Book that generated the highest revenue
SELECT TOP 1 
    b.Title,
    SUM(o.Total_Amount) AS Revenue
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Title
ORDER BY Revenue DESC;


--6) Customers who never placed any order
SELECT *
FROM Customers
WHERE Customer_ID NOT IN (SELECT Customer_ID FROM Orders);

--7) Books that have never been ordered (Dead Stock)
SELECT *
FROM Books
WHERE Book_ID NOT IN (SELECT Book_ID FROM Orders);


--8) Top 3 customers with highest number of orders
SELECT TOP 3 
    c.Name,
    COUNT(o.Order_ID) AS Order_Count
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Name
ORDER BY Order_Count DESC;


--9) Calculate reorder recommendation (critical stock < 10)
SELECT 
    Book_ID,
    Title,
    Stock,
    CASE WHEN Stock < 10 THEN 'REORDER REQUIRED'
         ELSE 'STOCK OK' END AS Status
FROM Books;


--10) Running Total of Revenue (WINDOW FUNCTION)
SELECT 
    Order_ID,
    Order_Date,
    Total_Amount,
    SUM(Total_Amount) OVER (ORDER BY Order_Date) AS Running_Revenue
FROM Orders
ORDER BY Order_Date;

--11) Rank customers by spending (RANK / DENSE_RANK)
SELECT 
    c.Name,
    SUM(o.Total_Amount) AS Total_Spent,
    RANK() OVER (ORDER BY SUM(o.Total_Amount) DESC) AS Spend_Rank
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Name;

--12) Find the most recent order of each customer
SELECT 
    c.Customer_ID,
    c.Name,
    MAX(o.Order_Date) AS Last_Order
FROM Customers c
LEFT JOIN Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Name;


--13) Find customers who buy only "Fiction" books
SELECT DISTINCT c.Name
FROM Customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
JOIN Books b ON o.Book_ID = b.Book_ID
WHERE c.Customer_ID NOT IN (
    SELECT o2.Customer_ID
    FROM Orders o2
    JOIN Books b2 ON o2.Book_ID = b2.Book_ID
    WHERE b2.Genre <> 'Fiction'
);



--14) Find average quantity sold per genre
SELECT 
    b.Genre,
    AVG(o.Quantity) AS Avg_Qty
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Genre;


--15) Find orders where quantity is higher than the average quantity
SELECT *
FROM Orders
WHERE Quantity > (SELECT AVG(Quantity) FROM Orders);


--16) Total revenue city-wise
SELECT 
    c.City,
    SUM(o.Total_Amount) AS Revenue
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.City
ORDER BY Revenue DESC;

--17) Customer Lifetime Value (CLV)
SELECT 
    c.Customer_ID,
    c.Name,
    SUM(o.Total_Amount) AS Lifetime_Value
FROM Customers c
LEFT JOIN Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Name;


--18) Books ordered more than the stock available (Over-demand check)
SELECT 
    b.Title,
    b.Stock,
    SUM(o.Quantity) AS Ordered
FROM Books b
JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Title, b.Stock
HAVING SUM(o.Quantity) > b.Stock;


--19) Customer who bought the most different genres
SELECT TOP 1 
    c.Name,
    COUNT(DISTINCT b.Genre) AS Genre_Count
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY c.Name
ORDER BY Genre_Count DESC;


--20) Identify duplicate customers (same email id)
SELECT Email, COUNT(*) AS Count_Duplicate
FROM Customers
GROUP BY Email
HAVING COUNT(*) > 1;

--21) Find orders placed on weekends
SELECT *
FROM Orders
WHERE DATENAME(WEEKDAY, Order_Date) IN ('Saturday','Sunday');

--22) Compute total books sold & revenue per author
SELECT 
    b.Author,
    SUM(o.Quantity) AS Books_Sold,
    SUM(o.Total_Amount) AS Revenue
FROM Books b
JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Author
ORDER BY Revenue DESC;

--23) Most purchased book each month (Advanced Window Query)
WITH MonthlySales AS (
    SELECT 
        FORMAT(o.Order_Date, 'yyyy-MM') AS Month,
        b.Title,
        SUM(o.Quantity) AS Qty,
        RANK() OVER (PARTITION BY FORMAT(o.Order_Date,'yyyy-MM')
                     ORDER BY SUM(o.Quantity) DESC) AS rnk
    FROM Orders o
    JOIN Books b ON o.Book_ID = b.Book_ID
    GROUP BY FORMAT(o.Order_Date,'yyyy-MM'), b.Title
)
SELECT * 
FROM MonthlySales
WHERE rnk = 1;


--24) Find books whose price is above the average price of their genre
SELECT 
    b.*
FROM Books b
WHERE Price > (
    SELECT AVG(Price) 
    FROM Books b2 
    WHERE b2.Genre = b.Genre
);


--25) Detect possible fraudulent customers (orders on same day multiple times)
SELECT 
    Customer_ID,
    Order_Date,
    COUNT(*) AS Order_Count
FROM Orders
GROUP BY Customer_ID, Order_Date
HAVING COUNT(*) >= 2;


--26) Calculate order fulfillment rate
SELECT 
    SUM(CASE WHEN Quantity <= Stock THEN 1 END) * 100.0 / COUNT(*) 
        AS Fulfillment_Rate_Percentage
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID;



