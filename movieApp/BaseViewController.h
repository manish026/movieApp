//
//  BaseViewController.h
//  NeoSTORE
//
//  Created by Manish S. Malviya on 03/11/16.
//  Copyright © 2016 Webwerks. All rights reserved.
//

/*
 How to use : Make your view controller import and implement BaseViewController and to
 exclude a textview to move the view up just make its tag =1
 */

#import <UIKit/UIKit.h>



@interface BaseViewController : UIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate>


@property(nonatomic , assign) NSTimeInterval keyboard_duration;
@property(nonatomic , assign) UIViewAnimationCurve keyboard_curve;

@property (nonatomic,retain)UILabel *titleLabel;
@property CGPoint touchPoint;

@property (strong,nonatomic) NSNotification * keyboardNotification;

//-(CGFloat)heightForText:(NSString *)text;
@end
