//
//  Time.m
//  Rubik's Timer
//
//  Created by Hamdan Javeed on 12/29/2013.
//  Copyright (c) 2013 Hamdan Javeed. All rights reserved.
//

#import "Time.h"

/*
 * Array storage format
 * --------------------
 * 0 - time
 * 1 - date
 * 2 - scramble
 */

#define TIME_INDEX 0
#define DATE_INDEX 1
#define SCRAMBLE_INDEX 2

@implementation Time

- (id)initWithTime:(NSTimeInterval)time date:(NSDate *)date andScramble:(NSString *)scramble {
    if (self = [super init]) {
        self.time = time;
        self.date = date;
        self.scramble = scramble;
    }
    return self;
}

+ (NSArray *)convertToArray:(Time *)time {
    return [NSArray arrayWithObjects:[NSNumber numberWithDouble:time.time], time.date, time.scramble, nil];
}

+ (Time *)getFromArray:(NSArray *)array {
    return [[Time alloc] initWithTime:[array[0] doubleValue] date:array[1] andScramble:array[2]];
}

+ (NSTimeInterval)getTimeFromArray:(NSArray *)array {
    return [array[TIME_INDEX] doubleValue];
}

+ (BOOL)isBest:(double)time {
    double min = [Time getTimeFromArray:[USER_TIMES firstObject]];
    for (int i = 1; i < [USER_TIMES count]; i++) {
        min = MIN(min, [Time getTimeFromArray:USER_TIMES[i]]);
    }
    return time == min;
}

+ (BOOL)isWorst:(double)time {
    double max = [self getTimeFromArray:[USER_TIMES firstObject]];
    for (int i = 1; i < [USER_TIMES count]; i++) {
        max = MAX(max, [self getTimeFromArray:USER_TIMES[i]]);
    }
    return time == max;
}

@end
