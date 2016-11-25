//
//  iHotelTableViewCell.m
//  iHotel
//
//  Created by Rigo on 23/11/2016.
//  Copyright © 2016 Rigos. All rights reserved.
//

#import "iHotelTableViewCell.h"

@implementation iHotelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setWeatherText:(NSString *)weatherText
{
    self.weatherLabel.text = [weatherText copy];
}

- (void) setWeatherImage:(UIImage *)weatherImage
{
    self.weatherImageView.image = weatherImage;
}

@end
