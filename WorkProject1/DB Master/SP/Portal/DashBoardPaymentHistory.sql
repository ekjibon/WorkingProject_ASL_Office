IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DashBoardPaymentHistory]'))
BEGIN
DROP PROCEDURE  DashBoardPaymentHistory
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec DashBoardPaymentHistory 14470

CREATE PROCEDURE DashBoardPaymentHistory 
	(
	@IID INT
	
	)
	
	
AS
BEGIN


 --   execute DashBoardPaymentHistory  39222


	
	BEGIN
			SELECT sb.StudentIID, 
			SB.StudentInsID,
			sb.FullName, 
		
			s.SessionName, 
			b.BranchName, 
			sh.ShiftName, 
			c.ClassName, 
		
			sc.SectionName, 
			Sb.FullName,
			sb.RollNo, 
			
	 
			sb.SessionId, 
			sb.BranchID, 
			sb.ShiftID, 
			sb.ClassId,
			FC.TotalAmount,
			FC.AddDate as BankCollectionDate,
			FC.TrxID,
			FM.MonthName,
			FC.MonthId,
			FC.Id,
			FC.PaymentType,
			 (CASE FC.PaymentType
			WHEN 1 THEN 'Cash'
			WHEN 2 THEN 'Cheque'
			WHEN 3 THEN 'Online Transfer'
			END) AS PType
			

	FROM  dbo.Student_BasicInfo sb  
			INNER JOIN dbo.Fees_CollectionMaster FC ON sb.StudentIID=FC.StudentIID			
			INNER JOIN dbo.Fees_FeesMonth FM 	ON FC.MonthId=FM.FeesMonthId
			INNER JOIN dbo.Ins_Session s ON sb.SessionId = s.SessionId 
			INNER JOIN dbo.Ins_Branch b ON sb.BranchID = b.BranchId 
			INNER JOIN dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId 
			INNER JOIN dbo.Ins_ClassInfo c	ON sb.ClassId = c.ClassId 
			INNER JOIN dbo.Ins_Section sc ON sc.SectionId = sb.SectionId 
			

	WHERE 	
			FC.StudentIID = @IID
		
			AND sb.IsDeleted = 0 
			
			AND sb.[Status] = 'A'

	
	ORDER  BY FC.Id DESC
	END
	
	

 END



 --select * from Fees_CollectionMaster