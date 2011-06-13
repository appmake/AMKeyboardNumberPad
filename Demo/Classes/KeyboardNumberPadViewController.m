//
//  KeyboardNumberPadViewController.m
//  KeyboardNumberPad
//
//  Created by Vinogradov Sergey on 11.06.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "KeyboardNumberPadViewController.h"
#import "AMTextFieldNumberPad.h"

@implementation KeyboardNumberPadViewController

#pragma mark -
#pragma mark Initializate

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Вызов из Interface Builder
	[textField setButtonIcon:ButtonIconKeyboard];
	
	// Прозрачная клавиатура с UIReturnKeyGo
	AMTextFieldNumberPad *textField2 = [[AMTextFieldNumberPad alloc] initWithFrame:CGRectMake(20.00f, 70.00f, 280.00f, 31.00f)];
	[textField2 setBorderStyle:UITextBorderStyleRoundedRect];
	[textField2 setKeyboardType:UIKeyboardTypeNumberPad];
	[textField2 setReturnKeyType:UIReturnKeyGo];
	[textField2 setKeyboardAppearance:UIKeyboardAppearanceAlert];
	[textField2 setPlaceholder:@"Прозрачная с UIReturnKeyGo"];
	[self.view addSubview:textField2];
	[textField2 release];
	
	// Обычная клавиатура с иконкой клавиатуры
	AMTextFieldNumberPad *textField3 = [[AMTextFieldNumberPad alloc] initWithFrame:CGRectMake(20.00f, 120.00f, 280.00f, 31.00f)];
	[textField3 setBorderStyle:UITextBorderStyleRoundedRect];
	[textField3 setKeyboardType:UIKeyboardTypeNumberPad];
	[textField3 setKeyboardAppearance:UIKeyboardAppearanceDefault];
	[textField3 setButtonIcon:ButtonIconKeyboard];
	[textField3 setPlaceholder:@"Обычная с иконкой клавиатуры"];
	[self.view addSubview:textField3];
	[textField3 release];
	 
	// Прозрачная клавиатура с иконкой клавиатуры
	AMTextFieldNumberPad *textField4 = [[AMTextFieldNumberPad alloc] initWithFrame:CGRectMake(20.00f, 170.00f, 280.00f, 31.00f)];
	[textField4 setBorderStyle:UITextBorderStyleRoundedRect];
	[textField4 setKeyboardType:UIKeyboardTypeNumberPad];
	[textField4 setKeyboardAppearance:UIKeyboardAppearanceAlert];
	[textField4 setButtonIcon:ButtonIconKeyboard];
	[textField4 setPlaceholder:@"Прозрачная с иконкой клавиатуры"];
	[self.view addSubview:textField4];
	[textField4 release];
	
	// Обычная клавиатура с кастомной иконкой
	AMTextFieldNumberPad *textField5 = [[AMTextFieldNumberPad alloc] initWithFrame:CGRectMake(20.00f, 220.00f, 280.00f, 31.00f)];
	[textField5 setBorderStyle:UITextBorderStyleRoundedRect];
	[textField5 setKeyboardType:UIKeyboardTypeNumberPad];
	[textField5 setKeyboardAppearance:UIKeyboardAppearanceDefault];
	[textField5 setButtonImage:[UIImage imageNamed:@"heart.png"]];
	[textField5 setPlaceholder:@"Обычная с кастомной иконкой"];
	[self.view addSubview:textField5];
	[textField5 release];
	
	// Обычная клавиатура с текстом HABRAHABR
	AMTextFieldNumberPad *textField6 = [[AMTextFieldNumberPad alloc] initWithFrame:CGRectMake(20.00f, 270.00f, 280.00f, 31.00f)];
	[textField6 setBorderStyle:UITextBorderStyleRoundedRect];
	[textField6 setKeyboardType:UIKeyboardTypeNumberPad];
	[textField6 setButtonText:@"HABRAHABR"];
	[textField6 setPlaceholder:@"Обычная c текстом"];
	[self.view addSubview:textField6];
	[textField6 release];
}

#pragma mark -
#pragma mark Other

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
	[textField release];
    [super dealloc];
}

@end