IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[StudentAdvanceFees]'))
BEGIN
DROP PROCEDURE  StudentAdvanceFees
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE StudentAdvanceFees
	@ProcessTypeId int=null,
	@MonthId int =null,
	@ProcessType Varchar(1)
AS
BEGIN
DECLARE @PMonthId int
If(@MonthId=1)
Set @PMonthId=12
else
Set @PMonthId=@MonthId-1

Create Table #Fees_Advance
	(
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MonthId] int,
	[StudentIID] int ,
	[HeadId] int ,
	[AdvanceAmount] decimal(18,2)
	)

	Insert Into #Fees_Advance
	(
	[MonthId] ,
	[StudentIID],
	[HeadId],
	[AdvanceAmount]
	)
	 SELECT 
	[MonthId] ,
	[StudentIID],
	[HeadId],
	[AdvanceAmount] From Fees_Student where  MonthId=@PMonthId And AdvanceAmount>0

	Create table #Fees_Student
	(
	Id [bigint] IDENTITY(1,1) NOT NULL,
	[StudentIID] [bigint] NOT NULL,
	)

	Insert Into #Fees_Student ([StudentIID] )
   SELECT [StudentIID] From Fees_Student where  MonthId=@PMonthId And AdvanceAmount>0 group by StudentIID
 return 0;
END
