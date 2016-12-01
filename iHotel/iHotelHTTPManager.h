//
//  iHotelHTTPManager.h
//  iHotel
//
//  Created by Rigo on 01/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import <CoreLocation/CoreLocation.h>

@protocol iHotelHTTPManagerDelegate;

@interface iHotelHTTPManager : AFHTTPSessionManager

@property (weak, nonatomic) id<iHotelHTTPManagerDelegate> delegate;

+ (iHotelHTTPManager *) sharedInstance;
- (instancetype) initWithBaseURL: (NSURL *)baseURL;
- (void) getHotelsAtLocation: (CLLocation *)location;

@end

@protocol iHotelHTTPManagerDelegate <NSObject>

@optional
- (void) iHotelHTTPManagerDelegate:(iHotelHTTPManager *)client didGETHotels:(id)hotelsResponse;
- (void) iHotelHTTPManagerDelegate:(iHotelHTTPManager *)client didGETFailWithError:(NSError *)error;

@end
