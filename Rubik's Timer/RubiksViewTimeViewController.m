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
@property (strong, nonatomic) IBOutlet UIBarButtonItem *emailBarButtonItem;
@end

@implementation RubiksViewTimeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setBarButtonItemStatus];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [self setBarButtonItemStatus];
}

- (void)setBarButtonItemStatus {
    if ([USER_TIMES count] == 0) {
        [self setEditing:NO animated:NO];
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
    } else {
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        self.navigationItem.leftBarButtonItem = self.emailBarButtonItem;
    }
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
        return ([USER_TIMES count]) ? [USER_TIMES count] : 1;
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
    } else {
        if ([USER_TIMES count] == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            double time = [Time getTimeFromArray:[USER_TIMES objectAtIndex:indexPath.row]];
            if ([Time isBest:time]) {
                cell = [tableView dequeueReusableCellWithIdentifier:BestAllCellIdentifier forIndexPath:indexPath];
            } else if ([Time isWorst:time]) {
                cell = [tableView dequeueReusableCellWithIdentifier:WorstAllCellIdentifier forIndexPath:indexPath];
            } else {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
                [[cell detailTextLabel] setText:@"No Times"];
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
                [[cell detailTextLabel] setText:@"No Times"];
            }
        }
    } else {
        if ([USER_TIMES count] == 0) {
            [[cell textLabel] setText:@"No recorded solves"];
        } else {
            [[cell textLabel] setText:[RubiksUtil formatTime:[Time getTimeFromArray:[USER_TIMES objectAtIndex:indexPath.row]]]];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([USER_TIMES count]) {
        [self performSegueWithIdentifier:@"View Time Segue Global" sender:nil];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // if we're not in the records section
    if (indexPath.section) {
        // only edit if there are times available
        return [USER_TIMES count];
    }
    
    // don't allow editing of the records section
    return false;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath) {
            // Delete the row from the data source
            NSMutableArray *times = [NSMutableArray arrayWithArray:USER_TIMES];
            [times removeObjectAtIndex:indexPath.row];
            [[NSUserDefaults standardUserDefaults] setObject:[times copy] forKey:TIMES_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if ([USER_TIMES count]) {
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            } else {
                [self setBarButtonItemStatus];
            }
            
            [tableView reloadData];
        }
    }
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
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
