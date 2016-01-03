//
//  MetrAPI.m
//  City Meter
//
//  Created by Kieraj Mumick on 1/3/16.
//  Copyright © 2016 Kieraj Mumick. All rights reserved.
//

#import "MetrAPI.h"

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
    NSString *urlString = [NSString stringWithFormat:@"%@/parking-space/occupy/%@", [MetrAPI baseURL], parkingSpot.fullID];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:nil] start];
}

+ (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    NSString *urlString = [NSString stringWithFormat:@"%@/login", [MetrAPI baseURL]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];

    NSString *bodyData = [NSString stringWithFormat:@"email=%@&password=%@", username, password];
    [urlRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];

    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:nil];
}

@end
