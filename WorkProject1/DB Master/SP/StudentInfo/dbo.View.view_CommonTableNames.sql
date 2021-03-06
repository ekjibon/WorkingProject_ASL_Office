/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[view_CommonTableNames]'))
BEGIN
DROP VIEW  view_CommonTableNames
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_CommonTableNames]
as
SELECT        dbo.Ins_Branch.BranchName, 
dbo.Ins_ClassInfo.ClassName,
 dbo.Ins_Session.SessionName, 
 dbo.Ins_Shift.ShiftName, 
 dbo.Ins_Section.SectionName, 
                         dbo.Ins_Session.SessionId, 
						 dbo.Ins_ClassInfo.ClassId,
						  dbo.Ins_Branch.BranchId, 
						  dbo.Ins_Shift.ShiftId,
						   dbo.Ins_Section.SectionId
FROM            dbo.Ins_Branch INNER JOIN
                         dbo.Ins_Shift ON dbo.Ins_Branch.BranchId = dbo.Ins_Shift.BranchId CROSS JOIN
                      
                         dbo.Ins_ClassInfo  INNER JOIN
                         dbo.Ins_Section ON dbo.Ins_ClassInfo.ClassId = dbo.Ins_Section.ClassId CROSS JOIN
                         dbo.Ins_Session 