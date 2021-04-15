/****** Object:  StoredProcedure [dbo].[GetStudentInfoForResult]    Script Date: 7/22/2017 4:19:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FeesCommon]'))
BEGIN
DROP PROCEDURE  FeesCommon
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[FeesCommon] 1,1,1,2,1
CREATE PROCEDURE [dbo].[FeesCommon]  -- Total 9 param
	@Block INT = 0,
	@VersionId INT = NULL,
	@SessionId INT = NULL,
	@BranchID INT = NULL,
	@ClassId INT = NULL
	
	
AS
BEGIN

 IF(@Block=1) -- View Student Due

 BEGIN
select fd.FeesHeadId,fd.HeadName,fd.CategoryId,fdh.* from dbo.Fees_Head fd 
left outer join dbo.Fees_HeadPriority fdh on fdh.FeesHeadId=fd.FeesHeadId and fdh.VersionId=coalesce(@VersionId,null) and fdh.SessionId=coalesce(fdh.SessionId,null) and fdh.BranchId=coalesce(@BranchID,null) and fdh.ClassId=coalesce(@ClassId,null)


 END
 END




