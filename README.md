# OnlineBookstore-SQL-Project
“Built a full-scale Online Bookstore database in SQL Server, leveraging advanced SQL queries, joins, aggregations, and window functions to analyze sales, track customers, optimize inventory, and deliver actionable business insights.”





- **Advanced JOINs:** Mastered INNER, LEFT, and RIGHT JOINs to seamlessly link Books, Customers, and Orders.
- **Aggregations & Reporting:** Leveraged SUM, COUNT, AVG with GROUP BY to track sales, revenue, and average pricing.
- **Window Functions:** Applied RANK(), DENSE_RANK(), and SUM() OVER() for top customers, bestsellers, and running totals.
- **Conditional Logic:** Used CASE statements to monitor stock levels and trigger reorder recommendations.
- **Subqueries & Nested Queries:** Identified genre-exclusive buyers and flagged anomalous customer behavior.
- **Filtering & Analytics:** Utilized WHERE, HAVING, DISTINCT, TOP, and ORDER BY for precise business insights.
- **Inventory & Fulfillment Tracking:** Calculated remaining stock, fulfillment rates, and critical reorder needs.
- **Fraud Detection:** Detected duplicate customers and multiple same-day orders to ensure data integrity.
- **Temporal Analysis:** Analyzed monthly trends and weekend orders using FORMAT() and DATENAME().
- **Data Import & Management:** Efficiently loaded large CSV datasets using BULK INSERT / COPY.
- **Genre & Author Insights:** Measured genre-wise sales, author revenue, and customer preferences.
- **Performance Optimization:** Enhanced query efficiency with COALESCE(), TOP, and indexing strategies.
  
**Additional Features Implemented**

**Views:**

-vw_BookSales: Calculates total sales and revenue per book.

-vw_CustomerSpending: Tracks total spending per customer.

**Stored Procedures:**

-sp_GetOrdersByCustomer: Fetches all orders for a specific customer, including book details and order dates.

**CTEs (Common Table Expressions):**

-Example: Identifying top 5 bestselling books with total quantity sold.
