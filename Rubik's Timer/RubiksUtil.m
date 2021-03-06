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
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[USER_SETTINGS objectForKey:THEME_KEY] objectForKey:THEME_BACKGROUND_COLOR_KEY]];
}

+ (UIColor *)getThemeForeground {
    return [UIColor whiteColor];
}

+ (UIColor *)getThemeTint {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[USER_SETTINGS objectForKey:THEME_KEY] objectForKey:THEME_TINT_KEY]];
}

+ (UIColor *)reduceAlphaOfColor:(UIColor *)color
                    byAFactorOf:(float)factor {
    
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    return [UIColor colorWithRed:r green:g blue:b alpha:a * factor];
}

+ (void)setAppropriateStatusBarStyle {
    NSString *themeStatusBarStyle = [[USER_SETTINGS objectForKey:THEME_KEY] objectForKey:THEME_STATUS_BAR_STYLE_KEY];
    if ([themeStatusBarStyle isEqualToString:@"Black"]) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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

+ (BOOL)checkSettingsForCorrectness:(NSDictionary *)settings {
    id inspectionTime = [settings objectForKey:INSPECTION_TIME_KEY];
    id theme = [settings objectForKey:THEME_KEY];
    
    if (inspectionTime && theme) {
        id backgroundColor = [theme objectForKey:THEME_BACKGROUND_COLOR_KEY];
        id backgroundString = [theme objectForKey:THEME_BACKGROUND_STRING_KEY];
        id themeStatusBarStyle = [theme objectForKey:THEME_STATUS_BAR_STYLE_KEY];
        if (backgroundColor && backgroundString && themeStatusBarStyle) {
            return true;
        }
    }
    
    return false;
}

+ (void)buildFiles {
    NSDictionary *orangeWhite = [NSDictionary dictionaryWithObjects:@[[NSKeyedArchiver archivedDataWithRootObject:[UIColor colorWithRed:0.99 green:0.48 blue:0.03 alpha:1]],
                                                                      [NSKeyedArchiver archivedDataWithRootObject:[UIColor colorWithRed:0.38 green:0.72 blue:0.81 alpha:1]],
                                                                      @"Orange",
                                                                      @"Black"]
                                                            forKeys:@[THEME_BACKGROUND_COLOR_KEY,
                                                                      THEME_TINT_KEY,
                                                                      THEME_BACKGROUND_STRING_KEY,
                                                                      THEME_STATUS_BAR_STYLE_KEY]];
    
    NSDictionary *lightBlueWhite = [NSDictionary dictionaryWithObjects:@[[NSKeyedArchiver archivedDataWithRootObject:[UIColor colorWithRed:0.38 green:0.706 blue:0.812 alpha:1]],
                                                                         [NSKeyedArchiver archivedDataWithRootObject:[UIColor colorWithRed:0.761 green:0.361 blue:0.231 alpha:1]],
                                                                         @"Light Blue",
                                                                         @"Black"]
                                                               forKeys:@[THEME_BACKGROUND_COLOR_KEY,
                                                                         THEME_TINT_KEY,
                                                                         THEME_BACKGROUND_STRING_KEY,
                                                                         THEME_STATUS_BAR_STYLE_KEY]];
    
    NSDictionary *darkBlueWhite = [NSDictionary dictionaryWithObjects:@[[NSKeyedArchiver archivedDataWithRootObject:[UIColor colorWithRed:0.208 green:0.569 blue:0.682 alpha:1]],
                                                                        [NSKeyedArchiver archivedDataWithRootObject:[UIColor colorWithRed:0.682 green:0.322 blue:0.208 alpha:1]],
                                                                        @"Dark Blue",
                                                                        @"White"]
                                                              forKeys:@[THEME_BACKGROUND_COLOR_KEY,
                                                                        THEME_TINT_KEY,
                                                                        THEME_BACKGROUND_STRING_KEY,
                                                                        THEME_STATUS_BAR_STYLE_KEY]];
    
    NSDictionary *lightGreenWhite = [NSDictionary dictionaryWithObjects:@[[NSKeyedArchiver archivedDataWithRootObject:[UIColor colorWithRed:0.38 green:0.812 blue:0.486 alpha:1]],
                                                                          [NSKeyedArchiver archivedDataWithRootObject:[UIColor colorWithRed:0.81 green:0.49 blue:0.38 alpha:1]],
                                                                          @"Light Green",
                                                                          @"Black"]
                                                                forKeys:@[THEME_BACKGROUND_COLOR_KEY,
                                                                          THEME_TINT_KEY,
                                                                          THEME_BACKGROUND_STRING_KEY,
                                                                          THEME_STATUS_BAR_STYLE_KEY]];
    
    NSDictionary *purpleWhite = [NSDictionary dictionaryWithObjects:@[[NSKeyedArchiver archivedDataWithRootObject:[UIColor colorWithRed:0.537 green:0.259 blue:0.839 alpha:1]],
                                                                      [NSKeyedArchiver archivedDataWithRootObject:[UIColor colorWithRed:0.56 green:0.84 blue:0.26 alpha:1]],
                                                                      @"Purple",
                                                                      @"White"]
                                                            forKeys:@[THEME_BACKGROUND_COLOR_KEY,
                                                                      THEME_TINT_KEY,
                                                                      THEME_BACKGROUND_STRING_KEY,
                                                                      THEME_STATUS_BAR_STYLE_KEY]];
    
    NSDictionary *blackWhite = [NSDictionary dictionaryWithObjects:@[[NSKeyedArchiver archivedDataWithRootObject:[UIColor colorWithRed:0.23 green:0.23 blue:0.23 alpha:1]],
                                                                     [NSKeyedArchiver archivedDataWithRootObject:[UIColor colorWithRed:0.99 green:0.48 blue:0.03 alpha:1]],
                                                                     @"Black",
                                                                     @"White"]
                                                           forKeys:@[THEME_BACKGROUND_COLOR_KEY,
                                                                     THEME_TINT_KEY,
                                                                     THEME_BACKGROUND_STRING_KEY,
                                                                     THEME_STATUS_BAR_STYLE_KEY]];
    
    NSDictionary *brownBlue = [NSDictionary dictionaryWithObjects:@[[NSKeyedArchiver archivedDataWithRootObject:[UIColor colorWithRed:0.65 green:0.33 blue:0.00 alpha:1]],
                                                                     [NSKeyedArchiver archivedDataWithRootObject:[UIColor colorWithRed:0.38 green:0.72 blue:0.81 alpha:1]],
                                                                     @"Brown",
                                                                     @"Blue"]
                                                           forKeys:@[THEME_BACKGROUND_COLOR_KEY,
                                                                     THEME_TINT_KEY,
                                                                     THEME_BACKGROUND_STRING_KEY,
                                                                     THEME_STATUS_BAR_STYLE_KEY]];
    
    NSArray *themes = [NSArray arrayWithObjects:orangeWhite, lightBlueWhite, darkBlueWhite, lightGreenWhite, purpleWhite, blackWhite, brownBlue, nil];
    NSDictionary *files = [NSDictionary dictionaryWithObject:themes forKey:FILES_THEMES_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:files forKey:FILES_KEY];
    SYNCHRONIZE_SETTINGS;
}

@end
