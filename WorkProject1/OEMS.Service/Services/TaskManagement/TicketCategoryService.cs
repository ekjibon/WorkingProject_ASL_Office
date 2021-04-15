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
    public class TicketCategoryService : IService<TicketCategory>
    {
        private TicketCategoryRepository ticketCategoryRepository;

        public TicketCategoryService()
        {
            ticketCategoryRepository = new TicketCategoryRepository();
        }
        public bool Add(TicketCategory entity)
        {
        // entity.Id =   ( Convert.ToInt32( SessionRepository.GetAll().ToList().Select(e => e.Id).Max()) + 1).ToString();
          return  ticketCategoryRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<TicketCategory> entities)
        {
            return ticketCategoryRepository.AddRange(entities);
        }

        public bool Update(TicketCategory entity)
        {
            return ticketCategoryRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<TicketCategory> entities)
        {
            return ticketCategoryRepository.AddRange(entities);
        }

        public IEnumerable<TicketCategory> Filter(Expression<Func<TicketCategory, bool>> filter, Func<IQueryable<TicketCategory>, IOrderedQueryable<TicketCategory>> orderBy = null, string[] Children = null)
        {
            return ticketCategoryRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<TicketCategory, bool>> filter, Func<IQueryable<TicketCategory>, IOrderedQueryable<TicketCategory>> orderBy = null)
        {
            return ticketCategoryRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public TicketCategory Get(long id)
        {
            return ticketCategoryRepository.Get(id);
        }

        public IEnumerable<TicketCategory> GetAll()
        {
            return ticketCategoryRepository.GetAll();
        }

        public IEnumerable<TicketCategory> GetByPage(int pageno, int pagesize)
        {
            return ticketCategoryRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return ticketCategoryRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return ticketCategoryRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return ticketCategoryRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            TicketCategory entity = new TicketCategory();
            entity = ticketCategoryRepository.SingleOrDefault(e=>e.Id==id);
            return ticketCategoryRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<TicketCategory> entities = new List<TicketCategory>();
            entities = ticketCategoryRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return ticketCategoryRepository.RemoveRange(entities);
        }

        public TicketCategory SingleOrDefault(Expression<Func<TicketCategory, bool>> filter)
        {
            return ticketCategoryRepository.SingleOrDefault(filter);
        }


    }
}
