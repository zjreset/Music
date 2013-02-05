//
//  DetailViewController.m
//  Music
//
//  Created by runes on 12-9-28.
//  Copyright (c) 2012年 Runes.cn. All rights reserved.
//

#import "DetailViewController.h"
#import "MyLabel.h"
#import "SpeakImageView.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize player,scrollView;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDetailsView:(MusicInfo*)musicInfo withType:(int) type
{
    scrollView = [[UIScrollView alloc] init];
    scrollView.scrollEnabled = TRUE;
    scrollView.contentSize = CGSizeMake(320, 450);
    scrollView.showsVerticalScrollIndicator = TRUE;
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    
    //设置基础信息
    int x = 10,y = 10, w = 300, h = 35;
    UILabel *wi_name = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
    if(musicInfo.wi_language != NULL){
        wi_name.text = [musicInfo.wi_name stringByAppendingString:musicInfo.wi_language];
    }
    else {
        wi_name.text = musicInfo.wi_name;
    }
    y = y + h+10;
    [wi_name setFont:[UIFont fontWithName:@"Helvetica-Bold" size:22]];
    [scrollView addSubview:wi_name];
    [wi_name release];
    
    //播放图标及读音设置
    BOOL istrue = FALSE;
    NSString *musicFilePath = [[NSBundle mainBundle] pathForResource:[musicInfo.wi_name lowercaseString] ofType:@"mp3"];        //创建音乐文件路径
    if (musicFilePath != NULL) {                //判断该路径是否存在,如存在,则显示播放图标
        istrue = TRUE;
        SpeakImageView *wi_img_speak = [[SpeakImageView alloc] initWithFrame:CGRectMake(260, y, 35, h)];
        wi_img_speak.imageName = musicInfo.wi_name;     //将文件名称传入图片属性中,待点击的获取文件
        wi_img_speak.image = [UIImage imageNamed:@"icon_annoucement.png"];
        wi_img_speak.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTouch=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(speakVoice:)];
        singleTouch.numberOfTouchesRequired = 1;    //触摸点个数
        singleTouch.numberOfTapsRequired = 1;
        [wi_img_speak addGestureRecognizer:singleTouch];
        [scrollView addSubview:wi_img_speak];
        [wi_img_speak release];
        [singleTouch release];
        musicFilePath = nil;
    }
    //音标设置
    if (musicInfo.wi_symbol != NULL) {
        istrue = TRUE;
        UILabel *wi_symbol = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w-55, h)];
        wi_symbol.text = [[@"【" stringByAppendingString: musicInfo.wi_symbol] stringByAppendingString:@"】"];
        [wi_symbol setFont:[UIFont fontWithName:@"Helvetica-Oblique" size:17]];
        [scrollView addSubview:wi_symbol];
        [wi_symbol release];
    }
    //判断是否存在音标或播放声音,如果存在,则y+h;
    if(istrue){
        y = y + h;
    }
    //增加分隔线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y-2, w, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [scrollView addSubview:lineView];
    [lineView release];
    
    switch (type) {
        case 3:
            //BPM参考值
            if (musicInfo.ws_simple_bpm != NULL) {
                UILabel *ws_simple_bpm = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
                y = y + h;
                ws_simple_bpm.text = [@"【BPM参考值】" stringByAppendingString:musicInfo.ws_simple_bpm];
                [scrollView addSubview:ws_simple_bpm];
                [ws_simple_bpm release];
                
                //分隔线
                lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y-2, w, 1)];
                lineView.backgroundColor = [UIColor lightGrayColor];
                [scrollView addSubview:lineView];
                [lineView release];
            }
            
            //BPM范围值
            if (musicInfo.ws_area_bpm != NULL) {
                UILabel *ws_area_bpm = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
                y = y + h;
                ws_area_bpm.text = [@"【BPM范围值】" stringByAppendingString:musicInfo.ws_area_bpm];
                [scrollView addSubview:ws_area_bpm];
                [ws_area_bpm release];
                
                //分隔线
                lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y-2, w, 1)];
                lineView.backgroundColor = [UIColor lightGrayColor];
                [scrollView addSubview:lineView];
                [lineView release];
            }
            
            //速度参考信息
            if (musicInfo.ws_other != NULL) {
                int colomNumber = musicInfo.ws_other.length+10;
                int temph = 25*(1+colomNumber/16) + 15;
                UITextView *ws_other = [[UITextView alloc] initWithFrame:CGRectMake(x-10, y, w, temph)];
                y = y + temph;
                ws_other.text = [@"【BPM参考信息】" stringByAppendingString: musicInfo.ws_other];
                [ws_other setFont:[UIFont fontWithName:@"Helvetica" size:17]];
                [ws_other setEditable:NO];
                [scrollView addSubview:ws_other];
                [ws_other release];
                
                lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y-2, w, 1)];
                lineView.backgroundColor = [UIColor lightGrayColor];
                [scrollView addSubview:lineView];
                [lineView release];
            }
            break;
            
        default:
            break;
    }
    
    
    //翻译设置
    if (musicInfo.wi_translation_simple != NULL) {
        int colomNumber = musicInfo.wi_translation_simple.length;
        int temph = 25*(1+colomNumber/16) + 15;
        UITextView *wi_translation_simple = [[UITextView alloc] initWithFrame:CGRectMake(x-10, y, w, temph)];
        y = y + temph;
        wi_translation_simple.text = [@"【描述】" stringByAppendingString: musicInfo.wi_translation_simple];
        [wi_translation_simple setFont:[UIFont fontWithName:@"Helvetica" size:17]];
        [wi_translation_simple setEditable:NO];
        [scrollView addSubview:wi_translation_simple];
        [wi_translation_simple release];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y-2, w, 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [scrollView addSubview:lineView];
        [lineView release];
    }
    //链接地址
    if (musicInfo.wi_link_path != NULL) {
        MyLabel *wi_link_path = [[MyLabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        y = y + h;
        wi_link_path.text = musicInfo.wi_link_path;
        UITapGestureRecognizer *singleTouch=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showWebView:)];
        singleTouch.numberOfTouchesRequired = 1;    //触摸点个数
        singleTouch.numberOfTapsRequired = 1;
        [wi_link_path addGestureRecognizer:singleTouch];
        [scrollView addSubview:wi_link_path];
        [singleTouch release];
        [wi_link_path release];
        
        //分隔线
        lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y-2, w, 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [scrollView addSubview:lineView];
        [lineView release];
    }
    //类型设置
    istrue = false;
    if (musicInfo.wi_class != NULL) {
        istrue = true;
        UILabel *wi_class = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        y = y + h;
        wi_class.text = [@"【类型】" stringByAppendingString:musicInfo.wi_class];
        [scrollView addSubview:wi_class];
        [wi_class release];
    }
    //归类设置
    if (musicInfo.wi_type != NULL) {
        istrue = true;
        UILabel *wi_type = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        y = y + h;
        wi_type.text = [@"【归类】" stringByAppendingString:musicInfo.wi_type];
        [scrollView addSubview:wi_type];
        [wi_type release];
    }
    //常见程度设置
    if (musicInfo.wi_deep != NULL) {
        istrue = true;
        UILabel *wi_deep = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        y = y + h;
        wi_deep.text = [@"【常见程度】" stringByAppendingString:musicInfo.wi_deep];
        [scrollView addSubview:wi_deep];
        [wi_deep release];
    }
    //领域设置
    if (musicInfo.wi_area != NULL) {
        istrue = true;
        UILabel *wi_area = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        y = y + h;
        wi_area.text = [@"【领域】" stringByAppendingString:musicInfo.wi_area];
        [scrollView addSubview:wi_area];
        [wi_area release];
    }
    if (istrue) {
        lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y-2, w, 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [scrollView addSubview:lineView];
        [lineView release];
    }
    //图片设置
    if (musicInfo.wi_picture_path != NULL) {
        UIImage *image = [UIImage imageNamed:musicInfo.wi_picture_path];
        int width = image.size.width,height = image.size.height;
        if (width > w) {
            width = w;
        }
        if (height > 200) {
            height = 200;
        }
        UIImageView *wi_picture_path = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        y = y + image.size.height;
        wi_picture_path.image = image;
        [scrollView addSubview:wi_picture_path];
        //[image release];
        [wi_picture_path release];
        lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y-2, w, 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [scrollView addSubview:lineView];
        [lineView release];
    }
    //解释设置
    if (musicInfo.wi_translation_details != NULL) {
        int colomNumber = musicInfo.wi_translation_details.length;
        int temph = 25*(1+colomNumber/16) + 15;
        UITextView *wi_translation_details = [[UITextView alloc] initWithFrame:CGRectMake(x, y, w, temph)];
        wi_translation_details.text = musicInfo.wi_translation_details;
        [wi_translation_details setEditable:NO];
        [scrollView addSubview:wi_translation_details];
        [wi_translation_details release];
    }
    self.view = scrollView;
}

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

@end
