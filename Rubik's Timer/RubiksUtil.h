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

@end
