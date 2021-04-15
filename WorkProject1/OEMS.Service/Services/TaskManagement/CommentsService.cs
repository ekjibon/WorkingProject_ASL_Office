using OEMS.Models;
using OEMS.Models.Model.Company;
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
    public class CommentsService : IService<Comments>
    {
        CommentsRepository commentsRepository;
        public CommentsService()
        {
            commentsRepository = new CommentsRepository();
        }

        public bool Add(Comments entity)
        {
            return commentsRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<Comments> entities)
        {
            return commentsRepository.AddRange(entities);
        }

        public bool Update(Comments entity)
        {
            return commentsRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<Comments> entities)
        {
            return commentsRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            Comments entity = new Comments();
            entity = commentsRepository.SingleOrDefault(e => e.Id == id);
            return commentsRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<Comments> entities = new List<Comments>();
            entities = commentsRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return commentsRepository.RemoveRange(entities);
        }

        public Comments Get(long id)
        {
            return commentsRepository.Get(id);
        }

        public Comments SingleOrDefault(Expression<Func<Comments, bool>> filter)
        {
            return commentsRepository.SingleOrDefault(filter);
        }


        public IEnumerable<Comments> GetAll()
        {
            return commentsRepository.GetAll();
        }

        public IEnumerable<Comments> Filter(Expression<Func<Comments, bool>> filter, Func<IQueryable<Comments>, IOrderedQueryable<Comments>> orderBy = null, string[] Children = null)
        {
            return commentsRepository.Filter(filter, orderBy);
        }

        public IEnumerable<Comments> GetByPage(int pageno, int pagesize)
        {
            return commentsRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return commentsRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return commentsRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return commentsRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<Comments, bool>> filter, Func<IQueryable<Comments>, IOrderedQueryable<Comments>> orderBy = null)
        {
            return commentsRepository.Filter(pageno, pagesize, filter, orderBy);
        }
    }
}
