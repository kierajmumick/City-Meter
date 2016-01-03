//
//  MetrAPI.m
//  City Meter
//
//  Created by Kieraj Mumick on 1/3/16.
//  Copyright © 2016 Kieraj Mumick. All rights reserved.
//

#import "MetrAPI.h"
#import "URLConnectionDelegateGeneric.h"
#import "AppDelegate.h"

@interface MetrAPI () <NSURLConnectionDataDelegate>

@end

@implementation MetrAPI

+ (NSString *)baseURL
{
    return @"https://metr.herokuapp.com";
}

+ (NSArray *)findParkingSpotsAroundCoordinate:(CLLocationCoordinate2D)coordinate andMiles:(float)miles
{

    NSString *urlString = [NSString stringWithFormat:@"%@/api/parking-spaces/find/nearby?lat=%f&lng=%f&miles=%f", [MetrAPI baseURL], coordinate.latitude, coordinate.longitude, miles];
    NSError *stringError;
    NSString *jsonString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:&stringError];
    if (stringError) {
        NSLog(@"stringError: %@", stringError);
    }

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
    NSDictionary *userDictionary = [MetrAPI getUserObject];
    NSString *urlString = [NSString stringWithFormat:@"%@/parking-space/occupy/%@?userId=%@", [MetrAPI baseURL], parkingSpot.fullID, userDictionary[@"_id"]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:[URLConnectionDelegateGeneric new]] start];
}

+ (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    NSString *urlString = [NSString stringWithFormat:@"%@/login", [MetrAPI baseURL]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];

    NSString *bodyData = [NSString stringWithFormat:@"email=%@&password=%@", username, password];
    [urlRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];

    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:[URLConnectionDelegateGeneric new]];
}

+ (NSDictionary *)getUserObject
{
    NSString *urlString = [NSString stringWithFormat:@"%@/api/users/find-by/email?email=kieraj@mumick.com", [MetrAPI baseURL]];
    NSURL *url = [NSURL URLWithString:urlString];

    NSError *stringError;
    NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&stringError];
    if (stringError) {
        NSLog(@"error: %@", stringError);
    }

    NSError *decodingError;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&decodingError];
    return json;
}

+ (void)leaveParkingSpace
{
    NSDictionary *userDictionary = [MetrAPI getUserObject];
    NSString *urlString = [NSString stringWithFormat:@"%@/parking-space/leave?userId=%@", [MetrAPI baseURL], userDictionary[@"_id"]];
    NSURL *url = [NSURL URLWithString:urlString];

    NSError *stringError;
    NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&stringError];
    if (stringError) {
        NSLog(@"error: %@", stringError);
    }

    NSError *decodingError;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&decodingError];
//    return json;
}


+ (NSArray *)getHistoryForCurrentUser
{
    NSDictionary *userDictionary = [MetrAPI getUserObject];
    NSString *urlString = [NSString stringWithFormat:@"%@/api/trips/of-user/%@", [MetrAPI baseURL], userDictionary[@"_id"]];
    NSURL *url = [NSURL URLWithString:urlString];

    NSError *stringError;
    NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&stringError];
    if (stringError) {
        NSLog(@"error: %@", stringError);
    }

    NSError *decodingError;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&decodingError];
    return json;
}

@end
