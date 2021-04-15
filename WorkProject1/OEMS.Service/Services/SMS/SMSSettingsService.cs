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
    public class SMSSettingsService : IService<SMSSettings>
    {
        private SMSSettingsRepository SMSSettingsRepository;

        public SMSSettingsService()
        {
            SMSSettingsRepository = new SMSSettingsRepository();
        }
        public bool Add(SMSSettings entity)
        {
            return  SMSSettingsRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<SMSSettings> entities)
        {
            return SMSSettingsRepository.AddRange(entities);
        }

        public IEnumerable<SMSSettings> Filter(Expression<Func<SMSSettings, bool>> filter, Func<IQueryable<SMSSettings>, IOrderedQueryable<SMSSettings>> orderBy = null, string[] Children = null)
        {
            return SMSSettingsRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<SMSSettings, bool>> filter, Func<IQueryable<SMSSettings>, IOrderedQueryable<SMSSettings>> orderBy = null)
        {
            return SMSSettingsRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public SMSSettings Get(long id)
        {
            return SMSSettingsRepository.Get(id);
        }

        public IEnumerable<SMSSettings> GetAll()
        {
            return SMSSettingsRepository.GetAll();
        }

        public IEnumerable<SMSSettings> GetByPage(int pageno, int pagesize)
        {
            return SMSSettingsRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return SMSSettingsRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return SMSSettingsRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return SMSSettingsRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            SMSSettings entity = new SMSSettings();
            entity = SMSSettingsRepository.SingleOrDefault(e=>e.SettingsId==id);
            entity.IsDeleted = true;
            entity.SetDate();
            return SMSSettingsRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<SMSSettings> entities = new List<SMSSettings>();
            entities = SMSSettingsRepository.Filter(x => ids.Contains(Convert.ToInt64(x.SettingsId))).ToList();

            return SMSSettingsRepository.RemoveRange(entities);
        }

        public SMSSettings SingleOrDefault(Expression<Func<SMSSettings, bool>> filter)
        {
            return SMSSettingsRepository.SingleOrDefault(filter);
        }

        public bool Update(SMSSettings entity)
        { 
            return SMSSettingsRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<SMSSettings> entities)
        {
            return SMSSettingsRepository.AddRange(entities);
        }
        public bool Remove(int RouteId)
        {
            SMSSettings entity = new SMSSettings();
            entity = SMSSettingsRepository.SingleOrDefault(e => e.SettingsId == RouteId);
            return SMSSettingsRepository.Remove(entity);
        }

        public int GetSMSSettingsId(long RouteId)
        {

            int SMSSettingsID = SMSSettingsRepository.SingleOrDefault(e => e.SettingsId == RouteId).SettingsId;
            return SMSSettingsID;
        }

       

    }
}
