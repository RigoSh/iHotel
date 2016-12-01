//
//  iHotelsObject.m
//  iHotel
//
//  Created by Rigo on 01/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import "iHotelsObject.h"

static NSString *const kResultsCount    = @"resultsCount";
static NSString *const kSearchResults   = @"searchResults";
static NSString *const kHotelName       = @"name";

@interface iHotelsObject ()

@property (strong, nonatomic) NSDictionary *hotelsResponse;

@end

@implementation iHotelsObject

- (instancetype) initWithResponse:(NSDictionary *)response
{
    self = [super init];
    
    if (self)
    {
        _hotelsResponse = response;
    }
    
    return self;
}

- (NSInteger) count
{
    if(_hotelsResponse)
    {
        NSNumber *cnt = _hotelsResponse[kResultsCount];
        
        return [cnt integerValue];
    }
    else
    {
        return 0;
    }
}

- (NSString *) hotelNameAtIndex:(NSInteger)index
{
    if(self.hotelsResponse)
    {
        if(index >= [self count])
        {
            return nil;
        }
        
        NSArray *hotelsArray = _hotelsResponse[kSearchResults];
        NSDictionary *hotel = hotelsArray[index];
        
        NSString *name = hotel[kHotelName];
        
        return name;
    }
    else
    {
        return nil;
    }
}

@end
