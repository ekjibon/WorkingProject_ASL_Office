GO
/****** Object:  StoredProcedure [dbo].[PairTotalAutoSubExamMarkSetup]    Script Date: 03/08/2017 4:06:56 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GrandPairTotalAutoSubExamMarkSetup]'))
BEGIN
DROP PROCEDURE  GrandPairTotalAutoSubExamMarkSetup
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROC GrandPairTotalAutoSubExamMarkSetup
 (
  @MainExamMarkSetupId INT,
  @SubExamId INT,
  @SubExamFullMarks DECIMAL(8,2),
  @SubExamExamMarks DECIMAL(8,2),
  @AddBy NVARCHAR(128)
  )
  AS
  BEGIN
  DECLARE @VersionId INT, @SessionId INT, @ClassId INT, @GroupId INT, @MainExamId INT, @FirstSubID INT, @SecondSubID INT
  DECLARE @SecondSubFullMark DECIMAL(8,2)=0,  @SecondSubExamMark DECIMAL(8,2)=0
  --DECLARE @MainExamMarkSetupId INT=72,@SubExamId INT=114, @SubExamFullMarks INT=10, @SubExamExamMarks INT=50, @AddBy NVARCHAR(128)='shahin'
  DECLARE @PairSubjectMainExamMarkSetupId INT,@FirstMainExamMarkSetupID INT, @SecondMainExamMarkSetupID INT
  DECLARE @SubjectID int, @PairSubjectID INT

  SELECT @SubjectID=M.ExamSubjectID, @VersionId=M.VersionId, @SessionId=M.SessionId, @ClassId=M.ClassId,
  @GroupId=M.GroupId, @MainExamId=M.GrandExamId FROM dbo.Res_GrandExamMarkSetup AS M WHERE M.GrandExamMarkSetupId=@MainExamMarkSetupId

  SELECT @PairSubjectID=S.SubID, @FirstSubID=S.FirstPairSubID, @SecondSubID=S.SecondPairSubID FROM Res_SubjectSetup AS S WHERE 
  (S.FirstPairSubID =@SubjectID OR S.SecondPairSubID=@SubjectID) AND S.FirstPairSubID!=0 AND S.SecondPairSubID!=0

  SELECT @PairSubjectMainExamMarkSetupId=M.GrandExamMarkSetupId FROM dbo.Res_GrandExamMarkSetup AS M WHERE M.ExamSubjectID=@PairSubjectID
  AND M.VersionId=@VersionId AND M.SessionId=@SessionId AND M.ClassId=@ClassId AND M.GroupId=@GroupId AND M.GrandExamId=@MainExamId

  --SELECT @PairSubjectID,@PairSubjectMainExamMarkSetupId
  IF EXISTS(SELECT * FROM Res_GrandSubExamMarkSetup WHERE GrandExamMarkSetupId=@PairSubjectMainExamMarkSetupId AND SubExamId=@SubExamId AND IsDeleted=0 )
  BEGIN
  SELECT @FirstMainExamMarkSetupID=M.GrandExamMarkSetupId FROM dbo.Res_GrandExamMarkSetup AS M WHERE M.ExamSubjectID=@FirstSubID
  AND M.VersionId=@VersionId AND M.SessionId=@SessionId AND M.ClassId=@ClassId AND M.GroupId=@GroupId AND M.GrandExamId=@MainExamId

  SELECT @SecondMainExamMarkSetupID=M.GrandExamMarkSetupId FROM dbo.Res_GrandExamMarkSetup AS M WHERE M.ExamSubjectID=@SecondSubID
  AND M.VersionId=@VersionId AND M.SessionId=@SessionId AND M.ClassId=@ClassId AND M.GroupId=@GroupId AND M.GrandExamId=@MainExamId
  IF(@FirstMainExamMarkSetupID=@MainExamMarkSetupId)
  BEGIN

  SELECT @SecondSubFullMark=SubExamFullMarks, @SecondSubExamMark=SubExamExamMarks FROM Res_GrandSubExamMarkSetup
  WHERE GrandExamMarkSetupId=@SecondMainExamMarkSetupID AND SubExamId=@SubExamId AND IsDeleted=0
 -- IF(@SecondSubFullMark IS NULL)
	--BEGIN
	--	 SET @SecondSubFullMark=0
	--END
 -- IF(@SecondSubExamMark IS NULL)
 --   BEGIN
	--	 SET @SecondSubExamMark=0
	--END
  UPDATE Res_GrandSubExamMarkSetup SET SubExamFullMarks=(@SubExamFullMarks+@SecondSubFullMark),
  SubExamExamMarks=(@SecondSubExamMark+@SubExamExamMarks), UpdateBy=@AddBy, UpdateDate=GETDATE()
  WHERE GrandExamMarkSetupId=@PairSubjectMainExamMarkSetupId AND SubExamId=@SubExamId AND IsDeleted=0  

  END
  ELSE IF(@SecondMainExamMarkSetupID=@MainExamMarkSetupId)
  BEGIN  
  SELECT @SecondSubFullMark=SubExamFullMarks, @SecondSubExamMark=SubExamExamMarks FROM Res_GrandSubExamMarkSetup
  WHERE GrandExamMarkSetupId=@FirstMainExamMarkSetupID AND SubExamId=@SubExamId AND IsDeleted=0
 -- IF(@SecondSubFullMark IS NULL)
	--BEGIN
	--	 SET @SecondSubFullMark=0
	--END
 -- IF(@SecondSubExamMark IS NULL)
 --   BEGIN
	--	 SET @SecondSubExamMark=0
	--END
  UPDATE Res_GrandSubExamMarkSetup SET SubExamFullMarks=(@SubExamFullMarks+@SecondSubFullMark),  
  SubExamExamMarks=(@SecondSubExamMark+@SubExamExamMarks), UpdateBy=@AddBy, UpdateDate=GETDATE()
  WHERE GrandExamMarkSetupId=@PairSubjectMainExamMarkSetupId AND SubExamId=@SubExamId AND IsDeleted=0  

  END

  END
  ELSE
  BEGIN
  INSERT INTO Res_GrandSubExamMarkSetup
       (
	   GrandExamMarkSetupId
      ,SubExamId
      ,SubExamFullMarks
      ,SubExamExamMarks
      ,SubExamIsPassDepend
      ,SubExamPassMark
      ,SubExamPassMarkIsPercent      
      ,IsDeleted
      ,AddBy
      ,AddDate  
	  ,[Status]   
      ,SubExamIsEnable
	  )VALUES(@PairSubjectMainExamMarkSetupId,@SubExamId,@SubExamFullMarks,@SubExamExamMarks,0,0,0,0,@AddBy,GETDATE(),'A',0)
	  END
  END
