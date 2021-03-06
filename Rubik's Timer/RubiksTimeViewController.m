//
//  RubiksTimeViewController.m
//  Rubik's Timer
//
//  Created by Hamdan Javeed on 12/15/2013.
//  Copyright (c) 2013 Hamdan Javeed. All rights reserved.
//

#import "RubiksTimeViewController.h"
#import "Time.h"

/*
 NSUserDefaults Structure:
 -------------------------

 > times (NSArray)
 
 > settings (NSDictionary)
    - inspection time: NSNumber
    - theme: NSDictionary (proposed)
        - background color: UIColor
        - foreground color: UIColor
        - background string: NSString
        - foreground string: NSString
        - status bar style: NSString
        - tint: UIColor
 
 > files (NSDictionary)
    - themes: NSArray
        - theme[i] (NSDictionary)
            - background color: UIColor
            - foreground color: UIColor
            - background string: NSString
            - foreground string: NSString
            - status bar style: NSString
            - tint: UIColor
 */

@interface RubiksTimeViewController ()
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) BOOL timerIsRunning;
@property (nonatomic) NSTimeInterval currentTime;
@property (strong, nonatomic) NSDate *fireDate;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (nonatomic) BOOL currentTouchDidStopTimer;

@property (strong, nonatomic) NSTimer *inspectionTimer;
@property (nonatomic) BOOL inspectionDidFinish;
@property (nonatomic) int startingInspectionTime;

@property (weak, nonatomic) IBOutlet UILabel *scrambleLabel;

@property (weak, nonatomic) IBOutlet UIView *blurView;
@property (nonatomic) BOOL isBlurred;
@end

@implementation RubiksTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fireDate = [NSDate date];
    [self generateScramble];
    
    [self.blurView setOpaque:NO];
    [self.blurView setUserInteractionEnabled:NO];
    
    [RubiksUtil buildFiles];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *settings = [ud objectForKey:SETTINGS_KEY];
    
    if (![RubiksUtil checkSettingsForCorrectness:settings]) {
        NSNumber *inspectionTime = @(15);
        
        NSDictionary *theme = [[FILES objectForKey:FILES_THEMES_KEY] firstObject];
        settings = [[NSDictionary alloc] initWithObjectsAndKeys:inspectionTime, INSPECTION_TIME_KEY, theme, THEME_KEY, nil];
        [ud setObject:settings forKey:SETTINGS_KEY];
        [ud synchronize];
    }

    self.startingInspectionTime = [[USER_SETTINGS objectForKey:INSPECTION_TIME_KEY] intValue];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIColor *foreground = [RubiksUtil getThemeForeground];
    [self.timerLabel setTextColor:foreground];
    [self.scrambleLabel setTextColor:[RubiksUtil reduceAlphaOfColor:foreground
                                                        byAFactorOf:FOREGROUND_LIGHT_ALPHA_REDUCTION_FACTOR]];
    
    [RubiksUtil setAppropriateStatusBarStyle];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.startingInspectionTime = [[USER_SETTINGS objectForKey:INSPECTION_TIME_KEY] intValue];
    
    if (self.timerIsRunning) {
        self.timerIsRunning = NO;
        self.currentTouchDidStopTimer = YES;
        
        if (self.inspectionDidFinish) {
            [self.timer invalidate];
            Time *time = [[Time alloc] initWithTime:self.currentTime date:[NSDate date] andScramble:self.scrambleLabel.text];
            NSMutableArray *timesInMemory = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:TIMES_KEY]];
            if (!timesInMemory) {
                timesInMemory = [[NSMutableArray alloc] init];
            }
            [timesInMemory insertObject:[Time convertToArray:time] atIndex:0];
            [[NSUserDefaults standardUserDefaults] setObject:[timesInMemory copy] forKey:TIMES_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self generateScramble];
            
            [self toggleBlur];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.startingInspectionTime && !self.currentTouchDidStopTimer) {
        self.timerIsRunning = YES;
        self.currentTime = 0;
        self.fireDate = [NSDate date];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(update:) userInfo:nil repeats:YES];
        [self.timer fire];
        self.inspectionDidFinish = YES;
        
        [self toggleBlur];
    } else {
        if (!self.timerIsRunning && !self.currentTouchDidStopTimer) {
            self.timerIsRunning = YES;
            self.currentTime = 0;
            self.fireDate = [NSDate date];
            self.inspectionTimer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(updateInspectionTimer:) userInfo:nil repeats:YES];
            [self.inspectionTimer fire];
            self.inspectionDidFinish = NO;
        
            [self toggleBlur];
        } else if (!self.inspectionDidFinish) {
            self.timerIsRunning = YES;
            self.currentTime = 0;
            self.fireDate = [NSDate date];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(update:) userInfo:nil repeats:YES];
            [self.timer fire];
        
            [self.inspectionTimer invalidate];
            self.inspectionDidFinish = YES;
        }
    }
    self.currentTouchDidStopTimer = self.currentTouchDidStopTimer ? NO : YES;
}

#define ANIMATION_TIME 0.3f
- (void)toggleBlur {
    if (self.isBlurred) {
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            self.blurView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        }];
    } else {
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            self.blurView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        }];
    }
    self.isBlurred = !self.isBlurred;
}

- (void)update:(NSTimer *)timer {
    self.currentTime = [[NSDate date] timeIntervalSinceDate:self.fireDate];
    self.timerLabel.text = [RubiksUtil formatTime:self.currentTime];
}

- (void)updateInspectionTimer:(NSTimer *)timer {
    if ([[NSDate date] timeIntervalSinceDate:self.fireDate] > self.startingInspectionTime) {
        self.timerIsRunning = YES;
        self.currentTime = 0;
        self.fireDate = [NSDate date];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(update:) userInfo:nil repeats:YES];
        [self.timer fire];
        
        [self.inspectionTimer invalidate];
        self.inspectionDidFinish = YES;
    } else {
        int seconds = self.startingInspectionTime - [[NSDate date] timeIntervalSinceDate:self.fireDate] + 1;
        self.timerLabel.text = [NSString stringWithFormat:@"%d", seconds];
    }
}

- (void)generateScramble {
    self.scrambleLabel.text = [RubiksUtil generateScramble];
}

@end
