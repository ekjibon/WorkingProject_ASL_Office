/****** Object:  StoredProcedure [dbo].[GetAllSubject]    Script Date: 7/22/2017 4:07:49 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetByPassStudentList]'))
BEGIN
DROP PROCEDURE  GetByPassStudentList
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[GetByPassStudentList] --  GetByPassStudentList 1,6,null,null,8,0,null,null,0,0,1,0,0
(

@SessionId int =NULL,
@BranchID int =NULL,
@ShiftID int =NULL,
@ClassId int =NULL,

@SectionId int =NULL,
@StudentInsID nvarchar(150)=NULL,
@ByGrand BIT,
@OverAllMerit BIT,
@ShiftWiseMerit BIT,
@ClassWiseMerit BIT,
@SectionWiseMerit BIT,
@ExamId INT
)
AS
BEGIN
	IF(@ByGrand=1)
	BEGIN
		DECLARE @GrandExamId INT
		SET @GrandExamId=@ExamId;	
	SELECT DISTINCT [Student_BasicInfo].[StudentIID]
		  ,[VersionID]
		  ,[SessionId]
		  ,[BranchID]
		  ,[ShiftID]
		  ,[ClassId]
		  ,[GroupId]
		  ,[SectionId]
		  ,[StudentInsID]
		  ,[Student_BasicInfo].[RollNo]
		  --,[PromotedRollNo]
		  ,CASE WHEN @OverAllMerit =1 then [OverAllMerit]
				 WHEN @ShiftWiseMerit =1 then [ShiftWiseMerit]
				 WHEN @ClassWiseMerit =1 then [ClassWiseMerit]	
				 ELSE @SectionWiseMerit
				 END  [Merit]
		  ,[OverAllMerit]
		  ,[SectionWiseMerit]
          ,[ShiftWiseMerit]
          ,[ClassWiseMerit]		 
		  ,[FullName]		 
		  ,[FatherName]
		  ,[MotherName]
		  ,[SMSNotificationNo] 
		  ,[Remarks]
		  ,CONVERT(BIT,0 )AS promote  
	  FROM [Student_BasicInfo] 
	  INNER JOIN [Res_GrandResult] ON [Student_BasicInfo].StudentIID=[Res_GrandResult].StudentIID
	  WHERE	GrandExamId=@GrandExamId

			AND	[SessionId]=isnull(@SessionId,[SessionId])
			AND [BranchID]=isnull(@BranchID,[BranchID])
			AND	[ShiftID]=isnull(@ShiftID,[ShiftID])
			AND [ClassId]=isnull(@ClassId,[ClassId])

			AND	[SectionId]=isnull(@SectionId, [SectionId])
			AND [StudentInsID]=isnull(@StudentInsID, [StudentInsID])
			AND [IsDeleted]=0	
			ORDER BY
			CASE WHEN @OverAllMerit =1 then [OverAllMerit]
				 WHEN @ShiftWiseMerit =1 then [ShiftWiseMerit]
				 WHEN @ClassWiseMerit =1 then [ClassWiseMerit]	
				 ELSE @SectionWiseMerit
				 END
	END
	ELSE
	BEGIN
		DECLARE @MainExamId INT
		SET @MainExamId=@ExamId
		SELECT DISTINCT [Student_BasicInfo].[StudentIID]

		  ,[SessionId]
		  ,[BranchID]
		  ,[ShiftID]
		  ,[ClassId]

		  ,[SectionId]
		  ,[StudentInsID]
	      ,[Student_BasicInfo].[RollNo]
		   --,[PromotedRollNo]
		  ,CASE WHEN @OverAllMerit =1 then [OverAllMerit]
				 WHEN @ShiftWiseMerit =1 then [ShiftWiseMerit]
				 WHEN @ClassWiseMerit =1 then [ClassWiseMerit]	
				 ELSE @SectionWiseMerit
				 END  [Merit]
		  ,[OverAllMerit]
		  ,[SectionWiseMerit]
          ,[ShiftWiseMerit]
          ,[ClassWiseMerit]		  
		  ,[FullName]		  
		  ,[FatherName]
		  ,[MotherName]
		  ,[SMSNotificationNo]
		  ,[Remarks]
		  ,CONVERT(BIT,0 ) AS promote 
	  FROM [Student_BasicInfo] 
	  INNER JOIN [Res_MainExamResult] ON [Student_BasicInfo].StudentIID=[Res_MainExamResult].StudentIID
	  WHERE MainExamId=@MainExamId 

			AND	[SessionId]=isnull(@SessionId,[SessionId])
			AND [BranchID]=isnull(@BranchID,[BranchID])
			AND	[ShiftID]=isnull(@ShiftID,[ShiftID])
			AND [ClassId]=isnull(@ClassId,[ClassId])

			AND	[SectionId]=isnull(@SectionId, [SectionId])
			AND [StudentInsID]=isnull(@StudentInsID, [StudentInsID])
			AND [IsDeleted]=0
			ORDER BY
		    CASE WHEN @OverAllMerit =1 then [OverAllMerit]
				 WHEN @ShiftWiseMerit =1 then [ShiftWiseMerit]
				 WHEN @ClassWiseMerit =1 then [ClassWiseMerit]	
				 ELSE @SectionWiseMerit
				 END
	END
END

