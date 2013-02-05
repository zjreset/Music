//
//  IndexViewController.m
//  Music
//
//  Created by runes on 12-8-24.
//  Copyright (c) 2012年 Runes.cn. All rights reserved.
//

#import "IndexViewController.h"
@interface IndexViewController ()

@end

@implementation IndexViewController
@synthesize logoImageView,rootViewController,delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    //logoImageView.image = [UIImage imageNamed:@"company_logo.png"];
    [super viewDidLoad];
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

- (void)viewDidAppear:(BOOL)animated
{
    [self initializeDb];
    //[self performSelector:@selector(initializeDb) withObject:nil afterDelay:0];
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
    
    //rootViewController = [[RootViewController alloc] init];
    //[self.view addSubview:rootViewController.view];
    [delegate getMain];
    return YES;  
    //END:code.DatabaseShoppingList.copyDatabaseFileToDocuments 
}       

- (void) dealloc
{
    [logoImageView release];
    [super dealloc];
}

@end
