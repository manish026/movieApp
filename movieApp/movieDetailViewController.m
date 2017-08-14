//
//  movieDetailViewController.m
//  movieApp
//
//  Created by Manish on 12/08/17.
//  Copyright © 2017 Manish. All rights reserved.
//

#import "movieDetailViewController.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"


@interface movieDetailViewController ()

@end

@implementation movieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setData];
}



-(void)setData{
    self.title = self.movie.title;
    [self.descriptionTitleLabel setText:NSLocalizedString(@"desciption_Title", @"title for description")];
    self.movieTitleLabel.text = self.movie.original_title;
    [self.rateView setStarFillColor:movieBlueColor];
    [self.rateView setStarSize:self.view.frame.size.width/414*30];
    [self.rateView setRating:[_movie.vote_average floatValue]/2.0];
    NSString * imageurl = [NSString stringWithFormat:@"%@%@",posterBaseUrl,self.movie.poster_path];
    [self.bannerImageView sd_setImageWithURL:[NSURL URLWithString:imageurl]];
    [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:imageurl]];
    [self.descriptionTextView setText:self.movie.overview];
    [self.releaseLabel setText:[NSString stringWithFormat:@"%@ : %@",NSLocalizedString(@"release_Title", @"release title"),_movie.release_date]];
}



@end
