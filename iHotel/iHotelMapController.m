//
//  iHotelMapController.m
//  iHotel
//
//  Created by Rigo on 30/11/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import "iHotelMapController.h"

static NSString *const hotelCellID = @"Hotel cell ID";

@interface iHotelMapController ()

@property (strong, nonatomic) IBOutlet MQMapView *mapQuestView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UITableView *hotelsTableView;

@property (strong, nonatomic) iHotelsObject *hotels;

@end

@implementation iHotelMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapQuestView.mapType = MQMapTypeNormal;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
//    [self.locationManager stopUpdatingLocation];
    
    CLLocation *newLocation = [locations lastObject];
    CLLocationCoordinate2D loc2d = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    [self.mapQuestView setCenterCoordinate:loc2d zoomLevel:11 animated:YES];
    
    iHotelHTTPManager *httpManager = [iHotelHTTPManager sharedInstance];
    httpManager.delegate = self;
    
    [httpManager getHotelsAtLocation:newLocation];    
}

- (IBAction)startUpdateLocation:(id)sender
{
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.hotels)
    {
        return 0;
    }
    else
    {
        return [self.hotels count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hotelCellID forIndexPath:indexPath];
    
//    NSDictionary *daysWeather = nil;
//    
//    switch (indexPath.section)
//    {
//        case 0:
//        {
//            daysWeather = [self.weather currentCondition];
//            break;
//        }
//        case 1:
//        {
//            NSArray *upcomingWeather = [self.weather upcomingWeather];
//            daysWeather = upcomingWeather[indexPath.row];
//            break;
//        }
//        default:
//            break;
//    }
//    
//    
//    cell.weatherText = [daysWeather weatherDescription];
//    
//    NSURL *url = [NSURL URLWithString:daysWeather.weatherIconURL];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    
//    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder.jpeg"];
//    
//    __weak iHotelTableViewCell *weakCell = cell;
//    
//    [cell.weatherImageView setImageWithURLRequest:request
//                                 placeholderImage:placeholderImage
//                                          success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image)
//     {
//         weakCell.weatherImage = image;
//         [weakCell setNeedsLayout];
//     }
//                                          failure:nil];
    cell.textLabel.text = [self.hotels hotelNameAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - iHotelHTTPManager delegate methods
- (void) iHotelHTTPManagerDelegate:(iHotelHTTPManager *)client didGETHotels:(id)hotelsResponse
{
    self.hotels = [[iHotelsObject alloc] initWithResponse:hotelsResponse];
    
    [self.hotelsTableView reloadData];
}

- (void) iHotelHTTPManagerDelegate:(iHotelHTTPManager *)client didGETFailWithError:(NSError *)error
{
    self.hotels = nil;
    [self.hotelsTableView reloadData];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Request error" message:error.description preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
