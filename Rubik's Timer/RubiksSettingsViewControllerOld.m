//
//  RubiksSettingsViewController.m
//  Rubik's Timer
//
//  Created by Hamdan Javeed on 1/10/2014.
//  Copyright (c) 2014 Hamdan Javeed. All rights reserved.
//

#import "RubiksSettingsViewControllerOld.h"

@interface RubiksSettingsViewControllerOld () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *inspectionTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *inspectionSlider;
@end

@implementation RubiksSettingsViewControllerOld

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

- (IBAction)delete {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete all times" message:@"Are you sure you want to delete all your times?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {
        NSArray *array = [[NSArray alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"times"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
