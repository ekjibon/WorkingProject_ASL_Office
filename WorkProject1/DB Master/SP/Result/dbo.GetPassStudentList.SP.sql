/****** Object:  StoredProcedure [dbo].[GetAllSubject]    Script Date: 7/22/2017 4:07:49 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetPassStudentList]'))
BEGIN
DROP PROCEDURE  GetPassStudentList
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetPassStudentList] --  GetPassStudentList 6,null,null,8,0,null,0,0,1,0,0
(

@SessionId int =NULL,--0
@BranchID int =NULL, --1
@ShiftID int =NULL, --2
@ClassId int =NULL,  --3

@SectionId int =NULL, --4
@StudentInsID nvarchar(150)=NULL, --5
@ByGrand BIT, --6
@OverAllMerit BIT, --7
@ShiftWiseMerit BIT, --8
@ClassWiseMerit BIT, --9
@SectionWiseMerit BIT, --10
@ExamId INT  --11
)
AS
BEGIN
	IF(@ByGrand=1)
	BEGIN
		DECLARE @GrandExamId INT
		SET @GrandExamId=@ExamId;
	SELECT DISTINCT [Student_BasicInfo].[StudentIID]
		
		  ,[SessionId]
		  ,[BranchID]
		  ,[ShiftID]
		  ,[ClassId]

		  ,[SectionId]
		  ,[StudentInsID]
		  ,[Student_BasicInfo].[RollNo]
		  -- What about based on merit list 
		  ,CASE WHEN @OverAllMerit =1 then [OverAllMerit] -- On OverAll  or Shift Wise  or Class Wise  either Section Wise
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
	  INNER JOIN [Res_GrandResult] ON [Student_BasicInfo].StudentIID=[Res_GrandResult].StudentIID AND [Res_GrandResult].IsPass=1
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
	  INNER JOIN [Res_MainExamResult] ON [Student_BasicInfo].StudentIID=[Res_MainExamResult].StudentIID AND [Res_MainExamResult].IsPass=1
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

