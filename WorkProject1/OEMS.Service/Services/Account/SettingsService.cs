using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using OEMS.Models;
using System.Linq.Expressions;
using OEMS.Models.Model.Account;
using OEMS.Repository.Repositories.Account;

namespace OEMS.Service.Services.Account
{
    public class AccountSettingsService : IService<AccountSettings>
    {
        private AccountSettingsRepository AccountSettingService;

        public AccountSettingsService()
        {
            AccountSettingService = new AccountSettingsRepository();
        }        
        public bool Add(AccountSettings entity)
        {        
          return  AccountSettingService.Add(entity);
        }

        public bool AddRange(IEnumerable<AccountSettings> entities)
        {
            return AccountSettingService.AddRange(entities);
        }

        public IEnumerable<AccountSettings> Filter(Expression<Func<AccountSettings, bool>> filter, Func<IQueryable<AccountSettings>, IOrderedQueryable<AccountSettings>> orderBy = null, string[] Children = null)
        {
            return AccountSettingService.Filter(filter,orderBy,Children);
        }

        
        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<AccountSettings, bool>> filter, Func<IQueryable<AccountSettings>, IOrderedQueryable<AccountSettings>> orderBy = null)
        {
            return AccountSettingService.Filter(pageno,pagesize,filter,orderBy);
        }

        public AccountSettings Get(long id)
        {
            return AccountSettingService.Get(id);
        }

        public IEnumerable<AccountSettings> GetAll()
        {
            return AccountSettingService.GetAll();
        }      
        public IEnumerable<AccountSettings> GetByPage(int pageno, int pagesize)
        {
            return AccountSettingService.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return AccountSettingService.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return AccountSettingService.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return AccountSettingService.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            AccountSettings entity = new AccountSettings();
            entity = AccountSettingService.SingleOrDefault(e=>e.SettingId == id);
            return AccountSettingService.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<AccountSettings> entities = new List<AccountSettings>();
            entities = AccountSettingService.Filter(x => ids.Contains(Convert.ToInt64(x.SettingId))).ToList();

            return AccountSettingService.RemoveRange(entities);
        }

        public AccountSettings SingleOrDefault(Expression<Func<AccountSettings, bool>> filter)
        {
            return AccountSettingService.SingleOrDefault(filter);
        }

        //public bool UpdatePairSubjectID(Settings entity)
        //{
        //    Settings _entity = SettingsRepository.SingleOrDefault(e => e.SubID == entity.SubID); 
        //    _entity.PairSubjectID = entity.PairSubjectID;
        //    _entity.SetDate();
        //    _entity.UpdateBy = entity.UpdateBy;

        //    return SettingsRepository.Update(_entity);             
        //}

        //public bool UpdateDeleteStatus(Settings entity)
        //{
        //    Settings _entity = SettingsRepository.SingleOrDefault(e => e.SubID == entity.SubID);
        //    _entity.IsDeleted = entity.IsDeleted;
        //    _entity.SetDate();
        //    _entity.UpdateBy = entity.UpdateBy;

        //    return SettingsRepository.Update(_entity);
        //}
        public bool Update(AccountSettings entity)
        { 
            return AccountSettingService.Update(entity);
        }

        public bool UpdateRange(IEnumerable<AccountSettings> entities)
        {
            return AccountSettingService.UpdateRange(entities);
        }
        public bool Remove(string Name)
        {
            AccountSettings entity = new AccountSettings();
            entity = AccountSettingService.SingleOrDefault(e => e.Name == Name);
            return AccountSettingService.Remove(entity);
        }

        public int GetSettingsId(string Email)
        {
            int SettingsID = AccountSettingService.SingleOrDefault(e => e.Email == Email).SettingId;
            return SettingsID;
        }

    }
}
