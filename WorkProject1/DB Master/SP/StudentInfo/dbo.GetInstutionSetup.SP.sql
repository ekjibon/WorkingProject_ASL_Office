/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetInstutionSetup]'))
BEGIN
DROP PROCEDURE  GetInstutionSetup
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetInstutionSetup] 
	@VersionId INT,
	@SessionId INT,
	@BranchID INT,
	@ShiftID INT ,
	@ClassId INT,
	@GroupId INT,
	@SectionId INT,
	@SubjectID INT,
	@MainExamId INT,
	@SubExamId INT--,
--	@DividedExamId INT
AS
BEGIN
	
	DECLARE @VersionName VARCHAR(50),@SessionName VARCHAR(50),@BranchName VARCHAR(50),@ShiftName VARCHAR(50),@ClassName VARCHAR(50),@GroupName VARCHAR(50),
	@SectionName VARCHAR(50), @SubjectName VARCHAR(50),@MainExamName VARCHAR(50),@SubExamName VARCHAR(50),@DividedExamName VARCHAR(50)

	SELECT @VersionName = VersionName FROM Ins_Version WHERE VersionId =  @VersionId
	SELECT @SessionName= SessionName FROM Ins_Session WHERE SessionId = @SessionId
	SELECT @BranchName= BranchName FROM Ins_Branch WHERE BranchId = @BranchID	
	SELECT @ShiftName = ShiftName FROM Ins_Shift WHERE ShiftId = @ShiftID	
	SELECT @ClassName = ClassName FROM Ins_ClassInfo WHERE ClassId = @ClassId	
	SELECT @GroupName= GroupName FROM Ins_Group WHERE GroupId = @GroupId
	SELECT @SectionName= SectionName FROM Ins_Section WHERE SectionId = @SectionId
	SELECT @SubjectName= SubjectName FROM Res_SubjectSetup WHERE SubID = @SubjectID 	
	SELECT @MainExamName= MainExamName FROM Res_MainExam WHERE MainExamId = @MainExamId
	SELECT @SubExamName= SubExamName FROM Res_SubExam WHERE SubExamId = @SubExamId
--	SELECT @DividedExamName= DividedExamName FROM Res_DividedExam WHERE DividedExamId = @DividedExamId 	


	SELECT @VersionName AS VersionName 
	, @SessionName AS SessionName
	, @BranchName AS BranchName
	, @ShiftName AS ShiftName
	, @ClassName AS ClassName
	, @GroupName AS GroupName
	, @SectionName AS SectionName
	, @SubjectName AS SubjectName
	, @MainExamName AS MainExamName
	, @SubExamName AS SubExamName
	, @DividedExamName AS DividedExamName

END	

--- GetInstutionSetup 1,5,1,1,5,0,108,144,3,113
