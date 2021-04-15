using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel.Employee
{
    public class EmpRequestVM
    {
        public int Id { get; set; }
        public string Status { get; set; }
        public DateTime AddDate { get; set; }
        public DateTime Date { get; set; }
        public string MeetingIssue { get; set; }
        public string Reason { get; set; }
        public string Remarks { get; set; }
        public string Description { get; set; }
        public int ReqID { get; set; }
        public int EmpBasicInfoID { get; set; }
        public string FatherName { get; set; }
        public string MotherName { get; set; }
        public string EmpID { get; set; }
        public string RequestType { get; set; }
        public string RequestedBy { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
        public string CategoryName { get; set; }
        public decimal Duration { get; set; }
        public string LeaveTypeCategory { get; set; }

        public int LeaveCategoryId { get; set; }
        public string From { get; set; }
        public string To { get; set; }
        public bool IsFile { get; set; }
    }
}
