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
    public class TicketsService : IService<Tickets>
    {
        private TicketsRepository ticketsRepository;

        public TicketsService()
        {
            ticketsRepository = new TicketsRepository();
        }
        public bool Add(Tickets entity)
        {
        // entity.Id =   ( Convert.ToInt32( SessionRepository.GetAll().ToList().Select(e => e.Id).Max()) + 1).ToString();
          return  ticketsRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<Tickets> entities)
        {
            return ticketsRepository.AddRange(entities);
        }

        public bool Update(Tickets entity)
        {
            return ticketsRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<Tickets> entities)
        {
            return ticketsRepository.AddRange(entities);
        }

        public IEnumerable<Tickets> Filter(Expression<Func<Tickets, bool>> filter, Func<IQueryable<Tickets>, IOrderedQueryable<Tickets>> orderBy = null, string[] Children = null)
        {
            return ticketsRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<Tickets, bool>> filter, Func<IQueryable<Tickets>, IOrderedQueryable<Tickets>> orderBy = null)
        {
            return ticketsRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public Tickets Get(long id)
        {
            return ticketsRepository.Get(id);
        }

        public IEnumerable<Tickets> GetAll()
        {
            return ticketsRepository.GetAll();
        }

        public IEnumerable<Tickets> GetByPage(int pageno, int pagesize)
        {
            return ticketsRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return ticketsRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return ticketsRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return ticketsRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            Tickets entity = new Tickets();
            entity = ticketsRepository.SingleOrDefault(e=>e.Id==id);
            return ticketsRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<Tickets> entities = new List<Tickets>();
            entities = ticketsRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return ticketsRepository.RemoveRange(entities);
        }

        public Tickets SingleOrDefault(Expression<Func<Tickets, bool>> filter)
        {
            return ticketsRepository.SingleOrDefault(filter);
        }

        

    }
}
