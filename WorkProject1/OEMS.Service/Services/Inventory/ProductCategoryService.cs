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
    
    public  class ProductCategoryService : IService<ProductCategory>
    {
        private ProductCategoryRepository productCategoryRepository;

        public ProductCategoryService()
        {
            productCategoryRepository = new ProductCategoryRepository();
        }
        public bool Add(ProductCategory entity)
        {
            return productCategoryRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<ProductCategory> entities)
        {
            return productCategoryRepository.AddRange(entities);
        }

        public IEnumerable<ProductCategory> Filter(Expression<Func<ProductCategory, bool>> filter, Func<IQueryable<ProductCategory>, IOrderedQueryable<ProductCategory>> orderBy = null, string[] Children = null)
        {
            return productCategoryRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<ProductCategory, bool>> filter, Func<IQueryable<ProductCategory>, IOrderedQueryable<ProductCategory>> orderBy = null)
        {
            return productCategoryRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public ProductCategory Get(long id)
        {
            return productCategoryRepository.Get(id);
        }

        public IEnumerable<ProductCategory> GetAll()
        {
            return productCategoryRepository.GetAll();
        }

        public IEnumerable<ProductCategory> GetByPage(int pageno, int pagesize)
        {
            return productCategoryRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return productCategoryRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return productCategoryRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return productCategoryRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            ProductCategory entity = new ProductCategory();
            entity = productCategoryRepository.SingleOrDefault(e => e.ProductCateId == id);
            entity.IsDeleted = true;
            entity.SetDate();
            return productCategoryRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<ProductCategory> entities = new List<ProductCategory>();
            entities = productCategoryRepository.Filter(x => ids.Contains(Convert.ToInt64(x.ProductCateId))).ToList();

            return productCategoryRepository.RemoveRange(entities);
        }

        public ProductCategory SingleOrDefault(Expression<Func<ProductCategory, bool>> filter)
        {
            return productCategoryRepository.SingleOrDefault(filter);
        }

        public bool Update(ProductCategory entity)
        {
            return productCategoryRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<ProductCategory> entities)
        {
            return productCategoryRepository.AddRange(entities);
        }
        public bool Remove(string categoryName)
        {
            ProductCategory entity = new ProductCategory();
            entity = productCategoryRepository.SingleOrDefault(e => e.CategoryName == categoryName);
            return productCategoryRepository.Remove(entity);
        }


    }
}
