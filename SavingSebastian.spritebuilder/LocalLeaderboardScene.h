//
//  LeaderboardScene.h
//  SavingSebastian
//
//  Created by Ariana Antonio on 1/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"
#import <sqlite3.h> 

@interface LocalLeaderboardScene : CCNode <CCTableViewDataSource>
{
    NSString *dbPath;
    NSMutableArray *scoreArray;
    CCTableView* table;
}
@end
