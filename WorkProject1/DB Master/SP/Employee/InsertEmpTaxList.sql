
/****** Object:  StoredProcedure [dbo].[InsertEmpTaxList]    Script Date: 5/4/2020 11:15:16 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[InsertEmpTaxList]'))
BEGIN
DROP PROCEDURE  [InsertEmpTaxList]
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Khaled
-- Create date: 
-- Description:	
-- =============================================
-- [InsertEmpTaxList] 1,1,60000,1200,2,''
CREATE PROCEDURE [dbo].[InsertEmpTaxList]

	@EmpId INT,
	@EmpCategory INT,
	@CurrentSalary DECIMAL(10,2), 
	@TaxAmount DECIMAL(10,2),
	@TaxYearId INT,
	@AddBy VARCHAR(MAX)
	


AS
BEGIN
 DELETE  FROM [dbo].[HR_EmployeeTaxSetup]
				   WHERE EmpId = @EmpId AND TaxYearId = @TaxYearId

   IF(@@ROWCOUNT>0)
   BEGIN 
   		INSERT INTO [dbo].[HR_EmployeeTaxSetup]
					([CurrentSalary],[TaxAmount],[IsDeleted],[AddBy],[AddDate],[UpdateBy],[UpdateDate],[Remarks],[Status],[EmpId],[TaxYearId],[CategoryID])
		SELECT @CurrentSalary,@TaxAmount,0,@AddBy,GETDATE(),'',GETDATE(),'','A',@EmpId,@TaxYearId,@EmpCategory
							FROM [dbo].[Emp_BasicInfo] EB WHERE EmpBasicInfoID = @EmpId 
   END 
   ELSE 
   BEGIN
   		INSERT INTO [dbo].[HR_EmployeeTaxSetup]
					([CurrentSalary],[TaxAmount],[IsDeleted],[AddBy],[AddDate],[UpdateBy],[UpdateDate],[Remarks],[Status],[EmpId],[TaxYearId],[CategoryID])
		SELECT @CurrentSalary,@TaxAmount,0,@AddBy,GETDATE(),'',GETDATE(),'','A',@EmpId,@TaxYearId,@EmpCategory
							FROM [dbo].[Emp_BasicInfo] EB WHERE EmpBasicInfoID = @EmpId 
   

END


	SELECT @@ROWCOUNT AS TOTALLROWS

END



