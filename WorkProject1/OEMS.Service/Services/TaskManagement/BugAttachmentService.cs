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
using UI.Admin.Models.Task;

namespace OEMS.Service.Services
{
    public class BugAttachmentService : IService<BugAttachment>
    {
        private BugAttachmentRepository bugAttachmentRepository;

        public BugAttachmentService()
        {
            bugAttachmentRepository = new BugAttachmentRepository();
        }
        public bool Add(BugAttachment entity)
        {
        // entity.Id =   ( Convert.ToInt32( SessionRepository.GetAll().ToList().Select(e => e.Id).Max()) + 1).ToString();
          return  bugAttachmentRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<BugAttachment> entities)
        {
            return bugAttachmentRepository.AddRange(entities);
        }

        public bool Update(BugAttachment entity)
        {
            //BugAttachment _entity = bugAttachmentRepository.SingleOrDefault(e => e.Id == entity.Id);
            //    return bugAttachmentRepository.Update(_entity);
            return bugAttachmentRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<BugAttachment> entities)
        {
            return bugAttachmentRepository.AddRange(entities);
        }

        public IEnumerable<BugAttachment> Filter(Expression<Func<BugAttachment, bool>> filter, Func<IQueryable<BugAttachment>, IOrderedQueryable<BugAttachment>> orderBy = null, string[] Children = null)
        {
            return bugAttachmentRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<BugAttachment, bool>> filter, Func<IQueryable<BugAttachment>, IOrderedQueryable<BugAttachment>> orderBy = null)
        {
            return bugAttachmentRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public BugAttachment Get(long id)
        {
            return bugAttachmentRepository.Get(id);
        }

        public IEnumerable<BugAttachment> GetAll()
        {
            return bugAttachmentRepository.GetAll();
        }

        public IEnumerable<BugAttachment> GetByPage(int pageno, int pagesize)
        {
            return bugAttachmentRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return bugAttachmentRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return bugAttachmentRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return bugAttachmentRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            BugAttachment entity = new BugAttachment();
            entity = bugAttachmentRepository.SingleOrDefault(e=>e.Id==id);
            return bugAttachmentRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<BugAttachment> entities = new List<BugAttachment>();
            entities = bugAttachmentRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return bugAttachmentRepository.RemoveRange(entities);
        }

        public BugAttachment SingleOrDefault(Expression<Func<BugAttachment, bool>> filter)
        {
            return bugAttachmentRepository.SingleOrDefault(filter);
        }

        

    }
}
