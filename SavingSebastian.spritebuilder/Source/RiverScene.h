//
//  RiverScene.h
//  SavingSebastian
//
//  Created by Ariana Antonio on 12/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import <sqlite3.h>
#import <Parse/Parse.h> 

@interface RiverScene : CCNode <CCPhysicsCollisionDelegate>
{
    BOOL isPaused;
    BOOL isDead;
    BOOL logIsChild;
    NSTimer *myTimer;
    NSDate *startDate;
    NSString *finishedTime;
    int timeInt;
    int score;
    NSTimer *newTimer;
    NSDate *pauseStart, *previousFireDate;
    int first;
    CGFloat logScrollSpeed;
    int burgerCount;
    int skipLogCount;
    BOOL isPowerUp;
    int totalLogsSkipped;
    int totalBurgersEaten;
    int totalTaps;
    NSString *userId;
    NSString *usernameSaved;
    NSString *objectId;
    
    NSNumber *score25;
    NSNumber *score50;
    NSNumber *score100;
    NSNumber *score150;
    NSNumber *burgers20;
    NSNumber *burgers60;
    NSNumber *burgers120;
    NSNumber *log_avoid20;
    NSNumber *log_avoid50;
    NSNumber *log_avoid100;
    NSNumber *taps500;
    NSNumber *taps1000;
    NSNumber *beginnersLuck;
    NSNumber *completedGame;
}

@end
