//
//  SpeedViewController.h
//  Music
//
//  Created by runes on 12-8-28.
//  Copyright (c) 2012年 Runes.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SpeedViewController : UITableViewController
{
	NSArray			*listContent;			
    AVAudioPlayer   *player;
}
@property (nonatomic, retain) NSArray *listContent;
@property (nonatomic, retain) AVAudioPlayer *player;

@end
