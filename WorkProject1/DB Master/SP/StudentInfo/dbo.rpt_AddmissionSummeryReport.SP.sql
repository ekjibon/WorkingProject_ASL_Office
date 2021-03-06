/****** Object:  StoredProcedure [dbo].[rpt_AddmissionSummeryReport]    Script Date: 7/22/2017 4:37:23 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rpt_AddmissionSummeryReport]'))
BEGIN
DROP PROCEDURE  rpt_AddmissionSummeryReport
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[rpt_AddmissionSummeryReport]
	
AS
BEGIN

CREATE TABLE #temp (
ClassId INT,
SectionId INT,
StudentTypeID INT,
NoOfstudent INT,
[Status] VARCHAR(50),
[StatusSerial] INT
)

	INSERT INTO #temp 
	SELECT SB.ClassId, SB.SectionId,Sb.StudentTypeID,COUNT(  SB.ClassId ),'New Addmission',1
	FROM   dbo.Student_BasicInfo SB WHERE SB.AddmissionStatus = 'N'
	GROUP BY SB.ClassId , SB.SectionId,Sb.StudentTypeID 

	INSERT INTO #temp 
	SELECT SB.ClassId, SB.SectionId,Sb.StudentTypeID,COUNT(  SB.ClassId ),'Re- Admission',2
	FROM   dbo.Student_BasicInfo SB WHERE SB.AddmissionStatus = 'R'
	GROUP BY SB.ClassId , SB.SectionId,Sb.StudentTypeID 

	INSERT INTO #temp 
	SELECT SB.ClassId, SB.SectionId,Sb.StudentTypeID,COUNT(  SB.ClassId ),'Inactive (TC)',3
	FROM   dbo.Student_BasicInfo SB WHERE SB.Status = 'ITC' AND IsTC = 1
	GROUP BY SB.ClassId , SB.SectionId,Sb.StudentTypeID
	
	INSERT INTO #temp 
	SELECT SB.ClassId, SB.SectionId,Sb.StudentTypeID,COUNT(  SB.ClassId ),'Inactive',4
	FROM   dbo.Student_BasicInfo SB WHERE SB.Status = 'I' 
	GROUP BY SB.ClassId , SB.SectionId,Sb.StudentTypeID 

	INSERT INTO #temp 
	SELECT SB.ClassId, SB.SectionId,Sb.StudentTypeID,COUNT(  SB.ClassId ),'Active',5
	FROM   dbo.Student_BasicInfo SB WHERE SB.Status = 'A' 
	GROUP BY SB.ClassId , SB.SectionId,Sb.StudentTypeID

SELECT CL.ClassName,SE.SectionName, T.* ,  TY.StudentTypeName FROM #temp T
INNER JOIN Ins_ClassInfo CL ON CL.ClassId = T.ClassId
INNER JOIN Ins_Section SE ON SE.SectionId = T.SectionId 
INNER JOIN Ins_StudentType TY ON TY.StudentTypeId = T.StudentTypeID
ORDER BY T.ClassId

DROP TABLE #temp
		
END

-- EXEC rpt_AddmissionSummeryReport 
