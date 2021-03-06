using OEMS.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Service.Interface
{
    interface IServiceCommon
    {
       
        CommonResponse GetResponseBySpWithParam(string SpName, params object[] parameterValues);
        DataTable GetBySp(string SpName);
        DataTable GetBySpWithParam(string SpName, params object[] parameterValues);
        object GetScalarValueBySP(string SpName);
        DataTable GetDatatableBySQL(string SQL);
        bool IsExist(string TableName, string Col, string value);
        bool IsExist(string TableName, string Col, int value);

    }
}
