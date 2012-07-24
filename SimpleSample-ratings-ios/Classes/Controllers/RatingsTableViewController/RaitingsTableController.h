//
//  RaitingsTableController.h
//  QuickQuiz
//
//  Created by kirill on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RaitingsTableController : UIViewController<UITableViewDataSource,UITableViewDelegate,QBActionStatusDelegate>{
    NSInteger scoreID;
    
}
@property (retain, nonatomic) IBOutlet UITableView *raitingsTable;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic,retain) NSArray* topScores;
@property (nonatomic,retain) NSString* userName;
@property (assign)NSInteger userQuizScore;

- (IBAction)backButtonClicked:(id)sender;

@end
