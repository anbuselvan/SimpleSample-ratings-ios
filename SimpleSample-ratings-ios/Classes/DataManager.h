//
//  DataManager.h
//  QuickQuiz
//
//  Created by kirill on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
                                        // singleton for storing and transferring info between controllers
@interface DataManager : NSObject{
}
@property (nonatomic,retain) NSMutableArray* quizData;

+(DataManager*)instance;            // shared instance
-(void)saveParsedData:(NSMutableArray*)parsedData;
@end
