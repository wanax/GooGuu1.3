//
//  ComFieldViewController.m
//  UIDemo
//
//  Created by Xcode on 13-7-10.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ComFieldViewController.h"
#import "IntroductionViewController.h"
#import "ModelViewController.h"
#import "AnalysisReportViewController.h"
#import "MHTabBarController.h"
#import "ContainerViewController.h"
#import "PrettyToolbar.h"


@interface ComFieldViewController ()

@end

@implementation ComFieldViewController

@synthesize browseType;

@synthesize viewController1;
@synthesize viewController2;
@synthesize viewController3;
@synthesize viewController4;
@synthesize tabBarController;
@synthesize top;
@synthesize myToolBarItems;



- (void)dealloc
{
    SAFE_RELEASE(myToolBarItems);
    SAFE_RELEASE(top);
    SAFE_RELEASE(tabBarController);
    SAFE_RELEASE(viewController1);
    SAFE_RELEASE(viewController2);
    SAFE_RELEASE(viewController3);
    SAFE_RELEASE(viewController4);
    
    [super dealloc];
}

//退回主菜单
-(void)back:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [Utiles iOS7StatusBar:self];
    ContainerViewController *content=[[ContainerViewController alloc] init];
    content.browseType=self.browseType;
    if (IOS7_OR_LATER) {
        content.view.frame=CGRectMake(0,64,FRAME_WIDTH,FRAME_HEIGHT);
    } else {
        content.view.frame=CGRectMake(0,24,FRAME_WIDTH,FRAME_HEIGHT);
    }
    
    [self.view addSubview:content.view];
    [self addChildViewController:content];
    [self addToolBar];
    [content release];

    
}

-(void)addToolBar{
    
    [self.view setBackgroundColor:[Utiles colorWithHexString:@"#D6D6D4"]];
    
    UILabel *companyNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 40)];
    [companyNameLabel setBackgroundColor:[UIColor clearColor]];
    XYZAppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    id comInfo=delegate.comInfo;
    [companyNameLabel setText:[comInfo objectForKey:@"companyname"]];
    [companyNameLabel setTextAlignment:NSTextAlignmentCenter];
    
    if (IOS7_OR_LATER) {
        top=[[UIToolbar alloc] initWithFrame:CGRectMake(0,20,SCREEN_WIDTH,44)];
        [companyNameLabel setTextColor:[Utiles colorWithHexString:@"#2E71FA"]];
    } else {
        top=[[PrettyToolbar alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,44)];
        [companyNameLabel setTextColor:[UIColor whiteColor]];
    }

    [top addSubview:companyNameLabel];
    SAFE_RELEASE(companyNameLabel);
    UIBarButtonItem *back=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
    [back setBackgroundImage:[UIImage imageNamed:@"backBt"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    myToolBarItems=[[NSMutableArray alloc] init];
    [myToolBarItems addObject:back];
    [top setItems:myToolBarItems];
    [self.view addSubview:top];
    [back release];
    [top release];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSUInteger)supportedInterfaceOrientations{
    
    if([[self childViewControllers] count]>0){
        return [[self.childViewControllers objectAtIndex:0] supportedInterfaceOrientations];
    }else{
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
}

- (BOOL)shouldAutorotate
{
    if([[self childViewControllers] count]>0){
        return [[self.childViewControllers objectAtIndex:0] shouldAutorotate];
    }else{
        return NO;
    }
}











@end
