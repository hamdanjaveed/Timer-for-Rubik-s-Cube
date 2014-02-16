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

#define ORANGE_WHITE 0
-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *currentTheme = [[[NSUserDefaults standardUserDefaults] objectForKey:@"settings"] objectForKey:@"theme"];
    NSLog(@"%@", currentTheme);
    if (indexPath.row == ORANGE_WHITE) {
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
}

@end
