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
    
    public class RequisitionDetailsService : IService<RequisitionDetails>
    {
        private RequisitionDetailsRepository requisitionDetailsRepository;

        public RequisitionDetailsService()
        {
            requisitionDetailsRepository = new RequisitionDetailsRepository();
        }
        public bool Add(RequisitionDetails entity)
        {
            return requisitionDetailsRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<RequisitionDetails> entities)
        {
            return requisitionDetailsRepository.AddRange(entities);
        }

        public IEnumerable<RequisitionDetails> Filter(Expression<Func<RequisitionDetails, bool>> filter, Func<IQueryable<RequisitionDetails>, IOrderedQueryable<RequisitionDetails>> orderBy = null, string[] Children = null)
        {
            return requisitionDetailsRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<RequisitionDetails, bool>> filter, Func<IQueryable<RequisitionDetails>, IOrderedQueryable<RequisitionDetails>> orderBy = null)
        {
            return requisitionDetailsRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public RequisitionDetails Get(long id)
        {
            return requisitionDetailsRepository.Get(id);
        }

        public IEnumerable<RequisitionDetails> GetAll()
        {
            return requisitionDetailsRepository.GetAll();
        }

        public IEnumerable<RequisitionDetails> GetByPage(int pageno, int pagesize)
        {
            return requisitionDetailsRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return requisitionDetailsRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return requisitionDetailsRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return requisitionDetailsRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            RequisitionDetails entity = new RequisitionDetails();
            entity = requisitionDetailsRepository.SingleOrDefault(e => e.ReqDetailsId == id);
     
            return requisitionDetailsRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<RequisitionDetails> entities = new List<RequisitionDetails>();
            entities = requisitionDetailsRepository.Filter(x => ids.Contains(Convert.ToInt64(x.ReqDetailsId))).ToList();

            return requisitionDetailsRepository.RemoveRange(entities);
        }

        public RequisitionDetails SingleOrDefault(Expression<Func<RequisitionDetails, bool>> filter)
        {
            return requisitionDetailsRepository.SingleOrDefault(filter);
        }

        public bool Update(RequisitionDetails entity)
        {
            return requisitionDetailsRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<RequisitionDetails> entities)
        {
            return requisitionDetailsRepository.AddRange(entities);
        }


    }
}
