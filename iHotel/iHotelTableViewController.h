//
//  iHotelTableViewController.h
//  iHotel
//
//  Created by Rigo on 23/11/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "iHotelHTTPClient.h"

@interface iHotelTableViewController : UITableViewController <CLLocationManagerDelegate, iHotelHTTPClientDelegate>

@end
