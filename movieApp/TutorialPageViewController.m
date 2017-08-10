//
//  TutorialPageViewController.m
//  movieApp
//
//  Created by Manish on 10/08/17.
//  Copyright © 2017 Manish. All rights reserved.
//

#import "TutorialPageViewController.h"
#import "ContentTutViewController.h"



@interface TutorialPageViewController ()



@end

@implementation TutorialPageViewController

@synthesize tutsVCArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    self.dataSource = self;
    
    tutsVCArray = @[[self viewControllerAtIndex:0]];
    
    [self setViewControllers:tutsVCArray direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - pageController Delegate

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSUInteger index = ((ContentTutViewController *)viewController).pageIndex;
    
    if(index == 0 || index == NSNotFound){
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    NSUInteger index = ((ContentTutViewController *)viewController).pageIndex;
    
    if(index == 3 || index == NSNotFound){
        return nil;
    }
    
    index++;
    
    return [self viewControllerAtIndex:index];
}


#pragma mark - pageController Data Source

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 4;
}



#pragma mark - Helper Methods

// instatiates and returns a vc for given index

-(ContentTutViewController *)viewControllerAtIndex:(NSUInteger)index
{
    ContentTutViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"vc"];
    //vc.strImage = devices[index];
    [vc.view setBackgroundColor:[UIColor blueColor]];
    vc.pageIndex = index;
    [vc.titleLabel setText:NSLocalizedString(@"title", @"displays title")];
    [vc.tutImageView setBackgroundColor:[UIColor purpleColor] ];
    
    
    return vc;
}

@end
