//
//  RubiksStatisticsViewController.m
//  Rubik's Timer
//
//  Created by Hamdan Javeed on 12/25/2013.
//  Copyright (c) 2013 Hamdan Javeed. All rights reserved.
//

#import "RubiksStatisticsViewController.h"
#import "RubiksUtil.h"

@interface RubiksStatisticsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *bestLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageLabel;
@property (weak, nonatomic) IBOutlet UILabel *average5Label;
@property (weak, nonatomic) IBOutlet UILabel *average10Label;

@property (strong, nonatomic) NSArray *times;
@end

@implementation RubiksStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateStatistics];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateStatistics];
}

- (void)updateStatistics {
    self.times = [[NSUserDefaults standardUserDefaults] objectForKey:@"times"];
    if ([self.times count]) {
        [self updateBest];
        [self updateAverage];
        [self updateAverageOf5];
        [self updateAverageOf10];
    } else {
        self.bestLabel.text = @"Best: No recorded solves";
        self.averageLabel.text = @"Average: No recorded solves";
        self.average5Label.text = @"Average of 5: Need 5 more solves";
        self.average10Label.text = @"Average of 10: Need 10 more solves";
    }
}

- (void)updateBest {
    double min = [[self.times firstObject] doubleValue];
    for (int i = 1; i < [self.times count]; i++) {
        min = MIN(min, [self.times[i] doubleValue]);
    }
    self.bestLabel.text = [NSString stringWithFormat:@"Best: %@", [RubiksUtil formatTime:min]];
}

- (void)updateAverage {
    double sum = [[self.times firstObject] doubleValue];
    for (int i = 1; i < [self.times count]; i++) {
        sum += [self.times[i] doubleValue];
    }
    self.averageLabel.text = [NSString stringWithFormat:@"Average: %@", [RubiksUtil formatTime:sum / [self.times count]]];
}

- (void)updateAverageOf5 {
    int numberOfSolves = [self.times count];
    if (numberOfSolves < 5) {
        self.average5Label.text = [NSString stringWithFormat:@"Average of 5: Need %d more solve%@", 5 - numberOfSolves, (5 - numberOfSolves == 1) ? @"" : @"s"];
    } else {
        double sum = [[self.times firstObject] doubleValue];
        for (int i = 1; i < 5; i++) {
            sum += [self.times[i] doubleValue];
        }
        self.average5Label.text = [NSString stringWithFormat:@"Average of 5: %@", [RubiksUtil formatTime:sum / 5]];
    }
}

- (void)updateAverageOf10 {
    int numberOfSolves = [self.times count];
    if (numberOfSolves < 10) {
        self.average10Label.text = [NSString stringWithFormat:@"Average of 10: Need %d more solve%@", 10 - numberOfSolves, (10 - numberOfSolves == 1) ? @"" : @"s"];
    } else {
        double sum = [[self.times firstObject] doubleValue];
        for (int i = 1; i < 10; i++) {
            sum += [self.times[i] doubleValue];
        }
        self.average10Label.text = [NSString stringWithFormat:@"Average of 10: %@", [RubiksUtil formatTime:sum / 10]];
    }
}

@end
