//
//  RubiksUtil.m
//  Rubik's Timer
//
//  Created by Hamdan Javeed on 12/25/2013.
//  Copyright (c) 2013 Hamdan Javeed. All rights reserved.
//

#import "RubiksUtil.h"
#import "Time.h"

@implementation RubiksUtil

+ (NSString *)generateScramble {
    NSArray *possibleMoves = @[@"F", @"F'", @"F2", @"B", @"B'", @"B2", @"R", @"R'", @"R2", @"L", @"L'", @"L2", @"U", @"U'", @"U2", @"D", @"D'", @"D2"];
    int scrambleLength = 25;
    int move1 = arc4random() % [possibleMoves count];
    int move2 = arc4random() % [possibleMoves count];
    do {
        move2 = arc4random() % [possibleMoves count];
    } while (move2 / 3 == move1 / 3);
    NSMutableArray *scrambleArray = [[NSMutableArray alloc] init];
    [scrambleArray addObject:[NSNumber numberWithInt:move1]];
    [scrambleArray addObject:[NSNumber numberWithInt:move2]];
    for (int i = 2; i < scrambleLength; i++) {
        scrambleArray[i] = [self getNextScrambleMoveWithPreviousMove:[scrambleArray[i - 1] intValue] andMoveBeforeThat:[scrambleArray[i - 2] intValue] withPossibleMoves:possibleMoves];
    }
    
    NSMutableArray *scrambleArrayMoves = [[NSMutableArray alloc] init];
    for (int i = 0; i < scrambleLength; i++) {
        scrambleArrayMoves[i] = possibleMoves[[scrambleArray[i] integerValue]];
    }
    
    return [scrambleArrayMoves componentsJoinedByString:@"  "];
}

+ (NSNumber *)getNextScrambleMoveWithPreviousMove:(int)previous andMoveBeforeThat:(int)moveBeforeThat withPossibleMoves:(NSArray *)possibleMoves {
    // get new move
    int new = arc4random() % [possibleMoves count];
    // check if this move is the same as the previous move and if all their axes are the same
    while ((new / 3 == previous / 3) || (new / 6 == previous / 6 && previous / 6 == moveBeforeThat / 6)) {
        return [self getNextScrambleMoveWithPreviousMove:previous andMoveBeforeThat:moveBeforeThat withPossibleMoves:possibleMoves];
    }
    return [NSNumber numberWithInt:new];
}

+ (NSString *)formatTime:(double)seconds {
    int minutes = seconds / 60;
    seconds -= minutes * 60;
    return [NSString stringWithFormat:@"%@%@", minutes ? [NSString stringWithFormat:@"%d:", minutes] : @"", (seconds < 10 && minutes) ? [NSString stringWithFormat:@"0%.2f", seconds] : [NSString stringWithFormat:@"%.2f", seconds]];
}

+ (NSString *)getEmailMessageBody {
    NSArray *timeObjects = USER_TIMES;
    NSMutableArray *times = [[NSMutableArray alloc] init];
    for (NSArray *timeArray in timeObjects) {
        [times addObject:[NSNumber numberWithDouble:[Time getTimeFromArray:timeArray]]];
    }
    return [times componentsJoinedByString:@"\n"];
}

+ (UIColor *)getThemeBackground {
    NSString *background = [USER_SETTINGS objectForKey:THEME_BACKGROUND_KEY];
    if ([background isEqualToString:@"Black"]) {
        return [UIColor blackColor];
    } else if ([background isEqualToString:@"Green"]) {
        return [UIColor greenColor];
    } else {
        return [UIColor orangeColor];
    }
}

+ (UIColor *)getThemeForeground {
    NSString *foreground = [USER_SETTINGS objectForKey:THEME_FOREGROUND_KEY];
    if ([foreground isEqualToString:@"Black"]) {
        return [UIColor blackColor];
    } else {
        return [UIColor whiteColor];
    }
}

+ (UIColor *)reduceAlphaOfColor:(UIColor *)color
                    byAFactorOf:(float)factor {
    
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    return [UIColor colorWithRed:r green:g blue:b alpha:a * factor];
}

+ (void)setAppropriateStatusBarStyleWithShouldCheck:(BOOL)shouldCheck {
    if (!shouldCheck) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    } else {
        NSString *background = [USER_SETTINGS objectForKey:THEME_BACKGROUND_KEY];
        if ([background isEqualToString:@"Black"]) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }
    }
}

+ (NSString *)pluralizeStringWithSingularForm:(NSString *)singular
                                     zeroForm:(NSString *)zeroForm
                                 andParameter:(int)parameter {
    
    NSString *pluralOrSingular = (parameter == 1) ? [@"%d " stringByAppendingString:singular] : [[@"%d " stringByAppendingString:singular] stringByAppendingString:@"s"];
    NSString *finalString;
    if (parameter == 0) {
        finalString = zeroForm;
    } else {
        finalString = [NSString stringWithFormat:pluralOrSingular, parameter];
    }
    
    return finalString;
}

@end
