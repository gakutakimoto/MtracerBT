/*!
 @file WCType.h
 プリミティブ型定義ファイル
 @copyright Copyright (C) SEIKO EPSON CORPORATION 2013. All rights reserved.
 */

#pragma once

// デバッグログ
#ifdef DEBUG
#define DEBUG_LOG(...) NSLog(__VA_ARGS__)
#else
#define DEBUG_LOG(...)
#endif

// アサーション
#ifdef DEBUG
#define DEBUG_ASSERT(...) NSAssert(__VA_ARGS__)
#else
#define DEBUG_ASSERT(...)
#endif

#define COMPILE_TIME_ASSERT(condition) typedef int CompileTimeAssertion[ (condition) ? 1 : -1 ]
#define ASSERT_SIZE(name, size) COMPILE_TIME_ASSERT( sizeof(name) == (size) )

/*!
 @typedef
 @discussion 符号あり1byte整数
 */
typedef	__signed char		WCSInt8;

/*!
 @typedef
 @discussion 符号なし1byte整数
 */
typedef	unsigned char		WCUInt8;

/*!
 @typedef
 @discussion 符号あり2byte整数
 */
typedef	short				WCSInt16;

/*!
 @typedef
 @discussion 符号なし2byte整数
 */
typedef	unsigned short		WCUInt16;

/*!
 @typedef
 @discussion 符号あり4byte整数
 */
typedef	int					WCSInt32;

/*!
 @typedef
 @discussion 符号なし4byte整数
 */
typedef	unsigned int		WCUInt32;

/*!
 @typedef
 @discussion 符号あり8byte整数
 */
typedef	long long			WCSInt64;

/*!
 @typedef
 @discussion 符号なし8byte整数
 */
typedef	unsigned long long	WCUInt64;

/*!
 @typedef
 @discussion 真理値型
 */
typedef WCSInt8				WCBool;
