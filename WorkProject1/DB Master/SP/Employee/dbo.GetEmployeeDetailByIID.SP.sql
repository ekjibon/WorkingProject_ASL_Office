
/****** Object:  StoredProcedure [dbo].[rpt_GetStudentInfoByIID]    Script Date: 7/22/2017 4:37:23 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmployeeDetailByIID]'))
BEGIN
DROP PROCEDURE  [dbo].GetEmployeeDetailByIID 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC [dbo].[GetStudentDetailByIID]  201

CREATE PROCEDURE [dbo].GetEmployeeDetailByIID
	@StudentIID BIGINT
AS
BEGIN
--1.Student Info

END



