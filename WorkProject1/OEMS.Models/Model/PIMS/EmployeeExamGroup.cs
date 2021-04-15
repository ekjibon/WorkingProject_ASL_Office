using OEMS.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.Spatial;

[Table("Emp_ExamGroup")]
[ClassName("Employee Exam Group")]
public class EmployeeExamGroup: Entity
    {
        [Key]
        public int EmployeeExamGroup_ID { get; set; }

        [Required]
        [StringLength(100)]
        public string EmployeeExamGroup_Name { get; set; }

      }

