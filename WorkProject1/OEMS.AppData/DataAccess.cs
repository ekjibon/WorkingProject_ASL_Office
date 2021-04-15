using OEMS.Models.Model;
using OEMS.Models.Model.Attendance;
using OEMS.Service.Services;
using OEMS.Service.Services.Account;
using OEMS.Service.Services.Attendance;
using OEMS.Service.Services.Clients;
using OEMS.Service.Services.Employee;
using OEMS.Service.Services.HRPayroll;
using OEMS.Service.Services.Inventory;
using OEMS.Service.Services.Invoice;
using OEMS.Service.Services.ProjectCategorys;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.AppData
{
    public class DataAccess
    {
        private static DataAccess _DataAccess;

        //  SchoolSetupService _SchoolSetupService;
      

    
        
        public PoliceStationService PoliceStation = new PoliceStationService();
        public DistrictService District = new DistrictService();      
        public DropDownConfigService DropDownConfig = new DropDownConfigService();   
        public AlertSettingService AlertSettingService = new AlertSettingService(); // new


  
        public RoleService Role = new RoleService();
        public AspNetPageService AspNetPage = new AspNetPageService();
        public PageRoleService PageRole = new PageRoleService();
        public UsersService Users = new UsersService();
        public EmailTemplateService EmailTemplateService = new EmailTemplateService();


        
        //added by Abul hasan
        public RepHeaderImgService RepHeaderImgService = new RepHeaderImgService();

        public EmpBasicInfoService EmpBasicInfoService=new EmpBasicInfoService();
        public EmpCategoryService EmpCategoryService = new EmpCategoryService();
        public EmpDepartmentService EmpDepartmentService = new EmpDepartmentService();

        //added by Khaled
        public EmpLeaveQuotaService EmpLeaveQuotaService = new EmpLeaveQuotaService();
        public SalaryStructurePeriodService SalaryStructurePeriodService = new SalaryStructurePeriodService();

        public EmpDesignationtService EmpDesignationtService = new EmpDesignationtService();
        public EmpSectionService EmpSectionService = new EmpSectionService();
        public EmpShiftService EmpShiftService = new EmpShiftService();
        public EmpStatusService EmpStatusService = new EmpStatusService();
        public EmpSubjectService EmpSubjectService = new EmpSubjectService();
     
        public EmpImageService EmpImageService = new EmpImageService();

        public EmployeeEducationalInfoService EmployeeEducationalInfoService = new EmployeeEducationalInfoService();
        public EmployeeExamBoardService EmployeeExamBoardService = new EmployeeExamBoardService();
        public EmployeeExamGroupService EmployeeExamGroupService = new EmployeeExamGroupService();
        public EmployeeExamService EmployeeExamService = new EmployeeExamService();
        public EmpJobHistoryService EmpJobHistoryService = new EmpJobHistoryService();
        public EmpNomineeService EmpNomineeService = new EmpNomineeService();
        public EmpDocumentArchiveService EmpDocumentArchiveService = new EmpDocumentArchiveService();
        public EmpTrainingService EmpTrainingService = new EmpTrainingService();
        public EmpLeaveTypeService EmpLeaveTypeService = new EmpLeaveTypeService();
        public BranchService Branch = new BranchService();


        #region Employee
        public SalaryGradeService SalaryGradeService = new SalaryGradeService();
        public EmpLIFOService EmpLIFOService = new EmpLIFOService();
        public LeaveQuotaService LeaveQuotaService = new LeaveQuotaService();
        public SalaryTaxYearService SalaryTaxYearService = new SalaryTaxYearService();
        public SalaryHeadService SalaryHeadService = new SalaryHeadService();
        public SalaryIncrementService SalaryIncrementService = new SalaryIncrementService();
        public SalaryStructureService SalaryStructureService = new SalaryStructureService();
    
        public SalaryPeriodService SalaryPeriodService = new SalaryPeriodService();
        public AdvanceSalaryService AdvanceSalaryService = new AdvanceSalaryService();
        public AdvanceSalaryPaymentService AdvanceSalaryPaymentService = new AdvanceSalaryPaymentService();
        public SalaryYearService SalaryYearService = new SalaryYearService();

        public SalaryHoldService SalaryHoldService = new SalaryHoldService();
        public SalaryHoldRefundService SalaryHoldRefundService = new SalaryHoldRefundService(); 
        public SalaryHoldPaymentService SalaryHoldPaymentService = new SalaryHoldPaymentService();
        public SalaryHeadWiseConfigService SalaryHeadWiseConfigService = new SalaryHeadWiseConfigService();
        public SalaryEmployeeService SalaryEmployeeService = new SalaryEmployeeService();
        public LeaveApplicationService LeaveApplicationService = new LeaveApplicationService();
        public LeaveCategoryService LeaveCategoryService = new LeaveCategoryService();
        public SalaryPayDetailsService SalaryPayDetailsService = new SalaryPayDetailsService();
        public EmpRequestService EmpRequestService = new EmpRequestService();
        public EmpAcademicCalandarService EmpAcademicCalandarService = new EmpAcademicCalandarService();
        public EmpAcademicCalandarDetailsService EmpAcademicCalandarDetailsService = new EmpAcademicCalandarDetailsService();
        public EmpGPSService EmpGPSService = new EmpGPSService();
        #endregion Employee

        #region Leave Routing
        public LeaveRoutingConfigService LeaveRoutingConfigService = new LeaveRoutingConfigService();
        public LeaveRoutingHistoryService LeaveRoutingHistoryService = new LeaveRoutingHistoryService();
        public LeaveRequestDetailsService LeaveRequestDetailsService = new LeaveRequestDetailsService();
        public LeaveRoutingConfigDetailsService LeaveRoutingConfigDetailsService = new LeaveRoutingConfigDetailsService();
        
        #endregion

        //      

        public LeaveTypesService LeaveTypesService = new LeaveTypesService();        
        public SMSSettingsService SMSSettingsService = new SMSSettingsService();
        public SMSTemplateService SMSTemplateService = new SMSTemplateService();
        public SMSTempTagService SMSTempTagService = new SMSTempTagService();
        public SMSSendHistroyService SMSSendHistroyService = new SMSSendHistroyService();
        public SMSExtGroupService SMSExtGroupService = new SMSExtGroupService();
        public SMSExtNumbersService SMSExtNumbersService = new SMSExtNumbersService();
        public ScheduleSMSConfigService ScheduleSMSConfigService = new ScheduleSMSConfigService();

        public PortalDocumentService PortalDocumentService = new PortalDocumentService();

        #region ArchiveService

        #endregion ArchiveService
        #region AccountsService
        public TagsService TagsService = new TagsService();
        public LedgersService LedgersService = new LedgersService();       
        public AccountSettingsService AccountSettingsService = new AccountSettingsService();
        public FiscalYearService FiscalYearService = new FiscalYearService();
        public AccountBranchService AccountBranchService = new AccountBranchService();
        public RootGroupService RootGroupService = new RootGroupService();     
        public TransactionService TransactionService = new TransactionService();
        public TransactionDetailService TransactionDetailService = new TransactionDetailService();
        public CostCategoryService CostCategoryService = new CostCategoryService();
        public CostCenterService CostCenterService = new CostCenterService();
        public CostCenterDetailsService CostCenterDetailsService = new CostCenterDetailsService();        
        #endregion AccountsService
        #region Portal
     
        public EmpMeetingConfigService EmpMeetingConfigService = new EmpMeetingConfigService();
       
        #endregion Portal
        #region Inventory

        public ProductCategoryService ProductCategoryService = new ProductCategoryService();
        public ProductSubCategoryService ProductSubCategoryService = new ProductSubCategoryService();
        public UnitSetupService UnitSetupService = new UnitSetupService();
        public ServiceSetupService ServiceSetupService = new ServiceSetupService();

        public ProductService ProductService = new ProductService();
        public ProductStocksService ProductStocksService = new ProductStocksService();
      
        public QuotationDetailsService QuotationDetailsService = new QuotationDetailsService();
        public QuotationService QuotationService = new QuotationService();
        public RequisitionDetailsService RequisitionDetailsService = new RequisitionDetailsService();
        


        public RequisitionService RequisitionService = new RequisitionService();
        public StockTransactionService StockTransactionService = new StockTransactionService();
        public SupplierService SupplierService = new SupplierService();
        public CustomerService CustomerService = new CustomerService(); //new
        public PurchaseOrderService PurchaseOrderService = new PurchaseOrderService();
        public AssetCategoryService AssetCategoryService = new AssetCategoryService(); 
        public AssetSubCategoryService AssetSubCategoryService = new AssetSubCategoryService();
        public AssetService AssetService = new AssetService();
        public AssetUnitSetupService AssetUnitSetupService = new AssetUnitSetupService();
        public AssetDetailsService AssetDetailsService = new AssetDetailsService();
        public AssetPurchaseOrderDetailsService AssetPurchaseOrderDetailsService = new AssetPurchaseOrderDetailsService();
        public AssetPurchaseOrderService AssetPurchaseOrderService = new AssetPurchaseOrderService();
        public AssetQuotationDetailsService AssetQuotationDetailsService = new AssetQuotationDetailsService();
        public AssetQuotationService AssetQuotationService = new AssetQuotationService();
        public AssetRequisitionDetailsService AssetRequisitionDetailsService = new AssetRequisitionDetailsService();
        public AssetRequisitionService AssetRequisitionService = new AssetRequisitionService();


        #endregion

        #region Client (CRM_Clients)
        public ClientService ClientService = new ClientService();
        public ClientsdbService ClientsdbService = new ClientsdbService();

        #endregion

        #region Invoice
        public InvoiceServiceService InvoiceService = new InvoiceServiceService();
        public InvoiceBillingMethodService InvoiceBillingMethod = new InvoiceBillingMethodService(); 
        public InvoiceBillingHeadService InvoiceBillingHead = new InvoiceBillingHeadService();
        public BillingHeadConfigService BillingHeadConfigService = new BillingHeadConfigService();
        public BillingHeadConfigDetailsService BillingHeadConfigDetailsService = new BillingHeadConfigDetailsService(); 
        public BillingProcessService BillingProcessService = new BillingProcessService(); 
        public InvoiceGenerateService InvoiceGenerateService = new InvoiceGenerateService(); 
        public InvoiceCollectionMasterService InvoiceCollectionMasterService = new InvoiceCollectionMasterService();
        public InvoiceCollectionDetailsService InvoiceCollectionDetailsService = new InvoiceCollectionDetailsService();
        public InvoicePrintMasterService InvoicePrintMasterService = new InvoicePrintMasterService();


        public PhoneCallMaintainService PhoneCallMaintainService = new PhoneCallMaintainService();

        #endregion

        #region Task Management
        public BugAttachmentService BugAttachmentService = new BugAttachmentService();
        public CommentsService CommentsService = new CommentsService();
        public ModulesService ModulesService = new ModulesService();
        public ProjectService ProjectService = new ProjectService();
        public ProjectUsersService ProjectUsersService = new ProjectUsersService();
        public SprintService SprintService = new SprintService();
        public TaskActivityLogService TaskActivityLogService = new TaskActivityLogService();
        public TaskInfoService TaskInfoService = new TaskInfoService();
        public TicketCategoryService TicketCategoryService = new TicketCategoryService();
        public TicketFwdMappingService TicketFwdMappingService = new TicketFwdMappingService();
        public TicketsService TicketsService = new TicketsService();
        public TicketsAttachmentService TicketsAttachmentService = new TicketsAttachmentService();
        public TicketUsersService TicketUsersService = new TicketUsersService();
        public BugService BugService = new BugService();
        public NotificationsService NotificationsService = new NotificationsService();
        public TaskAssignService TaskAssignService = new TaskAssignService();
        public TestSiteService TestSiteService = new TestSiteService();

        public TasksStatusService TasksStatusService = new TasksStatusService();
        public IssueTypeService IssueTypeService = new IssueTypeService();
        public IssueService IssueService = new IssueService();
        public IssueHistoryService IssueHistoryService = new IssueHistoryService();
        public IssueWebLinkService IssueWebLinkService = new IssueWebLinkService();
        public IssueAttachmentService IssueAttachmentService = new IssueAttachmentService();
        public ProjectCategoryService ProjectCategoryService = new ProjectCategoryService();

        #endregion

        #region
     
        #endregion
        public CommonServices CommonServices = new CommonServices();
        private static object _sync = new object();
        public static DataAccess Instance 
        {
            get
            {
                if (_DataAccess == null)
                {
                    lock (_sync)
                    {
                        if (_DataAccess == null)
                        {
                            _DataAccess = new DataAccess();
                        }
                    }
                }
                return _DataAccess;
            }
        }

        public SchoolSetupService SchoolSetupService = new SchoolSetupService();

        // public static SchoolSetupService _SchoolSetupService = new SchoolSetupService();


        public ClassTeacherService aClassTeacherService = new ClassTeacherService();        
        public EmpAttendanceService EmpAttendanceService = new EmpAttendanceService();
        public EmpLeaveModifyService EmpLeaveModifyService = new EmpLeaveModifyService();
        //public EmpAcademicCalandarDetailsService EmpAcademicCalandarDetailsService = new EmpAcademicCalandarDetailsService();

        public UserAccBranchService UserAccBranch = new UserAccBranchService();
        public EmpRosterService EmpRoster = new EmpRosterService();
    }
}
