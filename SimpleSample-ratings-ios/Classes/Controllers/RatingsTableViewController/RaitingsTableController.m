//
//  RaitingsTableController.m
//  QuickQuiz
//
//  Created by kirill on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RaitingsTableController.h"
#import "MainViewController.h"
@interface RaitingsTableController ()

@end

@implementation RaitingsTableController
@synthesize topScores = _topScores;
@synthesize raitingsTable = _raitingsTable;
@synthesize activityIndicator = _activityIndicator;
@synthesize userQuizScore = _userQuizScore;
@synthesize userName = _userName;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_activityIndicator startAnimating];

    // Store User's score on QuickBlox
    QBRScore* userScore = [QBRScore score];
    userScore.gameModeID = GAME_MODE_ID;
    userScore.value = _userQuizScore;
    //
    [QBRatings createScore:userScore delegate:self];
}

- (void)viewDidUnload
{
    [self setRaitingsTable:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Back button action
- (IBAction)backButtonClicked:(id)sender {
    MainViewController* mainController = [[MainViewController alloc] init];
    [self presentModalViewController:mainController animated:NO];
    [mainController release];
}


#pragma mark -
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Raitings";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _topScores.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = [NSString stringWithFormat:@"%d", indexPath.row];
    
    UITableViewCell *cell = [_raitingsTable dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if (indexPath.row != 0) {
        QBRScore* scoreRecord = [_topScores objectAtIndex:indexPath.row-1];   
        UILabel* place = [[UILabel alloc] init];
        place.frame = CGRectMake(10, 22, 25, 20);
        place.font = [UIFont systemFontOfSize:20];
        [place setText:[NSString stringWithFormat:@"%d",indexPath.row]];
        [cell addSubview:place];
        [place release];
        
        UILabel* userName = [[UILabel alloc] init];
        userName.frame = CGRectMake(45, 20, 150, 20);
        userName.font = [UIFont systemFontOfSize:20];
        NSString* str = [[NSString alloc] initWithString:[(QBRGameModeParameterValue *)[scoreRecord.gameModeParameterValues objectAtIndex:0] value]];
        [userName setText:[NSString stringWithFormat:@"%@", str]];
        [str release];
        [cell addSubview:userName];
        [userName release];
        
        UILabel* scoreValue = [[UILabel alloc] init];
        scoreValue.frame = CGRectMake(230, 22, 40, 20);
        scoreValue.font = [UIFont systemFontOfSize:20];
        [scoreValue setText:[NSString stringWithFormat:@"%d",scoreRecord.value]];
        [cell addSubview:scoreValue];
        [scoreValue release];
    }
    else {
        UILabel* place = [[UILabel alloc] init];
        place.frame = CGRectMake(10, 22, 40, 20);
        place.font = [UIFont boldSystemFontOfSize:20];
        [place setText:@"№"];
        [cell addSubview:place];
        [place release];
        
        UILabel* userName = [[UILabel alloc] init];
        userName.frame = CGRectMake(45, 20, 140, 20);
        userName.font = [UIFont boldSystemFontOfSize:20];
        [userName setText:@"User Name"];
        [cell addSubview:userName];
        [userName release];
        
        UILabel* scoreValue = [[UILabel alloc] init];
        scoreValue.frame = CGRectMake(200, 22, 80, 20);
        scoreValue.font = [UIFont boldSystemFontOfSize:20];
        [scoreValue setText:@"Scores"];
        [cell addSubview:scoreValue];
        [scoreValue release];

    }
    return cell;
}


#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox API queries delegate
-(void)completedWithResult:(Result*)result{
    
    // Success result
    if (result.success) {
        
        // QuickBlox create Score result
        if ([result isKindOfClass:[QBRScoreResult class]]) {
            QBRScoreResult *res = (QBRScoreResult *)result;
            scoreID = res.score.ID;
            
            // Next query - set user name (to extra parameter)
            QBRGameModeParameterValue* userNameParameter = [QBRGameModeParameterValue gameModeParameterValue];
            userNameParameter.value = _userName;
            userNameParameter.gameModeParameterID = GAME_MODE_PARAMETER_ID;
            userNameParameter.scoreID = scoreID;
            
            [QBRatings createGameModeParameterValue:userNameParameter  delegate:self];
            
        // QuickBlox set extra parameter result
        }else if ([result isKindOfClass:[QBRGameModeParameterValueResult class]]) {
            
            // Get top 10 scores from server
            QBRScoreGetRequest* getRequest = [[QBRScoreGetRequest alloc] init];
            getRequest.sortAsc = YES;
            getRequest.sortBy = ScoreSortByKindValue;
            
            [QBRatings topNScores:10 gameModeID:GAME_MODE_ID delegate:self];
            [getRequest release];
            
        // QuickBlox get top N scores result
        }else if ([result isKindOfClass:[QBRScorePagedResult class]]) {
            QBRScorePagedResult* res = (QBRScorePagedResult*)result;
            
            _topScores = [[NSArray alloc] initWithArray:res.scores];
            
            [_raitingsTable reloadData];
            
            [_activityIndicator stopAnimating];
            [_activityIndicator setHidesWhenStopped:YES];
        } 
    }
}

- (void)dealloc{
    [_topScores release];
    [super dealloc];
}

@end
