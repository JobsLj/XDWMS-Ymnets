USE [XDWMS]
GO

/****** Object:  StoredProcedure [dbo].[P_WMS_ConfirmFeedList]    Script Date: 2019/5/11 21:00:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [dbo].[P_WMS_ConfirmFeedList]
	@UserId varchar(50),
	@ReleaseBillNum	varchar(50),
	@ReturnValue	varchar(50) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	set xact_abort on   

	DECLARE @now datetime = getdate()
	DECLARE @SubAssemblyPartId int;
	DECLARE @InvId int;
	DECLARE @SubInvId int;
	DECLARE @Lot varchar(50);
	DECLARE @Qty decimal(10, 3);
	DECLARE @rowId int;
	DECLARE @countOK int = 0;
	DECLARE @countError int = 0;

	BEGIN TRAN

	--�޸Ŀ��
	DECLARE cur_FeedList cursor for (select Id, SubAssemblyPartId, InvId, SubInvId, Lot, FeedQty * -1
											from WMS_Feed_List
											where ReleaseBillNum = @ReleaseBillNum
											  and PrintStaus = '�Ѵ�ӡ'
											  and ConfirmStatus = 'δȷ��');
    --���α�--
    open cur_FeedList;
    --��ʼѭ���α����--
    fetch next from cur_FeedList into @rowId, @SubAssemblyPartId, @InvId, @SubInvId, @Lot, @Qty;
    while @@FETCH_STATUS = 0    --���ر� FETCH���ִ�е�����α��״̬--
    begin         
		BEGIN TRY   
			--BEGIN TRAN

			exec P_WMS_UpdateInvQty @UserId, @SubAssemblyPartId, @InvId, null, @Lot, 0, 1, @Qty, @now, 'Ͷ��', @rowId, @ReleaseBillNum;

			--�޸�Ͷ�ϵ��е�ȷ��״̬
			update WMS_Feed_List set ConfirmStatus = '��ȷ��', ConfirmMan = @UserId, ConfirmDate = @now,
					ConfirmMessage = '',
					ModifyPerson = @UserId, ModifyTime = @now
					where Id = @rowId;

			set @countOK = @countOK + 1;
			--COMMIT TRAN;
 		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0
				ROLLBACK TRAN ;

			--���������Ϣ
			BEGIN TRAN SaveError
			set @countError = @countError + 1;
			update WMS_Feed_List set ConfirmMessage = ERROR_MESSAGE(),
					ModifyPerson = @UserId, ModifyTime = @now
					where Id = @rowId;
			COMMIT TRAN SaveError

			--����ѭ��
			BREAK;
		END CATCH

		--ת����һ���α꣬û�л���ѭ��
        fetch next from cur_FeedList into @rowId, @SubAssemblyPartId, @InvId, @SubInvId, @Lot, @Qty;  
    end    
    close cur_FeedList  --�ر��α�
    deallocate cur_FeedList   --�ͷ��α�

	IF (@countError = 0)
	BEGIN
		IF @@TRANCOUNT > 0
			COMMIT TRAN ;
		RETURN;
	END
	ELSE
	BEGIN
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN;
		set @ReturnValue = 'Ͷ�ϵ�ȷ�ϴ��ڴ��󣬾�����鿴������Ϣ��';
		RETURN;
	END;

	--IF (@countError > 0)
	--BEGIN
	--	set @ReturnValue = 'Ͷ�ϵ�ȷ�ϳɹ�:' + CONVERT(varchar, @countOK) + '�У�ʧ��:' + CONVERT(varchar, @countError) + '�У�������鿴������Ϣ��';
	--	RETURN;
	--END
END

GO

/****** Object:  StoredProcedure [dbo].[P_WMS_ConfirmInventory]    Script Date: 2019/5/11 21:00:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[P_WMS_ConfirmInventory] --�̵����
	@UserId varchar(50),
	@HeadId int,	--�̵�ͷ���ID
	@ReturnValue	varchar(50) OUTPUT

AS
BEGIN
	SET NOCOUNT ON;
	set xact_abort on   

	DECLARE @now datetime = getdate()
	DECLARE @Count int;
	DECLARE @InventoryBillNum varchar(50);

	--��ѯ���̵���״̬�Ƿ�Ϊ�������ɡ�
	select @Count = count(*) from WMS_Inventory_H
							where id = @HeadId
							  and InventoryStatus = '������';
	IF (@Count <> 1)
	BEGIN
		;
		THROW 51000, '��ǰ�̵��״̬���ǡ������ɡ�����ȷ�ϣ�', 1;
		RETURN;
	END;


	--��ѯ�Ƿ����ʵ����С��0������
	select @Count = count(*) from WMS_Inventory_D id
							where id.HeadId = @HeadId
							  and id.InventoryQty < 0;
	IF (@Count > 0)
	BEGIN
		update WMS_Inventory_D set ConfirmMessage = 'ʵ����С��0���޷������̵������'
				from WMS_Inventory_D id
				where id.HeadId = @HeadId
					and id.InventoryQty < 0;
		THROW 51000, '����ʵ����С��0����ȷ�ϣ�', 1;
		RETURN;
	END;

	--�ж��̵�������ϵ������Ƿ��ͻ�������κͷǿ�����ͬʱ����
	select InvId, SubInvId, PartId
		INTO #id_lot
		from
		(
			select InvId, SubInvId, PartId,
					case when Isnull(Lot, '') = '' then 0
							 else 1
							 end LotType
				--INTO #id_lot
				from WMS_Inventory_D
				where HeadId = @HeadId
				group by InvId, SubInvId, PartId,
						case when Isnull(Lot, '') = '' then 0
							 else 1
							 end
		) lot
		group by lot.InvId, lot.SubInvId, lot.PartId
		having count(*) > 1;
	select count(*) from #id_lot;
	IF (@Count > 0)
	BEGIN
		update WMS_Inventory_D set ConfirmMessage = '�̵����ϵ����δ��ڳ�ͻ�������κͷǿ�����ͬʱ���ڡ����޷������̵������'
				from WMS_Inventory_D id,
					 #id_lot id_lot
				where id.InvId = id_lot.InvId
					and isnull(id.SubInvId, 0) = isnull(id_lot.SubInvId, 0)
					and id.PartId = id_lot.PartId
					and id.HeadId = @HeadId;
		THROW 51000, '�̵����ϵ����δ��ڳ�ͻ�������κͷǿ�����ͬʱ���ڡ�����ȷ�ϣ�', 1;
		RETURN;
	END;

	--��ѯ�Ƿ����ʵ����<�����������ݣ��������д�������Ϣ�󱨴�
	select @Count = count(*) from WMS_Inventory_D id,
								  WMS_Inv inv
							where id.InvId = inv.InvId
							  and isnull(id.SubInvId, 0) = isnull(inv.SubInvId, 0)
							  and id.PartId = inv.PartId
							  and isnull(id.Lot, 0) = isnull(inv.Lot, 0)
							  and id.HeadId = @HeadId
							  and id.InventoryQty < inv.StockQty;
	IF (@Count > 0)
	BEGIN
		update WMS_Inventory_D set ConfirmMessage = 'ʵ����С�ڱ��������޷������̵������'
				from WMS_Inventory_D id,
					 WMS_Inv inv
				where id.InvId = inv.InvId
					and isnull(id.SubInvId, 0) = isnull(inv.SubInvId, 0)
					and id.PartId = inv.PartId
					and isnull(id.Lot, 0) = isnull(inv.Lot, 0)
					and id.HeadId = @HeadId
					and id.InventoryQty < inv.StockQty;
		THROW 51000, '����ʵ����С�ڱ����������ݣ���ȷ�ϣ�', 1;
		RETURN;
	END;

	BEGIN TRAN

	--��ȡ�̵��ͷ�ĵ��ݱ��
	select @InventoryBillNum = InventoryBillNum
		from WMS_Inventory_H
		 where Id = @HeadId;

	--�������¼��
	INSERT INTO WMS_InvRecord (PartId,
								Lot,
								QTY,
								InvId,
								SubInvId,
								BillId,
								SourceBill,
								OperateDate,
								Type,
								OperateMan
								)
				SELECT id.PartId,
						id.Lot,
						id.InventoryQty - id.SnapshootQty,
						id.InvId,
						id.SubInvId,	
						id.Id,
						@InventoryBillNum,
						@now,
						'�̵����',
						@UserId
						FROM WMS_Inventory_D id
						WHERE id.HeadId = @HeadId
	IF (@@ERROR <> 0)
	BEGIN
		set @ReturnValue = '�������¼ʱ����'
		ROLLBACK TRAN
		RETURN
	END

	--�޸�������
	MERGE INTO WMS_Inv AS inv
		USING (SELECT * FROM WMS_Inventory_D WHERE HeadId = @HeadId)  AS id
		ON (id.InvId = inv.InvId
			and isnull(id.SubInvId, 0) = isnull(inv.SubInvId, 0)
			and id.PartId = inv.PartId
			and isnull(id.Lot, 0) = isnull(inv.Lot, 0)
			)
		WHEN MATCHED
			THEN UPDATE SET inv.Qty = inv.Qty + (id.InventoryQty - id.SnapshootQty)
		WHEN NOT MATCHED
			THEN INSERT (InvId,
						SubInvId,
						PartId,
						Lot,
						Qty,
						StockQty) 
					VALUES(id.InvId,
							id.SubInvId,
							id.PartId,
							id.Lot,
							id.InventoryQty,
							0);
	IF (@@ERROR <> 0)
	BEGIN
		set @ReturnValue = '�޸Ŀ��������ʱ����'
		ROLLBACK TRAN
		RETURN
	END

	--�޸��̵��״̬
	update WMS_Inventory_H set InventoryStatus = '��ȷ��',
								ModifyPerson = @UserId,
								ModifyTime = @now
			where Id = @HeadId;


	COMMIT TRAN
	RETURN

END

GO

/****** Object:  StoredProcedure [dbo].[P_WMS_ConfirmReturnOrder]    Script Date: 2019/5/11 21:00:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [dbo].[P_WMS_ConfirmReturnOrder]
	@UserId varchar(50),
	@ReturnOrderNum	varchar(50),
	@ReturnValue	varchar(50) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	set xact_abort on   

	DECLARE @now datetime = getdate()
	DECLARE @PartId int;
	DECLARE @InvId int;
	DECLARE @SubInvId int;
	DECLARE @Lot varchar(50);
	DECLARE @Qty decimal(10, 3);
	DECLARE @rowId int;


	BEGIN TRAN

	--�޸Ŀ�棺ֻ��InvId��Ϊ�յļ�¼�޸Ŀ�棨�ֹ������Ŀ���˻����������ݲ��ϸ��������ɵ��˻�����û�н�����ġ�
	DECLARE cur_ReturnOrder cursor for (select rod.Id, ro.PartId, ro.InvId, ro.SubInvId, ro.Lot, rod.ReturnQty * -1
											from WMS_ReturnOrder_D rod,
											     WMS_ReturnOrder ro
											where rod.ReturnOrderDNum = @ReturnOrderNum
											  and rod.PrintStaus = '���˻�'
											  and rod.ConfirmStatus = 'δȷ��'
											  and rod.HeadId = ro.Id
											  and ro.InvId is not null);
    --���α�--
    open cur_ReturnOrder;
    --��ʼѭ���α����--
    fetch next from cur_ReturnOrder into @rowId, @PartId, @InvId, @SubInvId, @Lot, @Qty;
    while @@FETCH_STATUS = 0    --���ر� FETCH���ִ�е�����α��״̬--
    begin            
		exec P_WMS_UpdateInvQty @UserId, @PartId, @InvId, null, @Lot, 0, 0, @Qty, @now, '�˻�', @rowId, @ReturnOrderNum
		--ת����һ���α꣬û�л���ѭ��
        fetch next from cur_ReturnOrder into @rowId, @PartId, @InvId, @SubInvId, @Lot, @Qty;  
    end    
    close cur_ReturnOrder  --�ر��α�
    deallocate cur_ReturnOrder   --�ͷ��α�


	--�޸�ʵ���˻���״̬
	update WMS_ReturnOrder_D set ConfirmStatus = '��ȷ��', ConfirmMan = @UserId, ConfirmDate = @now,
                ModifyPerson = @UserId, ModifyTime = @now
          where ReturnOrderDNum = @ReturnOrderNum
		    and PrintStaus = '���˻�'
			and ConfirmStatus = 'δȷ��';
	IF (@@ERROR <> 0)
	BEGIN
		;
		THROW 51000, '�޸�ʵ���˻���״̬ʱ����', 1;
		RETURN
	END

	COMMIT TRAN
	RETURN
END
GO

/****** Object:  StoredProcedure [dbo].[P_WMS_ConfirmSaleOrder]    Script Date: 2019/5/11 21:00:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE     PROCEDURE [dbo].[P_WMS_ConfirmSaleOrder]
	@UserId varchar(50),
	@SellBillNum	varchar(50),
	@ReturnValue	varchar(50) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	set xact_abort on   

	DECLARE @now datetime = getdate()
	DECLARE @PartId int;
	DECLARE @InvId int;
	DECLARE @SubInvId int;
	DECLARE @Lot varchar(50);
	DECLARE @Qty decimal(10, 3);
	DECLARE @rowId int;
	DECLARE @countOK int = 0;
	DECLARE @countError int = 0;

	BEGIN TRAN

	--�޸Ŀ��
	DECLARE cur_SaleOrder cursor for (select Id, PartId, InvId, SubInvId, Lot, Qty * -1
											from WMS_Sale_Order
											where SellBillNum = @SellBillNum
											  and PrintStaus = '�Ѵ�ӡ'
											  and ConfirmStatus = 'δȷ��');
    --���α�--
    open cur_SaleOrder;
    --��ʼѭ���α����--
    fetch next from cur_SaleOrder into @rowId, @PartId, @InvId, @SubInvId, @Lot, @Qty;
    while @@FETCH_STATUS = 0    --���ر� FETCH���ִ�е�����α��״̬--
    begin         
		BEGIN TRY   
			--BEGIN TRAN

			exec P_WMS_UpdateInvQty @UserId, @PartId, @InvId, null, @Lot, 0, 1, @Qty, @now, '����', @rowId, @SellBillNum;

			--�޸�Ͷ�ϵ��е�ȷ��״̬
			update WMS_Sale_Order set ConfirmStatus = '��ȷ��', ConfirmMan = @UserId, ConfirmDate = @now,
					ConfirmMessage = '',
					ModifyPerson = @UserId, ModifyTime = @now
					where Id = @rowId;

			set @countOK = @countOK + 1;
			--COMMIT TRAN;
 		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0
				ROLLBACK TRAN ;

			--���������Ϣ
			BEGIN TRAN SaveError
			set @countError = @countError + 1;
			update WMS_Sale_Order set ConfirmMessage = ERROR_MESSAGE(),
					ModifyPerson = @UserId, ModifyTime = @now
					where Id = @rowId;
			COMMIT TRAN SaveError

			--����ѭ��
			BREAK;
		END CATCH

		--ת����һ���α꣬û�л���ѭ��
        fetch next from cur_SaleOrder into @rowId, @PartId, @InvId, @SubInvId, @Lot, @Qty;  
    end    
    close cur_SaleOrder  --�ر��α�
    deallocate cur_SaleOrder   --�ͷ��α�

	IF (@countError = 0)
	BEGIN
		IF @@TRANCOUNT > 0
			COMMIT TRAN ;
		RETURN;
	END
	ELSE
	BEGIN
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN;
		set @ReturnValue = '���۶���ȷ�ϴ��ڴ��󣬾�����鿴������Ϣ��';
		RETURN;
	END;

	--IF (@countError > 0)
	--BEGIN
	--	set @ReturnValue = '���۶���ȷ�ϳɹ�:' + CONVERT(varchar, @countOK) + '�У�ʧ��:' + CONVERT(varchar, @countError) + '�У�������鿴������Ϣ��';
	--	RETURN;
	--END
END

GO

/****** Object:  StoredProcedure [dbo].[P_WMS_CreateBatchReturnInspection]    Script Date: 2019/5/11 21:00:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE     PROCEDURE [dbo].[P_WMS_CreateBatchReturnInspection]
	@UserId varchar(50),
	@JsonReturnInspection NVARCHAR(MAX), --��ѡ����˻�����¼
	@ReturnInspectionNum	varchar(50) OUTPUT,
	@ReturnValue	varchar(50) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	set xact_abort on   

	DECLARE @now date = getdate();
	DECLARE @count int;
	DECLARE @InvId int;
	DECLARE @CheckOutResult varchar(50);

	--���浽��ʱ��
	SELECT *
		INTO #ReturnInspection
		FROM OPENJSON(@JsonReturnInspection)  
			WITH (	PartCustomerCode nvarchar(50),
					PartId int,
					CustomerId int,
					SupplierId int,
					Qty decimal(10, 3),
					PCS nvarchar(50),
					Volume nvarchar(50),
					Remark nvarchar(200)
				) 
	IF (@@ERROR <> 0)
	BEGIN
		set @ReturnValue = '��ʱ������Ϣʱ����'
		RETURN
	END

	select @count = count(*) from #ReturnInspection
		where PartId is null;
	IF (@count > 0)
	BEGIN
		;
		THROW 51000, '��������IdΪ�յļ�¼����ȷ�ϣ�', 1;
		RETURN;
	END;

	select @count = count(*) from #ReturnInspection
		where CustomerId is null;
	IF (@count > 0)
	BEGIN
		;
		THROW 51000, '���ڿͻ�IdΪ�յļ�¼����ȷ�ϣ�', 1;
		RETURN;
	END;

	select @count = count(*) from #ReturnInspection ri, WMS_Part p
		where ri.PartId = p.Id
		  and p.PartType = '�⹺��'
		  and SupplierId is null;
	IF (@count > 0)
	BEGIN
		;
		THROW 51000, '���ڹ�Ӧ��IdΪ�յ��⹺����¼����ȷ�ϣ�', 1;
		RETURN;
	END;

	select @count = count(*) from #ReturnInspection
		where Qty <= 0;
	IF (@count > 0)
	BEGIN
		;
		THROW 51000, '�����˻�����С��0�ļ�¼����ȷ�ϣ�', 1;
		RETURN;
	END;

	--�ȳ�ʼ����ǰ���ڡ���ǰtype��Num��Ҫ������ʼ֮ǰִ�У�
	exec P_WMS_InitNumForDay 'THJ', 'WMS_ReturnInspection', @now

	BEGIN TRAN

	--��ȡ��ǰ�ĵ��ݱ��
	exec P_WMS_GetMaxNum 'THJ', 'WMS_ReturnInspection', @now, @ReturnInspectionNum output

	--��ȡĬ�Ͽⷿ
	select top 1 @InvId = Id from WMS_InvInfo
		where Status = '��Ч'
		  and IsDefault = 1;

	--��ֵ��Ĭ�ϵļ�����
	set @CheckOutResult = '�ϸ�';

	INSERT INTO WMS_ReturnInspection (ReturnInspectionNum,
								PartCustomerCode,
								PartCustomerCodeName,
								PartID,
								CustomerId,
								SupplierId,
								Qty,
								PCS,
								Volume,
								Remark,
								QualifyQty,
								NoQualifyQty,
								CheckOutResult,
								InvId,

								PrintStatus,
								PrintDate,
								PrintMan,
								InspectStatus,
								ConfirmStatus,

								CreatePerson,
								CreateTime
								) 
						SELECT	@ReturnInspectionNum,
								PartCustomerCode,
								'',
								PartId,
								CustomerId,
								SupplierId,
								Qty,
								case when isnull(PCS, '') = '' then null else convert(decimal(19,2), PCS) end,
								case when isnull(Volume, '') = '' then null else convert(decimal(19,2), Volume) end,
								Remark,
								Qty,	--Ĭ�Ϻϸ�
								0,
								@CheckOutResult,
								@InvId,

								'�Ѵ�ӡ',
								@now,
								@UserId,
								'δ����',
								'δȷ��',

								@UserId,
								@now
							FROM #ReturnInspection;
	IF (@@ERROR <> 0)
	BEGIN
		set @ReturnValue = '�����˻�����¼ʱ����'
		RETURN
	END


	COMMIT TRAN
	RETURN
END
GO

/****** Object:  StoredProcedure [dbo].[P_WMS_CreateBatchReturnOrder]    Script Date: 2019/5/11 21:00:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[P_WMS_CreateBatchReturnOrder]
	@UserId varchar(50),
	@JsonReturnOrder NVARCHAR(MAX), --��ѡ��Ҫ�˻����˻���¼
	--@ReturnOrderNum	varchar(50) OUTPUT,
	@ReturnValue	varchar(50) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	set xact_abort on   

	DECLARE @now date = getdate();
	DECLARE @count int;

	--���浽��ʱ��
	SELECT *
		INTO #ReturnOrder
		FROM OPENJSON(@JsonReturnOrder)  
			WITH (	PartId int,
					SupplierId int,
					InvId int,
					Lot varchar(50),
					AdjustQty decimal(10, 3),
					Remark nvarchar(200)
				) 
	IF (@@ERROR <> 0)
	BEGIN
		set @ReturnValue = '��ʱ������Ϣʱ����'
		RETURN
	END

	select @count = count(*) from #ReturnOrder
		where PartId is null;
	IF (@count > 0)
	BEGIN
		;
		THROW 51000, '��������IdΪ�յļ�¼����ȷ�ϣ�', 1;
		RETURN;
	END;

	select @count = count(*) from #ReturnOrder
		where SupplierId is null;
	IF (@count > 0)
	BEGIN
		;
		THROW 51000, '���ڹ�Ӧ��IdΪ�յļ�¼����ȷ�ϣ�', 1;
		RETURN;
	END;

	select @count = count(*) from #ReturnOrder
		where InvId is null;
	IF (@count > 0)
	BEGIN
		;
		THROW 51000, '���ڿⷿIdΪ�յļ�¼����ȷ�ϣ�', 1;
		RETURN;
	END;

	select @count = count(*) from #ReturnOrder
		where Lot is null;
	IF (@count > 0)
	BEGIN
		;
		THROW 51000, '��������Ϊ�յļ�¼����ȷ�ϣ�', 1;
		RETURN;
	END;

	BEGIN TRAN

	INSERT INTO WMS_ReturnOrder (
								PartID,
								Lot,
								SupplierId,
								InvId,
								SubInvId,
								ReturnQty,
								AdjustQty,
								Status,
								Remark,
								CreatePerson,
								CreateTime
								) 
						SELECT	
								PartId,
								Lot,
								SupplierId,
								InvId,
								null,
								AdjustQty,
								0,
								'��Ч',
								Remark,
								@UserId,
								@now
							FROM #ReturnOrder;
	IF (@@ERROR <> 0)
	BEGIN
		set @ReturnValue = '�����˻���¼ʱ����'
		RETURN
	END


	COMMIT TRAN
	RETURN
END
GO

/****** Object:  StoredProcedure [dbo].[P_WMS_CreateInspectBill]    Script Date: 2019/5/11 21:00:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [dbo].[P_WMS_CreateInspectBill]
	-- Add the parameters for the stored procedure here
	@UserId varchar(50),
	@ArrivalBillNum varchar(50),
	@InspectBillNum varchar(50) output
AS
BEGIN
	SET NOCOUNT ON;
	set xact_abort on   

	--DECLARE @billNum varchar(50)
	DECLARE @now date = getdate()
	DECLARE @defaultInvId int

	--�ȳ�ʼ����ǰ���ڡ���ǰtype��Num��Ҫ������ʼ֮ǰִ�У�
	exec P_WMS_InitNumForDay 'SJ', 'WMS_AI', @now

	BEGIN TRAN

	--��ȡ��ǰ�ĵ��ݱ��
	exec P_WMS_GetMaxNum 'SJ', 'WMS_AI', @now, @InspectBillNum output

	SELECT top 1 @defaultInvId = Id from WMS_InvInfo
		WHERE Status = '��Ч' AND IsDefault = 1

	update WMS_AI set InspectBillNum = @InspectBillNum,
					  InspectMan = @UserId,
					  InspectDate = @now,
					  InspectStatus = '���ͼ�',
					  CheckOutDate = @now,
					  InvId = @defaultInvId,
					  InStoreStatus = 'δ���'
			where ArrivalBillNum = @ArrivalBillNum


	COMMIT TRAN
END

GO

/****** Object:  StoredProcedure [dbo].[P_WMS_CreateInventoryLine]    Script Date: 2019/5/11 21:00:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[P_WMS_CreateInventoryLine]
	@UserId varchar(50),
	@HeadId int,
	@JsonInvList NVARCHAR(MAX), --�̵�Ŀⷿ
	@ReturnValue	varchar(500) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	set xact_abort on   

	DECLARE @InspectBillNum varchar(50)
	DECLARE @now date = getdate();
	DECLARE @InventoryStatus nvarchar(10);

	select @InventoryStatus = InventoryStatus
		from WMS_Inventory_H
		where id = @HeadId;
	IF (@InventoryStatus <> 'δ����')
	BEGIN
		;
		THROW 51000, '�̵�������ɣ���ȷ�ϣ�', 1;
		RETURN
	END;


	--���̵�Ŀⷿ���浽��ʱ��
	SELECT *
		INTO #InvList
		FROM OPENJSON(@JsonInvList)  
			WITH (	Id int
				);
	IF (@@ERROR <> 0)
	BEGIN
		set @ReturnValue = '��ʱ�����̵�ⷿʱ����'
		RETURN
	END

	BEGIN TRAN

	--�����̵��б�
	insert into WMS_Inventory_D (HeadId,
								PartId,
								InvId,
								SubInvId,
								Lot,
								SnapshootQty,
								InventoryQty,
								CreatePerson,
								CreateTime
								)
					select		@HeadId,
								PartId,
								InvId,
								SubInvId,
								Lot,
								Qty,
								0,
								@UserId,
								@now
						from WMS_Inv inv
						where qty+stockqty>0 and inv.InvId in (select id from #InvList);

	--�޸��̵�ͷ��״̬
	update WMS_Inventory_H set InventoryStatus = '������',
								ModifyPerson = @UserId,
								ModifyTime = @now
			where Id = @HeadId;

	COMMIT TRAN
	RETURN
END

GO

/****** Object:  StoredProcedure [dbo].[P_WMS_CreateInvHistory]    Script Date: 2019/5/11 21:00:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--������ʷ���
CREATE PROCEDURE [dbo].[P_WMS_CreateInvHistory]
	@UserId varchar(50),
	@InvHistoryTitle nvarchar(100),
	@InvHistoryStatus nvarchar(10),
	@Remark nvarchar(200),
	--@ReturnOrderNum	varchar(50) OUTPUT,
	@ReturnValue	varchar(50) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	set xact_abort on   

	DECLARE @now datetime = getdate()
	DECLARE @rowId int

	BEGIN TRAN

	--�����˻���¼���˻�����Ϊ�գ���ӡʱ�������˻����ţ�
	INSERT INTO WMS_Inv_History_H (
								InvHistoryTitle,
								InvHistoryStatus,
								Remark,
								CreatePerson,
								CreateTime
								) 
						VALUES	(
								@InvHistoryTitle,
								@InvHistoryStatus,
								@Remark,
								@UserId,
								@now
								);
	IF (@@ERROR <> 0)
	BEGIN
		set @ReturnValue = '������ʷ����¼ʱ����'
		RETURN
	END
	set @rowId = @@IDENTITY

	--������ʷ�����б�
	insert into WMS_Inv_History_D (HeadId,
								PartId,
								InvId,
								SubInvId,
								SnapshootQty,
								CreatePerson,
								CreateTime
								)
					select		@rowId,
								PartId,
								InvId,
								SubInvId,
								sum(Qty),
								@UserId,
								@now
						from WMS_Inv inv
						group by PartId,
								InvId,
								SubInvId;

	IF (@@ERROR <> 0)
	BEGIN
		set @ReturnValue = '������ʷ����¼ʱ����'
		RETURN
	END

	COMMIT TRAN
	RETURN
END
GO

/****** Object:  StoredProcedure [dbo].[P_WMS_CreateReInspect]    Script Date: 2019/5/11 21:00:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [dbo].[P_WMS_CreateReInspect]
	@UserId varchar(50),
	@AIID int,
	@NCheckOutResult nvarchar(50),
	@NQualifyQty decimal(10, 3),
	@NNoQualifyQty decimal(10, 3),
	@NCheckOutRemark nvarchar(100),
	@NCheckOutDate datetime,
	@Remark nvarchar(100),
	@ReturnValue	varchar(50) OUTPUT

AS
BEGIN
	SET NOCOUNT ON;
	set xact_abort on   

	DECLARE @now datetime = getdate();
	DECLARE @rowId int
	DECLARE @SupplierId int;
	DECLARE @PartId int;
	DECLARE @InvId int;
	DECLARE @SubInvId int;
	DECLARE @Lot varchar(50);
	DECLARE @OQualifyQty decimal(10, 3);
	DECLARE @ONoQualifyQty decimal(10, 3);
	DECLARE @qty decimal(10, 3);
	DECLARE @NoQualifyQty decimal(10, 3);

	BEGIN TRAN

	SELECT @PartId = ai.PartId,
			@SupplierId = po.SupplierId,
			@InvId = ai.InvId,
			@SubInvId = ai.SubInvId,
			@Lot = ai.Lot,
			@OQualifyQty = ai.QualifyQty,
			@ONoQualifyQty = ai.NoQualifyQty
		FROM WMS_AI ai,
			WMS_PO po
		WHERE ai.POId = po.Id
		  and ai.Id = @AIID;

	--����ReInspect��
	INSERT INTO WMS_ReInspect (AIId,
							OCheckOutResult,
							OQualifyQty,
							ONoQualifyQty,
							OCheckOutRemark,
							OCheckOutDate,
							NCheckOutResult,
							NQualifyQty,
							NNoQualifyQty,
							NCheckOutRemark,
							NCheckOutDate,
							Remark,
							AdjustMan,
							AdjustDate,
							CreatePerson,
							CreateTime
							)
			SELECT @AIID,
					CheckOutResult,
					QualifyQty,
					NoQualifyQty,
					CheckOutRemark,
					CheckOutDate,
					@NCheckOutResult,
					@NQualifyQty,
					@NNoQualifyQty,
					@NCheckOutRemark,
					@NCheckOutDate,
					@Remark,
					@UserId,
					@now,
					@UserId,
					@now
				FROM WMS_AI
				WHERE Id = @AIID;
	IF (@@ERROR <> 0)
	BEGIN
		set @ReturnValue = '���������ͼ��¼ʱ����'
		ROLLBACK TRAN
		RETURN
	END
	set @rowId = @@IDENTITY

	--�޸�AI��
	UPDATE WMS_AI set CheckOutDate = @NCheckOutDate,
						CheckOutResult = @NCheckOutResult,
						QualifyQty = @NQualifyQty,
						NoQualifyQty = @NNoQualifyQty,
						CheckOutRemark = @NCheckOutRemark,
						ModifyPerson = @UserId,
						ModifyTime = @now
				WHERE Id = @AIID;
	IF (@@ERROR <> 0)
	BEGIN
		set @ReturnValue = '�޸ļ����¼ʱ����'
		ROLLBACK TRAN
		RETURN
	END

	--�޸Ŀ�棺��������=������-������
	set @qty = @NQualifyQty - @OQualifyQty;
	exec P_WMS_UpdateInvQty @UserId, @PartId, @InvId, @SubInvId, @Lot, 0, 0, @qty, @now, '�����ͼ�', @rowId, null

	--�����˻���¼
	set @NoQualifyQty = @NNoQualifyQty - @ONoQualifyQty;
	IF (@NoQualifyQty <> 0)
	BEGIN
		INSERT INTO WMS_ReturnOrder (AIID,
									ReInspectID,
									PartID,
									Lot,
									SupplierId,
									ReturnQty,
									AdjustQty,
									Status,
									--PrintStaus,
									CreatePerson,
									CreateTime
									--ConfirmStatus
									)
				VALUES (@AIID,
						@rowId,
						@PartId,
						@Lot,
						@SupplierId,
						@NoQualifyQty,
						0,
						'��Ч',
						--'δ�˻�',
						@UserId,
						@now
						--'δȷ��'
						);
	END;

	COMMIT TRAN
	RETURN
END

GO

/****** Object:  StoredProcedure [dbo].[P_WMS_CreateReturnOrder]    Script Date: 2019/5/11 21:00:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--�ֹ������˻���
CREATE PROCEDURE [dbo].[P_WMS_CreateReturnOrder]
	@UserId varchar(50),
	@PartId int,
	@SupplierId int,
	@InvId int,
	@Lot varchar(50),
	@Qty decimal(10, 3),
	@Remark nvarchar(200),
	--@ReturnOrderNum	varchar(50) OUTPUT,
	@ReturnValue	varchar(50) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	set xact_abort on   

	DECLARE @now datetime = getdate()
	DECLARE @rowId int

	--�ȳ�ʼ����ǰ���ڡ���ǰtype��Num��Ҫ������ʼ֮ǰִ�У�
	--exec P_WMS_InitNumForDay 'TH', 'WMS_ReturnOrder', @now

	BEGIN TRAN

	--��ȡ��ǰ�ĵ��ݱ��
	--exec P_WMS_GetMaxNum 'TH', 'WMS_ReturnOrder', @now, @ReturnOrderNum output

	--�����˻���¼���˻�����Ϊ�գ���ӡʱ�������˻����ţ�
	INSERT INTO WMS_ReturnOrder (--ReturnOrderNum,
								PartID,
								Lot,
								SupplierId,
								InvId,
								SubInvId,
								ReturnQty,
								AdjustQty,
								Status,
								Remark,
								--PrintStaus,
								CreatePerson,
								CreateTime
								--ConfirmStatus
								) 
						VALUES	(--@ReturnOrderNum,
								@PartId,
								@Lot,
								@SupplierId,
								@InvId,
								null,
								@Qty,
								0,
								'��Ч',
								@Remark,
								--'δ�˻�',
								@UserId,
								@now
								--'δȷ��'
								);
	IF (@@ERROR <> 0)
	BEGIN
		set @ReturnValue = '�����˻���¼ʱ����'
		RETURN
	END
	set @rowId = @@IDENTITY

	--�޸Ŀ�棺ֻ��AIIDΪ�յļ�¼�޸Ŀ�棨�ֹ��������˻����������ݲ��ϸ��������ɵ��˻�����û�н�����ġ�
	--��ȷ���˻���ʱ���޸Ŀ��
	--exec P_WMS_UpdateInvQty @UserId, @PartId, @InvId, null, @Qty, @now, '����', @rowId, null

	--�������¼��
	--INSERT INTO WMS_InvRecord (PartId,
	--							QTY,
	--							InvId,
	--							SubInvId,
	--							BillId,
	--							SourceBill,
	--							OperateDate,
	--							Type,
	--							OperateMan
	--							)
	--			SELECT ro.PartId,
	--					ro.AdjustQty,
	--					ro.InvId,
	--					ro.SubInvId,	
	--					ro.Id,
	--					null,
	--					@now,
	--					'�˿�',
	--					@UserId
	--					FROM WMS_ReturnOrder ro
	--					WHERE ro.Id = @rowId
	--					 AND  ro.AIID IS NULL
	--IF (@@ERROR <> 0)
	--BEGIN
	--	set @ReturnValue = '�������¼ʱ����'
	--	ROLLBACK TRAN
	--	RETURN
	--END

	----�޸�������
	--UPDATE WMS_Inv SET Qty = Qty - ro.AdjustQty
	--	FROM WMS_Inv inv,
	--		WMS_ReturnOrder ro
	--	WHERE inv.InvId = ro.InvId
	--		AND Isnull(inv.SubInvId, 0) = Isnull(ro.SubInvId, 0)
	--		AND inv.PartId = ro.PartId
	--		AND ro.Id = @rowId
	--		AND  ro.AIID IS NULL
	--IF (@@ERROR <> 0)
	--BEGIN
	--	set @ReturnValue = '�޸Ŀ��������ʱ����'
	--	ROLLBACK TRAN
	--	RETURN
	--END


	COMMIT TRAN
	RETURN
END

GO

/****** Object:  StoredProcedure [dbo].[p_wms_deleteTestData]    Script Date: 2019/5/11 21:00:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_wms_deleteTestData]
AS
BEGIN
delete wms_inv
delete WMS_InvRecord
delete WMS_Feed_List;
delete WMS_Sale_Order;
delete WMS_ReturnOrder_d;
delete WMS_ReturnOrder;
delete WMS_Inv_Adjust;
delete WMS_Product_Entry;
delete WMS_ReInspect;
delete WMS_Inventory_D;
delete WMS_Inventory_H;
delete [WMS_AI]
delete wms_po
delete WMS_Inv_History_D;
delete WMS_Inv_History_H;
end

GO

/****** Object:  StoredProcedure [dbo].[P_WMS_GetMaxNum]    Script Date: 2019/5/11 21:00:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[P_WMS_GetMaxNum]
	@Type varchar(50),
	@Tabname varchar(50),
	@Now date,
	@Result nvarchar(50) output 
AS
BEGIN
	SET NOCOUNT ON;

	declare @count int
	declare @maxNum int

	--��ȡ���ݱ��
	select @count = count(*) from WMS_Num t
		where t.Type = @Type and t.TabName = @Tabname  and t.Day = @Now
	IF (@count = 0)
	BEGIN
		set @maxNum = 0
		--begin tran
		insert into WMS_Num (Num, Day, Type, TabName, MinNum, MaxNum)
			values (@maxNum, @Now, @Type, @Tabname, 0, 9999)
		--commit tran
	END

	--�޸ĵ�ǰ�ĵ��ݱ��
	update WMS_Num set Num = Num + 1 
		where Type = @type and Day = @now

	select @maxNum = Num from WMS_Num t
		where t.Type = @Type and t.Day = @Now


	set @Result = @Type + CONVERT(varchar(8), @Now, 112) + replace(right(str(@maxNum), 4),' ','0')

END

GO

/****** Object:  StoredProcedure [dbo].[P_WMS_InitNumForDay]    Script Date: 2019/5/11 21:00:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[P_WMS_InitNumForDay]
	@Type varchar(50),
	@Tabname varchar(50),
	@Now date
AS
BEGIN
	SET NOCOUNT ON;

	declare @count int
	declare @maxNum int

	--��ȡ���ݱ��
	select @count = count(*) from WMS_Num t
		where t.Type = @Type and t.TabName = @Tabname  and t.Day = @Now
	IF (@count = 0)
	BEGIN
		set @maxNum = 0
		insert into WMS_Num (Num, Day, Type, TabName, MinNum, MaxNum)
			values (@maxNum, @Now, @Type, @Tabname, 0, 9999)
	END
END

GO

/****** Object:  StoredProcedure [dbo].[P_WMS_InvAdjust]    Script Date: 2019/5/11 21:00:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE   PROCEDURE [dbo].[P_WMS_InvAdjust]
	-- Add the parameters for the stored procedure here
	@UserId varchar(50),
	@PartId int,
	@InvId int,
	@Lot nvarchar(50),
	@AdjustQty decimal(10, 3),
	@AdjustType nvarchar(50),
	@Remark nvarchar(200),
	@InvAdjustBillNum	varchar(50) OUTPUT,
	@ReturnValue	varchar(500) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	set xact_abort on   
	
	DECLARE @now datetime = getdate()
	DECLARE @rowId int
	DECLARE @count int

	--�ȳ�ʼ����ǰ���ڡ���ǰtype��Num��Ҫ������ʼ֮ǰִ�У�
	exec P_WMS_InitNumForDay 'TZ', 'WMS_Inv_Adjust', @now

	BEGIN TRAN 

	--��ȡ��ǰ�ĵ��ݱ��
	exec P_WMS_GetMaxNum 'TZ', 'WMS_Inv_Adjust', @now, @InvAdjustBillNum output

	--������˼�¼
	INSERT INTO WMS_Inv_Adjust (InvAdjustBillNum,
								PartID,
								InvId,
								SubInvId,
								AdjustQty,
								AdjustType,
								Remark,
								CreatePerson,
								CreateTime) 
						VALUES	(@InvAdjustBillNum,
								@PartId,
								@InvId,
								null,
								@AdjustQty,
								@AdjustType,
								@Remark,
								@UserId,
								@now
								);
	IF (@@ERROR <> 0)
	BEGIN
		set @ReturnValue = '������˼�¼ʱ����'
		ROLLBACK TRAN
		RETURN
	END
	set @rowId = @@IDENTITY

	--�޸Ŀ�棺
	exec P_WMS_UpdateInvQty @UserId, @PartId, @InvId, null, @Lot, 1, 0,
		@AdjustQty, @now, '����', @rowId, @InvAdjustBillNum

	COMMIT TRAN
	RETURN

END

GO

/****** Object:  StoredProcedure [dbo].[P_WMS_InvStock]    Script Date: 2019/5/11 21:00:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE       PROCEDURE [dbo].[P_WMS_InvStock]	--��汸��
	@UserId varchar(50),
	@PartId int,
	@InvId int,
	@SubInvId int,
	@Lot varchar(50),
	@Qty decimal(10, 3),
	@now datetime,
	@type varchar(50),
	@BillId int,
	@SourceBill varchar(50)
AS
BEGIN
	DECLARE @AllowNegativeInv bit = 0; --�Ƿ�������棬Ĭ�Ϸ�
	DECLARE @Count int;
	DECLARE @rowId int;
	DECLARE @InvQty decimal(10, 3) = 0;
	DECLARE @StockQty decimal(10, 3) = 0;
	DECLARE @CurrentQty decimal(10, 3) = 0;	--��ǰ�۳�����
	DECLARE @ResidueQty decimal(10, 3) = 0; --ʣ������

	IF (@Qty = 0)
	BEGIN
		;
		THROW 51000, '��汸������Ϊ0����ȷ�ϣ�', 1;
		RETURN;
	END;
	
	--�޸Ŀ�汸����
	IF (@Qty > 0)
	BEGIN
		;
		THROW 51000, '���ҵ���ܽ��б��ϲ�������ȷ�ϣ�', 1;
		RETURN;
	END


	--���ٿ�棺������Ϊ�գ����Ƚ��ȳ���ԭ����б��ϣ������ηǿ�ʱ��ֻ��ָ�����ν��б���
	IF (@Qty < 0)
	BEGIN
		IF (@Lot IS NOT NULL) --���β�Ϊ��
		BEGIN
			SELECT @Count = count(*), @InvQty = SUM(Qty - Isnull(StockQty, 0)) FROM WMS_Inv
				WHERE InvId = @InvId
					AND Isnull(SubInvId, 0) = Isnull(@SubInvId, 0)
					AND PartId = @PartId
					AND Isnull(Lot, 0) = Isnull(@Lot, 0);
			IF (@Qty < 0 AND IsNull(@InvQty, 0) < ABS(@Qty) AND @AllowNegativeInv = 0)	--�����ٿ�桢�Ҳ�������桢�ҿ������������ʱ���׳��쳣
			BEGIN
				;
				THROW 51000, '��ǰ���εĿ�����������㣬��ȷ�ϣ�', 1;
				RETURN;
			END
		END

		IF (@Lot IS NULL) --����Ϊ��
		BEGIN
			SELECT @Count = count(*), @InvQty = SUM(Qty - Isnull(StockQty, 0)) FROM WMS_Inv
				WHERE InvId = @InvId
					AND Isnull(SubInvId, 0) = Isnull(@SubInvId, 0)
					AND PartId = @PartId;
			IF (@Qty < 0 AND IsNull(@InvQty, 0) < ABS(@Qty) AND @AllowNegativeInv = 0)	--�����ٿ�桢�Ҳ�������桢�ҿ������������ʱ���׳��쳣
			BEGIN
				;
				THROW 51000, '������������㣬��ȷ�ϣ�', 1;
				RETURN;
			END
		END

		--ʹ���α꣬���Ƚ��ȳ���ԭ����
		DECLARE cur_Inv cursor for select Id, Qty, Isnull(StockQty, 0)
												from WMS_Inv
												where InvId = @InvId
													AND Isnull(SubInvId, 0) = Isnull(@SubInvId, 0)
													AND PartId = @PartId
													AND Isnull(Lot, 0) = Isnull(@Lot, Isnull(Lot, 0))
													AND Qty - Isnull(StockQty, 0) > 0
											Order By Lot;
		set @ResidueQty = ABS(@Qty);
		--���α�--
		open cur_Inv;
		--��ʼѭ���α����--
		fetch next from cur_Inv into @rowId, @InvQty, @StockQty;
		while @@FETCH_STATUS = 0    --���ر� FETCH���ִ�е�����α��״̬--
		begin         
			IF (@InvQty - @StockQty < @ResidueQty)
			BEGIN
				set @CurrentQty = @InvQty - @StockQty;
			END
			ELSE
			BEGIN
				set @CurrentQty = @ResidueQty;
			END;
			set @ResidueQty = @ResidueQty - @CurrentQty;

			--�޸Ŀ�汸����
			UPDATE WMS_Inv SET StockQty = Isnull(StockQty, 0) + @CurrentQty
				WHERE Id = @rowId;
			--�������¼��
			INSERT INTO WMS_InvRecord (PartId,
										Lot,
										QTY,
										InvId,
										SubInvId,
										BillId,
										SourceBill,
										OperateDate,
										Type,
										OperateMan,
										Stock_InvId,
										StockStatus
										)
								VALUES (@PartId,
										@Lot,
										@CurrentQty,
										@InvId,
										@SubInvId,	
										@BillId,
										@SourceBill,
										@now,
										@type,
										@UserId,
										@rowId,
										2);


			IF (@ResidueQty > 0)
			BEGIN
				--ת����һ���α꣬û�л���ѭ��
				fetch next from cur_Inv into @rowId, @InvQty, @StockQty; 
			END
			ELSE
			BEGIN
				BREAK;
			END;
		end    
		close cur_Inv  --�ر��α�
		deallocate cur_Inv   --�ͷ��α�
	END
END

GO

/****** Object:  StoredProcedure [dbo].[P_WMS_InvStock_BatchUpdate]    Script Date: 2019/5/11 21:00:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE     PROCEDURE [dbo].[P_WMS_InvStock_BatchUpdate]	--��汸��
	@UserId varchar(50),
	@PartId int,
	@InvId int,
	@SubInvId int,
	@Lot varchar(50),
	@Qty decimal(10, 3)
AS
BEGIN
	DECLARE @AllowNegativeInv bit = 0; --�Ƿ�������棬Ĭ�Ϸ�
	DECLARE @Count int;
	DECLARE @InvQty decimal(10, 3);

	IF (@Qty = 0)
	BEGIN
		;
		THROW 51000, '��汸������Ϊ0����ȷ�ϣ�', 1;
		RETURN;
	END;
	
	--�޸Ŀ�汸����
	IF (@Qty > 0)
	BEGIN
		;
		THROW 51000, '���ҵ���ܽ��б��ϲ�������ȷ�ϣ�', 1;
		RETURN;
	END


	--���ٿ�棺������Ϊ�գ����Ƚ��ȳ���ԭ����б��ϣ������ηǿ�ʱ��ֻ��ָ�����ν��б���
	IF (@Qty < 0)
	BEGIN
		IF (@Lot IS NOT NULL) --���β�Ϊ��
		BEGIN
			SELECT @Count = count(*), @InvQty = SUM(Qty - Isnull(StockQty, 0)) FROM WMS_Inv
				WHERE InvId = @InvId
					AND Isnull(SubInvId, 0) = Isnull(@SubInvId, 0)
					AND PartId = @PartId
					AND Isnull(Lot, 0) = Isnull(@Lot, 0);
			IF (@Qty < 0 AND IsNull(@InvQty, 0) < ABS(@Qty) AND @AllowNegativeInv = 0)	--�����ٿ�桢�Ҳ�������桢�ҿ������������ʱ���׳��쳣
			BEGIN
				;
				THROW 51000, '��ǰ���εĿ�����������㣬��ȷ�ϣ�', 1;
				RETURN;
			END

			--���ӱ�����
			UPDATE WMS_Inv SET StockQty = Isnull(StockQty, 0) + ABS(@Qty)
				WHERE InvId = @InvId
					AND Isnull(SubInvId, 0) = Isnull(@SubInvId, 0)
					AND PartId = @PartId
					AND Isnull(Lot, 0) = Isnull(@Lot, 0);
		END

		IF (@Lot IS NULL) --����Ϊ��
		BEGIN
			SELECT @Count = count(*), @InvQty = SUM(Qty - Isnull(StockQty, 0)) FROM WMS_Inv
				WHERE InvId = @InvId
					AND Isnull(SubInvId, 0) = Isnull(@SubInvId, 0)
					AND PartId = @PartId;
			IF (@Qty < 0 AND IsNull(@InvQty, 0) < ABS(@Qty) AND @AllowNegativeInv = 0)	--�����ٿ�桢�Ҳ�������桢�ҿ������������ʱ���׳��쳣
			BEGIN
				;
				THROW 51000, '������������㣬��ȷ�ϣ�', 1;
				RETURN;
			END

			--�ۼ���棺�Ƚ��ȳ�
			UPDATE WMS_Inv SET StockQty = StockQty +
					CASE WHEN (SELECT ABS(@Qty) - Isnull(SUM(t.Qty - Isnull(t.StockQty, 0)), 0) 
								FROM WMS_Inv t
								WHERE t.InvId = @InvId
									AND Isnull(t.SubInvId, 0) = Isnull(@SubInvId, 0)
									AND t.PartId = @PartId
									AND Isnull(t.Lot, 0) <= Isnull(inv.Lot, 0)
									AND t.Qty > 0) >= 0
						THEN Qty - Isnull(StockQty, 0)
						ELSE CASE WHEN (SELECT ABS(@Qty) - Isnull(SUM(t.Qty - Isnull(t.StockQty, 0)), 0) 
										FROM WMS_Inv t
										WHERE t.InvId = @InvId
											AND Isnull(t.SubInvId, 0) = Isnull(@SubInvId, 0)
											AND t.PartId = @PartId
											AND Isnull(t.Lot, 0) < Isnull(inv.Lot, 0)
											AND t.Qty > 0) < 0
								THEN 0
								ELSE (SELECT ABS(@Qty) - Isnull(SUM(t.Qty - Isnull(t.StockQty, 0)), 0) 
										FROM WMS_Inv t
										WHERE t.InvId = @InvId
											AND Isnull(t.SubInvId, 0) = Isnull(@SubInvId, 0)
											AND t.PartId = @PartId
											AND Isnull(t.Lot, 0) < Isnull(inv.Lot, 0)
											AND t.Qty > 0)
								END
						END,
					OutQty = 
					CASE WHEN (SELECT ABS(@Qty) - Isnull(SUM(t.Qty - Isnull(t.StockQty, 0)), 0) 
								FROM WMS_Inv t
								WHERE t.InvId = @InvId
									AND Isnull(t.SubInvId, 0) = Isnull(@SubInvId, 0)
									AND t.PartId = @PartId
									AND Isnull(t.Lot, 0) <= Isnull(inv.Lot, 0)
									AND t.Qty > 0) >= 0
						THEN Qty - Isnull(StockQty, 0)
						ELSE CASE WHEN (SELECT ABS(@Qty) - Isnull(SUM(t.Qty - Isnull(t.StockQty, 0)), 0) 
										FROM WMS_Inv t
										WHERE t.InvId = @InvId
											AND Isnull(t.SubInvId, 0) = Isnull(@SubInvId, 0)
											AND t.PartId = @PartId
											AND Isnull(t.Lot, 0) < Isnull(inv.Lot, 0)
											AND t.Qty > 0) < 0
								THEN 0
								ELSE (SELECT ABS(@Qty) - Isnull(SUM(t.Qty - Isnull(t.StockQty, 0)), 0) 
										FROM WMS_Inv t
										WHERE t.InvId = @InvId
											AND Isnull(t.SubInvId, 0) = Isnull(@SubInvId, 0)
											AND t.PartId = @PartId
											AND Isnull(t.Lot, 0) < Isnull(inv.Lot, 0)
											AND t.Qty > 0)
								END
						END
				FROM WMS_Inv inv
				WHERE inv.InvId = @InvId
					AND Isnull(inv.SubInvId, 0) = Isnull(@SubInvId, 0)
					AND inv.PartId = @PartId;
		END
	END
END

GO

/****** Object:  StoredProcedure [dbo].[P_WMS_PrintFeedList]    Script Date: 2019/5/11 21:00:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [dbo].[P_WMS_PrintFeedList]
	@UserId varchar(50),
	@FeedBillNum nvarchar(50),
	@Id int,	--���@Id = 0����ʾ�ǵ�һ�δ�ӡ�������ݣ���Ҫ���ɵ��ݺţ����<>0�����ʾ�ڶ��δ�ӡ���ϡ�
	@ReleaseBillNum	varchar(50) OUTPUT,
	@ReturnValue	varchar(50) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	set xact_abort on   

	DECLARE @now date = getdate()
	DECLARE @SubAssemblyPartId int;
	DECLARE @InvId int;
	DECLARE @SubInvId int;
	DECLARE @Lot varchar(50);
	DECLARE @Qty decimal(10, 3);
	DECLARE @rowId int;
	DECLARE @countOK int = 0;
	DECLARE @countError int = 0;

	--�ȳ�ʼ����ǰ���ڡ���ǰtype��Num��Ҫ������ʼ֮ǰִ�У�
	--exec P_WMS_InitNumForDay 'TL', 'WMS_Feed_List', @now

	BEGIN TRAN

	--��ȡ��ǰ�ĵ��ݱ�ţ����@Id = 0����ʾ�ǵ�һ�δ�ӡ�������ݣ���Ҫ���ɵ��ݺ�
	IF (@Id = 0)
	BEGIN
		exec P_WMS_GetMaxNum 'TL', 'WMS_Feed_List', @now, @ReleaseBillNum output
	END
	ELSE
	BEGIN
		select @ReleaseBillNum = ReleaseBillNum
			from WMS_Feed_List
			where Id = @Id;
	END;

	--���п�汸��
	DECLARE cur_FeedList cursor for (select Id, SubAssemblyPartId, InvId, SubInvId, Lot, FeedQty * -1
											from WMS_Feed_List
											where IIF(@Id = 0, FeedBillNum, CONVERT(VARCHAR, Id)) = IIF(@Id = 0, @FeedBillNum, CONVERT(VARCHAR, @Id))
											  and PrintStaus = 'δ��ӡ');
    --���α�--
    open cur_FeedList;
    --��ʼѭ���α����--
    fetch next from cur_FeedList into @rowId, @SubAssemblyPartId, @InvId, @SubInvId, @Lot, @Qty;
    while @@FETCH_STATUS = 0    --���ر� FETCH���ִ�е�����α��״̬--
    begin         
		BEGIN TRY   
			--�ж�Ͷ�����������0������
			IF (@Qty >= 0)
			BEGIN
				;
				THROW 51000, '��ǰͶ����Ϊ�������㣬��ȷ�ϣ�', 1;
			END;

			exec P_WMS_InvStock @UserId, @SubAssemblyPartId, @InvId, null, @Lot, @Qty, @now, 'Ͷ��', @rowId, @ReleaseBillNum;

			--�޸�Ͷ�ϵ��еĴ�ӡ״̬
			update WMS_Feed_List set ReleaseBillNum = @ReleaseBillNum,
					PrintStaus = '�Ѵ�ӡ', PrintMan = @UserId, PrintDate = @now,
					ConfirmMessage = '',
					ModifyPerson = @UserId, ModifyTime = @now
					where Id = @rowId;

			set @countOK = @countOK + 1;
 		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0
				ROLLBACK TRAN;

			--���������Ϣ
			BEGIN TRAN SaveError
			set @countError = @countError + 1;
			update WMS_Feed_List set ConfirmMessage = ERROR_MESSAGE(),
					ModifyPerson = @UserId, ModifyTime = @now
					where Id = @rowId;
			COMMIT TRAN SaveError

			--����ѭ��
			BREAK;
		END CATCH

		--ת����һ���α꣬û�л���ѭ��
        fetch next from cur_FeedList into @rowId, @SubAssemblyPartId, @InvId, @SubInvId, @Lot, @Qty;  
    end    
    close cur_FeedList  --�ر��α�
    deallocate cur_FeedList   --�ͷ��α�

	IF (@countError = 0)
	BEGIN
		IF @@TRANCOUNT > 0
			COMMIT TRAN;
		RETURN;
	END
	ELSE
	BEGIN
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN;
		set @ReturnValue = 'Ͷ�ϵ����ϴ��ڴ��󣬾�����鿴������Ϣ��';
		RETURN;
	END;

	--IF (@countError > 0)
	--BEGIN
	--	set @ReturnValue = 'Ͷ�ϵ����ϳɹ�:' + CONVERT(varchar, @countOK) + '�У�ʧ��:' + CONVERT(varchar, @countError) + '�У�������鿴������Ϣ��';
	--	RETURN;
	--END
END

GO

/****** Object:  StoredProcedure [dbo].[P_WMS_PrintReturnOrder]    Script Date: 2019/5/11 21:00:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [dbo].[P_WMS_PrintReturnOrder]
	@UserId varchar(50),
	@JsonReturnOrder NVARCHAR(MAX), --��ѡ��Ҫ��ӡ���˻���¼
	@ReturnOrderNum	varchar(50) OUTPUT,
	@ReturnValue	varchar(50) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	set xact_abort on   

	DECLARE @now date = getdate()
	DECLARE @batchId int

	--�ȳ�ʼ����ǰ���ڡ���ǰtype��Num��Ҫ������ʼ֮ǰִ�У�
	exec P_WMS_InitNumForDay 'TH', 'WMS_ReturnOrder', @now

	--�����������浽��ʱ��
	SELECT *
		INTO #ReturnOrder
		FROM OPENJSON(@JsonReturnOrder)  
			WITH (	Id int,
					Qty decimal(10, 3),
					Remark nvarchar(200)
				) 
	IF (@@ERROR <> 0)
	BEGIN
		set @ReturnValue = '��ʱ���������Ϣʱ����'
		RETURN
	END

	BEGIN TRAN

	--�޸ı��BatchId���Խ���������⣨�����ˣ�
	--SELECT @batchId = NEXT VALUE FOR S_WMS_BatchId;
	--update WMS_ReturnOrder set BatchId = @batchId
	--		FROM WMS_ReturnOrder ro,
	--			 #ReturnOrder t
	--		WHERE ro.Id = t.Id
	--		  AND BatchId is null
	--IF (@@ERROR <> 0)
	--BEGIN
	--	set @ReturnValue = '�޸�BatchIdʱ����'
	--	RETURN
	--END

	--��ȡ��ǰ�ĵ��ݱ��
	exec P_WMS_GetMaxNum 'TH', 'WMS_ReturnOrder', @now, @ReturnOrderNum output

	--����ʵ���˻���WMS_ReturnOrder_D
	insert into WMS_ReturnOrder_D (
								ReturnOrderDNum,
								HeadId,
								ReturnQty,
								Remark,
								PrintStaus,
								PrintDate,
								PrintMan,
								ConfirmStatus,
								CreatePerson,
								CreateTime
								)
					select @ReturnOrderNum,
							t.Id,
							t.Qty,
							t.Remark,
							'���˻�',
							@now,
							@UserId,
							'δȷ��',
							@UserId,
							@now
						from #ReturnOrder t
	IF (@@ERROR <> 0)
	BEGIN
		set @ReturnValue = '����ʵ���˻���¼ʱ����'
		RETURN
	END

	--�޸Ĵ��˻����ʵ���˻�������WMS_ReturnOrder
	update WMS_ReturnOrder set --ReturnOrderNum = @ReturnOrderNum,
								AdjustQty = ro.AdjustQty + t.Qty,
								--Remark = t.Remark,
								--PrintStaus = '���˻�',
								--PrintDate = @now,
								--PrintMan = @UserId,
								ModifyPerson = @UserId,
								ModifyTime = @now
			FROM WMS_ReturnOrder ro,
				 #ReturnOrder t
			WHERE ro.Id = t.Id
				--AND ro.BatchId = @batchId
	IF (@@ERROR <> 0)
	BEGIN
		set @ReturnValue = '������˻���¼ʱ����'
		RETURN
	END


	COMMIT TRAN
	RETURN


END

GO

/****** Object:  StoredProcedure [dbo].[P_WMS_PrintReturnOrder1]    Script Date: 2019/5/11 21:00:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[P_WMS_PrintReturnOrder1]
	@UserId varchar(50),
	@ReturnOrderNum	varchar(50),
	@ReturnValue	varchar(50) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	set xact_abort on   

	DECLARE @now date = getdate()

	BEGIN TRAN

	--�޸��˻���״̬
	UPDATE WMS_ReturnOrder set PrintStaus = '���˻�',
								PrintDate = @now,
								PrintMan = @UserId,
								ModifyPerson = @UserId,
								ModifyTime = @now
			WHERE ReturnOrderNum = @ReturnOrderNum
	IF (@@ERROR <> 0)
	BEGIN
		set @ReturnValue = '�����˻���¼ʱ����'
		RETURN
	END

	--�޸Ŀ�棺ֻ��AIIDΪ�յļ�¼�޸Ŀ�棨�ֹ��������˻����������ݲ��ϸ��������ɵ��˻�����û�н�����ġ�
	--�������¼��
	INSERT INTO WMS_InvRecord (PartId,
								QTY,
								InvId,
								SubInvId,
								BillId,
								SourceBill,
								OperateDate,
								Type,
								OperateMan
								)
				SELECT ro.PartId,
						ro.AdjustQty,
						ro.InvId,
						ro.SubInvId,	
						ro.Id,
						@ReturnOrderNum,
						@now,
						'�˿�',
						@UserId
						FROM WMS_ReturnOrder ro
						WHERE ro.ReturnOrderNum = @ReturnOrderNum
						 AND  ro.AIID IS NULL
	IF (@@ERROR <> 0)
	BEGIN
		set @ReturnValue = '�������¼ʱ����'
		ROLLBACK TRAN
		RETURN
	END

	--�޸�������
	UPDATE WMS_Inv SET Qty = Qty - ro.AdjustQty
		FROM WMS_Inv inv,
			WMS_ReturnOrder ro
		WHERE inv.InvId = ro.InvId
			AND Isnull(inv.SubInvId, 0) = Isnull(ro.SubInvId, 0)
			AND inv.PartId = ro.PartId
			AND ro.ReturnOrderNum = @ReturnOrderNum
			AND  ro.AIID IS NULL
	IF (@@ERROR <> 0)
	BEGIN
		set @ReturnValue = '�޸Ŀ��������ʱ����'
		ROLLBACK TRAN
		RETURN
	END


	COMMIT TRAN
	RETURN
END

GO

/****** Object:  StoredProcedure [dbo].[P_WMS_PrintSaleOrder]    Script Date: 2019/5/11 21:00:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE     PROCEDURE [dbo].[P_WMS_PrintSaleOrder]
	@UserId varchar(50),
	@SaleBillNum nvarchar(50),
	@Id int,	--���@Id = 0����ʾ�ǵ�һ�δ�ӡ�������ݣ���Ҫ���ɵ��ݺţ���� <> 0�����ʾ�ڶ��δ�ӡ���ϡ�
	@SellBillNum	varchar(50) OUTPUT,
	@ReturnValue	varchar(50) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	set xact_abort on   

	DECLARE @now date = getdate()
	DECLARE @PartId int;
	DECLARE @InvId int;
	DECLARE @SubInvId int;
	DECLARE @Lot varchar(50);
	DECLARE @Qty decimal(10, 3);
	DECLARE @rowId int;
	DECLARE @countOK int = 0;
	DECLARE @countError int = 0;

	--�ȳ�ʼ����ǰ���ڡ���ǰtype��Num��Ҫ������ʼ֮ǰִ�У�
	--exec P_WMS_InitNumForDay 'TL', 'WMS_Feed_List', @now

	BEGIN TRAN

	--��ȡ��ǰ�ĵ��ݱ�ţ����@Id = 0����ʾ�ǵ�һ�δ�ӡ�������ݣ���Ҫ���ɵ��ݺ�
	IF (@Id = 0)
	BEGIN
		exec P_WMS_GetMaxNum 'XS', 'WMS_Sale_Order', @now, @SellBillNum output;
	END
	ELSE
	BEGIN
		select @SellBillNum = SellBillNum
			from WMS_Sale_Order
			where Id = @Id;
	END;

	--���п�汸��
	DECLARE cur_SaleOrder cursor for (select Id, PartId, InvId, SubInvId, Lot, Qty * -1
											from WMS_Sale_Order
											where IIF(@Id = 0, SaleBillNum, CONVERT(VARCHAR, Id)) = IIF(@Id = 0, @SaleBillNum, CONVERT(VARCHAR, @Id))
											  and PrintStaus = 'δ��ӡ');
    --���α�--
    open cur_SaleOrder;
    --��ʼѭ���α����--
    fetch next from cur_SaleOrder into @rowId, @PartId, @InvId, @SubInvId, @Lot, @Qty;
    while @@FETCH_STATUS = 0    --���ر� FETCH���ִ�е�����α��״̬--
    begin         
		BEGIN TRY   
			--�ж����۶������������0������
			IF (@Qty >= 0)
			BEGIN
				;
				THROW 51000, '��ǰ���۶�����Ϊ�������㣬��ȷ�ϣ�', 1;
			END;

			--BEGIN TRAN

			exec P_WMS_InvStock @UserId, @PartId, @InvId, null, @Lot, @Qty, @now, '����', @rowId, @SellBillNum;

			--�޸�Ͷ�ϵ��еĴ�ӡ״̬
			update WMS_Sale_Order set SellBillNum = @SellBillNum,
					PrintStaus = '�Ѵ�ӡ', PrintMan = @UserId, PrintDate = @now,
					ConfirmMessage = '',
					ModifyPerson = @UserId, ModifyTime = @now
					where Id = @rowId;

			set @countOK = @countOK + 1;
			--COMMIT TRAN;
 		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0
				ROLLBACK TRAN ;

			--���������Ϣ
			BEGIN TRAN SaveError
			set @countError = @countError + 1;
			update WMS_Sale_Order set ConfirmMessage = ERROR_MESSAGE(),
					ModifyPerson = @UserId, ModifyTime = @now
					where Id = @rowId;
			COMMIT TRAN SaveError

			--����ѭ��
			BREAK;
		END CATCH

		--ת����һ���α꣬û�л���ѭ��
        fetch next from cur_SaleOrder into @rowId, @PartId, @InvId, @SubInvId, @Lot, @Qty;  
    end    
    close cur_SaleOrder  --�ر��α�
    deallocate cur_SaleOrder   --�ͷ��α�

	IF (@countError = 0)
	BEGIN
		IF @@TRANCOUNT > 0
			COMMIT TRAN ;
		RETURN;
	END
	ELSE
	BEGIN
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN;
		set @ReturnValue = '���۶������ϴ��ڴ��󣬾�����鿴������Ϣ��';
		RETURN;
	END;

	--IF (@countError > 0)
	--BEGIN
	--	set @ReturnValue = '���۶������ϳɹ�:' + CONVERT(varchar, @countOK) + '�У�ʧ��:' + CONVERT(varchar, @countError) + '�У�������鿴������Ϣ��';
	--	RETURN;
	--END
END

GO

/****** Object:  StoredProcedure [dbo].[P_WMS_ProcessInspectBill]    Script Date: 2019/5/11 21:00:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [dbo].[P_WMS_ProcessInspectBill]
	@UserId varchar(50),
	@JsonInspectBill NVARCHAR(MAX), --������
	@ReturnValue	varchar(50) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	set xact_abort on   

	DECLARE @InspectBillNum varchar(50)
	DECLARE @now date = getdate()
	DECLARE @count int
	DECLARE @InStoreBillNum varchar(50)
	DECLARE @ReturnOrderNum varchar(50)

	--�ȳ�ʼ����ǰ���ڡ���ǰtype��Num��Ҫ������ʼ֮ǰִ�У�
	exec P_WMS_InitNumForDay 'RK', 'WMS_AI', @now

	--�����������浽��ʱ��
	SELECT *
		INTO #InspectBill
		FROM OPENJSON(@JsonInspectBill)  
			WITH (	Id int,
					POId int,
					PartId int,
					Lot nvarchar(50),
					InspectBillNum nvarchar(50),
					CheckOutDate date,
					CheckOutResult nvarchar(50),
					QualifyQty decimal(10, 3),
					InvId int,
					SubInvId int,
					NoQualifyQty decimal(10, 3),
					CheckOutRemark nvarchar(50)
				) 
	IF (@@ERROR <> 0)
	BEGIN
		set @ReturnValue = '��ʱ���������Ϣʱ����'
		RETURN
	END

	--���ݼ�������ʼ�������������Ŀ���Ǵ������������������������У��ᵼ�³�ʼ�����ֻ����������ɺ�����ύ�������ڲ�����������������֮ǰ���������ύ����������ͬʱ�Կ�������������޸ġ�
	INSERT INTO WMS_Inv (InvId,
						SubInvId,
						PartId,
						Lot,
						Qty,
						StockQty
						)
			SELECT	ib.InvId,	
					ib.SubInvId,	
					ib.PartId,
					ib.Lot,
					0,
					0
					FROM #InspectBill ib
					WHERE ib.QualifyQty <> 0
						AND not exists (
										SELECT 1 FROM WMS_Inv inv
											WHERE inv.InvId = ib.InvId
												AND Isnull(inv.SubInvId, 0) = Isnull(ib.SubInvId, 0)
												AND inv.PartId = ib.PartId
												AND Isnull(inv.Lot, 0) = Isnull(ib.Lot, 0)
										)
	IF (@@ERROR <> 0)
	BEGIN
		set @ReturnValue = '��ʼ���������ʱ����'
		RETURN
	END


	BEGIN TRAN


	SELECT top 1 @InspectBillNum = InspectBillNum FROM #InspectBill

	--��ȡ��ⵥ��
	exec P_WMS_GetMaxNum 'RK', 'WMS_AI', @now, @InStoreBillNum output

	--���������
	update WMS_AI SET	--WMS_AI.InspectStatus = '���ͼ�',
						WMS_AI.CheckOutDate = t.CheckOutDate,
						WMS_AI.CheckOutResult = t.CheckOutResult,
						WMS_AI.QualifyQty = t.QualifyQty,
						WMS_AI.NoQualifyQty = t.NoQualifyQty,
						WMS_AI.CheckOutRemark = t.CheckOutRemark,
						WMS_AI.InStoreBillNum = @InStoreBillNum,
						WMS_AI.InStoreStatus = '�����',
						WMS_AI.InStoreMan = @UserId,
						WMS_AI.InvId = t.InvId,
						WMS_AI.SubInvId = t.SubInvId,
						WMS_AI.ModifyPerson = @UserId,
						WMS_AI.ModifyTime = @now
					FROM #InspectBill t,
						WMS_AI
					WHERE WMS_AI.Id = t.Id
							AND WMS_AI.InspectBillNum = @InspectBillNum
	IF (@@ERROR <> 0)
	BEGIN
		set @ReturnValue = '���������Ϣʱ����'
		ROLLBACK TRAN
		RETURN
	END


	--�Ժϸ�����������⴦��
	SELECT @count = count(*) FROM #InspectBill
		WHERE QualifyQty <> 0
	IF (@count > 0)
	BEGIN
		--�������¼��
		INSERT INTO WMS_InvRecord (PartId,
									Lot,
									QTY,
									InvId,
									SubInvId,
									BillId,
									SourceBill,
									OperateDate,
									Type,
									OperateMan
									)
					SELECT ib.PartId,
							ib.Lot,
							ib.QualifyQty,
							ib.InvId,
							ib.SubInvId,	
							ib.Id,
							@InStoreBillNum,
							@now,
							'���',
							@UserId
							FROM #InspectBill ib
							WHERE ib.QualifyQty <> 0
		IF (@@ERROR <> 0)
		BEGIN
			set @ReturnValue = '�������¼ʱ����'
			ROLLBACK TRAN
			RETURN
		END

		--�޸�������
		UPDATE WMS_Inv SET Qty = Qty + ib.QualifyQty
			FROM WMS_Inv inv,
				#InspectBill ib
			WHERE inv.InvId = ib.InvId
				AND Isnull(inv.SubInvId, 0) = Isnull(ib.SubInvId, 0)
				AND inv.PartId = ib.PartId
				AND Isnull(inv.Lot, 0) = Isnull(ib.Lot, 0)
				AND ib.QualifyQty <> 0
		IF (@@ERROR <> 0)
		BEGIN
			set @ReturnValue = '�޸Ŀ��������ʱ����'
			ROLLBACK TRAN
			RETURN
		END
	END


	--�Բ��ϸ����������˿⴦��
	SELECT @count = count(*) FROM #InspectBill
		WHERE NoQualifyQty <> 0
	IF (@count > 0)
	BEGIN
		--�����˻���¼
		INSERT INTO WMS_ReturnOrder (AIID,
									PartID,
									Lot,
									SupplierId,
									ReturnQty,
									AdjustQty,
									Status,
									--PrintStaus,
									CreatePerson,
									CreateTime
									--ConfirmStatus
									)
				SELECT ib.Id,
						ib.PartId,
						null,
						po.SupplierId,
						ib.NoQualifyQty,
						0,
						'��Ч',
						--'δ�˻�',
						@UserId,
						@now
						--'δȷ��'
					FROM #InspectBill ib,
							WMS_PO po
					WHERE ib.POId = po.Id
						AND ib.NoQualifyQty <> 0

	END


	COMMIT TRAN
	RETURN
END

GO

/****** Object:  StoredProcedure [dbo].[P_WMS_ProcessProductEntry]    Script Date: 2019/5/11 21:00:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [dbo].[P_WMS_ProcessProductEntry]
	@UserId varchar(50),
	@ProductBillNum nvarchar(100), --���Ƽ���ⵥ�ţ�ҵ��
	@ReturnValue	varchar(50) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	set xact_abort on   

	DECLARE @EntryBillNum varchar(50)
	DECLARE @now date = getdate()
	DECLARE @count int

	SELECT @count = count(*) FROM WMS_Product_Entry pe
					WHERE pe.ProductQty <> 0
						AND pe.ProductBillNum = @ProductBillNum
						AND pe.EntryBillNum is null
	IF (@count = 0)
	BEGIN
		set @ReturnValue = 'û���ҵ�ָ������ⵥ��'
		RETURN
	END

	--�ȳ�ʼ����ǰ���ڡ���ǰtype��Num��Ҫ������ʼ֮ǰִ�У�
	exec P_WMS_InitNumForDay 'RK', 'WMS_Product_Entry', @now

	--���ݼ�������ʼ�������������Ŀ���Ǵ������������������������У��ᵼ�³�ʼ�����ֻ����������ɺ�����ύ�������ڲ�����������������֮ǰ���������ύ����������ͬʱ�Կ�������������޸ġ�
	INSERT INTO WMS_Inv (InvId,
						SubInvId,
						PartId,
						Lot,
						Qty,
						StockQty
						)
			SELECT	pe.InvId,	
					pe.SubInvId,	
					pe.PartId,
					pe.Lot,
					0,
					0
					FROM WMS_Product_Entry pe
					WHERE pe.ProductQty <> 0
						AND pe.ProductBillNum = @ProductBillNum
						AND pe.EntryBillNum is null
						AND not exists (
										SELECT 1 FROM WMS_Inv inv
											WHERE inv.InvId = pe.InvId
												AND Isnull(inv.SubInvId, 0) = Isnull(pe.SubInvId, 0)
												AND inv.PartId = pe.PartId
												AND Isnull(inv.Lot, 0) = Isnull(pe.Lot, 0)
										);
	IF (@@ERROR <> 0)
	BEGIN
		set @ReturnValue = '��ʼ���������ʱ����'
		RETURN
	END

	BEGIN TRAN

	--��ȡ��ⵥ��
	exec P_WMS_GetMaxNum 'Z', 'WMS_Product_Entry', @now, @EntryBillNum output

	--���������
	update WMS_Product_Entry SET EntryBillNum = @EntryBillNum,
								ModifyPerson = @UserId,
								ModifyTime = @now
					WHERE ProductBillNum = @ProductBillNum
						AND EntryBillNum is null
	IF (@@ERROR <> 0)
	BEGIN
		set @ReturnValue = '���������Ϣʱ����'
		ROLLBACK TRAN
		RETURN
	END

	--�������¼��
	INSERT INTO WMS_InvRecord (PartId,
								Lot,
								QTY,
								InvId,
								SubInvId,
								BillId,
								SourceBill,
								OperateDate,
								Type,
								OperateMan
								)
				SELECT pe.PartId,
						pe.Lot,
						pe.ProductQty,
						pe.InvId,
						pe.SubInvId,	
						pe.Id,
						@EntryBillNum,
						@now,
						'���Ƽ����',
						@UserId
						FROM WMS_Product_Entry pe
						WHERE pe.ProductBillNum = @ProductBillNum
							AND pe.EntryBillNum = @EntryBillNum
	IF (@@ERROR <> 0)
	BEGIN
		set @ReturnValue = '�������¼ʱ����'
		ROLLBACK TRAN
		RETURN
	END

	--�޸�������
	UPDATE WMS_Inv SET Qty = Qty + pe.ProductQty
		FROM WMS_Inv inv,
			WMS_Product_Entry pe
		WHERE inv.InvId = pe.InvId
			AND Isnull(inv.SubInvId, 0) = Isnull(pe.SubInvId, 0)
			AND inv.PartId = pe.PartId
			AND Isnull(inv.Lot, 0) = Isnull(pe.Lot, 0)
			AND pe.ProductBillNum = @ProductBillNum
			AND pe.EntryBillNum = @EntryBillNum
	IF (@@ERROR <> 0)
	BEGIN
		set @ReturnValue = '�޸Ŀ��������ʱ����'
		ROLLBACK TRAN
		RETURN
	END

	COMMIT TRAN
	RETURN
END

GO

/****** Object:  StoredProcedure [dbo].[P_WMS_ProcessReturnInspectBill]    Script Date: 2019/5/11 21:00:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE     PROCEDURE [dbo].[P_WMS_ProcessReturnInspectBill]
	@UserId varchar(50),
	@JsonReturnInspectBill NVARCHAR(MAX), --������
	@ReturnValue	varchar(50) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	set xact_abort on   

	DECLARE @ReturnInspectBillNum varchar(50)
	DECLARE @now date = getdate()
	DECLARE @lot varchar(6) = dbo.F_GetLot(@now);
	DECLARE @count int
	DECLARE @InStoreBillNum varchar(50)
	DECLARE @ReturnOrderNum varchar(50)

	--�ȳ�ʼ����ǰ���ڡ���ǰtype��Num��Ҫ������ʼ֮ǰִ�У�
	exec P_WMS_InitNumForDay 'RK', 'WMS_ReturnInspection', @now

	--�����������浽��ʱ��
	SELECT *
		INTO #ReturnInspectBill
		FROM OPENJSON(@JsonReturnInspectBill)  
			WITH (	Id int,
					PartID int,
					ReturnInspectionNum nvarchar(50),
					SupplierId int,
					InspectDate date,
					CheckOutResult nvarchar(50),
					QualifyQty decimal(10, 3),
					InvId int,
					SubInvId int,
					NoQualifyQty decimal(10, 3)
				) 
	IF (@@ERROR <> 0)
	BEGIN
		set @ReturnValue = '��ʱ���������Ϣʱ����'
		RETURN
	END

	--���ݼ�������ʼ�������������Ŀ���Ǵ������������������������У��ᵼ�³�ʼ�����ֻ����������ɺ�����ύ�������ڲ�����������������֮ǰ���������ύ����������ͬʱ�Կ�������������޸ġ�
	INSERT INTO WMS_Inv (InvId,
						SubInvId,
						PartId,
						Lot,
						Qty,
						StockQty
						)
			SELECT	ib.InvId,	
					ib.SubInvId,	
					ib.PartID,
					@lot,
					0,
					0
					FROM #ReturnInspectBill ib
					WHERE ib.QualifyQty <> 0
						AND not exists (
										SELECT 1 FROM WMS_Inv inv
											WHERE inv.InvId = ib.InvId
												AND Isnull(inv.SubInvId, 0) = Isnull(ib.SubInvId, 0)
												AND inv.PartId = ib.PartID
												AND Isnull(inv.Lot, 0) = @lot
										)
	IF (@@ERROR <> 0)
	BEGIN
		set @ReturnValue = '��ʼ���������ʱ����'
		RETURN
	END


	BEGIN TRAN


	SELECT top 1 @ReturnInspectBillNum = ReturnInspectionNum FROM #ReturnInspectBill

	--��ȡ��ⵥ��
	exec P_WMS_GetMaxNum 'RK', 'WMS_ReturnInspection', @now, @InStoreBillNum output

	--���������
	update WMS_ReturnInspection SET	WMS_ReturnInspection.InspectStatus = '�Ѽ���',
						WMS_ReturnInspection.InspectDate = t.InspectDate,
						WMS_ReturnInspection.CheckOutResult = t.CheckOutResult,
						WMS_ReturnInspection.QualifyQty = t.QualifyQty,
						WMS_ReturnInspection.NoQualifyQty = t.NoQualifyQty,
						WMS_ReturnInspection.InStoreBillNum = @InStoreBillNum,
						WMS_ReturnInspection.InvId = t.InvId,
						WMS_ReturnInspection.SubInvId = t.SubInvId,
						WMS_ReturnInspection.Lot = @lot,
						WMS_ReturnInspection.ModifyPerson = @UserId,
						WMS_ReturnInspection.ModifyTime = @now
					FROM #ReturnInspectBill t,
						WMS_ReturnInspection
					WHERE WMS_ReturnInspection.Id = t.Id
							AND WMS_ReturnInspection.ReturnInspectionNum = @ReturnInspectBillNum
	IF (@@ERROR <> 0)
	BEGIN
		set @ReturnValue = '���������Ϣʱ����'
		ROLLBACK TRAN
		RETURN
	END


	--�Ժϸ�����������⴦��
	SELECT @count = count(*) FROM #ReturnInspectBill
		WHERE QualifyQty <> 0
	IF (@count > 0)
	BEGIN
		--�������¼��
		INSERT INTO WMS_InvRecord (PartId,
									Lot,
									QTY,
									InvId,
									SubInvId,
									BillId,
									SourceBill,
									OperateDate,
									Type,
									OperateMan
									)
					SELECT ib.PartId,
							@lot,
							ib.QualifyQty,
							ib.InvId,
							ib.SubInvId,	
							ib.Id,
							@InStoreBillNum,
							@now,
							'���',
							@UserId
							FROM #ReturnInspectBill ib
							WHERE ib.QualifyQty <> 0
		IF (@@ERROR <> 0)
		BEGIN
			set @ReturnValue = '�������¼ʱ����'
			ROLLBACK TRAN
			RETURN
		END

		--�޸�������
		UPDATE WMS_Inv SET Qty = Qty + ib.QualifyQty
			FROM WMS_Inv inv,
				#ReturnInspectBill ib
			WHERE inv.InvId = ib.InvId
				AND Isnull(inv.SubInvId, 0) = Isnull(ib.SubInvId, 0)
				AND inv.PartId = ib.PartId
				AND Isnull(inv.Lot, 0) = @lot
				AND ib.QualifyQty <> 0
		IF (@@ERROR <> 0)
		BEGIN
			set @ReturnValue = '�޸Ŀ��������ʱ����'
			ROLLBACK TRAN
			RETURN
		END
	END


	--�Բ��ϸ����������˿⴦���������⹺�������й�Ӧ��ID���˻���¼��
	SELECT @count = count(*) FROM #ReturnInspectBill
		WHERE NoQualifyQty <> 0
		  and SupplierId is not null
	IF (@count > 0)
	BEGIN
		--�����˻���¼
		INSERT INTO WMS_ReturnOrder (
									PartID,
									Lot,
									SupplierId,
									ReturnQty,
									AdjustQty,
									Status,
									--PrintStaus,
									CreatePerson,
									CreateTime
									--ConfirmStatus
									)
				SELECT 
						ib.PartId,
						null,
						ib.SupplierId,
						ib.NoQualifyQty,
						0,
						'��Ч',
						--'δ�˻�',
						@UserId,
						@now
						--'δȷ��'
					FROM #ReturnInspectBill ib
					WHERE ib.NoQualifyQty <> 0
					  and ib.SupplierId is not null

	END


	COMMIT TRAN
	RETURN
END

GO

/****** Object:  StoredProcedure [dbo].[P_WMS_SpecialInventory]    Script Date: 2019/5/11 21:00:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[P_WMS_SpecialInventory] --�̵����
	@UserName varchar(50),
	@HeadId int,	--�̵�ͷ���ID
	@ReturnValue	varchar(50) OUTPUT

AS
BEGIN
	SET NOCOUNT ON;
	set xact_abort on   

	DECLARE @now datetime = getdate()
	DECLARE @Count int;
	BEGIN TRAN
	--����ͷ��״̬Ϊ������
	update WMS_Inventory_H set InventoryStatus='������' where Id = @HeadId;
	--������ϵ������������������Σ���ô���Ŀ�������������������	
	MERGE INTO WMS_Inventory_D AS inventory
		USING (SELECT * FROM WMS_Inv where PartId in (select PartId from WMS_Inventory_D where HeadId = @HeadId))  AS inv
		ON (inventory.InvId = inv.InvId
			and isnull(inventory.SubInvId, 0) = isnull(inv.SubInvId, 0)
			and inventory.PartId = inv.PartId
			and isnull(inventory.Lot, 0) = isnull(inv.Lot, 0)
			and inventory.HeadId = @HeadId
			)
		WHEN MATCHED
			THEN UPDATE SET inventory.SnapshootQty = inv.Qty
		WHEN NOT MATCHED and inv.qty+inv.stockqty>0
			THEN INSERT (InvId,
						SubInvId,
						PartId,
						Lot,
						HeadId,
						SnapshootQty,
						InventoryQty,
						CreatePerson,
						CreateTime) 
					VALUES(inv.InvId,
							inv.SubInvId,
							inv.PartId,
							inv.Lot,
							@HeadId,
							inv.Qty,
							0,
							@UserName,
							@now);
	IF (@@ERROR <> 0)
	BEGIN
		set @ReturnValue = '��쵼��ʱ����'
		ROLLBACK TRAN
		RETURN
	END
	COMMIT TRAN
	RETURN

END
GO

/****** Object:  StoredProcedure [dbo].[P_WMS_UnInvStock]    Script Date: 2019/5/11 21:00:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE         PROCEDURE [dbo].[P_WMS_UnInvStock]	--ȡ����汸��
	@UserId varchar(50),
	@now datetime,
	@type varchar(50),
	@BillId int
AS
BEGIN
	DECLARE @Count int;
	DECLARE @rowId int;
	DECLARE @InvQty decimal(10, 3) = 0;
	DECLARE @StockQty decimal(10, 3) = 0;

	--�޸Ŀ���������ı�����
	UPDATE WMS_Inv SET StockQty = inv.StockQty - r.Qty
		FROM WMS_Inv inv,
			WMS_InvRecord r
		WHERE r.Type = @type
			AND r.BillId = @BillId
			AND r.Stock_InvId = inv.Id
			AND r.StockStatus = 2;

	--�������¼��ȡ�����ϲ�����¼
	INSERT INTO WMS_InvRecord (PartId,
								Lot,
								QTY,
								InvId,
								SubInvId,
								BillId,
								SourceBill,
								OperateDate,
								Type,
								OperateMan,
								Stock_InvId,
								StockStatus
								)
						SELECT	r.PartId,
								r.Lot,
								r.Qty * -1,
								r.InvId,
								r.SubInvId,	
								r.BillId,
								r.SourceBill,
								@now,
								r.type,
								@UserId,
								Stock_InvId,
								4
							FROM WMS_InvRecord r
							WHERE r.Type = @type
								AND r.BillId = @BillId
								AND r.Stock_InvId is not null
								AND r.StockStatus = 2;

	--�޸Ŀ���¼����ԭ�б��ϼ�¼��״̬Ϊ3��3-��Ч���ϣ�ȡ�����Ϻ�2�ĳ�3����
	UPDATE WMS_InvRecord SET StockStatus = 3
		WHERE Type = @type
			AND BillId = @BillId
			AND Stock_InvId is not null
			AND StockStatus = 2;

END

GO

/****** Object:  StoredProcedure [dbo].[P_WMS_UnPrintFeedList]    Script Date: 2019/5/11 21:00:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE     PROCEDURE [dbo].[P_WMS_UnPrintFeedList]
	@UserId varchar(50),
	@ReleaseBillNum nvarchar(50),
	@Id int,	
	@ReturnValue	varchar(50) OUTPUT
AS
BEGIN
	DECLARE @now date = getdate()
	DECLARE @rowId int;
	DECLARE @countOK int = 0;
	DECLARE @countError int = 0;

	SET NOCOUNT ON;
	set xact_abort on   

	--���п��ȡ������
	DECLARE cur_FeedList cursor for (select Id
											from WMS_Feed_List
											where IIF(@Id = 0, ReleaseBillNum, CONVERT(VARCHAR, Id)) = IIF(@Id = 0, @ReleaseBillNum, CONVERT(VARCHAR, @Id))
											  and PrintStaus = '�Ѵ�ӡ');
    --���α�--
    open cur_FeedList;
    --��ʼѭ���α����--
    fetch next from cur_FeedList into @rowId;
    while @@FETCH_STATUS = 0    --���ر� FETCH���ִ�е�����α��״̬--
    begin         
		BEGIN TRY   
			BEGIN TRAN

			--ȡ������
			exec P_WMS_UnInvStock @UserId, @now, 'Ͷ��', @rowId;

			--�޸�Ͷ�ϵ��еĴ�ӡ״̬
			update WMS_Feed_List set PrintStaus = 'δ��ӡ', PrintMan = @UserId, PrintDate = @now,
					ConfirmMessage = '',
					ModifyPerson = @UserId, ModifyTime = @now
					where Id = @rowId;

			set @countOK = @countOK + 1;
			COMMIT TRAN;
 		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0
				ROLLBACK TRAN ;

			--����ȷ�ϵĴ�����Ϣ
			set @countError = @countError + 1;
			update WMS_Feed_List set ConfirmMessage = ERROR_MESSAGE(),
					ModifyPerson = @UserId, ModifyTime = @now
					where Id = @rowId;
		END CATCH

		--ת����һ���α꣬û�л���ѭ��
        fetch next from cur_FeedList into @rowId;  
    end    
    close cur_FeedList  --�ر��α�
    deallocate cur_FeedList   --�ͷ��α�

	IF @@TRANCOUNT > 0
		COMMIT TRAN ;

	IF (@countError > 0)
	BEGIN
		set @ReturnValue = 'Ͷ�ϵ����ϳɹ�:' + CONVERT(varchar, @countOK) + '�У�ʧ��:' + CONVERT(varchar, @countError) + '�У�������鿴������Ϣ��';
		RETURN;
	END

END

GO

/****** Object:  StoredProcedure [dbo].[P_WMS_UnPrintSaleOrder]    Script Date: 2019/5/11 21:00:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE     PROCEDURE [dbo].[P_WMS_UnPrintSaleOrder]
	@UserId varchar(50),
	@SellBillNum	varchar(50),
	@Id int,	
	@ReturnValue	varchar(50) OUTPUT
AS
BEGIN
	DECLARE @now date = getdate()
	DECLARE @rowId int;
	DECLARE @countOK int = 0;
	DECLARE @countError int = 0;

	SET NOCOUNT ON;
	set xact_abort on   

		--���п�汸��
	DECLARE cur_SaleOrder cursor for (select Id
											from WMS_Sale_Order
											where IIF(@Id = 0, SellBillNum, CONVERT(VARCHAR, Id)) = IIF(@Id = 0, @SellBillNum, CONVERT(VARCHAR, @Id))
											  and PrintStaus = '�Ѵ�ӡ');
    --���α�--
    open cur_SaleOrder;
    --��ʼѭ���α����--
    fetch next from cur_SaleOrder into @rowId;
    while @@FETCH_STATUS = 0    --���ر� FETCH���ִ�е�����α��״̬--
    begin         
		BEGIN TRY   
			BEGIN TRAN

			--ȡ������
			exec P_WMS_UnInvStock @UserId, @now, '����', @rowId;

			--�޸����۶����еĴ�ӡ״̬
			update WMS_Sale_Order set PrintStaus = 'δ��ӡ', PrintMan = @UserId, PrintDate = @now,
					ConfirmMessage = '',
					ModifyPerson = @UserId, ModifyTime = @now
					where Id = @rowId;

			set @countOK = @countOK + 1;
			COMMIT TRAN;
 		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0
				ROLLBACK TRAN ;

			--����ȷ�ϵĴ�����Ϣ
			set @countError = @countError + 1;
			update WMS_Sale_Order set ConfirmMessage = ERROR_MESSAGE(),
					ModifyPerson = @UserId, ModifyTime = @now
					where Id = @rowId;
		END CATCH

		--ת����һ���α꣬û�л���ѭ��
        fetch next from cur_SaleOrder into @rowId;  
    end    
    close cur_SaleOrder  --�ر��α�
    deallocate cur_SaleOrder   --�ͷ��α�

	IF @@TRANCOUNT > 0
		COMMIT TRAN ;

	IF (@countError > 0)
	BEGIN
		set @ReturnValue = '���۶������ϳɹ�:' + CONVERT(varchar, @countOK) + '�У�ʧ��:' + CONVERT(varchar, @countError) + '�У�������鿴������Ϣ��';
		RETURN;
	END
END

GO

/****** Object:  StoredProcedure [dbo].[P_WMS_UpdateInvQty]    Script Date: 2019/5/11 21:00:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE     PROCEDURE [dbo].[P_WMS_UpdateInvQty]
	@UserId varchar(50),
	@PartId int,
	@InvId int,
	@SubInvId int,
	@Lot varchar(50),
	@AllowAddLot bit,	--�����ӿ��ʱ���Ƿ�������������
	@HasStockQty bit,	--�ڼ��ٿ��ʱ���Ƿ��ѽ��й�����
	@Qty decimal(10, 3),
	@now datetime,
	@type varchar(50),
	@BillId int,
	@SourceBill varchar(50),
	@AllowNegativeInv bit = 0 --�Ƿ�������棬Ĭ�Ϸ�
AS
BEGIN
	--DECLARE @AllowNegativeInv bit = 0; --�Ƿ�������棬Ĭ�Ϸ�
	DECLARE @Count int;
	DECLARE @rowId int;
	DECLARE @InvQty decimal(10, 3);
	DECLARE @StockQty decimal(10, 3) = 0;	--������
	DECLARE @CurrentQty decimal(10, 3) = 0;	--��ǰ�۳�����
	DECLARE @ResidueQty decimal(10, 3) = 0; --ʣ������

	IF (@Qty = 0)
	BEGIN
		;
		THROW 51000, '����޸�����Ϊ0����ȷ�ϣ�', 1;
		RETURN;
	END;
	
	IF (@Lot = '')
	BEGIN
		set @Lot = null;
	END;

	--�޸Ŀ��������
	--���ӿ��
	IF (@Qty > 0)
	BEGIN
		--���ʱ����Ҫ�����κ�
		IF (Isnull(@Lot, 0) = 0)
		BEGIN
			;
			THROW 51000, '���ʱ���β���Ϊ�գ���ȷ�ϣ�', 1;
			RETURN;
		END

		--�����Ƿ����ͬ���εĿ��
		SELECT @Count = count(*) FROM WMS_Inv
			WHERE InvId = @InvId
				AND Isnull(SubInvId, 0) = Isnull(@SubInvId, 0)
				AND PartId = @PartId
				AND Isnull(Lot, 0) = Isnull(@Lot, 0);
		IF (@Count = 1)	--����ҵ������޸Ŀ��������
		BEGIN
			UPDATE WMS_Inv SET Qty = Qty + @Qty
				WHERE InvId = @InvId
					AND Isnull(SubInvId, 0) = Isnull(@SubInvId, 0)
					AND PartId = @PartId
					AND Isnull(Lot, 0) = Isnull(@Lot, 0);
		END
		ELSE IF (@AllowAddLot = 1)	--��������
		BEGIN
			--������β�Ϊ�գ����ж����еĿ���������Ƿ���ڿ����Σ�ϵͳ��������ڿ����κͷǿ�����ͬʱ���ڵ������
			IF (Isnull(@Lot, '') <> '')
			BEGIN
				SELECT @Count = count(*) FROM WMS_Inv
					WHERE InvId = @InvId
						AND Isnull(SubInvId, 0) = Isnull(@SubInvId, 0)
						AND PartId = @PartId
						AND Isnull(Lot, '') = '';
				IF (@Count > 0)
				BEGIN
					;
					THROW 51000, '������δ������⣺��ǰ���β�Ϊ�գ���������Ϊ�յ����Σ���ȷ�ϣ�', 1;
					RETURN;
				END
			END
			--�������Ϊ�գ����ж����еĿ���������Ƿ���ڲ�Ϊ�����Σ�ϵͳ��������ڿ����κͷǿ�����ͬʱ���ڵ������
			IF (Isnull(@Lot, '') = '')
			BEGIN
				SELECT @Count = count(*) FROM WMS_Inv
					WHERE InvId = @InvId
						AND Isnull(SubInvId, 0) = Isnull(@SubInvId, 0)
						AND PartId = @PartId
						AND Isnull(Lot, '') <> '';
				IF (@Count > 0)
				BEGIN
					;
					THROW 51000, '������δ������⣺��ǰ����Ϊ�գ��������ڲ�Ϊ�յ����Σ���ȷ�ϣ�', 1;
					RETURN;
				END
			END
		
			--������������
			INSERT INTO WMS_Inv (InvId,
								SubInvId,
								PartId,
								Lot,
								Qty,
								StockQty)
						VALUES (@InvId,
								@SubInvId,
								@PartId,
								@Lot,
								@Qty,
								0
								);

		END
		ELSE  --���ӿ��ʱ������Ч����
		BEGIN
			;
			THROW 51000, '������δ������⣺��ǰ���ο�治�����Ҹò����������������Σ���ȷ�ϣ�', 1;
			RETURN;
		END

		--�������¼��
		INSERT INTO WMS_InvRecord (PartId,
									Lot,
									QTY,
									InvId,
									SubInvId,
									BillId,
									SourceBill,
									OperateDate,
									Type,
									OperateMan,
									Stock_InvId,
									StockStatus
									)
							VALUES (@PartId,
									@Lot,
									@Qty,
									@InvId,
									@SubInvId,	
									@BillId,
									@SourceBill,
									@now,
									@type,
									@UserId,
									null,
									1);
	END


	--���ٿ�棺������Ϊ�գ����Ƚ��ȳ���ԭ��ۼ���棻�����ηǿ�ʱ��ֻ�ۼ�ָ�����εĿ��
	IF (@Qty < 0)
	BEGIN
		IF (@HasStockQty = 1)	--�Ѿ����Ϲ���ֱ�ӿۼ���棬�����жϿ��������
		BEGIN
			--�޸Ŀ��������
			UPDATE WMS_Inv SET Qty = inv.Qty - r.QTY, 
								StockQty = inv.StockQty - r.Qty
				FROM WMS_Inv inv,
					 WMS_InvRecord r
				WHERE r.Type = @type
				  AND r.BillId = @BillId
				  AND r.Stock_InvId = inv.Id
				  AND r.StockStatus = 2;

			--�������¼��
			INSERT INTO WMS_InvRecord (PartId,
										Lot,
										QTY,
										InvId,
										SubInvId,
										BillId,
										SourceBill,
										OperateDate,
										Type,
										OperateMan,
										Stock_InvId,
										StockStatus
										)
								SELECT	r.PartId,
										r.Lot,
										r.Qty,
										r.InvId,
										r.SubInvId,	
										r.BillId,
										r.SourceBill,
										@now,
										r.type,
										@UserId,
										null,
										1
									FROM WMS_InvRecord r
									WHERE r.Type = @type
										AND r.BillId = @BillId
										AND r.Stock_InvId is not null;
		END
		ELSE
		BEGIN
			IF (Isnull(@Lot, '') <> '') --���β�Ϊ��
			BEGIN
				SELECT @Count = count(*), @InvQty = SUM(Qty - Isnull(StockQty, 0)) FROM WMS_Inv
					WHERE InvId = @InvId
						AND Isnull(SubInvId, 0) = Isnull(@SubInvId, 0)
						AND PartId = @PartId
						AND Isnull(Lot, 0) = Isnull(@Lot, 0);
				IF (@Qty < 0 AND IsNull(@InvQty, 0) < ABS(@Qty) AND @AllowNegativeInv = 0)	--�����ٿ�桢�Ҳ�������桢�ҿ������������ʱ���׳��쳣
				BEGIN
					;
					THROW 51000, '��ǰ���εĿ�����������㣬��ȷ�ϣ�', 1;
					RETURN;
				END
			END

			IF (Isnull(@Lot, '') = '') --����Ϊ��
			BEGIN
				SELECT @Count = count(*), @InvQty = SUM(Qty - Isnull(StockQty, 0)) FROM WMS_Inv
					WHERE InvId = @InvId
						AND Isnull(SubInvId, 0) = Isnull(@SubInvId, 0)
						AND PartId = @PartId;
				IF (@Qty < 0 AND IsNull(@InvQty, 0) < ABS(@Qty) AND @AllowNegativeInv = 0)	--�����ٿ�桢�Ҳ�������桢�ҿ������������ʱ���׳��쳣
				BEGIN
					;
					THROW 51000, '������������㣬��ȷ�ϣ�', 1;
					RETURN;
				END
			END

			--ʹ���α꣬���Ƚ��ȳ���ԭ�����
			DECLARE cur_Inv cursor for select Id, Qty, Isnull(StockQty, 0)
											from WMS_Inv
											where InvId = @InvId
												AND Isnull(SubInvId, 0) = Isnull(@SubInvId, 0)
												AND PartId = @PartId
												AND Isnull(Lot, 0) = Isnull(@Lot, Isnull(Lot, 0))
												AND Qty - Isnull(StockQty, 0) > 0
											Order By Lot;
			set @ResidueQty = ABS(@Qty);
			--���α�--
			open cur_Inv;
			--��ʼѭ���α����--
			fetch next from cur_Inv into @rowId, @InvQty, @StockQty;
			while @@FETCH_STATUS = 0    --���ر� FETCH���ִ�е�����α��״̬--
			begin         
				IF (@InvQty - @StockQty < @ResidueQty)
				BEGIN
					set @CurrentQty = @InvQty - @StockQty;
				END
				ELSE
				BEGIN
					set @CurrentQty = @ResidueQty;
				END;
				set @ResidueQty = @ResidueQty - @CurrentQty;

				--�޸Ŀ��������
				UPDATE WMS_Inv SET Qty = Qty - @CurrentQty
					WHERE Id = @rowId;
				--�������¼��
				INSERT INTO WMS_InvRecord (PartId,
											Lot,
											QTY,
											InvId,
											SubInvId,
											BillId,
											SourceBill,
											OperateDate,
											Type,
											OperateMan,
											Stock_InvId,
											StockStatus
											)
									VALUES (@PartId,
											@Lot,
											@CurrentQty,
											@InvId,
											@SubInvId,	
											@BillId,
											@SourceBill,
											@now,
											@type,
											@UserId,
											null,
											1);

				IF (@ResidueQty > 0)
				BEGIN
					--ת����һ���α꣬û�л���ѭ��
					fetch next from cur_Inv into @rowId, @InvQty, @StockQty; 
				END
				ELSE
				BEGIN
					BREAK;
				END;
			end    
			close cur_Inv  --�ر��α�
			deallocate cur_Inv   --�ͷ��α�

		END
	END
END

GO

/****** Object:  StoredProcedure [dbo].[P_WMS_UpdateInvQty_BatchUpdate]    Script Date: 2019/5/11 21:00:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [dbo].[P_WMS_UpdateInvQty_BatchUpdate]
	@UserId varchar(50),
	@PartId int,
	@InvId int,
	@SubInvId int,
	@Lot varchar(50),
	@AllowAddLot bit,	--�����ӿ��ʱ���Ƿ�������������
	@HasStockQty bit,	--�ڼ��ٿ��ʱ���Ƿ��ѽ��й�����
	@Qty decimal(10, 3),
	@now datetime,
	@type varchar(50),
	@BillId int,
	@SourceBill varchar(50)
AS
BEGIN
	DECLARE @AllowNegativeInv bit = 0; --�Ƿ�������棬Ĭ�Ϸ�
	DECLARE @Count int;
	DECLARE @InvQty decimal(10, 3);

	IF (@Qty = 0)
	BEGIN
		;
		THROW 51000, '����޸�����Ϊ0����ȷ�ϣ�', 1;
		RETURN;
	END;
	
	--�޸Ŀ��������
	--���ӿ��
	IF (@Qty > 0)
	BEGIN
		--�����Ƿ����ͬ���εĿ��
		SELECT @Count = count(*) FROM WMS_Inv
			WHERE InvId = @InvId
				AND Isnull(SubInvId, 0) = Isnull(@SubInvId, 0)
				AND PartId = @PartId
				AND Isnull(Lot, 0) = Isnull(@Lot, 0);
		IF (@Count = 1)	--����ҵ������޸Ŀ��������
		BEGIN
			UPDATE WMS_Inv SET Qty = Qty + @Qty
				WHERE InvId = @InvId
					AND Isnull(SubInvId, 0) = Isnull(@SubInvId, 0)
					AND PartId = @PartId
					AND Isnull(Lot, 0) = Isnull(@Lot, 0);
		END
		ELSE IF (@AllowAddLot = 1)	--��������
		BEGIN
			--������β�Ϊ�գ����ж����еĿ���������Ƿ���ڿ����Σ�ϵͳ��������ڿ����κͷǿ�����ͬʱ���ڵ������
			IF (@Lot IS NOT NULL)
			BEGIN
				SELECT @Count = count(*) FROM WMS_Inv
					WHERE InvId = @InvId
						AND Isnull(SubInvId, 0) = Isnull(@SubInvId, 0)
						AND PartId = @PartId
						AND Lot IS NULL;
				IF (@Count > 0)
				BEGIN
					;
					THROW 51000, '������δ������⣺��ǰ���β�Ϊ�գ���������Ϊ�յ����Σ���ȷ�ϣ�', 1;
					RETURN;
				END
			END
			--�������Ϊ�գ����ж����еĿ���������Ƿ���ڲ�Ϊ�����Σ�ϵͳ��������ڿ����κͷǿ�����ͬʱ���ڵ������
			IF (@Lot IS NULL)
			BEGIN
				SELECT @Count = count(*) FROM WMS_Inv
					WHERE InvId = @InvId
						AND Isnull(SubInvId, 0) = Isnull(@SubInvId, 0)
						AND PartId = @PartId
						AND Lot IS NOT NULL;
				IF (@Count > 0)
				BEGIN
					;
					THROW 51000, '������δ������⣺��ǰ����Ϊ�գ��������ڲ�Ϊ�յ����Σ���ȷ�ϣ�', 1;
					RETURN;
				END
			END
		
			--������������
			INSERT INTO WMS_Inv (InvId,
								SubInvId,
								PartId,
								Lot,
								Qty)
						VALUES (@InvId,
								@SubInvId,
								@PartId,
								@Lot,
								@Qty
								);

		END
		ELSE  --���ӿ��ʱ������Ч����
		BEGIN
			;
			THROW 51000, '������δ������⣺��ǰ���ο�治�����Ҹò����������������Σ���ȷ�ϣ�', 1;
			RETURN;
		END
	END


	--���ٿ�棺������Ϊ�գ����Ƚ��ȳ���ԭ��ۼ���棻�����ηǿ�ʱ��ֻ�ۼ�ָ�����εĿ��
	IF (@Qty < 0)
	BEGIN
		IF (@HasStockQty = 1)	--�Ѿ����Ϲ���ֱ�ӿۼ���棬�����жϿ��������
		BEGIN
			UPDATE WMS_Inv SET Qty = Qty + @Qty, 
								StockQty = StockQty + @Qty
				WHERE InvId = @InvId
					AND Isnull(SubInvId, 0) = Isnull(@SubInvId, 0)
					AND PartId = @PartId
					AND Isnull(Lot, 0) = Isnull(@Lot, 0);
		END
		ELSE
		BEGIN
			IF (@Lot IS NOT NULL) --���β�Ϊ��
			BEGIN
				SELECT @Count = count(*), @InvQty = SUM(Qty - StockQty) FROM WMS_Inv
					WHERE InvId = @InvId
						AND Isnull(SubInvId, 0) = Isnull(@SubInvId, 0)
						AND PartId = @PartId
						AND Isnull(Lot, 0) = Isnull(@Lot, 0);
				IF (@Qty < 0 AND IsNull(@InvQty, 0) < ABS(@Qty) AND @AllowNegativeInv = 0)	--�����ٿ�桢�Ҳ�������桢�ҿ������������ʱ���׳��쳣
				BEGIN
					;
					THROW 51000, '��ǰ���εĿ�����������㣬��ȷ�ϣ�', 1;
					RETURN;
				END

				--�ۼ����
				UPDATE WMS_Inv SET Qty = Qty + @Qty
					WHERE InvId = @InvId
						AND Isnull(SubInvId, 0) = Isnull(@SubInvId, 0)
						AND PartId = @PartId
						AND Isnull(Lot, 0) = Isnull(@Lot, 0);
			END

			IF (@Lot IS NULL) --����Ϊ��
			BEGIN
				SELECT @Count = count(*), @InvQty = SUM(Qty - StockQty) FROM WMS_Inv
					WHERE InvId = @InvId
						AND Isnull(SubInvId, 0) = Isnull(@SubInvId, 0)
						AND PartId = @PartId;
				IF (@Qty < 0 AND IsNull(@InvQty, 0) < ABS(@Qty) AND @AllowNegativeInv = 0)	--�����ٿ�桢�Ҳ�������桢�ҿ������������ʱ���׳��쳣
				BEGIN
					;
					THROW 51000, '������������㣬��ȷ�ϣ�', 1;
					RETURN;
				END

				--�ۼ���棺�Ƚ��ȳ�
				UPDATE WMS_Inv SET Qty = Qty -
						CASE WHEN (SELECT ABS(@Qty) - Isnull(SUM(t.Qty), 0) 
									FROM WMS_Inv t
									WHERE t.InvId = @InvId
										AND Isnull(t.SubInvId, 0) = Isnull(@SubInvId, 0)
										AND t.PartId = @PartId
										AND Isnull(t.Lot, 0) <= Isnull(inv.Lot, 0)
										AND t.Qty > 0) >= 0
							THEN Qty
							ELSE CASE WHEN (SELECT ABS(@Qty) - Isnull(SUM(t.Qty), 0) 
											FROM WMS_Inv t
											WHERE t.InvId = @InvId
												AND Isnull(t.SubInvId, 0) = Isnull(@SubInvId, 0)
												AND t.PartId = @PartId
												AND Isnull(t.Lot, 0) < Isnull(inv.Lot, 0)
												AND t.Qty > 0) < 0
									THEN 0
									ELSE (SELECT ABS(@Qty) - Isnull(SUM(t.Qty), 0) 
											FROM WMS_Inv t
											WHERE t.InvId = @InvId
												AND Isnull(t.SubInvId, 0) = Isnull(@SubInvId, 0)
												AND t.PartId = @PartId
												AND Isnull(t.Lot, 0) < Isnull(inv.Lot, 0)
												AND t.Qty > 0)
									END
							END,
						OutQty = 
						CASE WHEN (SELECT ABS(@Qty) - Isnull(SUM(t.Qty), 0) 
									FROM WMS_Inv t
									WHERE t.InvId = @InvId
										AND Isnull(t.SubInvId, 0) = Isnull(@SubInvId, 0)
										AND t.PartId = @PartId
										AND Isnull(t.Lot, 0) <= Isnull(inv.Lot, 0)
										AND t.Qty > 0) >= 0
							THEN Qty
							ELSE CASE WHEN (SELECT ABS(@Qty) - Isnull(SUM(t.Qty), 0) 
											FROM WMS_Inv t
											WHERE t.InvId = @InvId
												AND Isnull(t.SubInvId, 0) = Isnull(@SubInvId, 0)
												AND t.PartId = @PartId
												AND Isnull(t.Lot, 0) < Isnull(inv.Lot, 0)
												AND t.Qty > 0) < 0
									THEN 0
									ELSE (SELECT ABS(@Qty) - Isnull(SUM(t.Qty), 0) 
											FROM WMS_Inv t
											WHERE t.InvId = @InvId
												AND Isnull(t.SubInvId, 0) = Isnull(@SubInvId, 0)
												AND t.PartId = @PartId
												AND Isnull(t.Lot, 0) < Isnull(inv.Lot, 0)
												AND t.Qty > 0)
									END
							END
					FROM WMS_Inv inv
					WHERE inv.InvId = @InvId
						AND Isnull(inv.SubInvId, 0) = Isnull(@SubInvId, 0)
						AND inv.PartId = @PartId;
			END
		END
	END

	--�������¼��
	INSERT INTO WMS_InvRecord (PartId,
								Lot,
								QTY,
								InvId,
								SubInvId,
								BillId,
								SourceBill,
								OperateDate,
								Type,
								OperateMan
								)
			VALUES (@PartId,
						@Lot,
						@Qty,
						@InvId,
						@SubInvId,	
						@BillId,
						@SourceBill,
						@now,
						@type,
						@UserId);
	IF (@@ERROR <> 0)
	BEGIN
		;
		THROW 51000, '�������¼ʱ����', 1;
		RETURN
	END
END

GO

