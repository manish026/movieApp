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




@interface BaseViewController (){
    
}

@end

@implementation BaseViewController

@synthesize keyboardRect,keyboardDisplaying,i,prevY,tfRect,kboardheight,hasScrolledToTop,touchP,webServiceHelper;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initValues]; // initializes to default values

    
    // notification for keyboard appear
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    // gesture recognizer to get textedit y position.
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapRecognizer.delegate = self;
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
    
    [self loopThroughTextFieldsWithView:self.view]; // set delegate to self for all textfields.
    
    self.keyboardNotification = [NSNotification notificationWithName:@"" object:nil];
    
}

-(void)initValues{
    i=11;
    keyboardDisplaying = NO;
    prevY = 0;
    self.keyboard_duration = 0.25;
    self.keyboard_curve = 7;
    webServiceHelper = [WebServiceHelper sharedInstance];
    self.parameterDictionary = [NSMutableDictionary new];
    [self.parameterDictionary setValue:API_KEY forKey:@"api_key"];
}










-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardChangedStatus:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardChangedStatus:) name:UIKeyboardWillHideNotification object:nil];
    
   
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [nc removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
        
        
    }
}


//loop through subviews to find textFields
-(void) loopThroughTextFieldsWithView :(UIView *)v {
    for (id obj in [v subviews]) {
        if ([obj isKindOfClass:[UISearchBar class]]){
            
        }else
            if([obj isKindOfClass:[UITextField class]]){
                UITextField *textField = (UITextField *)obj;
                textField.alpha=1;
                
                textField.delegate = self;
                textField.tag = i;
                i++;
            }else
                
                if([obj isKindOfClass:[UIScrollView class]]){
                    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
                    tapRecognizer.delegate = self;
                    tapRecognizer.cancelsTouchesInView = NO;
                    [(UIScrollView *)obj addGestureRecognizer:tapRecognizer];
                    [self loopThroughTextFieldsWithView:(UIScrollView *)obj];
                }else
                    
                    if([obj isKindOfClass:[UIView class]]){
                        
                        [self loopThroughTextFieldsWithView:(UIView *)obj];
                    }
        
        
        
    }
}








#pragma mark keyboard delegates


- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = aNotification.userInfo;
    
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    self.keyboard_duration = animationDuration;
    self.keyboardNotification = aNotification;
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    self.keyboard_curve = animationCurve;
    
}

#pragma mark textField delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    prevY = touchP.y;
    keyboardDisplaying = YES;
    touchP = CGPointMake(0, 0);
    [textField resignFirstResponder];
    if(textField.tag!=i){
        UIResponder* nextResponder = [self.view viewWithTag:textField.tag+1];
        if (nextResponder) {
            [nextResponder becomeFirstResponder];
        }
        
    }
    
    return YES;
}



- (void)textFieldDidBeginEditing:(UITextField *)textField

{
    
    tfRect = [textField convertPoint:textField.bounds.origin toView:[UIApplication sharedApplication].keyWindow];
    
    if(keyboardDisplaying == YES){
        [self moveView:self.keyboardNotification keyboardHeight:keyboardRect];
        touchP.y = tfRect.y+textField.frame.size.height;
    }
    
    
}





#pragma mark gesture delegates

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([touch.view isKindOfClass:[UITextField class]]){
        
        touchP = [touch locationInView:self.view ];
        touchP.y = touchP.y+10;
    }
    
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return YES;
    }
    else
    {
        return YES;
    }
    
}



-(void)handleSingleTap:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
    CGPoint location = [tap locationInView:self.view];
    _touchPoint = location;
    
    
}

#pragma mark keyboard delegate

- (void)keyboardChangedStatus:(NSNotification*)notification {
    //get the size!
    
    [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardRect];
    
    
    kboardheight = keyboardRect.size.height;
    //move your view to the top, to display the textfield..
    self.keyboardNotification = notification;
    [self moveView:notification keyboardHeight:keyboardRect];
}

#pragma mark View Moving

- (void)moveView:(NSNotification *) notification keyboardHeight:(CGRect)keyRect{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGRect rect = self.view.frame;
    
    if(touchP.y==0){
        touchP = tfRect;
    }
    
    if ([[notification name] isEqual:UIKeyboardWillHideNotification]&&hasScrolledToTop) {
        
        rect.origin.y=0;
        hasScrolledToTop = NO;
        
    }
    else {
        if(touchP.y>keyRect.origin.y-19 ){
            rect.origin.y = -(-keyRect.origin.y+30 +touchP.y);
            hasScrolledToTop = YES;
           
        }
    }
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
    
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


#pragma mark - Flexible height for UILabel

-(CGFloat)heightForText:(NSString *)text
{
    NSInteger MAX_HEIGHT = 2000;
    UITextView * textView = [[UITextView alloc] initWithFrame: CGRectMake(0, 0,self.view.frame.size.width-40, MAX_HEIGHT)];
    textView.text = text;
    
    [textView sizeToFit];
    return textView.frame.size.height;
}

#pragma mark - Check Internet

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    BOOL connectionStatus = networkStatus != NotReachable;
    if(!connectionStatus){
        [self showAlert:NSLocalizedString(@"no_internet_message", @"no internet message") withTitle:NSLocalizedString(@"no_internet_title", @"No Internet.")];
    }
    return connectionStatus;
}

-(void)showAlert:(NSString*)message withTitle:(NSString *) title{
    
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:title
                                message:message
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction
                                    actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}


@end
