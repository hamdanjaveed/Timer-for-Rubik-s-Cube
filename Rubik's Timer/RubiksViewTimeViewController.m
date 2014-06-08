//
//  RubiksViewTimeViewController.m
//  Rubik's Timer
//
//  Created by Hamdan Javeed on 12/21/2013.
//  Copyright (c) 2013 Hamdan Javeed. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "RubiksViewTimeViewController.h"
#import "Time.h"
#import "RubiksIndividualTimeViewController.h"

@interface RubiksViewTimeViewController () <MFMailComposeViewControllerDelegate>
@property (nonatomic) int bestRow;
@property (nonatomic) int worstRow;
@end

@implementation RubiksViewTimeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
    [RubiksUtil setAppropriateStatusBarStyle];
}

- (void)viewDidLoad {
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return [USER_TIMES count];
    }
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    return @[@"Records", @"All"][section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Time Cell";
    static NSString *BestCellIdentifier = @"Best Time Cell";
    static NSString *WorstCellIdentifier = @"Worst Time Cell";
    static NSString *BestAllCellIdentifier = @"Best Time Cell All";
    static NSString *WorstAllCellIdentifier = @"Worst Time Cell All";
    
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:BestCellIdentifier forIndexPath:indexPath];
        } else if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:WorstCellIdentifier forIndexPath:indexPath];
        }
        
        if ([USER_TIMES count] == 0) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else {
        double time = [Time getTimeFromArray:[USER_TIMES objectAtIndex:indexPath.row]];
        if ([Time isBest:time]) {
            cell = [tableView dequeueReusableCellWithIdentifier:BestAllCellIdentifier forIndexPath:indexPath];
        } else if ([Time isWorst:time]) {
            cell = [tableView dequeueReusableCellWithIdentifier:WorstAllCellIdentifier forIndexPath:indexPath];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        }
    }
    
    if (indexPath.section == 0) {
        int index = 0;
        if (indexPath.row == 0) {
            // best
            double min = [Time getTimeFromArray:[USER_TIMES firstObject]];
            for (int i = 1; i < [USER_TIMES count]; i++) {
                index = (min > [Time getTimeFromArray:USER_TIMES[i]]) ? i : index;
                min = MIN(min, [Time getTimeFromArray:USER_TIMES[i]]);
            }
            if (min) {
                self.bestRow = index;
                [[cell detailTextLabel] setText:[RubiksUtil formatTime:[Time getTimeFromArray:USER_TIMES[index]]]];
            } else {
                [[cell detailTextLabel] setText:@"N/A"];
            }
        } else {
            // worst
            double max = [Time getTimeFromArray:[USER_TIMES firstObject]];
            for (int i = 1; i < [USER_TIMES count]; i++) {
                index = (max < [Time getTimeFromArray:USER_TIMES[i]]) ? i : index;
                max = MAX(max, [Time getTimeFromArray:USER_TIMES[i]]);
            }
            if (max) {
                self.worstRow = index;
                [[cell detailTextLabel] setText:[RubiksUtil formatTime:[Time getTimeFromArray:USER_TIMES[index]]]];
            } else {
                [[cell detailTextLabel] setText:@"N/A"];
            }
        }
    } else {
        [[cell textLabel] setText:[RubiksUtil formatTime:[Time getTimeFromArray:[USER_TIMES objectAtIndex:indexPath.row]]]];
    }
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section != 0;
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
            NSMutableArray *times = [NSMutableArray arrayWithArray:USER_TIMES];
            [times removeObjectAtIndex:indexPath.row];
            [[NSUserDefaults standardUserDefaults] setObject:[times copy] forKey:TIMES_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            [tableView reloadData];
        }
    }
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([USER_TIMES count]) {
        // the destination vc
        RubiksIndividualTimeViewController *destinationVC = [segue destinationViewController];
        
        // the time selected
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        int index = (int)indexPath.row;
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                index = self.bestRow;
            } else if (indexPath.row == 1) {
                index = self.worstRow;
            }
        }
        
        Time *time = [Time getFromArray:[USER_TIMES objectAtIndex:index]];
        
        destinationVC.time = time.time;
        destinationVC.date = time.date;
        destinationVC.scramble = time.scramble;
    }
}

- (IBAction)email:(id)sender {
    MFMailComposeViewController *emailVC = [[MFMailComposeViewController alloc] init];
    [emailVC setSubject:@"3x3 Times"];
    [emailVC setMessageBody:[RubiksUtil getEmailMessageBody] isHTML:NO];
    emailVC.mailComposeDelegate = self;
    [self presentViewController:emailVC animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self becomeFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
