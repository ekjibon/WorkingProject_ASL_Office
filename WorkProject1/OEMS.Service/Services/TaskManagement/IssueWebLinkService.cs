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
using UI.Admin.Models.Task;

namespace OEMS.Service.Services
{
    public class IssueWebLinkService : IService<IssueWebLink>
    {
        private IssueWebLinkRepository issueWebLinkRepository;

        public IssueWebLinkService()
        {
            issueWebLinkRepository = new IssueWebLinkRepository();
        }
        public bool Add(IssueWebLink entity)
        {
            return issueWebLinkRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<IssueWebLink> entities)
        {
            return issueWebLinkRepository.AddRange(entities);
        }

        public bool Update(IssueWebLink entity)
        {
            //Project _entity = projectRepository.SingleOrDefault(e => e.Id == entity.Id);
            return issueWebLinkRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<IssueWebLink> entities)
        {
            return issueWebLinkRepository.AddRange(entities);
        }

        public IEnumerable<IssueWebLink> Filter(Expression<Func<IssueWebLink, bool>> filter, Func<IQueryable<IssueWebLink>, IOrderedQueryable<IssueWebLink>> orderBy = null, string[] Children = null)
        {
            return issueWebLinkRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<IssueWebLink, bool>> filter, Func<IQueryable<IssueWebLink>, IOrderedQueryable<IssueWebLink>> orderBy = null)
        {
            return issueWebLinkRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public IssueWebLink Get(long id)
        {
            return issueWebLinkRepository.Get(id);
        }

        public IEnumerable<IssueWebLink> GetAll()
        {
            return issueWebLinkRepository.GetAll();
        }

        public IEnumerable<IssueWebLink> GetByPage(int pageno, int pagesize)
        {
            return issueWebLinkRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return issueWebLinkRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return issueWebLinkRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return issueWebLinkRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            IssueWebLink entity = new IssueWebLink();
            entity = issueWebLinkRepository.SingleOrDefault(e => e.Id == id);
            return issueWebLinkRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<IssueWebLink> entities = new List<IssueWebLink>();
            entities = issueWebLinkRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return issueWebLinkRepository.RemoveRange(entities);
        }

        public IssueWebLink SingleOrDefault(Expression<Func<IssueWebLink, bool>> filter)
        {
            return issueWebLinkRepository.SingleOrDefault(filter);
        }



    }
}
