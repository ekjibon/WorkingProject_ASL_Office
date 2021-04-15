IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetIssueBoardList]'))
BEGIN
DROP PROCEDURE  GetIssueBoardList
END
GO
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Arifur>
-- Create date: <Create Date,11-01-2021,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE GetIssueBoardList
	@Block INT=0,
	@Where VARCHAR(MAX),
	@pageno INT =1,
	@pageSize INT =10
AS
BEGIN
	IF(@Block=1)
	BEGIN
		DECLARE @sql VARCHAR(MAX) = ''
	SET @sql = 'SELECT  I.*, IT.IssueTypeName, P.ProjectName, S.SprintTitle,U.Id AS ReporterUserId,U.FullName AS ReporterName
							,AU.FullName AS AssigneeName,TS.StatusName,Au.Id AS AssigneeUserId, P.DepartmentId 							
							,(CASE WHEN I.ParentId IS NULL OR I.ParentId = 0 THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END) AS IsParent
							,(CASE WHEN  CAST(ISNULL(I.EndDate,I.StartDate) AS DATE) > CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) THEN 1 
								WHEN   I.StartDate IS NULL AND CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) < CAST(GETDATE() AS DATE) THEN 1 
							ELSE 0 END) AS IsOverDue
						FROM dbo.Task_Issue AS I
						LEFT JOIN dbo.Task_IssueType IT ON IT.Id = I.IssueTypeId
						LEFT JOIN dbo.Task_Project P ON P.Id = I.ProjectId 
						LEFT JOIN dbo.CRM_Client C ON  ISNULL(C.Id,0) = ISNULL(I.ClientId ,0 )
						LEFT JOIN dbo.Task_Sprint S ON S.Id = I.SprintId 
						LEFT JOIN dbo.AspNetUsers U ON ISNULL(U.EmpId,0) = ISNULL(I.ReporterId ,0)
						LEFT JOIN dbo.AspNetUsers AU ON ISNULL(AU.EmpId,0) = ISNULL(I.AssigneeId ,0)
						LEFT JOIN dbo.Task_Status TS ON ISNULL(TS.Id,0) = ISNULL(I.StatusId ,0) '
					IF(@Where <> '' AND @Where IS NOT NULL)
					BEGIN
						SET @sql  = @sql + ' WHERE ' + @Where
					END

					SET @sql = @sql + '  ORDER BY I.Id DESC OFFSET ' + CAST(((@pageno - 1) * @pageSize) AS varchar(MAX)) +' ROWS FETCH NEXT '+CAST(@pageSize AS VARCHAR(MAX))+' ROWS ONLY';
		PRINT @sql
		EXECUTE (@sql)	
	END
END
GO
-- EXEC GetIssueBoardList 1,'   I.IsDeleted = 0 AND I.StatusId = 3 AND  CAST(ISNULL(I.DueDate,I.AddDate) AS DATE) IN (CAST(ISNULL(''2021-01-12T18:00:00.000Z'', ISNULL(I.DueDate,I.AddDate)) AS DATE))  ',1,40