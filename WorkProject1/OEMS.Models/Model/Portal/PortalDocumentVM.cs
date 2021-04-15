using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Portal
{
    public class PortalDocumentVM : Entity
    {

        public int DocumentId { get; set; }
        public string Title { get; set; }
        public int TypeId { get; set; } //1=Academic Calender, 2= Newsletter,3=ECA Notice
        public int? Year { get; set; }
        public string Month { get; set; }

        public byte[] File { get; set; }
        public string FileName { get; set; }
        public int DocType { get; set; } // student =1 and employee=2
        public int SessionId { get; set; }
        public string ClassId { get; set; }
        public string ShiftId { get; set; }
        public int? BranchId { get; set; }
        public int? EmpId { get; set; }
    }
}