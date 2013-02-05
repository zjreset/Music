//
//  SearchViewController.m
//  Music
//
//  Created by runes on 12-8-28.
//  Copyright (c) 2012年 Runes.cn. All rights reserved.
//

#import "SearchViewController.h"
#import "MySubCell.h"
#import "MyLabel.h"
#import "MusicInfo.h"
#import "DataBase.h"
#import "DetailViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

@synthesize listContent, filteredListContent, savedSearchTerm, savedScopeButtonIndex, searchWasActive,player;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //设置标题
	self.title = @"词汇检索";
    
    //显示检索类型,这里默认不显示,当用户点击搜索框时显示
    //self.searchDisplayController.searchBar.showsScopeBar = YES;
	
	// create a filtered list that will contain products for the search results table.
	self.filteredListContent = [NSMutableArray arrayWithCapacity:[self.listContent count]];
	
	// restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        
        self.savedSearchTerm = nil;         
    }
    
    //    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TabBarView" owner:self options:nil];
    //    MyTabBar *myTabBar = (MyTabBar *)[nib objectAtIndex:0];
    //    [myTabBar setFrame:CGRectMake(0, self.view.bounds.size.height -44, self.view.bounds.size.width, 44)];  
    //    myTabBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth; 
    //    [myTabBar setSelectedItem:myTabBar.tabBar1];
    //    [self.tableView addSubview:myTabBar];
	
	[self.tableView reloadData];
	self.tableView.scrollEnabled = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.filteredListContent = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tableView.rowHeight = 66;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.filteredListContent count];
    }
	else
	{
        return [self.listContent count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MySubCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
        //		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellID] autorelease];
        //		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //使用自定义的模板
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MySubCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
	}
	
	/*
	 If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
	 */
	MusicInfo *musicInfo = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        musicInfo = [self.filteredListContent objectAtIndex:indexPath.row];
    }
	else
	{
        musicInfo = [self.listContent objectAtIndex:indexPath.row];
    }
    NSString *musicFilePath = [[NSBundle mainBundle] pathForResource:[musicInfo.wi_name lowercaseString] ofType:@"mp3"];        //创建音乐文件路径
    if (musicFilePath != NULL) {                //判断该路径是否存在,如存在,则显示播放图标
        cell.imageView.image = [UIImage imageNamed:@"icon_annoucement.png"];
        cell.imageView.userInteractionEnabled = YES;
        cell.imageView.imageName = musicInfo.wi_name;     //将文件名称传入图片属性中,待点击时获取文件
        UITapGestureRecognizer *singleTouch=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(speakVoice:)];
        singleTouch.numberOfTouchesRequired = 1;    //触摸点个数
        singleTouch.numberOfTapsRequired = 1;
        [cell.imageView addGestureRecognizer:singleTouch];
        [singleTouch release];
        musicFilePath = nil;
    }
    if(musicInfo.wi_language != NULL){
        cell.nameLabel.text = [musicInfo.wi_name stringByAppendingString: musicInfo.wi_language];
    }
    else{
        cell.nameLabel.text = musicInfo.wi_name;
    }
    [cell.nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    if(musicInfo.wi_translation_simple != NULL){
        cell.translationLabel.text = musicInfo.wi_translation_simple;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailsViewController = [[DetailViewController alloc] init];
    
	/*
	 If the requesting table view is the search display controller's table view, configure the next view controller using the filtered content, otherwise use the main list.
	 */
	MusicInfo *musicInfo = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        musicInfo = [self.filteredListContent objectAtIndex:indexPath.row];
    }
	else
	{
        musicInfo = [self.listContent objectAtIndex:indexPath.row];
    }
    detailsViewController.title = musicInfo.wi_name;
    DataBase *db = [[DataBase alloc] init];
    [db saveHistory:musicInfo.wi_id type:1];
    [db release];
    [detailsViewController setDetailsView:musicInfo withType:1];
    [[self navigationController] pushViewController:detailsViewController animated:YES];
    [detailsViewController release];
}

/**
 * 隐藏视图
 */
- (void)viewDidDisappear:(BOOL)animated
{
    // save the state of the search UI so that it can be restored if the view is re-created
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
}      

/**
 * 初始化search bar时讲取消按钮的标题更改为中文
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    for (id cc in [searchBar subviews]) {
        if ([cc isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)cc;
            [button setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}

/**
 * 释放内存
 */
- (void)dealloc
{
	[listContent release];
	[filteredListContent release];
	[player release];
    savedSearchTerm = nil;
    savedScopeButtonIndex = 0;
	[super dealloc];
}

#pragma mark - slef method

/**
 * 点击图标播放声音
 */
- (void)speakVoice:(UITapGestureRecognizer *)sender
{ 
    
    if(sender.state == UIGestureRecognizerStateEnded)
    { 
        NSString *musicFilePath = [[NSBundle mainBundle] pathForResource:[((SpeakImageView*)sender.view).imageName lowercaseString] ofType:@"mp3"];       //创建音乐文件路径
        if (musicFilePath != NULL) {
            NSURL *musicURL = [[NSURL alloc] initFileURLWithPath:musicFilePath];  
            player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
            
            [musicURL release];
            //[player prepareToPlay];
            if (player == nil){
                NSLog(@"audio player not initialized");   
            }          
            else if(TARGET_IPHONE_SIMULATOR){
                NSLog(@"player play"); 
                //[player play];   //播放
            } 
            else{
                [player play];  
            }
        }
        
    }
}

/**
 * 通过按钮点击响应超链接的页面跳转
 */
- (void)showWebView:(UITapGestureRecognizer *)sender
{
    MyLabel *wi_link_path = (MyLabel*)sender.view;
    UIViewController *webController = [[UIViewController alloc] init];
    UIWebView *webView = [[UIWebView alloc] init];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:wi_link_path.text]];
    [webView loadRequest:request];
    webController.view = webView;
    [[self navigationController] pushViewController:webController animated:YES];
    //[wi_link_path release];
    [webView release];
    [webController release];
}

#pragma mark -
#pragma mark Content Filtering
/**
 * 根据过滤信息设置过滤list
 */
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	[self.filteredListContent removeAllObjects]; // 首先清空过滤list.
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
    //NSLog(@"scope is %@",scope);
//	for (MusicInfo *musicInfo in listContent)
//	{
//        if ([scope isEqualToString:@"描述"])
//		{
//			NSComparisonResult result = [musicInfo.wi_translation_simple compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
//            if (result == NSOrderedSame)
//			{
//				[self.filteredListContent addObject:musicInfo];
//            }
//		}
//        else if([scope isEqualToString:@"解释"])
//		{
//			NSComparisonResult result = [musicInfo.wi_translation_details compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
//            if (result == NSOrderedSame)
//			{
//				[self.filteredListContent addObject:musicInfo];
//            }
//		}
//        else
//		{
//			NSComparisonResult result = [musicInfo.wi_name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
//            if (result == NSOrderedSame)
//			{
//				[self.filteredListContent addObject:musicInfo];
//            }
//		}
//	}
    DataBase *db =[[DataBase alloc]init];
    if ([scope isEqualToString:@"描述"])
    {
        self.filteredListContent = [db quaryTable:[[@" and wt_msg_zh like '%%" stringByAppendingFormat:@"%@",searchText] stringByAppendingFormat:@"%%' "] type:1];
    }
    else if([scope isEqualToString:@"解释"])
    {
        self.filteredListContent = [db quaryTable:[[@" and wtd_msg_zh like '%%" stringByAppendingFormat:@"%@",searchText] stringByAppendingFormat:@"%%' "] type:2];
    }
    else
    {
        self.filteredListContent = [db quaryTable:[[@" and wi_name like '" stringByAppendingFormat:@"%@",searchText] stringByAppendingFormat:@"%%' "] type:0];
    }
    [db release];
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods


/**
 * 发生更换检索字符串时执行的方法
 */
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

/**
 * 发生更改检索scope时执行的方法
 */
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    //NSLog(@"QQQ:%@",[self.searchDisplayController.searchBar text]);
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


@end
