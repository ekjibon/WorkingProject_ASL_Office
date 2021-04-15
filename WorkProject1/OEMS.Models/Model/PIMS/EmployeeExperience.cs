using OEMS.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.Spatial;

[ClassName("Employee Experience")]
public partial class EmployeeExperience :Entity
    {
        [Key]
        public int EmployeeExperience_ID { get; set; }

        public int EmployeeExperience_EmployeeAutoID { get; set; }

        [Required]
        [StringLength(50)]
        public string EmployeeExperience_CompanyName { get; set; }

        [Required]
        [StringLength(50)]
        public string EmployeeExperience_Designation { get; set; }

        [Required]
        [StringLength(50)]
        public string EmployeeExperience_AreaOfExperience { get; set; }

        public DateTime EmployeeExperience_FromDate { get; set; }

        public DateTime EmployeeExperience_ToDate { get; set; }

        public bool EmployeeExperience_IsContinued { get; set; }

        [Required]
        [StringLength(50)]
        public string EmployeeExperience_TotalExperience { get; set; }

      
    }
