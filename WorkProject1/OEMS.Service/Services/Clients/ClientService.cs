using OEMS.Models;
using OEMS.Models.Model;
using OEMS.Models.Model.Client;
using OEMS.Repository.Repositories;
using OEMS.Repository.Repositories.Clients;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Service.Services.Clients
{
    public class ClientService : IService<Client>
    {
        ClientRepository clientRepository;
        private CommonRepository commonRepository;
        public ClientService() 
        {
            clientRepository = new ClientRepository();
            commonRepository = new CommonRepository();
        }

        public bool Add(Client entity)
        {
            return clientRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<Client> entities)
        {
            return clientRepository.AddRange(entities);
        }

        public bool Update(Client entity)
        {
            return clientRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<Client> entities)
        {
            return clientRepository.AddRange(entities);
        }

        public bool Remove(long id)
        {
            Client entity = new Client();
            entity = clientRepository.SingleOrDefault(e => e.Id == id);
            return clientRepository.Remove(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<Client> entities = new List<Client>();
            entities = clientRepository.Filter(x => ids.Contains(Convert.ToInt64(x.Id))).ToList();

            return clientRepository.RemoveRange(entities);
        }

        public Client Get(long id)
        {
            return clientRepository.Get(id);
        }

        public Client SingleOrDefault(Expression<Func<Client, bool>> filter)
        {
            return clientRepository.SingleOrDefault(filter);
        }


        public IEnumerable<Client> GetAll()
        {
            return clientRepository.GetAll();
        }

        public IEnumerable<Client> Filter(Expression<Func<Client, bool>> filter, Func<IQueryable<Client>, IOrderedQueryable<Client>> orderBy = null, string[] Children = null)
        {
            return clientRepository.Filter(filter, orderBy);
        }

        public IEnumerable<Client> GetByPage(int pageno, int pagesize)
        {
            return clientRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return clientRepository.getPageResponse(pageno, pagesize);
        }
        public List<DropDownConfig> SearchClient(string SrchText)
        {
            var dt = commonRepository.GetBySpWithParam("GetForTypehead", new object[] { SrchText, 15 });
            return CommonRepository.ConvertDataTable<DropDownConfig>(dt);
        }
        public List<DropDownConfig> SearchClientDatabaseConfig(string SrchText)
        {
            var dt = commonRepository.GetBySpWithParam("GetForTypehead", new object[] { SrchText, 16 });
            return CommonRepository.ConvertDataTable<DropDownConfig>(dt);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return clientRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return clientRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<Client, bool>> filter, Func<IQueryable<Client>, IOrderedQueryable<Client>> orderBy = null)
        {
            return clientRepository.Filter(pageno, pagesize, filter, orderBy);
        }
        
    }
}
