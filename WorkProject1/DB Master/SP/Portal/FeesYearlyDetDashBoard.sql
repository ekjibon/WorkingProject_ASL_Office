IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FeesYearlyDetDashBoard]'))
BEGIN
DROP PROCEDURE  FeesYearlyDetDashBoard
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec FeesYearlyDetDashBoard 4901

CREATE PROCEDURE [dbo].[FeesYearlyDetDashBoard] 

	(
	@IID INT
	)
	
AS
BEGIN

 --   execute FeesYearlyDetDashBoard 33414
 
	BEGIN

	SELECT      
		sb.StudentIID, sb.StudentInsID, sb.FullName,
		
		--ISNULL((select Sum(DueAmount) from Fees_Student where  StudentIID=@IID and MonthId<(F.MonthId-1) AND IsDeleted = 0),0) As PreviousDue,
		 
		--sum(F.DueAmount) as DueAmount,
		
		--sum(F.TotalAmount) as TotalAmount,
		--sum(F.PaidAmount) as PaidAmount, 
		--sum(F.AdvanceAmount) as AdvanceAmount,
		--sum(F.DiscountAmount) as DiscountAmount,
			(CASE WHEN 
     (SELECT SUM(CD.Amount) FROM Fees_CollectionMaster FC 
     INNER JOIN Fees_CollectionDetails CD ON  CD.MasterID = FC.Id
     WHERE FC.StudentIID = F.StudentIID AND Year(BankCollectionDate)= Year(GETDATE()) AND Month(BankCollectionDate)= F.MonthId AND CD.MonthId =F.MonthId AND CD.Year=Year(GETDATE()))>0 THEN SUM(TotalAmount) 
     ELSE 0 END) as DueAmount,
		ISNULL((SELECT SUM(CD.Amount) FROM Fees_CollectionMaster FC 
     INNER JOIN Fees_CollectionDetails CD ON  CD.MasterID = FC.Id
     WHERE FC.StudentIID = F.StudentIID AND Year(BankCollectionDate)= Year(GETDATE()) AND Month(BankCollectionDate)= (F.MonthId) AND CD.MonthId <(F.MonthId) AND CD.Year=Year(GETDATE())),0) As PreviousDue,		 
		(ISNULL((SELECT SUM(CD.Amount) FROM Fees_CollectionMaster FC 
     INNER JOIN Fees_CollectionDetails CD ON  CD.MasterID = FC.Id
     WHERE FC.StudentIID = F.StudentIID AND Year(BankCollectionDate)= Year(GETDATE()) AND Month(BankCollectionDate)= (F.MonthId) AND CD.MonthId <(F.MonthId) AND CD.Year=Year(GETDATE())),0)+(CASE WHEN 
     (SELECT SUM(CD.Amount) FROM Fees_CollectionMaster FC 
     INNER JOIN Fees_CollectionDetails CD ON  CD.MasterID = FC.Id
     WHERE FC.StudentIID = F.StudentIID AND Year(BankCollectionDate)= Year(GETDATE()) AND Month(BankCollectionDate)= F.MonthId AND CD.MonthId =F.MonthId AND CD.Year=Year(GETDATE()))>0 THEN SUM(TotalAmount-ScholarshipAmount) 
     ELSE 0 END)) as TotalAmount,

		ISNULL((SELECT SUM(FC.ReceivedAmount) FROM Fees_CollectionMaster FC 
         WHERE FC.StudentIID = F.StudentIID AND Year(BankCollectionDate)= Year(GETDATE()) AND Month(BankCollectionDate)= F.MonthId),0) as  PaidAmount, 
		(ISNULL((SELECT SUM(FC.ReceivedAmount) FROM Fees_CollectionMaster FC 
         WHERE FC.StudentIID = F.StudentIID AND Year(BankCollectionDate)= Year(GETDATE()) AND Month(BankCollectionDate)= F.MonthId),0)-(CASE WHEN 
        (SELECT SUM(CD.Amount) FROM Fees_CollectionMaster FC 
         INNER JOIN Fees_CollectionDetails CD ON  CD.MasterID = FC.Id
         WHERE FC.StudentIID = F.StudentIID AND Year(BankCollectionDate)= Year(GETDATE()) AND Month(BankCollectionDate)= F.MonthId AND CD.MonthId =F.MonthId AND CD.Year=Year(GETDATE()))>0 THEN SUM(TotalAmount-ScholarshipAmount) 
         ELSE 0 END)) as AdvanceAmount,
		CM.MonthName,
		F.Year 
	--	,F.MonthId
		
	FROM               
    
        dbo.Student_BasicInfo sb  INNER JOIN
        dbo.Ins_Session s ON sb.SessionId = s.SessionId INNER JOIN
        dbo.Ins_Branch b ON sb.BranchID = b.BranchId INNER JOIN
        dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId INNER JOIN
        dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId INNER JOIN
       
		dbo.Ins_Section sc ON sc.SectionId = sb.SectionId INNER JOIN
		dbo.Ins_StudentType stutype ON stutype.StudentTypeId = sb.StudentTypeId INNER JOIN
		dbo.Fees_Student F ON F.StudentIID = sb.StudentIID INNER JOIN
		dbo.Fees_Head FH ON FH.FeesHeadId = F.HeadId
		INNER JOIN [dbo].[Fees_FeesMonth] CM ON CM.FeesMonthId = F.MonthId
			WHERE 			
		F.StudentIID = @IID AND
			sb.IsDeleted=0  AND F.IsDeleted = 0
			 
			AND F.PaidAmount <> 0 AND  sb.[Status] = 'A' 
			
		Group By sb.StudentIID, sb.StudentInsID, sb.FullName,CM.MonthName,F.Year,F.MonthId,F.StudentIID
		Order by F.MonthId DESC

		


	END

 END