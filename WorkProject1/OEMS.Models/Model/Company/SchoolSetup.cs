
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model
{
    [ClassName("School Setup")]
    public class SchoolSetup : Entity
    {
        [Key]
        public int SchoolID { get; set; }

        [StringLength(150)]
        [Required]
        public string SchoolName { get; set; }

        [StringLength(250)]
        public string SchoolNameBangla { get; set; }

        [StringLength(150)]
        public string WebURL { get; set; }

        [StringLength(150)]
        public string Email { get; set; }
        [StringLength(150)]
        public string Email_1 { get; set; }

        [StringLength(500)]
        public string Address { get; set; }

        [Column(TypeName = "image")]
        [Required]
        public byte[]  SchoolLogo { get; set; }
        [StringLength(250)]
        public string AddressBangla { get; set; }

        [StringLength(20)]
        public string ContactNumber { get; set; }

        [StringLength(10)]
        public string Fax { get; set; }

       

    }
}
