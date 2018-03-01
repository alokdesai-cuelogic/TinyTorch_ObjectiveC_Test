//
//  AppDelegate.h
//  tinytorch_test
//
//  Created by Alok Desai on 20/02/18.
//  Copyright © 2018 Cuelogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

@end

