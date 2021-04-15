using OEMS.Models.Model;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OEMS.Models;
using System.Linq.Expressions;
using OEMS.Repository.Repositories;
using OEMS.Models.Model.Student;
using OEMS.Models.Model.SMS;

namespace OEMS.Service.Services
{
    public class SMSSendHistroyService : IService< SMSSendHistroy>
    {
        private  SMSSendHistroyRepository  SMSSendHistroyRepository;

        public  SMSSendHistroyService()
        {
             SMSSendHistroyRepository = new  SMSSendHistroyRepository();
        }
        public bool Add( SMSSendHistroy entity)
        {
            return  SMSSendHistroyRepository.Add(entity);
        }

        public bool AddRange(IEnumerable< SMSSendHistroy> entities)
        {
            return  SMSSendHistroyRepository.AddRange(entities);
        }

        public IEnumerable< SMSSendHistroy> Filter(Expression<Func< SMSSendHistroy, bool>> filter, Func<IQueryable< SMSSendHistroy>, IOrderedQueryable< SMSSendHistroy>> orderBy = null, string[] Children = null)
        {
            return  SMSSendHistroyRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func< SMSSendHistroy, bool>> filter, Func<IQueryable< SMSSendHistroy>, IOrderedQueryable< SMSSendHistroy>> orderBy = null)
        {
            return  SMSSendHistroyRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public  SMSSendHistroy Get(long id)
        {
            return  SMSSendHistroyRepository.Get(id);
        }

        public IEnumerable< SMSSendHistroy> GetAll()
        {
            return  SMSSendHistroyRepository.GetAll();
        }

        public IEnumerable< SMSSendHistroy> GetByPage(int pageno, int pagesize)
        {
            return  SMSSendHistroyRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return  SMSSendHistroyRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return  SMSSendHistroyRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return  SMSSendHistroyRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
             SMSSendHistroy entity = new  SMSSendHistroy();
            entity =  SMSSendHistroyRepository.FirstOrDefault(e => e.HistoryId == id);
            entity.IsDeleted = true;
            entity.SetDate();
            return  SMSSendHistroyRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List< SMSSendHistroy> entities = new List< SMSSendHistroy>();
            entities =  SMSSendHistroyRepository.Filter(x => ids.Contains(Convert.ToInt64(x.HistoryId))).ToList();

            return  SMSSendHistroyRepository.RemoveRange(entities);
        }

        public  SMSSendHistroy SingleOrDefault(Expression<Func< SMSSendHistroy, bool>> filter)
        {
            return  SMSSendHistroyRepository.FirstOrDefault(filter);
        }

        public bool Update( SMSSendHistroy entity)
        {
            return  SMSSendHistroyRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable< SMSSendHistroy> entities)
        {
            return  SMSSendHistroyRepository.AddRange(entities);
        }
        public bool Remove(int RouteId)
        {
             SMSSendHistroy entity = new  SMSSendHistroy();
            entity =  SMSSendHistroyRepository.FirstOrDefault(e => e.HistoryId == RouteId);
            return  SMSSendHistroyRepository.Remove(entity);
        }

    }
}
