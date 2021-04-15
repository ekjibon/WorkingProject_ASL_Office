namespace OEMS.Models.Model.Employee
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Emp_Nominee")]
    [ClassName("Emp Nominee")]
    public  class EmpNominee:Entity
    {
        [Key]
        public int EmpNomineeID { get; set; }

        public int EmpID { get; set; }

        [StringLength(150)]
        public string NomineeName { get; set; }

        public DateTime? DOB { get; set; }

        [StringLength(150)]
        public string FathersName { get; set; }

        [StringLength(150)]
        public string MothersName { get; set; }

        [StringLength(50)]
        public string SpouseName { get; set; }

        [StringLength(250)]
        public string PresentAddress { get; set; }

        [StringLength(150)]
        public string PermanentAddress { get; set; }

        [StringLength(50)]
        public string Relation { get; set; }

        [StringLength(50)]
        public string NationalID { get; set; }

        [StringLength(50)]
        public string BirthRegNo { get; set; }

        [Column(TypeName = "image")]
        public byte[] Picture { get; set; }

      
    }
}
