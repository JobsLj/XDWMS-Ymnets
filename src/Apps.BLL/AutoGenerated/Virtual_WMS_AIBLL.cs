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
	public partial class WMS_AIBLL: Virtual_WMS_AIBLL,IWMS_AIBLL
	{
        

	}
	public class Virtual_WMS_AIBLL
	{
        [Dependency]
        public IWMS_AIRepository m_Rep { get; set; }

		public virtual List<WMS_AIModel> GetList(ref GridPager pager, string queryStr)
        {

            IQueryable<WMS_AI> queryData = null;
            if (!string.IsNullOrWhiteSpace(queryStr))
            {
                queryData = m_Rep.GetList(
								
								a=>a.ArrivalBillNum.Contains(queryStr)
								
								
								
								
								
								|| a.ReceiveMan.Contains(queryStr)
								|| a.ReceiveStatus.Contains(queryStr)
								|| a.InspectBillNum.Contains(queryStr)
								|| a.InspectMan.Contains(queryStr)
								
								|| a.InspectStatus.Contains(queryStr)
								
								|| a.CheckOutResult.Contains(queryStr)
								
								
								|| a.CheckOutRemark.Contains(queryStr)
								|| a.ReInspectBillNum.Contains(queryStr)
								|| a.InStoreBillNum.Contains(queryStr)
								|| a.InStoreMan.Contains(queryStr)
								
								
								|| a.InStoreStatus.Contains(queryStr)
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

		public virtual List<WMS_AIModel> GetListByUserId(ref GridPager pager, string userId,string queryStr)
		{
			return new List<WMS_AIModel>();
		}
		
		public virtual List<WMS_AIModel> GetListByParentId(ref GridPager pager, string queryStr,object parentId)
        {
			return new List<WMS_AIModel>();
		}

        public virtual List<WMS_AIModel> CreateModelList(ref IQueryable<WMS_AI> queryData)
        {

            List<WMS_AIModel> modelList = (from r in queryData
                                              select new WMS_AIModel
                                              {
													Id = r.Id,
													ArrivalBillNum = r.ArrivalBillNum,
													POId = r.POId,
													PartId = r.PartId,
													BoxQty = r.BoxQty,
													ArrivalQty = r.ArrivalQty,
													ArrivalDate = r.ArrivalDate,
													ReceiveMan = r.ReceiveMan,
													ReceiveStatus = r.ReceiveStatus,
													InspectBillNum = r.InspectBillNum,
													InspectMan = r.InspectMan,
													InspectDate = r.InspectDate,
													InspectStatus = r.InspectStatus,
													CheckOutDate = r.CheckOutDate,
													CheckOutResult = r.CheckOutResult,
													QualifyQty = r.QualifyQty,
													NoQualifyQty = r.NoQualifyQty,
													CheckOutRemark = r.CheckOutRemark,
													ReInspectBillNum = r.ReInspectBillNum,
													InStoreBillNum = r.InStoreBillNum,
													InStoreMan = r.InStoreMan,
													InvId = r.InvId,
													SubInvId = r.SubInvId,
													InStoreStatus = r.InStoreStatus,
													Attr1 = r.Attr1,
													Attr2 = r.Attr2,
													Attr3 = r.Attr3,
													Attr4 = r.Attr4,
													Attr5 = r.Attr5,
													CreatePerson = r.CreatePerson,
													CreateTime = r.CreateTime,
													ModifyPerson = r.ModifyPerson,
													ModifyTime = r.ModifyTime,
          
                                              }).ToList();

            return modelList;
        }

        public virtual bool Create(ref ValidationErrors errors, WMS_AIModel model)
        {
            try
            {
                WMS_AI entity = m_Rep.GetById(model.Id);
                if (entity != null)
                {
                    errors.Add(Resource.PrimaryRepeat);
                    return false;
                }
                entity = new WMS_AI();
               				entity.Id = model.Id;
				entity.ArrivalBillNum = model.ArrivalBillNum;
				entity.POId = model.POId;
				entity.PartId = model.PartId;
				entity.BoxQty = model.BoxQty;
				entity.ArrivalQty = model.ArrivalQty;
				entity.ArrivalDate = model.ArrivalDate;
				entity.ReceiveMan = model.ReceiveMan;
				entity.ReceiveStatus = model.ReceiveStatus;
				entity.InspectBillNum = model.InspectBillNum;
				entity.InspectMan = model.InspectMan;
				entity.InspectDate = model.InspectDate;
				entity.InspectStatus = model.InspectStatus;
				entity.CheckOutDate = model.CheckOutDate;
				entity.CheckOutResult = model.CheckOutResult;
				entity.QualifyQty = model.QualifyQty;
				entity.NoQualifyQty = model.NoQualifyQty;
				entity.CheckOutRemark = model.CheckOutRemark;
				entity.ReInspectBillNum = model.ReInspectBillNum;
				entity.InStoreBillNum = model.InStoreBillNum;
				entity.InStoreMan = model.InStoreMan;
				entity.InvId = model.InvId;
				entity.SubInvId = model.SubInvId;
				entity.InStoreStatus = model.InStoreStatus;
				entity.Attr1 = model.Attr1;
				entity.Attr2 = model.Attr2;
				entity.Attr3 = model.Attr3;
				entity.Attr4 = model.Attr4;
				entity.Attr5 = model.Attr5;
				entity.CreatePerson = model.CreatePerson;
				entity.CreateTime = model.CreateTime;
				entity.ModifyPerson = model.ModifyPerson;
				entity.ModifyTime = model.ModifyTime;
  

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

		
       

        public virtual bool Edit(ref ValidationErrors errors, WMS_AIModel model)
        {
            try
            {
                WMS_AI entity = m_Rep.GetById(model.Id);
                if (entity == null)
                {
                    errors.Add(Resource.Disable);
                    return false;
                }
                              				entity.Id = model.Id;
				entity.ArrivalBillNum = model.ArrivalBillNum;
				entity.POId = model.POId;
				entity.PartId = model.PartId;
				entity.BoxQty = model.BoxQty;
				entity.ArrivalQty = model.ArrivalQty;
				entity.ArrivalDate = model.ArrivalDate;
				entity.ReceiveMan = model.ReceiveMan;
				entity.ReceiveStatus = model.ReceiveStatus;
				entity.InspectBillNum = model.InspectBillNum;
				entity.InspectMan = model.InspectMan;
				entity.InspectDate = model.InspectDate;
				entity.InspectStatus = model.InspectStatus;
				entity.CheckOutDate = model.CheckOutDate;
				entity.CheckOutResult = model.CheckOutResult;
				entity.QualifyQty = model.QualifyQty;
				entity.NoQualifyQty = model.NoQualifyQty;
				entity.CheckOutRemark = model.CheckOutRemark;
				entity.ReInspectBillNum = model.ReInspectBillNum;
				entity.InStoreBillNum = model.InStoreBillNum;
				entity.InStoreMan = model.InStoreMan;
				entity.InvId = model.InvId;
				entity.SubInvId = model.SubInvId;
				entity.InStoreStatus = model.InStoreStatus;
				entity.Attr1 = model.Attr1;
				entity.Attr2 = model.Attr2;
				entity.Attr3 = model.Attr3;
				entity.Attr4 = model.Attr4;
				entity.Attr5 = model.Attr5;
				entity.CreatePerson = model.CreatePerson;
				entity.CreateTime = model.CreateTime;
				entity.ModifyPerson = model.ModifyPerson;
				entity.ModifyTime = model.ModifyTime;
 


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

      

        public virtual WMS_AIModel GetById(object id)
        {
            if (IsExists(id))
            {
                WMS_AI entity = m_Rep.GetById(id);
                WMS_AIModel model = new WMS_AIModel();
                              				model.Id = entity.Id;
				model.ArrivalBillNum = entity.ArrivalBillNum;
				model.POId = entity.POId;
				model.PartId = entity.PartId;
				model.BoxQty = entity.BoxQty;
				model.ArrivalQty = entity.ArrivalQty;
				model.ArrivalDate = entity.ArrivalDate;
				model.ReceiveMan = entity.ReceiveMan;
				model.ReceiveStatus = entity.ReceiveStatus;
				model.InspectBillNum = entity.InspectBillNum;
				model.InspectMan = entity.InspectMan;
				model.InspectDate = entity.InspectDate;
				model.InspectStatus = entity.InspectStatus;
				model.CheckOutDate = entity.CheckOutDate;
				model.CheckOutResult = entity.CheckOutResult;
				model.QualifyQty = entity.QualifyQty;
				model.NoQualifyQty = entity.NoQualifyQty;
				model.CheckOutRemark = entity.CheckOutRemark;
				model.ReInspectBillNum = entity.ReInspectBillNum;
				model.InStoreBillNum = entity.InStoreBillNum;
				model.InStoreMan = entity.InStoreMan;
				model.InvId = entity.InvId;
				model.SubInvId = entity.SubInvId;
				model.InStoreStatus = entity.InStoreStatus;
				model.Attr1 = entity.Attr1;
				model.Attr2 = entity.Attr2;
				model.Attr3 = entity.Attr3;
				model.Attr4 = entity.Attr4;
				model.Attr5 = entity.Attr5;
				model.CreatePerson = entity.CreatePerson;
				model.CreateTime = entity.CreateTime;
				model.ModifyPerson = entity.ModifyPerson;
				model.ModifyTime = entity.ModifyTime;
 
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
        public virtual bool CheckImportData(string fileName, List<WMS_AIModel> list,ref ValidationErrors errors )
        {
          
            var targetFile = new FileInfo(fileName);

            if (!targetFile.Exists)
            {

                errors.Add("导入的数据文件不存在");
                return false;
            }

            var excelFile = new ExcelQueryFactory(fileName);

            //对应列头
			 				 excelFile.AddMapping<WMS_AIModel>(x => x.ArrivalBillNum, "到货单据号");
				 excelFile.AddMapping<WMS_AIModel>(x => x.POId, "采购订单ID");
				 excelFile.AddMapping<WMS_AIModel>(x => x.PartId, "PartId");
				 excelFile.AddMapping<WMS_AIModel>(x => x.BoxQty, "到货箱数");
				 excelFile.AddMapping<WMS_AIModel>(x => x.ArrivalQty, "到货数量");
				 excelFile.AddMapping<WMS_AIModel>(x => x.ArrivalDate, "到货日期");
				 excelFile.AddMapping<WMS_AIModel>(x => x.ReceiveMan, "接收人");
				 excelFile.AddMapping<WMS_AIModel>(x => x.ReceiveStatus, "到货状态");
				 excelFile.AddMapping<WMS_AIModel>(x => x.InspectBillNum, "送检单号");
				 excelFile.AddMapping<WMS_AIModel>(x => x.InspectMan, "送检人");
				 excelFile.AddMapping<WMS_AIModel>(x => x.InspectDate, "送检日期");
				 excelFile.AddMapping<WMS_AIModel>(x => x.InspectStatus, "送检状体");
				 excelFile.AddMapping<WMS_AIModel>(x => x.CheckOutDate, "检验日期");
				 excelFile.AddMapping<WMS_AIModel>(x => x.CheckOutResult, "检验结果");
				 excelFile.AddMapping<WMS_AIModel>(x => x.QualifyQty, "合格数量");
				 excelFile.AddMapping<WMS_AIModel>(x => x.NoQualifyQty, "不合格数量");
				 excelFile.AddMapping<WMS_AIModel>(x => x.CheckOutRemark, "检验说明");
				 excelFile.AddMapping<WMS_AIModel>(x => x.ReInspectBillNum, "重新送检单");
				 excelFile.AddMapping<WMS_AIModel>(x => x.InStoreBillNum, "入库单号");
				 excelFile.AddMapping<WMS_AIModel>(x => x.InStoreMan, "入库员");
				 excelFile.AddMapping<WMS_AIModel>(x => x.InvId, "入库仓库");
				 excelFile.AddMapping<WMS_AIModel>(x => x.SubInvId, "SubInvId");
				 excelFile.AddMapping<WMS_AIModel>(x => x.InStoreStatus, "入库状态");
				 excelFile.AddMapping<WMS_AIModel>(x => x.Attr1, "Attr1");
				 excelFile.AddMapping<WMS_AIModel>(x => x.Attr2, "Attr2");
				 excelFile.AddMapping<WMS_AIModel>(x => x.Attr3, "Attr3");
				 excelFile.AddMapping<WMS_AIModel>(x => x.Attr4, "Attr4");
				 excelFile.AddMapping<WMS_AIModel>(x => x.Attr5, "Attr5");
				 excelFile.AddMapping<WMS_AIModel>(x => x.CreatePerson, "创建人");
				 excelFile.AddMapping<WMS_AIModel>(x => x.CreateTime, "创建时间");
				 excelFile.AddMapping<WMS_AIModel>(x => x.ModifyPerson, "修改人");
				 excelFile.AddMapping<WMS_AIModel>(x => x.ModifyTime, "修改时间");
 
            //SheetName
            var excelContent = excelFile.Worksheet<WMS_AIModel>(0);
            int rowIndex = 1;
            //检查数据正确性
            foreach (var row in excelContent)
            {
                var errorMessage = new StringBuilder();
                var entity = new WMS_AIModel();
						 				  entity.Id = row.Id;
				  entity.ArrivalBillNum = row.ArrivalBillNum;
				  entity.POId = row.POId;
				  entity.PartId = row.PartId;
				  entity.BoxQty = row.BoxQty;
				  entity.ArrivalQty = row.ArrivalQty;
				  entity.ArrivalDate = row.ArrivalDate;
				  entity.ReceiveMan = row.ReceiveMan;
				  entity.ReceiveStatus = row.ReceiveStatus;
				  entity.InspectBillNum = row.InspectBillNum;
				  entity.InspectMan = row.InspectMan;
				  entity.InspectDate = row.InspectDate;
				  entity.InspectStatus = row.InspectStatus;
				  entity.CheckOutDate = row.CheckOutDate;
				  entity.CheckOutResult = row.CheckOutResult;
				  entity.QualifyQty = row.QualifyQty;
				  entity.NoQualifyQty = row.NoQualifyQty;
				  entity.CheckOutRemark = row.CheckOutRemark;
				  entity.ReInspectBillNum = row.ReInspectBillNum;
				  entity.InStoreBillNum = row.InStoreBillNum;
				  entity.InStoreMan = row.InStoreMan;
				  entity.InvId = row.InvId;
				  entity.SubInvId = row.SubInvId;
				  entity.InStoreStatus = row.InStoreStatus;
				  entity.Attr1 = row.Attr1;
				  entity.Attr2 = row.Attr2;
				  entity.Attr3 = row.Attr3;
				  entity.Attr4 = row.Attr4;
				  entity.Attr5 = row.Attr5;
				  entity.CreatePerson = row.CreatePerson;
				  entity.CreateTime = row.CreateTime;
				  entity.ModifyPerson = row.ModifyPerson;
				  entity.ModifyTime = row.ModifyTime;
 
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
        public virtual void SaveImportData(IEnumerable<WMS_AIModel> list)
        {
            try
            {
                using (DBContainer db = new DBContainer())
                {
                    foreach (var model in list)
                    {
                        WMS_AI entity = new WMS_AI();
                       						entity.Id = 0;
						entity.ArrivalBillNum = model.ArrivalBillNum;
						entity.POId = model.POId;
						entity.PartId = model.PartId;
						entity.BoxQty = model.BoxQty;
						entity.ArrivalQty = model.ArrivalQty;
						entity.ArrivalDate = model.ArrivalDate;
						entity.ReceiveMan = model.ReceiveMan;
						entity.ReceiveStatus = model.ReceiveStatus;
						entity.InspectBillNum = model.InspectBillNum;
						entity.InspectMan = model.InspectMan;
						entity.InspectDate = model.InspectDate;
						entity.InspectStatus = model.InspectStatus;
						entity.CheckOutDate = model.CheckOutDate;
						entity.CheckOutResult = model.CheckOutResult;
						entity.QualifyQty = model.QualifyQty;
						entity.NoQualifyQty = model.NoQualifyQty;
						entity.CheckOutRemark = model.CheckOutRemark;
						entity.ReInspectBillNum = model.ReInspectBillNum;
						entity.InStoreBillNum = model.InStoreBillNum;
						entity.InStoreMan = model.InStoreMan;
						entity.InvId = model.InvId;
						entity.SubInvId = model.SubInvId;
						entity.InStoreStatus = model.InStoreStatus;
						entity.Attr1 = model.Attr1;
						entity.Attr2 = model.Attr2;
						entity.Attr3 = model.Attr3;
						entity.Attr4 = model.Attr4;
						entity.Attr5 = model.Attr5;
						entity.CreatePerson = model.CreatePerson;
						entity.CreateTime = ResultHelper.NowTime;
						entity.ModifyPerson = model.ModifyPerson;
						entity.ModifyTime = model.ModifyTime;
 
                        db.WMS_AI.Add(entity);
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
