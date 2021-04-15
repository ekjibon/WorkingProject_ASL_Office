using OEMS.Models;
using OEMS.Models.Model;
using OEMS.Models.Model.Invoice;
using OEMS.Repository.Repositories.Invoice;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Service.Services.Invoice
{
    public class PhoneCallMaintainService : IService<PhoneCallMaintain>
    {
        PhoneCallMaintainRepository PhoneCallMaintainRepository; 
        public PhoneCallMaintainService() 
        {
            PhoneCallMaintainRepository = new PhoneCallMaintainRepository();
        }

        public bool Add(PhoneCallMaintain entity)
        {
            return PhoneCallMaintainRepository.Add(entity);
        }


        public bool AddRange(IEnumerable<PhoneCallMaintain> entities)
        {
            return PhoneCallMaintainRepository.AddRange(entities);
        }

        public bool Update(PhoneCallMaintain entity)
        {
            return PhoneCallMaintainRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<PhoneCallMaintain> entities)
        {
            return PhoneCallMaintainRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            PhoneCallMaintain entity = new PhoneCallMaintain();
            entity = PhoneCallMaintainRepository.SingleOrDefault(e => e.Id == id);
            return PhoneCallMaintainRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<PhoneCallMaintain> entities = new List<PhoneCallMaintain>();
            entities = PhoneCallMaintainRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return PhoneCallMaintainRepository.RemoveRange(entities);
        }

        public PhoneCallMaintain Get(long id)
        {
            return PhoneCallMaintainRepository.Get(id);
        }

        public PhoneCallMaintain SingleOrDefault(Expression<Func<PhoneCallMaintain, bool>> filter)
        {
            return PhoneCallMaintainRepository.SingleOrDefault(filter);
        }

        public IEnumerable<PhoneCallMaintain> GetAll()
        {
            return PhoneCallMaintainRepository.GetAll();
        }

        public IEnumerable<PhoneCallMaintain> Filter(Expression<Func<PhoneCallMaintain, bool>> filter, Func<IQueryable<PhoneCallMaintain>, IOrderedQueryable<PhoneCallMaintain>> orderBy = null, string[] Children = null)
        {
            return PhoneCallMaintainRepository.Filter(filter, orderBy);
        }

        public IEnumerable<PhoneCallMaintain> GetByPage(int pageno, int pagesize)
        {
            return PhoneCallMaintainRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return PhoneCallMaintainRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return PhoneCallMaintainRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return PhoneCallMaintainRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<PhoneCallMaintain, bool>> filter, Func<IQueryable<PhoneCallMaintain>, IOrderedQueryable<PhoneCallMaintain>> orderBy = null)
        {
            return PhoneCallMaintainRepository.Filter(pageno, pagesize, filter, orderBy);
        }
    }
}
