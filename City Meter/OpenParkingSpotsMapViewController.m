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
@property (strong, nonatomic) IBOutlet UIButton *zoomButton;

@end

@implementation OpenParkingSpotsMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self addAnnotationsToMapView];

    self.mapView.mapType = MKMapTypeSatelliteFlyover;
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


//#pragma mark - Map View Delegate
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
//{
//
//}

@end
