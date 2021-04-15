using OEMS.Models;
using OEMS.Models.Model;
using OEMS.Models.Model.Client;
using OEMS.Models.Model.Inventory;
using OEMS.Repository.Repositories;
using OEMS.Repository.Repositories.Clients;
using OEMS.Repository.Repositories.Inventory;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace OEMS.Service.Services.Inventory
{
  
    public class ClientsdbService : IService<Clients_db>
    {
        private DBRepository DBRepository;

        public ClientsdbService()
        {
            DBRepository = new DBRepository();
        }
        public bool Add(Clients_db entity)
        {
            return DBRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<Clients_db> entities)
        {
            return DBRepository.AddRange(entities);
        }

        public IEnumerable<Clients_db> Filter(Expression<Func<Clients_db, bool>> filter, Func<IQueryable<Clients_db>, IOrderedQueryable<Clients_db>> orderBy = null, string[] Children = null)
        {
            return DBRepository.Filter(filter, orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<Clients_db, bool>> filter, Func<IQueryable<Clients_db>, IOrderedQueryable<Clients_db>> orderBy = null)
        {
            return DBRepository.Filter(pageno, pagesize, filter, orderBy);
        }

        public Clients_db Get(long id)
        {
            return DBRepository.Get(id);
        }

        public IEnumerable<Clients_db> GetAll()
        {
            return DBRepository.GetAll();
        }

        public IEnumerable<Clients_db> GetByPage(int pageno, int pagesize)
        {
            return DBRepository.GetByPage(pageno, pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return DBRepository.getPageResponse(pageno, pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return DBRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return DBRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            Clients_db entity = new Clients_db();
            entity = DBRepository.SingleOrDefault(e => e.ClientsDbId == id);
            entity.IsDeleted = true;
            entity.Status = "D";
            entity.SetDate();
            return DBRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<Clients_db> entities = new List<Clients_db>();
            entities = DBRepository.Filter(x => ids.Contains(Convert.ToInt64(x.ClientId))).ToList();

            return DBRepository.RemoveRange(entities);
        }

        public Clients_db SingleOrDefault(Expression<Func<Clients_db, bool>> filter)
        {
            return DBRepository.SingleOrDefault(filter);
        }

        public bool Update(Clients_db entity)
        {
            return DBRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<Clients_db> entities)
        {
            return DBRepository.AddRange(entities);
        }
        public bool Remove(string Name)
        {
            Clients_db entity = new Clients_db();
            entity = DBRepository.SingleOrDefault(e => e.DbName == Name);
            return DBRepository.Remove(entity);
        }
        public string GetConStr(int ClientDbId)
        {
            Clients_db entity = new Clients_db();
            entity = DBRepository.SingleOrDefault(e => e.ClientsDbId == ClientDbId);
            string Constr = String.Empty;
            if (entity != null)
            {

                Constr = $"Data Source={entity.Host};Initial Catalog={entity.DbName};User ID={entity.DbUserName};Password={entity.DbPass};MultipleActiveResultSets=True";
            }

            return Constr;
        }


    }
}
