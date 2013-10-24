//
//  XYZAppDelegate.m
//  welcom_demo_1
//
//  Created by chaoxiao zhuang on 13-1-10.
//  Copyright (c) 2013年 Pony Finance. All rights reserved.
//

#import "XYZAppDelegate.h"
#import "tipViewController.h"
#import "ConcernedViewController.h"
#import "ClientCenterViewController.h"
#import "DBLite.h"
#import "WXApi.h"
#import "ConcernedViewController.h"
#import "GooNewsViewController.h"
#import "MyGooguuViewController.h"
#import "FinanceToolsViewController.h"
#import "UniverseViewController.h"
#import "ChartViewController.h"
#import "Company.h"
#import "PrettyNavigationController.h"
#import "PrettyTabBarViewController.h"
#import "Reachability.h"
#import "ChartViewController.h"
#import "CommonlyMacros.h"
#import <Crashlytics/Crashlytics.h>
#import "SettingCenterViewController.h"
#import "AgreementViewController.h"
#import "ProAlertView.h"
#import "PonyDebugger.h"
#import "FinanceToolsViewController.h"
#import "BPush.h"
#import "FinPicKeyWordListViewController.h"
#import "GooGuuViewController.h"
#import "FinPic2ViewController.h"
#import "FinanceDataViewController.h"
#import <ShareSDK/ShareSDK.h>


@implementation XYZAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize scrollView;
@synthesize pageControl;
@synthesize loginTimer;
@synthesize comInfo;
@synthesize popoverController;

- (void)dealloc
{
    [popoverController release];
    [loginTimer release];
    [comInfo release];
    [scrollView release];
    [tabBarController release];
    [pageControl release];
    [window release];
    [super dealloc];
}

- (id)init
{
    if(self = [super init])
    {
        _scene = WXSceneSession;
    }
    return self;
}

-(void)setPonyDebugger{
    PDDebugger *debugger = [PDDebugger defaultInstance];
    [debugger enableNetworkTrafficDebugging];
    [debugger forwardAllNetworkTraffic];
    
    [debugger enableViewHierarchyDebugging];
    [debugger setDisplayedViewAttributeKeyPaths:@[@"frame", @"hidden", @"alpha", @"opaque"]];
    
    [debugger enableRemoteLogging];
    [debugger connectToURL:[NSURL URLWithString:@"ws://localhost:9000/device"]];
}

-(void)beginBaiDuStatistics{
    
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.enableExceptionLog = YES;
    statTracker.logSendWifiOnly = YES;
    [statTracker startWithAppId:@"0737a8b0ff"];
    
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1)
    {
        NSString *iTunesLink = @"itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=703282718&mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]]; 
    }
}
-(void)checkUpdate{
    AFHTTPClient *getAction=[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://itunes.apple.com"]];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:@"703282718",@"id",nil];
    
    [getAction getPath:@"/lookup" parameters:params success:^(AFHTTPRequestOperation *operation,id responseObject){

        NSString *version = @"";      
        NSArray *configData = [[operation.responseString objectFromJSONString] valueForKey:@"results"];
        
        for (id config in configData)
        {
            version = [config valueForKey:@"version"];
        }
        //Check your version with the version in app store
        if (![version isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"version"]])
        {
            ProAlertView *createUserResponseAlert = [[ProAlertView alloc] initWithTitle:@"新版本" message: @"下载新的版本" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"下载", nil];
            [createUserResponseAlert show];
            [createUserResponseAlert release];  
        }
        
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        
    }];

}
-(void)beginBaiDuPush:(UIApplication *)application{
    
    [BPush setupChannel:[Utiles getConfigureInfoFrom:@"BPushConfig" andKey:nil inUserDomain:NO]]; // 必须
    [BPush setDelegate:self]; // 必须。参数对象必须实现onMethod: response:方法，本示例中为self
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeAlert
     | UIRemoteNotificationTypeBadge
     | UIRemoteNotificationTypeSound];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannel];
}
- (void) onMethod:(NSString*)method response:(NSDictionary*)data {
    NSLog(@"On method:%@", method);
    NSLog(@"data:%@", [data description]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Receive Notify: %@", [userInfo JSONString]);
    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    if (application.applicationState == UIApplicationStateActive) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Did receive a Remote Notification"
                                                            message:[NSString stringWithFormat:@"The application received this remote notification while it was running:\n%@", alert]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    [application setApplicationIconBadgeNumber:0];
    
    [BPush handleNotification:userInfo];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self netChecked];
    [self beginBaiDuStatistics];
    [self beginBaiDuPush:application];
    //[self setPonyDebugger];
    [self.window setBackgroundColor:[Utiles colorWithHexString:@"#DCDCD6"]];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];

    [Utiles setConfigureInfoTo:@"userconfigure" forKey:@"stockColorSetting" andContent:[NSString stringWithFormat:@"%d",0]];

    [[NSUserDefaults standardUserDefaults] setObject:@"1.0.1" forKey:@"version"];

    
    
    
    [Crashlytics startWithAPIKey:@"c59317990c405b2f42582cacbe9f4fa9abe1fefb"];
    
    [ShareSDK registerApp:@"8c37a484287"];
    [ShareSDK connectWeChatWithAppId:@"wx68cacf0b8972c879" wechatCls:[WXApi class]];
    [ShareSDK connectSinaWeiboWithAppKey:@"1486252908"
                               appSecret:@"9991fbc725c5f5cf6b565b9a00a5584a"
                             redirectUri:@"http://appgo.cn"];

    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"firstLaunch"]==nil) {
        //用户初次使用进入使用引导界面
        [Utiles setConfigureInfoTo:@"userconfigure" forKey:@"checkUpdate" andContent:@"0"];
        tipViewController * startView = [[tipViewController alloc]init];
        self.window.rootViewController = startView;
        [startView release];
    }else if([[NSUserDefaults standardUserDefaults] objectForKey:@"agreement"]==nil){
        
        AgreementViewController * agreement = [[AgreementViewController alloc]init];
        self.window.rootViewController = agreement;
        [agreement release];
        
    }else {
        if([Utiles getConfigureInfoFrom:@"userconfigure" andKey:@"checkUpdate" inUserDomain:YES]){
            BOOL isOn=[Utiles stringToBool:[Utiles getConfigureInfoFrom:@"userconfigure" andKey:@"checkUpdate" inUserDomain:YES]];
            if(isOn){
                [self checkUpdate];
            }
        }
        [self initComponents];
    }
    
    if([Utiles isLogin]){
        [self handleTimer:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginKeeping" object:nil];
        [self loginKeeping:nil];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginKeeping:) name:@"LoginKeeping" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelLoginKeeping:) name:@"LogOut" object:nil];
    
    
    return YES;
}

#pragma mark -
#pragma mark Net Reachable
-(void)netChecked{
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    reach.reachableOnWWAN = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    [reach startNotifier];
}

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable]){
        NSLog(@"Reachable");
        self.isReachable=YES;
    }else{
        NSLog(@"NReachable");
        self.isReachable=NO;
    }
}

#pragma mark -
#pragma mark Share SDK

- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
}

#pragma mark -
#pragma mark Keep Login

-(void)loginKeeping:(NSNotification*)notification{
    loginTimer = [NSTimer scheduledTimerWithTimeInterval: 7000 target: self selector: @selector(handleTimer:) userInfo: nil repeats: YES];
}
-(void)cancelLoginKeeping:(NSNotification*)notification{
    [loginTimer invalidate];
}

- (void) handleTimer: (NSTimer *) timer{
    
    NSUserDefaults *userDeaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[[[userDeaults objectForKey:@"UserInfo"] objectForKey:@"username"] lowercaseString],@"username",[Utiles md5:[[userDeaults objectForKey:@"UserInfo"] objectForKey:@"password"]],@"password",@"googuu",@"from", nil];
    [Utiles getNetInfoWithPath:@"Login" andParams:params besidesBlock:^(id resObj){
        
        if([[resObj objectForKey:@"status"] isEqualToString:@"1"]){
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:@"UserToke"];
            [userDefaults setObject:[resObj objectForKey:@"token"] forKey:@"UserToken"];
            
            NSLog(@"%@",[resObj objectForKey:@"token"]);
            
        }else {
            NSLog(@"%@",[resObj objectForKey:@"msg"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


#pragma mark -
#pragma mark Generate Components

-(void)initComponents{
    UITabBarItem *barItem=[[[UITabBarItem alloc] initWithTitle:@"最新简报" image:[UIImage imageNamed:@"googuuNewsBar"] tag:1] autorelease];
    UITabBarItem *barItem2=[[[UITabBarItem alloc] initWithTitle:@"我的估股" image:[UIImage imageNamed:@"myGooGuuBar"] tag:2] autorelease];
    UITabBarItem *barItem3=[[[UITabBarItem alloc] initWithTitle:@"估值观点" image:[UIImage imageNamed:@"googuuViewBar"] tag:3] autorelease];
    UITabBarItem *barItem4=[[[UITabBarItem alloc] initWithTitle:@"金融图汇" image:[UIImage imageNamed:@"graphExchangeBar"] tag:4] autorelease];
    UITabBarItem *barItem5=[[[UITabBarItem alloc] initWithTitle:@"估值模型" image:[UIImage imageNamed:@"companyListBar"] tag:5] autorelease];
    //股票关注
    MyGooguuViewController *myGooGuu=[[[MyGooguuViewController alloc] init] autorelease];
    myGooGuu.tabBarItem=barItem2;
    UINavigationController *myGooGuuNavController=nil;
    //金融图汇
    FinPicKeyWordListViewController *picView=[[[FinPicKeyWordListViewController alloc] init] autorelease];
    picView.tabBarItem=barItem4;
    UINavigationController *picKeyWordNav=nil;
    //估值观点
    GooGuuViewController *toolsViewController=[[[GooGuuViewController alloc] init] autorelease];
    toolsViewController.tabBarItem=barItem3;
    UINavigationController *toolsNav=nil;
    //估股新闻
    GooNewsViewController *gooNewsViewController=[[[GooNewsViewController alloc] init] autorelease];
    gooNewsViewController.tabBarItem=barItem;
    UINavigationController *gooNewsNavController=nil;
    //股票列表
    UniverseViewController *universeViewController=[[[UniverseViewController alloc] init] autorelease];
    universeViewController.tabBarItem=barItem5;
    UINavigationController *universeNav=nil;
    
    if (IOS7_OR_LATER) {
        myGooGuuNavController=[[[UINavigationController alloc] initWithRootViewController:myGooGuu] autorelease];
        gooNewsNavController=[[[UINavigationController alloc] initWithRootViewController:gooNewsViewController] autorelease];
        universeNav=[[[UINavigationController alloc] initWithRootViewController:universeViewController] autorelease];
        toolsNav=[[[[UINavigationController alloc] initWithRootViewController:toolsViewController] autorelease] autorelease];
        picKeyWordNav=[[[UINavigationController alloc] initWithRootViewController:picView] autorelease];
        self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    } else {
        myGooGuuNavController=[[[PrettyNavigationController alloc] initWithRootViewController:myGooGuu] autorelease];
        gooNewsNavController=[[[PrettyNavigationController alloc] initWithRootViewController:gooNewsViewController] autorelease];
        universeNav=[[[PrettyNavigationController alloc] initWithRootViewController:universeViewController] autorelease];
        toolsNav=[[[PrettyNavigationController alloc] initWithRootViewController:toolsViewController] autorelease];
        picKeyWordNav=[[[PrettyNavigationController alloc] initWithRootViewController:picView] autorelease];
        self.tabBarController = [[[PrettyTabBarViewController alloc] init] autorelease];
    }
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:gooNewsNavController,toolsNav,universeNav,picKeyWordNav, myGooGuuNavController,nil];
    
    self.window.backgroundColor=[UIColor clearColor];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
}



@end