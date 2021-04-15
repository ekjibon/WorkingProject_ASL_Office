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
    public class ScheduleSMSConfigService : IService<ScheduleSMSConfig>
    {
        private ScheduleSMSConfigRepository ScheduleSMSConfigRepository;

        public ScheduleSMSConfigService()
        {
            ScheduleSMSConfigRepository = new ScheduleSMSConfigRepository();
        }
        public bool Add(ScheduleSMSConfig entity)
        {
            return  ScheduleSMSConfigRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<ScheduleSMSConfig> entities)
        {
            return ScheduleSMSConfigRepository.AddRange(entities);
        }

        public IEnumerable<ScheduleSMSConfig> Filter(Expression<Func<ScheduleSMSConfig, bool>> filter, Func<IQueryable<ScheduleSMSConfig>, IOrderedQueryable<ScheduleSMSConfig>> orderBy = null, string[] Children = null)
        {
            return ScheduleSMSConfigRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<ScheduleSMSConfig, bool>> filter, Func<IQueryable<ScheduleSMSConfig>, IOrderedQueryable<ScheduleSMSConfig>> orderBy = null)
        {
            return ScheduleSMSConfigRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public ScheduleSMSConfig Get(long id)
        {
            return ScheduleSMSConfigRepository.Get(id);
        }

        public IEnumerable<ScheduleSMSConfig> GetAll()
        {
            return ScheduleSMSConfigRepository.GetAll();
        }

        public IEnumerable<ScheduleSMSConfig> GetByPage(int pageno, int pagesize)
        {
            return ScheduleSMSConfigRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return ScheduleSMSConfigRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return ScheduleSMSConfigRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return ScheduleSMSConfigRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            ScheduleSMSConfig entity = new ScheduleSMSConfig();
            entity = ScheduleSMSConfigRepository.SingleOrDefault(e=>e.ConfigId==id);
            entity.IsDeleted = true;
            entity.SetDate();
            return ScheduleSMSConfigRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<ScheduleSMSConfig> entities = new List<ScheduleSMSConfig>();
            entities = ScheduleSMSConfigRepository.Filter(x => ids.Contains(Convert.ToInt64(x.ConfigId))).ToList();

            return ScheduleSMSConfigRepository.RemoveRange(entities);
        }

        public ScheduleSMSConfig SingleOrDefault(Expression<Func<ScheduleSMSConfig, bool>> filter)
        {
            return ScheduleSMSConfigRepository.SingleOrDefault(filter);
        }

        public bool Update(ScheduleSMSConfig entity)
        { 
            return ScheduleSMSConfigRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<ScheduleSMSConfig> entities)
        {
            return ScheduleSMSConfigRepository.AddRange(entities);
        }
        public bool Remove(int RouteId)
        {
            ScheduleSMSConfig entity = new ScheduleSMSConfig();
            entity = ScheduleSMSConfigRepository.SingleOrDefault(e => e.ConfigId == RouteId);
            return ScheduleSMSConfigRepository.Remove(entity);
        }

        public int GetScheduleSMSConfigId(long RouteId)
        {
            int ScheduleSMSConfigID = ScheduleSMSConfigRepository.SingleOrDefault(e => e.ConfigId == RouteId).ConfigId;
            return ScheduleSMSConfigID;
        }

       

    }
}
