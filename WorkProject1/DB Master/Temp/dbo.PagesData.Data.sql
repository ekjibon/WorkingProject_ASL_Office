GO
Truncate table [AspNetPages]
GO
SET IDENTITY_INSERT [dbo].[AspNetPages] ON 
GO
 ----------------------------------------------------------------------------------------------------------------------------------------------------
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2, 0, N'Student ', N'b', NULL, NULL, NULL, N'fa fa-graduation-cap', NULL, N'A', 1, 1)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (3, 0, N'Result', N'b', NULL, NULL, NULL, N'fa fa-newspaper-o', NULL, N'A', 2, 1)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4, 0, N'Setup', N'b', NULL, NULL, NULL, N'fa fa-cog', NULL, N'A', 3, 1)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (5, 0, N'User Management', N'b', NULL, NULL, NULL, N'fa fa-user-plus', NULL, N'A', 5, 1)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (6, 0, N'Employee', N'b', NULL, NULL, NULL, N'fa fa-user', NULL, N'A', 4, 1)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (7, 0, N'Fees', N'b', NULL, NULL, NULL, N'fa fa-user', NULL, N'A', 6, 1)
GO
------------------------------------------------------------------------------------------------------------------------------------------------------------- Layer 2 ----------------------------------------------------------------------------------------------------------------------
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (201, 2, N'Bulk Student Upload', N'b', N'Student', N'StuBulkUpload', NULL, N'fa fa-upload', NULL, N'A', 1, 0)
GO
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (202, 2, N'Student Record', N'b', NULL, N'', NULL, N'fa fa-address-card-o', NULL, N'A', 2, 0)
GO
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (203, 2, N'Reports', N'b', NULL, N'', NULL, N'fa fa-columns', NULL, N'A', 8, 0)
GO
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (204, 2, N'Academic Info', N'b', NULL, N'', NULL, N'fa fa-address-card-o', NULL, N'A', 3, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (201, 2, N'Student Entry', N'b', NULL, N'', NULL, N'fa fa-address-card-o', NULL, N'A', 1, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (202, 2, N'Student List', N'b', N'Student', N'StudentInfo', NULL, N'fa fa-address-card-o', NULL, N'A', 2, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (203, 2, N'Advance Search', N'b', N'Student', N'StudentSearch',  NULL, N'fa fa-address-card-o', NULL, N'A', 3, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (204, 2, N'Certificates', N'b', NULL, N'', NULL, N'fa fa-address-card-o', NULL, N'A', 4, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (205, 2, N'Reports', N'b', NULL, N'', NULL, N'fa fa-address-card-o', NULL, N'A', 5, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (206, 2, N'Attendance', N'b', NULL, N'', NULL, N'fa fa-address-card-o', NULL, N'A', 6, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (207, 2, N'Attendance Report', N'b', NULL, N'', NULL, N'fa fa-address-card-o', NULL, N'A', 7, 0)
GO


INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (301, 3, N'Main Exam', N'b', NULL, NULL, NULL, N'fa fa-folder-o', NULL, N'A', 6, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (302, 3, N'Grand Exam', N'b', NULL, NULL, NULL, N'fa fa-folder-o', NULL, N'A', 6, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (303, 3, N'Exam Attendance', N'b', N'Result', N'MainExamResultAttendanceSetup', NULL, N'fa fa-folder-o', NULL, N'A', 8, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (304, 3, N'Promotion', N'b', NULL, NULL, NULL, N'fa fa-folder-o', NULL, N'A', 9, 0)
GO

INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (401, 4, N'Institution Setup', N'b', NULL, NULL, NULL, N'fa fa-edit', NULL, N'A', 1, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (402, 4, N'Academic', N'b', NULL, NULL, NULL, N'fa fa-calendar-o', NULL, N'A', 2, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (403, 4, N'Main Exam', N'b', NULL, NULL, NULL, N'fa fa-calendar-o', NULL, N'A', 3, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (404, 4, N'Grand Exam', N'b', NULL, NULL, NULL, N'fa fa-calendar-o', NULL, N'A', 4, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (405, 4, N'Employee Setup', N'b', NULL, NULL, NULL, N'fa fa-users', NULL, N'A', 5, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (406, 4, N'Student Attendance', N'b', NULL, NULL, NULL, N'fa fa-users', NULL, N'A', 6, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (407, 4, N'Routine', N'b', NULL, NULL, NULL, N'fa fa-users', NULL, N'A', 7, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (408, 4, N'Fees', N'b', NULL, NULL, NULL, N'fa fa-users', NULL, N'A', 8, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (409, 4, N'Attendance', N'b', NULL, NULL, NULL, N'fa fa-users', NULL, N'A', 9, 0)
GO


INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (501, 5, N'Users', N'b', N'Users', N'Users', NULL, N'fa fa-user', NULL, N'A', 1, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (502, 5, N'Subject Assign', N'b', N'Result', N'AssignSubjectsToTeacher', NULL, N'fa fa-user', NULL, N'A', 2, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (503, 5, N'Roles', N'b', N'Users', N'Roles', NULL, N'fa fa-check-square-o', NULL, N'A', 3, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (504, 5, N'Block', N'b', NULL, NULL, NULL, N'fa fa-ban', NULL, N'A', 4, 0)
--GO
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (701, 7, N'Collection', N'b', NULL, NULL, NULL, N'fa fa-clipboard', NULL, N'A', 1, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (701, 7, N'POS/Live Collection', N'b', N'FeesV', N'FeesCollection', NULL, N'fa fa-clipboard', NULL, N'A', 1, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (702, 7, N'Process', N'b', N'FeesV', N'FeesProcess', NULL, N'fa fa-clipboard', NULL, N'A', 8, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (704, 7, N'Without Process Collection', N'b', N'FeesV', N'FeesCollectionWithoutProcess', NULL, N'fa fa-clipboard', NULL, N'A', 3, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (705, 7, N'Report', N'b', NULL, NULL, NULL, N'fa fa-clipboard', NULL, N'A', 9, 0)
GO 
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (706, 7, N'Modify Processed Fees', N'b', N'FeesV', N'ModifyProcessedFees', NULL, N'fa fa-clipboard', NULL, N'A', 6, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (707, 7, N'Modify Money Receipt', N'b', N'FeesV', N'ModifyMoneyReceipt', NULL, N'fa fa-clipboard', NULL, N'A', 7, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (708, 7, N'Admin Collection', N'b', N'FeesV', N'BulkFeesCollection', NULL, N'fa fa-clipboard', NULL, N'A', 2, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (709, 7, N'Bulk Collection', N'b', N'FeesV', N'FeesCollectionBulkUpload', NULL, N'fa fa-clipboard', NULL, N'A', 4, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (710, 7, N'Online Collection', N'b', N'FeesV', N'OnlineFeesCollection', NULL, N'fa fa-clipboard', NULL, N'A', 5, 0)
GO

INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (601, 6, N'Employee List', N'b', N'Employee', N'EmployeeList', NULL, N'fa fa-user', NULL, N'A', 1, 0)
GO

INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (602, 6, N'Subject List', N'b', N'Employee', N'TeacherSubjectList', NULL, N'fa fa-user', NULL, N'A', 1, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (603, 6, N'Subject List', N'b', N'Employee', N'TeacherMarksEntrySubjectList', NULL, N'fa fa-user', NULL, N'A', 2, 0)
GO


------------------------------------------------------------------------------------------------------------------------------------------------------------- Layer 3 ----------------------------------------------------------------------------------------------------------------------

--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2021, 202, N'Quick Add Student', N'b', N'Student', N'QuickAddStudent', NULL, N'fa fa-user-circle', NULL, N'A', 1, 0)
--GO
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2023, 202, N'Update Student', N'b', N'Student', N'UpdateStudentInfo', NULL, N'fa fa-user-circle', NULL, N'A', 2, 0)
--GO

--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2022, 202, N'Student List', N'b', N'Student', N'StudentInfo', NULL, N'fa fa-user-plus', NULL, N'A', 3, 0)
--GO
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2024, 202, N'Bulk Student Update', N'b', N'Student', N'BulkStudentUpdate', NULL, N'fa fa-user-circle', NULL, N'A', 4, 0)
--GO

--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2031, 203, N'Dynamic List Reports', N'b', N'Student', N'DynamicListReport', NULL, N'fa fa-clipboard', NULL, N'A', 3, 0)
--GO
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2032, 203, N'Statistical Reports', N'b', N'Student', N'StatisticalReport', NULL, N'fa fa-clipboard', NULL, N'A', 4, 0)
--GO




INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2021, 201, N'Bulk Student Upload', N'b', N'Student', N'StuBulkUpload', NULL, N'fa fa-clipboard', NULL, N'A', 1, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2022, 201, N'Bulk Student Update', N'b', N'Student', N'BulkStudentUpdate', NULL, N'fa fa-clipboard', NULL, N'A', 2, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2023, 201, N'Quick Add Student', N'b', N'Student', N'QuickAddStudent', NULL, N'fa fa-clipboard', NULL, N'A', 3, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2024, 201, N'Update Student', N'b', N'Student', N'UpdateStudentInfo', NULL, N'fa fa-clipboard', NULL, N'A', 4, 0)
GO


INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2031, 204, N'Admit Card', N'b', N'Student', N'StudentAdmitCard', NULL, N'fa fa-clipboard', NULL, N'A', 1, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2032, 204, N'ID Card', N'b', N'Student', N'StudentIDCard', NULL, N'fa fa-clipboard', NULL, N'A', 2, 0)
GO																																																
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2033, 204, N'Seat Card', N'b', N'Student', N'StudentSeatCard', NULL, N'fa fa-clipboard', NULL, N'A', 3, 0)
GO																																															
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2034, 204, N'Testimonial', N'b', N'Student', N'Testimonial', NULL, N'fa fa-clipboard', NULL, N'A', 4, 0)
GO																																																 
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2035, 204, N'Character Certificate ', N'b', N'Student', N'CharacterCertificate', NULL, N'fa fa-clipboard', NULL, N'A', 5, 0)
GO																																																
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2036, 204, N'Transfer Certificate ', N'b', N'Student', N'TransferCertificate', NULL, N'fa fa-clipboard', NULL, N'A', 6, 0)
GO																																																
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2037, 204, N'TC Approve ', N'b', N'Student', N'TransferCertificateforApprove', NULL, N'fa fa-clipboard', NULL, N'A', 7, 0)
GO


INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2041, 205, N'Dynamic Reports', N'b', N'Student', N'StudentReport', NULL, N'fa fa-bars', NULL, N'A', 1, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2042, 205, N'Statistical Reports', N'b', N'Student', N'StatisticalReport', NULL, N'fa fa-clipboard', NULL, N'A', 2, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2043, 205, N'Addmission Status Summary', N'b', N'Report', N'AddmissionStatusSummary', NULL, N'fa fa-clipboard', NULL, N'A', 3, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2044, 205, N'TOT List', N'b', N'Student', N'TOTList', NULL, N'fa fa-clipboard', NULL, N'A', 4, 0)


Go
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2033, 204, N'Testimonial', N'b', N'Student', N'Testimonial', NULL, N'fa fa-clipboard', NULL, N'A', 5, 0)
--GO
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2034, 204, N'Transfer Certificate ', N'b', N'Student', N'TransferCertificate', NULL, N'fa fa-clipboard', NULL, N'A', 6, 0)
--GO
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2035, 204, N'Character Certificate ', N'b', N'Student', N'CharacterCertificate', NULL, N'fa fa-clipboard', NULL, N'A', 7, 0)
--GO
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2036, 204, N'TC Approve ', N'b', N'Student', N'TransferCertificateforApprove', NULL, N'fa fa-clipboard', NULL, N'A', 8, 0)
--GO
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2037, 202, N'Advance Search', N'b', N'Student', N'StudentSearch', NULL, N'fa fa-search', NULL, N'A', 9, 0)
--GO
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2038, 203, N'Student Dynamic Reports', N'b', N'Student', N'StudentReport', NULL, N'fa fa-bars', NULL, N'A', 10, 0)
--GO
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2039, 203, N'Addmission Status Summary', N'b', N'Report', N'AddmissionStatusSummary', NULL, N'fa fa-clipboard', NULL, N'A', 11, 0)
--GO
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2040, 203, N'Admit Card', N'b', N'Student', N'StudentAdmitCard', NULL, N'fa fa-clipboard', NULL, N'A', 12, 0)
--GO
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2041, 203, N'TOT List', N'b', N'Student', N'TOTList', NULL, N'fa fa-clipboard', NULL, N'A', 13, 0)
--GO
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2042, 203, N'Seat Card', N'b', N'Student', N'StudentSeatCard', NULL, N'fa fa-clipboard', NULL, N'A', 14, 0)
--GO
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2043, 203, N'ID Card', N'b', N'Student', N'StudentIDCard', NULL, N'fa fa-clipboard', NULL, N'A', 15, 0)
--GO
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2044, 203, N'Academic Use Vairous Type', N'b', N'Student', N'AcademicUseVairousType', NULL, N'fa fa-clipboard', NULL, N'A', 16, 0)
--GO

INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2051, 206, N'Section Wise ', N'b', N'AttendanceV', N'StdSectionWiseAttendance', NULL, N'fa fa-clipboard', NULL, N'A', 17, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2052, 206, N'Month Wise Period ', N'b', N'AttendanceV', N'StdPeriodWiseAttendance', NULL, N'fa fa-clipboard', NULL, N'A', 18, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2053, 206, N'Day Wise Period', N'b', N'AttendanceV', N'StdPeriodWiseAttnSingleDay', NULL, N'fa fa-clipboard', NULL, N'A', 19, 0)
GO

INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2054, 206, N'Leave Apply', N'b', N'AttendanceV', N'StdLeaveApply', NULL, N'fa fa-clipboard', NULL, N'A', 21, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2055, 206, N'Leave List', N'b', N'AttendanceV', N'StdLeaveList', NULL, N'fa fa-clipboard', NULL, N'A', 22, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2056, 206, N'Sectiond Wise (Teacher)', N'b', N'AttendanceV', N'TeacherStdAttnListSectoinWise', NULL, N'fa fa-clipboard', NULL, N'A', 23, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2057, 206, N'Student Abscoding ', N'b', N'AttendanceV', N'StdAbscondingAttendance', NULL, N'fa fa-clipboard', NULL, N'A', 24, 0)
GO
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2058, 206, N'Period Wise Attn Single Day ', N'b', N'AttendanceV', N'PeriodWiseAttnSingleDay', NULL, N'fa fa-clipboard', NULL, N'A', 25, 0)
--GO


INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2061, 207, N'Daily Report', N'b', N'AttendanceV', N'StdDailyAttendanceReportPeriodWise', NULL, N'fa fa-clipboard', NULL, N'A', 23, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2062, 207, N'LIO Report', N'b', N'AttendanceV', N'StdLIOReport', NULL, N'fa fa-clipboard', NULL, N'A', 24, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2063, 207, N'Summary Report (Daily)', N'b', N'AttendanceV', N'StdAttendanceSummaryReport', NULL, N'fa fa-clipboard', NULL, N'A', 25, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2064, 207, N'Monthly Summary Report', N'b', N'AttendanceV', N'StdMonthlyAttendanceReport', NULL, N'fa fa-clipboard', NULL, N'A', 26, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2065, 207, N'Dynamic Attendance Report', N'b', N'AttendanceV', N'StdDynamicAttendanceReport', NULL, N'fa fa-clipboard', NULL, N'A', 27, 0)
GO

INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2066, 207, N'Attendance Summary(Date Range wise)', N'b', N'AttendanceV', N'AttndSummRange', NULL, N'fa fa-clipboard', NULL, N'A', 28, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2067, 207, N'Monthly Detail', N'b', N'AttendanceV', N'MonthlyAttendance', NULL, N'fa fa-clipboard', NULL, N'A', 29, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2068, 207, N'Section Ways & Leave Report', N'b', N'AttendanceV', N'SectionWaysAbscondingLeaveAttendance', NULL, N'fa fa-clipboard', NULL, N'A', 30, 0)
--GO
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2070, 206, N'Leave Report', N'b', N'AttendanceV', N'SectionWaysAbscondingLeaveAttendance', NULL, N'fa fa-clipboard', NULL, N'A', 32, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2069, 207, N'Device Report', N'b', N'AttendanceV', N'DeviceReport', NULL, N'fa fa-clipboard', NULL, N'A', 31, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2070, 207, N'SingleStudentSummery', N'b', N'AttendanceV', N'SingleStudentSummeryReport', NULL, N'fa fa-clipboard', NULL, N'A', 32, 0)
GO

INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (2071, 207, N'StudentSummery', N'b', N'AttendanceV', N'StudentSummeryReportSW', NULL, N'fa fa-clipboard', NULL, N'A', 33, 0)
GO






INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (3011, 301, N'Proccess Result', N'b', N'Result', N'MainExamProcessResult', NULL, N'fa fa-folder-o', NULL, N'A', 1, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (3012, 301, N'Generate Result', N'b', N'Result', N'MainExamGenerateResult', NULL, N'fa fa-folder-o', NULL, N'A', 2, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (3013, 301, N'Merit List', N'b',  N'Result', N'Merit', NULL, N'fa fa-folder-o', NULL, N'A', 3, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (3014, 301, N'Marks Entry', N'b', N'Result', N'MarksEntry', NULL, N'fa fa-folder-o', NULL, N'A', 4, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (3015, 301, N'Teacher Marks Entry', N'b', N'Result', N'TeacherMarksEntry', NULL, N'fa fa-folder-o', NULL, N'A', 5, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (3016, 301, N'Marks Upload', N'b', N'Result', N'MarksUpload', NULL, N'fa fa-folder-o', NULL, N'A', 6, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (3017, 301, N'Subject Assign Report', N'b', N'Result', N'SubjectAssignReport', NULL, N'fa fa-folder-o', NULL, N'A', 7, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (3018, 301, N'Staticties Report', N'b', N'Result', N'StaticReport', NULL, N'fa fa-folder-o', NULL, N'A', 8, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (3019, 301, N'Universal Marks Entry', N'b', N'Result', N'UniversalDynamicMarksEntryPanel', NULL, N'fa fa-folder-o', NULL, N'A', 9, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (3020, 301, N'Main Exam Assessment', N'b', N'Result', N'MainExamAssessment', NULL, N'fa fa-folder-o', NULL, N'A', 10, 0)
GO
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (3015, 301, N'Teacher Marks Entry', N'b', N'Result', N'TeacherMarksEntry', NULL, N'fa fa-folder-o', NULL, N'A', 9, 0)

INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (3021, 302, N'Proccess Result', N'b', N'Result', N'GrandProcessResult', NULL, N'fa fa-folder-o', NULL, N'A', 1, 0)
GO																																															 	   
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (3022, 302, N'Generate Result', N'b', N'Result', N'GrandGenerateResult', NULL, N'fa fa-folder-o', NULL, N'A', 2, 0)
GO																																															 	   
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (3023, 302, N'Merit List', N'b',  N'GrandResult', N'GrandMerit', NULL, N'fa fa-folder-o', NULL, N'A', 3, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (3024, 302, N'Grand Assessment', N'b',  N'GrandResult', N'GrandAssessment', NULL, N'fa fa-folder-o', NULL, N'A', 3, 0)
GO

INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (3025, 304, N'Pass Promotion', N'b', N'Promotion', N'PassStudentPromotion', NULL, N'fa fa-folder-o', NULL, N'A', 1, 0)
GO																																															 	   
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (3026, 304, N'Fail Promotion', N'b',  N'Promotion', N'FailStudentPromotion', NULL, N'fa fa-folder-o', NULL, N'A', 2, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (3027, 304, N'Bypass Promotion', N'b',  N'Promotion', N'ByPassPromotion', NULL, N'fa fa-folder-o', NULL, N'A', 3, 0)
GO

INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (40102, 401, N'Version', N'b', N'InstitutionSetup', N'Version', NULL, N'fa fa-edit', NULL, N'A', 1, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4011, 401, N'Branch', N'b', N'InstitutionSetup', N'Branch', NULL, N'fa fa-edit', NULL, N'A', 2, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4012, 401, N'Shift', N'b', N'InstitutionSetup', N'Shift', NULL, N'fa fa-edit', NULL, N'A', 3, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4013, 401, N'Session', N'b', N'InstitutionSetup', N'Session', NULL, N'fa fa-edit', NULL, N'A', 4, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4014, 401, N'Class', N'b', N'InstitutionSetup', N'Class', NULL, N'fa fa-edit', NULL, N'A', 5, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4015, 401, N'Section', N'b', N'InstitutionSetup', N'Section', NULL, N'fa fa-edit', NULL, N'A', 6, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4016, 401, N'Institution Info', N'b', N'InstitutionSetup', N'MyInstitution', NULL, N'fa fa-edit', NULL, N'A', 7, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4017, 401, N'Report Header', N'b',  N'Report', N'ReportHeader', NULL, N'fa fa-edit', NULL, N'A', 8, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4018, 401, N'Student ID Config', N'b', N'InstitutionSetup', N'StudentIDSetup', NULL, N'fa fa-edit', NULL, N'A', 9, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4019, 401, N'Common DropDown', N'b', N'Common', N'DropDownConfig', NULL, N'fa fa-edit', NULL, N'A', 10, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4020, 401, N'TTC Template', N'b', N'InstitutionSetup', N'TTCTemplate', NULL, N'fa fa-edit', NULL, N'A', 11, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (40101, 401, N'Fees Booth', N'b', N'InstitutionSetup', N'FeesBooth', NULL, N'fa fa-edit', NULL, N'A', 12, 0)




INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4021, 402, N'Subject Setup', N'b', N'Result', N'SubjectSetup', NULL, N'fa fa-cogs', NULL, N'A', 1, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4022, 402, N'Subject Process', N'b', N'Result', N'SubjectProcess', NULL, N'fa fa-cogs', NULL, N'A', 2, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4023, 402, N'Selective Subject Setup', N'b', N'Result', N'SelectiveSubject', NULL, N'fa fa-cogs', NULL, N'A', 3, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4024, 402, N'Optional Subject Setup', N'b', N'Result', N'OptionalSubject', NULL, N'fa fa-cogs', NULL, N'A', 4, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4025, 402, N'Fouth Subject Rules', N'b', N'Result', N'FouthSubjectRules', NULL, N'fa fa-cogs', NULL, N'A', 5, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4026, 402, N'Rounding Rule', N'b', N'Result', N'MarksMigratedSetup', NULL, N'fa fa-cogs', NULL, N'A', 6, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4027, 402, N'Grade Policy', N'b', N'Result', N'GradeSetup', NULL, N'fa fa-cogs', NULL, N'A', 7, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4028, 402, N'Merit Config', NULL, N'Result', N'MeritListConfig', NULL, N'fa fa-cogs', NULL, N'A', 8, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4029, 402, N'Highest Mark Policy', N'b', N'Result', N'HighestMarkSetup', NULL, N'fa fa-cogs', NULL, N'A', 9, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4030, 402, N'Report Config', NULL, N'Result', N'ReportConfig', NULL, N'fa fa-cogs', NULL, N'A', 10, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4031, 402, N'Subject List', N'b', N'Result', N'SubjectDetail', NULL, N'fa fa-cogs', NULL, N'A', 11, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4032, 403, N'Exam List', N'b', N'Result', N'ExamList', NULL, N'fa fa-cogs', NULL, N'A', 1, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4033, 403, N'Main Exam Mark Setup', N'b', N'Result', N'MainExamMarkSetup', NULL, N'fa fa-cogs', NULL, N'A', 2, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4036, 403, N'Virtual Config', N'b', N'Result', N'VirtualExam', NULL, N'fa fa-cogs', NULL, N'A', 6, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4037, 403, N'Tab Config', N'b',  N'Result', N'TabConfig', NULL, N'fa fa-cogs', NULL, N'A', 7, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4038, 403, N'Tab Header', N'b',  N'Result', N'TabHeaderSetup', NULL, N'fa fa-cogs', NULL, N'A', 8, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4039, 403, N'Main Exam Clone', N'b',  N'Result', N'CloneMainExam', NULL, N'fa fa-cogs', NULL, N'A', 9, 0)
GO

INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4041, 404, N'Grand Exam List', N'b',  N'GrandResult', N'GrandExams', NULL, N'fa fa-cogs', NULL, N'A', 1, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4042, 404, N'Grand Exam Setup', N'b',  N'GrandResult', N'GrandExamsSetup', NULL, N'fa fa-cogs', NULL, N'A', 2, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4043, 404, N'Grand ExamMark Setup', N'b',  N'GrandResult', N'GrandExamMarkSetup', NULL, N'fa fa-cogs', NULL, N'A', 3, 0)
Go
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4044, 404, N'Grand Mark Percent', N'b',  N'GrandResult', N'GrandSetup', NULL, N'fa fa-cogs', NULL, N'A', 4, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4045, 404, N'Grand Exam Clone', N'b',  N'GrandResult', N'GrandExamClone', NULL, N'fa fa-cogs', NULL, N'A', 5, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4046, 404, N'Grand Config', N'b',  N'GrandResult', N'GrandConfig', NULL, N'fa fa-cogs', NULL, N'A', 6, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4047, 404, N'Grand Virtual Exam', N'b',  N'GrandResult', N'GrandVirtualExam', NULL, N'fa fa-cogs', NULL, N'A', 7, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4048, 404, N'Grand Merit Config', N'b',  N'GrandResult', N'GrandMeritListConfig', NULL, N'fa fa-cogs', NULL, N'A', 8, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4049, 404, N'Leave Student', N'b',  N'Result', N'MainExamLeave', NULL, N'fa fa-cogs', NULL, N'A', 8, 0)
GO

INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4051, 405, N'Designation', N'b',  N'Employee', N'Designation', NULL, N'fa fa-cogs', NULL, N'A', 1, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4052, 405, N'Category', N'b',  N'Employee', N'Category', NULL, N'fa fa-cogs', NULL, N'A', 2, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4053, 405, N'Subject', N'b',  N'Employee', N'Subject', NULL, N'fa fa-cogs', NULL, N'A', 3, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4055, 405, N'Employee Status', N'b',  N'Employee', N'Status', NULL, N'fa fa-cogs', NULL, N'A', 5, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4056, 405, N'Department', N'b',  N'Employee', N'Department', NULL, N'fa fa-cogs', NULL, N'A', 6, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4057, 405, N' Class Teacher Assign', N'b',  N'Employee', N'ClassTeacherAssign', NULL, N'fa fa-cogs', NULL, N'A', 7, 0)
GO

INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4070, 401, N'Admit Card Setup', N'b', N'InstitutionSetup', N'AdmitCardSetup', NULL, N'fa fa-edit', NULL, N'A', 10, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4071, 401, N'Seat Card Setup', N'b', N'InstitutionSetup', N'SeatCardSetup', NULL, N'fa fa-edit', NULL, N'A', 11, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4072, 401, N'Auto Signature Setup', N'b', N'InstitutionSetup', N'SignatureSetup', NULL, N'fa fa-edit', NULL, N'A', 12, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4073, 401, N'Route Setup', N'b', N'Student', N'RouteSetup', NULL, N'fa fa-edit', NULL, N'A', 13, 0)
GO

INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4081, 406, N'Academic Calendar Setup', N'b', N'AttendanceV', N'StdAcademicCalendarSetup', NULL, N'fa fa-edit', NULL, N'A', 13, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4082, 406, N'Student Late in Early Out', N'b', N'AttendanceV', N'StdLateinEarlyOut', NULL, N'fa fa-edit', NULL, N'A', 14, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4083, 406, N'Teacher Period Setup', N'b', N'AttendanceV', N'StdTeacherPeriodSetup', NULL, N'fa fa-edit', NULL, N'A', 15, 0)
GO

INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4063, 407, N'Period Setup', N'b', N'AttendanceV', N'PeriodSetup', NULL, N'fa fa-edit', NULL, N'A', 15, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4064, 407, N'Period Teacher Assign', N'b', N'RoutineV', N'PeriodTeacherAssign', NULL, N'fa fa-edit', NULL, N'A', 16, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4065, 407, N'Class Period', N'b', N'RoutineV', N'ClassPeriod', NULL, N'fa fa-edit', NULL, N'A', 17, 0)
GO

INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4100, 408, N'Student Fees Config', N'b', N'FeesV', N'CommonFees', NULL, N'fa fa-edit', NULL, N'A', 3, 0)
--GO
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4102, 408, N'Individual Fees', N'b', N'FeesV', N'IndividualFees', NULL, N'fa fa-edit', NULL, N'A', 21, 0)
--GO
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4103, 408, N'Session Year Setup', N'b', N'FeesV', N'SessionYearSetup', NULL, N'fa fa-edit', NULL, N'A', 20, 0)
--GO
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4103, 408, N'Session Year Setup', N'b', N'FeesV', N'SessionYearSetup', NULL, N'fa fa-edit', NULL, N'A', 20, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4104, 408, N'Fees Process Setup', N'b', N'FeesV', N'FeesProcessSetup', NULL, N'fa fa-edit', NULL, N'A', 2, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4105, 408, N'Fees Head Setup', N'b', N'FeesV', N'FeesHeadSetup', NULL, N'fa fa-edit', NULL, N'A', 1, 0)
GO

INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4106, 408, N'Scholarship', N'b', N'FeesV', N'StudentScholarship', NULL, N'fa fa-edit', NULL, N'A', 7, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4107, 408, N'Scholarship Type', N'b', N'FeesV', N'ScholarshipType', NULL, N'fa fa-edit', NULL, N'A', 6, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4108, 408, N'Automated Fees', N'b', N'FeesV', N'AutomatedFeesConfig', NULL, N'fa fa-edit', NULL, N'A', 5, 0)
GO
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4109, 408, N'Add Automated Fees', N'b', N'FeesV', N'AddAutomatedFees', NULL, N'fa fa-plus', NULL, N'A', 26, 0)
--GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4110, 408, N'Fees Setting', N'b', N'FeesV', N'FeesSetting', NULL, N'fa fa-edit', NULL, N'A', 8, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4111, 408, N'FeesTransportConfig', N'b', N'FeesV', N'FeesTransportConfig', NULL, N'fa fa-edit', NULL, N'A', 4, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4112, 408, N'Fees Group Setup', N'b', N'FeesV', N'FeesHeadDisplayGroupSetup', NULL, N'fa fa-edit', NULL, N'A', 9, 0)


GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (4091, 409, N'Leave Type', N'b', N'AttendanceV', N'LeaveType', NULL, N'fa fa-edit', NULL, N'A', 20, 0)
GO

INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (7001, 702, N'Process', N'b', N'FeesV', N'FeesProcess', NULL, N'fa fa-edit', NULL, N'A', 21, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (7002, 702, N'Fees Book', N'b', N'FeesV', N'FeesBook', NULL, N'fa fa-edit', NULL, N'A', 22, 0)
GO


INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (7010, 705, N'Fees Collection Report', N'b', N'FeesV', N'FeesCollectionReport', NULL, N'fa fa-edit', NULL, N'A', 1, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (7011, 705, N'Individual Student', N'b', N'FeesV', N'IndividualStudentReport', NULL, N'fa fa-edit', NULL, N'A', 2, 0)
GO
INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (7012, 705, N'Money Receipt Print', N'b', N'FeesV', N'MoneyReceiptView', NULL, N'fa fa-edit', NULL, N'A', 3, 0)
GO

--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (8001, 701, N'POS/Live Collection', N'b', N'FeesV', N'FeesCollection', NULL, N'fa fa-clipboard', NULL, N'A', 1, 0)
--GO
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (8002, 701, N'Without Process Collection', N'b', N'FeesV', N'FeesCollectionWithoutProcess', NULL, N'fa fa-clipboard', NULL, N'A', 3, 0)
--GO
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (8003, 701, N'Admin Collection', N'b', N'FeesV', N'BulkFeesCollection', NULL, N'fa fa-clipboard', NULL, N'A', 2, 0)
--GO
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (8004, 701, N'Bulk Collection', N'b', N'FeesV', N'FeesCollectionBulkUpload', NULL, N'fa fa-clipboard', NULL, N'A', 4, 0)
--GO
--INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES (8005, 701, N'Online Collection', N'b', N'FeesV', N'OnlineFeesCollection', NULL, N'fa fa-clipboard', NULL, N'A', 5, 0)
--GO



SET IDENTITY_INSERT [dbo].[AspNetPages] OFF
GO
