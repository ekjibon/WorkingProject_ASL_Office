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
    
   public  class UnitSetupService : IService<UnitSetup>
    {
        private UnitSetupRepository unitSetupRepository;

        public UnitSetupService()
        {
            unitSetupRepository = new UnitSetupRepository();
        }
        public bool Add(UnitSetup entity)
        {
            return unitSetupRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<UnitSetup> entities)
        {
            return unitSetupRepository.AddRange(entities);
        }

        public IEnumerable<UnitSetup> Filter(Expression<Func<UnitSetup, bool>> filter, Func<IQueryable<UnitSetup>, IOrderedQueryable<UnitSetup>> orderBy = null, string[] Children = null)
        {
            return unitSetupRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<UnitSetup, bool>> filter, Func<IQueryable<UnitSetup>, IOrderedQueryable<UnitSetup>> orderBy = null)
        {
            return unitSetupRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public UnitSetup Get(long id)
        {
            return unitSetupRepository.Get(id);
        }

        public IEnumerable<UnitSetup> GetAll()
        {
            return unitSetupRepository.GetAll();
        }

        public IEnumerable<UnitSetup> GetByPage(int pageno, int pagesize)
        {
            return unitSetupRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return unitSetupRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return unitSetupRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return unitSetupRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            UnitSetup entity = new UnitSetup();
            entity = unitSetupRepository.SingleOrDefault(e => e.UnitSetupId == id);
            entity.IsDeleted = true;
            entity.SetDate();
            return unitSetupRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<UnitSetup> entities = new List<UnitSetup>();
            entities = unitSetupRepository.Filter(x => ids.Contains(Convert.ToInt64(x.UnitSetupId))).ToList();

            return unitSetupRepository.RemoveRange(entities);
        }

        public UnitSetup SingleOrDefault(Expression<Func<UnitSetup, bool>> filter)
        {
            return unitSetupRepository.SingleOrDefault(filter);
        }

        public bool Update(UnitSetup entity)
        {
            return unitSetupRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<UnitSetup> entities)
        {
            return unitSetupRepository.AddRange(entities);
        }


    }
}
