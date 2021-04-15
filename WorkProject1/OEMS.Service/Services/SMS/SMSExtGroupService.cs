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
    public class SMSExtGroupService : IService<SMSExtGroup>
    {
        private SMSExtGroupRepository SMSExtGroupRepository;

        public SMSExtGroupService()
        {
            SMSExtGroupRepository = new SMSExtGroupRepository();
        }
        public bool Add(SMSExtGroup entity)
        {
            return SMSExtGroupRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<SMSExtGroup> entities)
        {
            return SMSExtGroupRepository.AddRange(entities);
        }

        public IEnumerable<SMSExtGroup> Filter(Expression<Func<SMSExtGroup, bool>> filter, Func<IQueryable<SMSExtGroup>, IOrderedQueryable<SMSExtGroup>> orderBy = null, string[] Children = null)
        {
            return SMSExtGroupRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<SMSExtGroup, bool>> filter, Func<IQueryable<SMSExtGroup>, IOrderedQueryable<SMSExtGroup>> orderBy = null)
        {
            return SMSExtGroupRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public SMSExtGroup Get(long id)
        {
            return SMSExtGroupRepository.Get(id);
        }

        public IEnumerable<SMSExtGroup> GetAll()
        {
            return SMSExtGroupRepository.GetAll();
        }

        public IEnumerable<SMSExtGroup> GetByPage(int pageno, int pagesize)
        {
            return SMSExtGroupRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return SMSExtGroupRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return SMSExtGroupRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return SMSExtGroupRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            SMSExtGroup entity = new SMSExtGroup();
            entity = SMSExtGroupRepository.SingleOrDefault(e => e.GroupId == id);
            entity.IsDeleted = true;
            entity.SetDate();
            return SMSExtGroupRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<SMSExtGroup> entities = new List<SMSExtGroup>();
            entities = SMSExtGroupRepository.Filter(x => ids.Contains(Convert.ToInt64(x.GroupId))).ToList();

            return SMSExtGroupRepository.RemoveRange(entities);
        }

        public SMSExtGroup SingleOrDefault(Expression<Func<SMSExtGroup, bool>> filter)
        {
            return SMSExtGroupRepository.SingleOrDefault(filter);
        }

        public bool Update(SMSExtGroup entity)
        {
            return SMSExtGroupRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<SMSExtGroup> entities)
        {
            return SMSExtGroupRepository.AddRange(entities);
        }
        public bool Remove(int RouteId)
        {
            SMSExtGroup entity = new SMSExtGroup();
            entity = SMSExtGroupRepository.SingleOrDefault(e => e.GroupId == RouteId);
            return SMSExtGroupRepository.Remove(entity);
        }

        public int GetSMSExtGroupId(long RouteId)
        {

            int SMSExtGroupID = SMSExtGroupRepository.SingleOrDefault(e => e.GroupId == RouteId).GroupId;
            return SMSExtGroupID;
        }



    }
}
