//
//  RubiksTimeViewController.m
//  Rubik's Timer
//
//  Created by Hamdan Javeed on 12/15/2013.
//  Copyright (c) 2013 Hamdan Javeed. All rights reserved.
//

#import "RubiksTimeViewController.h"
#import "RubiksUtil.h"
#import "Time.h"


@interface RubiksTimeViewController ()
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) BOOL timerIsRunning;
@property (nonatomic) NSTimeInterval currentTime;
@property (strong, nonatomic) NSDate *fireDate;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (nonatomic) BOOL currentTouchDidStopTimer;

@property (strong, nonatomic) NSTimer *inspectionTimer;
@property (nonatomic) BOOL inspectionDidFinish;

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
        
        if (self.inspectionDidFinish) {
            Time *time = [[Time alloc] initWithTime:self.currentTime date:[NSDate date] andScramble:self.scrambleLabel.text];
            NSMutableArray *timesInMemory = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:TIME_ARRAY_KEY]];
            if (!timesInMemory) {
                timesInMemory = [[NSMutableArray alloc] init];
            }
            [timesInMemory insertObject:[Time convertToArray:time] atIndex:0];
            [[NSUserDefaults standardUserDefaults] setObject:[timesInMemory copy] forKey:TIME_ARRAY_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self generateScramble];
        } else {
            self.timerIsRunning = NO;
            [self.inspectionTimer invalidate];
            self.timerLabel.text = @"Tap to start";
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.timerIsRunning && !self.currentTouchDidStopTimer) {
        self.timerIsRunning = YES;
        self.currentTime = 0;
        self.fireDate = [NSDate date];
        self.inspectionTimer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(updateInspectionTimer:) userInfo:nil repeats:YES];
        [self.inspectionTimer fire];
        self.inspectionDidFinish = NO;
    }
    self.currentTouchDidStopTimer = self.currentTouchDidStopTimer ? NO : YES;
}

- (void)update:(NSTimer *)timer {
    self.currentTime = [[NSDate date] timeIntervalSinceDate:self.fireDate];
    self.timerLabel.text = [RubiksUtil formatTime:self.currentTime];
}

#define INSPECTION_TIME 3
- (void)updateInspectionTimer:(NSTimer *)timer {
    if ([[NSDate date] timeIntervalSinceDate:self.fireDate] > INSPECTION_TIME) {
        self.timerIsRunning = YES;
        self.currentTime = 0;
        self.fireDate = [NSDate date];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(update:) userInfo:nil repeats:YES];
        [self.timer fire];
        
        [self.inspectionTimer invalidate];
        self.inspectionDidFinish = YES;
    } else {
        int seconds = INSPECTION_TIME - [[NSDate date] timeIntervalSinceDate:self.fireDate] + 1;
        self.timerLabel.text = [NSString stringWithFormat:@"%d", seconds];
    }
}

- (void)generateScramble {
    self.scrambleLabel.text = [RubiksUtil generateScramble];
}

@end
