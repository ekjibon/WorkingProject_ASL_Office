/****** Object:  StoredProcedure [dbo].[GetSingleSearchEmpInfo]    Script Date: 12/20/2017 4:15:28 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetSingleSearchEmpInfo]'))
BEGIN
DROP PROCEDURE  GetSingleSearchEmpInfo
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[GetSingleSearchEmpInfo] 

	@EmpID varchar(100) = NULL
	
	
AS
BEGIN				
	
SELECT        EM.FullName, EM.EmpBasicInfoID, EM.EmpID, dbo.Emp_Designation.DesignationName, EM.JoiningDate, EM.SMSNotificationNo, 
                         dbo.Emp_Status.StatusName
FROM            dbo.Emp_BasicInfo as EM  JOIN
                         dbo.Emp_Designation ON EM.DesignationID = dbo.Emp_Designation.DesignationID 
						  JOIN  dbo.Emp_Status ON EM.StatusID = dbo.Emp_Status.StatusID
	WHERE 

			EM.EmpID = @EmpID		
		
			AND EM.IsDeleted =0
			

END

--EXEC GetSingleSearchEmpInfo 'T15M002'   
