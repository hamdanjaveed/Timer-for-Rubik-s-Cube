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
    [RubiksUtil setAppropriateStatusBarStyle];
}

- (void)resetSelectedIndexPath {
    NSArray *themes = [FILES objectForKey:FILES_THEMES_KEY];
    NSDictionary *currentTheme = [USER_SETTINGS objectForKey:THEME_KEY];
    NSInteger index = [themes indexOfObject:currentTheme];
    if (index != NSNotFound) {
        self.selectedThemeIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    } else {
        NSLog(@"ERROR: COULD NOT FIND INDEX OF THEME, SETTINGS THEME VC");
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"theme cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *theme = [FILES objectForKey:FILES_THEMES_KEY][indexPath.row];
    cell.textLabel.text = [theme objectForKey:THEME_BACKGROUND_STRING_KEY];
    cell.detailTextLabel.text = [@"with " stringByAppendingString:[theme objectForKey:THEME_FOREGROUND_STRING_KEY]];
    
    return cell;
}

-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    NSDictionary *theme = [FILES objectForKey:FILES_THEMES_KEY][indexPath.row];

    NSMutableDictionary *settings = [USER_SETTINGS mutableCopy];
    [settings setObject:theme forKey:THEME_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:settings forKey:SETTINGS_KEY];
    SYNCHRONIZE_SETTINGS;
    
    [self resetSelectedIndexPath];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[FILES objectForKey:FILES_THEMES_KEY] count];
}

@end
