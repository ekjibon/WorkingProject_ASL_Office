using OEMS.Models;
using OEMS.Models.Model.Account;
using OEMS.Repository.Repositories.Account;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Service.Services.Account
{
    
    public  class CostCenterDetailsService : IService<CostCenterDetails>
    {
        private CostCenterDetailsRepository costCenterDetailsRepository;

        public CostCenterDetailsService()
        {
            costCenterDetailsRepository = new CostCenterDetailsRepository();
        }
        public bool Add(CostCenterDetails entity)
        {
            return costCenterDetailsRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<CostCenterDetails> entities)
        {
            return costCenterDetailsRepository.AddRange(entities);
        }

        public IEnumerable<CostCenterDetails> Filter(Expression<Func<CostCenterDetails, bool>> filter, Func<IQueryable<CostCenterDetails>, IOrderedQueryable<CostCenterDetails>> orderBy = null, string[] Children = null)
        {
            return costCenterDetailsRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<CostCenterDetails, bool>> filter, Func<IQueryable<CostCenterDetails>, IOrderedQueryable<CostCenterDetails>> orderBy = null)
        {
            return costCenterDetailsRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public CostCenterDetails Get(long id)
        {
            return costCenterDetailsRepository.Get(id);
        }

        public IEnumerable<CostCenterDetails> GetAll()
        {
            return costCenterDetailsRepository.GetAll();
        }

        public IEnumerable<CostCenterDetails> GetByPage(int pageno, int pagesize)
        {
            return costCenterDetailsRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return costCenterDetailsRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return costCenterDetailsRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return costCenterDetailsRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            CostCenterDetails entity = new CostCenterDetails();
            entity = costCenterDetailsRepository.SingleOrDefault(e => e.Id == id);
            entity.IsDeleted = true;
            entity.SetDate();
            return costCenterDetailsRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<CostCenterDetails> entities = new List<CostCenterDetails>();
            entities = costCenterDetailsRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return costCenterDetailsRepository.RemoveRange(entities);
        }

        //public CostCenter SingleOrDefault(Expression<Func<CostCenterDetails, bool>> filter)
        //{
        //    return costCenterDetailsRepository.SingleOrDefault(filter);
        //}

        public bool Update(CostCenterDetails entity)
        {
            return costCenterDetailsRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<CostCenterDetails> entities)
        {
            return costCenterDetailsRepository.AddRange(entities);
        }

        CostCenterDetails IService<CostCenterDetails>.SingleOrDefault(Expression<Func<CostCenterDetails, bool>> filter)
        {
            throw new NotImplementedException();
        }
    }
}
