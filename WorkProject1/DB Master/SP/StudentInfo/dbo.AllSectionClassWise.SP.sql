/****** Object:  StoredProcedure [dbo].[ProccessMarks]    Script Date: 7/22/2017 4:26:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AllSectionClassWise]'))
BEGIN
DROP PROCEDURE  AllSectionClassWise
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 --execute [AllSectionClassWise] 10,1
Create PROCEDURE [dbo].[AllSectionClassWise]  
	(
	@ClassID int,
	@GroupID int
	)
AS
BEGIN
DECLARE @ClassID2 int=0, @ClassName varchar(50)

select @ClassName=[ClassName] from [dbo].[Ins_ClassInfo] where [ClassId]=@ClassID
select @ClassID2=[ClassId] from [dbo].[Ins_ClassInfo] where [ClassName]=@ClassName

Select * from [dbo].[Ins_Section] where ([ClassId]=@ClassID OR [ClassId]=@ClassID2 ) and [GroupId]=@GroupID AND [IsDeleted]=0
END

