//
//  S811AlgorithmInterface.h
//  S811Algorithm
//
//  Created by 5007710 on 2020/03/19.
//  Copyright © 2020 epson. All rights reserved.
//

#ifndef S811AlgorithmInterface_h
#define S811AlgorithmInterface_h

#import "SwingAnalyzer.h"

@protocol S811AlgorithmInterface

#pragma mark - getInstance
+(id<S811AlgorithmInterface>)getInstance;

#pragma mark - analysisSwing
-(SwingAnalyzeErrorCode)analysisSwing:(const SWING_ANALYSIS_INPUT*) input output:(SWING_ANALYSIS_OUTPUT*) output;

-(SwingAnalyzeErrorCode)getExtraSwingAnalysisInfo:(const EXTRA_SWING_ANALYSIS_INPUT*) input output:(EXTRA_SWING_ANALYSIS_OUTPUT*) output;

#endif /* S811AlgorithmInterface_h */

@end
