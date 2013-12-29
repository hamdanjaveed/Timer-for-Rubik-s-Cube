//
//  RubiksViewTimeViewController.m
//  Rubik's Timer
//
//  Created by Hamdan Javeed on 12/21/2013.
//  Copyright (c) 2013 Hamdan Javeed. All rights reserved.
//

#import "RubiksViewTimeViewController.h"
#import "RubiksUtil.h"
#import "Time.h"

@interface RubiksViewTimeViewController ()

@end

@implementation RubiksViewTimeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[NSUserDefaults standardUserDefaults] arrayForKey:@"times"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Time Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSArray *times = [[NSUserDefaults standardUserDefaults] arrayForKey:@"times"];
    [[cell textLabel] setText:[RubiksUtil formatTime:[Time getTimeFromArray:[times objectAtIndex:indexPath.row]]]];
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        /*
         * BUG: tap delete on last item fast, will crash on 2nd line
         * RESOLVE: (if)->check for indexpath
         */
        
        if (indexPath) {
            // Delete the row from the data source
            NSMutableArray *times = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"times"]];
            [times removeObjectAtIndex:indexPath.row];
            [[NSUserDefaults standardUserDefaults] setObject:[times copy] forKey:@"times"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
