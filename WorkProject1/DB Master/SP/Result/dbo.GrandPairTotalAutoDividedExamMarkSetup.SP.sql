GO
/****** Object:  StoredProcedure [dbo].[PairTotalAutoSubExamMarkSetup]    Script Date: 03/08/2017 4:06:56 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GrandPairTotalAutoDividedExamMarkSetup]'))
BEGIN
DROP PROCEDURE  GrandPairTotalAutoDividedExamMarkSetup
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROC GrandPairTotalAutoDividedExamMarkSetup
 (
  @SubExamMarkSetupId INT,
  @DividedExamId INT,
  @DividedExamType NVARCHAR(50),
  @DividedExamFullMarks DECIMAL(8,2),
  @DividedExamExamMarks DECIMAL(8,2),
  @AddBy NVARCHAR(128)
  )
  AS
  BEGIN
  DECLARE @VersionId INT, @SessionId INT, @ClassId INT, @GroupId INT, @MainExamId INT, @FirstSubID INT, @SecondSubID INT
  DECLARE @MainExamMarkSetupId INT, @SubExamId INT, @PairSubjectSubExamMarkSetupId INT
  DECLARE @SecondDivFullMark DECIMAL(8,2)=0,  @SecondDivExamMark DECIMAL(8,2)=0
  --DECLARE @MainExamMarkSetupId INT=72,@SubExamId INT=114, @SubExamFullMarks INT=10, @SubExamExamMarks INT=50, @AddBy NVARCHAR(128)='shahin'
  DECLARE @PairSubjectMainExamMarkSetupId INT,@FirstMainExamMarkSetupID INT, @SecondMainExamMarkSetupID INT
  DECLARE @FirstSubExamMarkSetupID INT,  @SecondSubExamMarkSetupID INT
  DECLARE @SubjectID int, @PairSubjectID INT
  SELECT @MainExamMarkSetupId=GrandExamMarkSetupId, @SubExamId=SubExamId FROM Res_GrandSubExamMarkSetup WHERE GrandSubExamMarkSetupId=@SubExamMarkSetupId

  SELECT @SubjectID=M.ExamSubjectID
  , @VersionId=M.VersionId
  , @SessionId=M.SessionId
  , @ClassId=M.ClassId,
  @GroupId=M.GroupId
  , @MainExamId=M.GrandExamId FROM dbo.Res_GrandExamMarkSetup AS M WHERE M.GrandExamMarkSetupId=@MainExamMarkSetupId

  SELECT @PairSubjectID=S.SubID, @FirstSubID=S.FirstPairSubID, @SecondSubID=S.SecondPairSubID FROM Res_SubjectSetup AS S WHERE 
  (S.FirstPairSubID =@SubjectID OR S.SecondPairSubID=@SubjectID) AND S.FirstPairSubID!=0 AND S.SecondPairSubID!=0

  SELECT @PairSubjectMainExamMarkSetupId=M.GrandExamMarkSetupId FROM dbo.Res_GrandExamMarkSetup AS M WHERE M.ExamSubjectID=@PairSubjectID
  AND M.VersionId=@VersionId AND M.SessionId=@SessionId AND M.ClassId=@ClassId AND M.GroupId=@GroupId AND M.GrandExamId=@MainExamId

   SELECT @PairSubjectSubExamMarkSetupId=GrandSubExamMarkSetupId FROM Res_GrandSubExamMarkSetup WHERE GrandExamMarkSetupId=@PairSubjectMainExamMarkSetupId AND SubExamId=@SubExamId

  --SELECT @PairSubjectID,@PairSubjectMainExamMarkSetupId
  IF EXISTS(SELECT * FROM Res_GrandDividedExamMarkSetup WHERE SubExamMarkSetupId=@PairSubjectSubExamMarkSetupId AND DividedExamId=@DividedExamId AND IsDeleted=0 )
  BEGIN
  SELECT @FirstMainExamMarkSetupID=M.GrandExamMarkSetupId FROM dbo.Res_GrandExamMarkSetup AS M WHERE M.ExamSubjectID=@FirstSubID
  AND M.VersionId=@VersionId AND M.SessionId=@SessionId AND M.ClassId=@ClassId AND M.GroupId=@GroupId AND M.GrandExamId=@MainExamId

  SELECT @FirstSubExamMarkSetupID=GrandSubExamMarkSetupId FROM Res_GrandSubExamMarkSetup WHERE GrandExamMarkSetupId=@FirstMainExamMarkSetupID AND SubExamId=@SubExamId

  SELECT @SecondMainExamMarkSetupID=M.GrandExamMarkSetupId FROM dbo.Res_GrandExamMarkSetup AS M WHERE M.ExamSubjectID=@SecondSubID
  AND M.VersionId=@VersionId AND M.SessionId=@SessionId AND M.ClassId=@ClassId AND M.GroupId=@GroupId AND M.GrandExamId=@MainExamId

  SELECT @SecondSubExamMarkSetupID=GrandSubExamMarkSetupId FROM Res_GrandSubExamMarkSetup WHERE GrandExamMarkSetupId=@SecondMainExamMarkSetupID AND SubExamId=@SubExamId

  IF(@SubExamMarkSetupId=@FirstSubExamMarkSetupID)
  BEGIN

  SELECT @SecondDivFullMark=ISNULL(DividedExamFullMarks,0), @SecondDivExamMark=ISNULL(DividedExamExamMarks,0) FROM Res_GrandDividedExamMarkSetup
  WHERE SubExamMarkSetupId=@SecondSubExamMarkSetupID AND DividedExamId=@DividedExamId AND IsDeleted=0

  UPDATE Res_GrandDividedExamMarkSetup SET DividedExamFullMarks=(@SecondDivFullMark+@DividedExamFullMarks),
  --DividedExamDefaultPercent=((@SecondDivExamMark+@DividedExamExamMarks)*DividedExamPassMarks)/100,
  DividedExamExamMarks=(@SecondDivExamMark+@DividedExamExamMarks), UpdateBy=@AddBy, UpdateDate=GETDATE()
  WHERE SubExamMarkSetupId=@PairSubjectSubExamMarkSetupId AND DividedExamId=@DividedExamId AND IsDeleted=0  

  END
  ELSE IF(@SubExamMarkSetupId=@SecondSubExamMarkSetupID)
  BEGIN

  SELECT @SecondDivFullMark=ISNULL(DividedExamFullMarks,0), @SecondDivExamMark=ISNULL(DividedExamExamMarks,0) FROM Res_GrandDividedExamMarkSetup
  WHERE SubExamMarkSetupId=@FirstSubExamMarkSetupID AND DividedExamId=@DividedExamId AND IsDeleted=0

  UPDATE Res_GrandDividedExamMarkSetup SET DividedExamFullMarks=(@SecondDivFullMark+@DividedExamFullMarks),
  --DividedExamDefaultPercent=((@SecondDivExamMark+@DividedExamExamMarks)*DividedExamPassMarks)/100,
  DividedExamExamMarks=(@SecondDivExamMark+@DividedExamExamMarks), UpdateBy=@AddBy, UpdateDate=GETDATE()
  WHERE SubExamMarkSetupId=@PairSubjectSubExamMarkSetupId AND DividedExamId=@DividedExamId AND IsDeleted=0  
  END
  END
  ELSE
  BEGIN
  INSERT INTO Res_GrandDividedExamMarkSetup
       (
	   SubExamMarkSetupId
      ,DividedExamId
      ,DividedExamType
      ,DividedExamFullMarks
	  ,DividedExamExamMarks
      ,DividedExamIsPassDepend
      ,DividedExamPassMarks
      ,DividedExamPassMarkIsPercent
      --,DividedExamDefaultPercent
      ,IsDeleted
      ,AddBy
      ,AddDate  
	  ,[Status]   
      ,DividedExamIsEnable
	  )VALUES(@PairSubjectSubExamMarkSetupId,@DividedExamId,@DividedExamType,@DividedExamFullMarks,@DividedExamExamMarks,0,0,0,0,@AddBy,GETDATE(),'A',0)
	  END
  END


  -- @SubExamMarkSetupId INT,
  --@DividedExamId INT,
  --@DividedExamType NVARCHAR(50),
  --@DividedExamFullMarks DECIMAL(8,2),
  --@DividedExamExamMarks DECIMAL(8,2),
  --@AddBy NVARCHAR(128)
 -- PairTotalAutoDividedExamMarkSetup 219,7,'O',10,10,'a'