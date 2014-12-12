//
//  RiverScene.h
//  SavingSebastian
//
//  Created by Ariana Antonio on 12/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "CSPausibleTimer.h"

@interface RiverScene : CCNode <CCPhysicsCollisionDelegate>
{
    BOOL isPaused;
    BOOL isDead;
    NSTimer *myTimer;
    NSDate *startDate;
    NSString *finishedTime;
    int timeInt;
    int score;
    NSTimer *newTimer;
    NSDate *pauseStart, *previousFireDate;
    CSPausibleTimer *pTimer;
    int first;
    
    
}
//@property (nonatomic, assign) NSInteger *timeInt;

@end
