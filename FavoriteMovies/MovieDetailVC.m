//
//  MovieDetailVC.m
//  FavoriteMovies
//
//  Created by Nick on 11/9/13.
//  Copyright (c) 2013 Nick. All rights reserved.
//

#import "MovieDetailVC.h"
#import "MoviesInTheater.h"
#import "WebVC.h"

@interface MovieDetailVC ()
@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *tomatometerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tomatometerImg;
@property (weak, nonatomic) IBOutlet UISwitch *favSwitch;
@property (weak, nonatomic) IBOutlet UIButton *urlButton;

@end

@implementation MovieDetailVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self.movieDict objectForKey:@"imgDetailed"]]];
    self.movieImageView.image = [UIImage imageWithData:data];
    self.movieImageView.frame = CGRectMake(70, 12, 180, 257);
    //<rect key="frame" x="70" y="12" width="180" height="257"/>
    self.titleLabel.text = [self.movieDict objectForKey:@"title"];
    self.yearLabel.text = [NSString stringWithFormat:@"%@",[self.movieDict objectForKey:@"year"] ];
    self.tomatometerLabel.text = [NSString stringWithFormat:@"     %@%%",[self.movieDict objectForKey:@"rating"] ];
    
    if( ![[self.movieDict objectForKey:@"rating"] isEqualToNumber:[NSNumber numberWithInt:-1]]) {
        if ( [[self.movieDict objectForKey:@"rating"] intValue] >= 60)
        {self.tomatometerImg.image=[UIImage imageNamed:@"fresh.png"];}
        else {self.tomatometerImg.image=[UIImage imageNamed:@"rotten.png"];}
    } else {
        self.tomatometerImg.image=nil;
        self.tomatometerLabel.text = @"No Critic Rating";
    }
    
    [self.favSwitch setOn:[MoviesInTheater isFavorite:self.movieDict]];
    [self.favSwitch addTarget:self action:@selector(checkOnOffState) forControlEvents:UIControlEventValueChanged];
    [self.urlButton addTarget:self action:@selector(viewWebsite) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWebsite
{
    [self performSegueWithIdentifier:@"View Rotten Tomatoes" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"string url: %@", [self.movieDict objectForKey:@"link"]);
    NSURL * movieURL = [[NSURL alloc]initWithString:[self.movieDict objectForKey:@"link"]];
    NSLog(@"movie url: %@", movieURL);
    [segue.destinationViewController setMovieURL:movieURL];
}
     
- (void)checkOnOffState
{
    if (self.favSwitch.on) {
        [MoviesInTheater addFavorite:self.movieDict];
    } else {
        [MoviesInTheater removeFavorite:self.movieDict];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
