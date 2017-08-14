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

@synthesize movieArray,fromSearch,page;

#pragma mark - Life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
   
    page = 1;
    
    if(fromSearch){
        
        [self handleResponse:self.searchDictionary];
        self.searchView.hidden = YES;
        self.title = self.vcTitle;
        self.sortView.hidden = YES;
        
    }else{
        
        [self loadDataWithPage];
        
    }
    
    [self registerForPreviewingWithDelegate:self sourceView:self.collectionView];  // registers to 3d touch.
    
    
}





#pragma mark - 3DTouch delegates

- (UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    movieDetailViewController * movieVC = [self.storyboard instantiateViewControllerWithIdentifier:@"movieDetailViewController"];
    
    movieVC.preferredContentSize = CGSizeMake(0.0, self.view.frame.size.height-200);
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    MovieDB * movie = [movieArray objectAtIndex:indexPath.row];
    movieVC.movie = movie;
    
    return movieVC;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    [self showViewController:viewControllerToCommit sender:self];
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
    cell.tag = indexPath.row;
    return cell;
    
    
}

#pragma mark - CollectionView Delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MovieDB * movie = [movieArray objectAtIndex:indexPath.row];
    
    movieDetailViewController * movieVC = [self.storyboard instantiateViewControllerWithIdentifier:@"movieDetailViewController"];
    movieVC.movie = movie;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.view.alpha = 0.8;
        
        
    } completion:^(BOOL finished) {
        
        movieVC.view.alpha = 0.9;

        
        [UIView animateWithDuration:0.5 animations:^{
            
            [self.view addSubview:movieVC.view];
            [self addChildViewController:movieVC];
            movieVC.view.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            
            
            [self.navigationController pushViewController:movieVC animated:NO];
            [movieVC.view removeFromSuperview];
            self.view.alpha = 1.0;
        }];
        
    }];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect rect = self.view.frame;
    return CGSizeMake(rect.size.width/320 * 131, rect.size.height/504 * 167);
}

#pragma mark - Button Click

- (IBAction)searchClicked:(UIButton *)sender {
    
    if(![self.searchTextField.text  isEqual: @""]){
    
        [self loadSearchData];
        
    }else{
        
        
    }
    
}




#pragma mark - webservice helper methods
// handles webservice response.

-(void)handleResponse : (NSDictionary *) dictResponse{
    
    NSArray * resultArray = [dictResponse valueForKey:@"results"];
    
    if(!movieArray){
        movieArray = [NSMutableArray new];
    }
    
    self.pageCount = [[dictResponse valueForKey:@"total_pages"] integerValue];
    
    for(NSMutableDictionary* dict in resultArray){
        
        // replacing id with movie_id
        NSString * movieId = [dict valueForKey:@"id"];
        [dict removeObjectForKey:@"id"];
        [dict setObject:movieId forKey:@"movie_id"];
        
        
        MovieDB * movie = [MovieDB new];
        [movie setValuesForKeysWithDictionary:dict];
        [movieArray addObject:movie];
        
        
    }
    

    
    
    [self.collectionView reloadData];
    
    
    
}




#pragma mark - ScrollView delegate


-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    NSArray * visibleCells = [self.collectionView visibleCells];
    movieCollectionViewCell * cell = [visibleCells lastObject];
    
    if(cell.tag >= [movieArray count] - 10  && page < _pageCount){
        
        if(fromSearch){
            [self loadSearchData];
        }else{
            [self loadDataWithPage];
        }
        
        
    }
    
}

#pragma mark - Segment switched

- (IBAction)popularitySegmentChanged:(UISegmentedControl *)sender {
    
    self.loadServerMethod = (sender.selectedSegmentIndex == 0)?@"movie/popular":@"movie/top_rated";
    
    movieArray = [NSMutableArray new];
    page = 1;
    [self loadDataWithPage];
}


#pragma mark - Load data methods

-(void)loadDataWithPage{
    
    if(!self.loadServerMethod || [self.loadServerMethod isEqualToString:@""]){
        self.loadServerMethod = [NSString new];
        self.loadServerMethod = @"movie/popular";
    }
    
    [self.parameterDictionary setValue:[NSString stringWithFormat:@"%lu",(unsigned long)page ] forKey:@"page"];
    
    [self.webServiceHelper callGetDataWithMethod:self.loadServerMethod withParameters:self.parameterDictionary withHud:YES success:^(id response) {
        
        //NSDictionary * dictResponse = (NSDictionary *)response;
        [self handleResponse:response];
        page++;
        
    } errorBlock:^(id error) {
        
    } withHeader:nil];
}

-(void)loadSearchData{
    
    if(fromSearch){
        page++;
        [self.parameterDictionary setValue:self.searchText forKey:@"query"];
        [self.parameterDictionary setValue:[NSString stringWithFormat:@"%lu",(unsigned long)page] forKey:@"page"];
        [self.webServiceHelper callGetDataWithMethod:@"search/movie" withParameters:self.parameterDictionary withHud:YES success:^(id response) {
            
            [self handleResponse:response];
            
            
        } errorBlock:^(id error) {
            
        } withHeader:nil];
        
    }else{
        
        [self.parameterDictionary setValue:self.searchTextField.text forKey:@"query"];
        
        
        [self.parameterDictionary removeObjectForKey:@"page"];
        [self.webServiceHelper callGetDataWithMethod:@"search/movie" withParameters:self.parameterDictionary withHud:YES success:^(id response) {
            
            //[self handleResponse:response];
            HomeViewController * searchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
            searchViewController.searchDictionary = response;
            searchViewController.fromSearch = YES;
            searchViewController.searchText = self.searchTextField.text;
            searchViewController.vcTitle = self.searchTextField.text;
            [self.navigationController pushViewController:searchViewController animated:YES];
            
        } errorBlock:^(id error) {
            
        } withHeader:nil];
        
    }
}

@end
