using OEMS.Models.Model;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OEMS.Models;
using System.Linq.Expressions;
using OEMS.Models.Model.Employee;
using OEMS.Repository.Repositories;
using OEMS.Repository.Repositories.Employee;
using OEMS.Models.Model.Attendance;

namespace OEMS.Service.Services
{
    public class EmpLIFOService : IService<EmpLIEO>
    {
        private EmpLIFORepository ClassTeacherRepository;

        public EmpLIFOService()
        {
            ClassTeacherRepository = new EmpLIFORepository();
        }
        public bool Add(EmpLIEO entity)
        {
            return ClassTeacherRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<EmpLIEO> entities)
        {
            return ClassTeacherRepository.AddRange(entities);
        }

        public IEnumerable<EmpLIEO> Filter(Expression<Func<EmpLIEO, bool>> filter, Func<IQueryable<EmpLIEO>, IOrderedQueryable<EmpLIEO>> orderBy = null, string[] Children = null)
        {
            return ClassTeacherRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<EmpLIEO, bool>> filter, Func<IQueryable<EmpLIEO>, IOrderedQueryable<EmpLIEO>> orderBy = null)
        {
            return ClassTeacherRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public EmpLIEO Get(long id)
        {
            return ClassTeacherRepository.Get(id);
        }

        public IEnumerable<EmpLIEO> GetAll()
        {
            return ClassTeacherRepository.GetAll();
        }

        public IEnumerable<EmpLIEO> GetByPage(int pageno, int pagesize)
        {
            return ClassTeacherRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return ClassTeacherRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return ClassTeacherRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return ClassTeacherRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            EmpLIEO entity = new EmpLIEO();
            entity = ClassTeacherRepository.SingleOrDefault(e=>e.LIEOId==id);
            return ClassTeacherRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<EmpLIEO> entities = new List<EmpLIEO>();
            entities = ClassTeacherRepository.Filter(x => ids.Contains(Convert.ToInt64(x.LIEOId))).ToList();

            return ClassTeacherRepository.RemoveRange(entities);
        }

        public EmpLIEO SingleOrDefault(Expression<Func<EmpLIEO, bool>> filter)
        {
            return ClassTeacherRepository.SingleOrDefault(filter);
        }

        public bool Update(EmpLIEO entity) 
        { 
            return ClassTeacherRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<EmpLIEO> entities)
        {
            return ClassTeacherRepository.AddRange(entities);
        }
      
    }
}
