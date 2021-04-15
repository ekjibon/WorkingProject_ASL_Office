using OEMS.Models.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Repository.Interface
{
    public interface ISchoolSetupRepository
    {
        SchoolSetup GetSchool(int id);
    }
}
