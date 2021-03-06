/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CheckMainExamIsPass]'))
BEGIN
DROP FUNCTION  CheckMainExamIsPass
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Biplob>
-- Create date: <01-Jun-2017,>
-- Description:	<For Latter grade ad GP  Calculation>
-- =============================================
--[dbo].[CheckMainExamIsPass] 1,1,9,
CREATE FUNCTION [dbo].[CheckMainExamIsPass]
(
	@VersionID int,
	@SessionID int,
	@ClassID int,
	@Marks decimal(10,2),
	@SubId int,
	@MainExamId INT
)
RETURNS BIT
AS
BEGIN
	DECLARE @ISPass BIT=1 ,@MainExamIsPassDepend BIT,@SubjectFullMark DECIMAL(10,2),@SubjectPassMark DECIMAL(10,2),@MainExamPassMarkIsPercent bit,@DBname VARCHAR(100)

	SELECT @MainExamIsPassDepend = MainExamIsPassDepend ,@SubjectFullMark = MainExamFullMarks , @SubjectPassMark= MainExamPassMark,@MainExamPassMarkIsPercent= MainExamPassMarkIsPercent
	FROM [dbo].[Res_MainExamMarkSetup]
	 WHERE MainExamSubjectID = @SubId AND MainExamId = @MainExamId AND IsDeleted = 0
	-- GROUP BY MainExamId,MainExamFullMarks
	
	 set @DBname=(select DB_Name())
	 If(@DBname in ('sos_new_2018'))
	      BEGIN
		        --IF(@SubId IN (14,15,28,29,30,31))
				 --Set @FullMarks=@FullMarks-25
				 Set @SubjectFullMark=@SubjectFullMark/2
		  END
 IF(@MainExamIsPassDepend=1)
  BEGIN
	If(@MainExamPassMarkIsPercent=0)
	   Begin
			If(@Marks>=@SubjectPassMark)
			 set @ISPass=1
			Else
			 set @ISPass=0
		END	
    ELSE
	  BEGIN
		If(((100*@Marks)/@SubjectFullMark)>=@SubjectPassMark)
			 set @ISPass=1
			Else
			 set @ISPass=0		  
	  END
  END

  
RETURN @ISPass

END
GO
