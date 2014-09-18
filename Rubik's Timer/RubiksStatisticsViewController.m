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
@property (strong, nonatomic) NSArray *times;
@end

@implementation RubiksStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.times = [[NSUserDefaults standardUserDefaults] objectForKey:TIMES_KEY];
    [self.tableView reloadData];
    [RubiksUtil setAppropriateStatusBarStyle];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    NSString *cellID = cell.reuseIdentifier;
    if ([cellID isEqualToString:@"number of solves"]) {
        cell.detailTextLabel.text = [self calculateNumberOfSolves];
    } else if ([cellID isEqualToString:@"best"]) {
        cell.detailTextLabel.text = [self calculateBest];
    } else if ([cellID isEqualToString:@"worst"]) {
        cell.detailTextLabel.text = [self calculateWorst];
    } else if ([cellID isEqualToString:@"average"]) {
        cell.detailTextLabel.text = [self calculateAverage];
    } else if ([cellID isEqualToString:@"average5"]) {
        cell.detailTextLabel.text = [self calculateAverageOf:5];
    } else if ([cellID isEqualToString:@"average10"]) {
        cell.detailTextLabel.text = [self calculateAverageOf:10];
    } else if ([cellID isEqualToString:@"average12"]) {
        cell.detailTextLabel.text = [self calculateAverageOf:12];
    } else if ([cellID isEqualToString:@"standard deviation"]) {
        cell.detailTextLabel.text = [self calculateStandardDeviation];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)calculateWorst {
    if (![self.times count]) {
        return @"No Recorded Solves";
    }
    
    double max = [Time getTimeFromArray:[self.times firstObject]];
    for (int i = 1; i < [self.times count]; i++) {
        max = MAX(max, [Time getTimeFromArray:self.times[i]]);
    }
    return [NSString stringWithFormat:@"%@", [RubiksUtil formatTime:max]];
}

- (NSString *)calculateNumberOfSolves {
    int count = (int)[[[NSUserDefaults standardUserDefaults] objectForKey:@"times"] count];
    return [NSString stringWithFormat:@"%d", count];
}

- (NSString *)calculateBest {
    if (![self.times count]) {
        return @"No Recorded Solves";
    }
    
    double min = [Time getTimeFromArray:[self.times firstObject]];
    for (int i = 1; i < [self.times count]; i++) {
        min = MIN(min, [Time getTimeFromArray:self.times[i]]);
    }
    return [NSString stringWithFormat:@"%@", [RubiksUtil formatTime:min]];
}

- (NSString *)calculateAverage {
    if (![self.times count]) {
        return @"No Recorded Solves";
    }
    
    double sum = [Time getTimeFromArray:[self.times firstObject]];
    for (int i = 1; i < [self.times count]; i++) {
        sum += [Time getTimeFromArray:self.times[i]];
    }
    return [NSString stringWithFormat:@"%@", [RubiksUtil formatTime:sum / [self.times count]]];
}

- (NSString *)calculateAverageOf:(int)averageCount {
    int numberOfSolves = (int)[self.times count];
    if (numberOfSolves < averageCount) {
        return [NSString stringWithFormat:@"Need %d more solve%@", averageCount - numberOfSolves, (averageCount - numberOfSolves == 1) ? @"" : @"s"];
    } else {
        double sum = [Time getTimeFromArray:[self.times firstObject]];
        for (int i = 1; i < averageCount; i++) {
            sum += [Time getTimeFromArray:self.times[i]];
        }
        return [NSString stringWithFormat:@"%@", [RubiksUtil formatTime:sum / averageCount]];
    }
}

- (NSString *)calculateStandardDeviation {
    if (![self.times count]) {
        return @"No Recorded Solves";
    }

    double total = 0.0f;

    for (int i = 0; i < [self.times count]; i++) {
        total += [Time getTimeFromArray:self.times[i]];
    }

    double mean = total / [self.times count];

    NSMutableArray *values = [NSMutableArray arrayWithCapacity:[self.times count]];

    for (int i = 0; i < [self.times count]; i++) {
        [values addObject:[NSNumber numberWithDouble:pow([Time getTimeFromArray:self.times[i]] - mean, 2)]];
    }

    double secondTotal = 0.0f;

    for (int i = 0; i < [values count]; i++) {
        secondTotal += [values[i] doubleValue];
    }

    return [NSString stringWithFormat:@"%f", sqrt(secondTotal / [values count])];
}

@end
