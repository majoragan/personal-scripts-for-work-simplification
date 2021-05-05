USE DM_EMEA_BIZ
GO

DECLARE @counter	INT
DECLARE @column		NVARCHAR(64)
DECLARE @type		NVARCHAR(32)
DECLARE @script		NVARCHAR(512)
DECLARE @tables		TABLE (
	id			INT NOT NULL UNIQUE,
	table_name	NVARCHAR(128)
)

SET @counter = 1
SET @column = 'overall_buy_index'
SET @type = 'NVARCHAR(4)'

INSERT INTO @tables (id, table_name)
VALUES 
	 (1, 'MSR.DIM_Customer_Nitrogen')
	,(2, 'MSR.DIM_Customer_Dedup')
	,(3, 'MSR.DIM_Customer_All_Levels')
	,(4, 'MSR.DIM_Customer')
	,(5, 'MS.DIM_Customer_All_Levels')
	,(6, 'MS.DIM_Customer')
	,(7, 'SH.DIM_Customer_All_Levels')
	,(8, 'SH.DIM_Customer');

WHILE @counter <= (SELECT MAX(id) FROM @tables)
	BEGIN TRY
		SET @script = CONCAT('ALTER TABLE ', (SELECT table_name FROM @tables WHERE id = @counter), ' ADD ', @column, ' ', @type, ';')
		--SET @script = CONCAT('ALTER TABLE ', (SELECT table_name FROM @tables WHERE id = @counter), ' DROP COLUMN ', @column, ';')
		EXECUTE (@script)
		RAISERROR(@script, 0, 1) WITH NOWAIT
		SET @counter += 1;
	END TRY
	BEGIN CATCH
		SELECT  
			 ERROR_NUMBER()		AS ErrorNumber  
			,ERROR_SEVERITY()	AS ErrorSeverity  
			,ERROR_STATE()		AS ErrorState  
			,ERROR_PROCEDURE()	AS ErrorProcedure  
			,ERROR_LINE()		AS ErrorLine  
			,ERROR_MESSAGE()	AS ErrorMessage;
		BREAK;
	END CATCH;
GO
