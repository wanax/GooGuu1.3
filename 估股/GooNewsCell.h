//
//  GooNewsCell.h
//  UIDemo
//
//  Created by Xcode on 13-6-14.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  Vision History
//  2013-06-14 | Wanax | 估股新闻栏目新闻cell  

#import <UIKit/UIKit.h>
#import "RTLabel.h"

@interface GooNewsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet RTLabel *contentLabel;
@property (nonatomic,retain) IBOutlet UILabel *timeDiferLabel;
@property (nonatomic,retain) IBOutlet UIImageView *readMarkImg;

@property (nonatomic,retain) IBOutlet UILabel *backLabel;
@property (nonatomic,retain) IBOutlet UIImageView *comIconImg;

@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *content;

@end
