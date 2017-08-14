//
//  Movie.h
//  movieApp
//
//  Created by Manish on 11/08/17.
//  Copyright © 2017 Manish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieDB : NSObject

@property (strong,nonatomic) NSString * overview;
@property (strong,nonatomic) NSString * popularity;
@property (strong,nonatomic) NSString * backdrop_path;
@property (strong,nonatomic) NSString * original_title;
@property (strong,nonatomic) NSString * poster_path;
@property (strong,nonatomic) NSString * title;
@property (strong,nonatomic) NSString * vote_average;
@property (strong,nonatomic) NSString * original_language;
@property (strong,nonatomic) NSString * vote_count;
@property (strong,nonatomic) NSString * movie_id;
@property (strong,nonatomic) NSString * release_date;
@property (strong,nonatomic) NSString * video;
@property (strong,nonatomic) NSArray * genre_ids;
@property BOOL adult;

@end
