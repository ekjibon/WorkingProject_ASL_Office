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
    public class TicketUsersService : IService<TicketUsers>
    {
        private TicketUsersRepository ticketUsersRepository;

        public TicketUsersService()
        {
            ticketUsersRepository = new TicketUsersRepository();
        }
        public bool Add(TicketUsers entity)
        {
        // entity.Id =   ( Convert.ToInt32( SessionRepository.GetAll().ToList().Select(e => e.Id).Max()) + 1).ToString();
          return  ticketUsersRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<TicketUsers> entities)
        {
            return ticketUsersRepository.AddRange(entities);
        }

        public bool Update(TicketUsers entity)
        {
            return ticketUsersRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<TicketUsers> entities)
        {
            return ticketUsersRepository.AddRange(entities);
        }

        public IEnumerable<TicketUsers> Filter(Expression<Func<TicketUsers, bool>> filter, Func<IQueryable<TicketUsers>, IOrderedQueryable<TicketUsers>> orderBy = null, string[] Children = null)
        {
            return ticketUsersRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<TicketUsers, bool>> filter, Func<IQueryable<TicketUsers>, IOrderedQueryable<TicketUsers>> orderBy = null)
        {
            return ticketUsersRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public TicketUsers Get(long id)
        {
            return ticketUsersRepository.Get(id);
        }

        public IEnumerable<TicketUsers> GetAll()
        {
            return ticketUsersRepository.GetAll();
        }

        public IEnumerable<TicketUsers> GetByPage(int pageno, int pagesize)
        {
            return ticketUsersRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return ticketUsersRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return ticketUsersRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return ticketUsersRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            TicketUsers entity = new TicketUsers();
            entity = ticketUsersRepository.SingleOrDefault(e=>e.Id==id);
            return ticketUsersRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<TicketUsers> entities = new List<TicketUsers>();
            entities = ticketUsersRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return ticketUsersRepository.RemoveRange(entities);
        }

        public TicketUsers SingleOrDefault(Expression<Func<TicketUsers, bool>> filter)
        {
            return ticketUsersRepository.SingleOrDefault(filter);
        }


    }
}
