//
//  HistoryViewController.m
//  Music
//
//  Created by runes on 12-8-28.
//  Copyright (c) 2012年 Runes.cn. All rights reserved.
//

#import "HistoryViewController.h"
#import "MySubCell.h"
#import "MyLabel.h"
#import "MusicInfo.h"
#import "DataBase.h"
#import "DetailViewController.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController
@synthesize listContent,player,noResultToDisplay,deleteButton;

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
    //设置标题
	self.title = @"最近访问";
    noResultToDisplay = TRUE;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.tableView.scrollEnabled = YES;
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 106, 44)];
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] 
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                          target:nil 
                                          action:nil];
    [buttons addObject:flexibleSpaceLeft];
    [flexibleSpaceLeft release];
    
    deleteButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                     target:self
                                     action:@selector(deleteAction:)];
    deleteButton.style = UIBarButtonItemStyleBordered;
    [buttons addObject:deleteButton];
    
    [toolbar setItems:buttons animated:NO];
    toolbar.barStyle = -1;
    [buttons release];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:toolbar] autorelease];
    [toolbar release];
}

- (void)viewWillAppear:(BOOL)animated
{
    DataBase *db = [[DataBase alloc] init];
    self.listContent = [db quaryTable:nil type:3];
    [db release];
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.listContent count] == 0) {
        noResultToDisplay = TRUE;
    }
    else {
        noResultToDisplay = FALSE;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tableView.rowHeight = 66;
    if (noResultToDisplay) {
        return 1;
    }
    else {
        return [self.listContent count];
    }
}

/**
 * 生成CELL行信息
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MySubCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
        //使用自定义的模板
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MySubCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
	}
    
    if(noResultToDisplay){
        cell.nameLabel.text = @"当前还没有访问的历史信息";
        cell.translationLabel.text = nil;
    }
    else {
        MusicInfo *musicInfo = [self.listContent objectAtIndex:indexPath.row];
        
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
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!noResultToDisplay) {
        DetailViewController *detailsViewController = [[DetailViewController alloc] init];
        MusicInfo *musicInfo = [self.listContent objectAtIndex:indexPath.row];    
        detailsViewController.title = musicInfo.wi_name;
        [detailsViewController setDetailsView:musicInfo withType:4];
        [[self navigationController] pushViewController:detailsViewController animated:YES];
        [detailsViewController release];
    }
}

/**
 * 释放内存
 */
- (void)dealloc
{
	[listContent release];
	[player release];
    [deleteButton release];
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

/**
 * 清空历史访问记录
 */
- (void)deleteAction:(id)sender
{
    DataBase *db =[[DataBase alloc]init];
    [db deleteHistoryTable];
    [db release];
    self.listContent = nil;
    [self.tableView reloadData];
}

@end
