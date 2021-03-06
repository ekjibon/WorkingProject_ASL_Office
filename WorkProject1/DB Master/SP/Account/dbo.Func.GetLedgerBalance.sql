/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetLedgerBalance]'))
BEGIN
DROP FUNCTION  GetLedgerBalance
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- SELECT dbo.GetLedgerBalance(50,1002,'Opening')

CREATE FUNCTION [dbo].[GetLedgerBalance]
(	
	@LedgerId INT,
	@FisCalId INT,
	@AmtType VARCHAR(10)
)
RETURNS  DECIMAL(18,2)
AS
BEGIN
	DECLARE @Value DECIMAL(18,2) ,@StartDate  DATETIME, @EndDate DATETIME

	SELECT @StartDate = StartDate , @EndDate = EndDate FROM ACC_FiscalYear WHERE Id = @FisCalId

	IF(@AmtType='Opening')
	BEGIN
		SELECT @Value = OpenningBalance FROM ACC_Ledgers WHERE LedgerId= @LedgerId
	END




	RETURN @Value

END


GO
