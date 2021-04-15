using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using OEMS.Models;
using OEMS.Models.Model.Attendance;
using System.Linq.Expressions;
using OEMS.Repository.Repositories;

namespace OEMS.Service.Services
{
    public class LeaveTypesService : IService<LeaveTypes>
    {
        private LeaveTypesRepository LeaveTypesRepository;

        public LeaveTypesService()
        {
            LeaveTypesRepository = new LeaveTypesRepository();
        }
        public bool Add(LeaveTypes entity)
        {
        // entity.Id =   ( Convert.ToInt32( LeaveTypesRepository.GetAll().ToList().Select(e => e.Id).Max()) + 1).ToString();
          return  LeaveTypesRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<LeaveTypes> entities)
        {
            return LeaveTypesRepository.AddRange(entities);
        }

        public IEnumerable<LeaveTypes> Filter(Expression<Func<LeaveTypes, bool>> filter, Func<IQueryable<LeaveTypes>, IOrderedQueryable<LeaveTypes>> orderBy = null, string[] Children = null)
        {
            return LeaveTypesRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<LeaveTypes, bool>> filter, Func<IQueryable<LeaveTypes>, IOrderedQueryable<LeaveTypes>> orderBy = null)
        {
            return LeaveTypesRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public LeaveTypes Get(long id)
        {
            return LeaveTypesRepository.Get(id);
        }

        public IEnumerable<LeaveTypes> GetAll()
        {
            return LeaveTypesRepository.GetAll();
        }

        public IEnumerable<LeaveTypes> GetByPage(int pageno, int pagesize)
        {
            return LeaveTypesRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return LeaveTypesRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return LeaveTypesRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return LeaveTypesRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            LeaveTypes entity = new LeaveTypes();
            entity = LeaveTypesRepository.SingleOrDefault(e=>e.LeaveId == id);
            entity.IsDeleted = true;
            entity.SetDate();
            return LeaveTypesRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<LeaveTypes> entities = new List<LeaveTypes>();
            entities = LeaveTypesRepository.Filter(x => ids.Contains(Convert.ToInt64(x.LeaveId))).ToList();

            return LeaveTypesRepository.RemoveRange(entities);
        }

        public LeaveTypes SingleOrDefault(Expression<Func<LeaveTypes, bool>> filter)
        {
            return LeaveTypesRepository.SingleOrDefault(filter);
        }

        public bool Update(LeaveTypes entity)
        { 
            return LeaveTypesRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<LeaveTypes> entities)
        {
            return LeaveTypesRepository.AddRange(entities);
        }
        public bool Remove(string LeaveId)
        {
            LeaveTypes entity = new LeaveTypes();
            entity = LeaveTypesRepository.SingleOrDefault(e => e.Remarks == LeaveId);
            return LeaveTypesRepository.Remove(entity);
        }

        public int GetLeaveTypesId(string LeaveId)
        {

            int LeaveTypesID = LeaveTypesRepository.SingleOrDefault(e => e.Remarks == LeaveId).LeaveId;
            return LeaveTypesID;
        }

    }
}
