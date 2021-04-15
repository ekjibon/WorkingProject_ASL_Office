/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MoneyReceiptGenerate]'))
BEGIN
DROP FUNCTION  MoneyReceiptGenerate
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Khaled>
-- Create date: <3-mar-2020,>
CREATE FUNCTION [dbo].[MoneyReceiptGenerate]
(
)
RETURNS  VARCHAR(MAX)
AS
BEGIN
	DECLARE @MoneyRecp VARCHAR(MAX) = NULL,@FCMID VARCHAR(MAX),@Year VARCHAR(50),@Month VARCHAR(50),@Day VARCHAR(50)
	SELECT TOP(1)  @FCMID = Id+1 FROM dbo.Fees_CollectionMaster
			 ORDER BY Id DESC	

		SELECT  @FCMID  =   REPLICATE('0', 6 - LEN(@FCMID)) + CAST(@FCMID AS varchar)

			 SET @Year  = SUBSTRING(CAST(YEAR(GETDATE()) AS VARCHAR(5)),3,3)
			 SET @Month  = CAST(Month(GETDATE()) AS VARCHAR(5))
			 SET @Day  = CAST(DAY(GETDATE()) AS VARCHAR(5))
			SET @MoneyRecp = @Year + @Month + @Day + @FCMID;


	RETURN @MoneyRecp 

END
GO

/*
SELECT * FROM Fees_CollectionMaster

SELECT [dbo].[MoneyReceiptGenerate]()
*/