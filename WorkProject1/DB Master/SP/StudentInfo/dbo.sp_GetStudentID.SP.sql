/****** Object:  StoredProcedure [dbo].[sp_GetStudentID]    Script Date: 7/22/2017 4:42:46 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[sp_GetStudentID]'))
BEGIN
DROP PROCEDURE  sp_GetStudentID
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--  execute [dbo].[sp_GetStudentID] 15,8,2,19,76,2,8,'School'

CREATE PROCEDURE [dbo].[sp_GetStudentID]
(
	@SessionID INT,
	@BranchID INT,
	@ShiftID INT,
	@ClassID INT,
	@SectionID INT,
	@StudentTypeID INT,
	@HouseID INT,
	@CinfigType VARCHAR(20)
	
)	
AS
DECLARE @SelectedConfig TABLE 
(
	ConfigName VARCHAR(50),
	IsSelected BIT,
	Prefix VARCHAR(2),
	_Length INT,
	Postfix VARCHAR(2),
	IsReset BIT,
	_ORDER INT,
	Seperator VARCHAR(1)
)
DECLARE @sid VARCHAR(20)
DECLARE @VarConfigName VARCHAR(50)
DECLARE @tag VARCHAR(100)
DECLARE @newtag VARCHAR(100)
DECLARE @Qry NVARCHAR(max)
DECLARE @newQry NVARCHAR(MAX)

DECLARE @sessionCode VARCHAR(4)
DECLARE @branchCode VARCHAR(4)
DECLARE @shiftCode VARCHAR(3)
DECLARE @classCode VARCHAR(3)
DECLARE @sectionCode VARCHAR(3)
DECLARE @studentTypeCode VARCHAR(3)
DECLARE @houseCode VARCHAR(3)
DECLARE @academicCode VARCHAR(3)

DECLARE @ForCollege BIT
DECLARE @reset BIT
DECLARE @prefix VARCHAR(2)
DECLARE @postifx VARCHAR(2)
DECLARE @seperator VARCHAR(1)
DECLARE @ConfigLength int
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
SET @Qry='';
SET @tag='';
SET @newtag='';
SET @newQry='';
 -------------- Get Who Is Selected Order by Order from Tbl_IDConfig---------------------------------------------------------------
INSERT INTO @SelectedConfig 
SELECT
 	ISNULL(i.ConfigName,''),
 	ISNULL(i.IsSelected,''),
 	ISNULL(i.Prefix,''),
 	ISNULL(i.Length,''),
 	ISNULL(i.Postfix,''),
 	ISNULL(i.IsReset,''),
 	ISNULL(i.[Order],''),
 	ISNULL(i.Seperator,'')
 FROM
 	Ins_IDConfig i WHERE i.IsSelected=1 and i.ConfigType=@CinfigType ORDER BY i.[Order]
 	
 	--SELECT
 	--	sc.ConfigName,
 	--	sc.IsSelected,
 	--	sc.Prefix,
 	--	sc._Length,
 	--	sc.Postfix,
 	--	sc.IsReset,
 	--	sc._ORDER,
 	--	sc.Seperator
 	--FROM
 	--	@SelectedConfig sc
 --------------------------------------------------------------------------------------------------------------------------------
 
----select each row from SelectedConfig Table------

----Declare Cursor....................
DECLARE config_Cursor CURSOR FOR 
SELECT
	sc.ConfigName
FROM
	@SelectedConfig sc ORDER BY sc._Order
----------------------------------------

----- Open Cursor----------------
 OPEN config_Cursor;
------------------------------

------ Fetch each Name-------------------------

FETCH NEXT FROM config_Cursor INTO @VarConfigName;
----------------------------------------------------
----Start Looping................................................
WHILE @@FETCH_STATUS = 0
BEGIN




------  Check Academic ID  -----------------------

	------ Check @studentTypeCode----------------------------
	IF(@VarConfigName='AcademicCode')
	BEGIN
	
	-------Select Prefix,Postfix,Seperator-------------
	SELECT
	@prefix=	sc.Prefix,
	@postifx=	sc.Postfix,
	@seperator=	sc.Seperator,
	@ConfigLength=sc._Length
	FROM
		@SelectedConfig sc WHERE sc.ConfigName=@VarConfigName
---------------------------------------------------------
---select reset id..........................
	SELECT @reset= sc.IsReset FROM @SelectedConfig sc WHERE sc.ConfigName=@VarConfigName
	
		Print '@AcademicCode------------------------:' print @Qry
----------------------------------------------------
------select verion code	
	--SELECT @academicCode =a.AcademicSection_Code FROM Ins_AcademicSection a WHERE a.AcademicSection_ID=1
--------------------------------------------------------------------------------------------------------------------
---Prepare Tag------	
	--SET @newtag=@prefix+@academicCode+@postifx+@seperator;
	--SET @tag=@tag+@newtag;
	--SELECT @tag AS forVersion
	END
	-----------------------------------------------------

	------  End Academic ID  ---------------------












------  Check House ID  -----------------------

	------ Check @studentTypeCode----------------------------
	IF(@VarConfigName='HouseCode')
	BEGIN
	
	-------Select Prefix,Postfix,Seperator-------------
	SELECT
	@prefix=	sc.Prefix,
	@postifx=	sc.Postfix,
	@seperator=	sc.Seperator,
	@ConfigLength=sc._Length
	FROM
		@SelectedConfig sc WHERE sc.ConfigName=@VarConfigName
---------------------------------------------------------
---select reset id..........................
	SELECT @reset= sc.IsReset FROM @SelectedConfig sc WHERE sc.ConfigName=@VarConfigName
	

		Print '@HouseCode------------------------:' print @Qry
----------------------------------------------------
------select verion code	
	SELECT @houseCode =h.HouseId FROM Ins_House h WHERE h.HouseId=@HouseID
--------------------------------------------------------------------------------------------------------------------
---Prepare Tag------	
	SET @newtag=@prefix+@houseCode+@postifx+@seperator;
	Print '@@@newtag------------------------:' print @newtag
	SET @tag=@tag+@newtag;
	Print '@@tag------------------------:' print @tag
	--SELECT @tag AS forVersion
	END
	-----------------------------------------------------

	------  End House ID  ---------------------





    ------  Check Student Type  -----------------------

	------ Check @studentTypeCode----------------------------
	IF(@VarConfigName='StudentType')
	BEGIN
	
	-------Select Prefix,Postfix,Seperator-------------
	SELECT
	@prefix=	sc.Prefix,
	@postifx=	sc.Postfix,
	@seperator=	sc.Seperator,
	@ConfigLength=sc._Length
	FROM
		@SelectedConfig sc WHERE sc.ConfigName=@VarConfigName
---------------------------------------------------------
---select reset id..........................
	SELECT @reset= sc.IsReset FROM @SelectedConfig sc WHERE sc.ConfigName=@VarConfigName
	
----------------------------------------------------
------select verion code	
print '@StudentTypeID---------------:' print @StudentTypeID
	SELECT @studentTypeCode =t.StudentTypeCode FROM Ins_StudentType t WHERE t.StudentTypeId=@StudentTypeID
--------------------------------------------------------------------------------------------------------------------
---Prepare Tag------	
	SET @newtag=@prefix+@studentTypeCode+@postifx+@seperator;
	Print '@@@newtag  StudentType ------------------------:' print @newtag
	SET @tag=@tag+@newtag;
	Print '@@tag------------------------:' print @tag
	--SELECT @tag AS forVersion
	END
	-----------------------------------------------------

	------  End Student Type  ---------------------



	------ Check Version----------------------------
	IF(@VarConfigName='VersionCode')
	BEGIN
	
	-------Select Prefix,Postfix,Seperator-------------
	SELECT
	@prefix=	sc.Prefix,
	@postifx=	sc.Postfix,
	@seperator=	sc.Seperator,
	@ConfigLength=sc._Length
	FROM
		@SelectedConfig sc WHERE sc.ConfigName=@VarConfigName
---------------------------------------------------------
---select reset id..........................
	SELECT @reset= sc.IsReset FROM @SelectedConfig sc WHERE sc.ConfigName=@VarConfigName
	
----------------------------------------------------
------select verion code	

--------------------------------------------------------------------------------------------------------------------
---Prepare Tag------	
	SET @newtag=@prefix+@postifx+@seperator;
	SET @tag=@tag+@newtag;
	--SELECT @tag AS forVersion
	END
	-----------------------------------------------------
	--Check Session--------------------------------------
	IF(@VarConfigName='SessionCode')
	BEGIN
	
		---select reset id..........................
	SELECT @reset= sc.IsReset FROM @SelectedConfig sc WHERE sc.ConfigName=@VarConfigName
	IF(@reset=1)
	BEGIN
	set @Qry='SessionId='+Convert(varchar,@SessionID);

	END
	ELSE
		BEGIN
			SET @Qry='';
		END
----------------------------------------------------
		-------Select Prefix,Postfix,Seperator-------------
	SELECT
	@prefix=	sc.Prefix,
	@postifx=	sc.Postfix,
	@seperator=	sc.Seperator,
	@ConfigLength=sc._Length
	FROM
		@SelectedConfig sc WHERE sc.ConfigName=@VarConfigName
---------------------------------------------------------
------ Select Session Code----------------------------------
		SELECT @sessionCode= s.SessionCode FROM Ins_Session s WHERE s.SessionId=@SessionID
---------------------------------------------------------------------------------------------------------------------	
		SET @newtag=@prefix+@sessionCode+@postifx+@seperator;
		
		SET @tag=@tag+@newtag
			--SELECT @tag AS forSession
	END
	----------------------------------------------------
	--Check Branch--------------------------------------
	IF(@VarConfigName='BranchCode')
	BEGIN
			---select reset id..........................
	SELECT @reset= sc.IsReset FROM @SelectedConfig sc WHERE sc.ConfigName=@VarConfigName
	IF(@reset=1)
	BEGIN
	set @Qry= 'BranchID='+Convert(varchar,@BranchID);
	
	END
	ELSE
		BEGIN
			SET @Qry='';
		END
----------------------------------------------------
				-------Select Prefix,Postfix,Seperator-------------
	SELECT
	@prefix=	sc.Prefix,
	@postifx=	sc.Postfix,
	@seperator=	sc.Seperator,
	@ConfigLength=sc._Length
	FROM
		@SelectedConfig sc WHERE sc.ConfigName=@VarConfigName
---------------------------------------------------------
		SELECT @branchCode= b.Code FROM Ins_Branch b WHERE b.BranchId=@BranchID 
			SET @newtag=@prefix+@branchCode+@postifx+@seperator;
		SET @tag=@tag+@newtag
			--SELECT @tag AS forBranch
	END
	----------------------------------------------------
	--Check Shift---------------------------------------
	IF(@VarConfigName='ShiftCode')
	BEGIN
					---select reset id..........................
	SELECT @reset= sc.IsReset FROM @SelectedConfig sc WHERE sc.ConfigName=@VarConfigName
	IF(@reset=1)
	BEGIN
	set @Qry='ShiftID='+Convert(varchar,@ShiftID);
	
	END
	ELSE
		BEGIN
		set	@Qry=''
		END
				-------Select Prefix,Postfix,Seperator-------------
	SELECT
	@prefix=	sc.Prefix,
	@postifx=	sc.Postfix,
	@seperator=	sc.Seperator,
	@ConfigLength=sc._Length
	FROM
		@SelectedConfig sc WHERE sc.ConfigName=@VarConfigName
---------------------------------------------------------
		SELECT @shiftCode= ss.ShiftCode FROM Ins_Shift ss WHERE ss.ShiftId=@ShiftID
			SET @newtag=@prefix+@shiftCode+@postifx+@seperator;
		
		SET @tag=@tag+@newtag
			--SELECT @tag AS forShift
	END
	---------------------------------------------------------
	--Check Class...............................................
	IF(@VarConfigName='ClassCode')
	BEGIN
		
							---select reset id..........................
	SELECT @reset= sc.IsReset FROM @SelectedConfig sc WHERE sc.ConfigName=@VarConfigName
	IF(@reset=1)
	BEGIN
	set @Qry='ClassId='+Convert(varchar,@ClassID);
	
	END
	ELSE
		BEGIN
			SET @Qry=''
		END
				-------Select Prefix,Postfix,Seperator-------------
	SELECT
	@prefix=	sc.Prefix,
	@postifx=	sc.Postfix,
	@seperator=	sc.Seperator,
	@ConfigLength=sc._Length
	FROM
		@SelectedConfig sc WHERE sc.ConfigName=@VarConfigName
---------------------------------------------------------
		SELECT @classCode= c.CalssCode FROM Ins_ClassInfo c WHERE c.ClassId=@ClassID 
			SET @newtag=@prefix+@classCode+@postifx+@seperator;
		SET @tag=@tag+@newtag
			--SELECT @tag AS forClass
	END
	----------------------------------------------------
	--Check Group...........................................
	IF(@VarConfigName='GroupCode')
	BEGIN
							---select reset id..........................
	SELECT @reset= sc.IsReset FROM @SelectedConfig sc WHERE sc.ConfigName=@VarConfigName
	IF(@reset=1)
	BEGIN
	set @Qry='GroupId='+Convert(varchar,@SectionID);
	
	END
	ELSE
		BEGIN
			SET @Qry=''
		END
				-------Select Prefix,Postfix,Seperator-------------
	SELECT
	@prefix=	sc.Prefix,
	@postifx=	sc.Postfix,
	@seperator=	sc.Seperator,
	@ConfigLength=sc._Length
	FROM
		@SelectedConfig sc WHERE sc.ConfigName=@VarConfigName
---------------------------------------------------------
		
			SET @newtag=@prefix+@postifx+@seperator;
		SET @tag=@tag+@newtag
			--SELECT @tag AS forGroup
	END
	----------------------------------------------------
	--Check Section---------------------------------------
	IF(@VarConfigName='SectionCode')
	BEGIN
							---select reset id..........................
	SELECT @reset= sc.IsReset FROM @SelectedConfig sc WHERE sc.ConfigName=@VarConfigName
	IF(@reset=1)
	BEGIN
	set @Qry= 'SectionId='+Convert(varchar,@SectionID);
	
	END
	ELSE
		BEGIN
			SET @Qry=''
		END
				-------Select Prefix,Postfix,Seperator-------------
	SELECT
	@prefix=	sc.Prefix,
	@postifx=	sc.Postfix,
	@seperator=	sc.Seperator,
	@ConfigLength=sc._Length
	FROM
		@SelectedConfig sc WHERE sc.ConfigName=@VarConfigName
---------------------------------------------------------
		SELECT @sectionCode= ss.SectionCode FROM Ins_Section ss WHERE ss.SectionId=@SectionID
		
			SET @newtag=@prefix+@sectionCode+@postifx+@seperator;
		SET @tag=@tag+@newtag
			--SELECT @tag AS forSection
	END
	
	print 'Final @Tag------------------: ' print @tag

	IF (@Qry!='' and @newQry='')
	BEGIN
		SET @newQry=@Qry
	END
	ELSE IF(@Qry!='' AND @newQry!='')
	BEGIN
		SET @newQry=@newQry+' and '+@Qry
	END
	
	FETCH NEXT FROM config_Cursor INTO @VarConfigName;
END
----- End Loop...............................................
-----------------------------
 CLOSE config_Cursor;
DEALLOCATE config_Cursor;
-------------------------------


--SELECT @tag AS Tag

------------- Generate Prefix Zeros..... based on length


---------------------------------------------------------------------------------------------------------------------------------------
------------------------------ Generate Id------------------------------------------------------------------------------
DECLARE @lastID NCHAR(24)

DECLARE @incrementId INT 
DECLARE @lastPrefix VARCHAR(50)
DECLARE @newID NCHAR(24)
DECLARE @lasteStudentIDTable TABLE (
	lasteStudentID NCHAR(24) NOT null
	)


SET @incrementId=0;
--SELECT @newQry
print '@newQry----????:' print @newQry
IF(@newQry!='')
BEGIN
	DECLARE @temp NVARCHAR(max)

	SET @temp='select top(1) ts.StudentInsID from Student_BasicInfo ts where '+@newQry+' order by ts.StudentIID desc'
	print '@temp---------------' print @temp

INSERT INTO @lasteStudentIDTable EXEC sp_executesql @temp
--SELECT * FROM @lasteStudentIDTable
		IF EXISTS(SELECT tt.lasteStudentID FROM @lasteStudentIDTable tt)
		BEGIN
			
			SELECT
			@lastID=lsi.lasteStudentID
			FROM
				@lasteStudentIDTable lsi
			print '@@tag----????:' print @tag
			IF(LEN(@tag)<LEN(@lastID))
			BEGIN
				
					SELECT @lastPrefix=SUBSTRING(@lastID,1,LEN(@tag))
			
					IF(@lastPrefix=@tag)
					BEGIN
						SELECT @incrementId=CONVERT(INT, SUBSTRING(@lastID,LEN(@tag)+1,LEN(@lastPrefix)))
							
				--SELECT @lastID,LEN(@lastID)
			--SELECT @incrementId =CONVERT(INT, SUBSTRING(@lastID, 12, 4))

						SET @incrementId=@incrementId+1;
						--SET @newID=@tag+right(replicate('0', @ConfigLength)+Convert(varchar,@incrementId),@ConfigLength)

						--SELECT @newID AS NewStudentID
					END
					ELSE
					BEGIN
						SET @incrementId=@incrementId+1;
								--SET @newID=@tag+right(replicate('0', @ConfigLength)+Convert(varchar,1),@ConfigLength);
								--SELECT @newID AS NewStudentID
						END
			END
			ELSE
			BEGIN
				SET @incrementId=@incrementId+1;
					--SET @newID=@tag+right(replicate('0', @ConfigLength)+Convert(varchar,1),@ConfigLength);
					--			SELECT @newID AS NewStudentID
				END
		END
		ELSE
		BEGIN
		PRINT @tag
			SET @incrementId=@incrementId+1;
			--	SET @newID=@tag+right(replicate('0', @ConfigLength)+Convert(varchar,1),@ConfigLength);
			--SELECT @newID AS NewStudentID
		END
		
		
	SET @newID=@tag+right(replicate('0', @ConfigLength)+Convert(varchar,@incrementId),@ConfigLength)

 WHILE EXISTS(SELECT si.StudentIID FROM Student_BasicInfo si WHERE si.StudentInsID=@newID )
 BEGIN
 		SET @incrementId=@incrementId+1;
 		SET @newID=@tag+right(replicate('0', @ConfigLength)+Convert(varchar,@incrementId),@ConfigLength)

		
 END

 -- Added By Rafiq For School & College
		--SELECT @ForCollege=[Class_ForCollege] FROM [dbo].[Tbl_Class] WHERE [Class_ID]=@ClassID
		--IF(@ForCollege=0)
		--BEGIN
		--	SET @newID='1'+@newID
		--END
		--ELSE
		--BEGIN
		--	SET @newID='C'+@newID
		--END
	
	SELECT @newID AS NewStudentID
		
END
------------------------------------------------------------------------------------------------------------------------------------
END
