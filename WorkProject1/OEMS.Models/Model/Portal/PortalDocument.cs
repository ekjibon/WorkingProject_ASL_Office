using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model.Document
{
    [Table("Portal_Document")]
    [ClassName("Portal Document")]
    public  class PortalDocument : Entity
    {
        [Key]
        public int DocumentId { get; set; } 
        public string Title { get; set; }
        public int TypeId { get; set; } //1=Academic Calender, 2= Newsletter,3=ECA Notice
        public int? Year { get; set; }
        public string Month { get; set; }

        public byte[] File { get; set; }
        public string  FileName { get; set; }
        public int  DocType { get; set; } // Employee=2

        #region Institution Basic Info
        public int SessionId { get; set; }
        public int? ClassId { get; set; }
        public int? ShiftId { get; set; }
        //public int? SectionId { get; set; }
        public int? BranchId { get; set; }
        public int? EmpId { get; set; }
        #endregion
    }
}
