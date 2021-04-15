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
  
    public class AssetDetailsService : IService<AssetDetails>
    {
        private AssetDetailsRepository AssetDetailsRepository;

        public AssetDetailsService()
        {
            AssetDetailsRepository = new AssetDetailsRepository();
        }
        public bool Add(AssetDetails entity)
        {
            return AssetDetailsRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<AssetDetails> entities)
        {
            return AssetDetailsRepository.AddRange(entities);
        }

        public IEnumerable<AssetDetails> Filter(Expression<Func<AssetDetails, bool>> filter, Func<IQueryable<AssetDetails>, IOrderedQueryable<AssetDetails>> orderBy = null, string[] Children = null)
        {
            return AssetDetailsRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<AssetDetails, bool>> filter, Func<IQueryable<AssetDetails>, IOrderedQueryable<AssetDetails>> orderBy = null)
        {
            return AssetDetailsRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public AssetDetails Get(long id)
        {
            return AssetDetailsRepository.Get(id);
        }

        public IEnumerable<AssetDetails> GetAll()
        {
            return AssetDetailsRepository.GetAll();
        }

        public IEnumerable<AssetDetails> GetByPage(int pageno, int pagesize)
        {
            return AssetDetailsRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return AssetDetailsRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return AssetDetailsRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return AssetDetailsRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            AssetDetails entity = new AssetDetails();
            entity = AssetDetailsRepository.SingleOrDefault(e => e.DetailId == id);
            entity.IsDeleted = true;
            entity.Status = "D";
            entity.SetDate();
            return AssetDetailsRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<AssetDetails> entities = new List<AssetDetails>();
            entities = AssetDetailsRepository.Filter(x => ids.Contains(Convert.ToInt64(x.DetailId))).ToList();

            return AssetDetailsRepository.RemoveRange(entities);
        }

        public AssetDetails SingleOrDefault(Expression<Func<AssetDetails, bool>> filter)
        {
            return AssetDetailsRepository.SingleOrDefault(filter);
        }

        public bool Update(AssetDetails entity)
        {
            return AssetDetailsRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<AssetDetails> entities)
        {
            return AssetDetailsRepository.AddRange(entities);
        }
      

       }
}
