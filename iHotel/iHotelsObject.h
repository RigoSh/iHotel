//
//  iHotelsObject.h
//  iHotel
//
//  Created by Rigo on 01/12/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iHotelsObject : NSObject

- (instancetype) initWithResponse:(NSDictionary *)response;

- (NSInteger) count;
- (NSString *) hotelNameAtIndex:(NSInteger)index;

@end
