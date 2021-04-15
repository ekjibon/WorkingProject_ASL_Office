

/****** Object:  StoredProcedure [dbo].[GetStudentInfoForResult]    Script Date: 7/22/2017 4:19:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetMultiSectionforHeadTeacherComment]'))
BEGIN
DROP PROCEDURE  GetMultiSectionforHeadTeacherComment
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[GetMultiSectionforHeadTeacherComment] '11','5','27'
CREATE PROCEDURE [dbo].[GetMultiSectionforHeadTeacherComment]  -- 
	@Session VARCHAR(128),
	@Shift  VARCHAR(128),
	@Class VARCHAR(128)
	
	
AS
BEGIN

     SELECT HCM.*,CI.ClassName,S.SectionName FROM Res_HeadsCommentMaster HCM
	 INNER JOIN Ins_ClassInfo CI ON CI.ClassId = HCM.ClassID
	 INNER JOIN Ins_Section S ON S.SectionId = HCM.SectionID
    
	WHERE HCM.SessionID =  @Session AND HCM.ShiftID = @Shift AND HCM.ClassID = @Class
 
 END
