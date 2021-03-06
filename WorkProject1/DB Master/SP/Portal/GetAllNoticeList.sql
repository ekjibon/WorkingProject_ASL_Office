IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAllNoticeList]'))
BEGIN
DROP PROCEDURE  GetAllNoticeList
END
GO
/****** Object:  StoredProcedure [dbo].[GetAllNoticeList]    Script Date: 4/4/2019 4:16:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[GetAllNoticeList]
(
 @StudentId nvarchar(1000),
 @TargetType int  --TargetType = 1 Student,TargetType = 2 Employee
)
As
Begin
Select ND.* ,
NInfo.*
from dbo.Ins_NoticeDetails  ND
Join dbo.Ins_NoticeInfo NInfo On ND.NoticeId = NInfo.Id
 Where ND.TargetId = @StudentId and ND.TargetType = @TargetType
End

--GetAllNoticeList 970 ,1