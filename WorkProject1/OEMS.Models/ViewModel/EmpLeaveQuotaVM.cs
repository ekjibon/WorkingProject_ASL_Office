using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel
{
   public class EmpLeaveQuotaVM
    {

        public int EmpLeaveQuotaId { get; set; }
        public int EmpId { get; set; }
        public int BranchId { get; set; }
        public int EmpCategory { get; set; }
        public int AnnualLeaveDay { get; set; }
        public int SickLeaveDay { get; set; }
        public int AdvanceLeaveDay { get; set; }
        public int MaternityLeaveDay { get; set; }
        public int EmpBasicInfoID { get; set; }
        public int CategoryId { get; set; }
        public int CalenderId { get; set; }
        public int RoutingId { get; set; }
        public int DesignationId { get; set; }
        public int DepartmentId { get; set; }
    }
}
