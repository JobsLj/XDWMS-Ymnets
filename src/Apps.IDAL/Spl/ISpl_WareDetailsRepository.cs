//------------------------------------------------------------------------------
// <auto-generated>
//     此代码已从模板生成。
//
//     手动更改此文件可能导致应用程序出现意外的行为。
//     如果重新生成代码，将覆盖对此文件的手动更改。
// </auto-generated>
//------------------------------------------------------------------------------

using Apps.Models;
using Apps.Models.Spl;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Apps.IDAL.Spl
{
	public partial interface ISpl_WareDetailsRepository
	{
        int GetWareCountByCategoryId(string categoryId);

        /// <summary>
        /// 查询库存表，存在并可以调出库的商品数据
        /// </summary>
        /// <param name="wareHouse"></param>
        /// <returns></returns>
        List<Spl_WareDetailsModel> GetListByWareHouse(string wareHouse);
    }
}
