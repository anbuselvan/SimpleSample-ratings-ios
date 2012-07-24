//
//  XMLParser.m
//  QuickQuiz
//
//  Created by kirill on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XMLParser.h"

@implementation XMLParser
@synthesize quizQuestions = _quizQuestions;
-(void)parseQuestionsFromPath:(NSString*)path{   
                                                        // initialise parser
    NSData* data = [[NSData alloc] initWithContentsOfFile:path];
    NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
    
    [parser setShouldResolveExternalEntities:YES];
    [parser setDelegate:self];
        
    [parser parse];
    [parser release];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
                            // root element of XML document
    if ([elementName isEqualToString:@"quiz"]) {
        
        if (!_quizQuestions) {
            NSNumber * numberOfQuestions = [attributeDict objectForKey:@"questionsNumber"];
            _quizQuestions = [[NSMutableArray alloc] initWithCapacity:[numberOfQuestions intValue]];
        }
        return;
    }
                             
    else if([elementName isEqualToString:@"question"]){
        if (!currentQuestion) {
            currentQuestion = [[QuizQuestion alloc] init];
        }
        return;
    }                               // mark with needed tags
    
    else if ([elementName isEqualToString:@"text"]) {
        currentNode = 1;
        return;
    }
    
    else if ([elementName isEqualToString:@"variants"]) {
        currentNode = 2;
        return;
    }
    else if([elementName isEqualToString:@"points"]){
        currentNode = 3;
        return;
    }
    else if ([elementName isEqualToString:@"correctAnswer"]) {
        currentNode = 4;
        return;
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
                                                        // clear variable for storing another value
    if ([elementName isEqualToString:@"question"]) {
        [_quizQuestions addObject:currentQuestion];
        [currentQuestion release];
        currentQuestion = nil;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    switch (currentNode) {
                            // if this is text 
        case 1:
            currentQuestion.questionText = [[NSString alloc] initWithString:string];
            break;
                            // if this is variant
        case 2:{
            if (!currentQuestion.possibleAnswers) {
                currentQuestion.possibleAnswers = [[NSMutableArray alloc] init];
            }
            [currentQuestion.possibleAnswers addObject:string];
            break;
        }     
                            // if this is points for question
        case 3:{
            currentQuestion.questionPoints = [string intValue];
            break;
        }
                            // if this is number of correct answer
        case 4:
            currentQuestion.correctAnswerNumber = [string intValue];
            break;
            
            
        default:
            break;
    }
    currentNode = 0;
}

-(void)dealloc{
    
    [currentQuestion release];
    [_quizQuestions release];
    [super dealloc];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    UIAlertView *parserAlert = [[UIAlertView alloc] init];  
    [parserAlert setTitle:@"Parsing Error!"];
     [parserAlert setMessage:[NSString stringWithFormat:@"Error %i, Description: %@,Line: %i, Column: %i", [parseError code],
                              [[parser parserError] localizedDescription], [parser lineNumber],                            
                                        [parser columnNumber]]];
    [parserAlert addButtonWithTitle:@"OK"];
    [parserAlert show];
    [parserAlert release];
}

@end
