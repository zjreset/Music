//
//  SpeedViewController.m
//  Music
//
//  Created by runes on 12-8-28.
//  Copyright (c) 2012年 Runes.cn. All rights reserved.
//

#import "SpeedViewController.h"
#import "MySubCell.h"
#import "MyLabel.h"
#import "MusicInfo.h"
#import "DataBase.h"
#import "DetailViewController.h"

@interface SpeedViewController ()

@end

@implementation SpeedViewController
@synthesize listContent,player;

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
	self.title = @"速度词汇";

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.tableView.scrollEnabled = YES;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tableView.rowHeight = 66;
    return [self.listContent count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{static NSString *CellIdentifier = @"Cell";
    MySubCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
        //使用自定义的模板
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MySubCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
	}
	
	/*
	 If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
	 */
	MusicInfo *musicInfo = [self.listContent objectAtIndex:indexPath.row];
    
    NSString *musicFilePath = [[NSBundle mainBundle] pathForResource:[musicInfo.wi_name lowercaseString] ofType:@"mp3"];        //创建音乐文件路径
    if (musicFilePath != NULL) {                //判断该路径是否存在,如存在,则显示播放图标
        cell.imageView.image = [UIImage imageNamed:@"icon_annoucement.png"];
        cell.imageView.userInteractionEnabled = YES;
        cell.imageView.imageName = musicInfo.ws_name;     //将文件名称传入图片属性中,待点击时获取文件
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
    //[cell.translationLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    NSMutableString *msg = [[NSMutableString alloc] init];
    if(musicInfo.ws_simple_bpm != NULL){
        [msg appendString:[NSString stringWithFormat:@"【BPM参考值】:%@",musicInfo.ws_simple_bpm]];
    }
    if(musicInfo.ws_area_bpm != NULL){
        [msg appendString:[NSString stringWithFormat:@"【BPM范围值】:%@",musicInfo.ws_area_bpm]];
    }
//    if(musicInfo.ws_other != NULL){
//        [msg appendString:[NSString stringWithFormat:@"\n%@",musicInfo.ws_other]];
//    }
//    else {
//    }
//    //设置自动行数与字符换行  
//    [cell.translationLabel setNumberOfLines:0];  
//    cell.translationLabel.lineBreakMode = UILineBreakModeWordWrap;  
//    UIFont *font = [UIFont fontWithName:@"Arial" size:12];  
//    //设置一个行高上限  
//    CGSize size = CGSizeMake(320,2000);  
//    //计算实际frame大小，并将label的frame变成实际大小  
//    CGSize labelsize = [msg sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];  
//    [cell.translationLabel setFrame:CGRectMake(cell.translationLabel.frame.origin.x, cell.translationLabel.frame.origin.y, cell.translationLabel.frame.size.width, labelsize.height)];  
    cell.translationLabel.text = msg;
    [msg release];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailsViewController = [[DetailViewController alloc] init];
	MusicInfo *musicInfo = [self.listContent objectAtIndex:indexPath.row];    
    detailsViewController.title = musicInfo.wi_name;
    
    //记录访问历史
    DataBase *db = [[DataBase alloc] init];
    [db saveHistory:musicInfo.wi_id type:1];
    [db release];
    
    [detailsViewController setDetailsView:musicInfo withType:3];
    [[self navigationController] pushViewController:detailsViewController animated:YES];
    [self.tableView scrollsToTop];
    [detailsViewController release];
}

/**
 * 释放内存
 */
- (void)dealloc
{
	[listContent release];
	[player release];
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

@end
