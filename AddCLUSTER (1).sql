DECLARE @localhost varchar(60)
DECLARE @id INT
DECLARE @getid CURSOR

DECLARE @newBankZMK varchar(60)
DECLARE @newBankZMKName varchar(60)
DECLARE @newBankZPK varchar(60)
DECLARE @newBankZPKName varchar(60)
DECLARE @newBankName varchar(60)
DECLARE @newBankCode varchar(60)
DECLARE @newBankHyperlegderPort varchar(60)
DECLARE @thisBankCode varchar(60)
DECLARE @thisBankHyperLegderIP varchar(60)
DECLARE @thisBankHyperLegderPort varchar(60)
DECLARE @newBankHLClientName varchar(60)
DECLARE @newBankHLServerName varchar(60)
DECLARE @newBankServiceName varchar(60)
DECLARE @newBankServiceCode varchar(60)
DECLARE @newBankServiceSearchIndex varchar(500)

DECLARE @currentMaxIdIns int
DECLARE @currentMaxIdKei int
DECLARE @currentMaxIdKei2 int
DECLARE @currentMaxIdNod int
DECLARE @currentMaxIdNod2 int
DECLARE @currentMaxIdTrn int
DECLARE @currentMaxIdRou int
DECLARE @currentMaxIdSer int

DECLARE @InsitutionKey int
DECLARE @keiesZMKCurrentKey int
DECLARE @keiesZPKCurrentKey int
DECLARE @NodeClientCurrentKey int
DECLARE @NodeServerCurrentKey int
DECLARE @TransactionSetKey int
DECLARE @RouteSetKey int
DECLARE @ServiceKey int

SET @newBankZMK = ''
SET @newBankZMKName = 'ZMK_CLUSTER'
SET @newBankZPK = null
SET @newBankZPKName = 'ZPK_CLUSTER'
SET @newBankName = 'CLUSTER'
SET @newBankHLClientName = 'ClientCLUSTER'
SET @newBankHLServerName = 'ServerCLUSTER'
SET @newBankCode = '5834'
SET @newBankHyperlegderPort = '5833'
SET @newBankServiceCode = '5834'
SET @newBankServiceName = 'FCMB TEST ATM Service'
SET @newBankServiceSearchIndex = 'CA-:.*:;CP-:*.*:;CT-(:\[:1.*_20*:\]:|:\[:1.*_016011*:\]:|:\[:1.*_316011*:\]:|:\[:3.*_31*:\]:|:\[:1.*_38*:\]:|:\[:1.*_396011:\]:);ST-:5834:;'

SET @thisBankCode = '076'
SET @thisBankHyperLegderIP = '9.9.9.9'
SET @thisBankHyperLegderPort = '5834'

SET @localhost = '0.0.0.0'

USE [ZoneSwitch_Core]

/****************************************************Add new bank as an institution******************************************************/
  select @currentMaxIdIns=MAX(ID) from Institutions
  INSERT INTO [ZoneSwitch_Core].[dbo].[Institutions] ([IsActive]
      ,[Name]
      ,[Code])
  VALUES ('1',@newBankName,@newBankCode)
  SET @InsitutionKey = (select ID from Institutions where id>@currentMaxIdIns and id<=SCOPE_IDENTITY())

  	SET @getid = CURSOR FOR
	SELECT ID
	FROM   [ZoneSwitch_Core].[dbo].[Routes]


	OPEN @getid
	FETCH NEXT
	FROM @getid INTO @id
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO [ZoneSwitch_Core].[dbo].[RouteInstitutions] ([RouteID]
		  ,[InstitutionID])
	  VALUES (@id,@InsitutionKey)
		FETCH NEXT
		FROM @getid INTO @id
	END

	CLOSE @getid
	DEALLOCATE @getid

/**************************************************************Adding new keys *********************************************************/
  select @currentMaxIdKei=MAX(ID) from Keies
  INSERT INTO [ZoneSwitch_Core].[dbo].[Keies]([IsActive]
      ,[Name]
      ,[ValueUnderLMK]
      ,[Type]
      ,[IsVariant]
      ,[Parity]
      ,[BlockFormat]
      ,[Length]
      ,[ParentID])
  VALUES ('1',@newBankZMKName,@newBankZMK,'ZoneMasterKey','1','Odd','ANSI','Double',null);
  SET @keiesZMKCurrentKey = (select ID from Keies where id>@currentMaxIdKei and id<=SCOPE_IDENTITY())

  select @currentMaxIdKei2=MAX(ID) from Keies
  INSERT INTO [ZoneSwitch_Core].[dbo].[Keies]([IsActive]
      ,[Name]
      ,[ValueUnderLMK]
      ,[Type]
      ,[IsVariant]
      ,[Parity]
      ,[BlockFormat]
      ,[Length]
      ,[ParentID])
  VALUES ('1',@newBankZPKName,@newBankZPK,'ZonePinKey','1','Odd','ANSI','Double',@keiesZMKCurrentKey);
  SET @keiesZPKCurrentKey = (select ID from Keies where id>@currentMaxIdKei2 and id<=SCOPE_IDENTITY())


  /**********************************************************Adding new nodes *********************************************************/
  select @currentMaxIdNod=MAX(ID) from Nodes
  INSERT INTO [ZoneSwitch_Core].[dbo].[Nodes] ([IsActive]
      ,[Name]
      ,[Port]
      ,[ReconnectInterval]
      ,[RequestTimeout]
      ,[AcquiringInstitutionCode]
      ,[DestinationInstitutionCode]
      ,[HostName]
      ,[Type]
      ,[ConnectionType]
      ,[KeyExchangeInterval]
      ,[IsServiceCodeAware]
      ,[IsExternalNode]
      ,[EchoInterval]
      ,[SourceKeyID]
      ,[DestinationKeyID]
      ,[DateCreated]
      ,[DateUpdated])
  VALUES ('1',@newBankHLClientName,@thisBankHyperLegderPort,'30','60',@thisBankCode,@newBankCode,@thisBankHyperLegderIP,'Destination','HyperLedgerClient','3600','0','1','30',null,null,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
  SET @NodeClientCurrentKey = (select ID from Nodes where id>@currentMaxIdNod and id<=SCOPE_IDENTITY())

  select @currentMaxIdNod2=MAX(ID) from Nodes
  INSERT INTO [ZoneSwitch_Core].[dbo].[Nodes] ([IsActive]
      ,[Name]
      ,[Port]
      ,[ReconnectInterval]
      ,[RequestTimeout]
      ,[AcquiringInstitutionCode]
      ,[DestinationInstitutionCode]
      ,[HostName]
      ,[Type]
      ,[ConnectionType]
      ,[KeyExchangeInterval]
      ,[IsServiceCodeAware]
      ,[IsExternalNode]
      ,[EchoInterval]
      ,[SourceKeyID]
      ,[DestinationKeyID]
      ,[DateCreated]
      ,[DateUpdated])
  VALUES ('1',@newBankHLServerName,@newBankHyperlegderPort,'30','60',@thisBankCode,@newBankCode,@localhost,'Source','HyperLedgerServer','3600','0','1','30',null,null,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
  SET @NodeServerCurrentKey = (select ID from Nodes where id>@currentMaxIdNod2 and id<=SCOPE_IDENTITY())

  
  /**************************************************Adding new services ***************************************************************/
  INSERT INTO [ZoneSwitch_Core].[dbo].[Services] ([IsActive]
      ,[Name]
      ,[Code]
      ,[SearchIndex]
      ,[IsDerivedOnly])
  VALUES ('1',@newBankServiceName,@newBankCode,@newBankServiceSearchIndex,'0')

  /**********************************************Adding new TransactionSets ************************************************************/ 
  
  select @currentMaxIdTrn=MAX(ID) from TransactionSets
  INSERT INTO [ZoneSwitch_Core].[dbo].[TransactionSets] ([IsActive]
      ,[Name])
  VALUES ('1',@newBankName)
    select ID from TransactionSets where ID>@currentMaxIdTrn and ID<=SCOPE_IDENTITY()
  SET @TransactionSetKey = (select ID from TransactionSets where id>@currentMaxIdTrn and id<=SCOPE_IDENTITY())

  /**********************************************Adding new TransactionSetServices *****************************************************/
  INSERT INTO [ZoneSwitch_Core].[dbo].[TransactionSetServices] ([ServiceID]
      ,[TransactionSetID])
  VALUES ( ISNULL(@TransactionSetKey, '1'),ISNULL(@TransactionSetKey, '1'))
 
  /**********************************************Adding new Route **********************************************************************/
  select @currentMaxIdRou=MAX(ID) from [Routes]
  INSERT INTO [ZoneSwitch_Core].[dbo].[Routes] ([IsActive]
      ,[Name]
      ,[DestinationNodeID])
  VALUES ('1',@newBankHLClientName,@NodeClientCurrentKey)
  SET @RouteSetKey = (select ID from [Routes] where id>@currentMaxIdRou and id<=SCOPE_IDENTITY())

  /**************************************Adding new TransactionSetServices *************************************************************/
	SET @getid = CURSOR FOR
	SELECT ID
	FROM   [ZoneSwitch_Core].[dbo].[Institutions]


	OPEN @getid
	FETCH NEXT
	FROM @getid INTO @id
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO [ZoneSwitch_Core].[dbo].[RouteInstitutions] ([RouteID]
		  ,[InstitutionID])
	  VALUES (@RouteSetKey,@id)
		FETCH NEXT
		FROM @getid INTO @id
	END

	CLOSE @getid
	DEALLOCATE @getid

  /*************************************************************Adding new Schemes ******************************************************/

  INSERT INTO [ZoneSwitch_Core].[dbo].[Schemes] ([TransactionSetID]
      ,[FeeID]
      ,[SourceNodeID]
      ,[LimitID]
      ,[RouteID])
  VALUES(ISNULL(@TransactionSetKey, '1'),'1','1','1',@RouteSetKey),
		(ISNULL(@TransactionSetKey, '1'),'1',@NodeServerCurrentKey,'1','1'),
		('1','1',@NodeServerCurrentKey,'1','1')

/***********************************************Adding new Service Channel Transaction Type *********************************************/
  select @currentMaxIdSer=MAX(ID) from [Services]
  SET @ServiceKey = (select ID from [Services] where id>=@currentMaxIdSer and id<=SCOPE_IDENTITY())

  INSERT INTO [ZoneSwitch_Core].[dbo].[ServiceChannelTransactionTypes] ([ChannelID]
      ,[TransactionTypeID]
      ,[ServiceID])
  VALUES('1','1',@ServiceKey),
		('1','2',@ServiceKey),
		('1','3',@ServiceKey),
		('1','4',@ServiceKey)