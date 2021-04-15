/****** Object:  StoredProcedure [dbo].[InsertEmployeeLeaveQouta]    Script Date: 5/4/2020 11:15:16 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[InsertEmployeeReward]'))
BEGIN
DROP PROCEDURE  [InsertEmployeeReward]
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
-- 
CREATE PROCEDURE [dbo].[InsertEmployeeReward]

	@EmpId INT,
	@RewardAmount Decimal(18,2),
	@AddBy VARCHAR(MAX)
	


AS
BEGIN
 DELETE ERE FROM [dbo].[HR_Reward] ERE
				   WHERE ERE.EmpId = @EmpId 

   IF(@@ROWCOUNT>0)
   BEGIN 
   		INSERT INTO [dbo].[HR_Reward]
					([EmpId],[RewardAmount],[IsDeleted],[AddBy],[AddDate],[UpdateBy],[UpdateDate],[Remarks],[Status])
		       SELECT @EmpId,@RewardAmount,0,@AddBy,GETDATE(),'',GETDATE(),'','A'
					  FROM [dbo].[Emp_BasicInfo] EB WHERE EmpBasicInfoID = @EmpId 
   END 
   ELSE 
   BEGIN
   		INSERT INTO [dbo].[HR_Reward]
					([EmpId],[RewardAmount],[IsDeleted],[AddBy],[AddDate],[UpdateBy],[UpdateDate],[Remarks],[Status])
		       SELECT @EmpId,@RewardAmount,0,@AddBy,GETDATE(),'',GETDATE(),'','A'
					  FROM [dbo].[Emp_BasicInfo] EB WHERE EmpBasicInfoID = @EmpId 
   

END


	SELECT @@ROWCOUNT AS TOTALLROWS

END