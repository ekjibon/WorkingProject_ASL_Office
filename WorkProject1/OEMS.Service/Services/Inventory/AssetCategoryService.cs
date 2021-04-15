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
    
    public  class AssetCategoryService : IService<AssetCategory>
    {
        private AssetCategoryRepository AssettCategoryRepository;

        public AssetCategoryService()
        {
            AssettCategoryRepository = new AssetCategoryRepository();
        }
        public bool Add(AssetCategory entity)
        {
            return AssettCategoryRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<AssetCategory> entities)
        {
            return AssettCategoryRepository.AddRange(entities);
        }

        public IEnumerable<AssetCategory> Filter(Expression<Func<AssetCategory, bool>> filter, Func<IQueryable<AssetCategory>, IOrderedQueryable<AssetCategory>> orderBy = null, string[] Children = null)
        {
            return AssettCategoryRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<AssetCategory, bool>> filter, Func<IQueryable<AssetCategory>, IOrderedQueryable<AssetCategory>> orderBy = null)
        {
            return AssettCategoryRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public AssetCategory Get(long id)
        {
            return AssettCategoryRepository.Get(id);
        }

        public IEnumerable<AssetCategory> GetAll()
        {
            return AssettCategoryRepository.GetAll();
        }

        public IEnumerable<AssetCategory> GetByPage(int pageno, int pagesize)
        {
            return AssettCategoryRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return AssettCategoryRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return AssettCategoryRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return AssettCategoryRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            AssetCategory entity = new AssetCategory();
            entity = AssettCategoryRepository.SingleOrDefault(e => e.AssetCateId == id);
            entity.IsDeleted = true;
            entity.SetDate();
            return AssettCategoryRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<AssetCategory> entities = new List<AssetCategory>();
            entities = AssettCategoryRepository.Filter(x => ids.Contains(Convert.ToInt64(x.AssetCateId))).ToList();

            return AssettCategoryRepository.RemoveRange(entities);
        }

        public AssetCategory SingleOrDefault(Expression<Func<AssetCategory, bool>> filter)
        {
            return AssettCategoryRepository.SingleOrDefault(filter);
        }

        public bool Update(AssetCategory entity)
        {
            return AssettCategoryRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<AssetCategory> entities)
        {
            return AssettCategoryRepository.AddRange(entities);
        }
        public bool Remove(string categoryName)
        {
            AssetCategory entity = new AssetCategory();
            entity = AssettCategoryRepository.SingleOrDefault(e => e.CategoryName == categoryName);
            return AssettCategoryRepository.Remove(entity);
        }


    }
}
