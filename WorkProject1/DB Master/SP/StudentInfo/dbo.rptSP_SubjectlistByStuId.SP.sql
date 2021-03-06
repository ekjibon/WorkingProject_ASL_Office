/****** Object:  StoredProcedure [dbo].[GetAllSubject]    Script Date: 7/22/2017 4:07:49 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptSP_SubjectlistByStuId]'))
BEGIN
DROP PROCEDURE  rptSP_SubjectlistByStuId
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[rptSP_SubjectlistByStuId]
(
	@StudentInsId nvarchar(max)
)
AS
BEGIN
select ss.StudentID, ss.VersionID,ss.SessionId,ss.ClassId,ss.GroupId,ss.SubjectID,sb.StudentInsID,ss.SubjectType,
(sb.StudentInsID +''+sb.FullName) StudentName , ssp.SubjectName,sb.FullName,sb.[RollNo],ssp.[SubjectCode],ssp.[ShortName],
 v.VersionName,s.SessionName,c.ClassName, g.GroupName from Res_StudentSubject ss
left outer join Ins_Version v on v.VersionId=ss.VersionId
left outer join Ins_Session s on s.SessionId=ss.SessionId
left outer join Ins_ClassInfo c  on c.ClassId=ss.ClassId
left outer join Ins_Group g  on g.GroupId=ss.GroupId
left outer join Res_SubjectSetup ssp  on ssp.SubID=ss.SubjectID
left outer join Student_BasicInfo sb  on sb.StudentIID=ss.StudentID
where 

@StudentInsId is null or sb.StudentInsID=@StudentInsId  
end



--select * from  [dbo].[Res_GrandSetup]
--select * from [Res_MainExam] as m 
--  where m.[VersionId]=1 and  m.[SessionId]=6 and  m.[ClassId]=10 and m.[GroupId]=1  and m.IsDeleted=0

    -- [dbo].[sp_GrandSetup] 1,6,10,1