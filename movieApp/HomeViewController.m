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
#import "movieDetailViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize movieArray,fromSearch;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    if(fromSearch){
        
        [self handleResponse:self.searchDictionary];
        self.searchView.hidden = YES;
        
        
    }else{
        
        [self loadDataWithPageNumber:@"1" withHUD:YES];
        
    }
    
    
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

-(void)loadDataWithPageNumber : (NSString *) page withHUD : (BOOL) showHUD{
    
     [self.parameterDictionary setValue:page forKey:@"page"];
    
    [self.webServiceHelper callGetDataWithMethod:@"movie/popular" withParameters:self.parameterDictionary withHud:showHUD success:^(id response) {
        
        //NSDictionary * dictResponse = (NSDictionary *)response;
        [self handleResponse:response];
       
    } errorBlock:^(id error) {
        
    } withHeader:nil];
}



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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MovieDB * movie = [movieArray objectAtIndex:indexPath.row];
    
    movieDetailViewController * movieVC = [self.storyboard instantiateViewControllerWithIdentifier:@"movieDetailViewController"];
    movieVC.movie = movie;
    
    
    [self.navigationController pushViewController:movieVC animated:YES];
    
}

- (IBAction)searchClicked:(UIButton *)sender {
    
    [self.parameterDictionary setValue:self.searchTextField.text forKey:@"query"];
    [self.webServiceHelper callGetDataWithMethod:@"search/movie" withParameters:self.parameterDictionary withHud:YES success:^(id response) {
        
        //[self handleResponse:response];
        HomeViewController * searchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        searchViewController.searchDictionary = response;
        searchViewController.fromSearch = YES;
        [self.navigationController pushViewController:searchViewController animated:YES];
        
    } errorBlock:^(id error) {
        
    } withHeader:nil];
    
}

-(void)handleResponse : (NSDictionary *) dictResponse{
    
    NSArray * resultArray = [dictResponse valueForKey:@"results"];
    movieArray = [NSMutableArray new];
    
    for(NSMutableDictionary* dict in resultArray){
        
        // replacing id with movie_id
        NSString * movieId = [dict valueForKey:@"id"];
        [dict removeObjectForKey:@"id"];
        [dict setObject:movieId forKey:@"movie_id"];
        
        
        MovieDB * movie = [MovieDB new];
        [movie setValuesForKeysWithDictionary:dict];
        [movieArray addObject:movie];
        [self.collectionView reloadData];
    }
    
    
    
}
@end
