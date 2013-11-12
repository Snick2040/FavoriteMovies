//
//  MoviesInTheater.h
//  FavoriteMovies
//
//  Created by Nick on 11/8/13.
//  Copyright (c) 2013 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoviesInTheater : NSObject{}

@property(nonatomic,retain) NSArray * arrayOfMovies;

+(MoviesInTheater *)getInstance;
+(void)reloadData;
+(BOOL)isFavorite:(NSDictionary *)thisMovie;
+(void)addFavorite:(NSDictionary *)thisMovie;
+(void)removeFavorite:(NSDictionary *)thisMovie;

@end
