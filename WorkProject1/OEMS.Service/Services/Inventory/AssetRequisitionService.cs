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
    
   public  class AssetRequisitionService : IService<AssetRequisition>
    {
        private AssetRequisitionRepository assetRequisitionRepository;

        public AssetRequisitionService()
        {
            assetRequisitionRepository = new AssetRequisitionRepository();
        }
        public bool Add(AssetRequisition entity)
        {
            return assetRequisitionRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<AssetRequisition> entities)
        {
            return assetRequisitionRepository.AddRange(entities);
        }

        public IEnumerable<AssetRequisition> Filter(Expression<Func<AssetRequisition, bool>> filter, Func<IQueryable<AssetRequisition>, IOrderedQueryable<AssetRequisition>> orderBy = null, string[] Children = null)
        {
            return assetRequisitionRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<AssetRequisition, bool>> filter, Func<IQueryable<AssetRequisition>, IOrderedQueryable<AssetRequisition>> orderBy = null)
        {
            return assetRequisitionRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public AssetRequisition Get(long id)
        {
            return assetRequisitionRepository.Get(id);
        }

        public IEnumerable<AssetRequisition> GetAll()
        {
            return assetRequisitionRepository.GetAll();
        }

        public IEnumerable<AssetRequisition> GetByPage(int pageno, int pagesize)
        {
            return assetRequisitionRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return assetRequisitionRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return assetRequisitionRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return assetRequisitionRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            AssetRequisition entity = new AssetRequisition();
            entity = assetRequisitionRepository.SingleOrDefault(e => e.AssetRequisitionId == id);
            entity.IsDeleted = true;
            entity.SetDate();
            return assetRequisitionRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<AssetRequisition> entities = new List<AssetRequisition>();
            entities = assetRequisitionRepository.Filter(x => ids.Contains(Convert.ToInt64(x.AssetRequisitionId))).ToList();

            return assetRequisitionRepository.RemoveRange(entities);
        }

        public AssetRequisition SingleOrDefault(Expression<Func<AssetRequisition, bool>> filter)
        {
            return assetRequisitionRepository.SingleOrDefault(filter);
        }

        public bool Update(AssetRequisition entity)
        {
            return assetRequisitionRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<AssetRequisition> entities)
        {
            return assetRequisitionRepository.AddRange(entities);
        }


    }
}
