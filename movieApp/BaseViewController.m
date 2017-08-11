//
//  BaseViewController.m
//  NeoSTORE
//
//  Created by Manish S. Malviya on 03/11/16.
//  Copyright © 2016 Webwerks. All rights reserved.
//
/*
 How to use : Make your view controller import and implement BaseViewController and to
 exclude a textview to move the view up just make its tag =1
 */
#import "BaseViewController.h"
#import <Canvas.h>
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.keyboard_duration = 0.25;
    self.keyboard_curve = 7;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [self loopThroughTextFieldsWithView:self.view];
    
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [UIView animateWithDuration:1.0 animations:^{
        [self animateWithView:self.view];
    }];
    
}

-(void)animateWithView:(UIView *)v{
    for (id obj in [v subviews]) {
        if([obj isKindOfClass:[UITextField class]]){
            UITextField *textField = (UITextField *)obj;
            textField.alpha=1;
            
        }
        if([obj isKindOfClass:[UIView class]]){
            
            [self animateWithView:(UIView *)obj];
        }
        if([obj isKindOfClass:[UIScrollView class]]){
            [self animateWithView:(UIScrollView *)obj];
        }
        
        if([obj isKindOfClass:[CSAnimationView class]]){
            
            [self animateWithView:(UIView *)obj];
        }
    }
}
//loop through subviews to find textFields

-(void) loopThroughTextFieldsWithView :(UIView *)v {
    for (id obj in [v subviews]) {
        if([obj isKindOfClass:[UITextField class]]){
            UITextField *textField = (UITextField *)obj;
            textField.alpha=0.3;
            if(textField.tag==1){
                
            }else
                textField.delegate = self;
        }
        
        if([obj isKindOfClass:[UIScrollView class]]){
            UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            tapRecognizer.delegate = self;
            tapRecognizer.cancelsTouchesInView = NO;
            [(UIScrollView *)obj addGestureRecognizer:tapRecognizer];
            [self loopThroughTextFieldsWithView:(UIScrollView *)obj];
        }
        
        if([obj isKindOfClass:[UIView class]]){
            
            [self loopThroughTextFieldsWithView:(UIView *)obj];
        }
        
        if([obj isKindOfClass:[CSAnimationView class]]){
            
            [self loopThroughTextFieldsWithView:(UIView *)obj];
        }
        
        
        
        
    }
}


//Move textFields when keyboard shows up

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 190; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

#pragma mark keyboard delegates


- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = aNotification.userInfo;
    
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    self.keyboard_duration = animationDuration;
    
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    self.keyboard_curve = animationCurve;
    
}

#pragma mark textField delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [self animateTextField: textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}


#pragma mark gesture delegates

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void)handleSingleTap:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
    if([tap.view isKindOfClass:[CSAnimationView class]]){
        [tap.view startCanvasAnimation];
    }
}

@end
