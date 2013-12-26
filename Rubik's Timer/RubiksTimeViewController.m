//
//  RubiksTimeViewController.m
//  Rubik's Timer
//
//  Created by Hamdan Javeed on 12/15/2013.
//  Copyright (c) 2013 Hamdan Javeed. All rights reserved.
//

#import "RubiksTimeViewController.h"
#import "RubiksUtil.h"


@interface RubiksTimeViewController ()
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) BOOL timerIsRunning;
@property (nonatomic) NSTimeInterval currentTime;
@property (strong, nonatomic) NSDate *fireDate;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (nonatomic) BOOL currentTouchDidStopTimer;
@property (weak, nonatomic) IBOutlet UILabel *scrambleLabel;
@end

@implementation RubiksTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fireDate = [NSDate date];
    [self generateScramble];
}

#define TIME_ARRAY_KEY @"times"
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.timerIsRunning) {
        self.timerIsRunning = NO;
        [self.timer invalidate];
        self.currentTouchDidStopTimer = YES;
        
        NSNumber *time = [NSNumber numberWithDouble:self.currentTime];
        NSMutableArray *timesInMemory = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:TIME_ARRAY_KEY]];
        if (!timesInMemory) {
            timesInMemory = [[NSMutableArray alloc] init];
        }
        [timesInMemory insertObject:time atIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:[timesInMemory copy] forKey:TIME_ARRAY_KEY];
        
        [self generateScramble];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.timerIsRunning && !self.currentTouchDidStopTimer) {
        self.timerIsRunning = YES;
        self.currentTime = 0;
        self.fireDate = [NSDate date];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(update:) userInfo:nil repeats:YES];
        [self.timer fire];
    }
    self.currentTouchDidStopTimer = self.currentTouchDidStopTimer ? NO : YES;
}

- (void)update:(NSTimer *)timer {
    self.currentTime = [[NSDate date] timeIntervalSinceDate:self.fireDate];
    self.timerLabel.text = [RubiksUtil formatTime:self.currentTime];
}

- (void)generateScramble {
    self.scrambleLabel.text = [RubiksUtil generateScramble];
}

@end
