USE DUMMY_DATABASE
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
SET @column = 'dummy'
SET @type = 'nvarchar(4)'

INSERT INTO @tables (id, table_name)
VALUES 
	 (1, 'dbo.dummy_table_1')
	,(2, 'dbo.dummy_table_2')
	,(3, 'dbo.dummy_table_3');

WHILE @counter <= (SELECT MAX(id) FROM @tables)
	BEGIN TRY
		PRINT @counter
		SET @script = CONCAT('ALTER TABLE ', (SELECT table_name FROM @tables WHERE id = @counter), ' ADD ', @column, ' ', @type, ';')
		--SET @script = CONCAT('ALTER TABLE ', (SELECT table_name FROM @tables WHERE id = @counter), ' DROP COLUMN ', @column, ';')
		PRINT @script
		--EXECUTE (@script)
		PRINT 'DONE'
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