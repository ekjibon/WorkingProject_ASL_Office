
--- StudentController 100
--- SetupInstitutionController 200
--- AttendanceController 300
--- EmployeeController 400
--- GrandResultController 500
--- ResultController 600
--- PromotionController 700
--- UserController  800

SET IDENTITY_INSERT [dbo].[AspNetApis] ON 
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (101, N'StudentInfo', N'SearchStudent', N'Student/Search/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (102, N'StudentInfo', N'GetStudentByID', N'Student/GetStudentByID/{id}')
GO
SET IDENTITY_INSERT [dbo].[AspNetApis] OFF
GO
SET IDENTITY_INSERT [dbo].[AspNetPageApis] ON 
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (101, 101, 2022)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (102, 102, 2022)
GO
SET IDENTITY_INSERT [dbo].[AspNetPageApis] OFF
GO
