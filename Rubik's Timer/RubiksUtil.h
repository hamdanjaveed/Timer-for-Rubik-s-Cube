//
//  RubiksUtil.h
//  Rubik's Timer
//
//  Created by Hamdan Javeed on 12/25/2013.
//  Copyright (c) 2013 Hamdan Javeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RubiksUtil : NSObject

+ (NSString *)generateScramble;
+ (NSString *)formatTime:(double)seconds;
+ (NSString *)getEmailMessageBody;
+ (UIColor *)getThemeBackground;
+ (UIColor *)getThemeForeground;
+ (UIColor *)getThemeTint;
+ (UIColor *)reduceAlphaOfColor:(UIColor *)color
                    byAFactorOf:(float)factor;
+ (void)setAppropriateStatusBarStyle;
+ (NSString *)pluralizeStringWithSingularForm:(NSString *)singular
                                     zeroForm:(NSString *)zeroForm
                                 andParameter:(int)parameter;
+ (BOOL)checkSettingsForCorrectness:(NSDictionary *)settings;
+ (void)buildFiles;

@end
