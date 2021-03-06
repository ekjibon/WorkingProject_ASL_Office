/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetStaticalReport]'))
BEGIN
DROP PROCEDURE  GetStaticalReport
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Mustak
-- Create date: 
-- Description:	
-- =============================================
--  GetStaticalReport 1171,1,1,1,1,64
CREATE PROCEDURE [dbo].[GetStaticalReport] 
	-- Add the parameters for the stored procedure here
	@mainExamId int = 0,
	@VersionId int = 0,
	@SessionId int = 0,
	@ClassId int = 0,
	@ShiftId int=0,
	@SectionId int =0
AS
BEGIN
	
	
select Top (1) (select Count (Aa.GradeLetter ) from [dbo].[Res_MainExamResult] Aa Inner Join [dbo].[Student_BasicInfo] SB ON Aa.StudentIID=SB.StudentIID 
where Aa.MainExamId=@mainExamId and SB.ShiftID=@ShiftId and SB.SectionId=@SectionId And Aa.GradeLetter='A+') as APlus
-- A grade
,(select Count (Aa.GradeLetter) from [dbo].[Res_MainExamResult] Aa 
Inner Join [dbo].[Student_BasicInfo] SB ON Aa.StudentIID=SB.StudentIID 
where Aa.MainExamId=@mainExamId and SB.ShiftID=@ShiftId and SB.SectionId=@SectionId And Aa.GradeLetter='A') as A

--A- Grade
,(select Count (Aa.GradeLetter) from [dbo].[Res_MainExamResult] Aa Inner Join [dbo].[Student_BasicInfo] SB ON Aa.StudentIID=SB.StudentIID 
where Aa.MainExamId=@mainExamId and SB.ShiftID=@ShiftId and SB.SectionId=@SectionId And Aa.GradeLetter='A-') as Aminus

--B Grade
,(select Count (Aa.GradeLetter) from [dbo].[Res_MainExamResult] Aa Inner Join [dbo].[Student_BasicInfo] SB ON Aa.StudentIID=SB.StudentIID 
where Aa.MainExamId=@mainExamId and SB.ShiftID=@ShiftId and SB.SectionId=@SectionId And Aa.GradeLetter='B') as B
-- C grade
,(select Count (Aa.GradeLetter) from [dbo].[Res_MainExamResult] Aa Inner Join [dbo].[Student_BasicInfo] SB ON Aa.StudentIID=SB.StudentIID 
where Aa.MainExamId=@mainExamId and SB.ShiftID=@ShiftId and SB.SectionId=@SectionId And Aa.GradeLetter='C') as C

-- F grade
,(select Count (Aa.GradeLetter) from [dbo].[Res_MainExamResult] Aa Inner Join [dbo].[Student_BasicInfo] SB ON Aa.StudentIID=SB.StudentIID 
where Aa.MainExamId=@mainExamId and SB.ShiftID=@ShiftId and SB.SectionId=@SectionId And Aa.GradeLetter='F') as F

--Total
,(select Count (Aa.GradeLetter) from [dbo].[Res_MainExamResult] Aa 
Inner Join [dbo].[Student_BasicInfo] SB ON Aa.StudentIID=SB.StudentIID 
where Aa.MainExamId=@mainExamId and SB.ShiftID=@ShiftId and SB.SectionId=@SectionId) as TotalStudent

from [dbo].[Res_MainExamResult] m
Inner Join [dbo].[Student_BasicInfo] SB ON m.StudentIID=SB.StudentIID 
where MainExamId=@mainExamId and SB.ShiftID=@ShiftId and SB.SectionId=@SectionId
END
