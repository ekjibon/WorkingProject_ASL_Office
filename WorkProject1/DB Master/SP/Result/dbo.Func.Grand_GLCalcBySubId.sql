/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Grand_GLCalcBySubId]'))
BEGIN
DROP FUNCTION  Grand_GLCalcBySubId
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Biplob>
-- Create date: <01-Jun-2017,>

-- =============================================
CREATE FUNCTION [dbo].[Grand_GLCalcBySubId]
(
	@VersionID int,
	@SessionID int,
	@ClassID int,
	@Marks decimal(10,2),
	@SubId int,
	@GrandExamId INT,
	@TotalCalculatuonRule  Varchar(1)
	
)
RETURNS VARCHAR(5)
AS
BEGIN
	DECLARE @GL VARCHAR(5)='T' ,@FullMarks decimal(18,2),@DBname VARCHAR(100)
	SELECT @FullMarks = ExamFullMarks FROM [Res_GrandExamMarkSetup] WHERE ExamSubjectID = @SubId AND GrandExamId = @GrandExamId
	 
	 set @DBname=(select DB_Name())
		  If(@DBname in ('sshs_new_db_GRtest'))
	      BEGIN
		       DECLARE @CTFullMark decimal(10,2)=0

			   SELECT  @CTFullMark=QG.DividedExamFullMarks
			   FROM Qry_GrandMarkSetup QG
			   WHERE QG.GrandExamId = @GrandExamId  AND QG.DividedExamType = 'W1' AND QG.ExamSubjectID = @SubId AND QG.MIsDeleted=0 AND QG.SIsDeleted=0 AND QG.DIsDeleted=0
			  set @FullMarks=@FullMarks-@CTFullMark
		  END

	Select Top(1) @GL=GS.GL from  Res_GradingSystem  GS 
	where GS.VersionID=@VersionID and GS.SessionID=@SessionID and GS.ClassID=@ClassID 
	and GS.Marks_From<=dbo.ConvertMarks(((@Marks*100)/@FullMarks),@TotalCalculatuonRule) 
	and GS.Marks_To>=dbo.ConvertMarks(((@Marks*100)/@FullMarks),@TotalCalculatuonRule) and GS.IsDeleted=0 
	ORDER BY GS.Marks_To DESC
	RETURN  @GL 

END
GO


--select [dbo].[Grand_GLCalcBySubId] (1,6,7,49,59,93,'R')