//
//  HomeViewController.h
//  movieApp
//
//  Created by Manish on 11/08/17.
//  Copyright © 2017 Manish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface HomeViewController : BaseViewController <UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UIViewControllerPreviewingDelegate>

@property (strong,nonatomic) NSMutableArray * movieArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property BOOL fromSearch ;
@property (strong,nonatomic) NSDictionary * searchDictionary;
- (IBAction)searchClicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic) NSString * vcTitle;
@property NSUInteger page;
@property NSUInteger pageCount;
@property (strong, nonatomic) NSString * searchText;

@end
