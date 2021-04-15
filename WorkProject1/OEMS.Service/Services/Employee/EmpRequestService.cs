using OEMS.Models;
using OEMS.Models.Model.Student;
using OEMS.Repository.Repositories.Employee;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Service.Services.Employee
{
    public class EmpRequestService : IService<EmpRequest>
    {
        private EmpRequestRepository empRequestRepository;

        public EmpRequestService()
        {
            empRequestRepository = new EmpRequestRepository();
        }
        public bool Add(EmpRequest entity)
        {
            return empRequestRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<EmpRequest> entities)
        {
            return empRequestRepository.AddRange(entities);
        }

        public IEnumerable<EmpRequest> Filter(Expression<Func<EmpRequest, bool>> filter, Func<IQueryable<EmpRequest>, IOrderedQueryable<EmpRequest>> orderBy = null, string[] Children = null)
        {
            return empRequestRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<EmpRequest, bool>> filter, Func<IQueryable<EmpRequest>, IOrderedQueryable<EmpRequest>> orderBy = null)
        {
            return empRequestRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public EmpRequest Get(long id)
        {
            return empRequestRepository.Get(id);
        }

        public IEnumerable<EmpRequest> GetAll()
        {
            return empRequestRepository.GetAll();
        }

        public IEnumerable<EmpRequest> GetByPage(int pageno, int pagesize)
        {
            return empRequestRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return empRequestRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return empRequestRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return empRequestRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            EmpRequest entity = new EmpRequest();
            entity = empRequestRepository.SingleOrDefault(e => e.Id == id);
           
            return empRequestRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<EmpRequest> entities = new List<EmpRequest>();
            entities = empRequestRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return empRequestRepository.RemoveRange(entities);
        }

        public EmpRequest SingleOrDefault(Expression<Func<EmpRequest, bool>> filter)
        {
            return empRequestRepository.SingleOrDefault(filter);
        }

        public bool Update(EmpRequest entity)
        {
            return empRequestRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<EmpRequest> entities)
        {
            return empRequestRepository.AddRange(entities);
        }
   

    }
}
