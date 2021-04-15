using OEMS.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.Spatial;

[Table("Emp_ExamBoard")]
[ClassName("Employee Exam Board")]
public class EmployeeExamBoard : Entity
{
        [Key]
        public int EmployeeExamBoard_ID { get; set; }

        [Required]
        [StringLength(100)]
        public string EmployeeExamBoard_Name { get; set; }

      
    }

