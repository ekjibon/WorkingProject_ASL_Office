/****** Object:  StoredProcedure [dbo].[ProccessMainExam]    Script Date: 7/22/2017 4:28:51 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetUserBranchDetailByUserId]'))
BEGIN
DROP PROCEDURE  GetUserBranchDetailByUserId
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [dbo].[GetUserBranchDetailByUserId] '66529a39-6640-41e7-85b8-4841209120c6'
CREATE PROCEDURE [dbo].[GetUserBranchDetailByUserId] 
	@UserId varchar(150)
AS
BEGIN
SELECT u.Id, emp.FullName, b.* from dbo.AspNetUsers u
inner join dbo.Emp_BasicInfo emp on emp.EmpID=u.UserName
inner join dbo.Ins_Branch b on b.BranchId=emp.BranchID
where u.Id=@UserId 

END
  ---update [scpsc_new_db].[dbo].[AspNetUsers] set EmpId=70 where FullName='Developer'
-----GetTeacherSubjectForMarksEntry '861fdfe7-5906-4d6e-917d-772b8b61a082'