//------------------------------------------------------------------------------
// <auto-generated>
//     此代码已从模板生成。
//
//     手动更改此文件可能导致应用程序出现意外的行为。
//     如果重新生成代码，将覆盖对此文件的手动更改。
// </auto-generated>
//------------------------------------------------------------------------------

namespace Apps.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class Spl_WareCategory
    {
        public Spl_WareCategory()
        {
            this.Spl_WareCategory1 = new HashSet<Spl_WareCategory>();
            this.Spl_WareDetails = new HashSet<Spl_WareDetails>();
        }
    
        public string Id { get; set; }
        public string Name { get; set; }
        public string Code { get; set; }
        public string ParentId { get; set; }
        public string Remark { get; set; }
        public System.DateTime CreateTime { get; set; }
        public bool Enable { get; set; }
    
        public virtual ICollection<Spl_WareCategory> Spl_WareCategory1 { get; set; }
        public virtual Spl_WareCategory Spl_WareCategory2 { get; set; }
        public virtual ICollection<Spl_WareDetails> Spl_WareDetails { get; set; }
    }
}
