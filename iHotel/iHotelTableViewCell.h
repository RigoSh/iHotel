//
//  iHotelTableViewCell.h
//  iHotel
//
//  Created by Rigo on 23/11/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iHotelTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;

@property (copy, nonatomic) NSString *weatherText;
@property (copy, nonatomic) UIImage *weatherImage;

@end
