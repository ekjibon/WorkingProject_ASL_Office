using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel.TaskManagement
{
    public class IssueReportVM
    {
        public int DepartmentId { get; set; }
        public int ProjectId { get; set; } 
        public int ClientId { get; set; }
        public int SprintId { get; set; }
        public int IssueTypeId { get; set; }
        public int ReportTypeId { get; set; }
        public string FromDate { get; set; }
        public string ToDate { get; set; }
    }
}
