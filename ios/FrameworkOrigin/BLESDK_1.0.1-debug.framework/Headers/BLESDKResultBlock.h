//
//  BLESDKResultBlock.h
//  BLESDK
//
//  Created by 5004300 on 2019/10/01.
//  Copyright © 2019 Seiko Epson. All rights reserved.
//

#ifndef BLESDKResultBlock_h
#define BLESDKResultBlock_h

#pragma mark - successBlock

/*!
 @typedef
 @discussion 結果を持たない処理の完了を通知するブロック
 */
typedef void (^BLESDKResultSuccessBlock)(void);

/*!
 @typedef
 @param serviceID				[in] サービスID
 @param serviceDestination		[in] サービス提供先
 @param commandMajorVersion		[in] コマンドメジャーバージョン
 @param commandMinorVersion		[in] コマンドマイナーバージョン
 @param dataClassMajorVersion	[in] データクラスメジャーバージョン
 @param dataClassMinorVersion	[in] データクラスマイナーバージョン
 @param algorithmMajorVersion	[in] アルゴリズムメジャーバージョン
 @param algorithmMinorVersion	[in] アルゴリズムマイナーバージョン
 @discussion open:successBlock にてオープンが成功した時に呼ばれるブロック
 */
typedef void (^BLESDKOpenResultSuccessBlock)(NSUInteger serviceID, NSUInteger serviceDestination,
												NSUInteger commandMajorVersion, NSUInteger commandMinorVersion,
													NSUInteger dataClassMajorVersion, NSUInteger dataClassMinorVersion,
														NSUInteger algorithmMajorVersion, NSUInteger algorithmMinorVersion);

/*!
 @typedef
 @param indexTable		[in]	インデックステーブル。UInt16の配列。
							インデックスは 0x0000 - 0xFFFF の範囲。
 @discussion requestIndexTableForDCLSID:filter:successBlock:failureBlock: の
 結果を通知するブロック。
 */
typedef void (^BLESDKIndexTableResultSuccessBlock)(NSArray* indexTable);

/*!
 @typedef
 @param size			[in]	データクラス本体のサイズ [単位:byte]
 @discussion requestSizeForDCLSID:index:successBlock:failureBlock: の
 結果を通知するブロック。<br>
 本体サイズは、4byte 符号なし整数です。
 */
typedef void (^BLESDKDataSizeResultSuccessBlock)(NSUInteger size);

/*!
 @typedef
 @param metaData		[in]	メタ情報
 @discussion requestMetaDataForDCLSID:index:successBlock:failureBlock: の
 結果を通知するブロック。
 */
typedef void (^BLESDKMetaDataResultSuccessBlock)(NSData* metaData);


/*!
 @typedef
 @param responseData	[in]	受信したデータ
 @discussion requestData:successBlockで呼ばれるブロック。
 */
typedef void (^BLESDKDataResultSuccessBlock)(NSData* responseData);

/*!
 @typedef
 @param batteryLevel    		[in]	バッテリーレベル[%]
 @discussion getBatteryLevel:successBlockで呼ばれるブロック。
 */
typedef void (^BLESDKBatteryLevelResultSuccessBlock)(NSUInteger batteryLevel);

/*!
 @typedef
 @param writedOffset    		[in]	書き込み済みオフセット
 @discussion prepareUpdateFirmware:successBlockで呼ばれるブロック。
 */
typedef void (^BLESDKPrepareUpdateFirmwareResultSuccessBlock)(NSUInteger writedOffset);

#pragma mark - EventBlock

/*!
 @typedef
 @param UUID				[in]	発見された機器のUUID
 @param localName			[in]	発見された機器のlocalName、存在しない場合は空文字
 @param manufacturerData	[in]	発見された機器の独自アドバタイズデータ、存在しない場合は空文字
 @discussion starScan:eventBlock にて機器が見つかるたびに呼ばれるブロック。
 */
typedef void (^BLESDKScanResultEventBlock)(NSString* UUID, NSString* localName, NSData* manufacturerData);

/*!
 @typedef
 @param progress		[in]	進捗率
 @discussion BLESDKコマンドにて進捗率が更新されるたびに呼ばれるブロック。
 */
typedef void (^BLESDKProgressEventBlock)(NSUInteger progress);

/*!
 @typedef
 @param reveiceEvent    		[in]	受信したイベント
 @discussion starEvent:eventBlock にてイベントを受信する度に呼ばれるブロック。
 */
typedef void (^BLESDKReceiveDataEventBlock)(NSData* reveiceEvent);

#pragma mark - FailureBlock

typedef NS_ENUM(NSInteger, BLESDKError) {
	BLESDKError_NoError,
	BLESDKError_Busy,
	BLESDKError_UserCancel,
	BLESDKError_InvalidParameter,
	BLESDKError_PoweredOff,
	BLESDKError_Unauthorized,
	BLESDKError_ConnectionFailure,
	BLESDKError_ConnectionTimeout,
	BLESDKError_ServiceDiscoverFailure,
	BLESDKError_CharacterDiscoverFailure,
	BLESDKError_DidDisconnectPeripheral,
	BLESDKError_PeripheralNotConnected,
	BLESDKError_WriteCharacteristicError,
	BLESDKError_UpdateCharacteristicError,
	BLESDKError_MutexError,
	BLESDKError_NotOpend,
	BLESDKError_ServiceNotFound,
	BLESDKError_CharacteristicNotFound,
	BLESDKError_ExecutionFailure,
	BLESDKError_NotAvailable,
	BLESDKError_ParseResponseError,
	BLESDKError_CommandTimeout,
	BLESDKError_FlashLocked,
	BLESDKError_Delayed,
	BLESDKError_Downgrade,
	BLESDKError_NotEnoughBattery,
	BLESDKError_InvalidDCLSID,
	BLESDKError_InvalidElementID,
	BLESDKError_InvalidIndex,
	BLESDKError_InvalidFilter,
	BLESDKError_InvalidOperation,
	BLESDKError_InvalidOffset,
	BLESDKError_InvalidSize,
	BLESDKError_InvalidParameterResponse,
	BLESDKError_FirmwareInternalError,
	BLESDKError_UnknownError
};

/*!
 @typedef
 @param errorEnum	[in] BLESDK で定義されるエラー列挙体
 @param error		[in] エラー情報オブジェクト。付随するエラー情報が存在しない場合は nil。
 @param	jsonString	[in] エラーJSON文字列
 @discussion エラーが発生した場合に呼ばれるブロック。
 */
typedef void (^BLESDKErrorFailureBlock)(BLESDKError errorEnum, NSError* error, NSString* jsonString);

#endif /* BLESDKResultDtoBlock_h */
