/****** Object:  StoredProcedure [dbo].[EDITGetAllMarks]    Script Date: 7/22/2017 3:57:47 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EDITGetAllMarks]'))
BEGIN
DROP PROCEDURE  EDITGetAllMarks
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
CREATE PROCEDURE [dbo].[EDITGetAllMarks] 
	@VersionId INT,
	@SessionId INT,
	@BranchID INT,
	@ShiftID INT ,
	@ClassId INT,
	@GroupId INT,
	@SectionId INT,
	@SubjectID INT,
	@MainExamId INT,
	@SubExamId INT,
	@DividedExamId INT
AS
BEGIN
	DECLARE @FullMarks DECIMAL = 0;	
	   SELECT
	    S.RollNo
	   ,S.StudentIID
	   ,S.FullName 
       ,ISNULL(M.[MarksId],0) AS [MarksId]
      ,@VersionId AS [VersionId]
      ,@SessionId AS [SessionId]
      ,@ShiftID AS [ShiftId]
      ,@ClassId AS [ClassId]
      ,@GroupId AS [GroupId]
      ,@SectionId AS [SectionId]
      ,S.[StudentIID]
      ,@MainExamId AS [MainExamID]
      ,@SubExamId AS [SubExamID]
      ,@DividedExamId AS [DividedExamID]
	  ,ISNULL(DS.Id,0)AS [DividedExamMarkSetupID]
      ,@SubjectID AS [SubjectID]
      ,ISNULL(M.[ObtainMarks],0)AS ObtainMarks
	  ,@FullMarks AS FullMarks
	   ,ISNULL(DS.DividedExamPassMarks,0) AS PassMark
      ,ISNULL(M.[ConvertedMarks_Abs],0) AS [ConvertedMarks_Abs]
      ,ISNULL(M.[ConvertedMarks_Ceiling],0) AS [ConvertedMarks_Ceiling]
      ,ISNULL(M.[ConvertedMarks_Floor],0) AS [ConvertedMarks_Floor]
      ,ISNULL(M.[IsPassDepended],0) AS [IsPassDepended]
      ,ISNULL(M.[IsPass],0) AS [IsPass]
      ,ISNULL(M.[IsAbsent],0) AS [IsAbsent]
      ,ISNULL(M.[IsDeleted],0) AS [IsDeleted]
      ,ISNULL(M.[AddBy],'') AS [AddBy]
      ,ISNULL(M.[AddDate],'') AS [AddDate]
      ,ISNULL(M.[UpdateBy],'') AS [UpdateBy]
      ,ISNULL(M.[UpdateDate],'') AS [UpdateDate]
      ,ISNULL(M.[Remarks],'') AS [Remarks]
      ,ISNULL(M.[Status],'') AS [Status]
      ,ISNULL(M.[ConvertedMarks_Round],0) AS [ConvertedMarks_Round]
      ,ISNULL(M.[ConvertedMarks],0) AS [ConvertedMarks]
      ,ISNULL(M.[ConvertedMarksFraction],0) AS [ConvertedMarksFraction]
      ,ISNULL(DE.[DividedExamType],'') AS [DividedExamType] FROM Student_BasicInfo S
	   LEFT OUTER JOIN [dbo].[Res_MainExamMarks] M ON M.StudentIID = S.StudentIID
	   AND M.SubjectID = @SubjectID INNER JOIN [dbo].[Res_DividedExam] DE
	   ON  DE.DividedExamId =  @DividedExamId
	   LEFT OUTER JOIN [dbo].[Res_DividedExamMarkSetup] AS DS ON DS.DividedExamId = @DividedExamId
	   WHERE S.VersionID =  @VersionId AND S.SessionId = @SessionId AND S.BranchID =  @BranchID 
	   AND S.ShiftID = @ShiftID AND S.ClassId = @ClassId AND S.GroupId = @GroupId 
	-- exec [EDITGetAllMarks] 2002,2012,1018,9,2011,1,1006,18,103,102,73
	
END
