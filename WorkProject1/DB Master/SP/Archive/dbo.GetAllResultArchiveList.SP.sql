/****** Object:  StoredProcedure [dbo].[GetAllSubject]    Script Date: 7/22/2017 4:07:49 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAllResultArchiveList]'))
BEGIN
DROP PROCEDURE  GetAllResultArchiveList
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  GetAllGroupsbyVersionIdandSessionId 1,9 
Create Proc GetAllResultArchiveList
AS
BEGIN
--select ar.* , v.VersionName,v.SessionName,v.BranchName,v.ShiftName,v.ClassName,v.GroupName, v.SectionName from dbo.Arch_ResultArchive ar INNER JOIN 
-- dbo.view_CommonTableNames v on v.VersionId=ar.VersionID and v.SessionId=ar.SessionId and v.BranchId=ar.BranchID and v.ShiftId=ar.ShiftID
--and v.ClassId=ar.ClassId and v.GroupId=ar.GroupId and v.SectionId=ar.SectionId  

select CAST( ROW_NUMBER() OVER (ORDER BY v.VersionId desc)+1 as int) as RowNumber, v.VersionId VersionID,v.VersionName, v.SessionId ,v.SessionName,v.BranchId BranchID,v.BranchName,v.ShiftId ShiftID,v.ShiftName
,v.ClassId ,v.ClassName,v.GroupId,v.GroupName,v.SectionId,v.SectionName from  dbo.view_CommonTableNames v 
END

