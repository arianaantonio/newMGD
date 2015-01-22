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
}
@end
