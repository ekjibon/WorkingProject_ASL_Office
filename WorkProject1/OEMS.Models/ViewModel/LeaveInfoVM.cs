using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel
{
   public class LeaveInfoVM
    {
       
        public int EmpId { get; set; }
        public int EmpRequestId { get; set; }
        public string FromDate { get; set; }
        public string ToDate { get; set; }
        public int Adjustable { get; set; }
        public int Unadjusted { get; set; }
        public int Withpay { get; set; }
        public int WithOutpay { get; set; }
        public int MaternityLeaveType { get; set; }
        public decimal RemainingUnadjusted { get; set; }
        public int LeaveHistoryId { get; set; }
        public string LeaveStatus { get; set; } // Approve = A,Reject = R
        public string ApproveType { get; set; } // Final Approval = FA, History Modal 
        public string Comments { get; set; }

        public int CalendarId { get; set; }
        public string Status { get; set; }
    }

    public class LeaveInfoDetailsVM
    {
        public LeaveInfoDetailsVM()
        {
            LeaveRequestDetailsList = new List<LeaveRequestDetail>();
            LeaveRoutingHistoryList = new List<LeaveRoutingHistoryVM>();
        }
        public int Id { get; set; }
        public int EmpId { get; set; }
        public int EmpRequestId { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
        public decimal Adjustable { get; set; }
        public decimal Unadjusted { get; set; }
        public int AdjustableDay { get; set; }
        public int UnadjustedDay { get; set; }
        public int Withpay { get; set; }
        public int WithOutpay { get; set; }
        public int MaternityLeaveType { get; set; }
        public decimal RemainingUnadjusted { get; set; }
        public string CategoryName { get; set; }
        public int LeaveHistoryId { get; set; }
        public string LeaveStatus { get; set; } // Approve = A,Reject = R
        public string ApproveType { get; set; } // Final Approval = FA, History Modal 
        public string Comments { get; set; }
        public decimal Duration { get; set; }
        public int LeaveCategoryId { get; set; }
        public string Reason { get; set; }
        public string Description { get; set; }
        public List<LeaveRequestDetail> LeaveRequestDetailsList { get; set; }
        public List<LeaveRoutingHistoryVM> LeaveRoutingHistoryList { get; set; }
        public List<LeaveQuotaVM> LeaveQuotaList { get; set; }

    }

    public class LeaveRequestDetail
    {
        public int Id { get; set; }
        public int LeaveId { get; set; } // fk
        public int EmpId { get; set; } // fk
        public string CategoryName { get; set; }
        public int LeaveCategoryId { get; set; } // fk 
        public decimal EligibleDays { get; set; }
        public decimal LeaveAvailed { get; set; }
        public decimal LeaveInHand { get; set; }
        public decimal AdjustLeave { get; set; }
        public decimal WithPayLeave { get; set; }
        public decimal WithoutPayLeave { get; set; }
    }


    public class LeaveRoutingHistoryVM
    {
        public int RoutingId { get; set; } 
        public string Comments { get; set; }
        public DateTime AddDate { get; set; }
        public string ApprovedStatus { get; set; }
        public string FullName { get; set; }
        public bool IsApprove { get; set; }
        public bool IsReject { get; set; }
    }

    public class LeaveQuotaVM
    {
        public int EmpId { get; set; }
        public int CalenderId { get; set; }
        public int RoutingId { get; set; }
        public decimal AnnualLeaveDay { get; set; }
        public decimal SickLeaveDay { get; set; }
        public decimal AdvanceLeaveDay { get; set; }
        public decimal MaternityLeaveDay { get; set; }
    }
}
