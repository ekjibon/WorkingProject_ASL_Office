/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DateRange_To_Table]'))
BEGIN
DROP FUNCTION  DateRange_To_Table
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
CREATE FUNCTION [dbo].[DateRange_To_Table] ( @minDate_Str NVARCHAR(30), @maxDate_Str NVARCHAR(30))

RETURNS  @Result TABLE(DateString NVARCHAR(30) NOT NULL, DateNameString NVARCHAR(30) NOT NULL)

AS

begin

    DECLARE @minDate DATETIME, @maxDate DATETIME
    SET @minDate = CONVERT(Datetime, @minDate_Str,23)
    SET @maxDate = CONVERT(Datetime, @maxDate_Str,23)


    INSERT INTO @Result(DateString, DateNameString )
    SELECT CONVERT(DATETIME,@minDate,23), CONVERT(NVARCHAR(30),DATENAME(dw,@minDate))



    WHILE @maxDate > @minDate
    BEGIN
        SET @minDate = (SELECT DATEADD(dd,1,@minDate))
        INSERT INTO @Result(DateString, DateNameString )
        SELECT CONVERT(DATETIME,@minDate,23), CONVERT(NVARCHAR(30),DATENAME(dw,@minDate))
    END




    return

end  