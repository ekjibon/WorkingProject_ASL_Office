using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel.TaskManagement
{
    public class IssueFilterVM
    {
       public string Priority { get; set; }
        public int? IssueTypeId { get; set; }
        public int? ProjectId { get; set; }
        public int? ClientId { get; set; }
        public int? ReporteId { get; set; }
        public int? SprintId { get; set; }
        public int? StatusId { get; set; }
        public string AddBy { get; set; }
        public int? AssigneeId { get; set; }
        public string DueDate { get; set; }

        public string TypeFilter { get; set; }
        public int issueCount { get; set; } = 10; 
        public int pageno { get; set; } = 1;
        public int pageSize { get; set; } = 10;


    }
}
