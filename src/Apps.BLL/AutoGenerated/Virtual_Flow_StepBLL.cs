//------------------------------------------------------------------------------
// <auto-generated>
//     此代码已从模板生成。
//
//     手动更改此文件可能导致应用程序出现意外的行为。
//     如果重新生成代码，将覆盖对此文件的手动更改。
// </auto-generated>
//------------------------------------------------------------------------------

using System;
using System.Collections.Generic;
using System.Linq;
using Apps.Models;
using Apps.Common;
using Unity.Attributes;
using System.Transactions;
using Apps.BLL.Core;
using Apps.Locale;
using LinqToExcel;
using System.IO;
using System.Text;
using Apps.IDAL.Flow;
using Apps.Models.Flow;
using Apps.IBLL.Flow;
namespace Apps.BLL.Flow
{
	public partial class Flow_StepBLL: Virtual_Flow_StepBLL,IFlow_StepBLL
	{
        

	}
	public class Virtual_Flow_StepBLL
	{
        [Dependency]
        public IFlow_StepRepository m_Rep { get; set; }

		public virtual List<Flow_StepModel> GetList(ref GridPager pager, string queryStr)
        {

            IQueryable<Flow_Step> queryData = null;
            if (!string.IsNullOrWhiteSpace(queryStr))
            {
                queryData = m_Rep.GetList(
								a=>a.Id.Contains(queryStr)
								|| a.Name.Contains(queryStr)
								|| a.Remark.Contains(queryStr)
								
								|| a.FormId.Contains(queryStr)
								
								
								
								|| a.Execution.Contains(queryStr)
								
								
								);
            }
            else
            {
                queryData = m_Rep.GetList();
            }
            pager.totalRows = queryData.Count();
            //排序
            queryData = LinqHelper.SortingAndPaging(queryData, pager.sort, pager.order, pager.page, pager.rows);
            return CreateModelList(ref queryData);
        }

		public virtual List<Flow_StepModel> GetListByUserId(ref GridPager pager, string userId,string queryStr)
		{
			return new List<Flow_StepModel>();
		}
		
		public virtual List<Flow_StepModel> GetListByParentId(ref GridPager pager, string queryStr,object parentId)
        {
			return new List<Flow_StepModel>();
		}

        public virtual List<Flow_StepModel> CreateModelList(ref IQueryable<Flow_Step> queryData)
        {

            List<Flow_StepModel> modelList = (from r in queryData
                                              select new Flow_StepModel
                                              {
													Id = r.Id,
													Name = r.Name,
													Remark = r.Remark,
													Sort = r.Sort,
													FormId = r.FormId,
													FlowRule = r.FlowRule,
													IsCustom = r.IsCustom,
													IsAllCheck = r.IsAllCheck,
													Execution = r.Execution,
													CompulsoryOver = r.CompulsoryOver,
													IsEditAttr = r.IsEditAttr,
          
                                              }).ToList();

            return modelList;
        }

        public virtual bool Create(ref ValidationErrors errors, Flow_StepModel model)
        {
            try
            {
                Flow_Step entity = m_Rep.GetById(model.Id);
                if (entity != null)
                {
                    errors.Add(Resource.PrimaryRepeat);
                    return false;
                }
                entity = new Flow_Step();
               				entity.Id = model.Id;
				entity.Name = model.Name;
				entity.Remark = model.Remark;
				entity.Sort = model.Sort;
				entity.FormId = model.FormId;
				entity.FlowRule = model.FlowRule;
				entity.IsCustom = model.IsCustom;
				entity.IsAllCheck = model.IsAllCheck;
				entity.Execution = model.Execution;
				entity.CompulsoryOver = model.CompulsoryOver;
				entity.IsEditAttr = model.IsEditAttr;
  

                if (m_Rep.Create(entity))
                {
                    return true;
                }
                else
                {
                    errors.Add(Resource.InsertFail);
                    return false;
                }
            }
            catch (Exception ex)
            {
                errors.Add(ex.Message);
                ExceptionHander.WriteException(ex);
                return false;
            }
        }



         public virtual bool Delete(ref ValidationErrors errors, object id)
        {
            try
            {
                if (m_Rep.Delete(id) == 1)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch (Exception ex)
            {
                errors.Add(ex.Message);
                ExceptionHander.WriteException(ex);
                return false;
            }
        }

        public virtual bool Delete(ref ValidationErrors errors, object[] deleteCollection)
        {
            try
            {
                if (deleteCollection != null)
                {
                    using (TransactionScope transactionScope = new TransactionScope())
                    {
                        if (m_Rep.Delete(deleteCollection) == deleteCollection.Length)
                        {
                            transactionScope.Complete();
                            return true;
                        }
                        else
                        {
                            Transaction.Current.Rollback();
                            return false;
                        }
                    }
                }
                return false;
            }
            catch (Exception ex)
            {
                errors.Add(ex.Message);
                ExceptionHander.WriteException(ex);
                return false;
            }
        }

		
       

        public virtual bool Edit(ref ValidationErrors errors, Flow_StepModel model)
        {
            try
            {
                Flow_Step entity = m_Rep.GetById(model.Id);
                if (entity == null)
                {
                    errors.Add(Resource.Disable);
                    return false;
                }
                              				entity.Id = model.Id;
				entity.Name = model.Name;
				entity.Remark = model.Remark;
				entity.Sort = model.Sort;
				entity.FormId = model.FormId;
				entity.FlowRule = model.FlowRule;
				entity.IsCustom = model.IsCustom;
				entity.IsAllCheck = model.IsAllCheck;
				entity.Execution = model.Execution;
				entity.CompulsoryOver = model.CompulsoryOver;
				entity.IsEditAttr = model.IsEditAttr;
 


                if (m_Rep.Edit(entity))
                {
                    return true;
                }
                else
                {
                    errors.Add(Resource.NoDataChange);
                    return false;
                }

            }
            catch (Exception ex)
            {
                errors.Add(ex.Message);
                ExceptionHander.WriteException(ex);
                return false;
            }
        }

      

        public virtual Flow_StepModel GetById(object id)
        {
            if (IsExists(id))
            {
                Flow_Step entity = m_Rep.GetById(id);
                Flow_StepModel model = new Flow_StepModel();
                              				model.Id = entity.Id;
				model.Name = entity.Name;
				model.Remark = entity.Remark;
				model.Sort = entity.Sort;
				model.FormId = entity.FormId;
				model.FlowRule = entity.FlowRule;
				model.IsCustom = entity.IsCustom;
				model.IsAllCheck = entity.IsAllCheck;
				model.Execution = entity.Execution;
				model.CompulsoryOver = entity.CompulsoryOver;
				model.IsEditAttr = entity.IsEditAttr;
 
                return model;
            }
            else
            {
                return null;
            }
        }


		 /// <summary>
        /// 校验Excel数据,这个方法一般用于重写校验逻辑
        /// </summary>
        public virtual bool CheckImportData(string fileName, List<Flow_StepModel> list,ref ValidationErrors errors )
        {
          
            var targetFile = new FileInfo(fileName);

            if (!targetFile.Exists)
            {

                errors.Add("导入的数据文件不存在");
                return false;
            }

            var excelFile = new ExcelQueryFactory(fileName);

            //对应列头
			 				 excelFile.AddMapping<Flow_StepModel>(x => x.Name, "步骤名称");
				 excelFile.AddMapping<Flow_StepModel>(x => x.Remark, "步骤说明");
				 excelFile.AddMapping<Flow_StepModel>(x => x.Sort, "排序");
				 excelFile.AddMapping<Flow_StepModel>(x => x.FormId, "所属表单");
				 excelFile.AddMapping<Flow_StepModel>(x => x.FlowRule, "流转规则");
				 excelFile.AddMapping<Flow_StepModel>(x => x.IsCustom, "该流程的 发起人/创建者 是否可以 自行选择 该步骤的审批者");
				 excelFile.AddMapping<Flow_StepModel>(x => x.IsAllCheck, "当规则或者角色被选择为多人时候，是否启用多人审核才通过");
				 excelFile.AddMapping<Flow_StepModel>(x => x.Execution, "执行者与规则对应");
				 excelFile.AddMapping<Flow_StepModel>(x => x.CompulsoryOver, "是否可以强制完成整个流程");
				 excelFile.AddMapping<Flow_StepModel>(x => x.IsEditAttr, "审核者是否可以编辑发起者的附件");
 
            //SheetName
            var excelContent = excelFile.Worksheet<Flow_StepModel>(0);
            int rowIndex = 1;
            //检查数据正确性
            foreach (var row in excelContent)
            {
                var errorMessage = new StringBuilder();
                var entity = new Flow_StepModel();
						 				  entity.Id = row.Id;
				  entity.Name = row.Name;
				  entity.Remark = row.Remark;
				  entity.Sort = row.Sort;
				  entity.FormId = row.FormId;
				  entity.FlowRule = row.FlowRule;
				  entity.IsCustom = row.IsCustom;
				  entity.IsAllCheck = row.IsAllCheck;
				  entity.Execution = row.Execution;
				  entity.CompulsoryOver = row.CompulsoryOver;
				  entity.IsEditAttr = row.IsEditAttr;
 
                //=============================================================================
                if (errorMessage.Length > 0)
                {
                    errors.Add(string.Format(
                        "第 {0} 列发现错误：{1}{2}",
                        rowIndex,
                        errorMessage,
                        "<br/>"));
                }
                list.Add(entity);
                rowIndex += 1;
            }
            if (errors.Count > 0)
            {
                return false;
            }
            return true;
        }

        /// <summary>
        /// 保存数据
        /// </summary>
        public virtual void SaveImportData(IEnumerable<Flow_StepModel> list)
        {
            try
            {
                using (DBContainer db = new DBContainer())
                {
                    foreach (var model in list)
                    {
                        Flow_Step entity = new Flow_Step();
                       						entity.Id = ResultHelper.NewId;
						entity.Name = model.Name;
						entity.Remark = model.Remark;
						entity.Sort = model.Sort;
						entity.FormId = model.FormId;
						entity.FlowRule = model.FlowRule;
						entity.IsCustom = model.IsCustom;
						entity.IsAllCheck = model.IsAllCheck;
						entity.Execution = model.Execution;
						entity.CompulsoryOver = model.CompulsoryOver;
						entity.IsEditAttr = model.IsEditAttr;
 
                        db.Flow_Step.Add(entity);
                    }
                    db.SaveChanges();
                }
            }
            catch(Exception ex)
            {
                throw;
            }
        }
		public virtual bool Check(ref ValidationErrors errors, object id,int flag)
        {
			return true;
		}

        public virtual bool IsExists(object id)
        {
            return m_Rep.IsExist(id);
        }
		
		public void Dispose()
        { 
            
        }

	}
}
