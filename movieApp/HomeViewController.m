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

#pragma mark - Life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
   
    
    if(fromSearch){
        
        [self handleResponse:self.searchDictionary];
        self.searchView.hidden = YES;
        self.title = self.vcTitle;
        
        
    }else{
        
        [self loadDataWithPageNumber:@"1" withHUD:YES];
        
    }
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    UIBarButtonItem * sortButton = [[UIBarButtonItem alloc]initWithImage:[ UIImage imageNamed:@"sort" ] style:UIBarButtonItemStylePlain target:self action:@selector(sortMovie)];
    
    [self.navigationItem setRightBarButtonItem:sortButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - CollectionView Data Source

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

#pragma mark - CollectionView Delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MovieDB * movie = [movieArray objectAtIndex:indexPath.row];
    
    movieDetailViewController * movieVC = [self.storyboard instantiateViewControllerWithIdentifier:@"movieDetailViewController"];
    movieVC.movie = movie;
    
    
    [self.navigationController pushViewController:movieVC animated:YES];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect rect = self.view.frame;
    return CGSizeMake(rect.size.width/320 * 131, rect.size.height/504 * 167);
}

#pragma mark - Button Click

- (IBAction)searchClicked:(UIButton *)sender {
    
    [self.parameterDictionary setValue:self.searchTextField.text forKey:@"query"];
    [self.webServiceHelper callGetDataWithMethod:@"search/movie" withParameters:self.parameterDictionary withHud:YES success:^(id response) {
        
        //[self handleResponse:response];
        HomeViewController * searchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        searchViewController.searchDictionary = response;
        searchViewController.fromSearch = YES;
        searchViewController.vcTitle = self.searchTextField.text;
        [self.navigationController pushViewController:searchViewController animated:YES];
        
    } errorBlock:^(id error) {
        
    } withHeader:nil];
    
}


#pragma mark - webservice helper methods
// handles webservice response.

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
        
        
    }
    
    NSSortDescriptor* sortPastByDate = [NSSortDescriptor sortDescriptorWithKey:@"vote_average" ascending:FALSE];
    [movieArray sortUsingDescriptors:[NSArray arrayWithObject:sortPastByDate]];
    
    
    [self.collectionView reloadData];
    
    
    
}

-(void)loadDataWithPageNumber : (NSString *) page withHUD : (BOOL) showHUD{
    
    [self.parameterDictionary setValue:page forKey:@"page"];
    
    [self.webServiceHelper callGetDataWithMethod:@"movie/popular" withParameters:self.parameterDictionary withHud:showHUD success:^(id response) {
        
        //NSDictionary * dictResponse = (NSDictionary *)response;
        [self handleResponse:response];
        
    } errorBlock:^(id error) {
        
    } withHeader:nil];
}

-(void)sortMovie{
    
}


@end
