

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetEmpInfo]'))
BEGIN
DROP PROCEDURE  rptGetEmpInfo
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[rptGetEmpInfo] -- Total 13 param
	
	@BranchID INT = NULL,
	@VersionID INT = NULL,
	@DesignationID INT = NULL,
	@CategoryID INT = NULL,
	@ShiftID INT = NULL,
	@StatusID INT = NULL,
	@DepartmentID INT = NULL,
	@SubjectID INT = NULL,
	@SectionID INT = NULL,
	@IsClassTeacher bit,
	@DOBFrom datetime=null,
	@DOBTo datetime=null,
	@JoinDate datetime=null
	
	
AS
BEGIN	
		IF @BranchID = 0 SET @BranchID  = NULL
		IF @VersionID = 0 SET @VersionID  = NULL
		IF @DesignationID = 0 SET @DesignationID  = NULL
		IF @CategoryID = 0 SET @CategoryID  = NULL
		IF @ShiftID = 0 SET @ShiftID  = NULL
		
		IF @DepartmentID = 0 SET @DepartmentID  = NULL
		IF @SubjectID = 0 SET @SubjectID  = NULL
		IF @StatusID = 0 SET @StatusID  = NULL
		IF @SectionID = 0 SET @SectionID  = NULL
		IF @DOBFrom = NULL set @DOBFrom='1800-01-01 00:00:00.000'
		IF @DOBTo = NULL set @DOBTo=GETDATE()
		
	print @DOBFrom
	
	IF @DOBTo is not NULL
	begin
	SELECT        EM.FullName,EM.DateOfBirth,EM.Status, EM.EmpBasicInfoID, EM.EmpID, dbo.Emp_Designation.DesignationName, EM.JoiningDate, EM.SMSNotificationNo, 
                         dbo.Emp_Status.StatusName,
						 EM.BloodGroup,
						 EM.BranchName,
						 EM.Religion,
						 EM.PresentAddress,
						 EM.Gender,
						 EM.Image,
						 EM.Email,
						 B.Name BranchName,
						 C.CategoryName
FROM                     dbo.Emp_BasicInfo as EM LEFT JOIN
                         dbo.Emp_Designation ON EM.DesignationID = dbo.Emp_Designation.DesignationID 
						 LEFt JOIN  dbo.Emp_Status ON EM.StatusID = dbo.Emp_Status.StatusID
						 LEFT JOIN  [dbo].[Emp_Category] C ON EM.CategoryID = C.CategoryID
						 LEFT JOIN [dbo].[ACC_Branchs] B ON B.BranchId = EM.BranchID
	WHERE 	

	     ( @BranchID is null OR EM.BranchID =@BranchID OR @BranchID=0)
		 AND (@VersionId is null OR EM.VersionID=@VersionId OR @VersionId=0)  
		 AND(@DesignationID is null OR @DesignationID=EM.DesignationID OR @DesignationID=0) 
		 AND( @CategoryID is null OR @CategoryID=EM.CategoryID OR @CategoryID=0) 
		 AND (@ShiftID is null OR @ShiftID= EM.ShiftID  OR @ShiftID=0) 
		 AND ( @DepartmentID is null OR  @DepartmentID=EM.DepartmentID OR @DepartmentID=0) 
		 AND (@SubjectID is null OR @SubjectID=EM.SubjectID OR @SubjectID=0) 
		 AND(@SectionID is null OR @SectionID=EM.SectionID OR @SectionID=0) 
		 --AND ((DATEDIFF(hour,@DOBFrom,EM.DateOfBirth))>0)
		       	--and EM.StatusID=COALESCE(@StatusID,EM.StatusID) 
			
			      --and	EM.IsClassTeacher=@IsClassTeacher) 
				  -- select (DATEDIFF(hour, '1990-01-01 00:00:00.000','1985-07-15 00:00:00.000'))

		 AND EM.IsDeleted =0

		 AND EM.JoiningDate=@JoinDate

			--EM.BranchID = COALESCE(@BranchID,EM.BranchID) OR
			--(EM.VersionID = COALESCE(@VersionId,EM.VersionID) and 
			--EM.DesignationID = COALESCE(@DesignationID,EM.DesignationID) and
			--EM.CategoryID=COALESCE(@CategoryID,EM.CategoryID) and
			--EM.ShiftID = COALESCE(@ShiftID,EM.ShiftID) and
			--EM.DepartmentID = COALESCE(@DepartmentID,EM.DepartmentID) and
			--EM.SubjectID = COALESCE(@SubjectID,EM.SubjectID) and
			--EM.SectionID = COALESCE(@SectionID,EM.SectionID) 
		 --      	--and EM.StatusID=COALESCE(@StatusID,EM.StatusID) 
			--)
			--      --and	EM.IsClassTeacher=@IsClassTeacher) 


		 --AND EM.IsDeleted =0
			
			

				
		ORDER BY EM.ReportOrderNo

	end
	else
	begin
	SELECT        EM.FullName,EM.DateOfBirth, EM.EmpBasicInfoID, EM.EmpID, dbo.Emp_Designation.DesignationName, EM.JoiningDate, EM.SMSNotificationNo, 
             dbo.Emp_Status.StatusName,
						 EM.BloodGroup,
						 EM.BranchName,
						 EM.Religion,
						 EM.PresentAddress,
						 EM.Gender,
						 EM.Image,
						 EM.Email,
						 B.Name BranchName,
						 C.CategoryName
FROM                     dbo.Emp_BasicInfo as EM LEFT JOIN
                         dbo.Emp_Designation ON EM.DesignationID = dbo.Emp_Designation.DesignationID 
						 LEFt JOIN  dbo.Emp_Status ON EM.StatusID = dbo.Emp_Status.StatusID
						 LEFT JOIN  [dbo].[Emp_Category] C ON EM.CategoryID = C.CategoryID
						 LEFT JOIN [dbo].[ACC_Branchs] B ON B.BranchId = EM.BranchID
	WHERE 	

	     ( @BranchID is null OR EM.BranchID =@BranchID OR @BranchID=0)
		 AND (@VersionId is null OR EM.VersionID=@VersionId OR @VersionId=0)  
		 AND(@DesignationID is null OR @DesignationID=EM.DesignationID OR @DesignationID=0) 
		 AND( @CategoryID is null OR @CategoryID=EM.CategoryID OR @CategoryID=0) 
		 AND (@ShiftID is null OR @ShiftID= EM.ShiftID  OR @ShiftID=0) 
		 AND ( @DepartmentID is null OR  @DepartmentID=EM.DepartmentID OR @DepartmentID=0) 
		 AND (@SubjectID is null OR @SubjectID=EM.SubjectID OR @SubjectID=0) 
		 AND(@SectionID is null OR @SectionID=EM.SectionID OR @SectionID=0) 
		 --AND ((DATEDIFF(hour,@DOBFrom,EM.DateOfBirth))>0)
		       	--and EM.StatusID=COALESCE(@StatusID,EM.StatusID) 
			
			      --and	EM.IsClassTeacher=@IsClassTeacher) 
				  -- select (DATEDIFF(hour, '1790-01-01 00:00:00.000','1981-11-10 00:00:00.000'))

		 AND EM.IsDeleted =0
		
		

			--EM.BranchID = COALESCE(@BranchID,EM.BranchID) OR
			--(EM.VersionID = COALESCE(@VersionId,EM.VersionID) and 
			--EM.DesignationID = COALESCE(@DesignationID,EM.DesignationID) and
			--EM.CategoryID=COALESCE(@CategoryID,EM.CategoryID) and
			--EM.ShiftID = COALESCE(@ShiftID,EM.ShiftID) and
			--EM.DepartmentID = COALESCE(@DepartmentID,EM.DepartmentID) and
			--EM.SubjectID = COALESCE(@SubjectID,EM.SubjectID) and
			--EM.SectionID = COALESCE(@SectionID,EM.SectionID) 
		 --      	--and EM.StatusID=COALESCE(@StatusID,EM.StatusID) 
			--)
			--      --and	EM.IsClassTeacher=@IsClassTeacher) 


		 --AND EM.IsDeleted =0
			
			

				
		ORDER BY EM.ReportOrderNo

	end

END




--EXEC [dbo].[rptGetEmpInfo] Null,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,Null,Null,Null,Null