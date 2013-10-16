//
//  GooGuuViewController.m
//  googuu
//
//  Created by Xcode on 13-10-16.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "GooGuuViewController.h"
#import "ValueViewCell.h"
#import "UIImageView+WebCache.h"
#import "GooGuuArticleViewController.h"
#import "ArticleCommentViewController.h"
#import "MHTabBarController.h"

@interface GooGuuViewController ()

@end

@implementation GooGuuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.viewDataArr=[[NSArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"估值观点"];
    [Utiles iOS7StatusBar:self];
	[self initComponents];
    [self getValueViewData:@"" code:@""];
}

-(void)initComponents{
    
    [self.view setBackgroundColor:[Utiles colorWithHexString:@"#FDFBE4"]];
    self.cusTable=[[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-120)];
    self.cusTable.delegate=self;
    self.cusTable.dataSource=self;
    self.cusTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    if(_refreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.cusTable.bounds.size.height, self.view.frame.size.width, self.cusTable.bounds.size.height)];
        
        view.delegate = self;
        [self.cusTable addSubview:view];
        _refreshHeaderView = view;
        [view release];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    [self.view addSubview:self.cusTable];
    
}
-(void)getValueViewData:(NSString *)articleID code:(NSString *)stockCode{
    
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:articleID,@"articleid",stockCode,@"stockcode", nil];
    [Utiles getNetInfoWithPath:@"GooGuuView" andParams:params besidesBlock:^(id obj) {
        
        NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];        
        for (id data in obj) {
            [temp addObject:data];
        }
        self.viewDataArr=temp;
        [self.cusTable reloadData];
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.cusTable];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

#pragma mark -
#pragma mark Table DataSource

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.viewDataArr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ValueViewCellIdentifier = @"ValueViewCellIdentifier";
    ValueViewCell *cell = (ValueViewCell*)[tableView dequeueReusableCellWithIdentifier:ValueViewCellIdentifier];//复用cell
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ValueViewCell" owner:self options:nil];//加载自定义cell的xib文件
        cell = [array objectAtIndex:0];
    }
    
    id model=[self.viewDataArr objectAtIndex:indexPath.row];

    if([model objectForKey:@"titleimgurl"]){
        [cell.titleImgView setImageWithURL:[NSURL URLWithString:[[model objectForKey:@"titleimgurl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"defaultIcon"]];
    }
    
    [cell.titleLabel setText:[model objectForKey:@"title"]];
    [cell.conciseLabel setText:[model objectForKey:@"concise"]];
    cell.conciseLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.conciseLabel.numberOfLines = 0;
    [cell.updateTimeLabel setText:[model objectForKey:@"updatetime"]];
    
    [cell.backLabel setBackgroundColor:[UIColor whiteColor]];
    cell.backLabel.layer.cornerRadius = 5;
    cell.backLabel.layer.borderColor = [UIColor grayColor].CGColor;
    cell.backLabel.layer.borderWidth = 0.5;
    
    [cell setBackgroundColor:[Utiles colorWithHexString:@"#FDFBE4"]];
    
    return cell;
    
}





#pragma mark -
#pragma mark Table Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *artId=[NSString stringWithFormat:@"%@",[[self.viewDataArr objectAtIndex:indexPath.row] objectForKey:@"articleid"]];
    GooGuuArticleViewController *articleViewController=[[GooGuuArticleViewController alloc] init];
    articleViewController.articleTitle=[[self.viewDataArr objectAtIndex:indexPath.row] objectForKey:@"title"];
    articleViewController.articleId=artId;
    articleViewController.title=@"研究报告";
    ArticleCommentViewController *articleCommentViewController=[[ArticleCommentViewController alloc] init];
    articleCommentViewController.articleId=artId;
    articleCommentViewController.title=@"评论";
    articleCommentViewController.type=News;
    MHTabBarController *container=[[MHTabBarController alloc] init];
    NSArray *controllers=[NSArray arrayWithObjects:articleViewController,articleCommentViewController, nil];
    container.viewControllers=controllers;
    
    container.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:container animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



#pragma mark -
#pragma mark - Table Header View Methods


- (void)doneLoadingTableViewData{
    
    [self getValueViewData:@"" code:@""];
    _reloading = NO;
    
}


#pragma mark –
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark –
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [_activityIndicatorView startAnimating];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
    
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    
    return _reloading; // should return if data source model is reloading
    
}
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}


-(BOOL)shouldAutorotate{
    return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
