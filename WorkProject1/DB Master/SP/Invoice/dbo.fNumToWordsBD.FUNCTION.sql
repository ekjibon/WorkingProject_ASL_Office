IF OBJECT_ID('fConvertDigit') IS NOT NULL
DROP FUNCTION fConvertDigit
go
create Function dbo.fConvertDigit(@decNumber decimal)
returns varchar(6)
as
Begin
declare
@strWords varchar(6)
Select @strWords = Case @decNumber
When '1' then 'One'
When '2' then 'Two'
When '3' then 'Three'
When '4' then 'Four'
When '5' then 'Five'
When '6' then 'Six'
When '7' then 'Seven'
When '8' then 'Eight'
When '9' then 'Nine'
Else ''
end
return @strWords

end
 
--Function  2: 
go
 IF OBJECT_ID('fConvertTens') IS NOT NULL
DROP FUNCTION fConvertTens
go
create Function dbo.fConvertTens(@decNumber varchar(2))
returns varchar(30)
as
Begin
declare @strWords varchar(30)
--Is value between 10 and 19?
If Left(@decNumber, 1) = 1
begin
Select @strWords = Case @decNumber
When '10' then 'Ten'
When '11' then 'Eleven'
When '12' then 'Twelve'
When '13' then 'Thirteen'
When '14' then 'Fourteen'
When '15' then 'Fifteen'
When '16' then 'Sixteen'
When '17' then 'Seventeen'
When '18' then 'Eighteen'
When '19' then 'Nineteen'
end
end
else -- otherwise it's between 20 and 99.
begin
Select @strWords = Case Left(@decNumber, 1)
When '0' then ''
When '2' then 'Twenty '
When '3' then 'Thirty '
When '4' then 'Forty '
When '5' then 'Fifty '
When '6' then 'Sixty '
When '7' then 'Seventy '
When '8' then 'Eighty '
When '9' then 'Ninety '
end
Select @strWords = @strWords + dbo.fConvertDigit(Right(@decNumber, 1))
end
--Convert ones place digit.

return @strWords
end 
--Function  3                 : 
 go
IF OBJECT_ID('fNumToWordsBD') IS NOT NULL
DROP FUNCTION fNumToWordsBD
go
create function dbo.fNumToWordsBD (@decNumber decimal(12, 2))
returns varchar(300)
As
Begin
Declare
@strNumber varchar(100),
@strMoneys varchar(200),
@strPaise varchar(100),
@strWords varchar(300),
@intIndex integer,
@intAndFlag integer

Select @strNumber = Cast(@decNumber as varchar(100))
Select @intIndex = CharIndex('.', @strNumber)
if(@decNumber>99999999.99)
BEGIN
RETURN ''
END
If @intIndex > 0
begin
Select @strPaise = dbo.fConvertTens(Right(@strNumber, Len(@strNumber) - @intIndex))
Select @strNumber = SubString(@strNumber, 1, Len(@strNumber) - 3)
If Len(@strPaise) > 0 Select @strPaise = @strPaise + ' paisa'
end
Select @strMoneys = ''
Select @intIndex=len(@strNumber)
Select @intAndFlag=2
while(@intIndex>0)
begin
if(@intIndex=8)
begin
Select @strMoneys=@strMoneys+dbo.fConvertDigit(left(@decNumber,1))+' Crore '
Select @strNumber=substring(@strNumber,2,len(@strNumber))
Select @intIndex=@intIndex-1

end
else if(@intIndex=7)
begin
if(substring(@strNumber,1,1)='0')
begin
if substring(@strNumber,2,1)<>'0'
begin
if (@strMoneys<>NULL and substring(@strNumber,3,1)='0'
and substring(@strNumber,4,1)='0' and substring(@strNumber,5,1)='0'
and substring(@strNumber,6,1)='0' and substring(@strNumber,7,1)='0'
and @intAndFlag=2 and @strPaise=NULL)
begin
Select @strMoneys=@strMoneys+' and ' +dbo.fConvertDigit(substring(@strNumber,2,1))+' Lac Taka'
Select @intAndFlag=1
end
else
begin
Select @strMoneys=@strMoneys+dbo.fConvertDigit(substring(@strNumber,2,1))+' Lac '
end

Select @strNumber=substring(@strNumber,3,len(@strNumber))
Select @intIndex=@intIndex-2
end
else
begin
Select @strNumber=substring(@strNumber,3,len(@strNumber))
Select @intIndex=@intIndex-2
end
end
else
begin
if(substring(@strNumber,3,1)='0' and substring(@strNumber,4,1)='0' and
substring(@strNumber,5,1)='0' and substring(@strNumber,6,1)='0' and
substring(@strNumber,7,1)='0' and @intAndFlag=2 and @strPaise='')
begin
Select @strMoneys=@strMoneys+' and ' + dbo.fConvertTens(substring(@strNumber,1,2))+' Lac Taka'
Select @intAndFlag=1
end
else
begin
Select @strMoneys=@strMoneys+dbo.fConvertTens(substring(@strNumber,1,2))+' Lac '
end
Select @strNumber=substring(@strNumber,3,len(@strNumber))
Select @intIndex=@intIndex-2
end
end
else if(@intIndex=6)
begin
if(substring(@strNumber,2,1)<>'0' or substring(@strNumber,3,1)<>'0'
and substring(@strNumber,4,1)='0' and substring(@strNumber,5,1)='0' and
substring(@strNumber,6,1)='0' and @intAndFlag=2 and @strPaise='')
begin

if len(@strMoneys) <= 0
begin
if convert(int,substring(@strNumber,1,1)) = 1
begin
Select @strMoneys=@strMoneys+'' + dbo.fConvertDigit(substring(@strNumber,1,1))+' Lac '
Select @intAndFlag=2
end
else
begin
Select @strMoneys=@strMoneys+'' + dbo.fConvertDigit(substring(@strNumber,1,1))+' Lac '
Select @intAndFlag=2
end
end
else
begin
if convert(int,substring(@strNumber,1,1)) = 1
begin
Select @strMoneys=@strMoneys+' and' + dbo.fConvertDigit(substring(@strNumber,1,1))+' Lac '
Select @intAndFlag=1
end
else
begin
Select @strMoneys=@strMoneys+' and' + dbo.fConvertDigit(substring(@strNumber,1,1))+' Lac '
Select @intAndFlag=1
end
end
end
else
begin
if convert(int,substring(@strNumber,1,1)) = 1
begin
Select @strMoneys=@strMoneys+dbo.fConvertDigit(substring(@strNumber,1,1))+' Lac '
end
else
begin
Select @strMoneys=@strMoneys+dbo.fConvertDigit(substring(@strNumber,1,1))+' Lac '
end
end
Select @strNumber=substring(@strNumber,2,len(@strNumber))
Select @intIndex=@intIndex-1
end
else if(@intIndex=5)
begin
if(substring(@strNumber,1,1)='0')
begin
if substring(@strNumber,2,1)<>'0'
begin
if(substring(@strNumber,3,1)='0' and substring(@strNumber,4,1)='0'
and substring(@strNumber,5,1)='0' and @intAndFlag=2 and @strPaise='')
begin
Select @strMoneys=@strMoneys+' and ' +dbo.fConvertDigit(substring(@strNumber,2,1))+' Thousand Taka'
Select @intAndFlag=1
end
else
begin
Select @strMoneys=@strMoneys+dbo.fConvertDigit(substring(@strNumber,2,1))+' Thousand '
end
Select @strNumber=substring(@strNumber,3,len(@strNumber))
Select @intIndex=@intIndex-2
end
else
begin
Select @strNumber=substring(@strNumber,3,len(@strNumber))
Select @intIndex=@intIndex-2
end
end
else
begin
if(substring(@strNumber,3,1)='0' and substring(@strNumber,4,1)='0'
and substring(@strNumber,5,1)='0' and @intAndFlag=2 and @strPaise='')
begin
--Select @strMoneys=@strMoneys+'andjo'+dbo.fConvertTens(substring(@strNumber,1,2))+' Thousand '
Select @strMoneys=@strMoneys+dbo.fConvertTens(substring(@strNumber,1,2))+' Thousand Taka'
Select @intAndFlag=1
end
else
begin
Select @strMoneys=@strMoneys+dbo.fConvertTens(substring(@strNumber,1,2))+' Thousand '
end
Select @strNumber=substring(@strNumber,3,len(@strNumber))
Select @intIndex=@intIndex-2
end
end
else if(@intIndex=4)
begin
if ( (substring(@strNumber,3,1)<>'0' or substring(@strNumber,4,1)<>'0') and
substring(@strNumber,2,1)='0' and @intAndFlag=2 and @strPaise='')
begin
Select @strMoneys=@strMoneys+' and' + dbo.fConvertDigit(substring(@strNumber,1,1))+' Thousand Taka'
Select @intAndFlag=1
end
else
begin
Select @strMoneys=@strMoneys+dbo.fConvertDigit(substring(@strNumber,1,1))+' Thousand '
end
Select @strNumber=substring(@strNumber,2,len(@strNumber))
Select @intIndex=@intIndex-1
end
else if(@intIndex=3)
begin
if ( (substring(@strNumber,1,1)<>'0' or substring(@strNumber,3,1)<>'0')  and @intAndFlag=1 and @strPaise='')
begin
Select @strMoneys=@strMoneys+' and ' + dbo.fConvertDigit(substring(@strNumber,1,1))+' Hundred Taka'
Select @intAndFlag=1
end
--else
--begin
--Select @strMoneys=@strMoneys+dbo.fConvertDigit(substring(@strNumber,1,1))+' Hundred '
--end
if substring(@strNumber,1,1)<>'0'
begin
Select @strMoneys=@strMoneys+dbo.fConvertDigit(substring(@strNumber,1,1))+' Hundred '
Select @strNumber=substring(@strNumber,2,len(@strNumber))

if( (substring(@strNumber,1,1)<>'0' or substring(@strNumber,2,1)<>'0') and
@intAndFlag=2 and @strPaise='')
begin
Select @strMoneys=@strMoneys+' and '
Select @intAndFlag=1
end
Select @intIndex=@intIndex-1
end
else
begin
Select @strNumber=substring(@strNumber,2,len(@strNumber))
Select @intIndex=@intIndex-1
end
end
else if(@intIndex=2)
begin
if substring(@strNumber,1,1)<>'0'
begin
Select @strMoneys=@strMoneys+dbo.fConvertTens(substring(@strNumber,1,2)) +' Taka '
Select @intIndex=@intIndex-2
end
else
begin
Select @intIndex=@intIndex-1
end
end
else if(@intIndex=1)
begin
if(@strNumber<>'0')
begin
Select @strMoneys=@strMoneys+dbo.fConvertDigit(@strNumber)
end
Select @intIndex=@intIndex-1

end
continue
end
if len(@strMoneys)>0 Select @strMoneys=@strMoneys
IF(len(@strPaise)<>0)
BEGIN
if len(@strMoneys)>0 Select @strMoneys=@strMoneys + ' and '
END
Select @strWords = IsNull(@strMoneys, '') + IsNull(@strPaise, '')
select @strWords = @strWords 
Return @strWords
End