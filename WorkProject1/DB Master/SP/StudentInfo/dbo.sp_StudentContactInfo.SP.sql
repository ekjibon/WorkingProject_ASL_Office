/****** Object:  StoredProcedure [dbo].[sp_StudentContactInfo]    Script Date: 7/22/2017 4:45:54 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[sp_StudentContactInfo]'))
BEGIN
DROP PROCEDURE  sp_StudentContactInfo
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[sp_StudentContactInfo] --sp_StudentContactInfo 84 
(
@StudentIID bigint
)
AS
Begin
SELECT        dbo.Student_ContactInfo.ContactIID, dbo.Student_ContactInfo.StudentIID, dbo.Student_ContactInfo.Pre_Address, dbo.Student_ContactInfo.Pre_PostOffice, dbo.Student_ContactInfo.Pre_PostalCode, 
                         dbo.Student_ContactInfo.Par_Address, dbo.Student_ContactInfo.Par_PostOffice, dbo.Student_ContactInfo.Par_PostalCode, dbo.Common_District.DistrictName AS Par_DisName, 
                         dbo.Common_PoliceStation.PsName AS Par_PsName, Common_District_1.DistrictName AS Pre_DisName, Common_PoliceStation_1.PsName AS Pre_PsName, dbo.Student_ContactInfo.Pre_PSId, 
                         dbo.Student_ContactInfo.Pre_DisId, dbo.Student_ContactInfo.Par_PSId, dbo.Student_ContactInfo.Par_DisId
FROM            dbo.Student_ContactInfo INNER JOIN
                         dbo.Common_District ON dbo.Student_ContactInfo.Par_DisId = dbo.Common_District.DistrictId INNER JOIN
                         dbo.Common_PoliceStation ON dbo.Student_ContactInfo.Par_PSId = dbo.Common_PoliceStation.PsId INNER JOIN
                         dbo.Common_PoliceStation AS Common_PoliceStation_1 ON dbo.Student_ContactInfo.Pre_PSId = Common_PoliceStation_1.PsId INNER JOIN
                         dbo.Common_District AS Common_District_1 ON dbo.Student_ContactInfo.Pre_DisId = Common_District_1.DistrictId
						 where dbo.Student_ContactInfo.StudentIID= 1767
  END
