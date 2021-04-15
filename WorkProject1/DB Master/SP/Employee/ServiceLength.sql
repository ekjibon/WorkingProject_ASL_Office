-- =============================================
-- Author:		Azmal
-- Create date: 2020-04-5
-- Description:	
-- =============================================
--  select dbo.fnServiceLength('2011-05-20 18:00:00.000','2020-04-5 18:00:00.000') 
Alter function dbo.fnServiceLength  
(@JoiningDate datetime,
@TodayDate datetime
)  
returns varchar(100)  
as  
BEGIN  
    DECLARE @date datetime, @tmpdate datetime, @years int, @months int, @days int  
    DECLARE @Age varchar(50)  
    set @Age=''  
    SELECT @tmpdate = @JoiningDate  
      
    SELECT @years = DATEDIFF(yy, @tmpdate, @TodayDate) - CASE WHEN (MONTH(@JoiningDate) > MONTH(@TodayDate)) OR (MONTH(@JoiningDate) = MONTH(@TodayDate) AND DAY(@JoiningDate) > DAY(@TodayDate)) THEN 1 ELSE 0 END  
    SELECT @tmpdate = DATEADD(yy, @years, @tmpdate)  
    SELECT @months = DATEDIFF(m, @tmpdate, @TodayDate) - CASE WHEN DAY(@JoiningDate) > DAY(@TodayDate) THEN 1 ELSE 0 END  
    SELECT @tmpdate = DATEADD(m, @months, @tmpdate)  
    SELECT @days = DATEDIFF(d, @tmpdate, @TodayDate)  
      
    set @Age=convert(varchar(50),@years)+' Years '+convert(varchar(50),@months)+' Months '+convert(varchar(50),@days)+' Days';  
    return @Age  
END 