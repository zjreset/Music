//
//  RootViewController.h
//  Music
//
//  Created by runes on 12-8-27.
//  Copyright (c) 2012年 Runes.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITabBarController
{
    IBOutlet UITabBarItem *tabBar1;
    IBOutlet UITabBarItem *tabBar2;
    IBOutlet UITabBarItem *tabBar3;
    IBOutlet UITabBarItem *tabBar4;
}
@property(nonatomic,retain) UITabBarItem *tabBar1,*tabBar2,*tabBar3,*tabBar4;

@end
