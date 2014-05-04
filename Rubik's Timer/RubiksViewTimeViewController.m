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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [USER_TIMES count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Time Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [[cell textLabel] setText:[RubiksUtil formatTime:[Time getTimeFromArray:[USER_TIMES objectAtIndex:indexPath.row]]]];
    
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
            NSMutableArray *times = [NSMutableArray arrayWithArray:USER_TIMES];
            [times removeObjectAtIndex:indexPath.row];
            [[NSUserDefaults standardUserDefaults] setObject:[times copy] forKey:TIMES_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // the destination vc
    RubiksIndividualTimeViewController *destinationVC = [segue destinationViewController];
    
    // the time selected
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    Time *time = [Time getFromArray:[USER_TIMES objectAtIndex:indexPath.row]];
    
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
