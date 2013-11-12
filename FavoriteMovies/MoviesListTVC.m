//
//  MoviesListTVC.m
//  FavoriteMovies
//
//  Created by Nick on 11/8/13.
//  Copyright (c) 2013 Nick. All rights reserved.
//

#import "MoviesListTVC.h"
#import "MoviesInTheater.h"
#import "MovieDetailVC.h"

@interface MoviesListTVC ()
@property (nonatomic, strong) NSArray *movieArray;
@property (nonatomic, strong) NSMutableDictionary *movieSortedDict;
@property (nonatomic, strong) NSMutableArray *headerArray;

@end

@implementation MoviesListTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //NSLog(@"%f, %f, %f, %f", self.view.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height);
    //NSLog(@"TVC%f, %f, %f, %f", self.view.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height);
    //self.movieArray = [[MoviesInTheater getInstance]arrayOfMovies];
    
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    //if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    //if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    NSArray *sortDescriptors =[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    self.movieArray = [[[MoviesInTheater getInstance]arrayOfMovies] sortedArrayUsingDescriptors:sortDescriptors];
    
    //NSLog(@"Sorted:\n%@", [self.movieArray description]);
    
    self.movieSortedDict = [[NSMutableDictionary alloc]init];
    self.headerArray = [[NSMutableArray alloc]init];
    
    for ( NSDictionary * thisMovie in self.movieArray)
    {
        NSString * firstL = [[thisMovie objectForKey:@"title"] substringToIndex:1];
        if (![self.movieSortedDict objectForKey:firstL]){
            [self.headerArray addObject:firstL];
            NSMutableArray * thisArray = [[NSMutableArray alloc]initWithObjects:thisMovie, nil];
            [self.movieSortedDict setValue:thisArray forKey:firstL];
        }
        else {
            [[self.movieSortedDict objectForKey:firstL] addObject:thisMovie];
        }
    }
    //NSLog(@"Sorted:\n%@", [self.movieSortedDict description]);
    //[self performSegueWithIdentifier:@"DisplayMovieFromAllMovies" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self.movieSortedDict allKeys] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.headerArray objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString * sectionHeader = [self.headerArray objectAtIndex:section];
    return [[self.movieSortedDict objectForKey:sectionHeader] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString * sectionHeader = [self.headerArray objectAtIndex:indexPath.section];
    
    NSDictionary * thisDict = [[self.movieSortedDict objectForKey:sectionHeader] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [thisDict objectForKey:@"title"];

    [[cell.contentView viewWithTag:123]removeFromSuperview] ;
    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(87,47, 14, 14 )];
    imv.tag = 123;
    
    if( ![[thisDict objectForKey:@"rating"] isEqualToNumber:[NSNumber numberWithInt:-1]]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"     %@%%",[thisDict objectForKey:@"rating"]];
        
        if ( [[thisDict objectForKey:@"rating"] intValue] >= 60)
            {imv.image=[UIImage imageNamed:@"fresh.png"];}
        else {imv.image=[UIImage imageNamed:@"rotten.png"];}
        
    } else {
        imv.image=nil;
        cell.detailTextLabel.text = @"No Critic Rating";
    }
    [cell.contentView addSubview:imv];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[thisDict objectForKey:@"imgThumb"]]];
    cell.imageView.image = [UIImage imageWithData:data];
    
    return cell;
}

/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString * sectionHeader = [self.headerArray objectAtIndex:indexPath.section];
    //NSDictionary * selectedMovieDict = [[self.movieSortedDict objectForKey:sectionHeader] objectAtIndex:indexPath.row];
    //NSLog(@"selected:%@", [selectedMovieDict objectForKey:@"title"]);
    [self performSegueWithIdentifier:@"DisplayMovieDetails" sender:self];
}*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DisplayMovieDetails"]) {
        NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
        NSString * sectionHeader = [self.headerArray objectAtIndex:indexPath.section];
        NSDictionary * selectedMovieDict = [[self.movieSortedDict objectForKey:sectionHeader] objectAtIndex:indexPath.row];
        //NSLog(@"selected2: %@, %@", [selectedMovieDict objectForKey:@"title"], indexPath);
        [segue.destinationViewController setMovieDict:selectedMovieDict];
    }
}

@end
