//
//  AMTextFieldNumberPad.m
//  KeyboardNumberPad
//
//  Created by Vinogradov Sergey on 13.06.11.
//  Copyright 2011 AppMake.Ru. All rights reserved.
//

#import "AMTextFieldNumberPad.h"

@interface AMTextFieldNumberPad (Private)
- (void)setup;
- (id)getKeyboardWindow;
- (void)checkKeyboardButton;
- (void)removeKeyboardButton;
- (void)changeButtonParams;
- (void)orientationDidChange:(NSNotification *)theNotification;
@end

@implementation AMTextFieldNumberPad

@synthesize buttonText, buttonImage, buttonIcon;

#pragma mark -
#pragma mark Initializate

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		[self setup];
	}
	return self;
}

- (id)init {
	if ((self = [super init])) {
		[self setup];
	}
	return self;
}

- (void)awakeFromNib {
	[self setup];
}

- (void)setup {
	
	// Регистрируем события изменения состояния клавиатуры, UITextField и изменения ориентации экрана
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
	
	[self orientationDidChange:nil];
	
	buttonIcon = ButtonIconNone;
}

#pragma mark -
#pragma mark Actions

- (void)actionKeyboardHide:(UIButton *)sender {
	[self resignFirstResponder];
	if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldShouldReturn:)])
		[self.delegate performSelector:@selector(textFieldShouldReturn:) withObject:self];
}

#pragma mark -
#pragma mark Setters

- (void)setButtonText:(NSString *)theButtonText {
	[theButtonText retain];
	[buttonText release];
	buttonText = theButtonText;
	buttonIcon = ButtonIconNone;
}

- (void)setButtonImage:(UIImage *)theButtonImage {
	[theButtonImage retain];
	[buttonImage release];
	buttonImage = theButtonImage;
	buttonIcon = ButtonIconCustom;
}

- (void)setButtonIcon:(ButtonIcon)theButtonIcon {
	buttonIcon = theButtonIcon;
}

#pragma mark -
#pragma mark Methods

- (id)getKeyboardWindow {
	UIWindow *windowTemp = nil;
	for (UIWindow *w in [[UIApplication sharedApplication] windows]) {
		if ([NSStringFromClass([w class]) isEqualToString:@"UITextEffectsWindow"]) {
			windowTemp = w;
			break;
		}
	}
	return windowTemp;
}

- (void)checkKeyboardButton {
	
	// Пробуем найти нужное окно
	id windowTemp = [self getKeyboardWindow];
	
	// Если нужное окно найдено
	if (windowTemp) {
		
		// Пробуем удалить кнопку (мы ее могли создать раньше, в этом или другом UITextField)
		for (UIView *v in [windowTemp subviews]) {
			if ([v isKindOfClass:[UIButton class]]) {
				[v setHidden:FALSE];
				buttonDone = [(UIButton *)v retain];
				[buttonDone removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
			}
		}
		
		// Создаем кнопку если она еще не создана
		if (!buttonDone) {
			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
			[button setAdjustsImageWhenHighlighted:NO];
			[[button titleLabel] setLineBreakMode:UILineBreakModeWordWrap];
			[[button titleLabel] setNumberOfLines:0];
			[[button titleLabel] setTextAlignment:UITextAlignmentCenter];
			[button retain];
			[windowTemp addSubview:button];
			
			buttonDone = button;
			[button release];
		}
		
		// Устанавливаем позицию кнопки
		[self changeButtonParams];
		
		// Добавляем событие
		[buttonDone addTarget:self action:@selector(actionKeyboardHide:) forControlEvents:UIControlEventTouchUpInside];
		
		// Если клавиатура обычная (UIKeyboardAppearanceDefault)
		if (self.keyboardAppearance == UIKeyboardAppearanceDefault) {
			if ([[[UIDevice currentDevice] systemVersion] hasPrefix:@"3"]) { 
				[buttonDone setBackgroundImage:[UIImage imageNamed:@"AMTextFieldNumberPad.bundle/button_keyboard3.png"] forState:UIControlStateNormal]; 
				[buttonDone setBackgroundImage:[UIImage imageNamed:@"AMTextFieldNumberPad.bundle/button_keyboard3_highlighted.png"] forState:UIControlStateHighlighted]; 
			} 
			else { 
				[buttonDone setBackgroundImage:[UIImage imageNamed:@"AMTextFieldNumberPad.bundle/button_keyboard4.png"] forState:UIControlStateNormal]; 
				[buttonDone setBackgroundImage:[UIImage imageNamed:@"AMTextFieldNumberPad.bundle/button_keyboard4_highlighted.png"] forState:UIControlStateHighlighted];
			}
		}
		// Если клавиатура прозрачная (UIKeyboardAppearanceAlert)
		else {
			if ([[[UIDevice currentDevice] systemVersion] hasPrefix:@"3"]) { 
				[buttonDone setBackgroundImage:[UIImage imageNamed:@"AMTextFieldNumberPad.bundle/button_keyboard3_transparent.png"] forState:UIControlStateNormal]; 
				[buttonDone setBackgroundImage:[UIImage imageNamed:@"AMTextFieldNumberPad.bundle/button_keyboard3_transparent_highlighted.png"] forState:UIControlStateHighlighted]; 
			} 
			else { 
				[buttonDone setBackgroundImage:[UIImage imageNamed:@"AMTextFieldNumberPad.bundle/button_keyboard4_transparent.png"] forState:UIControlStateNormal]; 
				[buttonDone setBackgroundImage:[UIImage imageNamed:@"AMTextFieldNumberPad.bundle/button_keyboard4_transparent_highlighted.png"] forState:UIControlStateHighlighted];
			}
		}
		
		// Добавляем текст если он есть
		if (buttonIcon == ButtonIconNone) {
			
			if (self.keyboardAppearance == UIKeyboardAppearanceDefault) {
				[buttonDone setTitleColor:[UIColor colorWithRed:71.0/255.0 green:78.0/255.0 blue:91.0/255.0 alpha:1.0] forState:UIControlStateNormal];
				[buttonDone setTitleColor:[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1.0] forState:UIControlStateHighlighted];
				[buttonDone setTitleShadowColor:[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.5] forState:UIControlStateNormal];
				[buttonDone setTitleShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5] forState:UIControlStateHighlighted];
				[[buttonDone titleLabel] setShadowOffset:CGSizeMake(0.00f, 1.00f)];
			}
			else {
				[buttonDone setTitleColor:[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1.0] forState:UIControlStateNormal];
				[buttonDone setTitleColor:[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1.0] forState:UIControlStateHighlighted];
				[buttonDone setTitleShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5] forState:UIControlStateNormal];
				[buttonDone setTitleShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5] forState:UIControlStateHighlighted];
				[[buttonDone titleLabel] setShadowOffset:CGSizeMake(0.00f, -1.00f)];
			}
			
			[buttonDone setImage:nil forState:UIControlStateNormal];
			[buttonDone setImage:nil forState:UIControlStateHighlighted];
			[[buttonDone titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
			[buttonDone setReversesTitleShadowWhenHighlighted:TRUE];
			
			// Если текст уже определен
			if (buttonText)
				[buttonDone setTitle:buttonText forState:UIControlStateNormal];
			// Пытаемся подобрать текст из UIReturnKeyType
			else {
				NSString *title = nil;
				if (self.returnKeyType == UIReturnKeyDone)
					title = @"DONE";
				else if (self.returnKeyType == UIReturnKeyEmergencyCall)
					title = @"EMERGENCY CALL";
				else if (self.returnKeyType == UIReturnKeyGo)
					title = @"GO";
				else if (self.returnKeyType == UIReturnKeyGoogle)
					title = @"GOOGLE";
				else if (self.returnKeyType == UIReturnKeyJoin)
					title = @"JOIN";
				else if (self.returnKeyType == UIReturnKeyNext)
					title = @"NEXT";
				else if (self.returnKeyType == UIReturnKeyRoute)
					title = @"ROUTE";
				else if (self.returnKeyType == UIReturnKeySearch)
					title = @"SEARCH";
				else if (self.returnKeyType == UIReturnKeySend)
					title = @"SEND";
				else if (self.returnKeyType == UIReturnKeyYahoo)
					title = @"YAHOO";
				else
					title = @"RETURN";
				[buttonDone setTitle:NSLocalizedString(title, @"") forState:UIControlStateNormal];
			}
		}
		else if (buttonIcon == ButtonIconKeyboard) {
			[buttonDone setTitle:@"" forState:UIControlStateNormal];
			[buttonDone setImage:[UIImage imageNamed:((self.keyboardAppearance == UIKeyboardAppearanceDefault) ? @"AMTextFieldNumberPad.bundle/button_keyboard_icon.png" : @"AMTextFieldNumberPad.bundle/button_keyboard_icon_transparent.png")] forState:UIControlStateNormal];
			[buttonDone setImage:[UIImage imageNamed:((self.keyboardAppearance == UIKeyboardAppearanceDefault) ? @"AMTextFieldNumberPad.bundle/button_keyboard_icon_highlighted.png" : @"AMTextFieldNumberPad.bundle/button_keyboard_icon_transparent_highlighted.png")] forState:UIControlStateHighlighted];
		}
		else if (buttonIcon == ButtonIconCustom && buttonImage) {
			[buttonDone setTitle:@"" forState:UIControlStateNormal];
			[buttonDone setImage:buttonImage forState:UIControlStateNormal];
			[buttonDone setImage:nil forState:UIControlStateHighlighted];
		}
	}
}

- (void)removeKeyboardButton {
	
	// Пробуем найти нужное окно
	id windowTemp = [self getKeyboardWindow];
	
	// Если нужное окно найдено
	if (windowTemp) {
		
		// Пробуем удалить кнопку
		for (UIView *v in [windowTemp subviews]) {
			if ([v isKindOfClass:[UIButton class]]) {
				[v setHidden:TRUE];
			}
		}
	}
}

- (void)changeButtonParams {
	if (self.editing) {
		[buttonDone setFrame:buttonRectShow];
	}
}

#pragma mark -
#pragma mark Notifications

- (void)orientationDidChange:(NSNotification *)theNotification {
	
	isRotating = TRUE;
    
    NSUInteger orientation = [UIDevice currentDevice].orientation;
    
    if (!UIDeviceOrientationIsValidInterfaceOrientation(orientation)) {
        isPortrait = YES;
    }
    else {
        isPortrait = UIDeviceOrientationIsPortrait(orientation);
    }

	buttonRectShow = (isPortrait) ? CGRectMake(0.00f, 427.00f, 105.00f, 53.00f) : CGRectMake(0.00f, 281.00f, 158.00f, 39.00f);
	buttonRectHide = (isPortrait) ? CGRectMake(0.00f, 644.00f, 105.00f, 53.00f) : CGRectMake(0.00f, 443.00f, 158.00f, 39.00f);
	
	[self changeButtonParams];
}

- (void)didBeginEditing:(NSNotification *)theNotification {
	if (self.editing) {
		if (self.keyboardType == UIKeyboardTypeNumberPad)
			[self checkKeyboardButton];
		else
			[buttonDone setHidden:TRUE];
	}
	
}

- (void)didEndEditing:(NSNotification *)theNotification {
	if (!self.editing) {
		[self removeKeyboardButton];
	}
}

- (void)keyboardWillShow:(NSNotification *)theNotification { 
	
	isRotating = FALSE;
	
	if (!self.editing || self.keyboardType != UIKeyboardTypeNumberPad || isKeyboardShow) {
		return;
	}
	
	// Получаем нужное окно
	UIWindow *windowTemp = [self getKeyboardWindow];
	
	// Проверяем, создана ли кнопка
	[self checkKeyboardButton];
	
	// Если нужное окно найдено и кнопка существует
	if (windowTemp && buttonDone) {
		
		// Включаем отображение кнопки (на тот случай если была выключена)
		[buttonDone setHidden:FALSE];
		
		// Тянем кнопку вверх вместе с клавиатурой
		[buttonDone setFrame:buttonRectHide];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		[buttonDone setFrame:buttonRectShow];
		[UIView commitAnimations];
	}
}

- (void)keyboardWillHide:(NSNotification *)theNotification {
	
	if (!self.editing || isRotating) {
		return;
	}
	
	// Получаем нужное окн
	UIWindow *windowTemp = [self getKeyboardWindow];
	
	// Проверяем, создана ли кнопка
	[self checkKeyboardButton];
	
	// Если нужное окно найдено и кнопка существует
	if (windowTemp && buttonDone) {
		
		// Тянем кнопку вниз вместе с клавиатурой
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(buttonAnimationHide)];
		[buttonDone setFrame:buttonRectHide];
		[UIView commitAnimations];
	}
}

- (void)buttonAnimationHide {
	isKeyboardShow = FALSE;
	[buttonDone setHidden:TRUE];
}

#pragma mark -
#pragma mark Memory managment

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[buttonDone release];
	[buttonText release];
	[buttonImage release];
	[super dealloc];
}

@end