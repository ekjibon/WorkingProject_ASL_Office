/****** Object:  StoredProcedure [dbo].[SP_GetEmpAllInfo]    Script Date: 11/18/2017 6:37:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SearchEmpInfo]'))
BEGIN
DROP PROCEDURE  SearchEmpInfo
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 -- execute [dbo].[SearchEmpInfo] 0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,'I'

 --execute [dbo].[SearchEmpInfo] 54,0,0,0,0,0,0, 0,0,0,0,null,null

CREATE PROCEDURE [dbo].[SearchEmpInfo] -- Total 13 param
	
	@EmpId INT = NULL,
	@BranchID INT = NULL,	
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
	@JoinDate datetime=null,
	@Status varchar(1) =null
	
AS
BEGIN	
		IF @BranchID = 0 SET @BranchID  = NULL		
		IF @DesignationID = 0 SET @DesignationID  = NULL
		IF @CategoryID = 0 SET @CategoryID  = NULL
		IF @ShiftID = 0 SET @ShiftID  = NULL		
		IF @DepartmentID = 0 SET @DepartmentID  = NULL
		IF @SubjectID = 0 SET @SubjectID  = NULL
		IF @StatusID = 0 SET @StatusID  = NULL
		IF @SectionID = 0 SET @SectionID  = NULL
		IF @Status = '' SET @Status  = NULL
	
		
	IF(@Status = 'A' OR @Status IS NULL)
	BEGIN
		SELECT        EM.FullName,EM.DisOrder,EM.DateOfBirth,EM.[Status], 
		EM.EmpBasicInfoID, EM.EmpID, dbo.Emp_Designation.DesignationName, 
		EM.JoiningDate, EM.SMSNotificationNo, dbo.Emp_Status.StatusName,
		EM.BloodGroup,B.BranchName BranchName,EM.Religion,EM.PresentAddress,
		EM.PresentPost,EM.PresentThana,EM.PresentDistrict,EM.Gender,
		EM.Image,EM.Email,B.BranchName BranchName,C.CategoryName, ED.DepartmentID,ED.DepartmentName ,EM.Child 

		FROM                     dbo.Emp_BasicInfo as EM LEFT JOIN
							 dbo.Emp_Designation ON EM.DesignationID = dbo.Emp_Designation.DesignationID 
							 LEFt JOIN  dbo.Emp_Status ON EM.StatusID = dbo.Emp_Status.StatusID
							 LEFT JOIN  [dbo].[Emp_Category] C ON EM.CategoryID = C.CategoryID
							 LEFT JOIN [dbo].[Ins_Branch] B ON B.BranchId = EM.BranchID
							 LEFT JOIN Emp_Department ED on EM.DepartmentID=ED.DepartmentID
		WHERE 	

	     ( @EmpId is null OR EM.EmpBasicInfoID =@EmpId OR @EmpId=0)
		 and
	     ( @BranchID is null OR EM.BranchID =@BranchID OR @BranchID=0)
		 
		 AND(@DesignationID is null OR @DesignationID=EM.DesignationID OR @DesignationID=0) 
		 AND( @CategoryID is null OR @CategoryID=EM.CategoryID OR @CategoryID=0) 
		 AND (@ShiftID is null OR @ShiftID= EM.ShiftID  OR @ShiftID=0) 
		 AND ( @DepartmentID is null OR  @DepartmentID=EM.DepartmentID OR @DepartmentID=0) 
		 AND (@SubjectID is null OR @SubjectID=EM.SubjectID OR @SubjectID=0) 
		 AND(@SectionID is null OR @SectionID=EM.SectionID OR @SectionID=0) 
		 and (@DOBFrom is null or EM.DateOfBirth > @DOBFrom )
		 and (@DOBTo is null or EM.DateOfBirth < @DOBTo )
		 AND EM.IsDeleted =0
		  AND(@JoinDate is null OR @JoinDate=EM.JoiningDate ) 
		  AND(@Status is null OR @Status=EM.[Status])
		  --OR (@Status EM.Status <> 'A') 				
		ORDER BY  EM.DesignationID, dbo.Emp_Designation.DesignationOrder
	END
	IF(@Status = 'I')
	BEGIN 

		SELECT        EM.FullName,EM.DisOrder,EM.DateOfBirth,EM.[Status], 
		EM.EmpBasicInfoID, EM.EmpID, dbo.Emp_Designation.DesignationName, 
		EM.JoiningDate, EM.SMSNotificationNo, dbo.Emp_Status.StatusName,
		EM.BloodGroup,B.BranchName BranchName,EM.Religion,EM.PresentAddress,
		EM.PresentPost,EM.PresentThana,EM.PresentDistrict,EM.Gender,
		EM.Image,EM.Email,B.BranchName BranchName,C.CategoryName, ED.DepartmentID,ED.DepartmentName ,EM.Child 

	FROM                     dbo.Emp_BasicInfo as EM LEFT JOIN
							 dbo.Emp_Designation ON EM.DesignationID = dbo.Emp_Designation.DesignationID 
							 LEFt JOIN  dbo.Emp_Status ON EM.StatusID = dbo.Emp_Status.StatusID
							 LEFT JOIN  [dbo].[Emp_Category] C ON EM.CategoryID = C.CategoryID
							 LEFT JOIN [dbo].[Ins_Branch] B ON B.BranchId = EM.BranchID
							 LEFT JOIN Emp_Department ED on EM.DepartmentID=ED.DepartmentID
		WHERE 	

			 ( @EmpId is null OR EM.EmpBasicInfoID =@EmpId OR @EmpId=0)
			 and
			 ( @BranchID is null OR EM.BranchID =@BranchID OR @BranchID=0)
		 
			 AND(@DesignationID is null OR @DesignationID=EM.DesignationID OR @DesignationID=0) 
			 AND( @CategoryID is null OR @CategoryID=EM.CategoryID OR @CategoryID=0) 
			 AND (@ShiftID is null OR @ShiftID= EM.ShiftID  OR @ShiftID=0) 
			 AND ( @DepartmentID is null OR  @DepartmentID=EM.DepartmentID OR @DepartmentID=0) 
			 AND (@SubjectID is null OR @SubjectID=EM.SubjectID OR @SubjectID=0) 
			 AND(@SectionID is null OR @SectionID=EM.SectionID OR @SectionID=0) 
			 and (@DOBFrom is null or EM.DateOfBirth > @DOBFrom )
			 and (@DOBTo is null or EM.DateOfBirth < @DOBTo )
			 AND EM.IsDeleted =0
			  AND(@JoinDate is null OR @JoinDate=EM.JoiningDate ) 
			  AND EM.Status <> 'A'
				
			ORDER BY  EM.DesignationID, dbo.Emp_Designation.DesignationOrder
	END	
END