/****** Object:  StoredProcedure [dbo].[SP_GetEmpAllInfo]    Script Date: 11/18/2017 6:37:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmpInfoByIDs]'))
BEGIN
DROP PROCEDURE  GetEmpInfoByIDs
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEmpInfoByIDs]  -- exec GetEmpInfoByIDs ',55079,55149,55021,55067,55148,55134,55157,55146,55120,55172,55068,55045,55042,55019,55136,55070,55144,55177,55023,55029,55017,55150,55059,55081,55117,55047,55160,55016,55095,CGSDTest001,S1903094,S1902286,55003,55001,55127,55084,55030,55077,55126,S1812311,hgfh54654,55046'

@EmpIDs nvarchar(max)


AS
BEGIN
SELECT value  INTO #EMPIDs
FROM String_Split(@EmpIDs, ',')
order by value
select EB.FullName,EB.Image as EmpImage,EB.EmpID, DE.DesignationName,EB.NationalID,EB.BloodGroup,EB.JoiningDate,
B.BranchName,S.SignatureImg1,S.SignatureImg2,S.SignatureImg3 from Emp_BasicInfo EB
inner join Emp_Designation DE on EB.DesignationID=DE.DesignationID
inner join Ins_Branch B on EB.BranchID=B.BranchId
inner join Ins_Signature S on S.BranchID=EB.BranchID
 where EmpID in (select * from #EMPIDs)
 order by EB.DisOrder asc
END

