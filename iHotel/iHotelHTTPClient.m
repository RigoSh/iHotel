//
//  iHotelHTTPClient.m
//  iHotel
//
//  Created by Rigo on 25/11/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import "iHotelHTTPClient.h"

static NSString *const weatherAPIKey = @"4b5a8dbe750f4a12b06174847162511";
static NSString *const weatherURLString = @"https://api.worldweatheronline.com/premium/v1/";

@implementation iHotelHTTPClient

+ (iHotelHTTPClient *) sharedInstance
{
    static iHotelHTTPClient *_instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:weatherURLString]];
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

- (void) updateWeatherAtLocation: (CLLocation *)location forNumberOfDays:(NSUInteger)number
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"num_of_days"] = @(number);
    params[@"q"] = [NSString stringWithFormat:@"%f, %f", location.coordinate.latitude, location.coordinate.longitude];
    params[@"format"] = @"json";
    params[@"key"] = weatherAPIKey;
    
    [self GET:@"weather.ashx"
   parameters:params
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          if([self.delegate respondsToSelector:@selector(iHotelHTTPClientDelegate:didUpdateWeather:)])
          {
               [self.delegate iHotelHTTPClientDelegate:self didUpdateWeather:responseObject];
          }
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          if([self.delegate respondsToSelector:@selector(iHotelHTTPClientDelegate:didFailWithError:)])
          {
              [self.delegate iHotelHTTPClientDelegate:self didFailWithError:error];
          }
      }];
}

@end
