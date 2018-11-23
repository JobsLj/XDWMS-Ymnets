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
using Apps.IDAL.Spl;
using Apps.Models.Spl;
using Apps.IBLL.Spl;
namespace Apps.BLL.Spl
{
	public partial class Spl_TestStudentsBLL: Virtual_Spl_TestStudentsBLL,ISpl_TestStudentsBLL
	{
        

	}
	public class Virtual_Spl_TestStudentsBLL
	{
        [Dependency]
        public ISpl_TestStudentsRepository m_Rep { get; set; }

		public virtual List<Spl_TestStudentsModel> GetList(ref GridPager pager, string queryStr)
        {

            IQueryable<Spl_TestStudents> queryData = null;
            if (!string.IsNullOrWhiteSpace(queryStr))
            {
                queryData = m_Rep.GetList(
								
								
								a=>a.Name.Contains(queryStr)
								
								|| a.Photo.Contains(queryStr)
								
								
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

		public virtual List<Spl_TestStudentsModel> GetListByUserId(ref GridPager pager, string userId,string queryStr)
		{
			return new List<Spl_TestStudentsModel>();
		}
		
		public virtual List<Spl_TestStudentsModel> GetListByParentId(ref GridPager pager, string queryStr,object parentId)
        {
			return new List<Spl_TestStudentsModel>();
		}

        public virtual List<Spl_TestStudentsModel> CreateModelList(ref IQueryable<Spl_TestStudents> queryData)
        {

            List<Spl_TestStudentsModel> modelList = (from r in queryData
                                              select new Spl_TestStudentsModel
                                              {
													Id = r.Id,
													ClassId = r.ClassId,
													Name = r.Name,
													Avg = r.Avg,
													Photo = r.Photo,
													Enable = r.Enable,
													CreateTime = r.CreateTime,
          
                                              }).ToList();

            return modelList;
        }

        public virtual bool Create(ref ValidationErrors errors, Spl_TestStudentsModel model)
        {
            try
            {
                Spl_TestStudents entity = m_Rep.GetById(model.Id);
                if (entity != null)
                {
                    errors.Add(Resource.PrimaryRepeat);
                    return false;
                }
                entity = new Spl_TestStudents();
               				entity.Id = model.Id;
				entity.ClassId = model.ClassId;
				entity.Name = model.Name;
				entity.Avg = model.Avg;
				entity.Photo = model.Photo;
				entity.Enable = model.Enable;
				entity.CreateTime = model.CreateTime;
  

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

		
       

        public virtual bool Edit(ref ValidationErrors errors, Spl_TestStudentsModel model)
        {
            try
            {
                Spl_TestStudents entity = m_Rep.GetById(model.Id);
                if (entity == null)
                {
                    errors.Add(Resource.Disable);
                    return false;
                }
                              				entity.Id = model.Id;
				entity.ClassId = model.ClassId;
				entity.Name = model.Name;
				entity.Avg = model.Avg;
				entity.Photo = model.Photo;
				entity.Enable = model.Enable;
				entity.CreateTime = model.CreateTime;
 


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

      

        public virtual Spl_TestStudentsModel GetById(object id)
        {
            if (IsExists(id))
            {
                Spl_TestStudents entity = m_Rep.GetById(id);
                Spl_TestStudentsModel model = new Spl_TestStudentsModel();
                              				model.Id = entity.Id;
				model.ClassId = entity.ClassId;
				model.Name = entity.Name;
				model.Avg = entity.Avg;
				model.Photo = entity.Photo;
				model.Enable = entity.Enable;
				model.CreateTime = entity.CreateTime;
 
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
        public virtual bool CheckImportData(string fileName, List<Spl_TestStudentsModel> list,ref ValidationErrors errors )
        {
          
            var targetFile = new FileInfo(fileName);

            if (!targetFile.Exists)
            {

                errors.Add("导入的数据文件不存在");
                return false;
            }

            var excelFile = new ExcelQueryFactory(fileName);

            //对应列头
			 				 excelFile.AddMapping<Spl_TestStudentsModel>(x => x.ClassId, "所属班级");
				 excelFile.AddMapping<Spl_TestStudentsModel>(x => x.Name, "姓名");
				 excelFile.AddMapping<Spl_TestStudentsModel>(x => x.Avg, "年龄");
				 excelFile.AddMapping<Spl_TestStudentsModel>(x => x.Photo, "头像");
				 excelFile.AddMapping<Spl_TestStudentsModel>(x => x.Enable, "状态");
				 excelFile.AddMapping<Spl_TestStudentsModel>(x => x.CreateTime, "创建时间");
 
            //SheetName
            var excelContent = excelFile.Worksheet<Spl_TestStudentsModel>(0);
            int rowIndex = 1;
            //检查数据正确性
            foreach (var row in excelContent)
            {
                var errorMessage = new StringBuilder();
                var entity = new Spl_TestStudentsModel();
						 				  entity.Id = row.Id;
				  entity.ClassId = row.ClassId;
				  entity.Name = row.Name;
				  entity.Avg = row.Avg;
				  entity.Photo = row.Photo;
				  entity.Enable = row.Enable;
				  entity.CreateTime = row.CreateTime;
 
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
        public virtual void SaveImportData(IEnumerable<Spl_TestStudentsModel> list)
        {
            try
            {
                using (DBContainer db = new DBContainer())
                {
                    foreach (var model in list)
                    {
                        Spl_TestStudents entity = new Spl_TestStudents();
                       						entity.Id = 0;
						entity.ClassId = model.ClassId;
						entity.Name = model.Name;
						entity.Avg = model.Avg;
						entity.Photo = model.Photo;
						entity.Enable = model.Enable;
						entity.CreateTime = ResultHelper.NowTime;
 
                        db.Spl_TestStudents.Add(entity);
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
