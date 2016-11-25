//
//  iHotelTableViewController.m
//  iHotel
//
//  Created by Rigo on 23/11/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import "iHotelTableViewController.h"
#import "NSDictionary+weather_package.h"
#import "NSDictionary+weather.h"
#import "iHotelTableViewCell.h"
#import "UIImageView+AFNetworking.h"

static NSString *cellID = @"ID weather cell";
static NSString * const BaseURLString = @"https://www.raywenderlich.com/demos/weather_sample/";

@interface iHotelTableViewController ()

@property (retain, nonatomic) NSDictionary *weather;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation iHotelTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
    CLLocation *newLocation = [locations lastObject];
    
    [self.locationManager stopUpdatingLocation];
    
    iHotelHTTPClient *client = [iHotelHTTPClient sharedInstance];
    client.delegate = self;
    [client updateWeatherAtLocation:newLocation forNumberOfDays:5];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if(!self.weather)
//    {
//        return 0;
//    }
//    else
//    {
//        NSArray *upcomingWeather = [self.weather upcomingWeather];
//        return upcomingWeather.count;
//    }
//    
    NSArray *upcomingWeather = [self.weather upcomingWeather];
    return upcomingWeather.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    iHotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    NSDictionary *daysWeather = nil;
    
    switch (indexPath.section)
    {
        case 0:
        {
            daysWeather = [self.weather currentCondition];
            break;
        }
        case 1:
        {
            NSArray *upcomingWeather = [self.weather upcomingWeather];
            daysWeather = upcomingWeather[indexPath.row];
            break;
        }
        default:
            break;
    }
    
    
    cell.weatherText = [daysWeather weatherDescription];
    
//    NSMutableString *mutStr = [NSMutableString stringWithString: daysWeather.weatherIconURL];
//    [mutStr insertString:@"s" atIndex:4];
//    NSURL *url = [NSURL URLWithString:mutStr];
    
    NSURL *url = [NSURL URLWithString:daysWeather.weatherIconURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder.jpeg"];
    
      __weak iHotelTableViewCell *weakCell = cell;
    
    [cell.weatherImageView setImageWithURLRequest:request
                          placeholderImage:placeholderImage
                                   success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image)
                                    {
                                       weakCell.weatherImage = image;
                                       [weakCell setNeedsLayout];
                                    }
                                   failure:nil];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - User actions
- (IBAction)jsonTapped:(id)sender
{
    NSString *urlString = [BaseURLString stringByAppendingString:@"weather.php?format=json"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSURLSessionDataTask *dataTask = [httpManager dataTaskWithRequest:request
                                                   uploadProgress:nil
                                                 downloadProgress:nil
                                                completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                        if(error)
                                                        {
                                                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Request eroor" message:error.description preferredStyle:UIAlertControllerStyleAlert];
                                                            
                                                            [self presentViewController:alert animated:YES completion:nil];
                                                        }
                                                    
                                                    self.weather = (NSDictionary *) responseObject;
                                                    self.title = @"JSON got";
                                                    
                                                    [self.tableView reloadData];
                                                }];

    [dataTask resume];
}

- (IBAction)clearTable:(id)sender
{
    self.weather = nil;
    self.title = @"Table cleared";
    
    [self.tableView reloadData];
    
}

- (IBAction)updateLocation:(id)sender
{
    [self.locationManager requestWhenInUseAuthorization];
//    [self.locationManager startMonitoringSignificantLocationChanges];
    [self.locationManager startUpdatingLocation];
}


#pragma mark - iHotel delegate methods
- (void) iHotelHTTPClientDelegate:(iHotelHTTPClient *)client didUpdateWeather:(id)weather
{
    self.weather = weather;
    self.title = @"API Updated";
    [self.tableView reloadData];
}

- (void) iHotelHTTPClientDelegate:(iHotelHTTPClient *)client didFailWithError:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Request eroor" message:error.description preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
