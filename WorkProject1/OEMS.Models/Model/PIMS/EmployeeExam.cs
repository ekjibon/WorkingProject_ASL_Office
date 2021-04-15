using OEMS.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.Spatial;

[Table("Emp_ExamName")]
[ClassName("Employee Exam")]
public class EmployeeExam : Entity 
{
        [Key]
        public int EmployeeExam_ID { get; set; }

        [Required]
        [StringLength(100)]
        public string EmployeeExam_Name { get; set; }

      
    }

