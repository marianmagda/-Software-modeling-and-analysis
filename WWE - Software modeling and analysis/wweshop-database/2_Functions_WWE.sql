﻿-- 1. Функция за получаване на средна оценка за продукт
CREATE FUNCTION PRODUCT_AVERAGE_RATING(@PRODUCT_ID INT) RETURNS VARCHAR(200)
AS
BEGIN
    DECLARE @PRODUCT_NAME VARCHAR(100), @AVG_RATING NUMERIC(3,2)
    SELECT @PRODUCT_NAME = PRODUCT_NAME, @AVG_RATING = AVG(RATING)
    FROM PRODUCT P
    JOIN PRODUCT_REVIEW R ON P.PRODUCT_ID = R.PRODUCT_ID
    WHERE P.PRODUCT_ID = @PRODUCT_ID
    GROUP BY P.PRODUCT_ID, PRODUCT_NAME
    RETURN @PRODUCT_NAME + ' (ID = ' + CAST(@PRODUCT_ID AS VARCHAR) + '), average rating: ' + CAST(@AVG_RATING AS VARCHAR) + '.'
END;

-- Употреба
SELECT DBO.PRODUCT_AVERAGE_RATING(PRODUCT_ID) AS PRODUCT_AVERAGE_RATING_RESULT
FROM PRODUCT;

-- 2. Функция за получаване на общия брой поръчки по клиент

CREATE FUNCTION SUBJECT_AVERAGE_GRADE(@SUBJ_ID INT) RETURNS VARCHAR(200)
AS
BEGIN
DECLARE @SUBJ_NAME VARCHAR(50), @AVG_GRADE NUMERIC(3,2)
SELECT @SUBJ_NAME = SUBJECT_NAME, @AVG_GRADE = AVG(GRADE_VALUE)
FROM GRADE G JOIN [SUBJECT] S
ON G.SUBJECT_ID = S.SUBJECT_ID
WHERE S.SUBJECT_ID = @SUBJ_ID
GROUP BY S.SUBJECT_ID, SUBJECT_NAME
RETURN @SUBJ_NAME + ' (ID = ' + CAST(@SUBJ_ID AS VARCHAR) + '), среден успех: ' + CAST(@AVG_GRADE AS VARCHAR) + '.'
END

SELECT DBO.SUBJECT_AVERAGE_GRADE(SUBJECT_ID) AS SUBJECT_AVERAGE_GRADE_RESULT
FROM [SUBJECT]


-- 3. Функция за получаване на обща наличност за категория

CREATE FUNCTION CATEGORY_TOTAL_STOCK(@CATEGORY_ID INT) RETURNS VARCHAR(200)
AS
BEGIN
    DECLARE @CATEGORY_NAME VARCHAR(50), @TOTAL_STOCK INT
    SELECT @CATEGORY_NAME = CATEGORY_NAME, @TOTAL_STOCK = SUM(STOCK)
    FROM CATEGORY C
    JOIN PRODUCT P ON C.CATEGORY_ID = P.CATEGORY_ID
    WHERE C.CATEGORY_ID = @CATEGORY_ID
    GROUP BY C.CATEGORY_ID, CATEGORY_NAME
    RETURN @CATEGORY_NAME + ' (ID = ' + CAST(@CATEGORY_ID AS VARCHAR) + '), total stock: ' + CAST(@TOTAL_STOCK AS VARCHAR) + '.'
END;

-- Употреба
SELECT DBO.CATEGORY_TOTAL_STOCK(CATEGORY_ID) AS CATEGORY_TOTAL_STOCK_RESULT
FROM CATEGORY;


-- 4. Функция за получаване на общи продажби за продукт
CREATE FUNCTION PRODUCT_TOTAL_SALES(@PRODUCT_ID INT) RETURNS VARCHAR(200)
AS
BEGIN
    DECLARE @PRODUCT_NAME VARCHAR(100), @TOTAL_SALES DECIMAL(10,2)
    SELECT @PRODUCT_NAME = PRODUCT_NAME, @TOTAL_SALES = SUM(QUANTITY * UNIT_PRICE)
    FROM PRODUCT P
    JOIN ORDER_ITEM OI ON P.PRODUCT_ID = OI.PRODUCT_ID
    WHERE P.PRODUCT_ID = @PRODUCT_ID
    GROUP BY P.PRODUCT_ID, PRODUCT_NAME
    RETURN @PRODUCT_NAME + ' (ID = ' + CAST(@PRODUCT_ID AS VARCHAR) + '), total sales: $' + CAST(@TOTAL_SALES AS VARCHAR) + '.'
END;

-- Употреба
SELECT DBO.PRODUCT_TOTAL_SALES(PRODUCT_ID) AS PRODUCT_TOTAL_SALES_RESULT
FROM PRODUCT;


-- 5. Функция за получаване на всички продукти и категории в магазина

CREATE FUNCTION PRODUCTS_IN_CATEGORY() RETURNS TABLE
AS
RETURN
    SELECT P.PRODUCT_NAME, P.PRICE, C.CATEGORY_NAME
    FROM PRODUCT P
    JOIN CATEGORY C ON P.CATEGORY_ID = C.CATEGORY_ID;

-- Употреба
SELECT * FROM DBO.PRODUCTS_IN_CATEGORY() ORDER BY CATEGORY_NAME, PRODUCT_NAME;
