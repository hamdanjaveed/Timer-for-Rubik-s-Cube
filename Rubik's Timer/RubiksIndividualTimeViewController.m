//
//  RubiksIndividualTimeViewController.m
//  Rubik's Timer
//
//  Created by Hamdan Javeed on 1/9/2014.
//  Copyright (c) 2014 Hamdan Javeed. All rights reserved.
//

#import "RubiksIndividualTimeViewController.h"
#import "RubiksUtil.h"

@interface RubiksIndividualTimeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *scrambleLabel;
@end

@implementation RubiksIndividualTimeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = [RubiksUtil formatTime:self.time];
    self.timeLabel.text = [RubiksUtil formatTime:self.time];
    self.dateLabel.text = [NSString stringWithFormat:@"Date: %@", [NSDateFormatter localizedStringFromDate:self.date dateStyle:NSDateFormatterFullStyle timeStyle: NSDateFormatterNoStyle]];
    self.scrambleLabel.text = [NSString stringWithFormat:@"Scramble: %@", self.scramble];
}

@end
