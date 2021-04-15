using OEMS.Models;
using OEMS.Models.Model.Inventory;
using OEMS.Repository.Repositories.Inventory;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Service.Services.Inventory
{
    public class ServiceSetupService : IService<ServiceSetup>
    {
        private ServiceSetupRepository serviceSetupRepository;

        public ServiceSetupService()
        {
            serviceSetupRepository = new ServiceSetupRepository();
        }
        public bool Add(ServiceSetup entity)
        {
            return serviceSetupRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<ServiceSetup> entities)
        {
            return serviceSetupRepository.AddRange(entities);
        }

        public IEnumerable<ServiceSetup> Filter(Expression<Func<ServiceSetup, bool>> filter, Func<IQueryable<ServiceSetup>, IOrderedQueryable<ServiceSetup>> orderBy = null, string[] Children = null)
        {
            return serviceSetupRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<ServiceSetup, bool>> filter, Func<IQueryable<ServiceSetup>, IOrderedQueryable<ServiceSetup>> orderBy = null)
        {
            return serviceSetupRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public ServiceSetup Get(long id)
        {
            return serviceSetupRepository.Get(id);
        }

        public IEnumerable<ServiceSetup> GetAll()
        {
            return serviceSetupRepository.GetAll();
        }

        public IEnumerable<ServiceSetup> GetByPage(int pageno, int pagesize)
        {
            return serviceSetupRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return serviceSetupRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return serviceSetupRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return serviceSetupRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            ServiceSetup entity = new ServiceSetup();
            entity = serviceSetupRepository.SingleOrDefault(e => e.ServiceSetupId == id);
            entity.IsDeleted = true;
            entity.SetDate();
            return serviceSetupRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<ServiceSetup> entities = new List<ServiceSetup>();
            entities = serviceSetupRepository.Filter(x => ids.Contains(Convert.ToInt64(x.ServiceSetupId))).ToList();

            return serviceSetupRepository.RemoveRange(entities);
        }

        public ServiceSetup SingleOrDefault(Expression<Func<ServiceSetup, bool>> filter)
        {
            return serviceSetupRepository.SingleOrDefault(filter);
        }

        public bool Update(ServiceSetup entity)
        {
            return serviceSetupRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<ServiceSetup> entities)
        {
            return serviceSetupRepository.AddRange(entities);
        }
    }
}
