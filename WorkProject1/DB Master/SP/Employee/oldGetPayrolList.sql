/****** Object:  StoredProcedure [dbo].[SP_GetEmpAllInfo]    Script Date: 11/18/2017 6:37:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[oldGetPayrolList]'))
BEGIN
DROP PROCEDURE  oldGetPayrolList1
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[oldGetPayrolList1] 
(
@DepartmentID INT = Null,
@CategoryID INT = Null,
@BranchID INT = Null
)
AS
BEGIN

     IF @DepartmentID = 0 Set @DepartmentID=null
     IF @CategoryID = 0 Set @DepartmentID=null
   
     IF @BranchID = 0 Set @DepartmentID=null
    -- Print @DesignationID;
	-- Print @DepartmentID;
	 Select EB.EmpBasicInfoID,
	          EB.FullName,EB.EmpID,EB.DesignationID,EB.IsClassTeacher,EB.TypeID,EB.BranchID,EB.ShiftID,EB.DepartmentID,
			  EB.SubjectID,EB.MobileNo
	 
	  from dbo.Emp_BasicInfo EB 
	   inner join dbo.Ins_Branch b on b.BranchId= EB.BranchID
	  inner join dbo.Emp_Designation desg on desg.DesignationID = EB.DesignationID
	  inner join dbo.Emp_Department d on d.DepartmentID = EB.DepartmentID
	 left join dbo.Emp_Category c on c.CategoryID = EB.CategoryID
	 Where (@DepartmentID is Null or EB.DepartmentID =@DepartmentID or @DepartmentID=0 )  
	      
		   AND (@CategoryID is null or EB.CategoryID = @CategoryID OR @CategoryID =0)
		   AND (@BranchID is NUll OR EB.BranchID = @BranchID OR @BranchID=0) AND EB.IsDeleted = 0 AND EB.Status='A'
		   
END
-- GetPayrolList 0,0,0

