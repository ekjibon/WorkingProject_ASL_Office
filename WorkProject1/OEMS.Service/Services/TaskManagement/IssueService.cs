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
    public class IssueService : IService<Issue>
    {
        private IssueRepository issueRepository;

        public IssueService()
        {
            issueRepository = new IssueRepository();
        }
        public bool Add(Issue entity)
        {
            return issueRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<Issue> entities)
        {
            return issueRepository.AddRange(entities);
        }

        public bool Update(Issue entity)
        {
            //Project _entity = projectRepository.SingleOrDefault(e => e.Id == entity.Id);
            return issueRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<Issue> entities)
        {
            return issueRepository.AddRange(entities);
        }

        public IEnumerable<Issue> Filter(Expression<Func<Issue, bool>> filter, Func<IQueryable<Issue>, IOrderedQueryable<Issue>> orderBy = null, string[] Children = null)
        {
            return issueRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<Issue, bool>> filter, Func<IQueryable<Issue>, IOrderedQueryable<Issue>> orderBy = null)
        {
            return issueRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public Issue Get(long id)
        {
            return issueRepository.Get(id);
        }

        public IEnumerable<Issue> GetAll()
        {
            return issueRepository.GetAll();
        }



        public IEnumerable<Issue> GetByPage(int pageno, int pagesize)
        {
            return issueRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return issueRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return issueRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return issueRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            Issue entity = new Issue();
            entity = issueRepository.SingleOrDefault(e => e.Id == id);
            return issueRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<Issue> entities = new List<Issue>();
            entities = issueRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return issueRepository.RemoveRange(entities);
        }

        public Issue SingleOrDefault(Expression<Func<Issue, bool>> filter)
        {
            return issueRepository.SingleOrDefault(filter);
        }



    }
}
