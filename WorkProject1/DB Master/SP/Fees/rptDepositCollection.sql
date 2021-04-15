
/****** Object:  StoredProcedure [dbo].[GetStudentInfoByFilter]    Script Date: 7/22/2017 4:15:28 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptDepositCollection]'))
BEGIN
DROP PROCEDURE  rptDepositCollection
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
---[dbo].rptDepositCollection  8,'20,22' 
Create PROCEDURE [dbo].rptDepositCollection 
	@BranchID INT =null ,
	@ClassId VARCHAR(1000) =null

AS
BEGIN

    SELECT distinct CM.StudentIID, s.SessionName ,b.BranchName ,sh.ShiftName ,c.ClassName ,sc.SectionName,
		 cast(sb.RollNo AS INT) RollNo, sb.StudentInsID, sb.FullName, SB.AdmissionDate,			
		 SUM(CM.ReceiveAmount) As CollAmnt,CM.DepositAmont,CM.Installment,CM.InstallmentAmount
		FROM [dbo].[Fees_SecurityDepositDetails] CM 	 		
		INNER JOIN dbo.Student_BasicInfo sb ON sb.StudentIID = CM.StudentIID
		
		 left outer join dbo.Ins_Session s ON sb.SessionId = s.SessionId
		 left outer join dbo.Ins_Branch b ON sb.BranchID = b.BranchId
		 left outer join dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId
		 left outer join dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId
		
		 left outer join dbo.Ins_Section sc ON sc.SectionId = sb.SectionId

		 WHERE SB.BranchID = @BranchID AND SB.ClassId IN (SELECT * FROM STRING_SPLIT(@ClassId,','))

		 GROUP BY CM.StudentIID, s.SessionName ,b.BranchName ,sh.ShiftName ,c.ClassName ,sc.SectionName,
		 sb.StudentIID,sb.RollNo, sb.StudentInsID, sb.FullName,CM.DepositAmont,CM.Installment,CM.InstallmentAmount,SB.AdmissionDate	
END


