//
//  QuizQuestion.m
//  QuickQuiz
//
//  Created by kirill on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuizQuestion.h"

@implementation QuizQuestion
@synthesize possibleAnswers = _possibleAnswers;
@synthesize correctAnswerNumber = _correctAnswerNumber;
@synthesize questionText = _questionText;
@synthesize questionPoints = _questionPoints;
-(id)init{
    if (self = [super init]) {
        _possibleAnswers = [[NSMutableArray alloc] init];
    }
    return self;
}
                            
-(BOOL)isAnswerCorrect:(NSInteger)answerNumber{
    return answerNumber == _correctAnswerNumber;
}

-(void)dealloc{
    [_questionText release];
    [_possibleAnswers release];
    [super dealloc];
}
@end
