//
//  AMTextFieldNumberPad.h
//  KeyboardNumberPad
//
//  Created by Vinogradov Sergey on 13.06.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	ButtonIconNone = 0,
	ButtonIconKeyboard = 1,
	ButtonIconCustom = 2
} ButtonIcon;

@interface AMTextFieldNumberPad : UITextField <UITextFieldDelegate> {
	UIButton *buttonDone;
	NSString *buttonText;
	UIImage *buttonImage;
	
	CGRect buttonRectShow;
	CGRect buttonRectHide;
	
	CGFloat buttonDurationShow;
	CGFloat buttonDurationHide;
	
	ButtonIcon buttonIcon;
	
	BOOL isKeyboardShow;
	BOOL isPortrait;
	BOOL isRotating;
}

@property (nonatomic, retain) NSString *buttonText;
@property (nonatomic, retain) UIImage *buttonImage;
@property (nonatomic, assign) ButtonIcon buttonIcon;

@end
