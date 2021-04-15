using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using OEMS.Models;
using System.Linq.Expressions;
using OEMS.Models.Model.Account;
using OEMS.Repository.Repositories.Account;
using OEMS.Repository.Repositories;
using OEMS.Models.Model;

namespace OEMS.Service.Services.Account
{
    public class LedgersService : IService<Ledgers>
    {
        private LedgersRepository LedgersRepository;
        private CommonRepository commonRepository = new CommonRepository();

        public LedgersService()
        {
            LedgersRepository = new LedgersRepository();
        }        
        public bool Add(Ledgers entity)
        {        
          return  LedgersRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<Ledgers> entities)
        {
            return LedgersRepository.AddRange(entities);
        }

        public IEnumerable<Ledgers> Filter(Expression<Func<Ledgers, bool>> filter, Func<IQueryable<Ledgers>, IOrderedQueryable<Ledgers>> orderBy = null, string[] Children = null)
        {
            return LedgersRepository.Filter(filter,orderBy,Children);
        }

        
        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<Ledgers, bool>> filter, Func<IQueryable<Ledgers>, IOrderedQueryable<Ledgers>> orderBy = null)
        {
            return LedgersRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public Ledgers Get(long id)
        {
            return LedgersRepository.Get(id);
        }

        public IEnumerable<Ledgers> GetAll()
        {
            return LedgersRepository.GetAll();
        }      
        public IEnumerable<Ledgers> GetByPage(int pageno, int pagesize)
        {
            return LedgersRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return LedgersRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return LedgersRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return LedgersRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            Ledgers entity = new Ledgers();
            entity = LedgersRepository.SingleOrDefault(e=>e.LedgerId == id);
            return LedgersRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<Ledgers> entities = new List<Ledgers>();
            entities = LedgersRepository.Filter(x => ids.Contains(Convert.ToInt64(x.LedgerId))).ToList();

            return LedgersRepository.RemoveRange(entities);
        }

        public Ledgers SingleOrDefault(Expression<Func<Ledgers, bool>> filter)
        {
            return LedgersRepository.SingleOrDefault(filter);
        }


        public List<DropDownConfig> SearchGroup(string SrchText, int ParentID)
        {

            var dt = commonRepository.GetBySpWithParam("GetForTypeheadForLedger", new object[] { SrchText, ParentID });

            return CommonRepository.ConvertDataTable<DropDownConfig>(dt);
        }

        //public bool UpdatePairSubjectID(Ledgers entity)
        //{
        //    Ledgers _entity = LedgersRepository.SingleOrDefault(e => e.SubID == entity.SubID); 
        //    _entity.PairSubjectID = entity.PairSubjectID;
        //    _entity.SetDate();
        //    _entity.UpdateBy = entity.UpdateBy;

        //    return LedgersRepository.Update(_entity);             
        //}

        //public bool UpdateDeleteStatus(Ledgers entity)
        //{
        //    Ledgers _entity = LedgersRepository.SingleOrDefault(e => e.SubID == entity.SubID);
        //    _entity.IsDeleted = entity.IsDeleted;
        //    _entity.SetDate();
        //    _entity.UpdateBy = entity.UpdateBy;

        //    return LedgersRepository.Update(_entity);
        //}
        public bool Update(Ledgers entity)
        { 
            return LedgersRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<Ledgers> entities)
        {
            return LedgersRepository.UpdateRange(entities);
        }

        public List<DropDownConfig> SearchLedger(string SrchText,int type ,string acctype, int paymode)
        {
            var dt = commonRepository.GetBySpWithParam("GetTypeheadForLedger", new object[] {SrchText,type,acctype,paymode});
            return CommonRepository.ConvertDataTable<DropDownConfig>(dt);
        }

        
    }
}
