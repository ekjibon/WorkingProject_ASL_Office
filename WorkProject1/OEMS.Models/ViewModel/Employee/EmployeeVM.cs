using OEMS.Models.Model;
using OEMS.Models.Model.Employee;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Models.ViewModel.Employee
{
   public class EmployeeVM
    {
        public EmployeeVM() {
            EmpBasicInfo = new EmpBasicInfo();
            EmpImage = new EmpImage();
            EmpJobHistory = new List<EmpJobHistory>();
            EmployeeEducationalInfo = new List<EmployeeEducationalInfo>();
            EmpNominee = new List<EmpNominee>();
            EmpTraining = new List<EmpTraining>();
        }
        public EmpBasicInfo EmpBasicInfo { get; set; }
        public EmpImage EmpImage { get; set; }
        public List<EmpJobHistory> EmpJobHistory { get; set; }
        public List<EmployeeEducationalInfo> EmployeeEducationalInfo { get; set; }
        public List<EmpNominee> EmpNominee { get; set; }
        public List<EmpTraining> EmpTraining { get; set; }
    }
}
