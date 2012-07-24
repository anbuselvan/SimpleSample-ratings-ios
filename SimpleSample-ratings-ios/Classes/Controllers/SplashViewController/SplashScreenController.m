//
//  SplashScreenController.m
//  QuickQuiz
//
//  Created by kirill on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SplashScreenController.h"
#import "DataManager.h"
@interface SplashScreenController ()

@end

@implementation SplashScreenController
@synthesize activityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        parser = [[XMLParser alloc] init];
    }
    return self;
}

-(void)hideSplashScreen{
    [self dismissModalViewControllerAnimated:YES];
    [activityIndicator stopAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [activityIndicator startAnimating];  
    
    // QuickBlox application authorization
    QBASessionCreationRequest *extendedAuthRequest = [[QBASessionCreationRequest alloc] init];
    extendedAuthRequest.userLogin = @"iostest";
    extendedAuthRequest.userPassword = @"iostest2";
    
    [QBAuth createSessionWithExtendedRequest:extendedAuthRequest delegate:self];
    
    [extendedAuthRequest release];
}


#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox API queries delegate
-(void)completedWithResult:(Result*)result{
    
    // QuickBlox application authorization result
    if([result isKindOfClass:[QBAAuthSessionCreationResult class]]){
        
        // Success result
        if(result.success){
            // Hide splash & show main controller
            [self performSelector:@selector(hideSplashScreen) withObject:self afterDelay:2];
            
            // Parse XML with questions
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"quizData" ofType:@"xml"]; 
            [parser parseQuestionsFromPath:filePath];
            
            // Save parsed data
            [[DataManager instance] saveParsedData:parser.quizQuestions];
            [parser release];
        }
    }
}

- (void)viewDidUnload
{
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [activityIndicator release];
    [super dealloc];
}
@end
