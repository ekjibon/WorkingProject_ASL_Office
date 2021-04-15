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
    public class RootGroupService : IService<RootGroup>
    {
        private RootGroupRepository RootGroupRepository;

        public RootGroupService()
        {
            RootGroupRepository = new RootGroupRepository();
        }        
        public bool Add(RootGroup entity)
        {        
          return  RootGroupRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<RootGroup> entities)
        {
            return RootGroupRepository.AddRange(entities);
        }

        public IEnumerable<RootGroup> Filter(Expression<Func<RootGroup, bool>> filter, Func<IQueryable<RootGroup>, IOrderedQueryable<RootGroup>> orderBy = null, string[] Children = null)
        {
            return RootGroupRepository.Filter(filter,orderBy,Children);
        }

        
        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<RootGroup, bool>> filter, Func<IQueryable<RootGroup>, IOrderedQueryable<RootGroup>> orderBy = null)
        {
            return RootGroupRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public RootGroup Get(long id)
        {
            return RootGroupRepository.Get(id);
        }

        public IEnumerable<RootGroup> GetAll()
        {
            return RootGroupRepository.GetAll();
        }      
        public IEnumerable<RootGroup> GetByPage(int pageno, int pagesize)
        {
            return RootGroupRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return RootGroupRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return RootGroupRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return RootGroupRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            RootGroup entity = new RootGroup();
            entity = RootGroupRepository.SingleOrDefault(e=>e.Id==id);
            return RootGroupRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<RootGroup> entities = new List<RootGroup>();
            entities = RootGroupRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return RootGroupRepository.RemoveRange(entities);
        }

        public RootGroup SingleOrDefault(Expression<Func<RootGroup, bool>> filter)
        {
            return RootGroupRepository.SingleOrDefault(filter);
        }

        //public bool UpdatePairSubjectID(Groups entity)
        //{
        //    Groups _entity = GroupsRepository.SingleOrDefault(e => e.SubID == entity.SubID); 
        //    _entity.PairSubjectID = entity.PairSubjectID;
        //    _entity.SetDate();
        //    _entity.UpdateBy = entity.UpdateBy;

        //    return GroupsRepository.Update(_entity);             
        //}

        //public bool UpdateDeleteStatus(Groups entity)
        //{
        //    Groups _entity = GroupsRepository.SingleOrDefault(e => e.SubID == entity.SubID);
        //    _entity.IsDeleted = entity.IsDeleted;
        //    _entity.SetDate();
        //    _entity.UpdateBy = entity.UpdateBy;

        //    return GroupsRepository.Update(_entity);
        //}
        public bool Update(RootGroup entity)
        { 
            return RootGroupRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<RootGroup> entities)
        {
            return RootGroupRepository.UpdateRange(entities);
        }
    }
}
