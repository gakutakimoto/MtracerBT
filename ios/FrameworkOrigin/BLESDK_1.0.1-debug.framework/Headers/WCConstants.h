/*!
 @file WCConstants.h
 WellnessCommunicationSDK 定数定義
 @copyright Copyright (C) SEIKO EPSON CORPORATION 2013. All rights reserved.
 */

#pragma once

#include "WCType.h"

/*!
 @typedef
 @discussion データクラスID型
 */
typedef WCUInt16 WCDCLSID;

/*!
 @enum WCUploadFlag
 @discussion アップロードフラグに設定する値
 @constant kWCUploadFlag_Uploaded			アップロード済み
 @constant kWCUploadFlag_NotUpload                   未アップロード
 @constant kWCUploadFlag_PartiallyUploaded	一部アップロード済み(Dupuicated)
 */
enum
{
    kWCUploadFlag_Uploaded					= 0x00,
    kWCUploadFlag_NotUpload					= 0x01,
    kWCUploadFlag_PartiallyUploaded			= 0x02,
};

/*!
 @enum WCFilteringParam
 @discussion 取得するインデックステーブルを決めるフィルタリング指定値
 @constant kWCFilteringParam_None				フィルタリングなし
 @constant kWCFilteringParam_NotUploaded		未アップロードのインデックス情報のみ取得
 @constant kWCFilteringParam_Uploaded			アップロード済のインデックス情報のみ取得
 @constant kWCFilteringParam_PartiallyUploaded	一部アップロード済のインデックス情報のみ取得
 */
enum
{
    kWCFilteringParam_None					= 0x00,
    kWCFilteringParam_NotUploaded			= 0x01,
    kWCFilteringParam_Uploaded				= 0x02,
    kWCFilteringParam_PartiallyUploaded		= 0x03,
};

/*!
 @enum WCEcoParam
 @discussion 省電力モードに設定する値
 @constant kWCEcoParam_NotEco			エコーモードなし
 @constant kWCEcoParam_BLEOff			BLEオフ
 */
enum
{
    kWCEcoParam_NotEco					= 0x0000,
    kWCEcoParam_Eco_BLE					= 0x0001,
};

/*!
 @enum WCEcoParam
 @discussion ファームウェア更新時の書き込みモード
 @constant kWCWriteMode_Normal			エコーモードなし
 @constant kWCWriteMode_Overwrite			BLEオフ
 */
enum
{
    kWCWriteMode_Normal					= 0x00,
    kWCWriteMode_Overwrite				= 0x01,
};
