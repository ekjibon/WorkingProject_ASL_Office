IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FeesDuePaymentTotal]'))
BEGIN
DROP PROCEDURE  FeesDuePaymentTotal
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec FeesDuePaymentTotal 4834

CREATE PROCEDURE [dbo].FeesDuePaymentTotal 

	(
	@IID INT
	)
	
AS
BEGIN
	SELECT        
	sum(F.DueAmount) as DueAmount
		
	FROM     
	dbo.Student_BasicInfo sb INNER JOIN
	dbo.Fees_Student F ON F.StudentIID = sb.StudentIID 
		
	WHERE 			
	F.StudentIID = @IID AND
	sb.IsDeleted=0  AND F.IsDeleted = 0
	AND F.DueAmount > 0 AND  sb.[Status] = 'A'  AND   datefromparts(Year,MonthId, 1) <= EOMONTH(datefromparts(Year(GETDATE()),Month(GETDATE()), 1))
	Group By sb.StudentIID, sb.StudentInsID
	
END