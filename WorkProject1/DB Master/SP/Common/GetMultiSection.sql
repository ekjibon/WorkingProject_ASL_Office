

/****** Object:  StoredProcedure [dbo].[GetStudentInfoForResult]    Script Date: 7/22/2017 4:19:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetMultiSection]'))
BEGIN
DROP PROCEDURE  GetMultiSection
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[GetMultiSection] '11','5','27'
CREATE PROCEDURE [dbo].[GetMultiSection]  -- Total 9 param
	@Session VARCHAR(128),
	@Shift  VARCHAR(128),
	@Class VARCHAR(128)
	
	
AS
BEGIN

	SELECT * 
		FROM Ins_Section 
		WHERE SectionId IN (SELECT SB.SectionId 
							FROM Student_BasicInfo SB
							WHERE SB.SessionId IN(SELECT CAST(value AS INT) FROM STRING_SPLIT(@Session, ',')) 
												AND SB.ShiftID IN(SELECT CAST(value AS INT) FROM STRING_SPLIT(@Shift, ',')) 
												AND  SB.ClassId IN (SELECT CAST(value AS INT) FROM STRING_SPLIT(@Class, ',')) GROUP BY SB.SectionId) AND IsDeleted = 0

 
 END




