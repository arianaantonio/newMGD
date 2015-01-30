//
//  GlobalLeaderboardScene.h
//  SavingSebastian
//
//  Created by Ariana Antonio on 1/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"
#import <Parse/Parse.h> 

@interface GlobalLeaderboardScene : CCNode <CCTableViewDataSource>
{
    NSString *userId;
    NSString *usernameSaved;
    CCTableView *table;
    NSMutableArray *scoreArray;
    
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
    NSNumber *completedGame;
    NSNumber *beginnersLuck;
}
@end
