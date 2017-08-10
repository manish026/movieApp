//
//  TutorialPageViewController.h
//  movieApp
//
//  Created by Manish on 10/08/17.
//  Copyright © 2017 Manish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialPageViewController : UIPageViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (strong,nonatomic) NSArray * tutsVCArray;

@end
