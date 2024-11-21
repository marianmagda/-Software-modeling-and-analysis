-- 1. Задействане за актуализиране на наличността при поставяне на поръчка
CREATE TRIGGER TRG_UPDATE_STOCK
ON ORDER_ITEM
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

	-- Намалете наличността в таблицата ПРОДУКТ
    UPDATE PRODUCT
    SET STOCK = STOCK - I.QUANTITY
    FROM INSERTED I
    WHERE PRODUCT.PRODUCT_ID = I.PRODUCT_ID;
END;


-- 2. Задействане за връщане на склад при анулиране на поръчка
CREATE TRIGGER TRG_REVERT_STOCK_ON_CANCEL
ON ORDER_HEADER
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(STATUS)
    BEGIN
        DECLARE @ORDER_ID INT;

        SELECT @ORDER_ID = ORDER_ID FROM INSERTED WHERE STATUS = 'Canceled';

        IF @ORDER_ID IS NOT NULL
        BEGIN
            UPDATE PRODUCT
            SET STOCK = STOCK + OI.QUANTITY
            FROM ORDER_ITEM OI
            WHERE OI.ORDER_ID = @ORDER_ID AND PRODUCT.PRODUCT_ID = OI.PRODUCT_ID;
        END
    END
END;
