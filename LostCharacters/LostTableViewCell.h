//
//  LostTableViewCell.h
//  LostCharacters
//
//  Created by Sherrie Jones on 4/6/15.
//  Copyright (c) 2015 Sherrie Jones. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LostTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *actorNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;
@property (strong, nonatomic) IBOutlet UILabel *seatNumberLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageLabel;

@end
