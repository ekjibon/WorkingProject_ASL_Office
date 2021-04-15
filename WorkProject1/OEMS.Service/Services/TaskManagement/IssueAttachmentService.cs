using OEMS.Models;
using OEMS.Models.Model.TaskManagement;
using OEMS.Repository.Repositories;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Service.Services
{
    public class IssueAttachmentService : IService<IssueAttachment>
    {
        private IssueAttachmentRepository issueAttachmentRepository;

        public IssueAttachmentService()
        {
            issueAttachmentRepository = new IssueAttachmentRepository();
        }
        public bool Add(IssueAttachment entity)
        {
            return issueAttachmentRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<IssueAttachment> entities)
        {
            return issueAttachmentRepository.AddRange(entities);
        }

        public bool Update(IssueAttachment entity)
        {
            //Project _entity = projectRepository.SingleOrDefault(e => e.Id == entity.Id);
            return issueAttachmentRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<IssueAttachment> entities)
        {
            return issueAttachmentRepository.AddRange(entities);
        }

        public IEnumerable<IssueAttachment> Filter(Expression<Func<IssueAttachment, bool>> filter, Func<IQueryable<IssueAttachment>, IOrderedQueryable<IssueAttachment>> orderBy = null, string[] Children = null)
        {
            return issueAttachmentRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<IssueAttachment, bool>> filter, Func<IQueryable<IssueAttachment>, IOrderedQueryable<IssueAttachment>> orderBy = null)
        {
            return issueAttachmentRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public IssueAttachment Get(long id)
        {
            return issueAttachmentRepository.Get(id);
        }

        public IEnumerable<IssueAttachment> GetAll()
        {
            return issueAttachmentRepository.GetAll();
        }

        public IEnumerable<IssueAttachment> GetByPage(int pageno, int pagesize)
        {
            return issueAttachmentRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return issueAttachmentRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return issueAttachmentRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return issueAttachmentRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            IssueAttachment entity = new IssueAttachment();
            entity = issueAttachmentRepository.SingleOrDefault(e => e.AttachmentId == id);
            return issueAttachmentRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<IssueAttachment> entities = new List<IssueAttachment>();
            entities = issueAttachmentRepository.Filter(x => ids.Contains(Convert.ToInt64(x.AttachmentId))).ToList();

            return issueAttachmentRepository.RemoveRange(entities);
        }

        public IssueAttachment SingleOrDefault(Expression<Func<IssueAttachment, bool>> filter)
        {
            return issueAttachmentRepository.SingleOrDefault(filter);
        }



    }
}
