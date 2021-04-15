using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel
{
   public class AttendanceSearchVM
    {
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
        public bool IsGrand { get; set; }
        public int MainExamId { get; set; }
        public int SessionId { get; set; }
        public int BranchID { get; set; }
        public int ShiftId { get; set; }
        public int? ClassId { get; set; }
        public int? SectionId { get; set; }
        public int? ShiftID { get; set; }
        public string SID { get; set; }
        public string Status{ get; set; }
        
    }

    public class AttendancAdveSearchVM
    {       
        public Int64 StudentIID { get; set; }
        public string STUDENTINSID { get; set; }
        public string FullName { get; set; }
        public int RollNo { get; set; }
        public int PresentDay { get; set; }
        public int LeaveDay { get; set; }
        public int AbsentDay { get; set; }
        public int LateDay { get; set; }
        public int EarlyOutDay { get; set; }
        public int AbscondingDay { get; set; }
        public Decimal Percentage { get; set; }
        public int LIEODay { get; set; }
    }
}
