using OEMS.Models.Model;
using OEMS.Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OEMS.Models;
using System.Linq.Expressions;
using OEMS.Models.Model.Employee;

using OEMS.Repository.Repositories;
using OEMS.Repository.Repositories.Employee;

namespace OEMS.Service.Services
{
    public class RepHeaderImgService /*: IService<RepHeaderImage>*/
    {
        private ReportHeaderImageRepository ReportHeaderImageRepository;

        public RepHeaderImgService()
        {
            ReportHeaderImageRepository = new ReportHeaderImageRepository();
        }
        public bool Add(ReportHeader entity)
        {
            return ReportHeaderImageRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<ReportHeader> entities)
        {
            return ReportHeaderImageRepository.AddRange(entities);
        }

        public IEnumerable<ReportHeader> Filter(Expression<Func<ReportHeader, bool>> filter, Func<IQueryable<ReportHeader>, IOrderedQueryable<ReportHeader>> orderBy = null, string[] Children = null)
        {
            return ReportHeaderImageRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<ReportHeader, bool>> filter, Func<IQueryable<ReportHeader>, IOrderedQueryable<ReportHeader>> orderBy = null)
        {
            return ReportHeaderImageRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public ReportHeader Get(long id)
        {
            return ReportHeaderImageRepository.Get(id);
        }

        public IEnumerable<ReportHeader> GetAll()
        {
            return ReportHeaderImageRepository.GetAll();
        }

        public IEnumerable<ReportHeader> GetByPage(int pageno, int pagesize)
        {
            return ReportHeaderImageRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return ReportHeaderImageRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return ReportHeaderImageRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return ReportHeaderImageRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        //public bool Remove(long id)
        //{
        //    RepHeaderImage entity = new RepHeaderImage();
        //    entity = ReportHeaderImageRepository.SingleOrDefault(e => e.RepHeaderImageID == id);
        //    entity.IsDeleted = true;
        //    entity.SetDate();
        //    return ReportHeaderImageRepository.Update(entity);
        //}

        public bool RemoveRange(List<long> ids)
        {
            List<ReportHeader> entities = new List<ReportHeader>();
            entities = ReportHeaderImageRepository.Filter(x => ids.Contains(Convert.ToInt64(x.ReportHeaderId))).ToList();

            return ReportHeaderImageRepository.RemoveRange(entities);
        }

        public ReportHeader SingleOrDefault(Expression<Func<ReportHeader, bool>> filter)
        {
            return ReportHeaderImageRepository.SingleOrDefault(filter);
        }

        public bool Update(ReportHeader entity)
        { 
            return ReportHeaderImageRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<ReportHeader> entities)
        {
            return ReportHeaderImageRepository.AddRange(entities);
        }
        //public bool Remove(string EmpName)
        //{
        //    RepHeaderImage entity = new RepHeaderImage();
        //    entity = ReportHeaderImageRepository.SingleOrDefault(e => e.FullName == EmpName);
        //    return ReportHeaderImageRepository.Remove(entity);
        //}

        //public int GetBranchId(string EmpName)
        //{

        //    int branchID = EmpBasicinfoRepository.SingleOrDefault(e => e.FullName == EmpName).EmpBasicInfoID;
        //    return branchID;
        //}

   
    }
}
