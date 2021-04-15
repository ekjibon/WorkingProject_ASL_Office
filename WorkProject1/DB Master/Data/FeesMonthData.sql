SELECT * FROM Fees_FeesMonth




	ALTER TABLE [dbo].[Fees_FeesMonth] NOCHECK CONSTRAINT ALL
	ALTER TABLE [dbo].[Fees_FeesMonth] DISABLE TRIGGER ALL
	DELETE FROM [dbo].[Fees_FeesMonth]
	DBCC CHECKIDENT ('[dbo].[Fees_FeesMonth]',RESEED, 0)
	ALTER TABLE [dbo].[Fees_FeesMonth] CHECK CONSTRAINT ALL
	ALTER TABLE [dbo].[Fees_FeesMonth] ENABLE TRIGGER ALL

	

INSERT INTO [dbo].[Fees_FeesMonth]([MonthName]) values('January')
INSERT INTO [dbo].[Fees_FeesMonth]([MonthName]) values('February')
INSERT INTO [dbo].[Fees_FeesMonth]([MonthName]) values('March')
INSERT INTO [dbo].[Fees_FeesMonth]([MonthName]) values('April')
INSERT INTO [dbo].[Fees_FeesMonth]([MonthName]) values('May')
INSERT INTO [dbo].[Fees_FeesMonth]([MonthName]) values('June')
INSERT INTO [dbo].[Fees_FeesMonth]([MonthName]) values('July')
INSERT INTO [dbo].[Fees_FeesMonth]([MonthName]) values('August')
INSERT INTO [dbo].[Fees_FeesMonth]([MonthName]) values('September')
INSERT INTO [dbo].[Fees_FeesMonth]([MonthName]) values('October')
INSERT INTO [dbo].[Fees_FeesMonth]([MonthName]) values('November')
INSERT INTO [dbo].[Fees_FeesMonth]([MonthName]) values('December')

