IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetMenuEmployee]'))
BEGIN
DROP PROCEDURE  [GetMenuEmployee]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[GetMenuEmployee]   -- [GetMenuEmployee] '42fc56ac-fa90-49e8-a61b-105dc1a020ca'
(
 @UserId Varchar(MAX)
)	
AS
BEGIN
	DECLARE @EmpId INT , @IsClsTeacher BIT, @IsSubTeacher BIT,@IsHeadTecaher BIT,@IsCoordinator BIT
	SELECT @EmpId = EmpId from dbo.AspNetUsers where Id =@UserId
	Print @EmpId

	SELECT @IsClsTeacher = ISNULL(eb.IsClassTeacher,0) FROM dbo.Emp_BasicInfo eb WHERE EmpBasicInfoID =@EmpId

	SELECT @IsSubTeacher = ISNULL(( CASE WHEN COUNT(TeacherID)>0 THEN 1 ELSE 0 END),0)  FROM Res_AssignSubjectsToTeacher  WHERE TeacherID = @EmpId

	Select @IsHeadTecaher =  ISNULL(( CASE WHEN COUNT(EmpBasicInfoID)>0 THEN 1 ELSE 0 END),0) FROM dbo.Emp_BasicInfo eb WHERE EmpBasicInfoID =@EmpId AND DesignationID = 10

	Select @IsCoordinator =  ISNULL(( CASE WHEN COUNT(EmpBasicInfoID)>0 THEN 1 ELSE 0 END),0) FROM dbo.Emp_BasicInfo eb WHERE EmpBasicInfoID =@EmpId AND DesignationID = 8

	SELECT @IsClsTeacher  AS IsClsTeacher, @IsSubTeacher AS IsSubTeacher ,@IsHeadTecaher  AS IsHeadTecaher,@IsCoordinator AS IsCoordinator

	--Select * FROM Emp_Designation
END

 
