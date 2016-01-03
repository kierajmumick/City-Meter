//
//  OpenParkingSpotsMapViewController.m
//  City Meter
//
//  Created by Kieraj Mumick on 1/2/16.
//  Copyright © 2016 Kieraj Mumick. All rights reserved.
//

#import "OpenParkingSpotsMapViewController.h"
#import <MapKit/MapKit.h>
#import "ParkingSpot.h"

@interface OpenParkingSpotsMapViewController () <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIButton *zoomButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSArray *rowTitles;

@end

typedef NS_ENUM(NSUInteger, RowIndex) {
    RowIndexEmptyCell,
    RowIndexParkingSpotOwner,
    RowIndexAddress,
    RowIndexParkingSpotNumber,
    RowIndexCurrentlyAvailable,
    RowIndexMaximumParkingTime,
    RowIndexBookNow,
};

@implementation OpenParkingSpotsMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self addAnnotationsToMapView];

    self.mapView.mapType = MKMapTypeSatelliteFlyover;
    self.mapView.showsUserLocation = YES;

    self.rowTitles = @[@"Parking Spot Owner", @"Address", @"Parking Spot Number", @"Currently Available", @"Max Parking Time", @"Book Now"];

    ParkingSpot *item = (ParkingSpot *)self.detailItem;
    self.title = [NSString stringWithFormat:@"%@ %@ Spot #%i", item.firstName, item.lastName, item.spotNumber];

    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.mapView.delegate = self;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;

        // Update the view.
    }
}

- (void)addAnnotationsToMapView
{
    if (self.mapView) {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = ((ParkingSpot *)self.detailItem).coordinate;
        [self.mapView addAnnotation:annotation];
        MKMapCamera* camera = [MKMapCamera
                               cameraLookingAtCenterCoordinate:annotation.coordinate
                               fromEyeCoordinate:CLLocationCoordinate2DMake(1.0001 * annotation.coordinate.latitude, 1.0001 * annotation.coordinate.longitude)
                               eyeAltitude:.00001];
        [self.mapView setCamera:camera animated:NO];
    }
}

#pragma mark - Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParkingSpot *parkingSpot = (ParkingSpot *)self.detailItem;
    if (indexPath.row == RowIndexEmptyCell) {
        return 250;
    } else if (indexPath.row == RowIndexBookNow && !parkingSpot.isAvailable) {
        return 0;
    }
    return 44;
}

#pragma mark Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rowTitles.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == RowIndexBookNow) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"bookNowCell"];
        cell.backgroundColor = [UIColor colorWithRed:.169 green:.784 blue:.137 alpha:1];
        cell.clipsToBounds = YES;
        return cell;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"availableParkingInfoCell"];
    }

    ParkingSpot *parkingSpot = (ParkingSpot *)self.detailItem;

    if (indexPath.row == RowIndexEmptyCell) {
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
        return cell;
    }

    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = self.rowTitles[indexPath.row - 1];

    switch (indexPath.row) {
        case RowIndexParkingSpotOwner:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", parkingSpot.firstName, parkingSpot.lastName];
            break;
        case RowIndexParkingSpotNumber:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", parkingSpot.spotNumber];
            break;
        case RowIndexCurrentlyAvailable:
            cell.detailTextLabel.text = parkingSpot.isAvailable ? @"Yes" : @"No";
            break;
        case RowIndexMaximumParkingTime:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f hours", parkingSpot.maxNumMinutes / 60.0];
        default:
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParkingSpot *parkingSpot = (ParkingSpot *)self.detailItem;
    if (indexPath.row == RowIndexBookNow) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confirm your parking spot" message:[NSString stringWithFormat:@"Please confirm that you are at this parking spot. Make sure you understand that you can be parked here for a maximum of %.2f hours", parkingSpot.maxNumMinutes / 60.0] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAlertAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nullable alertAction) {
            //TODO:  make the server call to update the occupied status of this care in the background, then inform the user the spot is his
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                [self.navigationController.navigationController popViewControllerAnimated:YES];
            });
        }];
        [alertController addAction:confirmAlertAction];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nullable alertAction) {
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }];
        [alertController addAction:cancelAction];

        [self presentViewController:alertController animated:YES completion:nil];
    }
}




//#pragma mark - Map View Delegate
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
//{
//
//}

@end
