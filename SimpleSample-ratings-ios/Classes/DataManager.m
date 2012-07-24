//
//  DataManager.m
//  QuickQuiz
//
//  Created by kirill on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager
@synthesize quizData = _quizData;
static DataManager* instance = nil;
+(DataManager*)instance{
    if (!instance) {
        instance = [[self alloc] init];
    }
    return instance;
}

-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)saveParsedData:(NSMutableArray*)parsedData{
    if (!_quizData) {
        _quizData = [[NSMutableArray alloc] initWithArray:parsedData];
    }
}

-(void)dealloc{
    [_quizData release];
    [super dealloc];
}
@end
