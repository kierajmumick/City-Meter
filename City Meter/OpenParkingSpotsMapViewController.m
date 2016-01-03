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
#import "MetrAPI.h"
#import "Colours.h"

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

    self.rowTitles = @[@"Parking Spot Owner", @"Address", @"Parking Spot Number", @"Currently Available", @"Rate", @"Book Now"];

    ParkingSpot *item = (ParkingSpot *)self.detailItem;
    self.title = [NSString stringWithFormat:@"%@ %@ #%@", item.firstName, item.lastName, item.spotNumber];

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
    ParkingSpot *parkingSpot = (ParkingSpot *)self.detailItem;

    UITableViewCell *cell;
    if (indexPath.row == RowIndexBookNow) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"bookNowCell"];
        UILabel *payForSpotLabel = [cell viewWithTag:1];
        payForSpotLabel.textColor = [UIColor whiteColor];
        if (parkingSpot.isAvailable) {
            cell.backgroundColor = [Colours greenColour];
        } else {
            cell.backgroundColor = [Colours redColour];
        }
        cell.clipsToBounds = YES;
        return cell;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"availableParkingInfoCell"];
    }


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
            cell.detailTextLabel.text = parkingSpot.spotNumber;
            break;
        case RowIndexCurrentlyAvailable:
            cell.detailTextLabel.text = parkingSpot.isAvailable ? @"Yes" : @"No";
            break;
        case RowIndexMaximumParkingTime:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$%i", parkingSpot.maxNumMinutes];
        default:
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParkingSpot *parkingSpot = (ParkingSpot *)self.detailItem;
    if (indexPath.row == RowIndexBookNow) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confirm your parking spot" message:[NSString stringWithFormat:@"Please confirm that you are at this parking spot"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAlertAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nullable alertAction) {
            if (parkingSpot.isAvailable) {
                [MetrAPI makeParkingSpotUnavailable:parkingSpot];
            } else {
                [MetrAPI leaveParkingSpace];
            }
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
