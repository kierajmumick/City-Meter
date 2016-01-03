//
//  URLConnectionDelegate.m
//  City Meter
//
//  Created by Kieraj Mumick on 1/3/16.
//  Copyright © 2016 Kieraj Mumick. All rights reserved.
//

#import "URLConnectionDelegateGeneric.h"

@implementation URLConnectionDelegateGeneric

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error: %@", error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Connection a success");
}

@end
