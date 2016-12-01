//
//  iHotelHTTPManager.m
//  iHotel
//
//  Created by Rigo on 01/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import "iHotelHTTPManager.h"

static NSString *const mapQuestAPIKey = @"UZn9oL1jGXSlzNeIedPy4GEx3Dd0HVd6"; // подумать как вытащить из info.plist
static NSString *const mapQuestURLString = @"http://www.mapquestapi.com/search/v2/";

@implementation iHotelHTTPManager

+ (iHotelHTTPManager *) sharedInstance
{
    static iHotelHTTPManager *_instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:mapQuestURLString]];
    });
    
    return _instance;
}

- (instancetype) initWithBaseURL: (NSURL *)baseURL
{
    self = [super initWithBaseURL:baseURL];
    
    if(self)
    {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

- (void) getHotelsAtLocation: (CLLocation *)location
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"key"] = mapQuestAPIKey;
    params[@"origin"] = [NSString stringWithFormat:@"%f, %f", location.coordinate.latitude, location.coordinate.longitude];
    params[@"maxMatches"] = @(5);
    params[@"ambiguities"] = @"ignore";
    params[@"hostedData"] = @"mqap.ntpois";
    params[@"outFormat"] = @"json";
    
    
    [self GET:@"radius"
   parameters:params
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          if([self.delegate respondsToSelector:@selector(iHotelHTTPManagerDelegate:didGETHotels:)])
          {
              [self.delegate iHotelHTTPManagerDelegate:self didGETHotels:responseObject];
          }
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          if([self.delegate respondsToSelector:@selector(iHotelHTTPManagerDelegate:didGETFailWithError:)])
          {
              [self.delegate iHotelHTTPManagerDelegate:self didGETFailWithError:error];
          }
      }];
}

@end

