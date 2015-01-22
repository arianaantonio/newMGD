//
//  LeaderboardScene.m
//  SavingSebastian
//
//  Created by Ariana Antonio on 1/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "LocalLeaderboardScene.h"

@implementation LocalLeaderboardScene
{
    CCButton *_shareScoreButton;
    CCNodeColor *_tableCover;
}

- (void)didLoadFromCCB {
    self.userInteractionEnabled = TRUE;
    
    [self removeChild:_tableCover];
    scoreArray = [[NSMutableArray alloc]init];
    
    //load sql database
    dbPath = [[NSBundle mainBundle] pathForResource:@"Leaderboard" ofType:@"sqlite"];
    [self loadDBValues];
    
    //init table
    table = [CCTableView node];
    table.dataSource = self;
    table.position = ccp(60,-130);
    table.block = ^(CCTableView* table) {
        //NSLog(@"Cell %d was pressed", (int) table.selectedRow);
    };
    [self addChild:table];
    [self addChild:_tableCover];
}
#pragma mark Button actions
//load main menu on click
-(void)menu {
    
    CCScene *mainMenu = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainMenu];
}
//share score to social networks
-(void)shareScore {
    
    NSNumber *highesterScore = [[scoreArray firstObject]objectForKey:@"score"];
    NSString *highestPlayer = [[scoreArray firstObject]objectForKey:@"username"];
    
    //setting up text for share option
    NSString *shareText = [NSString stringWithFormat:@"The highest score on my phone for Saving Sebastian is %@ by %@!", highesterScore, highestPlayer];
    
    //setting share view contoller
    UIActivityViewController *controller =
    [[UIActivityViewController alloc]
     initWithActivityItems:@[shareText]
     applicationActivities:nil];
    
    //excluding unwanted share options
    controller.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                         UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToVimeo,
                                         UIActivityTypePostToTencentWeibo,
                                         UIActivityTypeAirDrop];
    
    [[CCDirector sharedDirector] presentViewController:controller animated:YES completion:nil];
}
#pragma mark TableView Methods
- (CCTableViewCell*) tableView:(CCTableView*)tableView nodeForRowAtIndex:(NSUInteger) index {
    
    //initializing cell
    CCTableViewCell* cell = [CCTableViewCell node];
    cell.contentSizeType = CCSizeTypeMake(CCSizeUnitNormalized, CCSizeUnitUIPoints);
    cell.contentSize = CGSizeMake(1.0f, 32.0f);
    
    //set row color
    CCNodeColor* colorNode = [CCNodeColor nodeWithColor:[CCColor greenColor] width:250.0f height:18.0f];
    [cell addChild:colorNode];
    
    //set score label
    CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@",[[scoreArray objectAtIndex:index]objectForKey:@"score"]] fontName:@"HelveticaNeue" fontSize:18 * [CCDirector sharedDirector].UIScaleFactor];
    scoreLabel.positionType = CCPositionTypeNormalized;
    scoreLabel.position = ccp(0.5f, 0.3f);
    [cell addChild:scoreLabel];
    NSLog(@"%@",[[scoreArray objectAtIndex:index]objectForKey:@"username"]);
    
    //set player label
    CCLabelTTF *userLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@",[[scoreArray objectAtIndex:index]objectForKey:@"username"]] fontName:@"HelveticaNeue" fontSize:18 * [CCDirector sharedDirector].UIScaleFactor];
    userLabel.positionType = CCPositionTypeNormalized;
    userLabel.position = ccp(0.1f, 0.3f);
    [cell addChild:userLabel];
    
    return cell;
}
- (NSUInteger) tableViewNumberOfRows:(CCTableView*) tableView {
    return [scoreArray count];
}
#pragma mark SQL queries
//load data from database for table
-(void)loadDBValues {
    sqlite3 *database;
    NSString *query = @"SELECT * FROM scores ORDER BY score DESC";
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        const char *sqlStatement = [query cStringUsingEncoding:NSASCIIStringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {

                int score = 0;
                NSString *username = @"";
                NSString *date = @"";
                
                if (sqlite3_column_text(compiledStatement, 0) != NULL) {
                    username = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                }
                if (sqlite3_column_int(compiledStatement, 1) != 0) {
                    score = sqlite3_column_int(compiledStatement, 1);
                }
                if (sqlite3_column_text(compiledStatement, 2) != NULL) {
                    date = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                }
                NSLog(@"Score: %i, User: %@, Date: %@", score, username, date);
                
                NSNumber *scoreNum = [NSNumber numberWithInt:score];
                NSDictionary *scoreDictionary = [NSDictionary dictionaryWithObjectsAndKeys:scoreNum, @"score", username, @"username", date, @"date", nil];
                [scoreArray addObject:scoreDictionary];
            }
            sqlite3_finalize(compiledStatement);
        }
    }
    [table reloadData];
}
//connect to database
-(BOOL)checkIfTableExists:(NSString *)query
{
    sqlite3_stmt *compiledStatement = NULL;
    
    sqlite3 *database;
    
    BOOL exist = FALSE;
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        const char *sqlStatement = [query cStringUsingEncoding:NSASCIIStringEncoding];
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            exist = TRUE;
        }
    }
    
    sqlite3_finalize(compiledStatement);
    sqlite3_close(database);
    return exist;
}
@end
