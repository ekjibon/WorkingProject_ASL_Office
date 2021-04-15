IF type_id('dbo.UTT_CommentDetails') IS NOT NULL
BEGIN
 -- DROP PROCEDURE transactiondetailinsert 
	DROP TYPE dbo.UTT_CommentDetails;
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TYPE dbo.UTT_CommentDetails AS TABLE 
(
	
	[Comments] VARCHAR(MAX)
	
)
GO