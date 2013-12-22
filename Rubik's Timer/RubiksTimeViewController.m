//
//  RubiksTimeViewController.m
//  Rubik's Timer
//
//  Created by Hamdan Javeed on 12/15/2013.
//  Copyright (c) 2013 Hamdan Javeed. All rights reserved.
//

#import "RubiksTimeViewController.h"

@interface RubiksTimeViewController ()
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) BOOL timerIsRunning;
@property (nonatomic) NSTimeInterval currentTime;
@property (strong, nonatomic) NSDate *fireDate;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (nonatomic) BOOL currentTouchDidStopTimer;
@end

@implementation RubiksTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fireDate = [NSDate date];
}

#define TIME_ARRAY_KEY @"times"
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.timerIsRunning) {
        self.timerIsRunning = NO;
        [self.timer invalidate];
        self.currentTouchDidStopTimer = YES;
        
        NSNumber *time = [NSNumber numberWithFloat:self.currentTime];
        NSMutableArray *timesInMemory = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:TIME_ARRAY_KEY]];
        if (!timesInMemory) {
            timesInMemory = [[NSMutableArray alloc] init];
        }
        [timesInMemory addObject:time];
        [[NSUserDefaults standardUserDefaults] setObject:[timesInMemory copy] forKey:TIME_ARRAY_KEY];
        
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
    self.timerLabel.text = [self getFormattedLabel];
}

- (NSString *)getFormattedLabel {
    NSString *formattedLabel;
    
    // get subseconds
    NSString *subsecond = [NSString stringWithFormat:@"%f", fmod(self.currentTime, 1.0)];
    if ([subsecond length] > 4) {
        NSRange range = {2, 2};
        subsecond = [subsecond substringWithRange:range];
    }
    
    // get seconds
    NSString *seconds = [NSString stringWithFormat:@"%.0f", floor(self.currentTime)];
    
    // format the string
    if (self.currentTime < 60) {
        formattedLabel = [NSString stringWithFormat:@"%@:%@", seconds, subsecond];
    } else {
        formattedLabel = [NSString stringWithFormat:@"%02li:%02li:%02li",
                          lround(floor(self.currentTime / 3600.)) % 100,
                          lround(floor(self.currentTime / 60.)) % 60,
                          lround(floor(self.currentTime)) % 60];
    }
    
    return formattedLabel;
}

@end
