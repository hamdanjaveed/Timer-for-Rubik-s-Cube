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
@property (nonatomic) BOOL shouldAnimate;
@end

@implementation RubiksSettingsThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self resetSelectedIndexPath];
    [RubiksUtil setAppropriateStatusBarStyle];
}

- (void)resetSelectedIndexPath {
    NSArray *themes = [FILES objectForKey:FILES_THEMES_KEY];
    NSDictionary *currentTheme = [USER_SETTINGS objectForKey:THEME_KEY];
    NSInteger index = [themes indexOfObject:currentTheme];
    self.selectedThemeIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"theme cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *theme = [FILES objectForKey:FILES_THEMES_KEY][indexPath.row];
    cell.textLabel.text = [theme objectForKey:THEME_BACKGROUND_STRING_KEY];
    cell.detailTextLabel.text = [@"with " stringByAppendingString:[theme objectForKey:THEME_FOREGROUND_STRING_KEY]];
    cell.backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:[theme objectForKey:THEME_BACKGROUND_COLOR_KEY]];
    [cell.textLabel setTextColor:[NSKeyedUnarchiver unarchiveObjectWithData:[theme objectForKey:THEME_FOREGROUND_COLOR_KEY]]];
    [cell.detailTextLabel setTextColor:[NSKeyedUnarchiver unarchiveObjectWithData:[theme objectForKey:THEME_FOREGROUND_COLOR_KEY]]];
    
    if (self.selectedThemeIndexPath.row == indexPath.row) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        cell.tintColor = [NSKeyedUnarchiver unarchiveObjectWithData:[theme objectForKey:THEME_FOREGROUND_COLOR_KEY]];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    NSDictionary *theme = [FILES objectForKey:FILES_THEMES_KEY][indexPath.row];

    NSMutableDictionary *settings = [USER_SETTINGS mutableCopy];
    [settings setObject:theme forKey:THEME_KEY];
    [[NSUbiquitousKeyValueStore defaultStore] setObject:settings forKey:SETTINGS_KEY];
    SYNCHRONIZE_SETTINGS;
    
    [self resetSelectedIndexPath];
    [self.tableView reloadData];
    
    [UIView animateWithDuration:0.5f animations:^{
        self.navigationController.navigationBar.barTintColor = [RubiksUtil getThemeBackground];
        self.navigationController.navigationBar.tintColor = [RubiksUtil getThemeTint];
        [RubiksUtil setAppropriateStatusBarStyle];
    } completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[FILES objectForKey:FILES_THEMES_KEY] count];
}

@end
