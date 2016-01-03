//
//  ParkingSpot.m
//  City Meter
//
//  Created by Kieraj Mumick on 1/2/16.
//  Copyright © 2016 Kieraj Mumick. All rights reserved.
//

#import "ParkingSpot.h"

@implementation ParkingSpot

- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude andSpotNumber:(int)spotNumber;
{
    self = [super init];
    if (self) {
        self.firstName = firstName;
        self.lastName = lastName;
        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        self.isAvailable = YES;
        self.spotNumber = spotNumber;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

- (NSString *)detailedDescription
{
    return [NSString stringWithFormat:@"%f, %f", self.coordinate.latitude, self.coordinate.longitude];
}

+ (NSArray *)generateObjects
{
    ParkingSpot *object1 = [[ParkingSpot alloc] initWithFirstName:@"Palms" lastName:@"Resort" latitude:36.114816 longitude:-115.197334 andSpotNumber:1];
    ParkingSpot *object2 = [[ParkingSpot alloc] initWithFirstName:@"Palms" lastName:@"Resort" latitude:36.114819 longitude:-115.197369 andSpotNumber:2];
    ParkingSpot *object3 = [[ParkingSpot alloc] initWithFirstName:@"Palms" lastName:@"Resort" latitude:36.114815 longitude:-115.197395 andSpotNumber:3];
    ParkingSpot *object4 = [[ParkingSpot alloc] initWithFirstName:@"Palms" lastName:@"Resort" latitude:36.114815 longitude:-115.197428 andSpotNumber:4];
    ParkingSpot *object5 = [[ParkingSpot alloc] initWithFirstName:@"Palms" lastName:@"Resort" latitude:36.114818 longitude:-115.197455 andSpotNumber:5];
    ParkingSpot *object6 = [[ParkingSpot alloc] initWithFirstName:@"Palms" lastName:@"Resort" latitude:36.114816 longitude:-115.197488 andSpotNumber:6];
    ParkingSpot *object7 = [[ParkingSpot alloc] initWithFirstName:@"Palms" lastName:@"Resort" latitude:36.114765 longitude:-115.197494 andSpotNumber:7];
    ParkingSpot *object8 = [[ParkingSpot alloc] initWithFirstName:@"Palms" lastName:@"Resort" latitude:36.114758 longitude:-115.197457 andSpotNumber:8];
    ParkingSpot *object9 = [[ParkingSpot alloc] initWithFirstName:@"Palms" lastName:@"Resort" latitude:36.114753 longitude:-115.197432 andSpotNumber:9];
    ParkingSpot *object10 = [[ParkingSpot alloc] initWithFirstName:@"Palms" lastName:@"Resort" latitude:36.114764 longitude:-115.197400 andSpotNumber:10];
    ParkingSpot *object11 = [[ParkingSpot alloc] initWithFirstName:@"Palms" lastName:@"Resort" latitude:36.114764 longitude:-115.197367 andSpotNumber:11];
    ParkingSpot *object12 = [[ParkingSpot alloc] initWithFirstName:@"Palms" lastName:@"Resort" latitude:36.114759 longitude:-115.197337 andSpotNumber:12];

    NSArray *parkingSpots = @[object1, object2, object3, object4, object5, object6, object7, object8, object9, object10, object11, object12];

    return parkingSpots;
}

@end
