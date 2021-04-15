

/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetFeesFiscalSessionList]'))
BEGIN
DROP PROCEDURE  [GetFeesFiscalSessionList]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		 Arifur
-- Create date: 
-- Description:	
-- =============================================

 --execute ProcessFees 51,1
CREATE  PROCEDURE [dbo].[GetFeesFiscalSessionList] 

AS
BEGIN

SELECT FS.*
		,S.SessionName
		--,C.ClassName
		 FROM dbo.Fees_FiscalSession FS
		INNER JOIN dbo.Ins_Session S ON S.SessionId  = FS.SessionId		
		--INNER JOIN dbo.Ins_ClassInfo C ON C.ClassId  = FS.ClassId
		WHERE FS.IsDeleted = 0 AND FS.[Status] = 'A'
END


  


