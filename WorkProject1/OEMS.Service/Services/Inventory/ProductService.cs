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
  
    public class ProductService : IService<Product>
    {
        private ProductRepository productRepository;

        public ProductService()
        {
            productRepository = new ProductRepository();
        }
        public bool Add(Product entity)
        {
            return productRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<Product> entities)
        {
            return productRepository.AddRange(entities);
        }

        public IEnumerable<Product> Filter(Expression<Func<Product, bool>> filter, Func<IQueryable<Product>, IOrderedQueryable<Product>> orderBy = null, string[] Children = null)
        {
            return productRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<Product, bool>> filter, Func<IQueryable<Product>, IOrderedQueryable<Product>> orderBy = null)
        {
            return productRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public Product Get(long id)
        {
            return productRepository.Get(id);
        }

        public IEnumerable<Product> GetAll()
        {
            return productRepository.GetAll();
        }

        public IEnumerable<Product> GetByPage(int pageno, int pagesize)
        {
            return productRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return productRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return productRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return productRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            Product entity = new Product();
            entity = productRepository.SingleOrDefault(e => e.ProductId == id);
            entity.IsDeleted = true;
            entity.Status = "D";
            entity.SetDate();
            return productRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<Product> entities = new List<Product>();
            entities = productRepository.Filter(x => ids.Contains(Convert.ToInt64(x.ProductId))).ToList();

            return productRepository.RemoveRange(entities);
        }

        public Product SingleOrDefault(Expression<Func<Product, bool>> filter)
        {
            return productRepository.SingleOrDefault(filter);
        }

        public bool Update(Product entity)
        {
            return productRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<Product> entities)
        {
            return productRepository.AddRange(entities);
        }
        public bool Remove(string productName)
        {
            Product entity = new Product();
            entity = productRepository.SingleOrDefault(e => e.ProductName == productName);
            return productRepository.Remove(entity);
        }

        public List<DropDownConfig> SearchProduct(string SrchText)
        {
            CommonRepository commonrepository = new CommonRepository();

            var dt = commonrepository.GetBySpWithParam("GetForTypehead", new object[] { SrchText, 7 });

            return CommonRepository.ConvertDataTable<DropDownConfig>(dt);
        }
        
        public List<DropDownConfig> SearchDistributionProduct(string SrchText)
        {
            CommonRepository commonrepository = new CommonRepository();

            var dt = commonrepository.GetBySpWithParam("GetForTypehead", new object[] { SrchText, 9 });

            return CommonRepository.ConvertDataTable<DropDownConfig>(dt);
        }
        
        public List<DropDownConfig> SearchSellingProduct(string SrchText)
        {
            CommonRepository commonrepository = new CommonRepository();

            var dt = commonrepository.GetBySpWithParam("GetForTypehead", new object[] { SrchText, 10 });

            return CommonRepository.ConvertDataTable<DropDownConfig>(dt);
        }
        public List<DropDownConfig> SearchFixedAssetProduct(string SrchText)
        {
            CommonRepository commonrepository = new CommonRepository();

            var dt = commonrepository.GetBySpWithParam("GetForTypehead", new object[] { SrchText, 11 });

            return CommonRepository.ConvertDataTable<DropDownConfig>(dt);
        }
    }
}
