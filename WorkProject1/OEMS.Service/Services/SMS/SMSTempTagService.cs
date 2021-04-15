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
    public class SMSTempTagService : IService<SMSTempTag>
    {
        private SMSTempTagRepository SMSTempTagRepository;

        public SMSTempTagService()
        {
            SMSTempTagRepository = new SMSTempTagRepository();
        }
        public bool Add(SMSTempTag entity)
        {
            return SMSTempTagRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<SMSTempTag> entities)
        {
            return SMSTempTagRepository.AddRange(entities);
        }

        public IEnumerable<SMSTempTag> Filter(Expression<Func<SMSTempTag, bool>> filter, Func<IQueryable<SMSTempTag>, IOrderedQueryable<SMSTempTag>> orderBy = null, string[] Children = null)
        {
            return SMSTempTagRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<SMSTempTag, bool>> filter, Func<IQueryable<SMSTempTag>, IOrderedQueryable<SMSTempTag>> orderBy = null)
        {
            return SMSTempTagRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public SMSTempTag Get(long id)
        {
            return SMSTempTagRepository.Get(id);
        }

        public IEnumerable<SMSTempTag> GetAll()
        {
            return SMSTempTagRepository.GetAll();
        }

        public IEnumerable<SMSTempTag> GetByPage(int pageno, int pagesize)
        {
            return SMSTempTagRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return SMSTempTagRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return SMSTempTagRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return SMSTempTagRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            SMSTempTag entity = new SMSTempTag();
            entity = SMSTempTagRepository.SingleOrDefault(e => e.TagId == id);
            entity.IsDeleted = true;
            entity.SetDate();
            return SMSTempTagRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<SMSTempTag> entities = new List<SMSTempTag>();
            entities = SMSTempTagRepository.Filter(x => ids.Contains(Convert.ToInt64(x.TagId))).ToList();

            return SMSTempTagRepository.RemoveRange(entities);
        }

        public SMSTempTag SingleOrDefault(Expression<Func<SMSTempTag, bool>> filter)
        {
            return SMSTempTagRepository.SingleOrDefault(filter);
        }

        public bool Update(SMSTempTag entity)
        {
            return SMSTempTagRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<SMSTempTag> entities)
        {
            return SMSTempTagRepository.AddRange(entities);
        }
        public bool Remove(int RouteId)
        {
            SMSTempTag entity = new SMSTempTag();
            entity = SMSTempTagRepository.SingleOrDefault(e => e.TagId == RouteId);
            return SMSTempTagRepository.Remove(entity);
        }

        public int GetSMSTempTagId(long RouteId)
        {

            int SMSTempTagID = SMSTempTagRepository.SingleOrDefault(e => e.TagId == RouteId).TagId;
            return SMSTempTagID;
        }


    }
}
