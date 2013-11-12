//
//  FavMovieTVC.m
//  FavoriteMovies
//
//  Created by Nick on 11/10/13.
//  Copyright (c) 2013 Nick. All rights reserved.
//

#import "FavMovieTVC.h"
#import "MoviesInTheater.h"

@interface FavMovieTVC ()
@property (nonatomic, strong) NSArray *movieArray;
@property (nonatomic, strong) NSMutableDictionary *movieSortedDict;
@property (nonatomic, strong) NSMutableArray *headerArray;

@end

@implementation FavMovieTVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //NSLog(@"fav %f, %f, %f, %f", self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height);
    //NSLog(@"TVC%f, %f, %f, %f", self.view.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height);
    
    //if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    NSArray *sortDescriptors =[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    self.movieArray = [[[MoviesInTheater getInstance]arrayOfMovies] sortedArrayUsingDescriptors:sortDescriptors];
    
    self.movieSortedDict = [[NSMutableDictionary alloc]init];
    self.headerArray = [[NSMutableArray alloc]init];
    
    for ( NSDictionary * thisMovie in self.movieArray) {
        if ([MoviesInTheater isFavorite:thisMovie])
        {
            NSString * firstL = @"Favorites";
            if (![self.movieSortedDict objectForKey:firstL]){
                [self.headerArray addObject:firstL];
                NSMutableArray * thisArray = [[NSMutableArray alloc]initWithObjects:thisMovie, nil];
                [self.movieSortedDict setValue:thisArray forKey:firstL];
            }
            else {
                [[self.movieSortedDict objectForKey:firstL] addObject:thisMovie];
            }
        }
    }
    //NSLog(@"%@",[self.movieSortedDict description]);
}*/

- (void)viewWillAppear:(BOOL)animated{
    
    NSArray *sortDescriptors =[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    self.movieArray = [[[MoviesInTheater getInstance]arrayOfMovies] sortedArrayUsingDescriptors:sortDescriptors];
    
    self.movieSortedDict = [[NSMutableDictionary alloc]init];
    self.headerArray = [[NSMutableArray alloc]init];
    
    for ( NSDictionary * thisMovie in self.movieArray) {
        if ([MoviesInTheater isFavorite:thisMovie])
        {
            NSString * firstL = @"Favorites";
            if (![self.movieSortedDict objectForKey:firstL]){
                [self.headerArray addObject:firstL];
                NSMutableArray * thisArray = [[NSMutableArray alloc]initWithObjects:thisMovie, nil];
                [self.movieSortedDict setValue:thisArray forKey:firstL];
            }
            else {
                [[self.movieSortedDict objectForKey:firstL] addObject:thisMovie];
            }
        }
    }
    [self.tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
