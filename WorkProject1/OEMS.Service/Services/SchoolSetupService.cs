using OEMS.Models;
using OEMS.Models.Model;
using OEMS.Repository.Repositories;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;

namespace OEMS.Service.Services
{
	public class SchoolSetupService : IService<SchoolSetup>
    {
		private SchoolSetupRepository schoolSetupRepository;

		public SchoolSetupService()
		{
			this.schoolSetupRepository = new SchoolSetupRepository();
		}

		public bool Add(SchoolSetup entity)
		{
			return this.schoolSetupRepository.Add(entity);
		}

		public bool AddRange(IEnumerable<SchoolSetup> entities)
		{
			throw new NotImplementedException();
		}
        public bool Update(SchoolSetup entity)
        {
            return schoolSetupRepository.Update(entity);
        }

        public bool UpdateReange(IEnumerable<SchoolSetup> entities)
        {
            throw new NotImplementedException();
        }
        public IEnumerable<SchoolSetup> Filter(Expression<Func<SchoolSetup, bool>> filter, Func<IQueryable<SchoolSetup>, IOrderedQueryable<SchoolSetup>> orderBy = null, string[] Children = null)
		{
			return this.schoolSetupRepository.Filter(filter, orderBy);
		}

		public SchoolSetup Get(long id)
		{
            return schoolSetupRepository.Get(id);
		}

		public IEnumerable<SchoolSetup> GetAll()
		{
			return this.schoolSetupRepository.GetAll();
		}

		public CommonResponse getPageResponse(int pageno, int pagesize)
		{
			return this.schoolSetupRepository.getPageResponse(pageno, pagesize);
		}

		public IEnumerable<SchoolSetup> GetAll(int pageno, int pagesize)
		{
			return this.schoolSetupRepository.GetByPage(pageno, pagesize);
		}

		public bool Remove(long id)
		{
			throw new NotImplementedException();
		}

		public bool RemoveRange(List<long> ids)
		{
			throw new NotImplementedException();
		}

		public SchoolSetup SingleOrDefault(Expression<Func<SchoolSetup, bool>> predicate)
		{
			throw new NotImplementedException();
		}

        public IEnumerable<SchoolSetup> GetByPage(int pageno, int pagesize)
        {
            return this.schoolSetupRepository.GetByPage(pageno, pagesize);
        }

        public bool UpdateRange(IEnumerable<SchoolSetup> entities)
        {
            throw new NotImplementedException();
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<SchoolSetup, bool>> filter, Func<IQueryable<SchoolSetup>, IOrderedQueryable<SchoolSetup>> orderBy = null)
        {
            throw new NotImplementedException();
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            throw new NotImplementedException();
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            throw new NotImplementedException();
        }
    }
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                