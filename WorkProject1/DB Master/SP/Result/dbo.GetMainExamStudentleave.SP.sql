/****** Object:  StoredProcedure [dbo].[SP_GetEmpAllInfo]    Script Date: 11/18/2017 6:37:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetMainExamStudentleave]'))
BEGIN
DROP PROCEDURE  GetMainExamStudentleave
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetMainExamStudentleave] 
    @VersionId INT =null,
	@SessionId INT =null,
	@BranchId INT =null,
	@ShiftId INT =null,
	@ClassId INT =null,
	@GroupId INT =null,
	@SectionId INT =null,
	@GrandExamId INT =null
AS
BEGIN
select mels.Id,mels.StudentIID, mels.SessionId,mels.VersionId,mels.SectionId,mels.BranchId,mels.ClassId,mels.GroupId,mels.ShiftId,mels.SubjectID,mels.GrandExamId,mels.NumberOfExam,mels.NumberOfExam,
v.VersionName, ss.SessionName,sec.SectionName,b.BranchName,c.ClassName,g.GroupName,st.ShiftName,sbi.FullName,sbi.StudentInsID, sst.SubjectName , ge.GrandExamName from dbo.Res_MainExamLeaveStudent mels
left join dbo.Ins_Session ss on ss.SessionId = mels.SessionId
left join dbo.Ins_Version v on v.VersionId = mels.VersionId
left join dbo.Ins_Section sec on sec.SectionId = mels.SectionId
left join dbo.Ins_Branch b on b.BranchId = mels.BranchId
left join dbo.Ins_ClassInfo c on c.ClassId = mels.ClassId
left join dbo.Ins_Group g on g.GroupId = mels.GroupId
left join dbo.Ins_Shift st on st.ShiftId = mels.ShiftId
left join dbo.Res_SubjectSetup sst on sst.SubID = mels.SubjectID
left join dbo.Student_BasicInfo sbi on sbi.StudentIID = mels.StudentIID
left join dbo.Res_GrandExam ge on ge.GrandExamId = mels.GrandExamId

where  (mels.VersionId=@VersionId or @VersionId   IS NULL) AND 
	 (mels.SessionId=@SessionId or @SessionId   IS NULL) AND 
	 (mels.BranchId=@BranchId or @BranchId   IS NULL) AND 
	 (mels.ShiftId=@ShiftId or @ShiftId   IS NULL) AND 
	 (mels.GroupId=@GroupId or @GroupId   IS NULL) AND 
	 (mels.SectionId=@SectionId or @SectionId   IS NULL) AND 
	 (mels.GrandExamId=@GrandExamId or @GrandExamId   IS NULL) 

END
