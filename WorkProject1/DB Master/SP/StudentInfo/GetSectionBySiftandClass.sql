IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetSectionBySiftandClass]'))
BEGIN
DROP PROCEDURE  GetSectionBySiftandClass
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[GetSectionBySiftandClass] '5','24'
CREATE PROCEDURE [dbo].[GetSectionBySiftandClass]  
	@Shift  VARCHAR(128),
	@Class VARCHAR(128)
	
	
AS
BEGIN

	SELECT * 
		FROM Ins_Section 
		WHERE SectionId IN (SELECT Se.SectionId 
							FROM Ins_Section Se
							WHERE  Se.ShiftID IN(SELECT CAST(value AS INT) FROM STRING_SPLIT(@Shift, ',')) 
								   AND  Se.ClassId IN (SELECT CAST(value AS INT) FROM STRING_SPLIT(@Class, ',')) GROUP BY Se.SectionId) 
								   AND IsDeleted = 0

 
 END