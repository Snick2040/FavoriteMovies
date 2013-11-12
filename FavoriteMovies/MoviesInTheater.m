#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define kRottenTomatoesInTheaters @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=6r4jcc55zebmvpjyuzh8hhg2&page_limit=50"
#import "MoviesInTheater.h"

@implementation MoviesInTheater

+ (MoviesInTheater *)getInstance
{
    static MoviesInTheater *thisInstance = nil;
    
    if(nil == thisInstance){
        thisInstance = [[[self class] alloc] init];
    }
    return thisInstance;
}

+ (void)reloadData{
    static MoviesInTheater *thisInstance = nil;
    thisInstance = [[[self class] alloc] init];
}

+(BOOL)isFavorite:(NSDictionary *)thisMovie
{
    //NSLog(@"dataCache checked");
    NSMutableArray * favoriteList;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    favoriteList = [[defaults objectForKey:@"FAVORITE_LIST"] mutableCopy];
    if (!favoriteList) favoriteList = [NSMutableArray array];
    
    for( NSString * thisFavorite in favoriteList){
        if([thisFavorite isEqualToString:[thisMovie objectForKey:@"title"]])
        {
            return true;
        }
    }
    return false;
        
        //[defaults setObject:recentScores forKey:@"FAVORITE_LIST"];
        //[defaults synchronize];
}
    
+(void)addFavorite:(NSDictionary *)thisMovie
{
    //NSLog(@"dataCache added");
    NSMutableArray * favoriteList;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    favoriteList = [[defaults objectForKey:@"FAVORITE_LIST"] mutableCopy];
    if (!favoriteList) favoriteList = [NSMutableArray array];
    
    [favoriteList addObject:[thisMovie objectForKey:@"title"]];
    
    [defaults setObject:favoriteList forKey:@"FAVORITE_LIST"];
    [defaults synchronize];
}

+(void)removeFavorite:(NSDictionary *)thisMovie
{
    //NSLog(@"dataCache remove");
    NSMutableArray * favoriteList;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    favoriteList = [[defaults objectForKey:@"FAVORITE_LIST"] mutableCopy];
    if (!favoriteList) favoriteList = [NSMutableArray array];
    
    for( NSString * thisFavorite in favoriteList){
        if([thisFavorite isEqualToString:[thisMovie objectForKey:@"title"]])
        {
            [favoriteList removeObject:thisFavorite];
            [defaults setObject:favoriteList forKey:@"FAVORITE_LIST"];
            [defaults synchronize];
            break;
        }
    }
}

-(id) init{
    if (self=[super init]){
        [self loadRTData];
    }
    return self;
}

- (void)loadRTData
{
    
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
        //NSLog(@"URLS: %@", thisURL.query);
        [dataArray addObject:[NSData dataWithContentsOfURL:thisURL]];
    }
    
    NSMutableArray * parsedRottenTomatoesData = [[NSMutableArray alloc]init];
    
    //For Tesing
    //NSMutableArray * dataArray = [NSMutableArray arrayWithObject:[NSData dataWithContentsOfFile:@"/Users/nick/Desktop/in_theaters.json"]];
    
    
    //parse out the json data
    
    for( NSData * thisData in dataArray){
        
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
    _arrayOfMovies = [[NSArray alloc]initWithArray:parsedRottenTomatoesData];
}

@end
