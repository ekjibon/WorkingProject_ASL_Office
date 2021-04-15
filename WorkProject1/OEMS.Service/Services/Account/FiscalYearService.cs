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
    public class FiscalYearService : IService<FiscalYear>
    {
        private FiscalYearRepository FiscalYearRepository;

        public FiscalYearService()
        {
            FiscalYearRepository = new FiscalYearRepository();
        }        
        public bool Add(FiscalYear entity)
        {        
          return FiscalYearRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<FiscalYear> entities)
        {
            return FiscalYearRepository.AddRange(entities);
        }

        public IEnumerable<FiscalYear> Filter(Expression<Func<FiscalYear, bool>> filter, Func<IQueryable<FiscalYear>, IOrderedQueryable<FiscalYear>> orderBy = null, string[] Children = null)
        {
            return FiscalYearRepository.Filter(filter,orderBy,Children);
        }

        
        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<FiscalYear, bool>> filter, Func<IQueryable<FiscalYear>, IOrderedQueryable<FiscalYear>> orderBy = null)
        {
            return FiscalYearRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public FiscalYear Get(long id)
        {
            return FiscalYearRepository.Get(id);
        }

        public IEnumerable<FiscalYear> GetAll()
        {
            return FiscalYearRepository.GetAll();
        }      
        public IEnumerable<FiscalYear> GetByPage(int pageno, int pagesize)
        {
            return FiscalYearRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return FiscalYearRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return FiscalYearRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return FiscalYearRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            FiscalYear entity = new FiscalYear();
            entity = FiscalYearRepository.SingleOrDefault(f => f.Id == id);
            entity.IsDeleted = true;
            entity.Status = "D";
            return FiscalYearRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<FiscalYear> entities = new List<FiscalYear>();
            entities = FiscalYearRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return FiscalYearRepository.RemoveRange(entities);
        }

        public FiscalYear SingleOrDefault(Expression<Func<FiscalYear, bool>> filter)
        {
            return FiscalYearRepository.SingleOrDefault(filter);
        }

        //public bool UpdatePairSubjectID(EntryTypes entity)
        //{
        //    EntryTypes _entity = EntryTypesRepository.SingleOrDefault(e => e.SubID == entity.SubID); 
        //    _entity.PairSubjectID = entity.PairSubjectID;
        //    _entity.SetDate();
        //    _entity.UpdateBy = entity.UpdateBy;

        //    return EntryTypesRepository.Update(_entity);             
        //}

        //public bool UpdateDeleteStatus(EntryTypes entity)
        //{
        //    EntryTypes _entity = EntryTypesRepository.SingleOrDefault(e => e.SubID == entity.SubID);
        //    _entity.IsDeleted = entity.IsDeleted;
        //    _entity.SetDate();
        //    _entity.UpdateBy = entity.UpdateBy;

        //    return EntryTypesRepository.Update(_entity);
        //}
        public bool Update(FiscalYear entity)
        { 
            return FiscalYearRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<FiscalYear> entities)
        {
            return FiscalYearRepository.UpdateRange(entities);
        }
       

    }
}
