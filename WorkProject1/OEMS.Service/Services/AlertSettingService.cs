using OEMS.Models;
using OEMS.Models.Model.Company;
using OEMS.Repository.Repositories;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Service.Services
{
    public class AlertSettingService : IService<AlertSetting>
    {
        AlertSettingRepository alertSettingRepository;
        public AlertSettingService()
        {
            alertSettingRepository = new AlertSettingRepository();
        }

        public bool Add(AlertSetting entity)
        {
            return alertSettingRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<AlertSetting> entities)
        {
            return alertSettingRepository.AddRange(entities);
        }

        public bool Update(AlertSetting entity)
        {
            return alertSettingRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<AlertSetting> entities)
        {
            return alertSettingRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            AlertSetting entity = new AlertSetting();
            entity = alertSettingRepository.SingleOrDefault(e => e.Id == id);
            return alertSettingRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<AlertSetting> entities = new List<AlertSetting>();
            entities = alertSettingRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return alertSettingRepository.RemoveRange(entities);
        }

        public AlertSetting Get(long id)
        {
            return alertSettingRepository.Get(id);
        }

        public AlertSetting SingleOrDefault(Expression<Func<AlertSetting, bool>> filter)
        {
            return alertSettingRepository.SingleOrDefault(filter);
        }


        public IEnumerable<AlertSetting> GetAll()
        {
            return alertSettingRepository.GetAll();
        }

        public IEnumerable<AlertSetting> Filter(Expression<Func<AlertSetting, bool>> filter, Func<IQueryable<AlertSetting>, IOrderedQueryable<AlertSetting>> orderBy = null, string[] Children = null)
        {
            return alertSettingRepository.Filter(filter, orderBy);
        }

        public IEnumerable<AlertSetting> GetByPage(int pageno, int pagesize)
        {
            return alertSettingRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return alertSettingRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return alertSettingRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return alertSettingRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<AlertSetting, bool>> filter, Func<IQueryable<AlertSetting>, IOrderedQueryable<AlertSetting>> orderBy = null)
        {
            return alertSettingRepository.Filter(pageno, pagesize, filter, orderBy);
        }
    }
}
