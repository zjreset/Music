//
//  AppDelegate.h
//  Music
//
//  Created by runes on 12-8-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchViewDelegate.h"
#import "IndexViewController.h"
#import "RootViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,SwitchViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) IndexViewController *indexViewController;
@property (nonatomic, retain) RootViewController *rootViewController;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
