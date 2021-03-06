/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAccCodeById]'))
BEGIN
DROP FUNCTION  GetAccCodeById
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- SELECT dbo.GetAccCodeById(313,4)

CREATE FUNCTION [dbo].[GetAccCodeById]
(	
	@LedgerId INT,
	@RootId INT
)
RETURNS  NVARCHAR(MAX)
AS
BEGIN
	DECLARE @Code NVARCHAR(MAX) ,@Prefix  NVARCHAR(MAX), @Surfix NVARCHAR(MAX),@Seperator NVARCHAR(MAX),@Length INT , @LastCount INT

	SELECT @LastCount = COUNT(LedgerId) FROM ACC_Ledgers WHERE ParentId !=0 AND RootGroupId = @RootId	 AND LedgerId<@LedgerId
	SET @LastCount =  @LastCount +1

	SELECT @Prefix = ISNULL(Prefix,''), @Surfix = ISNULL( Surfix,'') ,@Seperator = ISNULL( Seperator,'') , @Length = [Length] FROM ACC_RootGroup WHERE Id = @RootId
	
	IF(@Prefix = 'AAA')
	BEGIN
	 SELECT @Prefix = RIGHT('000'+ISNULL(CAST(@LastCount AS VARCHAR(MAX)),''),3)
	END
	ELSE IF(@Prefix = 'AA')
	BEGIN
	 SELECT @Prefix = RIGHT('00'+ISNULL(CAST(@LastCount AS VARCHAR(MAX)),''),2)
	END

	IF(@Surfix = 'AAA')
	BEGIN
	 SELECT @Surfix = RIGHT('000'+ISNULL(CAST(@LastCount AS VARCHAR(MAX)),''),3)
	END
	ELSE IF(@Surfix = 'AA')
	BEGIN
	 SELECT @Surfix = RIGHT('00'+ISNULL(CAST(@LastCount AS VARCHAR(MAX)),''),2)
	END
	 --SELECT RIGHT('000'+ISNULL('20',''),3)
	 
	 SET @Code = @Prefix +@Seperator+ @Surfix

	RETURN @Code

END


GO
