//
//  BaseViewController.h
//  NeoSTORE
//
//  Created by Manish S. Malviya on 03/11/16.
//  Copyright © 2016 Webwerks. All rights reserved.
//

/*
 How to use : Make your view controller import and implement BaseViewController 
 */

#import <UIKit/UIKit.h>
#import "WebServiceHelper.h"
#import "Constants.h"

@interface BaseViewController : UIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate>


@property(nonatomic , assign) NSTimeInterval keyboard_duration;
@property(nonatomic , assign) UIViewAnimationCurve keyboard_curve;

@property (nonatomic,retain)UILabel *titleLabel;
@property CGPoint touchPoint;

@property (strong,nonatomic) NSNotification * keyboardNotification;
@property (strong,nonatomic) WebServiceHelper * webServiceHelper;

@property NSUInteger i;
@property NSUInteger prevY ;
@property BOOL keyboardDisplaying;
@property CGRect keyboardRect;
@property CGPoint tfRect;

@property NSUInteger kboardheight;
@property BOOL hasScrolledToTop;
@property CGPoint touchP;

@property NSMutableDictionary * parameterDictionary;

- (BOOL)connected;
-(void)showAlert:(NSString*)message withTitle:(NSString *) title;
//-(CGFloat)heightForText:(NSString *)text;
@end
