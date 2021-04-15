
using OEMS.Models.Model;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OEMS.Models.Model.Employee;
using OEMS.Models.Model.Attendance;
using OEMS.Models.Model.Student;
using OEMS.Models.Model.SMS;
using OEMS.Models.Model.Account;
using OEMS.Models.Model.Portal;
using OEMS.Models.Model.Company;
using OEMS.Models.Model.HR_PayRoll;
using OEMS.Models.Model.Document;
using OEMS.Models.Model.Club;
using OEMS.Models.Model.Inventory;
using UI.Admin.Models.Task;
using OEMS.Models.Model.Invoice;
using OEMS.Models.Model.TaskManagement;
using OEMS.Models.Model.Client;

namespace OEMS.Models
{
    public class ModelDbContext:DbContext
    {
        public ModelDbContext() : base("DefaultConnection")
        {
            this.Configuration.LazyLoadingEnabled = true;
        }
        public DbSet<AspNetPage> AspNetPage { get; set; }
        public DbSet<AspNetApi> AspNetApi { get; set; }
        public DbSet<AspNetPageApi> AspNetPageApi { get; set; }
        public DbSet<AspNetPagesRole> AspNetPagesRole { get; set; }
        public DbSet<AspNetRole> AspNetRole { get; set; }
        public DbSet<AspNetUser> AspNetUser { get; set; }
        public DbSet<SchoolSetup> SchoolSetup { get; set; }        
        public DbSet<EmpLeaveQuota> EmpLeaveQuota { get; set; }  
        public DbSet<DropDownConfig> DropDownConfig { get; set; }
        public DbSet<District> District { get; set; }
        public DbSet<PoliceStation> PoliceStation { get; set; }    
      
        public DbSet<AlertSetting> AlertSetting { get; set; }



        public DbSet<SalaryStructurePeriod> SalaryStructurePeriod { get; set; }
        public DbSet<SalaryStructurePeriodModifylog> SalaryStructurePeriodModifylog { get; set; }
        public DbSet<EmployeeSalary> EmployeeSalary { get; set; }
        public DbSet<EmpRequest> EmpRequest { get; set; }
        public DbSet<EmpDocumentArchive> EmpDocumentArchive { get; set; }

        public DbSet<SystemLog> SystemLog { get; set; }     
        public DbSet<ReportHeader> ReportHeader { get; set; }

        
        //Add Employee All Models Contex Abul Hasan      
        public DbSet<EmpBasicInfo> EmpBasicInfo { get; set; }
        public DbSet<EmpCategory> EmpCategory { get; set; }
        public DbSet<EmpDepartment> EmpDepartment { get; set; }
        public DbSet<EmpDesignation> EmpDesignation { get; set; }
        public DbSet<EmpShift> EmpShift { get; set; }
        public DbSet<EmpSection> EmpSection { get; set; }
        public DbSet<EmpStatus> EmpStatus { get; set; }
        public DbSet<EmpSubject> EmpSubject { get; set; }
        public DbSet<EmpMeetingConfig> EmpMeetingConfig { get; set; }
        public DbSet<EmpAttendance> EmpAttendance { get; set; }
        public DbSet<EmpLIEO> EmpLIEO { get; set; }

        public DbSet<PortalDocument> PortalDocument { get; set; }
        public DbSet<ClubConfig> ClubConfig { get; set; }
        public DbSet<ECAClub> ECAClub { get; set; }
        public DbSet<ECAAttendance> ECAAttendance { get; set; }
        public DbSet<StudentClubs> StudentClubs { get; set; }
        public DbSet<StudentClubsHistory> StudentClubsHistory { get; set; }

     

        public DbSet<EmpImage> EmpImage { get; set; }

        public DbSet<EmployeeEducationalInfo> EmployeeEducationalInfo { get; set; }
        public DbSet<EmployeeExam> EmployeeExam { get; set; }
        public DbSet<EmployeeExamBoard> EmployeeExamBoard { get; set; }
        public DbSet<EmpTraining> EmpTraining { get; set; }
        public DbSet<EmpNominee> EmployeeNominee { get; set; }
        public DbSet<EmpJobHistory> EmpJobHistory { get; set; }
        public DbSet<ExamAttendance> ExamAttendance { get; set; }
        public DbSet<EmpLeaveType> EmpLeaveType { get; set; }
        public DbSet<EmployeeTaxSetup> EmployeeTaxSetup { get; set; }
        public DbSet<EmpGPS> EmpGPS { get; set; }


        /// <summary>
        /// Attendance Models
        /// </summary>
        public DbSet<LeaveTypes> LeaveTypes { get; set; }
        public DbSet<AbscondingDetails> AbscondingDetails { get; set; }  
        public DbSet<ClassTeacher> ClassTeacher { get; set; }

      
        public DbSet<EmpAcademicCalendarDetails> EmpAcademicCalendarDetails { get; set; }
        public DbSet<EmpAcademicCalandar> EmpAcademicCalandar { get; set; }
        public DbSet<EmpRoster> EmpRoster { get; set; }
        public DbSet<LeaveRoutingHistory> LeaveRoutingHistory { get; set; }
        public DbSet<LeaveRoutingConfig> LeaveRoutingConfig { get; set; }
        public DbSet<LeaveRoutingConfigDetails> LeaveRoutingConfigDetails { get; set; }        
        public DbSet<LeaveRequestDetails> LeaveRequestDetails { get; set; }
        public DbSet<EmpDeviceAttendance> EmpDeviceAttendance { get; set; }
        public DbSet<EmpLeaveModify> EmpLeaveModify { get; set; }
        public DbSet<AttendanceLog> AttendanceLog { get; set; }
        public DbSet<EmailTemplate> EmailTemplate { get; set; }



        #region SMS Module

        public DbSet<SMSSendHistroy> SMSSendHistroy { get; set; }
        public DbSet<SMSSettings> SMSSettings { get; set; }
        public DbSet<SMSTemplate> SMSTemplate { get; set; }
        public DbSet<SMSTempTag> SMSTempTag { get; set; }
        public DbSet<SMSExtNumbers> SMSExtNumbers { get; set; }
        public DbSet<SMSExtGroup> SMSExtGroup { get; set; }
        public DbSet<ScheduleSMSConfig> ScheduleSMSConfig { get; set; }   
        #endregion
        /// <summary>
        /// Fees 
        /// </summary>
        
        #region Portal
        public DbSet<Pay2FeeTransection> Pay2FeeTransection { get; set; }
        public DbSet<OnlineTrans> OnlineTrans { get; set; }
        #endregion Portal
      
        #region Accounts 
      
        public DbSet<AccountBranchs> AccountBranchs { get; set; }
        public DbSet<AccountLogs> AccountLogs { get; set; }
        public DbSet<AccountSettings> AccountSettings { get; set; }
        public DbSet<TransactionDetail> TransactionDetail { get; set; }
        public DbSet<RootGroup> RootGroup { get; set; }
        public DbSet<Transaction> Transaction { get; set; }     
        public DbSet<Ledgers> Ledgers { get; set; }
        //public DbSet<AccountSettings> Settings { get; set; }
        public DbSet<Tags> Tags { get; set; }
        public DbSet<FiscalYear> FiscalYears { get; set; }
        public DbSet<UserAccBranch> UserAccBranch { get; set; }
        public DbSet<Branch> Branch { get; set; }

        public DbSet<CostCategory> CostCategory { get; set; }
        public DbSet<CostCenter> CostCenter { get; set; }
        public DbSet<CostCenterDetails> CostCenterDetails { get; set; }


        public DbSet<NoticeDetails> NoticeDetails { get; set; }
        public DbSet<NoticeInfo> NoticeInfo { get; set; }
        #endregion
        #region HR Payroll
        public DbSet<SalaryGrade> SalaryGrade { get; set; }
        public DbSet<LeaveQuota> LeaveQuota { get; set; }
        public DbSet<SalaryEmployee> SalaryEmployee { get; set; }
        public DbSet<LeaveApplication> LeaveApplication { get; set; }
        public DbSet<SalaryHead> SalaryHead { get; set; }
        public DbSet<SalaryHeadWiseConfig> SalaryHeadWiseConfig { get; set; }
        public DbSet<SalaryIncrement> SalaryIncrement { get; set; }
        public DbSet<SalaryPeriod> SalaryPeriod { get; set; }
        public DbSet<SalaryStructure> SalaryStructure { get; set; }

        public DbSet<SalaryYear> SalaryYear { get; set; }
        public DbSet<SalaryTaxYear> SalaryTaxYear { get; set; }
        public DbSet<LeaveCategory> LeaveCategory { get; set; }
        public DbSet<SalaryPayDetails> SalaryPayDetails { get; set; }
        public DbSet<AdvanceSalary> AdvanceSalary { get; set; }
        public DbSet<AdvanceSalaryPayment> AdvanceSalaryPayment { get; set; }
        public DbSet<SalaryHold> SalaryHold { get; set; }
        public DbSet<SalaryHoldPayment> SalaryHoldPayment { get; set; }
        public DbSet<Reward> Reward { get; set; }
        public DbSet<SalaryHoldRefund> SalaryHoldRefund { get; set; }
        
        #endregion HR Payroll

        #region Inventory
        public DbSet<Product> Product { get; set; }
        public DbSet<ProductCategory> ProductCategory { get; set; }
        public DbSet<ProductStocks> ProductStock { get; set; }
        public DbSet<ProductSubCategory> ProductSubCategory { get; set; }
        public DbSet<Quotation> Quotation { get; set; }
        public DbSet<QuotationDetails> QuotationDetails { get; set; }
        public DbSet<Requisition> Requisition { get; set; }
        public DbSet<RequisitionDetails> RequisitionDetails { get; set; }
        public DbSet<StockTransaction> StockTransaction { get; set; }
        public DbSet<Supplier> Supplier { get; set; } // bin added
        public DbSet<Customer> Customer { get; set; } //new added
        public DbSet<ServiceSetup> ServiceSetup { get; set; } // new added
        public DbSet<UnitSetup> UnitSetup { get; set; }

        public DbSet<PurchaseOrder> PurchaseOrder { get; set; }
        public DbSet<PurchaseOrderDetails> PurchaseOrderDetails { get; set; }
        public DbSet<Sales> Sales { get; set; }
        public DbSet<SalesDetails> SalesDetails { get; set; }
        public DbSet<AssetDisposal> AssetDisposal { get; set; }
        public DbSet<Distribution> Distribution { get; set; }

        public DbSet<Asset> Asset { get; set; }
        public DbSet<AssetCategory> AssetCategory { get; set; }
        public DbSet<AssetDetails> AssetDetails { get; set; }
        public DbSet<AssetPurchaseOrder> AssetPurchaseOrder { get; set; }
        public DbSet<AssetPurchaseOrderDetails> AssetPurchaseOrderDetails { get; set; }
        public DbSet<AssetQuotation> AssetQuotation { get; set; }
        public DbSet<AssetQuotationDetails> AssetQuotationDetails { get; set; }
        public DbSet<AssetRequisition> AssetRequisition { get; set; }
        public DbSet<AssetRequisitionDetails> AssetRequisitionDetails { get; set; }
        public DbSet<AssetSubCategory> AssetSubCategory { get; set; }
        public DbSet<AssetUnitSetup> AssetUnitSetup { get; set; }


        #endregion

        #region CRM
        public DbSet<Client> Clients { get; set; }
        public DbSet<Clients_db> Clients_db { get; set; }
        #endregion
        #region Task Management
        public DbSet<BugAttachment> BugAttachment { get; set; }
         public DbSet<Comments> Comments { get; set; }
         public DbSet<Modules> Modules { get; set; }
         public DbSet<Project> Project { get; set; }
         public DbSet<ProjectUsers> ProjectUsers { get; set; }
         public DbSet<Sprint> Sprint { get; set; }
         public DbSet<TaskActivityLog> TaskActivityLog { get; set; }
         public DbSet<TaskAssign> TaskAssign { get; set; }
         public DbSet<TaskInfo> TaskInfo { get; set; }
         public DbSet<TicketCategory> TicketCategory { get; set; }
         public DbSet<TicketFwdMapping> TicketFwdMapping { get; set; }
         public DbSet<Tickets> Tickets { get; set; }
         public DbSet<TicketsAttachment> TicketsAttachment { get; set; }
         public DbSet<TicketUsers> TicketUsers { get; set; }
         public DbSet<Notifications> Notifications { get; set; }
         public DbSet<Bug> Bug { get; set; }
         public DbSet<Meeting> Meeting { get; set; }
         public DbSet<MeetingPersons> MeetingPersons { get; set; }
         public DbSet<TestSite> TestSite { get; set; }
        public DbSet<Issue> Issue { get; set; }
        public DbSet<IssueType> IssueType { get; set; }
        public DbSet<TasksStatus> TasksStatus { get; set; }
        public DbSet<IssueHistory> IssueHistory { get; set; }
        public DbSet<IssueWebLink> IssueWebLink { get; set; }
        public DbSet<IssueAttachment> IssueAttachment { get; set; }
        public DbSet<ProjectCategory> ProjectCategory { get; set; }
        


        #endregion
        #region Invoice
        public DbSet<InvoiceService> InvoiceService { get; set; }
        public DbSet<InvoiceBillingHead> InvoiceBillingHead { get; set; }
        public DbSet<InvoiceBillingMethod> InvoiceBillingMethod { get; set; }
        public DbSet<BillingHeadConfig> BillingHeadConfig { get; set; }
        public DbSet<BillingHeadConfigDetails> BillingHeadConfigDetails { get; set; }
        public DbSet<BillingProcess> BillingProcess { get; set; }
        public DbSet<InvoiceGenerate> InvoiceGenerate { get; set; }
        public DbSet<InvoiceCollectionMaster> InvoiceCollectionMaster { get; set; }
        public DbSet<InvoiceCollectionDetails> InvoiceCollectionDetails { get; set; }
        public DbSet<PhoneCallMaintain> PhoneCallMaintain { get; set; }
        public DbSet<InvoiceLog> InvoiceLog { get; set; }
        public DbSet<InvoicePrintMaster> InvoicePrintMaster { get; set; }
        public DbSet<InvoicePrintDetails> InvoicePrintDetails { get; set; }
        #endregion


        private static ModelDbContext _db;
        public static ModelDbContext CreateInstance()
        {
            return _db ?? (_db = new ModelDbContext());
        }
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            Database.SetInitializer<ModelDbContext>(null);
            base.OnModelCreating(modelBuilder);
        }
    }
}
