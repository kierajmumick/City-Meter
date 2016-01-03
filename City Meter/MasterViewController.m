//
//  MasterViewController.m
//  City Meter
//
//  Created by Kieraj Mumick on 1/2/16.
//  Copyright © 2016 Kieraj Mumick. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "MetrAPI.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    self.title = @"History";

}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;

    self.objects = [[MetrAPI getHistoryForCurrentUser] mutableCopy];

    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"showDetail"]) {
        return NO;
    }

    return YES;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 156;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDictionary *object = self.objects[indexPath.row];

    UILabel *dateLabel = [cell viewWithTag:101];
    UILabel *startTimeLabel = [cell viewWithTag:102];
    UILabel *endTimeLabel = [cell viewWithTag:103];
    UILabel *hourlyRateLabel = [cell viewWithTag:104];
    UILabel *finalChargeLabel = [cell viewWithTag:105];

    NSString *startTime = object[@"startTime"];
    NSString *endTime = object[@"endTime"];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    NSDate *startDate = [dateFormatter dateFromString:startTime];
    NSDate *endDate = [dateFormatter dateFromString:endTime];

    NSDateFormatter *legibleFormatter = [[NSDateFormatter alloc] init];
    legibleFormatter.dateStyle = NSDateFormatterShortStyle;
    NSString *startDateShort = [legibleFormatter stringFromDate:startDate];

    NSString *parkingSpaceID = object[@"parkingSpace"];
    NSString *parkingSpaceLast4 = [parkingSpaceID substringFromIndex:(parkingSpaceID.length - 4)];
    dateLabel.text = [NSString stringWithFormat:@"%@ - Spot #%@", startDateShort, parkingSpaceLast4];

    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.dateFormat = @"HH:mm a";
    NSString *startTimeShort = [timeFormatter stringFromDate:startDate];
    NSString *endTimeShort = [timeFormatter stringFromDate:endDate];

    startTimeLabel.text = startTimeShort;
    endTimeLabel.text = endTimeShort;

    hourlyRateLabel.text = [NSString stringWithFormat:@"$%.2f/hr", [object[@"hourlyRate"] doubleValue]];
    finalChargeLabel.text = [NSString stringWithFormat:@"$%.2f", [object[@"cost"] doubleValue]];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
