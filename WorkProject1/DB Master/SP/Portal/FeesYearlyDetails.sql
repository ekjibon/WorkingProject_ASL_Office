IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FeesYearlyDetails]'))
BEGIN
DROP PROCEDURE  FeesYearlyDetails
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec FeesYearlyDetails 4440

CREATE PROCEDURE [dbo].[FeesYearlyDetails] 

	(
	@IID INT
	)
	
AS
BEGIN

 --   execute FeesYearlyDetails 4440
 
	BEGIN
Select * from (
	SELECT DISTINCT  
	(CASE WHEN 
     (SELECT SUM(CD.Amount) FROM Fees_CollectionMaster FC 
     INNER JOIN Fees_CollectionDetails CD ON  CD.MasterID = FC.Id
     WHERE FC.StudentIID = F.StudentIID AND Year(BankCollectionDate)= Year(GETDATE()) AND Month(BankCollectionDate)= F.MonthId AND CD.MonthId =F.MonthId AND CD.Year=Year(GETDATE()))>0 THEN SUM(TotalAmount) 
     ELSE 0 END) as 'Current Due',
		ISNULL((SELECT SUM(CD.Amount) FROM Fees_CollectionMaster FC 
     INNER JOIN Fees_CollectionDetails CD ON  CD.MasterID = FC.Id
     WHERE FC.StudentIID = F.StudentIID AND Year(BankCollectionDate)= Year(GETDATE()) AND Month(BankCollectionDate)= (F.MonthId) AND CD.MonthId <(F.MonthId) AND CD.Year=Year(GETDATE())),0) As 'Previous Due',		 
		(ISNULL((SELECT SUM(CD.Amount) FROM Fees_CollectionMaster FC 
     INNER JOIN Fees_CollectionDetails CD ON  CD.MasterID = FC.Id
     WHERE FC.StudentIID = F.StudentIID AND Year(BankCollectionDate)= Year(GETDATE()) AND Month(BankCollectionDate)= (F.MonthId) AND CD.MonthId <(F.MonthId) AND CD.Year=Year(GETDATE())),0)+(CASE WHEN 
     (SELECT SUM(CD.Amount) FROM Fees_CollectionMaster FC 
     INNER JOIN Fees_CollectionDetails CD ON  CD.MasterID = FC.Id
     WHERE FC.StudentIID = F.StudentIID AND Year(BankCollectionDate)= Year(GETDATE()) AND Month(BankCollectionDate)= F.MonthId AND CD.MonthId =F.MonthId AND CD.Year=Year(GETDATE()))>0 THEN SUM(TotalAmount) 
     ELSE 0 END)) as 'Total Due',
	(SELECT SUM(FC.ReceivedAmount) FROM Fees_CollectionMaster FC 
         WHERE FC.StudentIID = F.StudentIID AND Year(BankCollectionDate)= Year(GETDATE()) AND Month(BankCollectionDate)= F.MonthId) as 'Total Paid', 
		((SELECT SUM(FC.ReceivedAmount) FROM Fees_CollectionMaster FC 
         WHERE FC.StudentIID = F.StudentIID AND Year(BankCollectionDate)= Year(GETDATE()) AND Month(BankCollectionDate)= F.MonthId)-(CASE WHEN 
        (SELECT SUM(CD.Amount) FROM Fees_CollectionMaster FC 
         INNER JOIN Fees_CollectionDetails CD ON  CD.MasterID = FC.Id
         WHERE FC.StudentIID = F.StudentIID AND Year(BankCollectionDate)= Year(GETDATE()) AND Month(BankCollectionDate)= F.MonthId AND CD.MonthId =F.MonthId AND CD.Year=Year(GETDATE()))>0 THEN SUM(TotalAmount) 
         ELSE 0 END) - (ISNULL((SELECT SUM(CD.Amount) FROM Fees_CollectionMaster FC 
     INNER JOIN Fees_CollectionDetails CD ON  CD.MasterID = FC.Id
     WHERE FC.StudentIID = F.StudentIID AND Year(BankCollectionDate)= Year(GETDATE()) AND Month(BankCollectionDate)= (F.MonthId) AND CD.MonthId <(F.MonthId) AND CD.Year=Year(GETDATE())),0))) as 'Advance Amount',
	
		CM.MonthName,
		F.Year 

	FROM               
		dbo.Fees_Student F 
		INNER JOIN
		dbo.Fees_Head FH ON FH.FeesHeadId = F.HeadId
		INNER JOIN [dbo].[Fees_FeesMonth] CM ON CM.FeesMonthId = F.MonthId
			WHERE 			
		     F.IsDeleted = 0 AND Year(F.AddDate) = Year(GETDATE())
			 AND PaidAmount <> 0		
			 AND F.StudentIID = @IID
			AND F.Year= Year(GETDATE())
		Group By CM.MonthName,F.Year,F.MonthId, F.StudentIID
		--Order by F.MonthId DESC

		) As Details

		UNPIVOT
(
       Details
       FOR Dt IN ( "Current Due","Previous Due", "Total Due", "Total Paid","Advance Amount" )
	  
) AS P
	
PIVOT
(
       
      SUM (Details )
	  For MonthName IN( January,February,March,April,May,June,July,August,September,October,November,December)
) AS P
 ORDER BY
  case Dt
  when 'Current Due' then 1
  when 'Previous Due' then 2
  when 'Total Due' then 3
  when 'Total Paid' then 4
  else 5
  end



			 
			
	END

 END