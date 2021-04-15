/****** Object:  StoredProcedure [dbo].[SP_GetEmpAllInfo]    Script Date: 11/18/2017 6:37:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetPaySlipGenerate]'))
BEGIN
DROP PROCEDURE  GetPaySlipGenerate
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPaySlipGenerate] 

@PeriodId INT,
@MonthId Int


AS
BEGIN

select * from dbo.HR_SalaryHeadWiseConfig shwc on shwc.HeadId
END

