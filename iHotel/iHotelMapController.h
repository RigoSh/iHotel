//
//  iHotelMapController.h
//  iHotel
//
//  Created by Rigo on 30/11/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Mapbox/Mapbox.h>

#import "iHotelsObject.h"
#import "iHotelHTTPManager.h"

@interface iHotelMapController : UIViewController <CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, iHotelHTTPManagerDelegate>

@end
