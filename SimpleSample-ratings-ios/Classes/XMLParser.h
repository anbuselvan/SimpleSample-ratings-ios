//
//  XMLParser.h
//  QuickQuiz
//
//  Created by kirill on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuizQuestion.h"
                                                        // class for parsing XML into arrays of QuizQuestions
@interface XMLParser : NSObject<NSXMLParserDelegate>{
    QuizQuestion* currentQuestion;
    NSInteger currentNode;
}

-(void)parseQuestionsFromPath:(NSString*)path;
@property (nonatomic,retain) NSMutableArray* quizQuestions;

@end
