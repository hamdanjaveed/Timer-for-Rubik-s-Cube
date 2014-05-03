//
//  RubiksSettingsThemeViewController.m
//  Rubik's Timer
//
//  Created by Hamdan Javeed on 2/16/2014.
//  Copyright (c) 2014 Hamdan Javeed. All rights reserved.
//

#import "RubiksSettingsThemeViewController.h"

@interface RubiksSettingsThemeViewController ()
@property (strong, nonatomic) NSIndexPath *selectedThemeIndexPath;
@end

@implementation RubiksSettingsThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self resetSelectedIndexPath];
}

- (void)resetSelectedIndexPath {
    NSString *currentTheme = [USER_SETTINGS objectForKey:THEME_BACKGROUND_KEY];
    if ([currentTheme isEqualToString:@"Orange"]) {
        self.selectedThemeIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    } else if ([currentTheme isEqualToString:@"Black"]) {
        self.selectedThemeIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    } else if ([currentTheme isEqualToString:@"Green"]) {
        self.selectedThemeIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if ([self.selectedThemeIndexPath isEqual:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];

    NSMutableDictionary *settings = [USER_SETTINGS mutableCopy];
    [settings setObject:[tableView cellForRowAtIndexPath:indexPath].textLabel.text forKey:THEME_BACKGROUND_KEY];
    NSString *foreground = [[tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text substringFromIndex:[@"with " length]];
    [settings setObject:foreground forKey:THEME_FOREGROUND_KEY];

    [[NSUserDefaults standardUserDefaults] setObject:settings forKey:SETTINGS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self resetSelectedIndexPath];
    [self.tableView reloadData];
}

@end
