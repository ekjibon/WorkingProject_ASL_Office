/****** Object:  StoredProcedure [dbo].[ProccessAllSubjectMarks]    Script Date: 7/22/2017 4:26:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ProccessGrandMarksDetails]'))
BEGIN
DROP PROCEDURE  ProccessGrandMarksDetails 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
--execute ProccessGrandMarksDetails 3,6,24,124,20,'R',20,'mghs_new_db'

CREATE PROCEDURE ProccessGrandMarksDetails  
	(
	@MainExamId int,
	@SubExamId int,
	@SubjectID int,
	@StudentIID int,
	@GrandExamId int,
	@BodyCalculationRule VARCHAR(1),
	@TotalPersentage int,
	@DBname VARCHAR(100)
	)
AS
BEGIN
DECLARE @WObt1 decimal(8,2)=0
            ,@WConv1 decimal(8,2)=0
			,@WFrac1 decimal(8,2)=0
			,@WIsPass1 bit =1
			, @WIsAbs1 bit =0
			, @WObt2 decimal(8,2)=0
			, @WConv2 decimal(8,2)=0
			, @WFrac2 decimal(8,2)=0
			, @WIsPass2 bit =1
			, @WIsAbs2 bit =0
			
			, @WObt3 decimal(8,2)=0
			, @WConv3 decimal(8,2)=0
			, @WFrac3 decimal(8,2)=0
			, @WIsPass3 bit =1
			, @WIsAbs3 bit =0
			
			, @SObt decimal(8,2)=0
			, @SConv decimal(8,2)=0
			, @SFrac decimal(8,2)=0
			, @SIsPass bit =1
			, @SIsAbs bit =0
			
			, @OObt decimal(8,2)=0
			, @OConv decimal(8,2)=0
			, @OFrac decimal(8,2)=0
			, @OIsPass bit =1
			, @OIsAbs bit =0
			
			, @PObt decimal(8,2)=0
			, @PConv decimal(8,2)=0
			, @PFrac decimal(8,2)=0
			, @PIsPass bit =1
			, @PIsAbs bit =0

			, @GWObt1 decimal(8,2)=0
			, @SGWObt1 decimal(8,2)=0
			, @GWConv1 decimal(8,2)=0
			, @SGWConv1 decimal(8,2)=0
			, @GWFrac1 decimal(8,2)=0
			, @GWIsPass1 bit =1
			, @GWIsAbs1 bit =0
			, @SGWIsAbs1 bit =0
			, @GWObt2 decimal(8,2)=0
			, @SGWObt2 decimal(8,2)=0
			, @GWConv2 decimal(8,2)=0
			, @SGWConv2 decimal(8,2)=0
			, @GWFrac2 decimal(8,2)=0
			, @GWIsPass2 bit =1
			, @GWIsAbs2 bit =0
			, @SGWIsAbs2 bit =0
			
			, @GWObt3 decimal(8,2)=0
			, @SGWObt3 decimal(8,2)=0
			, @GWConv3 decimal(8,2)=0
			, @SGWConv3 decimal(8,2)=0
			, @GWFrac3 decimal(8,2)=0
			, @GWIsPass3 bit =1
			, @GWIsAbs3 bit =0
			, @SGWIsAbs3 bit =0
			
			, @GSObt decimal(8,2)=0
			, @SGSObt decimal(8,2)=0
			, @GSConv decimal(8,2)=0
			, @SGSConv decimal(8,2)=0
			, @GSFrac decimal(8,2)=0
			, @GSIsPass bit =1
			, @GSIsAbs bit =0
			, @SGSIsAbs bit =0
			
			, @GOObt decimal(8,2)=0
			, @SGOObt decimal(8,2)=0
			, @GOConv decimal(8,2)=0
			, @SGOConv decimal(8,2)=0
			, @GOFrac decimal(8,2)=0
			, @GOIsPass bit =1
			, @GOIsAbs bit =0
			, @SGOIsAbs bit =0
			
			, @GPObt decimal(8,2)=0
			, @SGPObt decimal(8,2)=0
			, @GPConv decimal(8,2)=0
			, @SGPConv decimal(8,2)=0
			, @GPFrac decimal(8,2)=0
			, @GPIsPass bit =1
			, @GPIsAbs bit =0
			, @SGPIsAbs bit =0
			, @GSubExamOriginalTotalObt decimal(8,2)=0
			, @GSubExamTotalObt decimal(8,2)=0
			, @GSubExamTotalConv decimal(8,2)=0
			, @GSubExamTotalFrac decimal(8,2)=0
			, @GSubExamIsPass bit=1
            , @GSubExamIsAbsent bit=0
			
			, @GrandSubExamId int
			, @GrandDivExamID int
			, @GrandDivExamType nvarchar(max)=null
			, @GDivExamFullmarks decimal(8,2)=0
			, @GDivExamExammarks decimal(8,2)=0
			, @GSubExamMSetupID int
			, @GDivExamType VARCHAR(10)
			, @GDivIsPassDepENDed bit=0
			, @GDivPassIspercentage decimal(8,2)=0
			, @GDivPassMark decimal(8,2)=0
			, @GDivIsPass bit=1
			, @GDivConvertedMarks decimal(8,2)=0
			, @GPTotalSubjectID int
			, @GTDivIsPass bit=1 , @GMainExamResultID int
			, @GDividedExamMarkSetupID int
			, @GSubExamExamMark decimal(10,2)
			, @GSubExamFullMark decimal(10,2)
			, @GSubIsPassDepENDed bit
			, @GSubPassIspercentage bit
			, @GSubPassMark decimal(10,2)
			, @MainExamPercent decimal(20,14)=null
			, @NumberOfExam int=1
			, @SOPTotalObt decimal(10,2) = 0 
			, @SOPTotalConv decimal(10,2) = 0 
			, @SOPTotalFrac decimal(10,2) = 0 
			, @TSOPTotalObt decimal(10,2) = 0 
			, @TSOPTotalConv decimal(10,2) = 0 
			, @TSOPTotalFrac decimal(10,2) = 0 


		Create Table #Res_MEResultDetails
	(
	[MarksDetailsID] [int] IDENTITY(1,1) NOT NULL,
	[SubjectID] [int] NOT NULL,
	[MainExamId] [int] NOT NULL,
	[StudentIID] [bigint] NOT NULL,
	[SubExamId] [int] NOT NULL,
	[WrittenObt1] [float] NOT NULL,
	[WrittenConv1] [float] NOT NULL,
	[WrittenIsAbsent1] [bit] NOT NULL,
	[WrittenObt2] [decimal](8, 2) NOT NULL,
	[WrittenConv2] [float] NOT NULL,
	[WrittenIsAbsent2] [bit] NOT NULL,
	[WrittenObt3] [decimal](8, 2) NOT NULL,
	[WrittenConv3] [float] NOT NULL,
	[WrittenIsAbsent3] [bit] NOT NULL,
	[SubjectiveObt] [decimal](8, 2) NOT NULL,
	[SubjectiveConv] [decimal](8, 2) NOT NULL,
	[SubjectiveIsAbsent] [bit] NOT NULL,
	[ObjectiveObt] [decimal](8, 2) NOT NULL,
	[ObjectiveConv] [decimal](8, 2) NOT NULL,
	[ObjectiveIsAbsent] [bit] NOT NULL,
	[PracticalObt] [decimal](8, 2) NOT NULL,
	[PracticalConv] [decimal](8, 2) NOT NULL,
	[PracticalIsAbsent] [bit] NOT NULL
	)

	Insert Into #Res_MEResultDetails
	SELECT 
	[SubjectID],
	[MainExamId],
	[StudentIID],
	[SubExamId],
	[WrittenObt1],
	[WrittenConv1],
	[WrittenIsAbsent1],
	[WrittenObt2],
	[WrittenConv2],
	[WrittenIsAbsent2],
	[WrittenObt3],
	[WrittenConv3],
	[WrittenIsAbsent3],
	[SubjectiveObt] ,
	[SubjectiveConv] ,
	[SubjectiveIsAbsent],
	[ObjectiveObt],
	[ObjectiveConv],
	[ObjectiveIsAbsent] ,
	[PracticalObt],
	[PracticalConv],
	[PracticalIsAbsent] From Res_MEResultDetails where MainExamId=@MainExamId AND SubjectID=@SubjectID AND SubExamId=@SubExamId  AND StudentIID=@StudentIID


	Create table #Res_GrandConfig
	(
	[GrandConfigId] [int] IDENTITY(1,1) NOT NULL,
	[SubjectId] [int] NOT NULL,
	[MainExamId] [int] NOT NULL,
	[SubExamId] [int] NOT NULL,
	[DivExamId] [int] NOT NULL,
	[DivExamType] [nvarchar](max) NOT NULL,
	[GrandExamId] [int] NOT NULL,
	[GrandSubExamId] [int] NOT NULL,
	[GrandDivExamId] [int] NOT NULL,
	[GrandDivExamType] [nvarchar](max) NOT NULL,
	[DivExamPercentage] [decimal](10, 2) NOT NULL
	)

	insert into #Res_GrandConfig
	select [SubjectId] ,
	[MainExamId] ,
	[SubExamId] ,
	[DivExamId] ,
	[DivExamType] ,
	[GrandExamId] ,
	[GrandSubExamId] ,
	[GrandDivExamId] ,
	[GrandDivExamType] ,
	[DivExamPercentage] From Res_GrandConfig  Where [MainExamId]=@MainExamId AND [SubjectId]=@SubjectID AND [SubExamId]=@SubExamId and IsDeleted=0

Select top (1) @GrandSubExamID=GrandSubExamId From [dbo].[#Res_GrandConfig] Where [MainExamId]=@MainExamId AND [SubjectId]=@SubjectID AND [SubExamId]=@SubExamId
--print '@GrandSubExamID:' print @GrandSubExamID
--print '@@SubjectID:' print @SubjectID
--print '@@@SubExamId:' print @SubExamId
--print '@@@@MainExamId:' print @MainExamId

Create Table #Qry_GrandMarkSetup
       (
	   [GrandExamMarkSetupId] int not null
	  ,[GrandExamId] int not null
	  ,[ExamSubjectID] int not null
      ,[ExamFullMarks] decimal(8,0) not null
      ,[ExamIsPassDepend] bit not null
      ,[ExamPassMark] decimal(8,0) not null
      ,[ExamPassMarkIsPercent]  bit not null
      ,[GrandSubExamMarkSetupId] int not null
      ,[SubExamId] int not null
      ,[SubExamFullMarks] decimal(8,0) not null
      ,[SubExamExamMarks] decimal(8,0) not null
      ,[SubExamIsPassDepend] bit not null
      ,[SubExamPassMark] decimal(8,0) not null
      ,[SubExamPassMarkIsPercent] bit not null
      ,[DividedExamMarkSetupId] int not null
      ,[DividedExamId] int not null
      ,[DividedExamType] Varchar(5)
      ,[DividedExamFullMarks] decimal(8,0) not null
      ,[DividedExamExamMarks] decimal(8,0) not null
      ,[DividedExamIsPassDepend] bit not null
      ,[DividedExamPassMarks] decimal(8,0) not null
      ,[DividedExamPassMarkIsPercent] bit not null
       )

	 Insert into  #Qry_GrandMarkSetup
	   SELECT
	   [GrandExamMarkSetupId] 
	  ,[GrandExamId] 
	  ,[ExamSubjectID] 
      ,[ExamFullMarks] 
      ,[ExamIsPassDepend] 
      ,[ExamPassMark] 
      ,[ExamPassMarkIsPercent]  
      ,[GrandSubExamMarkSetupId] 
      ,[SubExamId] 
      ,[SubExamFullMarks]
      ,[SubExamExamMarks] 
      ,[SubExamIsPassDepend]
      ,[SubExamPassMark] 
      ,[SubExamPassMarkIsPercent]
      ,[DividedExamMarkSetupId]
      ,[DividedExamId]
      ,[DividedExamType] 
      ,[DividedExamFullMarks] 
      ,[DividedExamExamMarks] 
      ,[DividedExamIsPassDepend] 
      ,[DividedExamPassMarks] 
      ,[DividedExamPassMarkIsPercent]
		 FROM Qry_GrandMarkSetup 
		 WHERE GrandExamId = @GrandExamId AND SubExamId = @GrandSubExamID  AND ExamSubjectID = @SubjectID and [MIsDeleted]=0 and [SIsDeleted]=0 and [DIsDeleted]=0
	 

	 CREATE TABLE [dbo].[#Res_MainExamLeaveStudent](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[VersionId] [int] NOT NULL,
	[SessionId] [int] NOT NULL,
	[BranchId] [int] NOT NULL,
	[ClassId] [int] NOT NULL,
	[ShiftId] [int] NOT NULL,
	[GroupId] [int] NOT NULL,
	[SectionId] [int] NOT NULL,
	[StudentIID] [bigint] NOT NULL,
	[SubjectID] [int] NOT NULL,
	[NumberOfExam] [int] NOT NULL,
	[ISStudentWise] [bit] NOT NULL,
	[GrandExamId] [int] NOT NULL,
	)

	Insert Into #Res_MainExamLeaveStudent
	(
	[VersionId],
	[SessionId],
	[BranchId],
	[ClassId],
	[ShiftId],
	[GroupId],
	[SectionId],
	[StudentIID],
	[SubjectID],
	[NumberOfExam],
	[ISStudentWise],
	[GrandExamId]

	)
	SELECT
	[VersionId],
	[SessionId],
	[BranchId],
	[ClassId],
	[ShiftId],
	[GroupId],
	[SectionId],
	[StudentIID],
	[SubjectID],
	[NumberOfExam],
	[ISStudentWise],
	[GrandExamId] FROM Res_MainExamLeaveStudent where [StudentIID]=@StudentIID and [SubjectID]=@SubjectID


IF Not Exists ( select GrandSubExamId from  [dbo].[Res_GrandResultMarksDetails] where GrandExamId=@GrandExamId and GrandSubExamId=@GrandSubExamID and  SubjectID=@SubjectID and StudentIID=@StudentIID )
	BEGIN
	/*W1 Config */
	Select @GrandDivExamType=GrandDivExamType,@GrandDivExamID=GrandDivExamId,@MainExamPercent=DivExamPercentage 
	From [dbo].[#Res_GrandConfig] Where [MainExamId]=@MainExamId AND [SubjectId]=@SubjectID AND [SubExamId]=@SubExamId AND [DivExamType]='W1' and GrandExamId=@GrandExamId
	If(@GrandDivExamType is not null)
		BEGIN

		IF Exists ( Select StudentIID From #Res_MainExamLeaveStudent)
		BEGIN
			SELECT TOP(1) @NumberOfExam=[NumberOfExam] From #Res_MainExamLeaveStudent
			Set @MainExamPercent=@TotalPersentage/@NumberOfExam
		END

		 SELECT  @GDivExamFullmarks=QG.DividedExamFullMarks,
		 @GDivExamExammarks=QG.DividedExamExamMarks,
		 @GDivIsPassDepENDed=QG.DividedExamIsPassDepEND,
		 @GDivPassIspercentage=QG.DividedExamPassMarkIsPercent,  
		 @GDivPassMark=QG.DividedExamPassMarks, 
		 @GDivExamType=QG.DividedExamType,
		 @GSubExamFullMark=QG.SubExamFullMarks,
		 @GSubExamExamMark=QG.SubExamExamMarks,
		 @GSubIsPassDepENDed=QG.SubExamIsPassDepEND,
		 @GSubPassIspercentage=QG.SubExamPassMarkIsPercent,
		 @GSubPassMark=QG.SubExamPassMark
		 FROM #Qry_GrandMarkSetup QG
		 WHERE QG.GrandExamId = @GrandExamId AND QG.SubExamId = @GrandSubExamID AND QG.DividedExamID = @GrandDivExamID AND QG.ExamSubjectID = @SubjectID 

		Select 
		@WObt1=(IsNull(WrittenObt1,0)*@MainExamPercent)/100,
		@WConv1=(IsNull(WrittenConv1,0)*@MainExamPercent)/100,
		@WIsAbs1=WrittenIsAbsent1
		From [dbo].[#Res_MEResultDetails] MERD where MainExamId=@MainExamId AND SubjectID=@SubjectID AND SubExamId=@SubExamId  AND StudentIID=@StudentIID

		 If(@GrandDivExamType='W1')
			BEGIN
			 set @GWObt1=dbo.ConvertMarks((@WObt1),@BodyCalculationRule)
			 set  @GWIsAbs1=@WIsAbs1

			  Set @GWFrac1=(@GDivExamFullmarks*@GWObt1)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv1=dbo.ConvertMarks((@GWObt1*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
					 if(@DbName='mmhs_new_2018')
					 BEGIN
					  set @GWConv1=@WConv1
					 END
				   End
			   else 
				  Begin
				   SET @GWConv1=@GWObt1
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt1>=@GDivPassMark)
						 SET @GWIsPass1=1
						ELSE
						 SET @GWIsPass1=0
					End
				 ELSE
						Begin
						If(((100*@GWObt1)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass1=1
						ELSE
					 	 SET @GWIsPass1=0
						END
				END

			END
		else If(@GrandDivExamType='W2')
			BEGIN
			 --set @GWObt2=@WObt1
			  set @GWObt2=dbo.ConvertMarks((@WObt1),@BodyCalculationRule)
			 set  @GWIsAbs2=@WIsAbs1
			 Set @GWFrac2=(@GDivExamFullmarks*@GWObt2)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv2=dbo.ConvertMarks((@GWObt2*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv2=@GWObt2
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt2>=@GDivPassMark)
						 SET @GWIsPass2=1
						ELSE
						 SET @GWIsPass2=0
					End
				 ELSE
						Begin
						If(((100*@GWObt2)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass2=1
						ELSE
					 	 SET @GWIsPass2=0
						END
				END
			END
		else If(@GrandDivExamType='W3')
			BEGIN
			 --set @GWObt3=@WObt1
			  set @GWObt3=dbo.ConvertMarks((@WObt1),@BodyCalculationRule)
			 set  @GWIsAbs3=@WIsAbs1
			   Set @GWFrac3=(@GDivExamFullmarks*@GWObt3)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv3=dbo.ConvertMarks((@GWObt3*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv3=@GWObt3
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt3>=@GDivPassMark)
						 SET @GWIsPass3=1
						ELSE
						 SET @GWIsPass3=0
					End
				 ELSE
						Begin
						If(((100*@GWObt3)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass3=1
						ELSE
					 	 SET @GWIsPass3=0
						END
				END
			END
		else If(@GrandDivExamType='S')
			BEGIN
			-- set @GSObt=@WObt1
			  set @GSObt=dbo.ConvertMarks((@WObt1),@BodyCalculationRule)
			 set  @GSIsAbs=@WIsAbs1
			 Set @GSFrac=(@GDivExamFullmarks*@GSObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GSConv=dbo.ConvertMarks((@GSObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GSConv=@GSObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GSObt>=@GDivPassMark)
						 SET @GSIsPass=1
						ELSE
						 SET @GSIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GSObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GSIsPass=1
						ELSE
					 	 SET @GSIsPass=0
						END
				END
			END
		else If(@GrandDivExamType='O')
			BEGIN
			-- set @GOObt=@WObt1
			   set @GOObt=dbo.ConvertMarks((@WObt1),@BodyCalculationRule)
			 set  @GOIsAbs=@WIsAbs1
			 Set @GOFrac=(@GDivExamFullmarks*@GOObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GOConv=dbo.ConvertMarks((@GOObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GOConv=@GOObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GOObt>=@GDivPassMark)
						 SET @GOIsPass=1
						ELSE
						 SET @GOIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GOObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GOIsPass=1
						ELSE
					 	 SET @GOIsPass=0
						END
				END
			END
		else If(@GrandDivExamType='P')
			BEGIN
			 --set @GPObt=@WObt1
			  set @GPObt=dbo.ConvertMarks((@WObt1),@BodyCalculationRule)
			 set  @GPIsAbs=@WIsAbs1
			 Set @GPFrac=(@GDivExamFullmarks*@GPObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GPConv=dbo.ConvertMarks((@GPObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GPConv=@GPObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GPObt>=@GDivPassMark)
						 SET @GPIsPass=1
						ELSE
						 SET @GPIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GPObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GPIsPass=1
						ELSE
					 	 SET @GPIsPass=0
						END
				END
			END
		END	
	/*End W1 Config */


	/*W2 Config */
	set @GrandDivExamType=null
	Select @GrandDivExamType=GrandDivExamType,@GrandDivExamID=GrandDivExamId,@MainExamPercent=DivExamPercentage From [dbo].[#Res_GrandConfig] Where [MainExamId]=@MainExamId AND [SubjectId]=@SubjectID AND [SubExamId]=@SubExamId AND [DivExamType]='W2'  and GrandExamId=@GrandExamId
	If(@GrandDivExamType is not null)
		BEGIN
		IF Exists ( Select StudentIID From #Res_MainExamLeaveStudent)
		BEGIN
			SELECT TOP(1) @NumberOfExam=[NumberOfExam] From #Res_MainExamLeaveStudent
			Set @MainExamPercent=@TotalPersentage/@NumberOfExam
		END

		 SELECT  @GDivExamFullmarks=QG.DividedExamFullMarks,
		 @GDivExamExammarks=QG.DividedExamExamMarks,
		 @GDivIsPassDepENDed=QG.DividedExamIsPassDepEND,
		 @GDivPassIspercentage=QG.DividedExamPassMarkIsPercent,  
		 @GDivPassMark=QG.DividedExamPassMarks, 
		 @GDivExamType=QG.DividedExamType,
		 @GSubExamFullMark=QG.SubExamFullMarks,
		 @GSubExamExamMark=QG.SubExamExamMarks,
		 @GSubIsPassDepENDed=QG.SubExamIsPassDepEND,
		 @GSubPassIspercentage=QG.SubExamPassMarkIsPercent,
		 @GSubPassMark=QG.SubExamPassMark
		 FROM #Qry_GrandMarkSetup QG
		 WHERE QG.GrandExamId = @GrandExamId AND QG.SubExamId = @GrandSubExamID AND QG.DividedExamID = @GrandDivExamID AND QG.ExamSubjectID = @SubjectID 
		Select 
		@WObt2=(WrittenObt2*@MainExamPercent)/100,@WIsAbs2=WrittenIsAbsent2
		From [dbo].[#Res_MEResultDetails] MERD where MainExamId=@MainExamId AND SubjectID=@SubjectID AND SubExamId=@SubExamId  AND StudentIID=@StudentIID

		 If(@GrandDivExamType='W1')
			BEGIN
			 --set @GWObt1=@WObt2
			 set @GWObt1=dbo.ConvertMarks((@WObt2),@BodyCalculationRule)
			  set  @GWIsAbs1=@WIsAbs2
			   Set @GWFrac1=(@GDivExamFullmarks*@GWObt1)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv1=dbo.ConvertMarks((@GWObt1*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv1=@GWObt1
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt1>=@GDivPassMark)
						 SET @GWIsPass1=1
						ELSE
						 SET @GWIsPass1=0
					End
				 ELSE
						Begin
						If(((100*@GWObt1)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass1=1
						ELSE
					 	 SET @GWIsPass1=0
						END
				END
			END
		else If(@GrandDivExamType='W2')
			BEGIN
			-- set @GWObt2=@WObt2
			 set @GWObt2=dbo.ConvertMarks((@WObt2),@BodyCalculationRule)
			 set  @GWIsAbs2=@WIsAbs2
			 Set @GWFrac2=(@GDivExamFullmarks*@GWObt2)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv2=dbo.ConvertMarks((@GWObt2*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv2=@GWObt2
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt2>=@GDivPassMark)
						 SET @GWIsPass2=1
						ELSE
						 SET @GWIsPass2=0
					End
				 ELSE
						Begin
						If(((100*@GWObt2)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass2=1
						ELSE
					 	 SET @GWIsPass2=0
						END
				END
			END
		else If(@GrandDivExamType='W3')
			BEGIN
			-- set @GWObt3=@WObt2
			 set @GWObt3=dbo.ConvertMarks((@WObt2),@BodyCalculationRule)
			 set  @GWIsAbs3=@WIsAbs2
			  Set @GWFrac3=(@GDivExamFullmarks*@GWObt3)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv3=dbo.ConvertMarks((@GWObt3*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv3=@GWObt3
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt3>=@GDivPassMark)
						 SET @GWIsPass3=1
						ELSE
						 SET @GWIsPass3=0
					End
				 ELSE
						Begin
						If(((100*@GWObt3)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass3=1
						ELSE
					 	 SET @GWIsPass3=0
						END
				END
			END
		else If(@GrandDivExamType='S')
			BEGIN
			-- set @GSObt=@WObt2
			 set @GSObt=dbo.ConvertMarks((@WObt2),@BodyCalculationRule)
			 set  @GSIsAbs=@WIsAbs2
			  Set @GSFrac=(@GDivExamFullmarks*@GSObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GSConv=dbo.ConvertMarks((@GSObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GSConv=@GSObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GSObt>=@GDivPassMark)
						 SET @GSIsPass=1
						ELSE
						 SET @GSIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GSObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GSIsPass=1
						ELSE
					 	 SET @GSIsPass=0
						END
				END
			END
		else If(@GrandDivExamType='O')
			BEGIN
			 --set @GOObt=@WObt2
			  set @GOObt=dbo.ConvertMarks((@WObt2),@BodyCalculationRule)
			 set  @GOIsAbs=@WIsAbs2
			 Set @GOFrac=(@GDivExamFullmarks*@GOObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GOConv=dbo.ConvertMarks((@GOObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GOConv=@GOObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GOObt>=@GDivPassMark)
						 SET @GOIsPass=1
						ELSE
						 SET @GOIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GOObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GOIsPass=1
						ELSE
					 	 SET @GOIsPass=0
						END
				END
			END
		else If(@GrandDivExamType='P')
			BEGIN
			-- set @GPObt=@WObt2
			  set @GPObt=dbo.ConvertMarks((@WObt2),@BodyCalculationRule)
			 set  @GPIsAbs=@WIsAbs2
			 Set @GPFrac=(@GDivExamFullmarks*@GPObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GPConv=dbo.ConvertMarks((@GPObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GPConv=@GPObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GPObt>=@GDivPassMark)
						 SET @GPIsPass=1
						ELSE
						 SET @GPIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GPObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GPIsPass=1
						ELSE
					 	 SET @GPIsPass=0
						END
				END
			END
		END	
	/*End W2 Config */

	/*W3 Config */
	set @GrandDivExamType=null
	Select @GrandDivExamType=GrandDivExamType,@GrandDivExamID=GrandDivExamId,@MainExamPercent=DivExamPercentage From [dbo].[#Res_GrandConfig] Where [MainExamId]=@MainExamId AND [SubjectId]=@SubjectID AND [SubExamId]=@SubExamId AND [DivExamType]='W3'  and GrandExamId=@GrandExamId
	If(@GrandDivExamType is not null)
		BEGIN
		IF Exists ( Select StudentIID From #Res_MainExamLeaveStudent)
		BEGIN
			SELECT TOP(1) @NumberOfExam=[NumberOfExam] From #Res_MainExamLeaveStudent
			Set @MainExamPercent=@TotalPersentage/@NumberOfExam
		END
		 SELECT  @GDivExamFullmarks=QG.DividedExamFullMarks,
		 @GDivExamExammarks=QG.DividedExamExamMarks,
		 @GDivIsPassDepENDed=QG.DividedExamIsPassDepEND,
		 @GDivPassIspercentage=QG.DividedExamPassMarkIsPercent,  
		 @GDivPassMark=QG.DividedExamPassMarks, 
		 @GDivExamType=QG.DividedExamType,
		 @GSubExamFullMark=QG.SubExamFullMarks,
		 @GSubExamExamMark=QG.SubExamExamMarks,
		 @GSubIsPassDepENDed=QG.SubExamIsPassDepEND,
		 @GSubPassIspercentage=QG.SubExamPassMarkIsPercent,
		 @GSubPassMark=QG.SubExamPassMark
		 FROM #Qry_GrandMarkSetup QG
		 WHERE QG.GrandExamId = @GrandExamId AND QG.SubExamId = @GrandSubExamID AND QG.DividedExamID = @GrandDivExamID AND QG.ExamSubjectID = @SubjectID 
		Select 
		@WObt3=(WrittenObt3*@MainExamPercent)/100,@WIsAbs3=WrittenIsAbsent3
		From [dbo].[#Res_MEResultDetails] MERD where MainExamId=@MainExamId AND SubjectID=@SubjectID AND SubExamId=@SubExamId  AND StudentIID=@StudentIID
		set @WObt3=dbo.ConvertMarks((@WObt3),@BodyCalculationRule)
		 If(@GrandDivExamType='W1')
			BEGIN
			 --set @GWObt1=@WObt3
			   set @GWObt1=dbo.ConvertMarks((@WObt3),@BodyCalculationRule)
			  set  @GWIsAbs1=@WIsAbs3
			   Set @GWFrac1=(@GDivExamFullmarks*@GWObt1)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv1=dbo.ConvertMarks((@GWObt1*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv1=@GWObt1
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt1>=@GDivPassMark)
						 SET @GWIsPass1=1
						ELSE
						 SET @GWIsPass1=0
					End
				 ELSE
						Begin
						If(((100*@GWObt1)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass1=1
						ELSE
					 	 SET @GWIsPass1=0
						END
				END
			END
		If(@GrandDivExamType='W2')
		BEGIN
		 --set @GWObt2=@WObt3
			   set @GWObt2=dbo.ConvertMarks((@WObt3),@BodyCalculationRule)

		 set  @GWIsAbs2=@WIsAbs3
		 Set @GWFrac2=(@GDivExamFullmarks*@GWObt2)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv2=dbo.ConvertMarks((@GWObt2*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv2=@GWObt2
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt2>=@GDivPassMark)
						 SET @GWIsPass2=1
						ELSE
						 SET @GWIsPass2=0
					End
				 ELSE
						Begin
						If(((100*@GWObt2)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass2=1
						ELSE
					 	 SET @GWIsPass2=0
						END
				END
		END
		 If(@GrandDivExamType='W3')
		BEGIN
		-- set @GWObt3=@WObt3
		 set  @GWIsAbs3=@WIsAbs3
		  Set @GWFrac3=(@GDivExamFullmarks*@GWObt3)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv3=dbo.ConvertMarks((@GWObt3*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv3=@GWObt3
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt3>=@GDivPassMark)
						 SET @GWIsPass3=1
						ELSE
						 SET @GWIsPass3=0
					End
				 ELSE
						Begin
						If(((100*@GWObt3)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass3=1
						ELSE
					 	 SET @GWIsPass3=0
						END
				END
		END
		If(@GrandDivExamType='S')
		BEGIN
		 set @GSObt=@WObt3
		 set  @GSIsAbs=@WIsAbs3
		  Set @GSFrac=(@GDivExamFullmarks*@GSObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GSConv=dbo.ConvertMarks((@GSObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GSConv=@GSObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GSObt>=@GDivPassMark)
						 SET @GSIsPass=1
						ELSE
						 SET @GSIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GSObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GSIsPass=1
						ELSE
					 	 SET @GSIsPass=0
						END
				END
		END
		 If(@GrandDivExamType='O')
		BEGIN
		 set @GOObt=@WObt3
		 set  @GOIsAbs=@WIsAbs3
		 Set @GOFrac=(@GDivExamFullmarks*@GOObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GOConv=dbo.ConvertMarks((@GOObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GOConv=@GOObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GOObt>=@GDivPassMark)
						 SET @GOIsPass=1
						ELSE
						 SET @GOIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GOObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GOIsPass=1
						ELSE
					 	 SET @GOIsPass=0
						END
				END
		END
		If(@GrandDivExamType='P')
		BEGIN
		 set @GPObt=@WObt3
		 set  @GPIsAbs=@WIsAbs3
		 Set @GPFrac=(@GDivExamFullmarks*@GPObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GPConv=dbo.ConvertMarks((@GPObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GPConv=@GPObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GPObt>=@GDivPassMark)
						 SET @GPIsPass=1
						ELSE
						 SET @GPIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GPObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GPIsPass=1
						ELSE
					 	 SET @GPIsPass=0
						END
				END
		END
		END	
	/*End W3 Config */

	/*S Config */
	set @GrandDivExamType=null
	Select @GrandDivExamType=GrandDivExamType,@GrandDivExamID=GrandDivExamId,@MainExamPercent=DivExamPercentage From [dbo].[#Res_GrandConfig] Where [MainExamId]=@MainExamId AND [SubjectId]=@SubjectID AND [SubExamId]=@SubExamId AND [DivExamType]='S'  and GrandExamId=@GrandExamId
	If(@GrandDivExamType is not null)
		BEGIN
		IF Exists ( Select StudentIID From #Res_MainExamLeaveStudent)
		BEGIN
			SELECT TOP(1) @NumberOfExam=[NumberOfExam] From #Res_MainExamLeaveStudent
			Set @MainExamPercent=@TotalPersentage/@NumberOfExam
		END
		 SELECT  @GDivExamFullmarks=QG.DividedExamFullMarks,
		 @GDivExamExammarks=QG.DividedExamExamMarks,
		 @GDivIsPassDepENDed=QG.DividedExamIsPassDepEND,
		 @GDivPassIspercentage=QG.DividedExamPassMarkIsPercent,  
		 @GDivPassMark=QG.DividedExamPassMarks, 
		 @GDivExamType=QG.DividedExamType,
		 @GSubExamFullMark=QG.SubExamFullMarks,
		 @GSubExamExamMark=QG.SubExamExamMarks,
		 @GSubIsPassDepENDed=QG.SubExamIsPassDepEND,
		 @GSubPassIspercentage=QG.SubExamPassMarkIsPercent,
		 @GSubPassMark=QG.SubExamPassMark
		 FROM #Qry_GrandMarkSetup QG
		 WHERE QG.GrandExamId = @GrandExamId AND QG.SubExamId = @GrandSubExamID AND QG.DividedExamID = @GrandDivExamID AND QG.ExamSubjectID = @SubjectID 
		Select 
		@SObt=(SubjectiveObt*@MainExamPercent)/100,@SIsAbs=SubjectiveIsAbsent
		
		From [dbo].[#Res_MEResultDetails] MERD where MainExamId=@MainExamId AND SubjectID=@SubjectID AND SubExamId=@SubExamId  AND StudentIID=@StudentIID
		set @SObt=dbo.ConvertMarks((@SObt),@BodyCalculationRule)
		 If(@GrandDivExamType='W1')
			BEGIN
			 set @GWObt1=@SObt
			 set  @GWIsAbs1=@SIsAbs
			 Set @GWFrac1=(@GDivExamFullmarks*@GWObt1)/@GDivExamExammarks;
			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv1=dbo.ConvertMarks((@GWObt1*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv1=@GWObt1
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt1>=@GDivPassMark)
						 SET @GWIsPass1=1
						ELSE
						 SET @GWIsPass1=0
					End
				 ELSE
						Begin
						If(((100*@GWObt1)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass1=1
						ELSE
					 	 SET @GWIsPass1=0
						END
				END
			END
		else If(@GrandDivExamType='W2')
			BEGIN
			 set @GWObt2=@SObt
			 set  @GWIsAbs2=@SIsAbs
			  Set @GWFrac2=(@GDivExamFullmarks*@GWObt2)/@GDivExamExammarks;
			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv2=dbo.ConvertMarks((@GWObt2*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv2=@GWObt2
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt2>=@GDivPassMark)
						 SET @GWIsPass2=1
						ELSE
						 SET @GWIsPass2=0
					End
				 ELSE
						Begin
						If(((100*@GWObt2)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass2=1
						ELSE
					 	 SET @GWIsPass2=0
						END
				END
			END
		else If(@GrandDivExamType='W3')
			BEGIN
			 set @GWObt3=@SObt
			 set  @GWIsAbs3=@SIsAbs
			 Set @GWFrac3=(@GDivExamFullmarks*@GWObt3)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv3=dbo.ConvertMarks((@GWObt3*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv3=@GWObt3
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt3>=@GDivPassMark)
						 SET @GWIsPass3=1
						ELSE
						 SET @GWIsPass3=0
					End
				 ELSE
						Begin
						If(((100*@GWObt3)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass3=1
						ELSE
					 	 SET @GWIsPass3=0
						END
				END
			END
		else If(@GrandDivExamType='S')
			BEGIN
			 set @GSObt=@SObt
			 set  @GSIsAbs=@SIsAbs
			   Set @GSFrac=(@GDivExamFullmarks*@GSObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GSConv=dbo.ConvertMarks((@GSObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GSConv=@GSObt
				  END

				

              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GSObt>=@GDivPassMark)
						 SET @GSIsPass=1
						ELSE
						 SET @GSIsPass=0
						Print '@@GDivIsPass>>>>' Print @GDivIsPass
					End
				 ELSE
						Begin
						If(((100*@GSObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GSIsPass=1
						ELSE
					 	 SET @GSIsPass=0
						END
				END

				 Print '@@GSIsPass>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>' Print @GSIsPass
				 Print '@@@GOIsPass>>>>' Print @GOIsPass



			END
		else If(@GrandDivExamType='O')
			BEGIN
			 set @GOObt=@SObt
			 set  @GOIsAbs=@SIsAbs
			  Set @GOFrac=(@GDivExamFullmarks*@GOObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GOConv=dbo.ConvertMarks((@GOObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GOConv=@GOObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GOObt>=@GDivPassMark)
						 SET @GOIsPass=1
						ELSE
						 SET @GOIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GOObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GOIsPass=1
						ELSE
					 	 SET @GOIsPass=0
						END
				END
			END
		else If(@GrandDivExamType='P')
			BEGIN
			 set @GPObt=@SObt
			 set  @GPIsAbs=@SIsAbs
			  Set @GPFrac=(@GDivExamFullmarks*@GPObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GPConv=dbo.ConvertMarks((@GPObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GPConv=@GPObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GPObt>=@GDivPassMark)
						 SET @GPIsPass=1
						ELSE
						 SET @GPIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GPObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GPIsPass=1
						ELSE
					 	 SET @GPIsPass=0
						END
				END
			END
		END	
	/*End S Config */

	
	/*O Config */
	set @GrandDivExamType=null
	Select @GrandDivExamType=GrandDivExamType,@GrandDivExamID=GrandDivExamId,@MainExamPercent=DivExamPercentage From [dbo].[#Res_GrandConfig] Where [MainExamId]=@MainExamId AND [SubjectId]=@SubjectID AND [SubExamId]=@SubExamId AND [DivExamType]='O'  and GrandExamId=@GrandExamId
	If(@GrandDivExamType is not null)
		BEGIN

		IF Exists ( Select StudentIID From #Res_MainExamLeaveStudent)
		BEGIN
			SELECT TOP(1) @NumberOfExam=[NumberOfExam] From #Res_MainExamLeaveStudent
			Set @MainExamPercent=@TotalPersentage/@NumberOfExam
		END

		 SELECT  @GDivExamFullmarks=QG.DividedExamFullMarks,
		 @GDivExamExammarks=QG.DividedExamExamMarks,
		 @GDivIsPassDepENDed=QG.DividedExamIsPassDepEND,
		 @GDivPassIspercentage=QG.DividedExamPassMarkIsPercent,  
		 @GDivPassMark=QG.DividedExamPassMarks, 
		 @GDivExamType=QG.DividedExamType,
		 @GSubExamFullMark=QG.SubExamFullMarks,
		 @GSubExamExamMark=QG.SubExamExamMarks,
		 @GSubIsPassDepENDed=QG.SubExamIsPassDepEND,
		 @GSubPassIspercentage=QG.SubExamPassMarkIsPercent,
		 @GSubPassMark=QG.SubExamPassMark
		 FROM #Qry_GrandMarkSetup QG
		 WHERE QG.GrandExamId = @GrandExamId AND QG.SubExamId = @GrandSubExamID AND QG.DividedExamID = @GrandDivExamID AND QG.ExamSubjectID = @SubjectID 
		Select 
		@OObt=(ObjectiveObt*@MainExamPercent)/100,@OIsAbs=ObjectiveIsAbsent
		From [dbo].[#Res_MEResultDetails] MERD where MainExamId=@MainExamId AND SubjectID=@SubjectID AND SubExamId=@SubExamId  AND StudentIID=@StudentIID
		set @OObt=dbo.ConvertMarks((@OObt),@BodyCalculationRule)
		 If(@GrandDivExamType='W1')
			BEGIN
			 set @GWObt1=@OObt
			 set  @GWIsAbs1=@OIsAbs
			  Set @GWFrac1=(@GDivExamFullmarks*@GWObt1)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv1=dbo.ConvertMarks((@GWObt1*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv1=@GWObt1
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt1>=@GDivPassMark)
						 SET @GWIsPass1=1
						ELSE
						 SET @GWIsPass1=0
					End
				 ELSE
						Begin
						If(((100*@GWObt1)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass1=1
						ELSE
					 	 SET @GWIsPass1=0
						END
				END
			END
		else If(@GrandDivExamType='W2')
			BEGIN
			 set @GWObt2=@OObt
			 set  @GWIsAbs2=@OIsAbs
			 Set @GWFrac2=(@GDivExamFullmarks*@GWObt2)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv2=dbo.ConvertMarks((@GWObt2*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv2=@GWObt2
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt2>=@GDivPassMark)
						 SET @GWIsPass2=1
						ELSE
						 SET @GWIsPass2=0
					End
				 ELSE
						Begin
						If(((100*@GWObt2)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass2=1
						ELSE
					 	 SET @GWIsPass2=0
						END
				END
			END
		else If(@GrandDivExamType='W3')
			BEGIN
			 set @GWObt3=@OObt
			 set  @GWIsAbs3=@OIsAbs
			  Set @GWFrac3=(@GDivExamFullmarks*@GWObt3)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv3=dbo.ConvertMarks((@GWObt3*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv3=@GWObt3
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt3>=@GDivPassMark)
						 SET @GWIsPass3=1
						ELSE
						 SET @GWIsPass3=0
					End
				 ELSE
						Begin
						If(((100*@GWObt3)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass3=1
						ELSE
					 	 SET @GWIsPass3=0
						END
				END
			END
		else If(@GrandDivExamType='S')
			BEGIN
			 set @GSObt=@OObt
			 set  @GSIsAbs=@OIsAbs
			  Set @GSFrac=(@GDivExamFullmarks*@GSObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GSConv=dbo.ConvertMarks((@GSObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GSConv=@GSObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GSObt>=@GDivPassMark)
						 SET @GSIsPass=1
						ELSE
						 SET @GSIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GSObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GSIsPass=1
						ELSE
					 	 SET @GSIsPass=0
						END
				END
			END
		else If(@GrandDivExamType='O')
			BEGIN
			 set @GOObt=@OObt
			 set  @GOIsAbs=@OIsAbs
			 Set @GOFrac=(@GDivExamFullmarks*@GOObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GOConv=dbo.ConvertMarks((@GOObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GOConv=@GOObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GOObt>=@GDivPassMark)
						 SET @GOIsPass=1
						ELSE
						 SET @GOIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GOObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GOIsPass=1
						ELSE
					 	 SET @GOIsPass=0
						END
				END

				print 'Obj>>>>>>>>>>>>>>>>>>' print @GOIsPass
			END
		else If(@GrandDivExamType='P')
			BEGIN
			 set @GPObt=@OObt
			 set  @GPIsAbs=@OIsAbs
			 Set @GPFrac=(@GDivExamFullmarks*@GPObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GPConv=dbo.ConvertMarks((@GPObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GPConv=@GPObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GPObt>=@GDivPassMark)
						 SET @GPIsPass=1
						ELSE
						 SET @GPIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GPObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GPIsPass=1
						ELSE
					 	 SET @GPIsPass=0
						END
				END
			END
		END	
	/*End O Config */


	/*P Config */
	set @GrandDivExamType=null
	Select @GrandDivExamType=GrandDivExamType,@GrandDivExamID=GrandDivExamId,@MainExamPercent=DivExamPercentage From [dbo].[#Res_GrandConfig] Where [MainExamId]=@MainExamId AND [SubjectId]=@SubjectID AND [SubExamId]=@SubExamId AND [DivExamType]='P'  and GrandExamId=@GrandExamId
	If(@GrandDivExamType is not null)
		BEGIN

		IF Exists ( Select StudentIID From #Res_MainExamLeaveStudent)
		BEGIN
			SELECT TOP(1) @NumberOfExam=[NumberOfExam] From #Res_MainExamLeaveStudent
			Set @MainExamPercent=@TotalPersentage/@NumberOfExam
		END

		 SELECT  @GDivExamFullmarks=QG.DividedExamFullMarks,
		 @GDivExamExammarks=QG.DividedExamExamMarks,
		 @GDivIsPassDepENDed=QG.DividedExamIsPassDepEND,
		 @GDivPassIspercentage=QG.DividedExamPassMarkIsPercent,  
		 @GDivPassMark=QG.DividedExamPassMarks, 
		 @GDivExamType=QG.DividedExamType,
		 @GSubExamFullMark=QG.SubExamFullMarks,
		 @GSubExamExamMark=QG.SubExamExamMarks,
		 @GSubIsPassDepENDed=QG.SubExamIsPassDepEND,
		 @GSubPassIspercentage=QG.SubExamPassMarkIsPercent,
		 @GSubPassMark=QG.SubExamPassMark
		 FROM #Qry_GrandMarkSetup QG
		 WHERE QG.GrandExamId = @GrandExamId AND QG.SubExamId = @GrandSubExamID AND QG.DividedExamID = @GrandDivExamID AND QG.ExamSubjectID = @SubjectID 
		Select
		@PObt=(PracticalObt*@MainExamPercent)/100 ,@SIsAbs=PracticalIsAbsent
		From [dbo].[#Res_MEResultDetails] MERD where MainExamId=@MainExamId AND SubjectID=@SubjectID AND SubExamId=@SubExamId  AND StudentIID=@StudentIID
		
			set @PObt=dbo.ConvertMarks((@PObt),@BodyCalculationRule)
		 If(@GrandDivExamType='W1')
			BEGIN
			 set @GWObt1=@PObt
			 set  @GWIsAbs1=@PIsAbs
			  Set @GWFrac1=(@GDivExamFullmarks*@GWObt1)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv1=dbo.ConvertMarks((@GWObt1*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv1=@GWObt1
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt1>=@GDivPassMark)
						 SET @GWIsPass1=1
						ELSE
						 SET @GWIsPass1=0
					End
				 ELSE
						Begin
						If(((100*@GWObt1)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass1=1
						ELSE
					 	 SET @GWIsPass1=0
						END
				END
			END
		else If(@GrandDivExamType='W2')
			BEGIN
			 set @GWObt2=@PObt
			 set  @GWIsAbs2=@PIsAbs
			 Set @GWFrac2=(@GDivExamFullmarks*@GWObt2)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv2=dbo.ConvertMarks((@GWObt2*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv2=@GWObt2
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt2>=@GDivPassMark)
						 SET @GWIsPass2=1
						ELSE
						 SET @GWIsPass2=0
					End
				 ELSE
						Begin
						If(((100*@GWObt2)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass2=1
						ELSE
					 	 SET @GWIsPass2=0
						END
				END
			END
		else If(@GrandDivExamType='W3')
			BEGIN
			 set @GWObt3=@PObt
			 set  @GWIsAbs3=@PIsAbs
			  Set @GWFrac3=(@GDivExamFullmarks*@GWObt3)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv3=dbo.ConvertMarks((@GWObt3*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv3=@GWObt3
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt3>=@GDivPassMark)
						 SET @GWIsPass3=1
						ELSE
						 SET @GWIsPass3=0
					End
				 ELSE
						Begin
						If(((100*@GWObt3)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass3=1
						ELSE
					 	 SET @GWIsPass3=0
						END
				END
			END
		else If(@GrandDivExamType='S')
			BEGIN
			 set @GSObt=@PObt
			 set  @GSIsAbs=@PIsAbs
			  Set @GSFrac=(@GDivExamFullmarks*@GSObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GSConv=dbo.ConvertMarks((@GSObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GSConv=@GSObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GSObt>=@GDivPassMark)
						 SET @GSIsPass=1
						ELSE
						 SET @GSIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GSObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GSIsPass=1
						ELSE
					 	 SET @GSIsPass=0
						END
				END
			END
		else If(@GrandDivExamType='O')
			BEGIN
			 set @GOObt=@PObt
			  set  @GOIsAbs=@PIsAbs
			  Set @GOFrac=(@GDivExamFullmarks*@GOObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GOConv=dbo.ConvertMarks((@GOObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GOConv=@GOObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GOObt>=@GDivPassMark)
						 SET @GOIsPass=1
						ELSE
						 SET @GOIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GOObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GOIsPass=1
						ELSE
					 	 SET @GOIsPass=0
						END
				END
			END
		else If(@GrandDivExamType='P')
			BEGIN
			 set @GPObt=@PObt
			  set  @GPIsAbs=@PIsAbs
			  Set @GPFrac=(@GDivExamFullmarks*@GPObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GPConv=dbo.ConvertMarks((@GPObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GPConv=@GPObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GPObt>=@GDivPassMark)
						 SET @GPIsPass=1
						ELSE
						 SET @GPIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GPObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GPIsPass=1
						ELSE
					 	 SET @GPIsPass=0
						END
				END
			END
		END	
	/*End P Config */

		SET @GSubExamTotalObt=@GWConv1+@GWConv2+@GWConv3+@GSConv+@GOConv+@GPConv;

		If(@DBname in ('sshs_new_2018') and(select ClassId from Ins_ClassInfo where ClassId in (9,10,11,12) ) is null)
			Begin
    			SET @GSubExamTotalObt=@GWConv2+@GWConv3+@GSConv+@GOConv+@GPConv;

	
						 DECLARE @CTFullMark decimal(8,2)=0, @CTExamMark decimal(8,2)=0

						    SELECT  @CTFullMark=QG.DividedExamFullMarks,
							 @CTExamMark=QG.DividedExamExamMarks
							 FROM #Qry_GrandMarkSetup QG
							 WHERE QG.GrandExamId = @GrandExamId AND QG.SubExamId = @GrandSubExamID AND QG.DividedExamType = 'W1' AND QG.ExamSubjectID = @SubjectID 

							 set @GSubExamFullMark=@GSubExamFullMark-@CTFullMark
							 set @GSubExamExamMark=@GSubExamExamMark-@CTExamMark

			End

		SET @GSubExamTotalFrac=((@GSubExamTotalObt*@GSubExamFullMark)/@GSubExamExamMark)
		SET @GSubExamOriginalTotalObt=@GWObt1+@GWObt2+@GWObt3+@GSObt+@GOObt+@GPObt;
	
	  


		IF(@GSubExamFullMark != @GSubExamExamMark)
			   Begin
				 SELECT @GSubExamTotalConv=dbo.ConvertMarks((@GSubExamTotalObt*@GSubExamFullMark)/@GSubExamExamMark,@BodyCalculationRule)
				End
			else 
			  Begin
			   SET @GSubExamTotalConv=@GSubExamTotalObt
			  END

		If(@GSubIsPassDepENDed=1)
			Begin

			If(@GSubPassIspercentage=0)
				Begin
					If(@GSubExamTotalObt>=@GSubPassMark)
					 SET @GSubExamIsPass=1
					ELSE
					 SET @GSubExamIsPass=0
				End
			ELSE
				Begin
					If(((100*@GSubExamTotalObt)/@GSubExamExamMark)>=@GSubPassMark)
					SET @GSubExamIsPass=1
					ELSE
					SET @GSubExamIsPass=0
				End
				End

        If(@GWIsPass1=0 OR @GWIsPass2=0 OR @GWIsPass3=0 OR @GSIsPass=0 OR @GOIsPass=0 OR @GPIsPass=0)
		BEGIN
		  SET @GSubExamIsPass=0
		END

		 If(@GWIsAbs1=0 OR @GWIsAbs2=0 or @GWIsAbs3=0 OR @GSIsAbs=0 or @GOIsAbs=0 OR @GPIsAbs=0)
						  BEGIN
						  set 	@GSubExamIsAbsent=0
						  END
					  Else
						  BEGIN
						  set 	@GSubExamIsAbsent=1
						  END	
		

	SET @SOPTotalObt=@GSObt + @GOObt + @GPObt
	SET @SOPTotalConv=@GSConv + @GOConv + @GPConv
	SET @SOPTotalFrac=@GSFrac + @GOFrac + @GPFrac
 
	 INSERT INTO [dbo].[Res_GrandResultMarksDetails]
				   (
			   [SubjectID]
			  ,[GrandExamId]
			  ,[GrandSubExamId]
			  ,[StudentIID]
			  ,[WrittenObt1]
			  ,[WrittenConv1]
			  ,[WrittenFrac1]
			  ,[WrittenIsPass1]
			  ,[WrittenIsAbsent1]
			  ,[WrittenObt2]
			  ,[WrittenConv2]
			  ,[WrittenFrac2]
			  ,[WrittenIsPass2]
			  ,[WrittenIsAbsent2]
			  ,[WrittenObt3]
			  ,[WrittenConv3]
			  ,[WrittenFrac3]
			  ,[WrittenIsPass3]
			  ,[WrittenIsAbsent3]
			  ,[SubjectiveObt]
			  ,[SubjectiveConv]
			  ,[SubjectiveFrac]
			  ,[SubjectiveIsPass]
			  ,[SubjectiveIsAbsent]
			  ,[ObjectiveObt]
			  ,[ObjectiveConv]
			  ,[ObjectiveFrac]
			  ,[ObjectiveIsPass]
			  ,[ObjectiveIsAbsent]
			  ,[PracticalObt]
			  ,[PracticalConv]
			  ,[PracticalFrac]
			  ,[PracticalIsPass]
			  ,[PracticalIsAbsent]
			  ,[SOPTotalObt]
			  ,[SOPTotalConv]
			  ,[SOPTotalFrac]
			  ,[SubExamTotalObt] 
			  ,[SubExamTotalConv]
			  ,[SubExamTotalFrac]
			  ,[SubExamIsPass]
			  ,[SubExamIsAbsent]
			  ,[SubExamOriginalTotalObt]
				   )
				   values
				   (
			 @SubjectID
			,@GrandExamId
			,@GrandSubExamID
			,@StudentIID
	
			,@GWObt1
			,@GWConv1
			,@GWFrac1
			,@GWIsPass1
			,@GWIsAbs1

			,@GWObt2
			,@GWConv2
			,@GWFrac2
			,@GWIsPass2
			,@GWIsAbs2
	
			,@GWObt3
			,@GWConv3
			,@GWFrac3
			,@GWIsPass3
			,@GWIsAbs3

			,@GSObt
			,@GSConv
			,@GSFrac
			,@GSIsPass
			,@GSIsAbs

			,@GOObt
			,@GOConv
			,@GOFrac
			,@GOIsPass
			,@GOIsAbs

			,@GPObt
			,@GPConv
			,@GPFrac
			,@GPIsPass
			,@GPIsAbs

			,@SOPTotalObt
			,@SOPTotalConv
			,@SOPTotalFrac
			,@GSubExamTotalObt 
			,@GSubExamTotalConv
			,@GSubExamTotalFrac
			,@GSubExamIsPass
			,@GSubExamIsAbsent
			
			,@GSubExamOriginalTotalObt

				   )
	END

Else ------------------------------------------------------------------------------------------------ Update for 2nd Time -------------------------------------------
	 BEGIN
	 Select @SGWObt1=WrittenObt1,@SGWIsAbs1=WrittenIsAbsent1,
	 @SGWObt2=WrittenObt2,@SGWIsAbs2=WrittenIsAbsent2,
	 @SGWObt3=WrittenObt3,@SGWIsAbs3=WrittenIsAbsent3,
	 @SGSObt=SubjectiveObt,@SGSIsAbs=SubjectiveIsAbsent,
	 @SGOObt=ObjectiveObt,@SGOIsAbs=ObjectiveIsAbsent,
	 @SGPObt=PracticalObt,@SGPIsAbs=PracticalIsAbsent,
	 

	 @SGWConv1=WrittenConv1,
	 @SGWConv2=WrittenConv2,
	 @SGWConv3=WrittenConv3,
	 @SGSConv=SubjectiveConv,
	 @SGOConv=ObjectiveConv,
	 @SGPConv=PracticalConv
	 
	  from  [dbo].[Res_GrandResultMarksDetails] where GrandExamId=@GrandExamId and GrandSubExamId=@GrandSubExamID and  SubjectID=@SubjectID and StudentIID=@StudentIID 


	 /*W1 Config */
	Select @GrandDivExamType=GrandDivExamType ,@GrandDivExamID=GrandDivExamId,@MainExamPercent=DivExamPercentage From [dbo].[#Res_GrandConfig] Where [MainExamId]=@MainExamId AND [SubjectId]=@SubjectID AND [SubExamId]=@SubExamId AND [DivExamType]='W1'  and GrandExamId=@GrandExamId
	
	If(@GrandDivExamType is not null)
		BEGIN

		IF Exists ( Select StudentIID From #Res_MainExamLeaveStudent)
		BEGIN
			SELECT TOP(1) @NumberOfExam=[NumberOfExam] From #Res_MainExamLeaveStudent
			Set @MainExamPercent=@TotalPersentage/@NumberOfExam
		END

		 SELECT  @GDivExamFullmarks=QG.DividedExamFullMarks,
		 @GDivExamExammarks=QG.DividedExamExamMarks,
		 @GDivIsPassDepENDed=QG.DividedExamIsPassDepEND,
		 @GDivPassIspercentage=QG.DividedExamPassMarkIsPercent,  
		 @GDivPassMark=QG.DividedExamPassMarks, 
		 @GDivExamType=QG.DividedExamType,
		 @GSubExamFullMark=QG.SubExamFullMarks,
		 @GSubExamExamMark=QG.SubExamExamMarks,
		 @GSubIsPassDepENDed=QG.SubExamIsPassDepEND,
		 @GSubPassIspercentage=QG.SubExamPassMarkIsPercent,
		 @GSubPassMark=QG.SubExamPassMark
		 FROM #Qry_GrandMarkSetup QG
		 WHERE QG.GrandExamId = @GrandExamId AND QG.SubExamId = @GrandSubExamID AND QG.DividedExamID = @GrandDivExamID AND QG.ExamSubjectID = @SubjectID 

		 Select @WObt1=(IsNull(WrittenObt1,0)*@MainExamPercent)/100, @WConv1=(IsNull(WrittenConv1,0)*@MainExamPercent)/100,@WIsAbs1=WrittenIsAbsent1
		 From [dbo].[#Res_MEResultDetails] MERD where MainExamId=@MainExamId AND SubjectID=@SubjectID AND SubExamId=@SubExamId  AND StudentIID=@StudentIID

		 If(@GrandDivExamType='W1')
			BEGIN
			 set @GWObt1=dbo.ConvertMarks((@WObt1 + @SGWObt1),@BodyCalculationRule)
			 

			  Set @GWFrac1=(@GDivExamFullmarks*@GWObt1)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv1=dbo.ConvertMarks((@GWObt1*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv1=@GWObt1
				  END
             
			 if(@DbName='mmhs_new_2018')
			   BEGIN
				 set @GWConv1=dbo.ConvertMarks((@WConv1 + @SGWConv1),@BodyCalculationRule)
			    END
			

              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt1>=@GDivPassMark)
						 SET @GWIsPass1=1
						ELSE
						 SET @GWIsPass1=0
					End
				 ELSE
						Begin
						If(((100*@GWObt1)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass1=1
						ELSE
					 	 SET @GWIsPass1=0
						END
				END
			  If(@WIsAbs1=0 OR @SGWIsAbs1=0)
				  BEGIN
				  set @GWIsAbs1=0
				  END
			  Else
				  BEGIN
				  set @GWIsAbs1=1
				  END

			END
		else If(@GrandDivExamType='W2')
			BEGIN
			 set @GWObt2=dbo.ConvertMarks((@WObt1 + @SGWObt2),@BodyCalculationRule)
			 Set @GWFrac2=(@GDivExamFullmarks*@GWObt2)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv2=dbo.ConvertMarks((@GWObt2*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv2=@GWObt2
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt2>=@GDivPassMark)
						 SET @GWIsPass2=1
						ELSE
						 SET @GWIsPass2=0
					End
				 ELSE
						Begin
						If(((100*@GWObt2)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass2=1
						ELSE
					 	 SET @GWIsPass2=0
						END
				END
			  If(@WIsAbs1=0 OR @SGWIsAbs2=0)
				  BEGIN
				  set @GWIsAbs2=0
				  END
			  Else
				  BEGIN
				  set @GWIsAbs2=1
				  END
			END
		else If(@GrandDivExamType='W3')
			BEGIN
			 set @GWObt3=dbo.ConvertMarks((@WObt1 +@SGWObt3),@BodyCalculationRule)
			  Set @GWFrac3=(@GDivExamFullmarks*@GWObt3)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv3=dbo.ConvertMarks((@GWObt3*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv3=@GWObt3
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt3>=@GDivPassMark)
						 SET @GWIsPass3=1
						ELSE
						 SET @GWIsPass3=0
					End
				 ELSE
						Begin
						If(((100*@GWObt3)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass3=1
						ELSE
					 	 SET @GWIsPass3=0
						END
				END
			  If(@WIsAbs1=0 OR @SGWIsAbs3=0)
				  BEGIN
				  set @GWIsAbs3=0
				  END
			  Else
				  BEGIN
				  set @GWIsAbs3=1
				  END
		
			END
		else If(@GrandDivExamType='S')
			BEGIN
			 set @GSObt=dbo.ConvertMarks((@WObt1 +@SGSObt),@BodyCalculationRule)
			  Set @GSFrac=(@GDivExamFullmarks*@GSObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GSConv=dbo.ConvertMarks((@GSObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GSConv=@GSObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GSObt>=@GDivPassMark)
						 SET @GSIsPass=1
						ELSE
						 SET @GSIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GSObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GSIsPass=1
						ELSE
					 	 SET @GSIsPass=0
						END
				END
			  If(@WIsAbs1=0 OR @SGSIsAbs=0)
				  BEGIN
				  set @GSIsAbs=0
				  END
			  Else
				  BEGIN
				  set @GSIsAbs=1
				  END
			END
		else If(@GrandDivExamType='O')
			BEGIN
			 set @GOObt=dbo.ConvertMarks((@WObt1 +@SGOObt),@BodyCalculationRule)
			 Set @GOFrac=(@GDivExamFullmarks*@GOObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GOConv=dbo.ConvertMarks((@GOObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GOConv=@GOObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GOObt>=@GDivPassMark)
						 SET @GOIsPass=1
						ELSE
						 SET @GOIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GOObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GOIsPass=1
						ELSE
					 	 SET @GOIsPass=0
						END
				END
			  If(@WIsAbs1=0 OR @SGOIsAbs=0)
				  BEGIN
				  set @GOIsAbs=0
				  END
			  Else
				  BEGIN
				  set @GOIsAbs=1
				  END
			END
		else If(@GrandDivExamType='P')
			BEGIN
			 set @GPObt=dbo.ConvertMarks((@WObt1 +@SGPObt),@BodyCalculationRule)
			 Set @GPFrac=(@GDivExamFullmarks*@GPObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GPConv=dbo.ConvertMarks((@GPObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GPConv=@GPObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GPObt>=@GDivPassMark)
						 SET @GPIsPass=1
						ELSE
						 SET @GPIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GPObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GPIsPass=1
						ELSE
					 	 SET @GPIsPass=0
						END
				END
			  If(@WIsAbs1=0 OR @SGPIsAbs=0)
				  BEGIN
				  set @GPIsAbs=0
				  END
			  Else
				  BEGIN
				  set @GPIsAbs=1
				  END
			END
		END	
	/*End W1 Config */


	/*W2 Config */
	set @GrandDivExamType=null
	Select @GrandDivExamType=GrandDivExamType,@GrandDivExamID=GrandDivExamId ,@MainExamPercent=DivExamPercentage From [dbo].[#Res_GrandConfig] Where [MainExamId]=@MainExamId AND [SubjectId]=@SubjectID AND [SubExamId]=@SubExamId AND [DivExamType]='W2'  and GrandExamId=@GrandExamId
	If(@GrandDivExamType is not null)
		BEGIN

		IF Exists ( Select StudentIID From #Res_MainExamLeaveStudent)
		BEGIN
			SELECT TOP(1) @NumberOfExam=[NumberOfExam] From #Res_MainExamLeaveStudent
			Set @MainExamPercent=@TotalPersentage/@NumberOfExam
		END

		 SELECT  @GDivExamFullmarks=QG.DividedExamFullMarks,
		 @GDivExamExammarks=QG.DividedExamExamMarks,
		 @GDivIsPassDepENDed=QG.DividedExamIsPassDepEND,
		 @GDivPassIspercentage=QG.DividedExamPassMarkIsPercent,  
		 @GDivPassMark=QG.DividedExamPassMarks, 
		 @GDivExamType=QG.DividedExamType,
		 @GSubExamFullMark=QG.SubExamFullMarks,
		 @GSubExamExamMark=QG.SubExamExamMarks,
		 @GSubIsPassDepENDed=QG.SubExamIsPassDepEND,
		 @GSubPassIspercentage=QG.SubExamPassMarkIsPercent,
		 @GSubPassMark=QG.SubExamPassMark
		 FROM #Qry_GrandMarkSetup QG
		 WHERE QG.GrandExamId = @GrandExamId AND QG.SubExamId = @GrandSubExamID AND QG.DividedExamID = @GrandDivExamID AND QG.ExamSubjectID = @SubjectID 

		 Select 
		@WObt2=(WrittenObt2*@MainExamPercent)/100,@WIsAbs2=WrittenIsAbsent2
		From [dbo].[#Res_MEResultDetails] MERD where MainExamId=@MainExamId AND SubjectID=@SubjectID AND SubExamId=@SubExamId  AND StudentIID=@StudentIID

		 If(@GrandDivExamType='W1')
			BEGIN
			 set @GWObt1=dbo.ConvertMarks((@WObt2 +@SGWObt1),@BodyCalculationRule)
			 Set @GWFrac1=(@GDivExamFullmarks*@GWObt1)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv1=dbo.ConvertMarks((@GWObt1*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv1=@GWObt1
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt1>=@GDivPassMark)
						 SET @GWIsPass1=1
						ELSE
						 SET @GWIsPass1=0
					End
				 ELSE
						Begin
						If(((100*@GWObt1)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass1=1
						ELSE
					 	 SET @GWIsPass1=0
						END
				END
			  If(@WIsAbs2=0 OR @SGWIsAbs1=0)
				  BEGIN
				  set @GWIsAbs1=0
				  END
			  Else
				  BEGIN
				  set @GWIsAbs1=1
				  END

			END
		  else If(@GrandDivExamType='W2')
			BEGIN
			 set @GWObt2=dbo.ConvertMarks((@WObt2 +@SGWObt2),@BodyCalculationRule)
			  Set @GWFrac2=(@GDivExamFullmarks*@GWObt2)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv2=dbo.ConvertMarks((@GWObt2*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv2=@GWObt2
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt2>=@GDivPassMark)
						 SET @GWIsPass2=1
						ELSE
						 SET @GWIsPass2=0
					End
				 ELSE
						Begin
						If(((100*@GWObt2)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass2=1
						ELSE
					 	 SET @GWIsPass2=0
						END
				END
			  If(@WIsAbs2=0 OR @SGWIsAbs2=0)
				  BEGIN
				  set @GWIsAbs2=0
				  END
			  Else
				  BEGIN
				  set @GWIsAbs2=1
				  END
			END
		else If(@GrandDivExamType='W3')
			BEGIN
			 set @GWObt3=dbo.ConvertMarks((@WObt2 +@SGWObt3),@BodyCalculationRule)
			   Set @GWFrac3=(@GDivExamFullmarks*@GWObt3)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv3=dbo.ConvertMarks((@GWObt3*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv3=@GWObt3
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt3>=@GDivPassMark)
						 SET @GWIsPass3=1
						ELSE
						 SET @GWIsPass3=0
					End
				 ELSE
						Begin
						If(((100*@GWObt3)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass3=1
						ELSE
					 	 SET @GWIsPass3=0
						END
				END
			  If(@WIsAbs2=0 OR @SGWIsAbs3=0)
				  BEGIN
				  set @GWIsAbs3=0
				  END
			  Else
				  BEGIN
				  set @GWIsAbs3=1
				  END
			END
		else If(@GrandDivExamType='S')
			BEGIN
			 set @GSObt=dbo.ConvertMarks((@WObt2 +@SGSObt),@BodyCalculationRule)
			  Set @GSFrac=(@GDivExamFullmarks*@GSObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GSConv=dbo.ConvertMarks((@GSObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GSConv=@GSObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GSObt>=@GDivPassMark)
						 SET @GSIsPass=1
						ELSE
						 SET @GSIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GSObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GSIsPass=1
						ELSE
					 	 SET @GSIsPass=0
						END
				END
			  If(@WIsAbs2=0 OR @SGSIsAbs=0)
				  BEGIN
				  set @GSIsAbs=0
				  END
			  Else
				  BEGIN
				  set @GSIsAbs=1
				  END

			END
		else If(@GrandDivExamType='O')
			BEGIN
			 set @GOObt=dbo.ConvertMarks((@WObt2 +@SGOObt),@BodyCalculationRule)
			  Set @GOFrac=(@GDivExamFullmarks*@GOObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GOConv=dbo.ConvertMarks((@GOObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GOConv=@GOObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GOObt>=@GDivPassMark)
						 SET @GOIsPass=1
						ELSE
						 SET @GOIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GOObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GOIsPass=1
						ELSE
					 	 SET @GOIsPass=0
						END
				END
			  If(@WIsAbs2=0 OR @SGOIsAbs=0)
				  BEGIN
				  set @GOIsAbs=0
				  END
			  Else
				  BEGIN
				  set @GOIsAbs=1
				  END
			END
		else If(@GrandDivExamType='P')
			BEGIN
			 set @GPObt=dbo.ConvertMarks((@WObt2 +@SGPObt),@BodyCalculationRule)
			  Set @GPFrac=(@GDivExamFullmarks*@GPObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GPConv=dbo.ConvertMarks((@GPObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GPConv=@GPObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GPObt>=@GDivPassMark)
						 SET @GPIsPass=1
						ELSE
						 SET @GPIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GPObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GPIsPass=1
						ELSE
					 	 SET @GPIsPass=0
						END
				END
			  If(@WIsAbs2=0 OR @SGPIsAbs=0)
				  BEGIN
				  set @GPIsAbs=0
				  END
			  Else
				  BEGIN
				  set @GPIsAbs=1
				  END
			END
		END	
	/*End W2 Config */

	/*W3 Config */
	set @GrandDivExamType=null
	Select @GrandDivExamType=GrandDivExamType,@GrandDivExamID=GrandDivExamId ,@MainExamPercent=DivExamPercentage From [dbo].[#Res_GrandConfig] Where [MainExamId]=@MainExamId AND [SubjectId]=@SubjectID AND [SubExamId]=@SubExamId AND [DivExamType]='W3'  and GrandExamId=@GrandExamId
	If(@GrandDivExamType is not null  AND @GrandDivExamID is not null)
		BEGIN

		IF Exists ( Select StudentIID From #Res_MainExamLeaveStudent)
		BEGIN
			SELECT TOP(1) @NumberOfExam=[NumberOfExam] From #Res_MainExamLeaveStudent
			Set @MainExamPercent=@TotalPersentage/@NumberOfExam
		END

		 SELECT  @GDivExamFullmarks=QG.DividedExamFullMarks,
		 @GDivExamExammarks=QG.DividedExamExamMarks,
		 @GDivIsPassDepENDed=QG.DividedExamIsPassDepEND,
		 @GDivPassIspercentage=QG.DividedExamPassMarkIsPercent,  
		 @GDivPassMark=QG.DividedExamPassMarks, 
		 @GDivExamType=QG.DividedExamType,
		 @GSubExamFullMark=QG.SubExamFullMarks,
		 @GSubExamExamMark=QG.SubExamExamMarks,
		 @GSubIsPassDepENDed=QG.SubExamIsPassDepEND,
		 @GSubPassIspercentage=QG.SubExamPassMarkIsPercent,
		 @GSubPassMark=QG.SubExamPassMark
		 FROM #Qry_GrandMarkSetup QG
		 WHERE QG.GrandExamId = @GrandExamId AND QG.SubExamId = @GrandSubExamID AND QG.DividedExamID = @GrandDivExamID AND QG.ExamSubjectID = @SubjectID 
		 Select 
		@WObt3=(WrittenObt3*@MainExamPercent)/100,@WIsAbs3=WrittenIsAbsent3
		From [dbo].[#Res_MEResultDetails] MERD where MainExamId=@MainExamId AND SubjectID=@SubjectID AND SubExamId=@SubExamId  AND StudentIID=@StudentIID

		 If(@GrandDivExamType='W1')
			BEGIN
			  set @GWObt1=dbo.ConvertMarks((@WObt3 +@SGWObt1),@BodyCalculationRule)
			  Set @GWFrac1=(@GDivExamFullmarks*@GWObt1)/@GDivExamExammarks;
			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv1=dbo.ConvertMarks((@GWObt1*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv1=@GWObt1
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt1>=@GDivPassMark)
						 SET @GWIsPass1=1
						ELSE
						 SET @GWIsPass1=0
					End
				 ELSE
						Begin
						If(((100*@GWObt1)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass1=1
						ELSE
					 	 SET @GWIsPass1=0
						END
				END
			  If(@WIsAbs3=0 OR @SGWIsAbs1=0)
				  BEGIN
				  set @GWIsAbs1=0
				  END
			  Else
				  BEGIN
				  set @GWIsAbs1=1
				  END
			END
		else If(@GrandDivExamType='W2')
			BEGIN
			 set @GWObt2=dbo.ConvertMarks((@WObt3 +@SGWObt2),@BodyCalculationRule)
			  Set @GWFrac2=(@GDivExamFullmarks*@GWObt2)/@GDivExamExammarks;
			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv2=dbo.ConvertMarks((@GWObt2*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv2=@GWObt2
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt2>=@GDivPassMark)
						 SET @GWIsPass2=1
						ELSE
						 SET @GWIsPass2=0
					End
				 ELSE
						Begin
						If(((100*@GWObt2)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass2=1
						ELSE
					 	 SET @GWIsPass2=0
						END
				END
			  If(@WIsAbs3=0 OR @SGWIsAbs2=0)
				  BEGIN
				  set @GWIsAbs2=0
				  END
			  Else
				  BEGIN
				  set @GWIsAbs2=1
				  END
			END
	   else If(@GrandDivExamType='W3')
			BEGIN
			 set @GWObt3=dbo.ConvertMarks((@WObt3 +@SGWObt3),@BodyCalculationRule)
			  Set @GWFrac3=(@GDivExamFullmarks*@GWObt3)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv3=dbo.ConvertMarks((@GWObt3*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv3=@GWObt3
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt3>=@GDivPassMark)
						 SET @GWIsPass3=1
						ELSE
						 SET @GWIsPass3=0
					End
				 ELSE
						Begin
						If(((100*@GWObt3)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass3=1
						ELSE
					 	 SET @GWIsPass3=0
						END
				END
			  If(@WIsAbs3=0 OR @SGWIsAbs3=0)
				  BEGIN
				  set @GWIsAbs3=0
				  END
			  Else
				  BEGIN
				  set @GWIsAbs3=1
				  END
			END
		else If(@GrandDivExamType='S')
			BEGIN
			 set @GSObt=dbo.ConvertMarks((@WObt3 +@SGSObt),@BodyCalculationRule)
			  Set @GSFrac=(@GDivExamFullmarks*@GSObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GSConv=dbo.ConvertMarks((@GSObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GSConv=@GSObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GSObt>=@GDivPassMark)
						 SET @GSIsPass=1
						ELSE
						 SET @GSIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GSObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GSIsPass=1
						ELSE
					 	 SET @GSIsPass=0
						END
				END
			  If(@WIsAbs3=0 OR @SGSIsAbs=0)
				  BEGIN
				  set @GSIsAbs=0
				  END
			  Else
				  BEGIN
				  set @GSIsAbs=1
				  END

			END
	   else If(@GrandDivExamType='O')
			BEGIN
			 set @GOObt=dbo.ConvertMarks((@WObt3 +@SGOObt),@BodyCalculationRule)
			  Set @GOFrac=(@GDivExamFullmarks*@GOObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GOConv=dbo.ConvertMarks((@GOObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GOConv=@GOObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GOObt>=@GDivPassMark)
						 SET @GOIsPass=1
						ELSE
						 SET @GOIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GOObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GOIsPass=1
						ELSE
					 	 SET @GOIsPass=0
						END
				END
			  If(@WIsAbs3=0 OR @SGOIsAbs=0)
				  BEGIN
				  set @GOIsAbs=0
				  END
			  Else
				  BEGIN
				  set @GOIsAbs=1
				  END
			END
	  else If(@GrandDivExamType='P')
			BEGIN
			 set @GPObt=dbo.ConvertMarks((@WObt3 +@SGPObt),@BodyCalculationRule)
			  Set @GPFrac=(@GDivExamFullmarks*@GPObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GPConv=dbo.ConvertMarks((@GPObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GPConv=@GPObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GPObt>=@GDivPassMark)
						 SET @GPIsPass=1
						ELSE
						 SET @GPIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GPObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GPIsPass=1
						ELSE
					 	 SET @GPIsPass=0
						END
				END
			  If(@WIsAbs3=0 OR @SGPIsAbs=0)
				  BEGIN
				  set @GPIsAbs=0
				  END
			  Else
				  BEGIN
				  set @GPIsAbs=1
				  END
			END

		END	
	/*End W3 Config */

	/*S Config */
	set @GrandDivExamType=null
	Select @GrandDivExamType=GrandDivExamType,@GrandDivExamID=GrandDivExamId ,@MainExamPercent=DivExamPercentage From [dbo].[#Res_GrandConfig] Where [MainExamId]=@MainExamId AND [SubjectId]=@SubjectID AND [SubExamId]=@SubExamId AND [DivExamType]='S'  and GrandExamId=@GrandExamId
	If(@GrandDivExamType is not null)
		BEGIN
		print 'This is Base Subjective----------------------------------------------------:'

		IF Exists ( Select StudentIID From #Res_MainExamLeaveStudent)
		BEGIN
			SELECT TOP(1) @NumberOfExam=[NumberOfExam] From #Res_MainExamLeaveStudent
			Set @MainExamPercent=@TotalPersentage/@NumberOfExam
		END

		 SELECT  @GDivExamFullmarks=QG.DividedExamFullMarks,
		 @GDivExamExammarks=QG.DividedExamExamMarks,
		 @GDivIsPassDepENDed=QG.DividedExamIsPassDepEND,
		 @GDivPassIspercentage=QG.DividedExamPassMarkIsPercent,  
		 @GDivPassMark=QG.DividedExamPassMarks, 
		 @GDivExamType=QG.DividedExamType,
		 @GSubExamFullMark=QG.SubExamFullMarks,
		 @GSubExamExamMark=QG.SubExamExamMarks,
		 @GSubIsPassDepENDed=QG.SubExamIsPassDepEND,
		 @GSubPassIspercentage=QG.SubExamPassMarkIsPercent,
		 @GSubPassMark=QG.SubExamPassMark
		 FROM #Qry_GrandMarkSetup QG
		 WHERE QG.GrandExamId = @GrandExamId AND QG.SubExamId = @GrandSubExamID AND QG.DividedExamID = @GrandDivExamID AND QG.ExamSubjectID = @SubjectID 

		 Select 
		@SObt=(SubjectiveObt*@MainExamPercent)/100,@SIsAbs=SubjectiveIsAbsent
		From [dbo].[#Res_MEResultDetails] MERD where MainExamId=@MainExamId AND SubjectID=@SubjectID AND SubExamId=@SubExamId  AND StudentIID=@StudentIID

		 If(@GrandDivExamType='W1')
			BEGIN
			 set @GWObt1=dbo.ConvertMarks((@SObt +@SGWObt1),@BodyCalculationRule)
			  Set @GWFrac1=(@GDivExamFullmarks*@GWObt1)/@GDivExamExammarks;
			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv1=dbo.ConvertMarks((@GWObt1*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv1=@GWObt1
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt1>=@GDivPassMark)
						 SET @GWIsPass1=1
						ELSE
						 SET @GWIsPass1=0
					End
				 ELSE
						Begin
						If(((100*@GWObt1)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass1=1
						ELSE
					 	 SET @GWIsPass1=0
						END
				END
			  If(@SIsAbs=0 OR @SGWIsAbs1=0)
				  BEGIN
				  set @GWIsAbs1=0
				  END
			  Else
				  BEGIN
				  set @GWIsAbs1=1
				  END
			END
		else If(@GrandDivExamType='W2')
			BEGIN
			 set @GWObt2=dbo.ConvertMarks((@SObt +@SGWObt2),@BodyCalculationRule)
			  Set @GWFrac2=(@GDivExamFullmarks*@GWObt2)/@GDivExamExammarks;
			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv2=dbo.ConvertMarks((@GWObt2*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv2=@GWObt2
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt2>=@GDivPassMark)
						 SET @GWIsPass2=1
						ELSE
						 SET @GWIsPass2=0
					End
				 ELSE
						Begin
						If(((100*@GWObt2)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass2=1
						ELSE
					 	 SET @GWIsPass2=0
						END
				END
			  If(@SIsAbs=0 OR @SGWIsAbs2=0)
				  BEGIN
				  set @GWIsAbs2=0
				  END
			  Else
				  BEGIN
				  set @GWIsAbs2=1
				  END
			END
		else If(@GrandDivExamType='W3')
			BEGIN
			 set @GWObt3=dbo.ConvertMarks((@SObt +@SGWObt3),@BodyCalculationRule)
			 Set @GWFrac3=(@GDivExamFullmarks*@GWObt3)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv3=dbo.ConvertMarks((@GWObt3*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv3=@GWObt3
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt3>=@GDivPassMark)
						 SET @GWIsPass3=1
						ELSE
						 SET @GWIsPass3=0
					End
				 ELSE
						Begin
						If(((100*@GWObt3)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass3=1
						ELSE
					 	 SET @GWIsPass3=0
						END
				END
			  If(@SIsAbs=0 OR @SGWIsAbs3=0)
				  BEGIN
				  set @GWIsAbs3=0
				  END
			  Else
				  BEGIN
				  set @GWIsAbs3=1
				  END
			END
		else If(@GrandDivExamType='S')
			BEGIN
			print 'This is Child Subjective----------------------------------------------------:'
			 set @GSObt=dbo.ConvertMarks((@SObt +@SGSObt),@BodyCalculationRule)
			  Set @GSFrac=(@GDivExamFullmarks*@GSObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GSConv=dbo.ConvertMarks((@GSObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GSConv=@GSObt
				  END

				  Print '@GDivExamFullmarks:'  Print @GDivExamFullmarks 
				  Print '@@GDivExamExammarks:' Print @GDivExamExammarks 
				  Print '@@GSConv: 1'          Print @GSConv 
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
					 
						If(@GSObt>=@GDivPassMark)
						 SET @GSIsPass=1
						ELSE
						 SET @GSIsPass=0
					End
				 ELSE
				
						Begin
						If(((100*@GSObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GSIsPass=1
						ELSE
					 	 SET @GSIsPass=0
						END
				END
			  If(@SIsAbs=0 OR @SGSIsAbs=0)
				  BEGIN
				  set @GSIsAbs=0
				  END
			  Else
				  BEGIN
				  set @GSIsAbs=1
				  END
			END
		else If(@GrandDivExamType='O')
			BEGIN
			 set @GOObt=dbo.ConvertMarks((@SObt +@SGOObt),@BodyCalculationRule)
			  Set @GOFrac=(@GDivExamFullmarks*@GOObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GOConv=dbo.ConvertMarks((@GOObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GOConv=@GOObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GOObt>=@GDivPassMark)
						 SET @GOIsPass=1
						ELSE
						 SET @GOIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GOObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GOIsPass=1
						ELSE
					 	 SET @GOIsPass=0
						END
				END
			  If(@SIsAbs=0 OR @SGOIsAbs=0)
				  BEGIN
				  set @GOIsAbs=0
				  END
			  Else
				  BEGIN
				  set @GOIsAbs=1
				  END
			END
		else If(@GrandDivExamType='P')
			BEGIN
			 set @GPObt=dbo.ConvertMarks((@SObt +@SGPObt),@BodyCalculationRule)
			  Set @GPFrac=(@GDivExamFullmarks*@GPObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GPConv=dbo.ConvertMarks((@GPObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GPConv=@GPObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GPObt>=@GDivPassMark)
						 SET @GPIsPass=1
						ELSE
						 SET @GPIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GPObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GPIsPass=1
						ELSE
					 	 SET @GPIsPass=0
						END
				END
			  If(@SIsAbs=0 OR @SGPIsAbs=0)
				  BEGIN
				  set @GPIsAbs=0
				  END
			  Else
				  BEGIN
				  set @GPIsAbs=1
				  END
			END
		END	
	/*End S Config */


	/*O Config */
	set @GrandDivExamType=null
	Select @GrandDivExamType=GrandDivExamType,@GrandDivExamID=GrandDivExamId ,@MainExamPercent=DivExamPercentage From [dbo].[#Res_GrandConfig] Where [MainExamId]=@MainExamId AND [SubjectId]=@SubjectID AND [SubExamId]=@SubExamId AND [DivExamType]='O'  and GrandExamId=@GrandExamId
	If(@GrandDivExamType is not null)
		BEGIN
		
		IF Exists ( Select StudentIID From #Res_MainExamLeaveStudent)
		BEGIN
			SELECT TOP(1) @NumberOfExam=[NumberOfExam] From #Res_MainExamLeaveStudent
			Set @MainExamPercent=@TotalPersentage/@NumberOfExam
		END

		 SELECT  @GDivExamFullmarks=QG.DividedExamFullMarks,
		 @GDivExamExammarks=QG.DividedExamExamMarks,
		 @GDivIsPassDepENDed=QG.DividedExamIsPassDepEND,
		 @GDivPassIspercentage=QG.DividedExamPassMarkIsPercent,  
		 @GDivPassMark=QG.DividedExamPassMarks, 
		 @GDivExamType=QG.DividedExamType,
		 @GSubExamFullMark=QG.SubExamFullMarks,
		 @GSubExamExamMark=QG.SubExamExamMarks,
		 @GSubIsPassDepENDed=QG.SubExamIsPassDepEND,
		 @GSubPassIspercentage=QG.SubExamPassMarkIsPercent,
		 @GSubPassMark=QG.SubExamPassMark
		 FROM #Qry_GrandMarkSetup QG
		 WHERE QG.GrandExamId = @GrandExamId AND QG.SubExamId = @GrandSubExamID AND QG.DividedExamID = @GrandDivExamID AND QG.ExamSubjectID = @SubjectID 
		PRINt 'err' print @GrandDivExamID PRINT @SubjectID
		 Select 
		@OObt=(ObjectiveObt*@MainExamPercent)/100,@OIsAbs=ObjectiveIsAbsent
		From [dbo].[#Res_MEResultDetails] MERD where MainExamId=@MainExamId AND SubjectID=@SubjectID AND SubExamId=@SubExamId  AND StudentIID=@StudentIID

		 If(@GrandDivExamType='W1')
			BEGIN
			 set @GWObt1=dbo.ConvertMarks((@OObt +@SGWObt1),@BodyCalculationRule)
			  Set @GWFrac1=(@GDivExamFullmarks*@GWObt1)/@GDivExamExammarks;
			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv1=dbo.ConvertMarks((@GWObt1*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv1=@GWObt1
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt1>=@GDivPassMark)
						 SET @GWIsPass1=1
						ELSE
						 SET @GWIsPass1=0
					End
				 ELSE
						Begin
						If(((100*@GWObt1)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass1=1
						ELSE
					 	 SET @GWIsPass1=0
						END
				END
			  If(@OIsAbs=0 OR @SGWIsAbs1=0)
				  BEGIN
				  set @GWIsAbs1=0
				  END
			  Else
				  BEGIN
				  set @GWIsAbs1=1
				  END
			END
		else If(@GrandDivExamType='W2')
			BEGIN
			 set @GWObt2=dbo.ConvertMarks((@OObt +@SGWObt2),@BodyCalculationRule)
			   Set @GWFrac2=(@GDivExamFullmarks*@GWObt2)/@GDivExamExammarks;
			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv2=dbo.ConvertMarks((@GWObt2*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv2=@GWObt2
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt2>=@GDivPassMark)
						 SET @GWIsPass2=1
						ELSE
						 SET @GWIsPass2=0
					End
				 ELSE
						Begin
						If(((100*@GWObt2)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass2=1
						ELSE
					 	 SET @GWIsPass2=0
						END
				END
			  If(@OIsAbs=0 OR @SGWIsAbs2=0)
				  BEGIN
				  set @GWIsAbs2=0
				  END
			  Else
				  BEGIN
				  set @GWIsAbs2=1
				  END
			END
		else If(@GrandDivExamType='W3')
			BEGIN
			 set @GWObt3=dbo.ConvertMarks((@OObt +@SGWObt3),@BodyCalculationRule)
			  Set @GWFrac3=(@GDivExamFullmarks*@GWObt3)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv3=dbo.ConvertMarks((@GWObt3*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv3=@GWObt3
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt3>=@GDivPassMark)
						 SET @GWIsPass3=1
						ELSE
						 SET @GWIsPass3=0
					End
				 ELSE
						Begin
						If(((100*@GWObt3)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass3=1
						ELSE
					 	 SET @GWIsPass3=0
						END
				END
			  If(@OIsAbs=0 OR @SGWIsAbs3=0)
				  BEGIN
				  set @GWIsAbs3=0
				  END
			  Else
				  BEGIN
				  set @GWIsAbs3=1
				  END
			END
		else If(@GrandDivExamType='S')
			BEGIN
			 set @GSObt=dbo.ConvertMarks((@OObt +@SGSObt),@BodyCalculationRule)
			  Set @GOFrac=(@GDivExamFullmarks*@GOObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GSConv=dbo.ConvertMarks((@GOObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GOConv=@GOObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GOObt>=@GDivPassMark)
						 SET @GSIsPass=1
						ELSE
						 SET @GSIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GOObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GSIsPass=1
						ELSE
					 	 SET @GSIsPass=0
						END
				END
			  If(@OIsAbs=0 OR @SGOIsAbs=0)
				  BEGIN
				  set @GOIsAbs=0
				  END
			  Else
				  BEGIN
				  set @GOIsAbs=1
				  END
			END
		else If(@GrandDivExamType='O')
			BEGIN
			--print 'calpit ' PRINT @GDivExamExammarks
			 set @GOObt=dbo.ConvertMarks((@OObt +@SGOObt),@BodyCalculationRule)
			 Set @GOFrac=(@GDivExamFullmarks*@GOObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GOConv=dbo.ConvertMarks((@GOObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GOConv=@GOObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GOObt>=@GDivPassMark)
						 SET @GOIsPass=1
						ELSE
						 SET @GOIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GOObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GOIsPass=1
						ELSE
					 	 SET @GOIsPass=0
						END
				END
			  If(@OIsAbs=0 OR @SGOIsAbs=0)
				  BEGIN
				  set @GOIsAbs=0
				  END
			  Else
				  BEGIN
				  set @GOIsAbs=1
				  END
			END
		else If(@GrandDivExamType='P')
			BEGIN
			 set @GPObt=dbo.ConvertMarks((@OObt +@SGPObt),@BodyCalculationRule)
			  Set @GPFrac=(@GDivExamFullmarks*@GPObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GPConv=dbo.ConvertMarks((@GPObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GPConv=@GPObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GPObt>=@GDivPassMark)
						 SET @GPIsPass=1
						ELSE
						 SET @GPIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GPObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GPIsPass=1
						ELSE
					 	 SET @GPIsPass=0
						END
				END
			  If(@OIsAbs=0 OR @SGPIsAbs=0)
				  BEGIN
				  set @GPIsAbs=0
				  END
			  Else
				  BEGIN
				  set @GPIsAbs=1
				  END
			END
		END	
	/*End O Config */


	/*P Config */
	set @GrandDivExamType=null
	Select @GrandDivExamType=GrandDivExamType,@GrandDivExamID=GrandDivExamId ,@MainExamPercent=DivExamPercentage From [dbo].[#Res_GrandConfig] Where [MainExamId]=@MainExamId AND [SubjectId]=@SubjectID AND [SubExamId]=@SubExamId AND [DivExamType]='P'  and GrandExamId=@GrandExamId
	If(@GrandDivExamType is not null)
		BEGIN

		IF Exists ( Select StudentIID From #Res_MainExamLeaveStudent)
		BEGIN
			SELECT TOP(1) @NumberOfExam=[NumberOfExam] From #Res_MainExamLeaveStudent
			Set @MainExamPercent=@TotalPersentage/@NumberOfExam
		END

		 SELECT  @GDivExamFullmarks=QG.DividedExamFullMarks,
		 @GDivExamExammarks=QG.DividedExamExamMarks,
		 @GDivIsPassDepENDed=QG.DividedExamIsPassDepEND,
		 @GDivPassIspercentage=QG.DividedExamPassMarkIsPercent,  
		 @GDivPassMark=QG.DividedExamPassMarks, 
		 @GDivExamType=QG.DividedExamType,
		 @GSubExamFullMark=QG.SubExamFullMarks,
		 @GSubExamExamMark=QG.SubExamExamMarks,
		 @GSubIsPassDepENDed=QG.SubExamIsPassDepEND,
		 @GSubPassIspercentage=QG.SubExamPassMarkIsPercent,
		 @GSubPassMark=QG.SubExamPassMark
		 FROM #Qry_GrandMarkSetup QG
		 WHERE QG.GrandExamId = @GrandExamId AND QG.SubExamId = @GrandSubExamID AND QG.DividedExamID = @GrandDivExamID AND QG.ExamSubjectID = @SubjectID 

	    Select 
		@PObt=(PracticalObt*@MainExamPercent)/100 ,@SIsAbs=PracticalIsAbsent
		From [dbo].[#Res_MEResultDetails] MERD where MainExamId=@MainExamId AND SubjectID=@SubjectID AND SubExamId=@SubExamId  AND StudentIID=@StudentIID

		 If(@GrandDivExamType='W1')
			BEGIN
			 set @GWObt1=dbo.ConvertMarks((@PObt +@SGWObt1),@BodyCalculationRule)
			  Set @GWFrac1=(@GDivExamFullmarks*@GWObt1)/@GDivExamExammarks;
			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv1=dbo.ConvertMarks((@GWObt1*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv1=@GWObt1
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt1>=@GDivPassMark)
						 SET @GWIsPass1=1
						ELSE
						 SET @GWIsPass1=0
					End
				 ELSE
						Begin
						If(((100*@GWObt1)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass1=1
						ELSE
					 	 SET @GWIsPass1=0
						END
				END
			  If(@PIsAbs=0 OR @SGWIsAbs1=0)
				  BEGIN
				  set @GWIsAbs1=0
				  END
			  Else
				  BEGIN
				  set @GWIsAbs1=1
				  END
			END
		else If(@GrandDivExamType='W2')
			BEGIN
			 set @GWObt2=dbo.ConvertMarks((@PObt +@SGWObt2),@BodyCalculationRule)
			   Set @GWFrac2=(@GDivExamFullmarks*@GWObt2)/@GDivExamExammarks;
			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv2=dbo.ConvertMarks((@GWObt2*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv2=@GWObt2
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt2>=@GDivPassMark)
						 SET @GWIsPass2=1
						ELSE
						 SET @GWIsPass2=0
					End
				 ELSE
						Begin
						If(((100*@GWObt2)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass2=1
						ELSE
					 	 SET @GWIsPass2=0
						END
				END
			  If(@PIsAbs=0 OR @SGWIsAbs2=0)
				  BEGIN
				  set @GWIsAbs2=0
				  END
			  Else
				  BEGIN
				  set @GWIsAbs2=1
				  END
			END
		else If(@GrandDivExamType='W3')
			BEGIN
			 set @GWObt3=dbo.ConvertMarks((@PObt +@SGWObt3),@BodyCalculationRule)
			  Set @GWFrac3=(@GDivExamFullmarks*@GWObt3)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GWConv3=dbo.ConvertMarks((@GWObt3*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GWConv3=@GWObt3
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GWObt3>=@GDivPassMark)
						 SET @GWIsPass2=1
						ELSE
						 SET @GWIsPass2=0
					End
				 ELSE
						Begin
						If(((100*@GWObt3)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GWIsPass2=1
						ELSE
					 	 SET @GWIsPass2=0
						END
				END
			  If(@PIsAbs=0 OR @SGWIsAbs3=0)
				  BEGIN
				  set @GWIsAbs3=0
				  END
			  Else
				  BEGIN
				  set @GWIsAbs3=1
				  END
			END
		else If(@GrandDivExamType='S')
			BEGIN
			 set @GSObt=dbo.ConvertMarks((@PObt +@SGSObt),@BodyCalculationRule)
			  Set @GOFrac=(@GDivExamFullmarks*@GOObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GSConv=dbo.ConvertMarks((@GOObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GOConv=@GOObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GOObt>=@GDivPassMark)
						 SET @GSIsPass=1
						ELSE
						 SET @GSIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GOObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GSIsPass=1
						ELSE
					 	 SET @GSIsPass=0
						END
				END
			  If(@PIsAbs=0 OR @SGOIsAbs=0)
				  BEGIN
				  set @GOIsAbs=0
				  END
			  Else
				  BEGIN
				  set @GOIsAbs=1
				  END
			END
		else If(@GrandDivExamType='O')
			BEGIN
			 set @GOObt=dbo.ConvertMarks((@PObt +@SGOObt),@BodyCalculationRule)
			 Set @GOFrac=(@GDivExamFullmarks*@GOObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GOConv=dbo.ConvertMarks((@GOObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GOConv=@GOObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GOObt>=@GDivPassMark)
						 SET @GOIsPass=1
						ELSE
						 SET @GOIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GOObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GOIsPass=1
						ELSE
					 	 SET @GOIsPass=0
						END
				END
			  If(@PIsAbs=0 OR @SGOIsAbs=0)
				  BEGIN
				  set @GOIsAbs=0
				  END
			  Else
				  BEGIN
				  set @GOIsAbs=1
				  END
			END
		else If(@GrandDivExamType='P')
			BEGIN
			 set @GPObt=dbo.ConvertMarks((@PObt +@SGPObt),@BodyCalculationRule)
			  Set @GPFrac=(@GDivExamFullmarks*@GPObt)/@GDivExamExammarks;

			  If(@GDivExamFullmarks != @GDivExamExammarks)
				   Begin
					 SELECT @GPConv=dbo.ConvertMarks((@GPObt*@GDivExamFullmarks)/@GDivExamExammarks,@BodyCalculationRule)
				   End
			   else 
				  Begin
				   SET @GPConv=@GPObt
				  END
              if(@GDivIsPassDepENDed=1)
				Begin
				 If(@GDivPassIspercentage=0)
					Begin
						If(@GPObt>=@GDivPassMark)
						 SET @GPIsPass=1
						ELSE
						 SET @GPIsPass=0
					End
				 ELSE
						Begin
						If(((100*@GPObt)/@GDivExamExammarks)>=@GDivPassMark)
						 SET @GPIsPass=1
						ELSE
					 	 SET @GPIsPass=0
						END
				END
			  If(@PIsAbs=0 OR @SGPIsAbs=0)
				  BEGIN
				  set @GPIsAbs=0
				  END
			  Else
				  BEGIN
				  set @GPIsAbs=1
				  END
			END
		END	
	/*End P Config */
	select * from dbo.Ins_ClassInfo
	SET @GSubExamTotalObt=@GWConv1+@GWConv2+@GWConv3+@GSConv+@GOConv+@GPConv;
	If(@DBname in ('sshs_new_2018') and(select ClassId from Ins_ClassInfo where ClassId in (9,10,11,12) ) is null)
			Begin
    			SET @GSubExamTotalObt=@GWConv2+@GWConv3+@GSConv+@GOConv+@GPConv;

	
						 DECLARE @GCTFullMark decimal(8,2)=0, @GCTExamMark decimal(8,2)=0

						    SELECT  @GCTFullMark=QG.DividedExamFullMarks,
							 @GCTExamMark=QG.DividedExamExamMarks
							 FROM #Qry_GrandMarkSetup QG
							 WHERE QG.GrandExamId = @GrandExamId AND QG.SubExamId = @GrandSubExamID AND QG.DividedExamType = 'W1' AND QG.ExamSubjectID = @SubjectID 

							 set @GSubExamFullMark=@GSubExamFullMark-@GCTFullMark
							 set @GSubExamExamMark=@GSubExamExamMark-@GCTExamMark

			End
	SET @GSubExamTotalFrac=((@GSubExamTotalObt*@GSubExamFullMark)/@GSubExamExamMark)
	SET @GSubExamOriginalTotalObt=@GWObt1+@GWObt2+@GWObt3+@GSObt+@GOObt+@GPObt;

	--print '@@@GSubExamTotalObt:' print @GSubExamTotalObt
	--print '@@GSubExamFullMark:' print @GSubExamFullMark
	--print '@@GSubExamExamMark:' print @GSubExamExamMark
	--print '@GSubExamTotalFrac:' print @GSubExamTotalFrac
	

IF(@GSubExamFullMark != @GSubExamExamMark)
	   Begin
		 SELECT @GSubExamTotalConv=dbo.ConvertMarks((@GSubExamTotalObt*@GSubExamFullMark)/@GSubExamExamMark,@BodyCalculationRule)
		End
	else 
	  Begin
	   SET @GSubExamTotalConv=@GSubExamTotalObt
	  END

	  print '@@@@GSConv:' print @GSConv
	   print '@@@@GSubExamTotalConv:' print @GSubExamTotalConv

If(@GSubIsPassDepENDed=1)
	Begin
	If(@GSubPassIspercentage=0)
		Begin
			If(@GSubExamTotalObt>=@GSubPassMark)
			 SET @GSubExamIsPass=1
			ELSE
			 SET @GSubExamIsPass=0
		End

	ELSE
		Begin
			If(((100*@GSubExamTotalObt)/@GSubExamExamMark)>=@GSubPassMark)
			SET @GSubExamIsPass=1
			ELSE
			SET @GSubExamIsPass=0
		End
		If(@DBname in ('mths_new_2018'))
		BEGIN
		If(@GSubPassIspercentage=0)
		Begin
			If(@GSubExamTotalConv>=@GSubPassMark)
			 SET @GSubExamIsPass=1
			ELSE
			 SET @GSubExamIsPass=0
		End
	ELSE
		Begin
			If(((100*@GSubExamTotalConv)/@GSubExamExamMark)>=@GSubPassMark)
			SET @GSubExamIsPass=1
			ELSE
			SET @GSubExamIsPass=0
		End
		END
		End
  If(@GWIsPass1=0 OR @GWIsPass2=0 OR @GWIsPass3=0 OR @GSIsPass=0 OR @GOIsPass=0 OR @GPIsPass=0)
		BEGIN
		  SET @GSubExamIsPass=0
		END

 If(@GWIsAbs1=0 OR @GWIsAbs2=0 or @GWIsAbs3=0 OR @GSIsAbs=0 or @GOIsAbs=0 OR @GPIsAbs=0)
				  BEGIN
				  set 	@GSubExamIsAbsent=0
				  END
			  Else
				  BEGIN
				  set 	@GSubExamIsAbsent=1
				  END	
		
	SET @SOPTotalObt=@GSObt + @GOObt + @GPObt
	SET @SOPTotalConv=@GSConv + @GOConv + @GPConv
	SET @SOPTotalFrac=@GSFrac + @GOFrac + @GPFrac


	Update  [dbo].[Res_GrandResultMarksDetails]
				 
			  set
			   [WrittenObt1]=@GWObt1
			  ,[WrittenConv1]=@GWConv1
			  ,[WrittenFrac1]=@GWFrac1
			  ,[WrittenIsPass1]=@GWIsPass1
			  ,[WrittenIsAbsent1]=@GWIsAbs1
			  ,[WrittenObt2]=@GWObt2
			  ,[WrittenConv2]=@GWConv2
			  ,[WrittenFrac2]=@GWFrac2
			  ,[WrittenIsPass2]=@GWIsPass2
			  ,[WrittenIsAbsent2]=@GWIsAbs2
			  ,[WrittenObt3]=@GWObt3
			  ,[WrittenConv3]=@GWConv3
			  ,[WrittenFrac3]=@GWFrac3
			  ,[WrittenIsPass3]=@GWIsPass3
			  ,[WrittenIsAbsent3]=@GWIsAbs3
			  ,[SubjectiveObt]=@GSObt
			  ,[SubjectiveConv]=@GSConv
			  ,[SubjectiveFrac]=@GSFrac
			  ,[SubjectiveIsPass]=@GSIsPass
			  ,[SubjectiveIsAbsent]=@GSIsAbs
			  ,[ObjectiveObt]=@GOObt
			  ,[ObjectiveConv]=@GOConv
			  ,[ObjectiveFrac]=@GOFrac
			  ,[ObjectiveIsPass]=@GOIsPass
			  ,[ObjectiveIsAbsent]=@GOIsAbs
			  ,[PracticalObt]=@GPObt
			  ,[PracticalConv]=@GPConv
			  ,[PracticalFrac]=@GPFrac
			  ,[PracticalIsPass]=@GPIsPass
			  ,[PracticalIsAbsent]=@GPIsAbs
			  ,[SubExamTotalObt]=@GSubExamTotalObt
			  ,[SubExamTotalConv]=@GSubExamTotalConv
			  ,[SubExamTotalFrac]=@GSubExamTotalFrac
			  ,[SubExamIsPass]=@GSubExamIsPass
			  ,[SubExamIsAbsent]=@GSubExamIsAbsent 
			  ,[SubExamOriginalTotalObt]=@GSubExamOriginalTotalObt
			  ,SOPTotalObt = @SOPTotalObt
			  ,SOPTotalConv = @SOPTotalConv
			  ,SOPTotalFrac = @SOPTotalFrac

			   where  [SubjectID]=@SubjectID AND [GrandExamId]=@GrandExamId AND [GrandSubExamId]=@GrandSubExamID AND [StudentIID]=@StudentIID 
	
	 END
   Drop Table #Res_MEResultDetails
   Drop Table #Res_GrandConfig
   Drop Table #Qry_GrandMarkSetup
END