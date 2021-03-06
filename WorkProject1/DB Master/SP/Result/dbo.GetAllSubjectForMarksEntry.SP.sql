/****** Object:  StoredProcedure [dbo].[GetAllSubjectForMarksEntry]    Script Date: 7/22/2017 4:09:00 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAllSubjectForMarksEntry]'))
BEGIN
DROP PROCEDURE  GetAllSubjectForMarksEntry
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[GetAllSubjectForMarksEntry] 
(
@ClassID int,
@SessionID int

)
As
Begin
SELECT [SubID]

      ,[SessionId]
      ,[ClassId]

      ,[SubjectName]
  FROM [dbo].[Res_SubjectSetup] AS S
  WHERE SessionId = @SessionID AND ClassId = @ClassID  AND S.IsDeleted=0
  ORDER BY [ReportSerialNo] ASC
 
End

 -- [GetAllSubjectForMarksEntry] 19,12,1