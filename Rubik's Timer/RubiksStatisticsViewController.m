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
        cell.detailTextLabel.text = [self updateNumberOfSolves];
    } else if ([cellID isEqualToString:@"best"]) {
        cell.detailTextLabel.text = [self updateBest];
    } else if ([cellID isEqualToString:@"worst"]) {
        cell.detailTextLabel.text = [self updateWorst];
    } else if ([cellID isEqualToString:@"average"]) {
        cell.detailTextLabel.text = [self updateAverage];
    } else if ([cellID isEqualToString:@"average5"]) {
        cell.detailTextLabel.text = [self updateAverageOf5];
    } else if ([cellID isEqualToString:@"average10"]) {
        cell.detailTextLabel.text = [self updateAverageOf10];
    } else if ([cellID isEqualToString:@"standard deviation"]) {
        cell.detailTextLabel.text = @"lol";
    }
    
    return cell;
}

- (NSString *)updateWorst {
    if (![self.times count]) {
        return @"No Recorded Solves";
    }
    
    double max = [Time getTimeFromArray:[self.times firstObject]];
    for (int i = 1; i < [self.times count]; i++) {
        max = MAX(max, [Time getTimeFromArray:self.times[i]]);
    }
    return [NSString stringWithFormat:@"%@", [RubiksUtil formatTime:max]];
}

- (NSString *)updateNumberOfSolves {
    int count = (int)[[[NSUserDefaults standardUserDefaults] objectForKey:@"times"] count];
    return [NSString stringWithFormat:@"%d", count];
}

- (NSString *)updateBest {
    if (![self.times count]) {
        return @"No Recorded Solves";
    }
    
    double min = [Time getTimeFromArray:[self.times firstObject]];
    for (int i = 1; i < [self.times count]; i++) {
        min = MIN(min, [Time getTimeFromArray:self.times[i]]);
    }
    return [NSString stringWithFormat:@"%@", [RubiksUtil formatTime:min]];
}

- (NSString *)updateAverage {
    if (![self.times count]) {
        return @"No Recorded Solves";
    }
    
    double sum = [Time getTimeFromArray:[self.times firstObject]];
    for (int i = 1; i < [self.times count]; i++) {
        sum += [Time getTimeFromArray:self.times[i]];
    }
    return [NSString stringWithFormat:@"%@", [RubiksUtil formatTime:sum / [self.times count]]];
}

- (NSString *)updateAverageOf5 {
    int numberOfSolves = (int)[self.times count];
    if (numberOfSolves < 5) {
        return [NSString stringWithFormat:@"Need %d more solve%@", 5 - numberOfSolves, (5 - numberOfSolves == 1) ? @"" : @"s"];
    } else {
        double sum = [Time getTimeFromArray:[self.times firstObject]];
        for (int i = 1; i < 5; i++) {
            sum += [Time getTimeFromArray:self.times[i]];
        }
        return [NSString stringWithFormat:@"%@", [RubiksUtil formatTime:sum / 5]];
    }
}

- (NSString *)updateAverageOf10 {
    int numberOfSolves = (int)[self.times count];
    if (numberOfSolves < 10) {
        return [NSString stringWithFormat:@"Need %d more solve%@", 10 - numberOfSolves, (10 - numberOfSolves == 1) ? @"" : @"s"];
    } else {
        double sum = [Time getTimeFromArray:[self.times firstObject]];
        for (int i = 1; i < 10; i++) {
            sum += [Time getTimeFromArray:self.times[i]];
        }
        return [NSString stringWithFormat:@"%@", [RubiksUtil formatTime:sum / 10]];
    }
}

@end
