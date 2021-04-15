using OEMS.Models;
using OEMS.Models.Model;
using OEMS.Models.Model.Inventory;
using OEMS.Repository.Repositories;
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
  
    public class AssetService : IService<Asset>
    {
        private AssetRepository AssetRepository;

        public AssetService()
        {
            AssetRepository = new AssetRepository();
        }
        public bool Add(Asset entity)
        {
            return AssetRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<Asset> entities)
        {
            return AssetRepository.AddRange(entities);
        }

        public IEnumerable<Asset> Filter(Expression<Func<Asset, bool>> filter, Func<IQueryable<Asset>, IOrderedQueryable<Asset>> orderBy = null, string[] Children = null)
        {
            return AssetRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<Asset, bool>> filter, Func<IQueryable<Asset>, IOrderedQueryable<Asset>> orderBy = null)
        {
            return AssetRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public Asset Get(long id)
        {
            return AssetRepository.Get(id);
        }

        public IEnumerable<Asset> GetAll()
        {
            return AssetRepository.GetAll();
        }

        public IEnumerable<Asset> GetByPage(int pageno, int pagesize)
        {
            return AssetRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return AssetRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return AssetRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return AssetRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            Asset entity = new Asset();
            entity = AssetRepository.SingleOrDefault(e => e.AssetId == id);
            entity.IsDeleted = true;
            entity.Status = "D";
            entity.SetDate();
            return AssetRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<Asset> entities = new List<Asset>();
            entities = AssetRepository.Filter(x => ids.Contains(Convert.ToInt64(x.AssetId))).ToList();

            return AssetRepository.RemoveRange(entities);
        }

        public Asset SingleOrDefault(Expression<Func<Asset, bool>> filter)
        {
            return AssetRepository.SingleOrDefault(filter);
        }

        public bool Update(Asset entity)
        {
            return AssetRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<Asset> entities)
        {
            return AssetRepository.AddRange(entities);
        }
        public bool Remove(string assetName)
        {
            Asset entity = new Asset();
            entity = AssetRepository.SingleOrDefault(e => e.AssetName == assetName);
            return AssetRepository.Remove(entity);
        }

       }
}
