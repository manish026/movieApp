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
    // Do any additional setup after loading the view.
    [self setData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setData{
    self.title = self.movie.title;
    [self.descriptionTitleLabel setText:NSLocalizedString(@"desciption_Title", @"title for description")];
    self.movieTitleLabel.text = self.movie.original_title;
    [self.rateView setStarFillColor:movieBlueColor];
    [self.rateView setStarSize:self.view.frame.size.width/414*30];
    [self.rateView setRating:[_movie.vote_average floatValue]/2.0];
    NSString * imageurl = [NSString stringWithFormat:@"%@%@",posterBaseUrl,self.movie.poster_path];
    [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:imageurl]];
    [self.descriptionTextView setText:self.movie.overview];
    [self.releaseLabel setText:[NSString stringWithFormat:@"%@ : %@",NSLocalizedString(@"release_Title", @"release title"),_movie.release_date]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
