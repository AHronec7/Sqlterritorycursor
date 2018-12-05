 use adventureworks2012
GO 


DECLARE @TerritoryID int, @Name nvarchar(50),  
    @message varchar(80), @product nvarchar(50), @orderID int, @salesYTD money;

PRINT '-------- Vendor Products Report --------';  

DECLARE Territory_cursor CURSOR FOR   
SELECT TerritoryID, Name  
FROM sales.SalesTerritory st 
ORDER BY TerritoryID;  

OPEN Territory_cursor  

FETCH NEXT FROM Territory_cursor   
INTO @TerritoryID, @Name 

WHILE @@FETCH_STATUS = 0  
BEGIN  
    PRINT ' '  
    SELECT @message = '----- Products From Vendor: ' +   
        @Name  

    PRINT @message  

    -- Declare an inner cursor based     
    -- on vendor_id from the outer cursor.  

    DECLARE sales_cursor CURSOR FOR   
    SELECT   soh.SalesOrderID, soh.TerritoryID
    FROM Sales.SalesOrderHeader soh, sales.SalesPerson sp 
    WHERE soh.TerritoryID = sp.TerritoryID AND  
    sp.SalesLastYear = @orderID  -- Variable value from the outer cursor  

    OPEN sales_cursor  
    FETCH NEXT FROM sales_cursor INTO @salesYTD, @Name 

    IF @@FETCH_STATUS <> 0   
        PRINT '         <<None>>'       

    WHILE @@FETCH_STATUS = 0  
    BEGIN  

        SELECT @message = '         ' + @product 
        PRINT @message  
        FETCH NEXT FROM sales_cursor INTO @salesYTD, @Name 
        END  

    CLOSE sales_cursor  
    DEALLOCATE sales_cursor  
        -- Get the next vendor.  
    FETCH NEXT FROM Territory_cursor   
    INTO @TerritoryID , @Name  
END   
CLOSE Territory_cursor;  
DEALLOCATE Territory_cursor; 

