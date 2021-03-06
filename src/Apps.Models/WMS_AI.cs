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
    
    public partial class WMS_AI
    {
        public WMS_AI()
        {
            this.WMS_ReInspect = new HashSet<WMS_ReInspect>();
            this.WMS_ReturnOrder = new HashSet<WMS_ReturnOrder>();
        }
    
        public int Id { get; set; }
        public string ArrivalBillNum { get; set; }
        public int POId { get; set; }
        public Nullable<int> PartId { get; set; }
        public Nullable<decimal> BoxQty { get; set; }
        public Nullable<decimal> ArrivalQty { get; set; }
        public Nullable<System.DateTime> ArrivalDate { get; set; }
        public string ReceiveMan { get; set; }
        public string ReceiveStatus { get; set; }
        public string InspectBillNum { get; set; }
        public string InspectMan { get; set; }
        public Nullable<System.DateTime> InspectDate { get; set; }
        public string InspectStatus { get; set; }
        public Nullable<System.DateTime> CheckOutDate { get; set; }
        public string CheckOutResult { get; set; }
        public Nullable<decimal> QualifyQty { get; set; }
        public Nullable<decimal> NoQualifyQty { get; set; }
        public string CheckOutRemark { get; set; }
        public string ReInspectBillNum { get; set; }
        public string InStoreBillNum { get; set; }
        public string InStoreMan { get; set; }
        public Nullable<int> InvId { get; set; }
        public Nullable<int> SubInvId { get; set; }
        public string InStoreStatus { get; set; }
        public string Attr1 { get; set; }
        public string Attr2 { get; set; }
        public string Attr3 { get; set; }
        public string Attr4 { get; set; }
        public string Attr5 { get; set; }
        public string CreatePerson { get; set; }
        public Nullable<System.DateTime> CreateTime { get; set; }
        public string ModifyPerson { get; set; }
        public Nullable<System.DateTime> ModifyTime { get; set; }
        public string Lot { get; set; }
    
        public virtual WMS_PO WMS_PO { get; set; }
        public virtual WMS_InvInfo WMS_InvInfo { get; set; }
        public virtual WMS_SubInvInfo WMS_SubInvInfo { get; set; }
        public virtual ICollection<WMS_ReInspect> WMS_ReInspect { get; set; }
        public virtual WMS_Part WMS_Part { get; set; }
        public virtual ICollection<WMS_ReturnOrder> WMS_ReturnOrder { get; set; }
    }
}
