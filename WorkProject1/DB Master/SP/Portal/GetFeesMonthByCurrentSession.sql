IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetFeesMonthByCurrentSession]'))
BEGIN
DROP PROCEDURE  GetFeesMonthByCurrentSession
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE GetFeesMonthByCurrentSession
( 
	@IID INT
)
	
AS
BEGIN 

 --   execute GetFeesMonthByCurrentSession 12
 


	SELECT
	      FSY.MonthId  		 	 		   
		 ,CM.MonthName 
		 ,FSY.Year 
		 ,FSY.FeesSessionYearId
	
	
	FROM             
         dbo.Fees_FeesSessionYear FSY 
		INNER JOIN [dbo].[Fees_FeesMonth] CM ON CM.FeesMonthId = FSY.MonthId
	  
		WHERE FSY.FeesFiscalSessionId = @IID --AND datefromparts(Year,FSY.MonthId, 1) <= EOMONTH(datefromparts(Year(GETDATE()),Month(GETDATE()), 1))
	 
		


 END




