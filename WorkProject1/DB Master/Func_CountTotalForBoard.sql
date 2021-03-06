IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[StatusWiseIssueCount]'))
BEGIN
DROP FUNCTION  StatusWiseIssueCount
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[StatusWiseIssueCount]
(
	@StatusId INT,
	@ProjectId INT, 
	@ClientId INT,
	@AssigneeId INT,
	@ReporterId  INT,
	@Priority VARCHAR(MAX),
	@IssueTypeId INT,
	@DueDate DATETIME
)
RETURNS INT

-- SELECT dbo.StatusWiseIssueCount(6,18,68,24,24,'Medium',2, '2020-12-14')
-- SELECT dbo.StatusWiseIssueCount(6,NULL,NULL,NULL,NULL,NULL,NULL,'2020-12-14')
AS
BEGIN
	DECLARE @Total INT 
	SELECT  @Total = COUNT(*)
	FROM dbo.Task_Issue AS I
	WHERE I.IsDeleted = 0 AND I.StatusId = @StatusId
		AND	I.Priority =  ISNULL(@Priority,I.Priority) 
		AND ISNULL(I.IssueTypeId,0) =  ISNULL(@IssueTypeId,ISNULL(I.IssueTypeId,0))
		AND ISNULL(I.ProjectId,0) =  ISNULL(@ProjectId,ISNULL(I.ProjectId,0)) 
		AND ISNULL(I.ClientId,0) =  ISNULL(@ClientId,ISNULL(I.ClientId,0))
		AND ISNULL(I.AssigneeId,0) =  ISNULL(@AssigneeId,ISNULL(I.AssigneeId,0))
		AND ISNULL(I.ReporterId,0) =  ISNULL(@ReporterId,ISNULL(I.ReporterId,0))
		AND  CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) IN (CAST(ISNULL(@DueDate, ISNULL(I.DueDate,I.AddDate)) AS DATE))

		RETURN @Total
END