//
//  GlobalLeaderboardScene.m
//  SavingSebastian
//
//  Created by Ariana Antonio on 1/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GlobalLeaderboardScene.h"

@implementation GlobalLeaderboardScene
{
    CCLabelTTF *_usernameLabel;
    CCLabelTTF *_passwordLabel;
    CCTextField *_usernameField;
    CCTextField *_passwordField;
    CCButton *_loginButton;
    CCButton *_signUpUserButton;
    CCButton *_signUpButton;
    CCButton *_logoutButton;
    CCButton *_loginUserButton;
    CCNodeColor *_bgColorBox;
    CCNodeColor *_tableCover;
    CCNodeColor *_usernameColor;
    CCNodeColor *_passwordColor;
}
- (void)didLoadFromCCB {
    self.userInteractionEnabled = TRUE;
    
    //remove elements not being used
    [self removeChild:_usernameField];
    [self removeChild:_usernameLabel];
    [self removeChild:_passwordField];
    [self removeChild:_passwordLabel];
    [self removeChild:_loginButton];
    [self removeChild:_bgColorBox];
    [self removeChild:_signUpUserButton];
    [self removeChild:_tableCover];
    [self removeChild:_passwordColor];
    [self removeChild:_usernameColor];
    
    scoreArray = [[NSMutableArray alloc]init];
    
    //create table
    table = [CCTableView node];
    table.dataSource = self;
    table.position = ccp(60,-130);
    table.block = ^(CCTableView* table) {
        //NSLog(@"Cell %d was pressed", (int) table.selectedRow);
    };
    [self addChild:table];
    
    //check if user is logged in
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        userId = currentUser.objectId;
        usernameSaved = currentUser.username;
        [self removeChild:_signUpButton];
        [self removeChild:_loginUserButton];
        [self loadTable];
    } else {
        [self removeChild:_logoutButton];
    }
    [self addChild:_tableCover];
}
//load main menu on click
-(void)menu {
    CCScene *mainMenu = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainMenu];
}
//log user in to Parse
-(void)login {
    
    if ([_bgColorBox isRunningInActiveScene]) {
        [self addChild:_loginButton];
        if ([_signUpButton isRunningInActiveScene]) {
            [self removeChild:_signUpUserButton];
        }
    } else {
        
    [self addChild:_bgColorBox];
    [self addChild:_usernameLabel];
    [self addChild:_usernameField];
    [self addChild:_passwordLabel];
    [self addChild:_passwordField];
    [self addChild:_loginButton];
    [self addChild:_usernameColor];
    [self addChild:_passwordColor];
    }
}
-(void)loginUser {
    
    //get username and password entered
    NSString *username = [_usernameField string];
    NSString *password = [_passwordField string];
    
    //log user in
    [PFUser logInWithUsernameInBackground:username password:password
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            NSLog(@"Logged in");
                                            //set up logged in elements
                                            [self removeChild:_usernameField];
                                            [self removeChild:_usernameLabel];
                                            [self removeChild:_passwordField];
                                            [self removeChild:_passwordLabel];
                                            [self removeChild:_bgColorBox];
                                            [self removeChild:_signUpButton];
                                            [self removeChild:_loginButton];
                                            [self removeChild:_loginUserButton];
                                            [self removeChild:_passwordColor];
                                            [self removeChild:_usernameColor];
                                            [self addChild:_logoutButton];
                                            
                                            [self loadTable];
                                            
                                            //set user values
                                            PFUser *currentUser = [PFUser currentUser];
                                            if (currentUser) {
                                                userId = currentUser.objectId;
                                                usernameSaved = username;
                                            
                                            } else {
                                                NSLog(@"Not logged in");
                                            }
                                        } else {
                                            NSLog(@"Not logged in");
                                        }
                                    }];
}
//sign up button clicked
-(void)signUp {
    
    if ([_bgColorBox isRunningInActiveScene]) {
        [self addChild:_signUpUserButton];
        if ([_loginButton isRunningInActiveScene]) {
            [self removeChild:_loginButton];
        }
    } else {
        
        [self addChild:_bgColorBox];
        [self addChild:_usernameLabel];
        [self addChild:_usernameField];
        [self addChild:_passwordLabel];
        [self addChild:_passwordField];
        [self addChild:_signUpUserButton];
        [self addChild:_usernameColor];
        [self addChild:_passwordColor];
    }
}
//sign up user
-(void)signUpUser {
    
    //set user info
    PFUser *user = [PFUser user];
    user.username = [_usernameField string];
    user.password = [_passwordField string];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
 
            [self removeChild:_usernameField];
            [self removeChild:_usernameLabel];
            [self removeChild:_passwordField];
            [self removeChild:_passwordLabel];
            [self removeChild:_bgColorBox];
            [self removeChild:_signUpButton];
            [self removeChild:_loginUserButton];
            [self addChild:_logoutButton];
            [self removeChild:_signUpUserButton];
            [self removeChild:_passwordColor];
            [self removeChild:_usernameColor];
            
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"Error: %@", errorString);
            if ([error code] == 202) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Username already in use" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        }
    }];
}
//logout user
-(void)logout {
    [PFUser logOut];
    [self addChild:_loginUserButton];
    [self addChild:_signUpButton];
    [self removeChild:_logoutButton];
}
//load highscore table
-(void)loadTable {
    
    [scoreArray removeAllObjects];
    
    //pull highscore table
    PFQuery *query2 = [PFQuery queryWithClassName:@"Highscores"];
    [query2 orderByDescending:@"score"];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            NSString *tableUsername = @"";
            NSString *tableScore = @"";
            
            //set score info to array for table
            for (PFObject *object in objects) {
                NSLog(@"User: %@, Score: %@", [object objectForKey:@"username"],[object objectForKey:@"score"]);
      
                tableUsername = [object objectForKey:@"username"];
                tableScore = [object objectForKey:@"score"];
            
                NSMutableDictionary *scoreDictionary = [[NSMutableDictionary alloc]init];
                [scoreDictionary setValue:tableScore forKey:@"score"];
                [scoreDictionary setValue:tableUsername forKey:@"username"];
                [scoreArray addObject:scoreDictionary];
            }
            [table reloadData];
        }
    }];
}
- (CCTableViewCell*) tableView:(CCTableView*)tableView nodeForRowAtIndex:(NSUInteger) index {
    
    //init cell
    CCTableViewCell* cell = [CCTableViewCell node];
    cell.contentSizeType = CCSizeTypeMake(CCSizeUnitNormalized, CCSizeUnitUIPoints);
    cell.contentSize = CGSizeMake(1.0f, 32.0f);
    
    //change color to highlight signed in user
    CCNodeColor* colorNode = [CCNodeColor nodeWithColor:[CCColor greenColor] width:250.0f height:18.0f];
    CCNodeColor* pinkColorNode = [CCNodeColor nodeWithColor:[CCColor purpleColor] width:250.0f height:18.0f];
    if ([usernameSaved isEqualToString:[[scoreArray objectAtIndex:index]objectForKey:@"username"]]) {
        [cell addChild:pinkColorNode];
    } else {
        [cell addChild:colorNode];
    }
    
    //set up score label
    CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@",[[scoreArray objectAtIndex:index]objectForKey:@"score"]] fontName:@"HelveticaNeue" fontSize:18 * [CCDirector sharedDirector].UIScaleFactor];
    scoreLabel.positionType = CCPositionTypeNormalized;
    scoreLabel.position = ccp(0.5f, 0.3f);
    [cell addChild:scoreLabel];
    NSLog(@"%@",[[scoreArray objectAtIndex:index]objectForKey:@"username"]);
    
    //set up username label
    CCLabelTTF *userLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@",[[scoreArray objectAtIndex:index]objectForKey:@"username"]] fontName:@"HelveticaNeue" fontSize:18 * [CCDirector sharedDirector].UIScaleFactor];
    userLabel.positionType = CCPositionTypeNormalized;
    userLabel.position = ccp(0.2f, 0.3f);
    [cell addChild:userLabel];
    
    return cell;
}
- (NSUInteger) tableViewNumberOfRows:(CCTableView*) tableView {
    return [scoreArray count];
}
//clicked today filter
-(void)todayClick {
    
    [scoreArray removeAllObjects];
    NSDate *today = [[NSDate alloc]init];
    
    //pull score table
    PFQuery *query2 = [PFQuery queryWithClassName:@"Highscores"];
    [query2 orderByDescending:@"score"];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            NSString *tableUsername = @"";
            NSString *tableScore = @"";
            NSString *scoreDate = @"";

            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                NSLog(@"User: %@, Score: %@", [object objectForKey:@"username"],[object objectForKey:@"score"]);
                
                //format today's date and createdAt to be the same
                NSDate *datePulled = object.createdAt;
                NSDateFormatter *df = [[NSDateFormatter alloc]init];
                [df setDateFormat:@"yyyy-MM-dd"];
                NSString *todayDateStr = [df stringFromDate:today];
                NSString *datePulledStr = [df stringFromDate:datePulled];
                
                tableUsername = [object objectForKey:@"username"];
                tableScore = [object objectForKey:@"score"];
                scoreDate = [object objectForKey:@"createdAt"];
                
                //if todays date is the same as createdAt, add it to the array
                if ([todayDateStr isEqualToString:datePulledStr]) {

                    NSMutableDictionary *scoreDictionary = [[NSMutableDictionary alloc]init];
                    [scoreDictionary setValue:tableScore forKey:@"score"];
                    [scoreDictionary setValue:tableUsername forKey:@"username"];
                    [scoreArray addObject:scoreDictionary];
                }
            }
            [table reloadData];
        }
    }];
}
//reload main table for all time highscores
-(void)allTimeClick {
    [self loadTable];
}
@end
