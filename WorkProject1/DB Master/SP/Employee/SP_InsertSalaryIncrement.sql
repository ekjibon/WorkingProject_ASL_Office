
/****** Object:  StoredProcedure [dbo].[SP_InsertSalaryIncrement]    Script Date: 5/10/2020 10:52:23 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_InsertSalaryIncrement]'))
BEGIN
DROP PROCEDURE  [SP_InsertSalaryIncrement]
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		AZMAL/Khaled
-- Create date: 5/6/2020 
-- Description:	
-- =============================================
-- 
CREATE PROCEDURE [dbo].[SP_InsertSalaryIncrement]
(
	@EmpId INT,
	@Amount INT,
	@IsPercentage INT, 
	@GrossSalary INT,
	@AmountAfterIncrement INT,
	@Remarks NVARCHAR(150),
	@AddBy VARCHAR(MAX)
	
)

AS
BEGIN
DECLARE @SalaryYearId INT=0
SET @SalaryYearId= (SELECT Top 1 Id FROM HR_SalaryYear WHERE Status='A' and IsDeleted=0 order by Id desc)
   
   	INSERT INTO [dbo].[HR_SalaryIncrement]( EmpId, Amount, IsPercentage, IsDeleted, AddBy, AddDate, Remarks, Status,  SalaryYearId, GrossSalary, AmountAfterIncrement)
		
	VALUES( @EmpId,@Amount,@IsPercentage,0,@AddBy,GETDATE(),@Remarks,'A',@SalaryYearId,@GrossSalary,@AmountAfterIncrement)

 --Start Add by khaled 10/05/2020

DECLARE @COUNTER INT = 0,@MAXID INT = 0,@HeadId INT,@Amunt DECIMAL(10,2),@CategoryID INT = 0
SELECT @CategoryID=CategoryID FROM Emp_BasicInfo WHERE EmpBasicInfoID = @EmpId
UPDATE Emp_BasicInfo
SET CurrentSalary = @AmountAfterIncrement WHERE EmpBasicInfoID = @EmpId

DELETE FROM dbo.HR_SalaryStructure WHERE EmpId = @EmpId AND CategoryID = @CategoryID

CREATE TABLE #test
(
Id int IDENTITY(1,1),
HeadId INT, 
Amount FLoat 
)

INSERT INTO #test (HeadId,Amount)
SELECT HeadId,Amount From HR_SalaryHeadWiseConfig Where CategoryID =@CategoryID And IsDeleted =0

   SELECT * FROM #test
	SELECT  @MAXID = @@ROWCOUNT
	SET @COUNTER = 1
	WHILE(@COUNTER <= @MAXID)
	BEGIN

	SELECT @HeadId=HeadId,@Amunt=Amount FROM #test WHERE Id = @COUNTER
	    
			INSERT INTO dbo.HR_SalaryStructure
		(HeadId,EmpId,CurrentSalary,Amount,IsDeleted,AddBy,AddDate,[Status],CategoryID)
		Values(@HeadId,@EmpId,@AmountAfterIncrement,dbo.SalarypercentageAmount(@AmountAfterIncrement,@Amunt),0,@AddBy,GETDATE(),'A',@CategoryID)	
	
		
		SET @COUNTER = @COUNTER + 1;
	END
	
	--End			
 
END
