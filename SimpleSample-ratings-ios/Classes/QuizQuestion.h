//
//  QuizQuestion.h
//  QuickQuiz
//
//  Created by kirill on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
                                        // class represents question in quiz
@interface QuizQuestion : NSObject
@property (nonatomic,retain) NSString* questionText;
@property (assign) NSInteger correctAnswerNumber;
@property (assign) NSInteger questionPoints;
@property (nonatomic,retain) NSMutableArray* possibleAnswers;
-(BOOL)isAnswerCorrect:(NSInteger)answerNumber;
@end
