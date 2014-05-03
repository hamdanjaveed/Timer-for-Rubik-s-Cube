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
@property (strong, nonatomic) NSArray *sectionHeaders;
@property (strong, nonatomic) NSArray *tableCells;
@end

@implementation RubiksSettingsViewController

- (NSArray *)tableCells {
    if (!_tableCells) {
        UITableViewCell *inspectionCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        inspectionCell.textLabel.text = @"Inspection Time";
        inspectionCell.detailTextLabel.text = [NSString stringWithFormat:@"%d seconds", [[[[NSUserDefaults standardUserDefaults] objectForKey:@"settings"] objectForKey:@"inspection time"] intValue]];
        
        UITableViewCell *themeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        themeCell.textLabel.text = @"Theme";
        themeCell.detailTextLabel.text = [USER_SETTINGS objectForKey:THEME_BACKGROUND_KEY];
        themeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UITableViewCell *deleteCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        deleteCell.textLabel.text = @"Delete all Times";
        deleteCell.textLabel.textAlignment = NSTextAlignmentCenter;
        deleteCell.textLabel.textColor = [UIColor redColor];
        
        _tableCells = @[@[inspectionCell], @[themeCell], @[deleteCell]];
    }
    return _tableCells;
}

- (NSArray *)sectionHeaders {
    if (!_sectionHeaders) {
        _sectionHeaders = @[@"Timer", @"General", @"Data"];
    }
    return _sectionHeaders;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionHeaders count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [self.tableCells[section] count];
}

-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"theme segue" sender:nil];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete all times" message:@"Are you sure you want to delete all your times?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
            [alert show];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {
        NSArray *array = [[NSArray alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:TIME_ARRAY_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tableCells[indexPath.section][indexPath.row];
}

- (int)getCurrectCell:(NSIndexPath *)indexPath {
    int sum = 0;
    for (int i = 0; i < indexPath.section; i++) {
        sum += [self.tableCells[i] count];
    }
    sum += indexPath.row;
    return sum;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionHeaders[section];
}

@end
