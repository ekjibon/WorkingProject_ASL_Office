using OEMS.Models;
using OEMS.Models.Model.Employee;
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
    public class EmpGPSService : IService<EmpGPS>
    {
        private EmpGPSRepository EmpGPSRepository;

        public EmpGPSService()
        {
            EmpGPSRepository = new EmpGPSRepository();
        }
        public bool Add(EmpGPS entity)
        {
            return EmpGPSRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<EmpGPS> entities)
        {
            return EmpGPSRepository.AddRange(entities);
        }

        public IEnumerable<EmpGPS> Filter(Expression<Func<EmpGPS, bool>> filter, Func<IQueryable<EmpGPS>, IOrderedQueryable<EmpGPS>> orderBy = null, string[] Children = null)
        {
            return EmpGPSRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<EmpGPS, bool>> filter, Func<IQueryable<EmpGPS>, IOrderedQueryable<EmpGPS>> orderBy = null)
        {
            return EmpGPSRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public EmpGPS Get(long id)
        {
            return EmpGPSRepository.Get(id);
        }

        public IEnumerable<EmpGPS> GetAll()
        {
            return EmpGPSRepository.GetAll();
        }

        public IEnumerable<EmpGPS> GetByPage(int pageno, int pagesize)
        {
            return EmpGPSRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return EmpGPSRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return EmpGPSRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return EmpGPSRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            EmpGPS entity = new EmpGPS();
            entity = EmpGPSRepository.SingleOrDefault(e => e.EmpId == id);
            return EmpGPSRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<EmpGPS> entities = new List<EmpGPS>();
            entities = EmpGPSRepository.Filter(x => ids.Contains(Convert.ToInt64(x.EmpId))).ToList();

            return EmpGPSRepository.RemoveRange(entities);
        }

        public EmpGPS SingleOrDefault(Expression<Func<EmpGPS, bool>> filter)
        {
            return EmpGPSRepository.SingleOrDefault(filter);
        }

        public bool Update(EmpGPS entity)
        {
            return EmpGPSRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<EmpGPS> entities)
        {
            return EmpGPSRepository.AddRange(entities);
        }
    }
}
