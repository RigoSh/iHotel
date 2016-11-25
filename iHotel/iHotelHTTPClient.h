//
//  iHotelHTTPClient.h
//  iHotel
//
//  Created by Rigo on 25/11/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import <CoreLocation/CoreLocation.h>

@protocol iHotelHTTPClientDelegate;

@interface iHotelHTTPClient : AFHTTPSessionManager

@property (weak, nonatomic) id<iHotelHTTPClientDelegate> delegate;

+ (iHotelHTTPClient *) sharedInstance;
- (instancetype) initWithBaseURL: (NSURL *)baseURL;
- (void) updateWeatherAtLocation: (CLLocation *)location forNumberOfDays:(NSUInteger)number;

@end

@protocol iHotelHTTPClientDelegate <NSObject>

@optional
- (void) iHotelHTTPClientDelegate:(iHotelHTTPClient *)client didUpdateWeather:(id)weather;
- (void) iHotelHTTPClientDelegate:(iHotelHTTPClient *)client didFailWithError:(NSError *)error;

@end
