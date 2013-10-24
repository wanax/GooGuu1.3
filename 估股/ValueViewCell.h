//
//  ValueViewCell.h
//  googuu
//
//  Created by Xcode on 13-10-16.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ValueViewCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UIImageView *titleImgView;
@property (nonatomic,retain) IBOutlet UILabel *titleLabel;
@property (nonatomic,retain) IBOutlet UILabel *conciseLabel;
@property (nonatomic,retain) IBOutlet UILabel *updateTimeLabel;
@property (nonatomic,retain) IBOutlet UILabel *backLabel;
@property (nonatomic,retain) IBOutlet UIWebView *conciseWebView;
@property (nonatomic,retain) IBOutlet UIImageView *readMarkImg;

@end
