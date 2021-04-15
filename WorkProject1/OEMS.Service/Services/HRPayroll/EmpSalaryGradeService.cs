using OEMS.Models;
using OEMS.Models.Model.Employee;
using OEMS.Models.Model.HR_PayRoll;
using OEMS.Repository.Repositories.Employee;
using OEMS.Repository.Repositories.HRPayroll;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Service.Services.HRPayroll
{
   public class SalaryGradeService: IService<SalaryGrade>
    {
        SalaryGradeRepository SalaryGradeRepositorye; 


        public SalaryGradeService()
        {
            SalaryGradeRepositorye = new SalaryGradeRepository();
        }

        public bool Add(SalaryGrade entity)
        {
            return SalaryGradeRepositorye.Add(entity);
        }

        public bool AddRange(IEnumerable<SalaryGrade> entities)
        {
            return SalaryGradeRepositorye.AddRange(entities);
        }

        public bool Update(SalaryGrade entity)
        {
            return SalaryGradeRepositorye.Update(entity);
        }

        public bool UpdateRange(IEnumerable<SalaryGrade> entities)
        {
            return SalaryGradeRepositorye.AddRange(entities);
        }

        public bool Remove(long id)
        {
            SalaryGrade entity = new SalaryGrade();
            entity = SalaryGradeRepositorye.SingleOrDefault(e => e.SalaryGradeId == id);
            return SalaryGradeRepositorye.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<SalaryGrade> entities = new List<SalaryGrade>();
            entities = SalaryGradeRepositorye.Filter(x => ids.Contains(Convert.ToInt64(x.SalaryGradeId))).ToList();

            return SalaryGradeRepositorye.RemoveRange(entities);
        }

        public SalaryGrade Get(long id)
        {
            return SalaryGradeRepositorye.Get(id);
        }

        public SalaryGrade SingleOrDefault(Expression<Func<SalaryGrade, bool>> filter)
        {
            return SalaryGradeRepositorye.SingleOrDefault(filter);
        }

       
        public IEnumerable<SalaryGrade> GetAll()
        {
            return SalaryGradeRepositorye.GetAll();
        }

        public IEnumerable<SalaryGrade> Filter(Expression<Func<SalaryGrade, bool>> filter, Func<IQueryable<SalaryGrade>, IOrderedQueryable<SalaryGrade>> orderBy = null, string[] Children = null)
        {
            return SalaryGradeRepositorye.Filter(filter, orderBy);
        }

        public IEnumerable<SalaryGrade> GetByPage(int pageno, int pagesize)
        {
            return SalaryGradeRepositorye.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return SalaryGradeRepositorye.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return SalaryGradeRepositorye.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return SalaryGradeRepositorye.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<SalaryGrade, bool>> filter, Func<IQueryable<SalaryGrade>, IOrderedQueryable<SalaryGrade>> orderBy = null)
        {
            return SalaryGradeRepositorye.Filter(pageno, pagesize, filter, orderBy);
        }

      
       
       
    }
}
