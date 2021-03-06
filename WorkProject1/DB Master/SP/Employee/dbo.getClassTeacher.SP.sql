/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[getClassTeacher]'))
BEGIN
DROP PROCEDURE  [getClassTeacher]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kawsar
-- Create date: 
-- Description:	
-- =============================================
-- execute [dbo].[getClassTeacher] 2,1,1,1,1,1,1,'a',1,'k','',''
CREATE PROCEDURE [dbo].[getClassTeacher] 
@block int,
@SessionId int =null,
@BranchId int =null,
@ShfiftId int =null,
@ClassId int =null,
@SectionId int =null
AS
BEGIN

If(@block=1)
	Begin
		 select SL.*, Ss.SessionName,B.BranchName, S.ShiftName,C.ClassName,Se.SectionName, EB.FullName
		 from dbo.Emp_ClassTeacher SL 
		 Inner JOIN dbo.Ins_Session Ss ON Ss.SessionId= SL.SessionId
		 Inner JOIN dbo.Ins_Branch B ON B.BranchId= SL.BranchID
		 Inner JOIN dbo.Ins_Shift S ON s.ShiftId= SL.ShiftId 
		 Inner JOIN dbo.Ins_ClassInfo C ON C.ClassId= SL.ClassId 
		 Inner JOIN dbo.Ins_Section SE ON SE.SectionId= SL.SectionId 
		 Inner JOIN Emp_BasicInfo EB ON SL.TeacherId=EB.EmpBasicInfoID
		 where SL.IsDeleted=0 
	 End
 
 If(@block=2)
	Begin
		 select SL.*, Ss.SessionName,B.BranchName, S.ShiftName,C.ClassName,Se.SectionName, EB.FullName
		 from dbo.Emp_ClassTeacher SL 
		 Inner JOIN dbo.Ins_Session Ss ON Ss.SessionId= SL.SessionId
		 Inner JOIN dbo.Ins_Branch B ON B.BranchId= SL.BranchID
		 Inner JOIN dbo.Ins_Shift S ON s.ShiftId= SL.ShiftId 
		 Inner JOIN dbo.Ins_ClassInfo C ON C.ClassId= SL.ClassId 
		 Inner JOIN dbo.Ins_Section SE ON SE.SectionId= SL.SectionId 
		 Inner JOIN Emp_BasicInfo EB ON SL.TeacherId=EB.EmpBasicInfoID
		 where SL.IsDeleted=0 And SL.SessionId=@SessionId And SL.BranchId=@BranchId AND SL.ShiftId=@ShfiftId
		 And SL.ClassId=@ClassId  And SL.SectionId=@SectionId and SL.IsDeleted=0 
	 End
END



