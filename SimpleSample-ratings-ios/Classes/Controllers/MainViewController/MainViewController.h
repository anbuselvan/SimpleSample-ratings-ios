//
//  MainViewController.h
//  QuickQuiz
//
//  Created by kirill on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckBox.h"

#define ANSWER_TIME 10              // time to answer one question

@interface MainViewController : UIViewController<UIAlertViewDelegate>{
    int currentQuestionIndex;
    NSMutableArray* checkBoxes;
    int score;
    int scoreID;
    NSArray* topScores;
    NSTimer* answerTimer;
    int timeToEndTask;
    int seconds;
    NSString* userName;
}
@property (retain, nonatomic) IBOutlet UILabel *questionLabel;
@property (retain, nonatomic) IBOutlet UILabel *answer1;
@property (retain, nonatomic) IBOutlet UILabel *answer2;
@property (retain, nonatomic) IBOutlet UILabel *answer3;
@property (retain, nonatomic) IBOutlet UILabel *currentUserScore;
@property (retain, nonatomic) IBOutlet UILabel *timerFace;
@property (retain, nonatomic) IBOutlet UIImageView *quizDecoration;

- (IBAction)nextButtonPressed:(id)sender;


@end
