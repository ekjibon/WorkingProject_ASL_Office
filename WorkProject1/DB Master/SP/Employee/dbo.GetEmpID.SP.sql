/****** Object:  StoredProcedure [dbo].[SP_GetEmpAllInfo]    Script Date: 11/18/2017 6:37:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmpID]'))
BEGIN
DROP PROCEDURE  GetEmpID
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEmpID] 

@DesignationID INT,
@JoiningDate date


AS
BEGIN

DECLARE @ID int

DECLARE @ID2 varchar
DECLARE @Designation2 varchar(100)
DECLARE @JoiningDate2 varchar

		insert into Emp_BasicInfo (DesignationID, JoiningDate,IsClassTeacher,TypeID,SectionID,BranchID,ShiftID,DepartmentID,SubjectID,CategoryID,VersionID,StatusID,ReportingPersonID
		,ReportOrderNo,SalaryGradeID,IsGovtSalaryActive,GovtSalaryGrade,IsPermanent,IsDeleted)
		values(@DesignationID, @JoiningDate,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)

		SET @ID=@@IDENTITY

		update Emp_BasicInfo SET EmpID=(
		(select substring(DesignationName, 1, 1)from  dbo.Emp_Designation WHERE DesignationID = @DesignationID)
		+(Select Format(@JoiningDate, N'yyMMdd'))
		+(SELECT CONVERT(varchar(10),@@IDENTITY))
		) where  EmpBasicInfoID=@ID

		select EmpID, EmpBasicInfoID from Emp_BasicInfo where  EmpBasicInfoID=@ID

--exec GetEmpID 5, '4/14/2018 6:00:00 PM'
END

