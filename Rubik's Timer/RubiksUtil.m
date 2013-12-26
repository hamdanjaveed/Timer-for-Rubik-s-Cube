//
//  RubiksUtil.m
//  Rubik's Timer
//
//  Created by Hamdan Javeed on 12/25/2013.
//  Copyright (c) 2013 Hamdan Javeed. All rights reserved.
//

#import "RubiksUtil.h"

@implementation RubiksUtil

+ (NSString *)generateScramble {
    NSArray *possibleMoves = @[@"F", @"F'", @"F2", @"R", @"R'", @"R2", @"U", @"U'", @"U2", @"B", @"B'", @"B2", @"D", @"D'", @"D2", @"L", @"L'", @"L2"];
    int scrambleLength = 25;
    NSMutableArray *scrambleArray = [NSMutableArray arrayWithObject: [NSNumber numberWithInt:(arc4random() % [possibleMoves count])]];
    for (int i = 1; i < scrambleLength; i++) {
        int nextMove;
        do {
            nextMove = arc4random() % [possibleMoves count];
        } while (nextMove / 3 == [scrambleArray[i - 1] intValue] / 3);
        
        scrambleArray[i] = [NSNumber numberWithInt:nextMove];
    }
    
    NSMutableArray *scrambleArrayMoves = [[NSMutableArray alloc] init];
    for (int i = 0; i < scrambleLength; i++) {
        scrambleArrayMoves[i] = possibleMoves[[scrambleArray[i] integerValue]];
    }
    
    return [scrambleArrayMoves componentsJoinedByString:@"  "];
}

@end
