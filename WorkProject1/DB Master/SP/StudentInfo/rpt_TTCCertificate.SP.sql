/****** Object:  StoredProcedure [dbo].[DeleteOptionalSubject] by Evan   Script Date: 7/22/2017 3:23:34 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rpt_TTCCertificate]'))--- Transfer, Testimonial,Character Certificate
BEGIN
DROP PROCEDURE  [rpt_TTCCertificate]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[rpt_TTCCertificate]   ---  EXEC [rpt_TTCCertificate] 'TM', ',27,51,52,53,54,55,56,57,58,59,68'
@Type VARCHAR(100),
@StudentIID VARCHAR(1000)
AS
BEGIN
SELECT value  INTO #StuId
FROM STRING_SPLIT(@StudentIID, ',')  
  DECLARE @sql varchar(max)
 DECLARE @ClassId INT ,
  @Count INT ,
  @Num INT ,
  @FullName VARCHAR(50),
  @AdmissionDate VARCHAR(50),
  @DOB VARCHAR(50),
  @Resigtration VARCHAR(50),
  @ClassName VARCHAR(50),
  @SectionName VARCHAR(50),
  @SessionName VARCHAR(50),
  @GroupName VARCHAR(50),
  @ShiftName VARCHAR(50),
  @VersionName VARCHAR(50),
  @FatherName VARCHAR(100),
  @MotherName VARCHAR(100),
  @StuName VARCHAR(50),
  @StudentInsID VARCHAR(1000),
  @Roll VARCHAR(100),
  @Text VARCHAR(MAX),
  @Where varchar(MAX) = NULL	

  create table #tampTable(
  StudentIID int,
  StudentInsID varchar(200),
  Title1 varchar(2000),
  Title2 varchar(2000),
  BG_Image varbinary(MAX),
  [Text] varchar(MAX)
  )
  
SELECT sb.*,c.ClassName  ,SEC.SectionName,SES.SessionName,
 g.GroupName,Sh.ShiftName,v.VersionName,ROW_NUMBER() OVER (ORDER BY sb.StudentIID) ROWNUM INTO  #tempIstTable 
  FROM Student_BasicInfo SB
 JOIN Ins_Version V on V.VersionId=sb.VersionID and sb.StudentIID  IN( Select * FROM #StuId)
 JOIN Ins_ClassInfo C on C.ClassId=sb.ClassId 
 JOIN Ins_Branch B on B.BranchId=sb.BranchId 
 JOIN Ins_Group G on G.GroupId=sb.GroupId 
 JOIN Ins_Section SEC on SEC.SectionId=sb.SectionId 
 JOIN Ins_Session SES on SES.SessionId=sb.SessionId
 JOIN Ins_Shift Sh on Sh.ShiftID=sb.ShiftID

 set @Count =@@ROWCOUNT
 Set @Num =1
while @Num <= @Count
Begin
print @Num
SELECT @StudentIID=sb.StudentIID, @StudentInsID=sb.StudentInsID, @ClassId = sb.ClassId, @FullName = FullName,@AdmissionDate=sb.AdmissionDate,@DOB=sb.DateOfBirth,@Resigtration=sb.RegiNo,
  @ClassName = sb.ClassName ,@SectionName=sb.SectionName,@SessionName=sb.SessionName,
 @GroupName=sb.GroupName,@ShiftName=sb.ShiftName,@VersionName=sb.VersionName,@FatherName=sb.FatherName,@MotherName=sb.MotherName,@Roll=sb.RollNo
  FROM  #tempIstTable SB
   where SB.ROWNUM=@Num
  set @Text=null;
   SELECT @Text = [Text] FROM Ins_TC_Template tc WHERE tc.ClassId = @ClassId and tc.Type= @Type

 if(@StudentInsID is not null) begin   SET @Text = REPLACE( @Text ,'[StudentInsID]',' '+ @StudentInsID + ' ') end
 if(@AdmissionDate is not null)begin SET @Text = REPLACE( @Text ,'[AdmissionDate]',' '+format(cast(@AdmissionDate as date), 'MM/dd/yyyy') + ' ')end
 if(@DOB is not null)begin SET @Text = REPLACE( @Text ,'[DOB]',' '+format(cast(@DOB as date), 'MM/dd/yyyy') + ' ')end
 if(@FullName is not null)begin SET @Text = REPLACE( @Text ,'[FullName]',' '+ @FullName + ' ')end
 if(@Roll is not null)begin SET @Text = REPLACE( @Text ,'[Roll]', ' '+@Roll+ ' ')end
 if(@Resigtration is not null)begin SET @Text = REPLACE( @Text ,'[RegistrationNO]', ' '+@Resigtration+' ') end Else  Begin SET @Text = REPLACE( @Text ,'[RegistrationNO]', ' '+'_________'+' ') END
 if(@VersionName is not null)begin SET @Text = REPLACE( @Text ,'[Version]',' '+ @VersionName + ' ')end
 if(@ClassName is not null)begin SET @Text = REPLACE( @Text ,'[Class]', ' '+@ClassName + ' ')end
 if(@GroupName is not null)begin SET @Text = REPLACE( @Text ,'[Group]', ' '+@GroupName + ' ')end
 if(@SectionName is not null)begin SET @Text = REPLACE( @Text ,'[Section]', ' '+@SectionName + ' ')end
 if(@FatherName is not null)begin SET @Text = REPLACE( @Text ,'[FatherName]', ' '+@FatherName +' ')end
 if(@MotherName is not null)begin SET @Text = REPLACE( @Text ,'[Mother]', ' '+@MotherName + ' ')end
 if(@SessionName is not null)begin SET @Text = REPLACE( @Text ,'[Session]', ' '+@SessionName + ' ')end
  print @Text


	INSERT INTO #tampTable(StudentIID,StudentInsID, Title1, Title2, BG_Image,[Text]) 
	 SELECT @StudentIID, @StudentInsID, Title1,Title2,BG_Image,@Text
  FROM  Ins_TC_Template tt  WHERE tt.ClassId=@ClassId  and  Type= @Type

  Set @Num = @Num +1
End
select * from #tampTable

drop TABLE #tampTable
drop TABLE #tempIstTable
END



 



	
	--rpt_GetTransferCertificate 'TM' 2405


