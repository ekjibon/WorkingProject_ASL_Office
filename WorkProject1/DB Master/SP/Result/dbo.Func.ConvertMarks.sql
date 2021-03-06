/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ConvertMarks]'))
BEGIN
DROP FUNCTION  ConvertMarks
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Biplob>
-- Create date: <01-Jun-2017,>
-- Description:	<For Latter grade ad GP  Calculation>
-- =============================================

CREATE FUNCTION [dbo].[ConvertMarks]
(
 @Marks decimal(10,2) ,
 @Format Varchar(1)
)
RETURNS  decimal(10,2)
AS
BEGIN
/*
O= Orginal
C= Ceiling 
F= floor
R=Round
*/
IF(@Format='R')
 RETURN Round(@Marks,0)
ELSE IF(@Format='C')
RETURN  CEILING(@Marks)
ELSE IF(@Format='F')
RETURN  FLOOR(@Marks)
ELSE 
RETURN  @Marks

RETURN  @Marks
END

GO


