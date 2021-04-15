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
    public class TransactionDetailService : IService<TransactionDetail>
    {
        private TransactionDetailRepository TransactionDetailRepository;

        public TransactionDetailService()
        {
            TransactionDetailRepository = new TransactionDetailRepository();
        }        
        public bool Add(TransactionDetail entity)
        {        
          return  TransactionDetailRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<TransactionDetail> entities)
        {
            return TransactionDetailRepository.AddRange(entities);
        }

        public IEnumerable<TransactionDetail> Filter(Expression<Func<TransactionDetail, bool>> filter, Func<IQueryable<TransactionDetail>, IOrderedQueryable<TransactionDetail>> orderBy = null, string[] Children = null)
        {
            return TransactionDetailRepository.Filter(filter,orderBy,Children);
        }

        
        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<TransactionDetail, bool>> filter, Func<IQueryable<TransactionDetail>, IOrderedQueryable<TransactionDetail>> orderBy = null)
        {
            return TransactionDetailRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public TransactionDetail Get(long id)
        {
            return TransactionDetailRepository.Get(id);
        }

        public IEnumerable<TransactionDetail> GetAll()
        {
            return TransactionDetailRepository.GetAll();
        }      
        public IEnumerable<TransactionDetail> GetByPage(int pageno, int pagesize)
        {
            return TransactionDetailRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return TransactionDetailRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return TransactionDetailRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return TransactionDetailRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            TransactionDetail entity = new TransactionDetail();
            entity = TransactionDetailRepository.SingleOrDefault(e=>e.Id==id);
            return TransactionDetailRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<TransactionDetail> entities = new List<TransactionDetail>();
            entities = TransactionDetailRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return TransactionDetailRepository.RemoveRange(entities);
        }

        public TransactionDetail SingleOrDefault(Expression<Func<TransactionDetail, bool>> filter)
        {
            return TransactionDetailRepository.SingleOrDefault(filter);
        }

        //public bool UpdatePairSubjectID(TransactionDetail entity)
        //{
        //    TransactionDetail _entity = TransactionDetailRepository.SingleOrDefault(e => e.SubID == entity.SubID); 
        //    _entity.PairSubjectID = entity.PairSubjectID;
        //    _entity.SetDate();
        //    _entity.UpdateBy = entity.UpdateBy;

        //    return TransactionDetailRepository.Update(_entity);             
        //}

        //public bool UpdateDeleteStatus(TransactionDetail entity)
        //{
        //    TransactionDetail _entity = TransactionDetailRepository.SingleOrDefault(e => e.SubID == entity.SubID);
        //    _entity.IsDeleted = entity.IsDeleted;
        //    _entity.SetDate();
        //    _entity.UpdateBy = entity.UpdateBy;

        //    return TransactionDetailRepository.Update(_entity);
        //}
        public bool Update(TransactionDetail entity)
        { 
            return TransactionDetailRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<TransactionDetail> entities)
        {
            return TransactionDetailRepository.UpdateRange(entities);
        }
    }
}
