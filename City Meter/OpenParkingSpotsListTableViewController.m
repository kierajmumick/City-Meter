//
//  OpenParkingSpotsListTableViewController.m
//  City Meter
//
//  Created by Kieraj Mumick on 1/2/16.
//  Copyright © 2016 Kieraj Mumick. All rights reserved.
//

#import "OpenParkingSpotsListTableViewController.h"
#import "ParkingSpot.h"
#import "Colours.h"


@interface OpenParkingSpotsListTableViewController () <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate>

@property (strong, nonatomic) NSMutableArray *objects;
@property (strong, nonatomic) NSMutableArray *searchObjects;
@property (nonatomic) BOOL currentlySearching;

@end

@implementation OpenParkingSpotsListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.detailViewController = (OpenParkingSpotsMapViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    self.searchObjects = [self.objects mutableCopy];

    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"All Spots", @"Open Spots"]];
    [segmentedControl setSelectedSegmentIndex:1];
    self.navigationItem.titleView = segmentedControl;
    self.title = @"Spots";
}

- (void)viewWillAppear:(BOOL)animated
{
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    self.objects = [[ParkingSpot generateObjects] mutableCopy];
    [self.tableView reloadData];

    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"parkingLocationListCell" forIndexPath:indexPath];
    // Configure the cell...
    UILabel *textLabel = [cell viewWithTag:771];
    UILabel *metrIdLabel = [cell viewWithTag:772];
    UIView *colourView = [cell viewWithTag:774];

    textLabel.text = [NSString stringWithFormat:@"%@", self.objects[indexPath.row]];

    ParkingSpot *spot = self.objects[indexPath.row];
    textLabel.text = [NSString stringWithFormat:@"%@ %@", spot.firstName, spot.lastName];
    metrIdLabel.text = spot.spotNumber;
    colourView.backgroundColor = spot.isAvailable ? [Colours greenColour] : [Colours redColour]; //(indexPath.row < 4 ? [Colours orangeColour] : [Colours redColour]);

    colourView.clipsToBounds = YES;
    colourView.layer.masksToBounds = YES;
    colourView.layer.cornerRadius = colourView.frame.size.width / 2;

    return cell;
}

- (NSMutableArray *)objects
{
    if (self.currentlySearching) {
        return _searchObjects;
    }

    return _objects;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showDetail" sender:tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"%f, %f", mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta);
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        // the sender is the table view that was selected
        UITableView *selectedTableView = (UITableView *)sender;

        NSIndexPath *indexPath = [selectedTableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        OpenParkingSpotsMapViewController *controller = (OpenParkingSpotsMapViewController *)[[segue destinationViewController] topViewController];

        controller.detailItem = object;

        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Search Display Delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.currentlySearching = YES;
    // filter through all of the objects
    NSMutableArray *newSearchObjects = [NSMutableArray new];
    for (ParkingSpot *parkingSpot in _objects) {
        // keep the result if:
        // (1) the username contains the text typed in
        // (2) the MetrID contains the text typed in
        // (3) the address contains the text typed in
        if ([[NSString stringWithFormat:@"%@ %@", parkingSpot.firstName, parkingSpot.lastName] containsString:searchText] || [parkingSpot.spotNumber containsString:searchText] /*[parkingSpot.address containsString:searchText]*/) {
            [newSearchObjects addObject:parkingSpot];
        }
    }
    self.searchObjects = newSearchObjects;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchObjects = [NSMutableArray new];
    self.currentlySearching = NO;
}

#pragma mark - Segmented Control Selected
- 9




@end
