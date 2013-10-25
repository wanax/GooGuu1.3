//
//  XYZAppDelegate.h
//  welcom_demo_1
//
//  Created by chaoxiao zhuang on 13-1-10.
//  Copyright (c) 2013年 Pony Finance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSPopoverController.h"
#import "BPush.h"
#import "WXApi.h"
#import <ShareSDK/ShareSDK.h>
#import "AGViewDelegate.h"

@class ConcernedViewController;
@class Company;
@class PrettyTabBarViewController;

@interface XYZAppDelegate : NSObject <UIApplicationDelegate>{
    IBOutlet UIWindow *window;
    NSString *_stockCode;
    enum WXScene _scene;
}

@property (nonatomic,assign) NSString *appId;
@property (nonatomic,assign) NSString *channelId;
@property (nonatomic,assign) NSString *userId;
@property (nonatomic,readonly) AGViewDelegate *viewDelegate;

@property BOOL isReachable;
@property (nonatomic,retain) TSPopoverController *popoverController;
@property (nonatomic,retain) UIScrollView *scrollView;
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain)  UITabBarController *tabBarController;

@property (retain,nonatomic) UIPageControl * pageControl;
@property (nonatomic,strong) id comInfo;
@property (nonatomic,retain) NSTimer *loginTimer;














@end
