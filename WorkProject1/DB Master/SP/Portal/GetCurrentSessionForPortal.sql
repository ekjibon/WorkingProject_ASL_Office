
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetCurrentSessionForPortal]'))
BEGIN
DROP PROCEDURE  GetCurrentSessionForPortal
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec GetCurrentSessionForPortal 14478

CREATE PROCEDURE GetCurrentSessionForPortal
(
 @IID INT
)
	
AS
BEGIN  PRINT @IID


	SELECT   S.SessionId
			,S.SessionName
			,S.SessionCode
			,S.Session_StartDate
			,S.Session_EndDate
			
	FROM Student_BasicInfo SB 
		
	LEFT JOIN dbo.Ins_Session S	 ON S.SessionId = SB.SessionId

	WHERE SB.StudentIID= @IID
        	


 END