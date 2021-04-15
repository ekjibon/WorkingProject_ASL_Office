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
    
  public   class ProductSubCategoryService : IService<ProductSubCategory>
    {
        private ProductSubCategoryRepository productSubCategoryRepository;

        public ProductSubCategoryService()
        {
            productSubCategoryRepository = new ProductSubCategoryRepository();
        }
        public bool Add(ProductSubCategory entity)
        {
            return productSubCategoryRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<ProductSubCategory> entities)
        {
            return productSubCategoryRepository.AddRange(entities);
        }

        public IEnumerable<ProductSubCategory> Filter(Expression<Func<ProductSubCategory, bool>> filter, Func<IQueryable<ProductSubCategory>, IOrderedQueryable<ProductSubCategory>> orderBy = null, string[] Children = null)
        {
            return productSubCategoryRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<ProductSubCategory, bool>> filter, Func<IQueryable<ProductSubCategory>, IOrderedQueryable<ProductSubCategory>> orderBy = null)
        {
            return productSubCategoryRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public ProductSubCategory Get(long id)
        {
            return productSubCategoryRepository.Get(id);
        }

        public IEnumerable<ProductSubCategory> GetAll()
        {
            return productSubCategoryRepository.GetAll();
        }

        public IEnumerable<ProductSubCategory> GetByPage(int pageno, int pagesize)
        {
            return productSubCategoryRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return productSubCategoryRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return productSubCategoryRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return productSubCategoryRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            ProductSubCategory entity = new ProductSubCategory();
            entity = productSubCategoryRepository.SingleOrDefault(e => e.ProductSubCatId == id);
            //entity.IsDeleted = true;
            //entity.Status = "D";
            //entity.SetDate();
            return productSubCategoryRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<ProductSubCategory> entities = new List<ProductSubCategory>();
            entities = productSubCategoryRepository.Filter(x => ids.Contains(Convert.ToInt64(x.ProductSubCatId))).ToList();

            return productSubCategoryRepository.RemoveRange(entities);
        }

        public ProductSubCategory SingleOrDefault(Expression<Func<ProductSubCategory, bool>> filter)
        {
            return productSubCategoryRepository.SingleOrDefault(filter);
        }

        public bool Update(ProductSubCategory entity)
        {
            return productSubCategoryRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<ProductSubCategory> entities)
        {
            return productSubCategoryRepository.AddRange(entities);
        }


    }
}
