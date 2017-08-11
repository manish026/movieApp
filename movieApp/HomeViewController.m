//
//  HomeViewController.m
//  movieApp
//
//  Created by Manish on 11/08/17.
//  Copyright © 2017 Manish. All rights reserved.
//

#import "HomeViewController.h"
#import "movieCollectionViewCell.h"
#import "MovieDB.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize movieArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.parameterDictionary setValue:@"1" forKey:@"page"];
    
    [self.webServiceHelper callGetDataWithMethod:@"/popular" withParameters:self.parameterDictionary withHud:YES success:^(id response) {
        
        NSDictionary * dictResponse = (NSDictionary *)response;
        NSArray * resultArray = [dictResponse valueForKey:@"results"];
        movieArray = [NSMutableArray new];
        for(NSMutableDictionary* dict in resultArray){
            NSString * movieId = [dict valueForKey:@"id"];
            [dict removeObjectForKey:@"id"];
            [dict setObject:movieId forKey:@"movie_id"];
            MovieDB * movie = [MovieDB new];
            [movie setValuesForKeysWithDictionary:dict];
            [movieArray addObject:movie];
        }
        [self.collectionView reloadData];
        NSLog(@"%@",response);
    } errorBlock:^(id error) {
        
    } withHeader:nil];
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

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return movieArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    movieCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"movieCollectionViewCell" forIndexPath:indexPath];
    MovieDB * movie = [movieArray objectAtIndex:indexPath.row];
    cell.movieTitle.text = movie.title;
    NSString * imageurl = [NSString stringWithFormat:@"%@%@",imageBaseUrl,movie.poster_path];
    [cell.movieImageView sd_setImageWithURL:[NSURL URLWithString:imageurl]];
    return cell;
    
    
}

@end
