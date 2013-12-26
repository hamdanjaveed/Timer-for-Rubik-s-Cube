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
    NSArray *possibleMoves = @[@"F", @"R", @"U", @"L", @"B", @"D", @"F'", @"R'", @"U'", @"L'", @"B'", @"D'", @"F2", @"R2", @"U2", @"L2", @"B2", @"D2"];
    int scrambleLength = 25;
    NSMutableArray *scrambleArray = [NSMutableArray arrayWithObject: [NSNumber numberWithInt:(arc4random() % [possibleMoves count])]];
    for (int i = 1; i < scrambleLength; i++) {
        int nextMove;
        do {
            nextMove = arc4random() % [possibleMoves count];
        } while (nextMove == [scrambleArray[i - 1] integerValue]);
        
        scrambleArray[i] = [NSNumber numberWithInt:nextMove];
    }
    
    NSMutableArray *scrambleArrayMoves = [[NSMutableArray alloc] init];
    for (int i = 0; i < scrambleLength; i++) {
        scrambleArrayMoves[i] = possibleMoves[[scrambleArray[i] integerValue]];
    }
    
    return [scrambleArrayMoves componentsJoinedByString:@"  "];
}

@end
