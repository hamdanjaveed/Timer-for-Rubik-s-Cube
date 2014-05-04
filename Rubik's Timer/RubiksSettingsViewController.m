//
//  RubiksSettingsViewController.m
//  Rubik's Timer
//
//  Created by Hamdan Javeed on 2/15/2014.
//  Copyright (c) 2014 Hamdan Javeed. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "RubiksSettingsViewController.h"

@interface RubiksSettingsViewController () <UIAlertViewDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *inspectionTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *inspectionTimeSlider;
@property (weak, nonatomic) IBOutlet UILabel *themeLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@end

@implementation RubiksSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setData];
    [RubiksUtil setAppropriateStatusBarStyle];
}

- (void)setData {
    [self.inspectionTimeLabel setText:[RubiksUtil pluralizeStringWithSingularForm:@"second"
                                                                         zeroForm:@"No inspection time"
                                                                     andParameter:[[USER_SETTINGS objectForKey:INSPECTION_TIME_KEY] intValue]]];
    [self.inspectionTimeSlider setValue:[[USER_SETTINGS objectForKey:INSPECTION_TIME_KEY] floatValue]];
    [self.inspectionTimeSlider setMinimumTrackTintColor:[RubiksUtil getThemeBackground]];
    
    [self.themeLabel setText:[[USER_SETTINGS objectForKey:THEME_KEY] objectForKey:THEME_BACKGROUND_STRING_KEY]];
    [self.themeLabel setTextColor:[RubiksUtil getThemeBackground]];
    
    [self.versionLabel setText:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    [self.versionLabel setTextColor:[RubiksUtil getThemeBackground]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete all times" message:@"Are you sure you want to delete all your times?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
            [alert show];
        }
    } else if (indexPath.section == 2) {
        MFMailComposeViewController *emailVC = [[MFMailComposeViewController alloc] init];
        emailVC.mailComposeDelegate = self;
        [emailVC setToRecipients:@[@"timerforrubikscube@gmail.com"]];
        
        switch (indexPath.row) {
            // write a review
            case 1:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id783217916"]];
                break;
            
            // request a feature
            case 2:
                [emailVC setSubject:@"Feature request for Timer for Rubik's Cube"];
                [emailVC setMessageBody:@"Request a feature that you really  want and I'll try to implement it as best and as quickly as I can :D\n-------------------------------------------\nRequest your feature here:\n" isHTML:NO];
                [self presentViewController:emailVC animated:YES completion:nil];
                break;

            // send feedback
            case 3:
                [emailVC setSubject:@"Feedback for Timer for Rubik's Cube"];
                [emailVC setMessageBody:@"Anything you like? Anything you don't like?\n-------------------------------------------\nWrite your feedback here:\n" isHTML:NO];
                [self presentViewController:emailVC animated:YES completion:nil];
                break;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self becomeFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {
        NSArray *array = [[NSArray alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:TIMES_KEY];
        SYNCHRONIZE_SETTINGS;
    }
}

- (IBAction)inspectionTimerDidChange:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [slider setValue:round(slider.value) animated:NO];
    int time = (int) slider.value;
    [self.inspectionTimeLabel setText:[RubiksUtil pluralizeStringWithSingularForm:@"second"
                                                                         zeroForm:@"No inspection time"
                                                                     andParameter:time]];
    
    NSMutableDictionary *settings = [USER_SETTINGS mutableCopy];
    [settings setObject:[NSNumber numberWithInt:time] forKey:INSPECTION_TIME_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:[settings copy] forKey:SETTINGS_KEY];
    SYNCHRONIZE_SETTINGS;
}

@end
