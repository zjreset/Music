//
//  DetailViewController.h
//  Music
//
//  Created by runes on 12-9-28.
//  Copyright (c) 2012年 Runes.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MusicInfo.h"

@interface DetailViewController : UIViewController
{
    AVAudioPlayer   *player;
}
@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, retain) UIScrollView *scrollView;
- (void)setDetailsView:(MusicInfo*)musicInfo withType:(int) type;

@end
