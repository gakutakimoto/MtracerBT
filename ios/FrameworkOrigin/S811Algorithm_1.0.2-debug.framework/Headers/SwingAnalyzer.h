/**
* Copyright(c) 1999 - 2013 SEIKO EPSON CORP.All rights reserved.
*
* This software is the proprietary information of SEIKO EPSON CORP.
* Use is subject to license terms.
*
* @file
*
*/

#ifndef SWING_ANALYZER_H_
#define SWING_ANALYZER_H_
#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/****************************************************************************
* Includes.
*/
#ifdef SWING_ANALYZER_FW
#include	"stdint.h"
#include	"stdbool.h"
#elif defined SWING_ANALYZER_SDK
#define		bool				_Bool
#define		true				1
#define		false				0
typedef		signed    char     int8_t;
typedef		unsigned  char     uint8_t;
typedef		signed   short     int16_t;
typedef		unsigned short     uint16_t;
typedef		signed   int       int32_t;
typedef		unsigned int       uint32_t;
#endif	/* SWING_ANALYZER_FW/SWING_ANALYZER_SDK */

/****************************************************************************
* definitions.
*/
/* バージョン情報 */
#define ALGORITHM_VERSION_MAJOR 1
#define ALGORITHM_VERSION_MINOR 0
#define ALGORITHM_VERSION_PATCH 2

#define xxxDEBUG_S751PB

#ifdef DEBUG_S751PB
#define SWING_TRAJECTORY_NUM 30000									//!< スイング軌道データ最大数
#else	/* DEBUG_S751PB */
#define SWING_TRAJECTORY_NUM 630									//!< スイング軌道データ最大数
#endif	/* DEBUG_S751PB */

#define	IMU_ACCELERATION_1DIGIT		1024							//!< 加速度　[1digit = 1 / 1024g] 
#define	IMU_GYRO_1DIGIT				8.2								//!< 角速度　[1digit = 1 / 8.2dps] 
#define	IMU_TIME_DIFF_1DIGIT		8								//!< 前回計測からの経過時間　[1digit = 1 / 8ms]

#define mtfloat float

/****************************************************************************
* enum definitions.
*/
/* 解析結果 */
typedef enum {
	SWING_ANALYSIS_SUCCESS = 0,										//!< 成功
	SWING_ANALYSIS_FAIL,											//!< 失敗
} SwingAnalyzeResult;

/* ゴルフクラブの硬さ */
typedef enum {
	SHAFT_HARDNESS_TYPE_L = 0,										//!< シャフト硬さL
	SHAFT_HARDNESS_TYPE_A,											//!< シャフト硬さA
	SHAFT_HARDNESS_TYPE_R,											//!< シャフト硬さR
	SHAFT_HARDNESS_TYPE_SR,											//!< シャフト硬さSR
	SHAFT_HARDNESS_TYPE_S,											//!< シャフト硬さS
	SHAFT_HARDNESS_TYPE_X,											//!< シャフト硬さX
	SHAFT_HARDNESS_TYPE_XX											//!< シャフト硬さXX
} ShaftHardnessType;

/* スイング状態 */
typedef enum {
	SWING_STATE_UNIMPACT = 0,										//!< スイングインパクト未検出状態
	SWING_STATE_IMPACTED,											//!< スイングインパクト検出済状態
	SWING_STATE_END													//!< スイング終了状態
} SwingState;

/* 利き手 */
#define SWING_HANDED_RIGHT 0										//!< 右利き
#define SWING_HANDED_LEFT  1										//!< 左利き


/* スイング解析失敗内容 */
typedef enum {
	SWING_ANALYSIS_NO_ERROR = 0,									//!< 成功
	SWING_ANALYSIS_INPUT_SENSOR_DATA_ERROR = 1,						//!< 入力センサデータのエラー（スイングセンサデータでないと判断した）
	SWING_ANALYSIS_INPUT_CLUB_LENGTH_ERROR = 2,						//!< 入力クラブ長のエラー
	SWING_ANALYSIS_INPUT_FACE_ANGLE_ERROR = 3,						//!< 入力フェース角のエラー
	SWING_ANALYSIS_INPUT_LIE_ANGLE_ERROR = 4,						//!< 入力ライ角のエラー
	SWING_ANALYSIS_INPUT_LOFT_ANGLE_ERROR = 5,						//!< 入力ロフト角エラー
	SWING_ANALYSIS_INPUT_SHAFT_HARDNESS_ERROR = 6,					//!< 入力シャフト硬さエラー
	SWING_ANALYSIS_INPUT_ADDRESS_FACE_ANGLE_ERROR = 9,				//!< 入力アドレス時のターゲットラインに対するフェース角エラー
	SWING_ANALYSIS_INPUT_USER_INFO_ERROR = 10,						//!< 入力ユーザー情報エラー
	SWING_ANALYSIS_OUTPUT_ERROR = 7,								//!< スイング計測エラー
	SWING_ANALYSIS_OUTPUT_ERROR_AFTER_IMPACT = 8					//!< インパクト以降のスイング計測エラー
} SwingAnalyzeErrorCode;

/* スイングフェーズインデックス有効フラグ（SWING_ANALYSIS_OUTPUTのvaild_swing_phase） */
#define SWING_PHASE_START_VAILD 0x01								//!< スイング開始インデクス 有効
#define SWING_PHASE_HALFWAY_BACK_VAILD 0x02							//!< ハーフウェイバックインデクス 有効
#define SWING_PHASE_TOP_VAILD 0x04									//!< トップインデクス 有効
#define SWING_PHASE_IMPACT_VAILD 0x08								//!< インパクトインデクス 有効
#define SWING_PHASE_HALFWAY_DOWN_VAILD 0x10							//!< ハーフダウンインデクス 有効
#define SWING_PHASE_FINISH_VAILD 0x20								//!< フィニッシュインデックス　有効
#define SWING_PHASE_MAX_HEAD_SPEED_VAILD 0x40						//!< 最大ヘッドスピードインデクス有効
#define SWING_PHASE_MAX_GRIP_SPEED_VAILD 0x80						//!< 最大グリップスピードインデクス（ナチュラルアンコックインデックス）有効

/* Vゾーンエリア */
#define VZONE_AREA_NONE 0x00										//!< Vゾーンエリア なし（該当のスイングフェーズ（ポイント）がないためVゾーンエリア）
#define VZONE_AREA_A	0x01										//!< Vゾーンエリア A
#define VZONE_AREA_B	0x02										//!< Vゾーンエリア B
#define VZONE_AREA_C	0x03										//!< Vゾーンエリア C
#define VZONE_AREA_D	0x04										//!< Vゾーンエリア D
#define VZONE_AREA_E	0x05										//!< Vゾーンエリア E

/****************************************************************************
* Structure definitions.
*/
/*! @struct IMUDATA
	@brief IMUデータ
*/
#pragma pack(1)
typedef struct IMUDATA{
	int16_t	acceleration[3];										/*!< 加速度　[1digit = 1 / 1024g] */
	int16_t	gyro[3];												/*!< 角速度　[1digit = 1 / 8.2dps] */
	uint8_t	time;													/*!< 前回計測からの経過時間　[1digit = 1 / 8ms] */
} IMUDATA;
#pragma pack()

/*! @struct SWING_ANALYSIS_INPUT
	@brief スイング解析入力情報			
*/
typedef struct SWING_ANALYSIS_INPUT{
	uint8_t* imu_binary_data;										/*!< IMUセンサのバイナリデータ(ファームウェアから受信したバイナリを復号化したもの) */
	mtfloat club_length;												/*!< クラブ長[m] */
	mtfloat club_face_angle;											/*!< フェース角[度] */
	mtfloat club_loft_angle;											/*!< ロフト角[度] */
	mtfloat club_lie_angle;											/*!< ライ角[度] */
	mtfloat address_face_angle;										/*!< アドレス時のターゲットラインに対するフェース角[度] */
	ShaftHardnessType club_shaft_hardness;							/*!< シャフト硬さ */
} SWING_ANALYSIS_INPUT;

/*! @struct SWING_MEASUREMENT
	@brief スイング指標
*/
typedef struct SWING_MEASUREMENT {
	mtfloat impact_head_speed;										/*!< インパクト時のヘッドスピード[m / s] */
	mtfloat impact_grip_speed;										/*!< インパクト時のグリップスピード[m / s] */
	mtfloat max_head_speed;											/*!< スイング中の最大ヘッドスピード[m / s] */
	mtfloat max_grip_speed;											/*!< スイング中の最大グリップスピード[m / s] */
	mtfloat impact_face_angle;										/*!< インパクト時のフェイス角度[度] */
	mtfloat impact_relative_face_angle;								/*!< インパクト時の相対フェイス角度[度] */
	mtfloat impact_club_path;											/*!< インパクト時のクラブパス[度] */
	mtfloat impact_attack_angle;										/*!< インパクト時のアタック角[度] */
	mtfloat impact_loft_angle;										/*!< インパクト時のロフト角度[度] */
	mtfloat impact_shaft_rotation;									/*<! インパクトシャフトローテーション */
	mtfloat down_swing_shaft_rotation_min;							/*<! ダウンスイングシャフトローテーション最小値 */
	mtfloat down_swing_shaft_rotation_max;							/*<! ダウンスイングシャフトローテーション最大値 */
	mtfloat address_lie_angle;										/*!< アドレス時のライ角[度] */
	mtfloat impact_lie_angle;											/*!< インパクト時のライ角[度] */
	mtfloat natural_uncock;											/*!< ナチュラルアンコック[%] */
	mtfloat natural_release_timing;									/*!< ナチュラルリリースタイミング[%] */
	mtfloat swing_tempo;												/*!< スイングテンポ */
	mtfloat estimate_carry;											/*!< 推定飛距離[Yds] */
	mtfloat impact_point_x;											/*!< 打点Ｘ（フェースのヒール方向がマイナス、中心０、トゥ方向がプラス）[cm] */
	mtfloat impact_point_y;											/*!< 打点Ｙ（フェースの下方向がマイナス、中心０、上方向がプラス）[cm] */
	mtfloat halfwayback_face_angle_to_vertical;						/*!< ハーフウエイバック時の後方から見たの垂直線に対するフェース角度[度] */
	mtfloat top_face_angle_to_horizontal;								/*!< スイングトップ時の後方から見たの水平線に対するフェース角度[度] */
	mtfloat halfwaydown_face_angle_to_vertical;						/*!< ハーフウエイダウン時の後方から見たの垂直線に対するフェース角度[度] */
	mtfloat impact_hand_first;										/*!< インパクト時のハンドファースト度[度] */
	mtfloat address_hand_first;										/*!< アドレス時のハンドファースト度[度] */
	uint8_t swing_handed;											/*!< スイングの利き手 */
	uint8_t reserve[3];												/*!< 予備 */
} SWING_MEASUREMENT;

/*! @struct QUATERNION
	@brief クォータニオン
*/
typedef struct QUATERNION {
	mtfloat w;														/*!< クォータニオンｗ */
	mtfloat x;														/*!< クォータニオンｘ */
	mtfloat y;														/*!< クォータニオンｙ */
	mtfloat z;														/*!< クォータニオンｚ */
} QUATERNION;

/*! @struct SWING_TRAJECTORY
	@brief スイング軌道１データ
*/
typedef struct SWING_TRAJECTORY {
	mtfloat head_positon[3];										/*!< 3次元ヘッド位置[m] */
	mtfloat grip_end_positon[3];									/*!< 3次元グリップエンド位置[m] */
	mtfloat head_acc[3];											/*!< 3次元ヘッド加速度[m/s] */
	QUATERNION attitude;											/*!< クラブ姿勢(クォータニオン) */
	mtfloat head_speed;												/*!< ヘッドスピード[m / s] */
	mtfloat grip_speed;												/*!< グリップスピード[m / s] */
	mtfloat shaft_rotation;											/*!< シャフトローテーション(1軸)[度] */
	mtfloat elapsed_time;											/*!< 経過時間[ms] */
} SWING_TRAJECTORY;



/*! @struct SWING_TRAJECTORY_ALL
	@brief クォータニオン
*/
typedef struct SWING_TRAJECTORY_ALL {
	uint16_t num;													/*!< スイング軌道データ数 */
	SWING_TRAJECTORY data[SWING_TRAJECTORY_NUM];					/*!< スイング軌道データ */
	uint16_t start_index;											/*!< スイング開始インデックス */
	uint16_t halfway_back;											/*!< ハーフウェイバックインデックス */
	uint16_t top_index;												/*!< トップインデックス */
	uint16_t impact_index;											/*!< インパクトインデックス */
	uint16_t halfway_down;											/*!< ハーフウエイダウンインデックス */
	uint16_t finish_index;											/*!< フィニッシュインデックス */
	uint16_t max_head_speed_index;									/*!< 最大ヘッドスピードインデックス */
	uint16_t max_grip_speed_index;									/*!< 最大グリップスピードインデックス */
} SWING_TRAJECTORY_ALL;

typedef struct SWING_SENSOR_DATA {
	mtfloat acceleration[3];											/*!< 加速度 */
	mtfloat gyro[3];													/*!< 角速度 */
} SWING_SENSOR_DATA;

typedef struct SWING_SENSOR_DATA_ALL {
	uint16_t num;													/*!< スイング軌道データ数 */
	SWING_SENSOR_DATA data[SWING_TRAJECTORY_NUM];					/*!< スイング軌道データ */
} SWING_SENSOR_DATA_ALL;

/*! @struct SWING_ANALYSIS_OUTPUT
	@brief スイング解析出力情報
*/
typedef struct SWING_ANALYSIS_OUTPUT {
	uint16_t vaild_swing_phase;										/*!< 有効なスイングフェーズフラグ (SWING_PHASE_XXXの定義参照) */
	SWING_MEASUREMENT measurement;									/*!< スイング指標 */
	SWING_TRAJECTORY_ALL trajectory;								/*!< スイング軌道の時系列データ */
	SWING_SENSOR_DATA_ALL sensor_data;								/*!< センサデータ */
} SWING_ANALYSIS_OUTPUT;

typedef struct EXTRA_SWING_ANALYSIS_INPUT {
	SWING_ANALYSIS_OUTPUT* analysys_info;							/*!< スイング解析した結果 */
	mtfloat club_length;												/*!< クラブ長[m] */
	mtfloat club_face_angle;											/*!< フェース角[度] */
	mtfloat club_loft_angle;											/*!< ロフト角[度] */
	mtfloat club_lie_angle;											/*!< ライ角[度] */
	mtfloat address_face_angle;										/*!< アドレス時のターゲットラインに対するフェース角[度] */
	ShaftHardnessType club_shaft_hardness;							/*!< シャフト硬さ */
	int16_t height;													/*!< 身長[cm] */
	int8_t gender;													/*!< 性別[0:男性、1:女性] */
} EXTRA_SWING_ANALYSIS_INPUT;

typedef struct SWING_V_ZONE {
	mtfloat v_zone_upper;					/*!< Vゾーン上[度] */
	mtfloat v_zone_under;					/*!< Vゾーン上[度] */
	mtfloat zone_AB;						/*!< AとBゾーンの境界角[度] */
	mtfloat zone_BC;						/*!< BとCゾーンの境界角[度] */
	mtfloat zone_CD;						/*!< CとDゾーン境界角[度] */
	mtfloat zone_DE;						/*!< DとEゾーン境界角[度] */
	mtfloat back_swing_zone_angle;		/*!< バックスイング時のクラブヘッドVゾーンエリア角[度] ※VゾーンエリアがVZONE_AREA_NONEの場合は、計算できないので0度設定 */
	mtfloat top_zone_angle;				/*!< トップ時のクラブヘッドVゾーンエリア角[度] ※VゾーンエリアがVZONE_AREA_NONEの場合は、計算できないので0度設定 */
	mtfloat natural_uncock_zone_angle;	/*!< ナチュラルアンコック時のクラブヘッドVゾーンエリア角[度] ※VゾーンエリアがVZONE_AREA_NONEの場合は、計算できないので0度設定 */
	mtfloat down_swing_zone_angle;		/*!< ダウンスイング時のクラブヘッドVゾーンエリア角[度] ※VゾーンエリアがVZONE_AREA_NONEの場合は、計算できないので0度設定 */
	uint8_t back_swing_zone_area;		/*!< バックスイング時のクラブヘッドVゾーンエリア(V_ZONE_AREA_XXX定義参照) */
	uint8_t top_zone_area;				/*!< トップ時のクラブヘッドVゾーンエリア(V_ZONE_AREA_XXX定義参照) */
	uint8_t natural_uncock_zone_area;	/*!< ナチュラルアンコック時のクラブヘッドVゾーンエリア(V_ZONE_AREA_XXX定義参照) */
	uint8_t down_swing_zone_area;		/*!< ダウンスイング時のクラブヘッドVゾーンエリア(V_ZONE_AREA_XXX定義参照) */
} SWING_V_ZONE;

/*! @struct EXTRA_SWING_ANALYSIS_OUTPUT
@brief スイング解析出力情報（Vゾーンなど2次解析情報）
*/
typedef struct EXTRA_SWING_ANALYSIS_OUTPUT {
	SWING_V_ZONE v_zone;
} EXTRA_SWING_ANALYSIS_OUTPUT;


/****************************************************************************
 * Public method declarations.
 */
#ifdef SWING_ANALYZER_FW
/*--------------------------------------------------------------------------*/
 /*! @brief スイングアルゴリズムの初期化する

	@param[in]      iAlgorithrmBuffer    アルゴリズムワークバッファポインタ
	@param[in]      iBuffersSize    アルゴリズムワークバッファサイズ
	@return         なし
*/
/*--------------------------------------------------------------------------*/
void SwingAnalyzer_Initialize(int8_t* iAlgorithrmBuffer, uint32_t iBuffersSize);


/*--------------------------------------------------------------------------*/
 /*! @brief スイングインパクトを検出する

	@param[in]      iImuData    IMUセンサデータ
	@param[in]      iImuNum    IMUセンサデータ数
	@param[in]      oState    スイング状態
	@return         結果
*/
/*--------------------------------------------------------------------------*/
SwingAnalyzeResult SwingAnalyzer_DetectImpact( const IMUDATA* iImuData, const uint16_t iImuNum, SwingState* state );

/*--------------------------------------------------------------------------*/
 /*! @brief スイングのセンサデータを取得する（指定された格納用エリアにコピーする）

	@param[out]      oImuData    スイングのセンサデータ格納用ポインタ（630データ分エリア）
	@param[out]      oImuNum    格納したセンサデータ数
	@return         結果
*/
/*--------------------------------------------------------------------------*/
SwingAnalyzeResult SwingAnalyzer_GetSwingData( IMUDATA* oImuData, uint16_t* oImuNum );
#endif	/* SWING_ANALYZER_FW */

#ifdef SWING_ANALYZER_SDK
SwingAnalyzeErrorCode SwingAnalyzer_SwingAnalysis( const SWING_ANALYSIS_INPUT* input, SWING_ANALYSIS_OUTPUT* output );

SwingAnalyzeErrorCode SwingAnalyzer_GetExtraSwingAnalysisInfo(const EXTRA_SWING_ANALYSIS_INPUT* input, EXTRA_SWING_ANALYSIS_OUTPUT *output);
#endif	/* SWING_ANALYZER_SDK */

void SwingAnalyzer_GetVersion(uint8_t*  major, uint8_t*  minor, uint8_t* patch);

#ifdef __cplusplus
}
#endif /* __cplusplus */
#endif /* SWING_ANALYZER_H_ */
