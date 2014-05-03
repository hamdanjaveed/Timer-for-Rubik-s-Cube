//
//  RubiksSettingsViewController.m
//  Rubik's Timer
//
//  Created by Hamdan Javeed on 2/15/2014.
//  Copyright (c) 2014 Hamdan Javeed. All rights reserved.
//

#import "RubiksSettingsViewController.h"
#import "RubiksSettingsThemeViewController.h"

@interface RubiksSettingsViewController () <UIAlertViewDelegate>
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
    [RubiksUtil setAppropriateStatusBarStyleWithShouldCheck:NO];
}

- (void)setData {
    [self.inspectionTimeLabel setText:[RubiksUtil pluralizeStringWithSingularForm:@"second"
                                                                         zeroForm:@"No inspection time"
                                                                     andParameter:[[USER_SETTINGS objectForKey:INSPECTION_TIME_KEY] intValue]]];
    [self.inspectionTimeSlider setValue:[[USER_SETTINGS objectForKey:INSPECTION_TIME_KEY] floatValue]];
    
    [self.themeLabel setText:[USER_SETTINGS objectForKey:THEME_BACKGROUND_KEY]];
    
    [self.versionLabel setText:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
}

-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete all times" message:@"Are you sure you want to delete all your times?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
            [alert show];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {
        NSArray *array = [[NSArray alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:TIME_ARRAY_KEY];
        SYNCHRONIZE_SETTINGS;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
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
