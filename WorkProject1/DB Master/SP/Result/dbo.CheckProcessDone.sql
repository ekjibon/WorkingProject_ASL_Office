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
-- [dbo].[CheckProcessDone] 1040,0,25,0,11, 100
(@MainExamId INT=NULL, 
 @ShiftId    INT=NULL, 
 @ClassId    INT=NULL, 
 @IsSuper    BIT=null,
 @SessionId   INT=NULL,
 @SectionId INT=NULL
 ) 
AS 
  BEGIN 
  SELECT  
             c.classname, 
             sh.shiftname, 
           
             ss.SessionName, 
             ex.mainexamname, 
             mer.*   into #mainexamresult    
      FROM   res_mainexamresult mer 
             INNER JOIN dbo.res_mainexam ex 
                     ON ex.mainexamid = mer.mainexamid 
                        AND ex.isdeleted = 0 
                        AND ex.classid = Isnull(@ClassId, ex.classid) 
                        AND ex.SessionId = Isnull(@SessionId, ex.SessionId) 
             INNER JOIN dbo.student_basicinfo s 
                     ON s.studentiid = mer.studentiid 
             INNER JOIN dbo.ins_classinfo c 
                     ON c.classid = s.classid 
             INNER JOIN dbo.ins_shift sh 
                     ON sh.shiftid = s.shiftid 
					  INNER JOIN dbo.Ins_Session ss
                     ON ss.SessionId = s.SessionId 
           
      WHERE  mer.mainexamid = Isnull(@MainExamId, mer.mainexamid) 
             --AND s.shiftid = Isnull(@ShiftId, s.shiftid) 
             AND s.SessionId = Isnull(@SessionId, s.SessionId) 
			 AND s.SectionId = Isnull(@SectionId, s.SectionId) 
			 AND s.ClassId = ISNULL(@ClassId,S.ClassId) AND S.[Status] = 'A'
			 --print @IsSuper
      IF(EXISTS(SELECT * 
                 FROM   #mainexamresult) AND (@IsSuper = 0) )
			
        BEGIN 
            SELECT ( 'Opps Class Wise Result Processed Found!!' 
                     + ' Session: ' 
                     + mer.SessionName + ',  Shift : ' 
                     + mer.shiftname + ', Class :' + classname 
                     + ', Exam : ' 
                     + mer.mainexamname ) MainExamName 
            FROM   #mainexamresult mer 
        END
		else
		SELECT *  FROM   #mainexamresult

      DROP TABLE #mainexamresult 
  END 