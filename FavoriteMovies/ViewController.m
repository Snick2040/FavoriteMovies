#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define kRottenTomatoesInTheaters @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=6r4jcc55zebmvpjyuzh8hhg2&page_limit=50"
#define backGroundColor [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5]

#import "ViewController.h"
#import "MoviesInTheater.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self loadData];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.spinner startAnimating];
    //[self loadData];
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
    dispatch_async(downloadQueue, ^{
        [MoviesInTheater reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
            [self performSegueWithIdentifier:@"ToMovieLists" sender:self];
            NSLog(@"left");
        });
    });
    
}

-(void)loadData{
    
    [self.spinner startAnimating];
    self.spinner.hidden = false;
    
    dispatch_async(kBgQueue, ^{
        
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kRottenTomatoesInTheaters]];
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:&error];
        NSNumber *numberOfMovies = [json objectForKey:@"total"];
        
        NSMutableArray * dataArray = [[NSMutableArray alloc]init];
        [dataArray addObject: data];
        
        NSURL * thisURL;
        for( int i = 2; i <= numberOfMovies.intValue / 50 + 1; i++){
            thisURL = [NSURL URLWithString:[kRottenTomatoesInTheaters stringByAppendingString:[NSString stringWithFormat:@"&page=%i",i]]];
            NSLog(@"URLS: %@", thisURL.query);
            [dataArray addObject:[NSData dataWithContentsOfURL:thisURL]];
        }
        [MoviesInTheater reloadData];
        [MoviesInTheater reloadData];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:dataArray waitUntilDone:YES];
    });
}

-(void)fetchedData:(NSArray *)responseDataArray{
    NSMutableArray * parsedRottenTomatoesData = [[NSMutableArray alloc]init];
    
    //parse out the json data
    
    for( NSData * thisData in responseDataArray){
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:thisData
                              options:kNilOptions
                              error:&error];
        
        NSArray * movies = [json objectForKey:@"movies"];
        
        for(NSDictionary * movie in movies){
            NSMutableDictionary * thisMovie = [[NSMutableDictionary alloc]init];
            
            //NSLog(@"Title: %@", [movie objectForKey:@"title"]);
            [thisMovie setValue:[movie objectForKey:@"title"] forKey:@"title"];
            [thisMovie setValue:[movie objectForKey:@"year"] forKey:@"year"];
            [thisMovie setValue:[movie objectForKey:@"id"] forKey:@"id"];
            [thisMovie setValue:[[movie objectForKey:@"ratings"] objectForKey:@"critics_score"] forKey:@"rating"];
            [thisMovie setValue:[[movie objectForKey:@"links"] objectForKey:@"alternate"] forKey:@"link"];
            [thisMovie setValue:[[movie objectForKey:@"posters"] objectForKey:@"thumbnail"] forKey:@"imgThumb"];
            [thisMovie setValue:[[movie objectForKey:@"posters"] objectForKey:@"detailed"] forKey:@"imgDetailed"];
            
            [parsedRottenTomatoesData addObject:thisMovie];
        }
    }
    //NSLog(@"Data:%i/n%@",[parsedRottenTomatoesData count], [parsedRottenTomatoesData description]);
    [self.spinner stopAnimating];
    self.spinner.hidden = TRUE;
    [self performSegueWithIdentifier:@"ToMovieLists" sender:self];
}


@end
