//
//  Time.h
//  Rubik's Timer
//
//  Created by Hamdan Javeed on 12/29/2013.
//  Copyright (c) 2013 Hamdan Javeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Time : NSObject

@property (nonatomic) NSTimeInterval time;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *scramble;

- (id)initWithTime:(NSTimeInterval)time date:(NSDate *)date andScramble:(NSString *)scramble;

+ (NSArray *)convertToArray:(Time *)time;
+ (Time *)getFromArray:(NSArray *)array;

+ (NSTimeInterval)getTimeFromArray:(NSArray *)array;

+ (BOOL)isBest:(double)time;
+ (BOOL)isWorst:(double)time;

@end
