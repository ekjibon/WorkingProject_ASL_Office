namespace OEMS.Models.Model.Employee
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Emp_Training")]
    [ClassName("Emp Training")]
    public class EmpTraining:Entity
    {
        [Key]
        public int EmpTrainingID { get; set; }
        public int EmpID { get; set; }
        [Required]
        [StringLength(50)]
        public string Title { get; set; }
        [Required]
        [StringLength(50)]
        public string TopicsCovered { get; set; }
        [Required]
        [StringLength(50)]
        public string InstituteName { get; set; }
        [Required]
        [StringLength(50)]
        public string TrainingCountry { get; set; }
        [Required]
        [StringLength(50)]
        public string TrainingLocation { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
        public bool EmpTraining_IsContinued { get; set; }
    }
}
