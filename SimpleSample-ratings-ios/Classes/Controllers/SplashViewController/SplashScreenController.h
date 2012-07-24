//
//  SplashScreenController.h
//  QuickQuiz
//
//  Created by kirill on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLParser.h"
@interface SplashScreenController : UIViewController<QBActionStatusDelegate>{
    XMLParser* parser;
}
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
-(void)hideSplashScreen;
@end
