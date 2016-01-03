//
//  ParkingSpot.h
//  City Meter
//
//  Created by Kieraj Mumick on 1/2/16.
//  Copyright © 2016 Kieraj Mumick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ParkingSpot : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) BOOL isAvailable;
@property (nonatomic, strong) NSString *spotNumber;
@property (nonatomic) int maxNumMinutes;
@property (nonatomic) NSString *fullID;

- (NSString *)detailedDescription;
+ (NSArray *)generateObjects;

@end
