
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace OEMS.Models.Model.Employee
{
    [Table("Emp_DocumentArchive")]
    [ClassName("Employee Document Archive")]

    public class EmpDocumentArchive:Entity 
    {
        [Key]
        public int EmpDocumentID { get; set; }
        public int EmpID { get; set; }
        
        public string DocumentName { get; set; }       
        public byte[] File { get; set; }
        public object ID { get; set; }
    }
}
