
SET IDENTITY_INSERT [dbo].[ACC_Ledgers] ON 
INSERT INTO ACC_Ledgers(LedgerId,Name,ParentId,IsEdit,RootGroupId,DisplayOrder,OpenningBalance,OpenningBalanceDc,CurrentBalance,CurrentBalanceDc,IsGroup,IsLedger,IsDisplay,IsDeleted,AddDate) VALUES 
(1, N'Assest', 0, 0, 0, 1,0,1,0,1,1,1,1,0,GETDATE()),
(2, N'Liabilities', 0,  0, 0, 2),
(3, N'Income', 0,  0, 0, 3),
(4, N'Expense', 0, 0, 0, 4),
(5, N'Fixed Assest', 1,  0, 1, 5),
(6, N'Current Assest', 1,  0, 1, 6),
(7, N'Accumulated', 1,  0, 1, 7),
(8, N'Other Assest', 1,  0, 1, 8),
(9, N'Current Liabilities', 2,  0, 2, 9),
(10, N'Non-Current Liabilities', 2,  0, 2, 10),
(11, N'Revenue', 3,  1, 3, 11),
(12, N'Sales Return', 3,  1, 3, 12),
(13, N'Direct Income', 3,  0, 3, 13),
(14, N'InDirect Income', 3,  0, 3, 14),
(15, N'Advertising Expense', 4,  1, 4, 15),
(16, N'Bank Fees', 4, 1, 4, 16),
(17, N'Depreciation Expense', 4,  1, 4, 17),
(18, N'Payroll Tax Expense', 4,  1, 4, 18),
(19, N'Rent Expense', 4,  1, 4, 19),
(20, N'Supplies Expense', 4,  1, 4, 20),
(21, N'Utilities Expense', 4, 1, 4, 21),
(22, N'Wages Expense', 4, 1, 4, 22),
(23, N'Other Expenses', 4, 1, 4, 24),
(24, N'Direct Expenses', 4, 0, 4, 25),
(25, N'InDirect Expenses', 4, 0, 4, 26),
(26, N'Building', 5,  1, 1, 27),
(27, N'Computer equipment', 5, 1, 1, 28),
(28, N'Compurter Software', 5, 1, 1, 29),
(29, N'Furniture and Fixtures', 5, 1, 1, 30),
(30, N'Land', 5, 1, 1, 31),
(31, N'Machinery', 5, 1, 1, 32),
(32, N'Vehicles', 5, 1, 1, 33),
(33, N'Cash In Hand', 6, 1, 1, 34),
(34, N'Bank', 6, 1, 1, 35),
(35, N'Accounts Receivable', 6, 1, 1, 36),
(36, N'Prepaid Expenses', 6, 1, 1, 37),
(37, N'Inventory', 6, 1, 1, 38),
(38, N'Advance Employee', 8, 1, 1, 39),
(39, N'Account Payable', 9, 1, 2, 40),
(40, N'Income Taxes Payable', 9, 1, 2, 41),
(41, N'Bank Account Overdrafts', 9, 1, 2, 42),
(42, N'Accrued Expenses', 9, 1, 2, 43),
(43, N'Short-term Loans', 9, 1, 2, 44),
(44, N'Long-term Loans', 10, 1, 2, 45),
(45, N'Owners Equity', 10, 1, 2, 46)

SET IDENTITY_INSERT [dbo].[ACC_Ledgers] OFF


-------------------------------------------------------------
-------------------------------------------------------------



SET IDENTITY_INSERT [dbo].[ACC_RootGroup] ON 

INSERT [dbo].[ACC_RootGroup] ([Id], [Name], [Prefix], [Surfix], [Seperator], [Lenght], [Order], [IsDeleted], [AddBy], [AddDate], [UpdateBy], [UpdateDate], [Remarks], [Status], [IP], [MacAddress], [Position]) VALUES 
(1, N'Assest', N'AAAA', N'AAAA', N'-', 0, 0, 0, NULL, CAST(N'2019-03-04T14:11:15.087' AS DateTime),, N'admin', CAST(N'2019-03-04T14:11:15.087' AS DateTime), NULL, N'A', N'192.168.20.208', N'10-98-36-B6-3F-04', NULL),
(2, N'Liabilities', N'PP', N'BB', N'-', 0, 0, 0, NULL, CAST(N'2019-03-04T15:31:12.793' AS DateTime),, N'admin', CAST(N'2019-03-04T15:31:12.793' AS DateTime), NULL, N'A', N'192.168.20.211', N'10-98-36-B6-3F-04', NULL),
(3, N'Income', N'KK', N'CK', NULL, 0, 0, 0, NULL, CAST(N'2019-03-05T18:58:33.887' AS DateTime),, N'admin', CAST(N'2019-03-05T18:58:33.887' AS DateTime), NULL, N'A', N'192.168.20.211', N'10-98-36-B6-3F-04', NULL),
(4, N'Expense', NULL, NULL, NULL, 0, 0, 0, NULL, CAST(N'2019-03-05T18:58:36.027' AS DateTime),, N'admin', CAST(N'2019-03-05T18:58:36.027' AS DateTime), NULL, N'A', N'192.168.20.211', N'10-98-36-B6-3F-04', NULL)

SET IDENTITY_INSERT [dbo].[ACC_RootGroup] OFF



-------------------------------------------------------------
-------------------------------------------------------------