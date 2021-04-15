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
    
   public  class AssetUnitSetupService : IService<AssetUnitSetup>
    {
        private AssetUnitSetupRepository assetunitSetupRepository;

        public AssetUnitSetupService()
        {
            assetunitSetupRepository = new AssetUnitSetupRepository();
        }
        public bool Add(AssetUnitSetup entity)
        {
            return assetunitSetupRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<AssetUnitSetup> entities)
        {
            return assetunitSetupRepository.AddRange(entities);
        }

        public IEnumerable<AssetUnitSetup> Filter(Expression<Func<AssetUnitSetup, bool>> filter, Func<IQueryable<AssetUnitSetup>, IOrderedQueryable<AssetUnitSetup>> orderBy = null, string[] Children = null)
        {
            return assetunitSetupRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<AssetUnitSetup, bool>> filter, Func<IQueryable<AssetUnitSetup>, IOrderedQueryable<AssetUnitSetup>> orderBy = null)
        {
            return assetunitSetupRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public AssetUnitSetup Get(long id)
        {
            return assetunitSetupRepository.Get(id);
        }

        public IEnumerable<AssetUnitSetup> GetAll()
        {
            return assetunitSetupRepository.GetAll();
        }

        public IEnumerable<AssetUnitSetup> GetByPage(int pageno, int pagesize)
        {
            return assetunitSetupRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return assetunitSetupRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return assetunitSetupRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return assetunitSetupRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            AssetUnitSetup entity = new AssetUnitSetup();
            entity = assetunitSetupRepository.SingleOrDefault(e => e.UnitSetupId == id);
            entity.IsDeleted = true;
            entity.SetDate();
            return assetunitSetupRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<AssetUnitSetup> entities = new List<AssetUnitSetup>();
            entities = assetunitSetupRepository.Filter(x => ids.Contains(Convert.ToInt64(x.UnitSetupId))).ToList();

            return assetunitSetupRepository.RemoveRange(entities);
        }

        public AssetUnitSetup SingleOrDefault(Expression<Func<AssetUnitSetup, bool>> filter)
        {
            return assetunitSetupRepository.SingleOrDefault(filter);
        }

        public bool Update(AssetUnitSetup entity)
        {
            return assetunitSetupRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<AssetUnitSetup> entities)
        {
            return assetunitSetupRepository.AddRange(entities);
        }


    }
}
