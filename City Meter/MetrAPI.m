//
//  MetrAPI.m
//  City Meter
//
//  Created by Kieraj Mumick on 1/3/16.
//  Copyright © 2016 Kieraj Mumick. All rights reserved.
//

#import "MetrAPI.h"
#import "APIDelegate.h"

@interface MetrAPI () <NSURLConnectionDataDelegate>

@end


@implementation MetrAPI

+ (NSString *)baseURL
{
    return @"https://iot-parking-meter.herokuapp.com";
}

+ (NSArray *)findParkingSpotsAroundCoordinate:(CLLocationCoordinate2D)coordinate andMiles:(float)miles
{

    NSString *urlString = [NSString stringWithFormat:@"%@/api/parking-spaces/find/nearby?lat=%f&lng=%f&miles=%f", [MetrAPI baseURL], coordinate.latitude, coordinate.longitude, miles];
    NSError *stringError;
    NSString *jsonString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:&stringError];


    NSError *decodingError;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&decodingError];
    return json;
}

+ (NSArray *)findParkingSpotsAroundCoordinateWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude andMiles:(float)miles
{
    return [MetrAPI findParkingSpotsAroundCoordinate:CLLocationCoordinate2DMake(latitude, longitude) andMiles:miles];
}

+ (void)makeParkingSpotUnavailable:(ParkingSpot *)parkingSpot
{
    // TODO: make parking spot unavailable
}

@end
