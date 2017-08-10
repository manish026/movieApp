//
//  ContentTutViewController.h
//  movieApp
//
//  Created by Manish on 10/08/17.
//  Copyright © 2017 Manish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentTutViewController : UIPageViewController

@property NSUInteger pageIndex;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tutImageView;

@end
