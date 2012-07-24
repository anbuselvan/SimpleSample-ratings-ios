//
//  CheckBox.m
//  QuickQuiz
//
//  Created by kirill on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CheckBox.h"

@implementation CheckBox
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    [self setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"checkbox-checked.png"] forState:UIControlStateSelected];
    return self;
}

-(void)clear{
    [self setSelected:NO];
}
@end
