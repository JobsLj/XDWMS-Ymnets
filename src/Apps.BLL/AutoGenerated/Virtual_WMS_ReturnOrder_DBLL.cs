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
using Apps.IDAL.WMS;
using Apps.Models.WMS;
using Apps.IBLL.WMS;
namespace Apps.BLL.WMS
{
	public partial class WMS_ReturnOrder_DBLL: Virtual_WMS_ReturnOrder_DBLL,IWMS_ReturnOrder_DBLL
	{
        

	}
	public class Virtual_WMS_ReturnOrder_DBLL
	{
        [Dependency]
        public IWMS_ReturnOrder_DRepository m_Rep { get; set; }

		public virtual List<WMS_ReturnOrder_DModel> GetList(ref GridPager pager, string queryStr)
        {

            IQueryable<WMS_ReturnOrder_D> queryData = null;
            if (!string.IsNullOrWhiteSpace(queryStr))
            {
                queryData = m_Rep.GetList(
								
								a=>a.ReturnOrderDNum.Contains(queryStr)
								
								
								|| a.Remark.Contains(queryStr)
								|| a.PrintStaus.Contains(queryStr)
								
								|| a.PrintMan.Contains(queryStr)
								|| a.ConfirmStatus.Contains(queryStr)
								|| a.ConfirmMan.Contains(queryStr)
								
								|| a.Attr1.Contains(queryStr)
								|| a.Attr2.Contains(queryStr)
								|| a.Attr3.Contains(queryStr)
								|| a.Attr4.Contains(queryStr)
								|| a.Attr5.Contains(queryStr)
								|| a.CreatePerson.Contains(queryStr)
								
								|| a.ModifyPerson.Contains(queryStr)
								
								
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

		public virtual List<WMS_ReturnOrder_DModel> GetListByUserId(ref GridPager pager, string userId,string queryStr)
		{
			return new List<WMS_ReturnOrder_DModel>();
		}
		
		public virtual List<WMS_ReturnOrder_DModel> GetListByParentId(ref GridPager pager, string queryStr,object parentId)
        {
			return new List<WMS_ReturnOrder_DModel>();
		}

        public virtual List<WMS_ReturnOrder_DModel> CreateModelList(ref IQueryable<WMS_ReturnOrder_D> queryData)
        {

            List<WMS_ReturnOrder_DModel> modelList = (from r in queryData
                                              select new WMS_ReturnOrder_DModel
                                              {
													Id = r.Id,
													ReturnOrderDNum = r.ReturnOrderDNum,
													HeadId = r.HeadId,
													ReturnQty = r.ReturnQty,
													Remark = r.Remark,
													PrintStaus = r.PrintStaus,
													PrintDate = r.PrintDate,
													PrintMan = r.PrintMan,
													ConfirmStatus = r.ConfirmStatus,
													ConfirmMan = r.ConfirmMan,
													ConfirmDate = r.ConfirmDate,
													Attr1 = r.Attr1,
													Attr2 = r.Attr2,
													Attr3 = r.Attr3,
													Attr4 = r.Attr4,
													Attr5 = r.Attr5,
													CreatePerson = r.CreatePerson,
													CreateTime = r.CreateTime,
													ModifyPerson = r.ModifyPerson,
													ModifyTime = r.ModifyTime,
													BatchId = r.BatchId,
          
                                              }).ToList();

            return modelList;
        }

        public virtual bool Create(ref ValidationErrors errors, WMS_ReturnOrder_DModel model)
        {
            try
            {
                WMS_ReturnOrder_D entity = m_Rep.GetById(model.Id);
                if (entity != null)
                {
                    errors.Add(Resource.PrimaryRepeat);
                    return false;
                }
                entity = new WMS_ReturnOrder_D();
               				entity.Id = model.Id;
				entity.ReturnOrderDNum = model.ReturnOrderDNum;
				entity.HeadId = model.HeadId;
				entity.ReturnQty = model.ReturnQty;
				entity.Remark = model.Remark;
				entity.PrintStaus = model.PrintStaus;
				entity.PrintDate = model.PrintDate;
				entity.PrintMan = model.PrintMan;
				entity.ConfirmStatus = model.ConfirmStatus;
				entity.ConfirmMan = model.ConfirmMan;
				entity.ConfirmDate = model.ConfirmDate;
				entity.Attr1 = model.Attr1;
				entity.Attr2 = model.Attr2;
				entity.Attr3 = model.Attr3;
				entity.Attr4 = model.Attr4;
				entity.Attr5 = model.Attr5;
				entity.CreatePerson = model.CreatePerson;
				entity.CreateTime = model.CreateTime;
				entity.ModifyPerson = model.ModifyPerson;
				entity.ModifyTime = model.ModifyTime;
				entity.BatchId = model.BatchId;
  

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

		
       

        public virtual bool Edit(ref ValidationErrors errors, WMS_ReturnOrder_DModel model)
        {
            try
            {
                WMS_ReturnOrder_D entity = m_Rep.GetById(model.Id);
                if (entity == null)
                {
                    errors.Add(Resource.Disable);
                    return false;
                }
                              				entity.Id = model.Id;
				entity.ReturnOrderDNum = model.ReturnOrderDNum;
				entity.HeadId = model.HeadId;
				entity.ReturnQty = model.ReturnQty;
				entity.Remark = model.Remark;
				entity.PrintStaus = model.PrintStaus;
				entity.PrintDate = model.PrintDate;
				entity.PrintMan = model.PrintMan;
				entity.ConfirmStatus = model.ConfirmStatus;
				entity.ConfirmMan = model.ConfirmMan;
				entity.ConfirmDate = model.ConfirmDate;
				entity.Attr1 = model.Attr1;
				entity.Attr2 = model.Attr2;
				entity.Attr3 = model.Attr3;
				entity.Attr4 = model.Attr4;
				entity.Attr5 = model.Attr5;
				entity.CreatePerson = model.CreatePerson;
				entity.CreateTime = model.CreateTime;
				entity.ModifyPerson = model.ModifyPerson;
				entity.ModifyTime = model.ModifyTime;
				entity.BatchId = model.BatchId;
 


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

      

        public virtual WMS_ReturnOrder_DModel GetById(object id)
        {
            if (IsExists(id))
            {
                WMS_ReturnOrder_D entity = m_Rep.GetById(id);
                WMS_ReturnOrder_DModel model = new WMS_ReturnOrder_DModel();
                              				model.Id = entity.Id;
				model.ReturnOrderDNum = entity.ReturnOrderDNum;
				model.HeadId = entity.HeadId;
				model.ReturnQty = entity.ReturnQty;
				model.Remark = entity.Remark;
				model.PrintStaus = entity.PrintStaus;
				model.PrintDate = entity.PrintDate;
				model.PrintMan = entity.PrintMan;
				model.ConfirmStatus = entity.ConfirmStatus;
				model.ConfirmMan = entity.ConfirmMan;
				model.ConfirmDate = entity.ConfirmDate;
				model.Attr1 = entity.Attr1;
				model.Attr2 = entity.Attr2;
				model.Attr3 = entity.Attr3;
				model.Attr4 = entity.Attr4;
				model.Attr5 = entity.Attr5;
				model.CreatePerson = entity.CreatePerson;
				model.CreateTime = entity.CreateTime;
				model.ModifyPerson = entity.ModifyPerson;
				model.ModifyTime = entity.ModifyTime;
				model.BatchId = entity.BatchId;
 
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
        public virtual bool CheckImportData(string fileName, List<WMS_ReturnOrder_DModel> list,ref ValidationErrors errors )
        {
          
            var targetFile = new FileInfo(fileName);

            if (!targetFile.Exists)
            {

                errors.Add("导入的数据文件不存在");
                return false;
            }

            var excelFile = new ExcelQueryFactory(fileName);

            //对应列头
			 				 excelFile.AddMapping<WMS_ReturnOrder_DModel>(x => x.ReturnOrderDNum, "退货单号");
				 excelFile.AddMapping<WMS_ReturnOrder_DModel>(x => x.HeadId, "头表ID");
				 excelFile.AddMapping<WMS_ReturnOrder_DModel>(x => x.ReturnQty, "退货数量");
				 excelFile.AddMapping<WMS_ReturnOrder_DModel>(x => x.Remark, "备注");
				 excelFile.AddMapping<WMS_ReturnOrder_DModel>(x => x.PrintStaus, "打印状态");
				 excelFile.AddMapping<WMS_ReturnOrder_DModel>(x => x.PrintDate, "打印日期");
				 excelFile.AddMapping<WMS_ReturnOrder_DModel>(x => x.PrintMan, "打印人");
				 excelFile.AddMapping<WMS_ReturnOrder_DModel>(x => x.ConfirmStatus, "确认状态");
				 excelFile.AddMapping<WMS_ReturnOrder_DModel>(x => x.ConfirmMan, "确认人");
				 excelFile.AddMapping<WMS_ReturnOrder_DModel>(x => x.ConfirmDate, "确认时间");
				 excelFile.AddMapping<WMS_ReturnOrder_DModel>(x => x.Attr1, "Attr1");
				 excelFile.AddMapping<WMS_ReturnOrder_DModel>(x => x.Attr2, "Attr2");
				 excelFile.AddMapping<WMS_ReturnOrder_DModel>(x => x.Attr3, "Attr3");
				 excelFile.AddMapping<WMS_ReturnOrder_DModel>(x => x.Attr4, "Attr4");
				 excelFile.AddMapping<WMS_ReturnOrder_DModel>(x => x.Attr5, "Attr5");
				 excelFile.AddMapping<WMS_ReturnOrder_DModel>(x => x.CreatePerson, "创建人");
				 excelFile.AddMapping<WMS_ReturnOrder_DModel>(x => x.CreateTime, "创建时间");
				 excelFile.AddMapping<WMS_ReturnOrder_DModel>(x => x.ModifyPerson, "修改人");
				 excelFile.AddMapping<WMS_ReturnOrder_DModel>(x => x.ModifyTime, "修改时间");
				 excelFile.AddMapping<WMS_ReturnOrder_DModel>(x => x.BatchId, "BatchId");
 
            //SheetName
            var excelContent = excelFile.Worksheet<WMS_ReturnOrder_DModel>(0);
            int rowIndex = 1;
            //检查数据正确性
            foreach (var row in excelContent)
            {
                var errorMessage = new StringBuilder();
                var entity = new WMS_ReturnOrder_DModel();
						 				  entity.Id = row.Id;
				  entity.ReturnOrderDNum = row.ReturnOrderDNum;
				  entity.HeadId = row.HeadId;
				  entity.ReturnQty = row.ReturnQty;
				  entity.Remark = row.Remark;
				  entity.PrintStaus = row.PrintStaus;
				  entity.PrintDate = row.PrintDate;
				  entity.PrintMan = row.PrintMan;
				  entity.ConfirmStatus = row.ConfirmStatus;
				  entity.ConfirmMan = row.ConfirmMan;
				  entity.ConfirmDate = row.ConfirmDate;
				  entity.Attr1 = row.Attr1;
				  entity.Attr2 = row.Attr2;
				  entity.Attr3 = row.Attr3;
				  entity.Attr4 = row.Attr4;
				  entity.Attr5 = row.Attr5;
				  entity.CreatePerson = row.CreatePerson;
				  entity.CreateTime = row.CreateTime;
				  entity.ModifyPerson = row.ModifyPerson;
				  entity.ModifyTime = row.ModifyTime;
				  entity.BatchId = row.BatchId;
 
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
        public virtual void SaveImportData(IEnumerable<WMS_ReturnOrder_DModel> list)
        {
            try
            {
                using (DBContainer db = new DBContainer())
                {
                    foreach (var model in list)
                    {
                        WMS_ReturnOrder_D entity = new WMS_ReturnOrder_D();
                       						entity.Id = 0;
						entity.ReturnOrderDNum = model.ReturnOrderDNum;
						entity.HeadId = model.HeadId;
						entity.ReturnQty = model.ReturnQty;
						entity.Remark = model.Remark;
						entity.PrintStaus = model.PrintStaus;
						entity.PrintDate = model.PrintDate;
						entity.PrintMan = model.PrintMan;
						entity.ConfirmStatus = model.ConfirmStatus;
						entity.ConfirmMan = model.ConfirmMan;
						entity.ConfirmDate = model.ConfirmDate;
						entity.Attr1 = model.Attr1;
						entity.Attr2 = model.Attr2;
						entity.Attr3 = model.Attr3;
						entity.Attr4 = model.Attr4;
						entity.Attr5 = model.Attr5;
						entity.CreatePerson = model.CreatePerson;
						entity.CreateTime = ResultHelper.NowTime;
						entity.ModifyPerson = model.ModifyPerson;
						entity.ModifyTime = model.ModifyTime;
						entity.BatchId = model.BatchId;
 
                        db.WMS_ReturnOrder_D.Add(entity);
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
