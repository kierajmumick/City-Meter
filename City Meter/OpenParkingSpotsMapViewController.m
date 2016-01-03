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

@interface OpenParkingSpotsMapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation OpenParkingSpotsMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self addAnnotationsToMapView];

    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;

    self.title = @"Available Parking";
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
        NSArray *allPoints = [ParkingSpot generateObjects];

        CLLocationCoordinate2D coordinate = ((ParkingSpot *)self.detailItem).coordinate;
        for (ParkingSpot *spot in allPoints) {
            if (spot.isAvailable) {
                MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
                pointAnnotation.title = spot.description;
                pointAnnotation.coordinate = spot.coordinate;
                [self.mapView addAnnotation:pointAnnotation];

                if (pointAnnotation.coordinate.latitude == coordinate.latitude && pointAnnotation.coordinate.longitude == coordinate.longitude) {
                    [self.mapView selectAnnotation:pointAnnotation animated:YES];
                }
            }
        }

        MKCoordinateRegion coordinateRegion = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.001, 0.001));
        [self.mapView setRegion:coordinateRegion];
    }
}

//#pragma mark - Map View Delegate
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
//{
//
//}

@end
