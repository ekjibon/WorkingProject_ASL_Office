using OEMS.Service.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess
{
    public class DataAccess
    {
        private static DataAccess _DataAccess;

      //  SchoolSetupService _SchoolSetupService;
      

        private static object _sync = new object();

        public static DataAccess Instance
        {
            get
            {
                if (_DataAccess == null)
                {
                    lock (_sync)
                    {
                        if (_DataAccess == null)
                        {
                            _DataAccess = new DataAccess();
                        }
                    }
                }
                return _DataAccess;
            }
        }


        public static SchoolSetupService _SchoolSetupService = new SchoolSetupService();
    }
}
