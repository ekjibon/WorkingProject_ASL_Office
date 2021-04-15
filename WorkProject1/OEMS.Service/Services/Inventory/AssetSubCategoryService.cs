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
    
  public   class AssetSubCategoryService : IService<AssetSubCategory>
    {
        private AssetSubCategoryRepository AssetSubCategoryRepository;

        public AssetSubCategoryService()
        {
            AssetSubCategoryRepository = new AssetSubCategoryRepository();
        }
        public bool Add(AssetSubCategory entity)
        {
            return AssetSubCategoryRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<AssetSubCategory> entities)
        {
            return AssetSubCategoryRepository.AddRange(entities);
        }

        public IEnumerable<AssetSubCategory> Filter(Expression<Func<AssetSubCategory, bool>> filter, Func<IQueryable<AssetSubCategory>, IOrderedQueryable<AssetSubCategory>> orderBy = null, string[] Children = null)
        {
            return AssetSubCategoryRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<AssetSubCategory, bool>> filter, Func<IQueryable<AssetSubCategory>, IOrderedQueryable<AssetSubCategory>> orderBy = null)
        {
            return AssetSubCategoryRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public AssetSubCategory Get(long id)
        {
            return AssetSubCategoryRepository.Get(id);
        }

        public IEnumerable<AssetSubCategory> GetAll()
        {
            return AssetSubCategoryRepository.GetAll();
        }

        public IEnumerable<AssetSubCategory> GetByPage(int pageno, int pagesize)
        {
            return AssetSubCategoryRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return AssetSubCategoryRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return AssetSubCategoryRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return AssetSubCategoryRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            AssetSubCategory entity = new AssetSubCategory();
            entity = AssetSubCategoryRepository.SingleOrDefault(e => e.AssetSubCatId == id);
            //entity.IsDeleted = true;
            //entity.Status = "D";
            //entity.SetDate();
            return AssetSubCategoryRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<AssetSubCategory> entities = new List<AssetSubCategory>();
            entities = AssetSubCategoryRepository.Filter(x => ids.Contains(Convert.ToInt64(x.AssetSubCatId))).ToList();

            return AssetSubCategoryRepository.RemoveRange(entities);
        }

        public AssetSubCategory SingleOrDefault(Expression<Func<AssetSubCategory, bool>> filter)
        {
            return AssetSubCategoryRepository.SingleOrDefault(filter);
        }

        public bool Update(AssetSubCategory entity)
        {
            return AssetSubCategoryRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<AssetSubCategory> entities)
        {
            return AssetSubCategoryRepository.AddRange(entities);
        }


    }
}
