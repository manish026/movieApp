//
//  movieCollectionViewCell.h
//  movieApp
//
//  Created by Manish on 11/08/17.
//  Copyright © 2017 Manish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface movieCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;

@end
