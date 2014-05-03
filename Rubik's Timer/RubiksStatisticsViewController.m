//
//  RubiksStatisticsViewController.m
//  Rubik's Timer
//
//  Created by Hamdan Javeed on 12/25/2013.
//  Copyright (c) 2013 Hamdan Javeed. All rights reserved.
//

#import "RubiksStatisticsViewController.h"
#import "Time.h"

@interface RubiksStatisticsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfSolvesLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageLabel;
@property (weak, nonatomic) IBOutlet UILabel *average5Label;
@property (weak, nonatomic) IBOutlet UILabel *average10Label;
@property (weak, nonatomic) IBOutlet UILabel *worstLabel;

@property (strong, nonatomic) NSArray *times;
@end

@implementation RubiksStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateStatistics];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIColor *foreground = [RubiksUtil getThemeForeground];
    [self.titleLabel setTextColor:foreground];
    UIColor *foregroundLight = [RubiksUtil reduceAlphaOfColor:foreground
                                                  byAFactorOf:FOREGROUND_LIGHT_ALPHA_REDUCTION_FACTOR];
    [self.numberOfSolvesLabel setTextColor:foregroundLight];
    [self.bestLabel setTextColor:foregroundLight];
    [self.average10Label setTextColor:foregroundLight];
    [self.average5Label setTextColor:foregroundLight];
    [self.averageLabel setTextColor:foregroundLight];
    [self.worstLabel setTextColor:foregroundLight];
    
    [self updateStatistics];
    [RubiksUtil setAppropriateStatusBarStyleWithShouldCheck:YES];
}

- (void)updateStatistics {
    self.times = [[NSUserDefaults standardUserDefaults] objectForKey:TIME_ARRAY_KEY];
    if ([self.times count]) {
        [self updateNumberOfSolves];
        [self updateBest];
        [self updateWorst];
        [self updateAverage];
        [self updateAverageOf5];
        [self updateAverageOf10];
    } else {
        self.bestLabel.text = @"Best: No recorded solves";
        self.numberOfSolvesLabel.text = @"Number of solves: 0";
        self.worstLabel.text = @"Worst: No recorded solves";
        self.averageLabel.text = @"Average: No recorded solves";
        self.average5Label.text = @"Average of 5: Need 5 more solves";
        self.average10Label.text = @"Average of 10: Need 10 more solves";
    }
}

- (void)updateWorst {
    double max = [Time getTimeFromArray:[self.times firstObject]];
    for (int i = 1; i < [self.times count]; i++) {
        max = MAX(max, [Time getTimeFromArray:self.times[i]]);
    }
    self.worstLabel.text = [NSString stringWithFormat:@"Worst: %@", [RubiksUtil formatTime:max]];
}

- (void)updateNumberOfSolves {
    int count = (int)[[[NSUserDefaults standardUserDefaults] objectForKey:@"times"] count];
    self.numberOfSolvesLabel.text = [NSString stringWithFormat:@"Number of solves: %d", count];
}

- (void)updateBest {
    double min = [Time getTimeFromArray:[self.times firstObject]];
    for (int i = 1; i < [self.times count]; i++) {
        min = MIN(min, [Time getTimeFromArray:self.times[i]]);
    }
    self.bestLabel.text = [NSString stringWithFormat:@"Best: %@", [RubiksUtil formatTime:min]];
}

- (void)updateAverage {
    double sum = [Time getTimeFromArray:[self.times firstObject]];
    for (int i = 1; i < [self.times count]; i++) {
        sum += [Time getTimeFromArray:self.times[i]];
    }
    self.averageLabel.text = [NSString stringWithFormat:@"Average: %@", [RubiksUtil formatTime:sum / [self.times count]]];
}

- (void)updateAverageOf5 {
    NSUInteger numberOfSolves = [self.times count];
    if (numberOfSolves < 5) {
        self.average5Label.text = [NSString stringWithFormat:@"Average of 5: Need %lu more solve%@", 5 - numberOfSolves, (5 - numberOfSolves == 1) ? @"" : @"s"];
    } else {
        double sum = [Time getTimeFromArray:[self.times firstObject]];
        for (int i = 1; i < 5; i++) {
            sum += [Time getTimeFromArray:self.times[i]];
        }
        self.average5Label.text = [NSString stringWithFormat:@"Average of 5: %@", [RubiksUtil formatTime:sum / 5]];
    }
}

- (void)updateAverageOf10 {
    NSUInteger numberOfSolves = [self.times count];
    if (numberOfSolves < 10) {
        self.average10Label.text = [NSString stringWithFormat:@"Average of 10: Need %lu more solve%@", 10 - numberOfSolves, (10 - numberOfSolves == 1) ? @"" : @"s"];
    } else {
        double sum = [Time getTimeFromArray:[self.times firstObject]];
        for (int i = 1; i < 10; i++) {
            sum += [Time getTimeFromArray:self.times[i]];
        }
        self.average10Label.text = [NSString stringWithFormat:@"Average of 10: %@", [RubiksUtil formatTime:sum / 10]];
    }
}

@end
