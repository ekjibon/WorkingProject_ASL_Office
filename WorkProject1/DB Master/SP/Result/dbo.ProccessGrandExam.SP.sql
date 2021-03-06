/****** Object:  StoredProcedure [dbo].[ProccessMainExam]    Script Date: 7/22/2017 4:28:51 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ProccessGrandExam]'))
BEGIN
DROP PROCEDURE  ProccessGrandExam
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO --- [ProccessGrandExam] 1,4,1,7,8,1
CREATE PROCEDURE [dbo].[ProccessGrandExam] 
    @VersionId int ,
	@SessionId int ,
	@ShiftId int,
	@ClassId int ,
	@MainExamId int,
	@GrandExamId int
AS
BEGIN
	
	DECLARE @DBname VARCHAR(100)
    set @DBname=(select DB_Name())

	/*marks Migration Rule */
DECLARE @BodyCalculationRule VARCHAR(1)
DECLARE @MainExamPercent decimal(8,0)=20
DECLARE @TotalPersentage  int=1

Select @BodyCalculationRule=MMS.BodyCalculationRule from [dbo].[Res_MarksMigratedSetup] MMS Where MMS.VersionID=@VersionId and MMS.SessionID=@SessionId and MMS.ClassID=@ClassId and MMS.IsDeleted=0
--Select @MainExamPercent=MainExamPercent from [dbo].[Res_GrandSetup] where [MainExamId]=@MainExamId and [GrandExamId]=@GrandExamId
/**/

CREATE TABLE #GrandResultMarksDetails(
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StudentIID] [bigint] NOT NULL,
	[SubjectID] [int] NOT NULL,
	[SubExamID] [int] NOT NULL
	)

INSERT INTO #GrandResultMarksDetails 
	SELECT M.[StudentIID],M.[SubjectID],M.[SubExamID] 
	 FROM [dbo].[Res_MEResultDetails] M 
	 INNER JOIN [dbo].[Student_BasicInfo] S ON S.[StudentIID] = M.[StudentIID] 
	 WHERE M.MainExamId=@MainExamId and S.ShiftId = @ShiftId and S.[Status]='A' 
	 --AND M.[StudentIID] = 1675 OR M.[StudentIID] = 1676
	-- AND M.SubjectID = 13
	-- and M.[SubjectID]<> 204 and M.[SubjectID]<>206 and M.[SubjectID]<>207 and M.[SubjectID]<> 220 and M.[SubjectID]<> 222 and M.[SubjectID]<> 223 and M.[SubjectID]<>247 and M.[SubjectID]<>255 and M.[SubjectID]<>264 and M.[SubjectID]<>271 and M.[SubjectID]<>280 and M.[SubjectID]<>287
     ORDER BY StudentIID
	 Print @@Rowcount

DECLARE @COUNTER INT, @MAXID INT 
DECLARE  @StudentIID INT, @SubjectID int , @SubExamID int

SET @COUNTER = 1
SELECT @MAXID = COUNT(*) FROM #GrandResultMarksDetails


--SELECT * FROM #GrandResultMarksDetails

WHILE (@COUNTER <= @MAXID)
BEGIN
	SELECT   @StudentIID =StudentIID, @SubExamID = SubExamID , @SubjectID = SubjectID 
	
		 FROM #GrandResultMarksDetails WHERE Id = @COUNTER

		-- SET @SubjectID = 6 --  For Testing 
			--SET @SubExamID = 32 --  For Testing 
		 Print ' Exec  ProccessGrandMarksDetails '+convert(varchar(500), @MainExamId)+' ,'+convert(varchar(500),@SubExamID)+','+convert(varchar(500),@SubjectID)+','+convert(varchar(500), @StudentIID)+','+convert(varchar(500), @GrandExamId)+','+ convert(varchar(500),@BodyCalculationRule)+','+convert(varchar(500),@TotalPersentage)+','+@DBname
	Exec  ProccessGrandMarksDetails @MainExamId ,@SubExamID,@SubjectID, @StudentIID, @GrandExamId, @BodyCalculationRule,@TotalPersentage,@DBname
	SET @COUNTER = @COUNTER +1
END



END



