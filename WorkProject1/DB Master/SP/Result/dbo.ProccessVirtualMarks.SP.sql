/****** Object:  StoredProcedure [dbo].[ProccessSubjectMarks]    Script Date: 7/22/2017 4:26:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ProccessVirtualMarks]'))
BEGIN
DROP PROCEDURE  ProccessVirtualMarks
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 -- Execute ProccessVirtualMarks 1,4,2,4,1,111

Create PROCEDURE [dbo].[ProccessVirtualMarks]  
	( 
	@VersionId int ,
	@SessionId int ,
	@ShiftId	INT ,
	@ClassId int ,
	@GroupId int ,
	@MainExamId int
	)
AS
BEGIN



DECLARE @SubjectIsPass bit=1 ,
 		@StudentIID int,
		@SubjectID int


/*For Subject*/
 DECLARE @COUNTERMarksDetails INT=1, @MAXIDMarksDetails INT 
 CREATE TABLE #TempMarksDetails(
    [MarksDetailsID] [int] IDENTITY(1,1) NOT NULL,
	[StudentIID] [bigint] NOT NULL,
	[MainExamID] [int] NOT NULL,
	[SubjectID] [int] NOT NULL
	)

	

 INSERT INTO #TempMarksDetails
   SELECT M.[StudentIID],M.[MainExamID],M.[SubjectID] From Res_MEResultDetails  M INNER JOIN [dbo].[Student_BasicInfo] S ON S.[StudentIID] = M.[StudentIID]
    where M.[MainExamID]=@MainExamId AND S.ShiftId = @ShiftId  GROUP BY M.[StudentIID],M.[MainExamID],M.[SubjectID] ORDER BY M.StudentIID

SELECT @MAXIDMarksDetails = COUNT(*) FROM #TempMarksDetails

CREATE TABLE #Res_MEResultDetails(
    [MarksDetailsID] [int] IDENTITY(1,1) NOT NULL,
	[StudentIID] [bigint] NOT NULL,
	[MainExamID] [int] NOT NULL,
	[SubjectID] [int] NOT NULL,
	[SubExamId] [int] NOT NULL,
	[WrittenConv1] [decimal](8, 2) NOT NULL,
	[WrittenConv2] [decimal](8, 2) NOT NULL,
	[WrittenConv3] [decimal](8, 2) NOT NULL,
	[SubjectiveConv] [decimal](8, 2) NOT NULL,
	[ObjectiveConv] [decimal](8, 2) NOT NULL,
	[PracticalConv] [decimal](8, 2) NOT NULL,
	)

	INSERT INTO #Res_MEResultDetails
   SELECT M.[StudentIID],M.[MainExamID],M.[SubjectID],M.[SubExamId],
	M.[WrittenConv1],
	M.[WrittenConv2],
	M.[WrittenConv3],
	M.[SubjectiveConv],
	M.[ObjectiveConv],
	M.[PracticalConv] From Res_MEResultDetails  M INNER JOIN [dbo].[Student_BasicInfo] S ON S.[StudentIID] = M.[StudentIID]
    where M.[MainExamID]=@MainExamId AND S.ShiftId = @ShiftId 


 WHILE (@COUNTERMarksDetails <= @MAXIDMarksDetails)
  BEGIN
    SELECT @StudentIID =StudentIID,@SubjectID = SubjectID  FROM #TempMarksDetails WHERE MarksDetailsID = @COUNTERMarksDetails
	
	
	
	 DECLARE @GP decimal (8,2)=0
     DECLARE @GL VARCHAR(5)='T'
     SELECT @GP=SubjectGP,@GL=SubjectGL,@SubjectIsPass=SubjectIsPass from  [dbo].[Res_MainExamResultSubjectDetails] where StudentIID=@StudentIID and  MainExamID=@MainExamID and SubjectID=@SubjectID
   /* For Virtual */
	DECLARE @VTotal1 decimal(8,2)=0, @VTotal2 decimal(8,2)=0
	DECLARE @VirtualIsPass1 bit=1
    DECLARE @VirtualIsPass2 bit=1
	If Exists (select * from [dbo].[Res_VirtualExamSetup] VES where VES.VersionId=@VersionId and VES.SessionId=@SessionId and VES.ClassId=@ClassId and VES.GroupId=@GroupId and VES.MainExamID=@MainExamID and VES.SubjectID=@SubjectID)
	BEGIN
		DECLARE @VSubExamID int,@DivExamTypeVirtual1 varchar(80),@DivExamTypeVirtual2 varchar(80)

		DECLARE MYCURSOR CURSOR FOR  
		SELECT [SubExamID],[DivExamTypeVirtual1],[DivExamTypeVirtual2] from [dbo].[Res_VirtualExamSetup] VES where VES.VersionId=@VersionId and VES.SessionId=@SessionId and VES.ClassId=@ClassId and VES.GroupId=@GroupId and VES.MainExamID=@MainExamID and VES.SubjectID=@SubjectID
        
		OPEN MYCURSOR   
		FETCH NEXT FROM MYCURSOR INTO @VSubExamID, @DivExamTypeVirtual1,@DivExamTypeVirtual2   
		DECLARE @VirExamFullMark1 decimal(10,2),@VirExamFullMark2 decimal(8,2)
		SET @VTotal1 =0
		SET @VTotal2 =0
		SET @VirExamFullMark1=0
		SET @VirExamFullMark2=0

		Print @DivExamTypeVirtual1
		Print @DivExamTypeVirtual1

		WHILE @@FETCH_STATUS = 0   
		BEGIN  
			DECLARE @getmarks1 decimal(8,2),@getmarks2 decimal(8,2), @getExamFullMark1 decimal(8,2),@getExamFullMark2 decimal(8,2)
			set @getmarks1 =0
			set @getmarks2 =0
			set @getExamFullMark1=0
			set @getExamFullMark2=0
			If(@DivExamTypeVirtual1='W1')
			select @getmarks1=IsNull(RMED.[WrittenConv1],0) from [dbo].[#Res_MEResultDetails] RMED where RMED.MainExamId=@MainExamID and RMED.SubjectID=@SubjectID and RMED.SubExamId=@VSubExamID and RMED.StudentIID=@StudentIID
			else If(@DivExamTypeVirtual1='W2')
			select @getmarks1=IsNull(RMED.[WrittenConv2],0) from [dbo].[#Res_MEResultDetails] RMED where RMED.MainExamId=@MainExamID and RMED.SubjectID=@SubjectID and RMED.SubExamId=@VSubExamID and RMED.StudentIID=@StudentIID
			else If(@DivExamTypeVirtual1='W3')
			select @getmarks1=IsNull(RMED.[WrittenConv3],0) from [dbo].[#Res_MEResultDetails] RMED where RMED.MainExamId=@MainExamID and RMED.SubjectID=@SubjectID and RMED.SubExamId=@VSubExamID and RMED.StudentIID=@StudentIID
			else If(@DivExamTypeVirtual1='S')
			select @getmarks1=IsNull(RMED.SubjectiveConv,0) from [dbo].[#Res_MEResultDetails] RMED where RMED.MainExamId=@MainExamID and RMED.SubjectID=@SubjectID and RMED.SubExamId=@VSubExamID and RMED.StudentIID=@StudentIID
			else If(@DivExamTypeVirtual1='O')
			select @getmarks1=IsNull(RMED.ObjectiveConv,0) from [dbo].[#Res_MEResultDetails] RMED where RMED.MainExamId=@MainExamID and RMED.SubjectID=@SubjectID and RMED.SubExamId=@VSubExamID and RMED.StudentIID=@StudentIID
			else If(@DivExamTypeVirtual1='P')
			select @getmarks1=IsNull(RMED.PracticalConv,0) from [dbo].[#Res_MEResultDetails] RMED where RMED.MainExamId=@MainExamID and RMED.SubjectID=@SubjectID and RMED.SubExamId=@VSubExamID and RMED.StudentIID=@StudentIID
			SET @VTotal1 = @VTotal1 +@getmarks1

			Select @getExamFullMark1=QMS.[DividedExamFullMarks] from [dbo].[Qry_MarkSetup] AS QMS where QMS.[MainExamId]=@MainExamID and QMS.[MainExamSubjectID]=@SubjectID and QMS.[SubExamId]=@VSubExamID and QMS.DividedExamType=@DivExamTypeVirtual1
			SET @VirExamFullMark1= @VirExamFullMark1 + @getExamFullMark1


			If(@DivExamTypeVirtual2='W1')
			select @getmarks2=IsNull(RMED.[WrittenConv1],0) from [dbo].[#Res_MEResultDetails] RMED where RMED.MainExamId=@MainExamID and RMED.SubjectID=@SubjectID and RMED.SubExamId=@VSubExamID and RMED.StudentIID=@StudentIID
			else If(@DivExamTypeVirtual2='W2')
			select @getmarks2=IsNull(RMED.[WrittenConv2],0) from [dbo].[#Res_MEResultDetails] RMED where RMED.MainExamId=@MainExamID and RMED.SubjectID=@SubjectID and RMED.SubExamId=@VSubExamID and RMED.StudentIID=@StudentIID
			else If(@DivExamTypeVirtual2='W3')
			select @getmarks2=IsNull(RMED.[WrittenConv3],0) from [dbo].[#Res_MEResultDetails] RMED where RMED.MainExamId=@MainExamID and RMED.SubjectID=@SubjectID and RMED.SubExamId=@VSubExamID and RMED.StudentIID=@StudentIID
			else If(@DivExamTypeVirtual2='S')
			select @getmarks2=IsNull(RMED.SubjectiveConv,0) from [dbo].[#Res_MEResultDetails] RMED where RMED.MainExamId=@MainExamID and RMED.SubjectID=@SubjectID and RMED.SubExamId=@VSubExamID and RMED.StudentIID=@StudentIID
			else If(@DivExamTypeVirtual2='O')
			select @getmarks2=IsNull(RMED.ObjectiveConv,0) from [dbo].[#Res_MEResultDetails] RMED where RMED.MainExamId=@MainExamID and RMED.SubjectID=@SubjectID and RMED.SubExamId=@VSubExamID and RMED.StudentIID=@StudentIID
			else If(@DivExamTypeVirtual2='P')

			select @getmarks2=IsNull(RMED.PracticalConv,0) from [dbo].[#Res_MEResultDetails] RMED where RMED.MainExamId=@MainExamID and RMED.SubjectID=@SubjectID and RMED.SubExamId=@VSubExamID and RMED.StudentIID=@StudentIID
			SET @VTotal2 = @VTotal2 +@getmarks2

			Select @getExamFullMark2=QMS.[DividedExamFullMarks] from [dbo].[Qry_MarkSetup] AS QMS where QMS.[MainExamId]=@MainExamID and QMS.[MainExamSubjectID]=@SubjectID and QMS.[SubExamId]=@VSubExamID and QMS.DividedExamType=@DivExamTypeVirtual2
			SET @VirExamFullMark2= @VirExamFullMark2 + @getExamFullMark2


			FETCH NEXT FROM MYCURSOR INTO @VSubExamID, @DivExamTypeVirtual1,@DivExamTypeVirtual2 
		END   

		CLOSE MYCURSOR   
		DEALLOCATE MYCURSOR

		DECLARE @VirtualPassMark1 decimal(8,2)=0
		DECLARE @VirtualPassMark2 decimal(8,2)=0
	
		DECLARE @VirtualPassIsPercent1 bit=0
		DECLARE @VirtualPassIsPercent2 bit=0
		
		Select @VirtualIsPass1=VirtualIsPass1, @VirtualIsPass2=VirtualIsPass2, @SubjectIsPass=SubjectIsPass, @GP=SubjectGP From [dbo].[Res_MainExamResultSubjectDetails] where StudentIID=@StudentIID and  MainExamID=@MainExamID and SubjectID=@SubjectID

		select Top(1) @VirtualPassMark1=VES.VirtualPassMark1, @VirtualPassMark2=VES.VirtualPassMark2,@VirtualPassIsPercent1=VES.VirtualPassMarkIsPercent1 ,@VirtualPassIsPercent2=VES.VirtualPassMarkIsPercent2 
		from [dbo].[Res_VirtualExamSetup] VES where VES.VersionId=@VersionId and VES.SessionId=@SessionId and VES.ClassId=@ClassId and VES.GroupId=@GroupId and VES.MainExamID=@MainExamID and VES.SubjectID=@SubjectID
		
		if(@VirtualPassIsPercent1=1)
			BEGIN
				if(@VirtualPassMark1>(@VTotal1*100)/@VirExamFullMark1)
				BEGIN
					set @VirtualIsPass1=0
					set @SubjectIsPass=0
					select @GP=GP, @GL=GL from [dbo].[Res_GradingSystem] where IsFailGrade=1

	
				End

			END
		ELSE
			BEGIN
				if(@VirtualPassMark1>@VTotal1)
				BEGIN
					set @VirtualIsPass1=0
					set @SubjectIsPass=0
					select @GP=GP, @GL=GL from [dbo].[Res_GradingSystem] where IsFailGrade=1

	
				End
			END

		 if(@VirtualPassIsPercent2=1)
		 BEGIN
		 if(@VirtualPassMark2>(@VTotal2*100)/@VirExamFullMark2)
			BEGIN
				set @VirtualIsPass2=0
				set @SubjectIsPass=0
				select @GP=GP, @GL=GL from [dbo].[Res_GradingSystem] where IsFailGrade=1
	
			End
		 END
	 ELSE
		 BEGIN
			if(@VirtualPassMark2>@VTotal2)
			BEGIN
				set @VirtualIsPass2=0
				set @SubjectIsPass=0
				select @GP=GP, @GL=GL from [dbo].[Res_GradingSystem] where IsFailGrade=1
	
			End
		END

	End

	    Print @VTotal1
		Print @VTotal2
	Update [dbo].[Res_MainExamResultSubjectDetails] SET VirtualConvertedMarks1=@VTotal1,VirtualIsPass1=@VirtualIsPass1,VirtualConvertedMarks2=@VTotal2,VirtualIsPass2=@VirtualIsPass2 ,SubjectGP=@GP, SubjectGL=@GL,SubjectIsPass=@SubjectIsPass
	 where StudentIID=@StudentIID and  MainExamID=@MainExamID and SubjectID=@SubjectID

	/* End Virtual */

	
		   SET @COUNTERMarksDetails = @COUNTERMarksDetails + 1

		END

/*End Subject*/
Drop TABLE #Res_MEResultDetails
Drop TABLE #TempMarksDetails
END
