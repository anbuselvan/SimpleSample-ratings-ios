//
//  MovieDetailsViewController.m
//  SimpleSample-ratings-ios
//
//  Created by Ruslan on 9/11/12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "Movie.h"
#import "DataManager.h"


@interface MovieDetailsViewController ()

@end

@implementation MovieDetailsViewController
@synthesize ratingButton;
@synthesize movie;
@synthesize detailsText;
@synthesize movieImageView;
@synthesize alertRatingView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = movie.movieName;

    [self.detailsText setText:[movie movieDetails]];
    [self.movieImageView setImage:[UIImage imageNamed:[movie movieImage]]];
    
    self.ratingView = [[[RateView alloc] initWithFrameBig:CGRectMake(40, 328, 240, 40)] autorelease];
    self.ratingView.alignment = RateViewAlignmentLeft;
    self.ratingView.editable = NO;
    self.ratingView.rate = [movie rating];
    [self.view addSubview:self.ratingView];
    
    self.alertRatingView = [[[RateView alloc] initWithFrameBig:CGRectMake(20, 80, 240, 30)] autorelease];
    self.alertRatingView.alignment = RateViewAlignmentLeft;
    self.alertRatingView.editable = YES;
    self.alertRatingView.delegate = self;
}

- (void)viewDidUnload
{
    [self setDetailsText:nil];
    [self setMovieImageView:nil];
    [self setRatingButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [detailsText release];
    [ratingButton release];
    [alertRatingView release];
    [super dealloc];
}

- (IBAction)rate:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Ratings" message:@"Rate this film\n\n\n" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert addSubview:self.alertRatingView];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{ 
    QBRScore *score = [QBRScore score];
    score.gameModeID = [movie gameModeID];
    score.value = alertRatingView.rate;
    [QBRatings createScore:score delegate:nil];
}

@end