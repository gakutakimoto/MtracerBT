//
//  BLESDKInterface.h
//  BLESDK
//
//  Created by 5004300 on 2019/10/01.
//  Copyright © 2019 Seiko Epson. All rights reserved.
//

#ifndef BLESDKInterface_h
#define BLESDKInterface_h

#import "BLESDKResultBlock.h"

@protocol BLESDKInterface

#pragma mark - getInstance

/*!
 @method
 @return BLESDKInterface
 @discussion シングルトンインスタンスの取得<br>
 */
+(id<BLESDKInterface>)getInstance;

#pragma mark - startScan

/*!
 @method
 @param serviceUUIDs	[in] スキャン対象となるサービスUUID配列
 @param productNames	[in] スキャン対象となるローカルネーム
 @param eventBlock		[in] デバイス機器が見つかったときに呼ばれるブロック。
 @param successBlock 	[in] デバイス機器が見つかったときに呼ばれるブロック。
 @param failureBlock 	[in] エラー発生時に呼ばれるブロック。
 @discussion
 スキャン結果は以下の順序で機器ごとに返却されます。<BR>
 1. 接続済の機器<BR>
 2. アドバタイズしている機器<BR>
 */
- (void)startScan:(NSArray *)serviceUUIDs
	 productNames:(NSArray *)productNames
	   eventBlock:(BLESDKScanResultEventBlock)eventBlock
	 successBlock:(BLESDKResultSuccessBlock)successBlock
	 failureBlock:(BLESDKErrorFailureBlock)failureBlock;

#pragma mark - stopScan

/*!
 @method
 */
- (void)stopScan;

#pragma mark - startAlwaysOnConnection

/*!
 @method
 @param UUID			[in] 常時接続を開始する機器のUUID
 @param successBlock	[in] オープンが成功した時に呼ばれるブロック
 @param failureBlock	[in] エラー発生時に呼ばれるブロック
 @discussion 常時接続を開始します。
 */
- (void)startAlwaysOnConnection:(NSString*)UUID
				   successBlock:(BLESDKResultSuccessBlock)successBlock
				   failureBlock:(BLESDKErrorFailureBlock)failureBlock;

#pragma mark - stopAlwaysOnConnection

/*!
 @method
 @discussion 常時接続を停止します。
 */
- (void)stopAlwaysOnConnection;

#pragma mark - open

/*!
 @method
 @param UUID			[in] UUID
 @param successBlock	[in] オープンが成功した時に呼ばれるブロック
 @param failureBlock	[in] エラー発生時に呼ばれるブロック
 */
- (void)open:(NSString*)UUID
successBlock:(BLESDKOpenResultSuccessBlock)successBlock
failureBlock:(BLESDKErrorFailureBlock)failureBlock;

#pragma mark - close

/*!
 @method
 @param successBlock	[in] クローズが成功した時に呼ばれるブロック
 @param failureBlock	[in] エラー発生時に呼ばれるブロック
 */
- (void)close:(BLESDKResultSuccessBlock)successBlock
 failureBlock:(BLESDKErrorFailureBlock)failureBlock;

#pragma mark - requestIndexTable

/*!
 @enum FilteringParam
 @discussion 取得するインデックステーブルを決めるフィルタリング指定値
 @constant none				フィルタリングなし
 @constant notUploaded		未アップロードのインデックス情報のみ取得
 @constant uploaded			アップロード済のインデックス情報のみ取得
 @constant partiallyUploaded		一部アップロード済のインデックス情報のみ取得
 */
typedef NS_ENUM(NSInteger, FilteringParam) {
    FilteringParam_none						= 0x00,
    FilteringParam_notUploaded				= 0x01,
    FilteringParam_uploaded					= 0x02,
    FilteringParam_partiallyUploaded		= 0x03,
};

/*!
 @method
 @param eventBlock		[in] クローズが成功した時に呼ばれるブロック
 @param successBlock	[in] クローズが成功した時に呼ばれるブロック
 @param failureBlock	[in] エラー発生時に呼ばれるブロック
 */
- (void)requestIndexTable:(NSUInteger)DCLSID
				   filter:(FilteringParam)filter
			   eventBlock:(BLESDKProgressEventBlock)eventBlock
			 successBlock:(BLESDKIndexTableResultSuccessBlock)successBlock
			 failureBlock:(BLESDKErrorFailureBlock)failureBlock;

#pragma mark - requestDataSize

/*!
 @method
 @param DCLSID			[in] 対象のデータクラスID
 @param index			[in] データクラスの取得対象
 @param successBlock	[in] データクラス本体サイズを取得したときに呼ばれるブロック。
 @param failureBlock	[in] エラー発生時に呼ばれるブロック。
 @discussion データクラスの本体サイズを取得します。<br>
 コマンドの実行をキャンセルする場合は、cancelRequestを呼び出します。
 */
- (void)requestDataSize:(NSUInteger)DCLSID
				  index:(NSUInteger)index
		   successBlock:(BLESDKDataSizeResultSuccessBlock)successBlock
		   failureBlock:(BLESDKErrorFailureBlock)failureBlock;

#pragma mark - requestData

/*!
 @method
 @param DCLSID			[in] 対象のデータクラスID
 @param index			[in] データクラスの取得対象
 @param offset			[in] データクラス読み込み開始位置
 @param size			[in] データクラス読み込みサイズ
 @param eventBlock		[in] データクラス本体を取得進捗率が更新された時に呼ばれるブロック
 @param successBlock	[in] データクラス本体の取得が成功した時に呼ばれるブロック
 @param failureBlock	[in] エラー発生時に呼ばれるブロック。
 @discussion データクラス本体を取得します。<br>
 コマンドの実行をキャンセルする場合は、cancelRequestを呼び出します。<br>
 */
- (void)requestData:(NSUInteger)DCLSID
			  index:(NSUInteger)index
			 offset:(NSUInteger)offset
			   size:(NSUInteger)size
		 eventBlock:(BLESDKProgressEventBlock)eventBlock
	   successBlock:(BLESDKDataResultSuccessBlock)successBlock
	   failureBlock:(BLESDKErrorFailureBlock)failureBlock;

#pragma mark - requestMetaData

/*!
 @method
 @param DCLSID			[in] 対象のデータクラスID
 @param index			[in] データクラスメタ情報の取得対象
 @param successBlock	[in] データクラスメタ情報を取得したときに呼ばれるブロック。
 @param failureBlock	[in] エラー発生時に呼ばれるブロック。
 @discussion データクラスのメタ情報を取得します。<br>
 コマンドの実行をキャンセルする場合は、cancelRequestを呼び出します。<br>
 */
- (void)requestMetaData:(NSUInteger)DCLSID
				  index:(NSUInteger)index
		   successBlock:(BLESDKMetaDataResultSuccessBlock)successBlock
		   failureBlock:(BLESDKErrorFailureBlock)failureBlock;

#pragma mark - updateUploadFlag

/*!
 @enum UploadFlag
 @discussion アップロードフラグ
 @constant uploaded			アップロード済み
 @constant notUpload			未アップロード
 @constant partiallyUploaded		一部アップロード
 */
typedef NS_ENUM(NSInteger, UploadFlag) {
    UploadFlag_uploaded				= 0x00,
    UploadFlag_notUpload			= 0x01,
    UploadFlag_partiallyUploaded	= 0x02,
};

/*!
 @method
 @param DCLSID			[in] 対象のデータクラスID
 @param index			[in] フラグを設定する対象のインデックス
 @param uploadFlag		[in] 設定するアップロードフラグ値。WCUploadFlagで定義される値を指定します。
 @param successBlock	[in] アップロードフラグの更新が完了したときに呼ばれるブロック
 @param failureBlock	[in] エラー発生時に呼ばれるブロック
 @discussion データクラスのアップロードフラグを更新します。<br>
 コマンドの実行をキャンセルする場合は、cancelRequestを呼び出します。
 */
- (void)updateUploadFlag:(NSUInteger)DCLSID
				   index:(NSUInteger)index
			  uploadFlag:(UploadFlag)uploadFlag
			successBlock:(BLESDKResultSuccessBlock)successBlock
			failureBlock:(BLESDKErrorFailureBlock)failureBlock;

#pragma mark - writeData

/*!
 @method
 @param DCLSID 			[in] 対象のデータクラスID
 @param index			[in] データ本体書き込み対象のインデックス
 @param data			[in] データ本体
 @param eventBlock		[in] 書き込みにおける進捗率が更新されるたびに呼ばれるブロック
 @param successBlock	[in] データ本体書き込みが完了したときに呼ばれるブロック
 @param failureBlock	[in] エラー発生時に呼ばれるブロック
 @discussion データ本体の書き込みを行います。data と dataSize は必ず一致させてください。<br>
 コマンドの実行をキャンセルする場合は、cancelRequestを呼び出します。
 */
- (void)writeData:(NSUInteger)DCLSID
			index:(NSUInteger)index
			 data:(NSData*)data
	   eventBlock:(BLESDKProgressEventBlock)eventBlock
	 successBlock:(BLESDKResultSuccessBlock)successBlock
	 failureBlock:(BLESDKErrorFailureBlock)failureBlock;

#pragma mark - cancelRequest

/*!
 @method
 @param successBlock    [in] キャンセルが完了した場合に呼ばれます。
 @discussion 送受信処理をキャンセルします。<br>
 キャンセルが終了した後に、successBlock が呼ばれます。<br>
 入れ違いで送受信処理が終了してしまった場合も、キャンセル終了の正常デリゲートは発生します。<br>
 */
- (void)cancelRequest:(BLESDKResultSuccessBlock)successBlock;

#pragma mark - startDataEvent

/*!
 @method
 @param characteristicUUID	[in] イベントを受信するキャラクタリスティックUUID
 @param serviceUUID			[in] イベントを受信するサービスUUID
 @param eventBlock			[in] イベントを受信する毎に呼ばれるブロック
 @param successBlock		[in] イベント受信開始に成功した時に呼ばれるブロック
 @param failureBlock		[in] エラー発生時に呼ばれるブロック
 @discussion イベント受信を開始します<BR>
 */
- (void)startDataEvent:(NSString*)characteristicUUID
		   serviceUUID:(NSString*)serviceUUID
			eventBlock:(BLESDKReceiveDataEventBlock)eventBlock
		  successBlock:(BLESDKResultSuccessBlock)successBlock
		  failureBlock:(BLESDKErrorFailureBlock)failureBlock;

#pragma mark - stopDataEvent

/*!
 @method
 @param characteristicUUID	[in] イベントを停止するキャラクタリスティックUUID
 @discussion イベント受信を停止します<BR>
 */
- (void)stopDataEvent:(NSString*)characteristicUUID;

#pragma mark - getBatterylevel

/*!
 @method
 @param successBlock		[in] バッテリーレベルを取得した時に呼ばれるブロック
 @param failureBlock		[in] エラー発生時に呼ばれるブロック
 @discussion バッテリレベルを取得します<BR>
 */
- (void)getBatterylevel:(BLESDKBatteryLevelResultSuccessBlock)successBlock
		   failureBlock:(BLESDKErrorFailureBlock)failureBlock;

#pragma mark - requestInitializeToFactory

/*!
 @method
 @param successBlock		[in] 工場出荷初期化要求成功時に呼ばれるブロック
 @param failureBlock		[in] エラー発生時に呼ばれるブロック
 @discussion 機器を工場出荷状態に初期化します<BR>
 */
- (void)requestInitializeToFactory:(BLESDKResultSuccessBlock)successBlock
					  failureBlock:(BLESDKErrorFailureBlock)failureBlock;

#pragma mark - requestResetDevice

/*!
 @method
 @param successBlock		[in] リセット要求成功時に呼ばれるブロック
 @param failureBlock		[in] エラー発生時に呼ばれるブロック
 @discussion 機器をリセットします<BR>
 */
- (void)requestResetDevice:(BLESDKResultSuccessBlock)successBlock
			  failureBlock:(BLESDKErrorFailureBlock)failureBlock;

#pragma mark - requestSetEcoMode

/*!
 @enum EcoParam
 @discussion 省電力型
 @constant notEco			省電力未設定
 @constant ecoBLE			BLE省電力
 */
typedef NS_ENUM(NSInteger, EcoMode) {
    EcoMode_notEco			= 0x0000,
    EcoMode_ecoBLE			= 0x0001,
};

/*!
 @method
 @param ecoModeParam		[in] 省電力設定ビット
 @param successBlock		[in] 省電力設定要求成功時に呼ばれるブロック
 @param failureBlock		[in] エラー発生時に呼ばれるブロック
 @discussion 機器に省電力状態を設定します<BR>
 */
- (void)requestSetEcoMode:(EcoMode)ecoModeParam
			 successBlock:(BLESDKResultSuccessBlock)successBlock
			 failureBlock:(BLESDKErrorFailureBlock)failureBlock;

#pragma mark - prepareFirmwareUpdate

/*!
 @typedef
 @discussion ファームウェア書き込みモード
 @constant normal			通常モード
 @constant overwrite		上書きモード
 */
typedef NS_ENUM(NSInteger, FirmwareWriteMode) {
	FirmwareWriteMode_normal = 0,
	FirmwareWriteMode_overwrite
};

/*!
 @method
 @param majorVersion		[in] 更新対象ファームウェアのメジャーバージョン
 @param minorVersion		[in] 更新対象ファームウェアのマイナーバージョン
 @param patchVersion		[in] 更新対象ファームウェアのパッチバーション
 @param dataSize			[in] 更新対象ファームウェアのデータサイズ
 @param crc32				[in] 更新対象ファームウェアのCRC32
 @param writeMode			[in] 書き込みモード
 @param successBlock		[in] 省電力設定要求成功時に呼ばれるブロック
 @param failureBlock		[in] エラー発生時に呼ばれるブロック
 @discussion 機器に省電力状態を設定します<BR>
 */
- (void)prepareUpdateFirmware:(NSUInteger)majorVersion
				 minorVersion:(NSUInteger)minorVersion
				 patchVersion:(NSUInteger)patchVersion
					 dataSize:(NSUInteger)dataSize
						crc32:(NSUInteger)crc32
					writeMode:(FirmwareWriteMode)writeMode
				 successBlock:(BLESDKPrepareUpdateFirmwareResultSuccessBlock)successBlock
				 failureBlock:(BLESDKErrorFailureBlock)failureBlock;

#pragma mark - writeFirmwareData

/*!
 @method
 @param offset				[in] 書き込み開始位置
 @param data				[in] ファームウェアデータ
 @param eventBlock			[in] 進捗が更新された時に呼ばれるブロック
 @param successBlock		[in] 書き込み成功時に呼ばれるブロック
 @param failureBlock		[in] エラー発生時に呼ばれるブロック
 @discussion 機器に省電力状態を設定します<BR>
 */
- (void)writeFirmwareData:(NSUInteger)offset
					 data:(NSData*)data
			   eventBlock:(BLESDKProgressEventBlock)eventBlock
			 successBlock:(BLESDKResultSuccessBlock)successBlock
			 failureBlock:(BLESDKErrorFailureBlock)failureBlock;

#pragma mark - requestUpdateFirmware

/*!
 @method
 @param successBlock		[in] ファームウェア更新要求成功時に呼ばれるブロック
 @param failureBlock		[in] エラー発生時に呼ばれるブロック
 @discussion 機器に省電力状態を設定します<BR>
 */
- (void)requestUpdateFirmware:(BLESDKResultSuccessBlock)successBlock
				 failureBlock:(BLESDKErrorFailureBlock)failureBlock;

@end

#endif /* BLESDKInterface_h */
