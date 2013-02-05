//
//  HistoryViewController.h
//  Music
//
//  Created by runes on 12-8-28.
//  Copyright (c) 2012年 Runes.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface HistoryViewController : UITableViewController
{
	NSArray			*listContent;			
    AVAudioPlayer   *player;
    BOOL            noResultToDisplay;
    UIBarButtonItem *deleteButton;
}
@property (nonatomic, retain) NSArray *listContent;
@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic) BOOL noResultToDisplay;
@property (nonatomic, retain) UIBarButtonItem *deleteButton;

@end
