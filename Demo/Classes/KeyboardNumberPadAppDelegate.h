//
//  KeyboardNumberPadAppDelegate.h
//  KeyboardNumberPad
//
//  Created by Vinogradov Sergey on 11.06.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KeyboardNumberPadViewController;

@interface KeyboardNumberPadAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    KeyboardNumberPadViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet KeyboardNumberPadViewController *viewController;

@end

