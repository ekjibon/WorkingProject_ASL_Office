IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[InsertSalaryStructure]'))
BEGIN
DROP PROCEDURE  [InsertSalaryStructure]
END
GO
/****** Object:  StoredProcedure [dbo].[InsertSalaryStructure]    **/ -- khaled
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[InsertSalaryStructure] 1,1,100,'admin'
Create Procedure [dbo].[InsertSalaryStructure]
(
@CategoryID int =0,
@HeadId varchar(100),
@Amount  DECIMAL(10,2) =0,
@AddBy varchar(100)

)
As
BEGIN

DELETE [dbo].[HR_SalaryStructure] WHERE HeadId = @HeadId AND CategoryID = @CategoryID

DECLARE @COUNTER INT = 0,@MAXID INT = 0,@EmpId int,@CurrentSalary decimal(10,2)

INSERT INTO dbo.HR_SalaryStructure
		(HeadId,EmpId,CurrentSalary,Amount,IsDeleted,AddBy,AddDate,[Status],CategoryID)
		SELECT @HeadId,EmpBasicInfoID,CurrentSalary,dbo.SalarypercentageAmount(CurrentSalary,@Amount),0,@AddBy,GETDATE(),'A',CategoryID FROM Emp_BasicInfo WHERE CategoryID =@CategoryID AND CurrentSalary <> 0

--SELECT * From Emp_BasicInfo Where CategoryID =@CategoryID
--	SELECT @MAXID = @@ROWCOUNT
--	SET @COUNTER = 1
--	WHILE(@COUNTER <= @MAXID)
--	BEGIN
--	  --  SELECT  EmpID,CurrentSalary   FROM Emp_BasicInfo WHERE EmpBasicInfoID = @COUNTER
				
--	INSERT INTO dbo.HR_SalaryStructure
--		(HeadId,EmpId,CurrentSalary,Amount,IsDeleted,AddBy,AddDate,[Status],CategoryID)
--		SELECT @HeadId,EmpID,CurrentSalary,dbo.SalarypercentageAmount(CurrentSalary,@Amount),0,@AddBy,GETDATE(),'A',@CategoryID FROM Emp_BasicInfo WHERE EmpBasicInfoID = @COUNTER
		
--		SET @COUNTER = @COUNTER + 1;
--	END
		

END





