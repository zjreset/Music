//
//  RootViewController.m
//  Music
//
//  Created by runes on 12-8-27.
//  Copyright (c) 2012年 Runes.cn. All rights reserved.
//

#import "RootViewController.h"
#import "SearchViewController.h"
#import "ClassifyViewController.h"
#import "SpeedViewController.h"
#import "HistoryViewController.h"
#import "DataBase.h"


@interface RootViewController ()

@end

@implementation RootViewController
@synthesize tabBar1,tabBar2,tabBar3,tabBar4;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self){
        SearchViewController *view1 = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:[NSBundle mainBundle]];
        ClassifyViewController *view2 = [[ClassifyViewController alloc] initWithNibName:@"ClassifyViewController" bundle:[NSBundle mainBundle]];
        SpeedViewController *view3 = [[SpeedViewController alloc] initWithNibName:@"SpeedViewController" bundle:[NSBundle mainBundle]];
        HistoryViewController *view4 = [[HistoryViewController alloc] initWithNibName:@"HistoryViewController" bundle:[NSBundle mainBundle]];
        //tabBar1 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:1];
        //tabBar2 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:2];
        //tabBar3 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:3];
        //tabBar4 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:4];
        tabBar1 = [[UITabBarItem alloc] initWithTitle:@"词汇检索" image:[UIImage imageNamed:@"icon_glass.png"] tag:1];
        tabBar2 = [[UITabBarItem alloc] initWithTitle:@"分类检索" image:[UIImage imageNamed:@"icon_copy.png"] tag:2];
        tabBar3 = [[UITabBarItem alloc] initWithTitle:@"速度词汇" image:[UIImage imageNamed:@"icon_star.png"] tag:3];
        tabBar4 = [[UITabBarItem alloc] initWithTitle:@"最近访问" image:[UIImage imageNamed:@"icon_time.png"] tag:4];
        
        [view1 setTabBarItem:tabBar1];
        [view2 setTabBarItem:tabBar2];
        [view3 setTabBarItem:tabBar3];
        [view4 setTabBarItem:tabBar4];
        
        //加载数据库控制器
        DataBase *db =[[DataBase alloc]init];
        view2.listContent = view1.listContent = [db quaryTable:nil type:0];
        view3.listContent = [db quaryTable:nil type:4];
        
        [db release];
        
        UINavigationController *navController1 = [[UINavigationController alloc] initWithRootViewController:view1];
        UINavigationController *navController2 = [[UINavigationController alloc] initWithRootViewController:view2];
        UINavigationController *navController3 = [[UINavigationController alloc] initWithRootViewController:view3];
        UINavigationController *navController4 = [[UINavigationController alloc] initWithRootViewController:view4];
        
        self.viewControllers = [NSArray arrayWithObjects:navController1,navController2,navController3,navController4, nil];
        [view1 release];
        [view2 release];
        [view3 release];
        [view4 release];
        [navController1 release];
        [navController2 release];
        [navController3 release];
        [navController4 release];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeDb];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
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

- (BOOL) initializeDb {
    NSLog (@"初始化DB");
    // look to see if DB is in known location (~/Documents/$DATABASE_FILE_NAME)
    //START:code.DatabaseShoppingList.findDocumentsDirectory
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentFolderPath = [searchPaths objectAtIndex: 0];
    //查看文件目录
    NSString *dbFilePath = [documentFolderPath stringByAppendingPathComponent:@"music_db.db"];
    //END:code.DatabaseShoppingList.findDocumentsDirectory
    //START:code.DatabaseShoppingList.copyDatabaseFileToDocuments
    if (![[NSFileManager defaultManager] fileExistsAtPath: dbFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:dbFilePath error:nil];
        // didn't find db, need to copy
        NSString *backupDbPath = [[NSBundle mainBundle] pathForResource:@"music_db" ofType:@"db"];
        NSLog(@"%@",backupDbPath);
        if (backupDbPath == nil) {
            // couldn't find backup db to copy, bail
            return NO;
        } else {
            BOOL copiedBackupDb = [[NSFileManager defaultManager] copyItemAtPath:backupDbPath toPath:dbFilePath error:nil];
            if (! copiedBackupDb) {
                // copying backup db failed, bail
                return NO;
            }
        }
    }
    NSLog (@"完成初始化DB");
    return YES;
    //END:code.DatabaseShoppingList.copyDatabaseFileToDocuments
}

@end
