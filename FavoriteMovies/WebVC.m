//
//  WebVC.m
//  FavoriteMovies
//
//  Created by Nick on 11/10/13.
//  Copyright (c) 2013 Nick. All rights reserved.
//

#import "WebVC.h"

@interface WebVC ()
@property (weak, nonatomic) IBOutlet UIWebView *thisWebView;
@end

@implementation WebVC

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
    
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:self.movieURL];
    [self.thisWebView loadRequest:requestURL];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
