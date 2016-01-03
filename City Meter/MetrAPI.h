//
//  MetrAPI.h
//  City Meter
//
//  Created by Kieraj Mumick on 1/3/16.
//  Copyright © 2016 Kieraj Mumick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ParkingSpot.h"

@interface MetrAPI : NSObject

+ (NSArray *)findParkingSpotsAroundCoordinate:(CLLocationCoordinate2D)coordinate andMiles:(float)miles;
+ (NSArray *)findParkingSpotsAroundCoordinateWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude andMiles:(float)miles;
+ (void)makeParkingSpotUnavailable:(ParkingSpot *)parkingSpot;
+ (void)loginWithUsername:(NSString *)username password:(NSString *)password;
@end
