//
//  MainViewController.m
//  QuickQuiz
//
//  Created by kirill on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "DataManager.h"
#import "QuizQuestion.h"
#import "CheckBox.h"
#import "RaitingsTableController.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize currentUserScore;
@synthesize timerFace;
@synthesize quizDecoration;
@synthesize answer1;
@synthesize answer2;
@synthesize answer3;
@synthesize questionLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        currentQuestionIndex = 0;
        score = 0;
        checkBoxes = [[NSMutableArray alloc] init];
        seconds = ANSWER_TIME;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    int y = 190;        
    
    // Show checkbox items
    for (int i = 0; i < 3; i++) {        
        CheckBox* checkBox = [[CheckBox alloc] initWithFrame:CGRectMake(10, y, 33, 27)];
        checkBox.tag = i;
        [checkBox addTarget:self action:@selector(chooseAnswer:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:checkBox];
        [checkBoxes addObject:checkBox];
        [checkBox release];
        y += 50;
    }
}
 
// Choose answer
-(void)chooseAnswer:(id)sender{
    // can make only one choice
    [self clearCheckBoxes];
                                
    switch ([sender tag]) {
        case 0:
            [[checkBoxes objectAtIndex:0] setSelected:YES];
            break;
        case 1:
            [[checkBoxes objectAtIndex:1] setSelected:YES];
            break;
            
        case 2:
            [[checkBoxes objectAtIndex:2] setSelected:YES];
            break;
            
        default:
            break;
    }
}
                    
-(BOOL)isAnswerChecked{
    for (CheckBox* checkbox in checkBoxes) {
        if ([checkbox isSelected]) {
            return YES;
        }
    }
    return NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self putQuestionWithIndexOnScreen:currentQuestionIndex];
}

// Show answers
-(void)putQuestionWithIndexOnScreen:(NSInteger)index{    
    seconds = ANSWER_TIME;
    [self showTime];
    [self runTimer];
                                                // get current question
    QuizQuestion* question = [[[DataManager instance] quizData] objectAtIndex:index];
                // show question on screen
    questionLabel.text = question.questionText;
    answer1.text = [question.possibleAnswers objectAtIndex:0];
    answer2.text = [question.possibleAnswers objectAtIndex:1];
    answer3.text = [question.possibleAnswers objectAtIndex:2];
}

- (void)viewDidUnload
{
    [self setQuestionLabel:nil];
    [self setAnswer1:nil];
    [self setAnswer2:nil];
    [self setAnswer3:nil];
    [self setCurrentUserScore:nil];
    [self setTimerFace:nil];
    [self setQuizDecoration:nil];
    [super viewDidUnload];
}

// Run question timer
-(void)runTimer{                    
    answerTimer = [[NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(showTime) userInfo:nil repeats:YES] retain]; 
}
//
-(void)showTime{
    timeToEndTask++;
    if (timeToEndTask == 1000) {
        seconds--;
        timeToEndTask = 0;
    }
    [timerFace setText:[NSString stringWithFormat:@"%d:%d",seconds,timeToEndTask]];
    
    if (seconds == 0) {
        // if all questions are answered
        if (currentQuestionIndex == [[[DataManager instance] quizData] count]-1) {
            [self showResultDialog];            // show final dialog
            [answerTimer invalidate];
            return;
        }
        else {
            // show correct answer and switch to another question
            [self clearCheckBoxes];
            [answerTimer invalidate];
                                                    // show correct answer if user did not answer
            
            QuizQuestion* question = [[[DataManager instance] quizData] objectAtIndex:currentQuestionIndex];
            
            [questionLabel setText:@"And correct answer is"];
            
            [[checkBoxes objectAtIndex:question.correctAnswerNumber-1] setSelected:YES];
                                        // show next question in 2 seconds
            [self performSelector:@selector(switchToAnotherQuestion) withObject:self afterDelay:2];
        }
    }
}
    
- (void) switchToAnotherQuestion{
    [self clearCheckBoxes];
    currentQuestionIndex++;
    [self putQuestionWithIndexOnScreen:currentQuestionIndex];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)clearCheckBoxes{
    for (CheckBox* box in checkBoxes) {
        [box setSelected:NO];
    }
}

// get users answers
-(NSMutableArray*)answers{
    NSMutableArray* result = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < checkBoxes.count; i++) {
        if ([[checkBoxes objectAtIndex:i] isSelected]) {
            NSNumber* questionNumber = [NSNumber numberWithInt:i+1];
            [result addObject:questionNumber];
        }
    }
    return result;
}

-(void)checkAnswerAndUpdateScore:(NSMutableArray*)answers{
    if (answers.count == 1) {
        QuizQuestion* question = [[[DataManager instance] quizData] objectAtIndex:currentQuestionIndex];
            
        int number = [[answers objectAtIndex:0] intValue];
        if ([question isAnswerCorrect:number]) {
            score += question.questionPoints;
        }
    }

}
-(void)clearView{
    for(UIView *subview in [self.view subviews]) {
        if([subview isKindOfClass:[UIButton class]] || [subview isKindOfClass:[UILabel class]]) {
            [subview removeFromSuperview];
        }     
    }
}

// End of Quiz - show reult dialog
-(void)showResultDialog{
    [self clearView];

    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!" message:@"You have finished quiz. Please enter your name" 
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;

    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{ 
                        // react only if it is result dialog
    if ([[alertView title] isEqualToString:@"Congratulations!"]) {
        userName = [[NSString alloc] initWithString:[[alertView textFieldAtIndex:0] text]];
        // if user did not specifie name use default name
        if ([userName isEqualToString:@""]) {
            userName = [[NSString alloc] initWithString:@"%USER_NAME%"];
        }
        // show raitings table
        RaitingsTableController* raitings = [[RaitingsTableController alloc] init];
        raitings.userName = [NSString stringWithString:userName];
        raitings.userQuizScore = score;
        [self presentModalViewController:raitings animated:NO];
        [raitings release];
    }

}

// Next Question action
- (IBAction)nextButtonPressed:(id)sender {
                    // check user answered
    if ([self isAnswerChecked]) {
        [answerTimer invalidate];
        
        NSMutableArray* questionAnswers = [self answers];
        [self checkAnswerAndUpdateScore:questionAnswers];
                                        // if not all questions are answered
        if (currentQuestionIndex < [[[DataManager instance] quizData] count]-1) {
            
            currentQuestionIndex++;
            [self putQuestionWithIndexOnScreen:currentQuestionIndex];
            [currentUserScore setText:[NSString stringWithFormat:@"%d scores",score]];
            [self clearCheckBoxes];
            return;
        }        
    }
    else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"ERROR! " message:@"No answer selected!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    if (currentQuestionIndex == [[[DataManager instance] quizData] count]-1) {
        
        [self showResultDialog];
    }
}

@end
