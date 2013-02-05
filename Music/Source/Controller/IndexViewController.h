//
//  IndexViewController.h
//  Music
//
//  Created by runes on 12-8-24.
//  Copyright (c) 2012年 Runes.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "SwitchViewDelegate.h"

@interface IndexViewController : UIViewController
{
    UIImageView *logoImageView;
    RootViewController *rootViewController;
    id<SwitchViewDelegate> delegate;
}
@property(nonatomic,retain) id<SwitchViewDelegate> delegate;
@property (nonatomic, retain) UIImageView *logoImageView;
@property (nonatomic, retain) RootViewController *rootViewController;
@end
