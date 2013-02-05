//
//  ClassifyViewController.h
//  Music
//
//  Created by runes on 12-8-28.
//  Copyright (c) 2012年 Runes.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ClassifyViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
{
	NSArray         *listContent;	
	NSArray         *alertListContent;
    AVAudioPlayer   *player;
    BOOL            noResultToDisplay;
    UIBarButtonItem *languageButton;
    UIBarButtonItem *freqButton;
    UIBarButtonItem *resourceButton;
    UIBarButtonItem *resetButton;
    UITableView     *alertTableView;
    UIAlertView     *myAlertView;
    int             clickTag;
    NSString        *languageName;
    NSString        *resourceName;
    NSString        *freqName;
}
@property (nonatomic, retain) NSArray *listContent;
@property (nonatomic, retain) NSArray *alertListContent;
@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic) BOOL noResultToDisplay;
@property (nonatomic, retain) UIBarButtonItem *languageButton;
@property (nonatomic, retain) UIBarButtonItem *freqButton;
@property (nonatomic, retain) UIBarButtonItem *resourceButton;
@property (nonatomic, retain) UIBarButtonItem *resetButton;
@property (nonatomic, retain) UITableView *alertTableView;
@property (nonatomic, retain) UIAlertView *myAlertView;
@property (nonatomic) int clickTag;
@property (nonatomic, retain) NSString *languageName;
@property (nonatomic, retain) NSString *resourceName;
@property (nonatomic, retain) NSString *freqName;
@end
