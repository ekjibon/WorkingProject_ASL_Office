-- =============================================
-- Author:		Azmal
-- Create date: 2020-05-19
-- Description:	
-- =============================================
-- EXEC SP_RPTStudentAdvancePayment 8,11,21
ALTER PROC SP_RPTStudentAdvancePayment
(
@BranchId INT=0,
@SessionId INT=0,
@ClassId INT=0
)
AS
BEGIN
		SELECT FM.studentIId, sb.StudentInsID, sb.FullName,case when b.BranchName='CGSD Primary' then 'Primary Campus' else 'Secondary Campus' end BranchName  ,
		c.ClassName, SUM(FM.AdvanceAmount)AdvanceAmount
		FROM Fees_Student FM 
		INNER JOIN dbo.Student_BasicInfo sb ON sb.StudentIID = FM.studentIId
		 left outer join dbo.Ins_Session s ON sb.SessionId = s.SessionId
		 left outer join dbo.Ins_Branch b ON sb.BranchID = b.BranchId
		 left outer join dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId
		 WHERE FM.AdvanceAmount>0 AND FM.IsDeleted=0
		 AND sb.BranchID=@BranchId AND s.SessionId=@SessionId AND sb.ClassId=@ClassId
		 GROUP BY FM.studentIId,sb.StudentInsID, sb.FullName,b.BranchName,c.ClassName
		 ORDER BY sb.FullName
		
END