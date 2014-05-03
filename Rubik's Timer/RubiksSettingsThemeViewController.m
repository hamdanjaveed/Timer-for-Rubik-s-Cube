//
//  RubiksSettingsThemeViewController.m
//  Rubik's Timer
//
//  Created by Hamdan Javeed on 2/16/2014.
//  Copyright (c) 2014 Hamdan Javeed. All rights reserved.
//

#import "RubiksSettingsThemeViewController.h"

@interface RubiksSettingsThemeViewController ()

@end

@implementation RubiksSettingsThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];

    NSMutableDictionary *settings = [USER_SETTINGS mutableCopy];
    [settings setObject:[tableView cellForRowAtIndexPath:indexPath].textLabel.text forKey:THEME_BACKGROUND_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:settings forKey:SETTINGS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *currentTheme = [USER_SETTINGS objectForKey:THEME_BACKGROUND_KEY];
    NSLog(@"%@", currentTheme);
}

@end
