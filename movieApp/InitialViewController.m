//
//  ViewController.m
//  movieApp
//
//  Created by Manish on 10/08/17.
//  Copyright © 2017 Manish. All rights reserved.
//

#import "InitialViewController.h"
#import "ContentTutViewController.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showTutorial];    // displays the tutorial view
    
    
    }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - showTutorial


-(void)showTutorial{
    
    self.tutorialPageViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tutorialPageVC"];
    
    
    self.tutorialPageViewController.view.frame = self.pageViewContainer.frame;
    
    [self.pageViewContainer addSubview:self.tutorialPageViewController.view];
    [self addChildViewController:self.tutorialPageViewController];

    
}



@end
