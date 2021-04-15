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
using System.Data;
using OEMS.Models.ViewModel.Employee;

namespace OEMS.Service.Services
{
    public class EmpBasicInfoService : IService<EmpBasicInfo>
    {
        private EmpBasicinfoRepository EmpBasicinfoRepository;
        private CommonRepository commonRepository = new CommonRepository();
        public EmpBasicInfoService()
        {
            EmpBasicinfoRepository = new EmpBasicinfoRepository();
        }
        public bool Add(EmpBasicInfo entity)
        {
            return EmpBasicinfoRepository.Add(entity);
        }

        public bool AddRange(IEnumerable<EmpBasicInfo> entities)
        {
            return EmpBasicinfoRepository.AddRange(entities);
        }

        public IEnumerable<EmpBasicInfo> Filter(Expression<Func<EmpBasicInfo, bool>> filter, Func<IQueryable<EmpBasicInfo>, IOrderedQueryable<EmpBasicInfo>> orderBy = null, string[] Children = null)
        {
            return EmpBasicinfoRepository.Filter(filter,orderBy);
        }

        public CommonResponse Filter(int pageno, int pagesize, Expression<Func<EmpBasicInfo, bool>> filter, Func<IQueryable<EmpBasicInfo>, IOrderedQueryable<EmpBasicInfo>> orderBy = null)
        {
            return EmpBasicinfoRepository.Filter(pageno,pagesize,filter,orderBy);
        }

        public EmpBasicInfo Get(long id)
        {
            return EmpBasicinfoRepository.Get(id);
        }

        public IEnumerable<EmpBasicInfo> GetAll()
        {
            return EmpBasicinfoRepository.GetAll();
        }

        public IEnumerable<EmpBasicInfo> GetByPage(int pageno, int pagesize)
        {
            return EmpBasicinfoRepository.GetByPage(pageno,pagesize);
        }

        public CommonResponse getPageResponse(int pageno, int pagesize)
        {
            return EmpBasicinfoRepository.getPageResponse(pageno,pagesize);
        }

        public CommonResponse getResponseBySp(string SpName)
        {
            return EmpBasicinfoRepository.getResponseBySp(SpName);
        }

        public CommonResponse getResponseBySpWithParam(string SpName, params object[] parameterValues)
        {
            return EmpBasicinfoRepository.getResponseBySpWithParam(SpName, parameterValues);
        }

        public bool Remove(long id)
        {
            EmpBasicInfo entity = new EmpBasicInfo();
            entity = EmpBasicinfoRepository.SingleOrDefault(e=>e.SubjectID==id);
            entity.IsDeleted = true;
            entity.SetDate();
            return EmpBasicinfoRepository.Update(entity);
        }

        public bool RemoveRange(List<long> ids)
        {
            List<EmpBasicInfo> entities = new List<EmpBasicInfo>();
            entities = EmpBasicinfoRepository.Filter(x => ids.Contains(Convert.ToInt64(x.EmpBasicInfoID))).ToList();

            return EmpBasicinfoRepository.RemoveRange(entities);
        }

        public EmpBasicInfo SingleOrDefault(Expression<Func<EmpBasicInfo, bool>> filter)
        {
            return EmpBasicinfoRepository.SingleOrDefault(filter);
        }

        public bool Update(EmpBasicInfo entity)
        { 
            return EmpBasicinfoRepository.Update(entity);
        }

        public bool UpdateRange(IEnumerable<EmpBasicInfo> entities)
        {
            return EmpBasicinfoRepository.AddRange(entities);
        }
        public bool Remove(string EmpName)
        {
            EmpBasicInfo entity = new EmpBasicInfo();
            entity = EmpBasicinfoRepository.SingleOrDefault(e => e.FullName == EmpName);
            return EmpBasicinfoRepository.Remove(entity);
        }

        public int GetBranchId(string EmpName)
        {

            int branchID = EmpBasicinfoRepository.SingleOrDefault(e => e.FullName == EmpName).EmpBasicInfoID;
            return branchID;
        }

        public List<DropDownConfig> SearchEmployee(string SrchText)
        {
            var dt = commonRepository.GetBySpWithParam("GetForTypehead", new object[] { SrchText, 2 });
            return CommonRepository.ConvertDataTable<DropDownConfig>(dt);
        }
        public List<DropDownConfig> SearchEmpFromASPNetUsers(string SrchText)
        {
            var dt = commonRepository.GetBySpWithParam("GetForTypehead", new object[] { SrchText, 18 });
            return CommonRepository.ConvertDataTable<DropDownConfig>(dt);
        }
        //public List<DropDownConfig> SearchEmpForLeaveRouteConfig(int designationId, string searchText)
        //{
        //    var dt = commonRepository.GetBySpWithParam("GetUserTypeheadByDesigOrd", new object[] { 1, designationId, searchText });
        //    return CommonRepository.ConvertDataTable<DropDownConfig>(dt);
        //}
        public List<DropDownConfig> SearchAllEmployee(string SrchText)
        {
            var dt = commonRepository.GetBySpWithParam("GetForTypehead", new object[] { SrchText, 14 });
            return CommonRepository.ConvertDataTable<DropDownConfig>(dt);
        }
        public List<DropDownConfig> SearchTeacher(string SrchText,int Type)
        {
            var dt = commonRepository.GetBySpWithParam("GetForTypehead", new object[] { SrchText,Type});
            return CommonRepository.ConvertDataTable<DropDownConfig>(dt);
        }
        public EmployeeVM GetEmployeeDetail(int? EmpId)
        {
            EmployeeVM EmpVM = new EmployeeVM();
            DataSet dt = commonRepository.getDatasetResponseBySp("GetEmpInfoDetailID", new object[] { EmpId }).results;
            if (dt != null)
            {
                EmpVM.EmpBasicInfo = CommonRepository.ConvertDataTable<EmpBasicInfo>(dt.Tables[0]).FirstOrDefault();
                EmpVM.EmpImage = CommonRepository.ConvertDataTable<EmpImage>(dt.Tables[1]).FirstOrDefault();
                EmpVM.EmpJobHistory = CommonRepository.ConvertDataTable<EmpJobHistory>(dt.Tables[2]);
                EmpVM.EmployeeEducationalInfo = CommonRepository.ConvertDataTable<EmployeeEducationalInfo>(dt.Tables[3]);
                EmpVM.EmpNominee = CommonRepository.ConvertDataTable<EmpNominee>(dt.Tables[4]);
                EmpVM.EmpTraining = CommonRepository.ConvertDataTable<EmpTraining>(dt.Tables[5]);
            }
            return EmpVM;
        }
    }
}
