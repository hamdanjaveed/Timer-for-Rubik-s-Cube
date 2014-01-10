//
//  RubiksSettingsViewController.m
//  Rubik's Timer
//
//  Created by Hamdan Javeed on 1/10/2014.
//  Copyright (c) 2014 Hamdan Javeed. All rights reserved.
//

#import "RubiksSettingsViewController.h"

@interface RubiksSettingsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *inspectionTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *inspectionSlider;
@end

@implementation RubiksSettingsViewController

- (void)viewDidLoad {
    int value = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"settings"] objectForKey:@"inspection time"] intValue];
    self.inspectionTimeLabel.text = [NSString stringWithFormat:@"Inspection Time: %d seconds", value];
    self.inspectionSlider.value = value;
}

- (IBAction)inspectionTimeUpdated:(UISlider *)sender {
    int value = sender.value;
    self.inspectionTimeLabel.text = [NSString stringWithFormat:@"Inspection Time: %d seconds", value];
    [sender setValue:value];
    
    NSMutableDictionary *settings = [[[NSUserDefaults standardUserDefaults] objectForKey:@"settings"] mutableCopy];
    [settings setObject:[NSNumber numberWithInt:value] forKey:@"inspection time"];
    [[NSUserDefaults standardUserDefaults] setObject:[settings copy] forKey:@"settings"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
