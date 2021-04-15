/****** Object:  StoredProcedure [dbo].[SP_GetEmpAllInfo]    Script Date: 11/18/2017 6:37:37 PM ******/ 
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[CheckProcessDone]')) 
  BEGIN 
      DROP PROCEDURE [CheckProcessDone] 
  END 

go 

SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go 

CREATE PROC [dbo].[Checkprocessdone] 
-- [dbo].[CheckProcessDone] 2051,2,47,0,0, 6
(@MainExamId INT=NULL, 
 @ShiftId    INT=NULL, 
 @ClassId    INT=NULL, 
 @GroupId    INT=NULL, 
 @IsSuper    BIT=null,
 @SessionId   INT=NULL
 ) 
AS 
  BEGIN 
  SELECT  v.versionname, 
             c.classname, 
             sh.shiftname, 
             g.groupname, 
             ss.SessionName, 
             ex.mainexamname, 
             mer.*   into #mainexamresult    
      FROM   res_mainexamresult mer 
             INNER JOIN dbo.res_mainexam ex 
                     ON ex.mainexamid = mer.mainexamid 
                        AND ex.isdeleted = 0 
                        AND ex.classid = Isnull(@ClassId, ex.classid) 
                        AND ex.groupid = Isnull(@GroupId, ex.groupid) 
                        AND ex.SessionId = Isnull(@SessionId, ex.SessionId) 
             INNER JOIN dbo.student_basicinfo s 
                     ON s.studentiid = mer.studentiid 
             INNER JOIN dbo.ins_classinfo c 
                     ON c.classid = s.classid 
             INNER JOIN dbo.ins_shift sh 
                     ON sh.shiftid = s.shiftid 
					  INNER JOIN dbo.Ins_Session ss
                     ON ss.SessionId = s.SessionId 
             INNER JOIN dbo.ins_version v 
                     ON v.versionid = s.versionid 
             INNER JOIN dbo.ins_group g 
                     ON g.groupid = s.groupid 
      WHERE  mer.mainexamid = Isnull(@MainExamId, mer.mainexamid) 
             AND s.shiftid = Isnull(@ShiftId, s.shiftid) 
             AND s.SessionId = Isnull(@SessionId, s.SessionId) 
			 --print @IsSuper
      IF(EXISTS(SELECT * 
                 FROM   #mainexamresult) AND (@IsSuper = 0) )
			
        BEGIN 
            SELECT ( 'Opps Result Processed Found!! Version : ' 
                     + mer.versionname + ' Session: ' 
                     + mer.SessionName + ',  Shift : ' 
                     + mer.shiftname + ', Class :' + classname 
                     + ', Group :' + groupname + ', Exam : ' 
                     + mer.mainexamname ) MainExamName 
            FROM   #mainexamresult mer 
        END
		else
		SELECT * 
                 FROM   #mainexamresult

      DROP TABLE #mainexamresult 
  END 