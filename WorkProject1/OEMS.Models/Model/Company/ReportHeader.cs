using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.Model
{
    [Table("Ins_ReportHeader")]
    [ClassName("Report Header")]
    public class ReportHeader : Entity
    {
        [Key]
        public int ReportHeaderId { get; set; }
        [Required]

        [Column(TypeName = "image")]
        public byte[] LegalLandscape { get; set; }
        [Column(TypeName = "image")]
        public byte[] LegalPortrait { get; set; }

        [Column(TypeName = "image")]
        public byte[] A4Landscape { get; set; }

        [Column(TypeName = "image")]
        public byte[] A4Portrait { get; set; }


    }
}
