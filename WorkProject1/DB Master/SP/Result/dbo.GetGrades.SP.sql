/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetGrades]'))
BEGIN
DROP PROCEDURE  GetGrades
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kawsar
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[GetGrades] 
	-- Add the parameters for the stored procedure here
	
	
	@SessionId int = 0,
	@ClassId int = 0
AS
BEGIN
	
	SELECT [ID]
    
      ,[SessionID]
      ,[ClassID]
      ,[Marks_From]
      ,(CASE WHEN [Marks_To]= 100 THEN [Marks_To]
	  ELSE [Marks_To]-1
	  END) AS [Marks_To]
      ,[GL]
      ,[GP]
      ,[IsFailGrade]
      ,[Comments]
     FROM Res_GradingSystem  
	WHERE [SessionID] = @SessionId and [ClassID] =  @ClassId

END
