IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAllSalaryHeadWiseConfig]'))
BEGIN
DROP PROCEDURE  GetAllSalaryHeadWiseConfig
END
GO
/****** Object:  StoredProcedure [dbo].[GetAllSalaryHeadWiseConfig]    Script Date: 7/15/2019 6:29:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create procedure [dbo].[GetAllSalaryHeadWiseConfig]

as 
begin
	
	select h.Id as HeadId,h.HeadName ,s.Id,s.Amount,s.IsPercentage,s.MaxAmount,s.MinAmount
	from HR_SalaryHeadWiseConfig s
	inner join HR_SalaryHead h on s.HeadId=h.Id
	where s.IsDeleted=0
end


