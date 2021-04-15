/****** Object:  StoredProcedure [dbo].[rptStatisticaData]    Script Date: 7/22/2017 4:15:28 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptTotListReport]'))
BEGIN
DROP PROCEDURE  [rptTotListReport]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROC [dbo].[rptTotListReport] -- EXEC [rptTotListReport] 1,3,3,6,11,1,30
	@VersionId INT =null,
	@SessionId INT =null,
	@BranchId INT =null,
	@ShiftId INT =null,
	@ClassId INT =null,
	@GroupId INT =null,
	@SectionId INT =null

AS

	SELECT 
		   SS.StudentIID,
		   STUFF((SELECT ', ' + convert(varchar(500),S.SubjectName)
				  FROM [Res_StudentSubject] US INNER JOIN [Res_SubjectSetup] AS S ON US.SubjectID=S.SubID
				  WHERE US.StudentID = SS.StudentIID
				  FOR XML PATH('')), 1, 1, '') [SUBJECT]
		INTO #SUBJECTNAME FROM [Student_BasicInfo] SS 
		GROUP BY SS.StudentIID, SS.FullName
	ORDER BY 1
	SELECT 
	   SS.StudentIID,
	   STUFF((SELECT ', ' + convert(varchar(500),S.SubjectCode)
			  FROM [Res_StudentSubject] US INNER JOIN [Res_SubjectSetup] AS S ON US.SubjectID=S.SubID
			  WHERE US.StudentID = SS.StudentIID
			  FOR XML PATH('')), 1, 1, '') [SUBJECT CODE]
	INTO #SUBJECTCODE FROM [Student_BasicInfo] SS 
	GROUP BY SS.StudentIID, SS.FullName
	ORDER BY 1
	SELECT S.[StudentID]
		   ,SS.SubjectName
		  , SS.SubjectCode
		  ,[OptionalType]     
	 INTO #OptionalSubject  FROM [dbo].[Res_StudentSubject] AS S
	 LEFT JOIN [dbo].[Res_SubjectSetup] AS SS ON S.SubjectID=SS.SubID WHERE S.[OptionalType] ='FT' 
	SELECT B.FullName, B.FatherName, B.MotherName, B.DateOfBirth, B.Gender, B.RollNo,SI.Photo,
	 V.SessionName,V.ShiftName, V.GroupName,V.VersionName,V.BranchName, O.SubjectName+'('+O.SubjectCode+')' AS OptionalSubjectAndCode, N.[SUBJECT] as ComSubjectName, C.[SUBJECT CODE] as SUBJECTCODE  
	  FROM [dbo].[Student_BasicInfo] AS B INNER JOIN view_CommonTableNames AS V ON B.ClassId=V.ClassId AND B.VersionID=V.VersionId
	 AND B.SessionId=V.SessionId AND B.BranchID=V.BranchId AND B.ShiftID=V.ShiftId AND B.GroupId=V.GroupId AND B.SectionId=V.SectionId
	 LEFT JOIN #SUBJECTNAME AS N ON B.StudentIID=N.StudentIID INNER JOIN #SUBJECTCODE AS C ON B.StudentIID=C.StudentIID
	 LEFT JOIN #OptionalSubject AS O ON B.StudentIID=O.StudentID
	 LEFT JOIN [dbo].[Student_Image] AS SI ON B.StudentIID = SI.StudentIID

	 WHERE B.VersionID = @VersionId AND B.SessionId = @SessionId AND B.BranchID = @BranchId AND B.ShiftID = @ShiftId 
	 AND B.ClassId = @ClassId AND B.GroupId = @GroupId AND B.SectionId = @SectionId
	 DROP TABLE #SUBJECTNAME,#SUBJECTCODE,#OptionalSubject