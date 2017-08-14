//
//  movieDetailViewController.h
//  movieApp
//
//  Created by Manish on 12/08/17.
//  Copyright © 2017 Manish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieDB.h"
#import <RateView.h>

//#import <HCSStarRatingView.h>

@interface movieDetailViewController : UIViewController

@property MovieDB * movie;

@property (weak, nonatomic) IBOutlet RateView *rateView;

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UILabel *releaseLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;

@end
