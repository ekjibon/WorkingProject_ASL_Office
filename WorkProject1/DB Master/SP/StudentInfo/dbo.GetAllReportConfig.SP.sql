/****** Object:  StoredProcedure [dbo].[GetAllSubject]    Script Date: 7/22/2017 4:07:49 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAllReportConfig]'))
BEGIN
DROP PROCEDURE  GetAllReportConfig
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Proc [dbo].[GetAllReportConfig] 

As
Begin
SELECT [ReportConfigId] ,RC.[ClassId], C.ClassName, R.ReportName ,RC.[ReportId],RC.[Type],
		(CASE WHEN RC.[Type] = 'M' THEN 'Main  Exam'
			WHEN RC.[Type] = 'MME' THEN 'Main  Exam'
			WHEN RC.[Type] = 'MF' THEN 'Main  Exam '
			WHEN RC.[Type] = 'S' THEN 'SUb Exam'
			WHEN RC.[Type] = 'G' THEN 'Grand Result'
			WHEN RC.[Type] = 'GME' THEN 'Grand Result'
			WHEN RC.[Type] = 'GF' THEN 'Grand Result'
			END) AS Exam 
  FROM [dbo].[Res_ReportConfig] RC INNER JOIN Ins_ClassInfo C ON C.[ClassId] = RC.[ClassId]
		INNER JOIN [dbo].[Res_Reports] R ON R.ReportId = RC.ReportId
	
End

