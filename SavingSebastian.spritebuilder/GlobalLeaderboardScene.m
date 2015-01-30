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
    CCSprite *_achievements;
    CCSprite *_score25_filled;
    CCSprite *_score50filled;
    CCSprite *_score100filled;
    CCSprite *_score150filled;
    CCSprite *_burgers20filled;
    CCSprite *_burgers60filled;
    CCSprite *_burgers120filled;
    CCSprite *_logs20Filled;
    CCSprite *_logs50filled;
    CCSprite *_logs100filled;
    CCSprite *_taps500filled;
    CCSprite *_taps1000filled;
    CCSprite *_score25empty;
    CCSprite *_score50empty;
    CCSprite *_score100empty;
    CCSprite *_score150empty;
    CCSprite *_burgers20empty;
    CCSprite *_burgers60empty;
    CCSprite *_burgers120empty;
    CCSprite *_logs20empty;
    CCSprite *_logs50empty;
    CCSprite *_logs100empty;
    CCSprite *_taps500empty;
    CCSprite *_taps1000empty;
    CCSprite *_beginnersLuckFilled;
    CCSprite *_completedFilled;
    CCSprite *_beginnersLuckempty;
    CCSprite *_completedempty;
    
}
- (void)didLoadFromCCB {
    self.userInteractionEnabled = TRUE;
    
    //remove elements not being used
    [self removeChild:_score25empty];
    [self removeChild:_score50empty];
    [self removeChild:_score100empty];
    [self removeChild:_score150empty];
    [self removeChild:_burgers20empty];
    [self removeChild:_burgers60empty];
    [self removeChild:_burgers120empty];
    [self removeChild:_logs20empty];
    [self removeChild:_logs50empty];
    [self removeChild:_logs100empty];
    [self removeChild:_taps500empty];
    [self removeChild:_taps1000empty];
    [self removeChild:_beginnersLuckempty];
    [self removeChild:_beginnersLuckFilled];
    [self removeChild:_completedempty];
    [self removeChild:_completedFilled];
    
    [self removeChild:_score25_filled];
    [self removeChild:_score50filled];
    [self removeChild:_score100filled];
    [self removeChild:_score150filled];
    [self removeChild:_burgers20filled];
    [self removeChild:_burgers60filled];
    [self removeChild:_burgers120filled];
    [self removeChild:_logs20Filled];
    [self removeChild:_logs50filled];
    [self removeChild:_logs100filled];
    [self removeChild:_taps500filled];
    [self removeChild:_taps1000filled];
    [self removeChild:_achievements];
    
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
    [self loadTable];
    [self loadAchievements];
}
//load main menu on click
-(void)menu {
    CCScene *mainMenu = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainMenu];
}
//log user in to Parse
-(void)login {
    
    if ([_loginUserButton isRunningInActiveScene]) {
        if ([_bgColorBox isRunningInActiveScene]) {
            if (![_loginButton isRunningInActiveScene]) {
                [self addChild:_loginButton];
            }
            if ([_signUpUserButton isRunningInActiveScene]) {
                [self removeChild:_signUpUserButton];
            }
        } else {
            
            if (![_usernameLabel isRunningInActiveScene]) {
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
                                            //NSLog(@"Logged in");
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
                                            [self loadAchievements];
                                            
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
    
    if ([_signUpButton isRunningInActiveScene]) {
        if ([_bgColorBox isRunningInActiveScene]) {
            if (![_signUpUserButton isRunningInActiveScene]) {
                [self addChild:_signUpUserButton];
            }
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
}
//sign up user
-(void)signUpUser {
    
    //set user info
    PFUser *user = [PFUser user];
    user.username = [_usernameField string];
    user.password = [_passwordField string];
    //NSString *newUser = [_usernameField string];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            PFUser *currentUser = [PFUser currentUser];
            if (currentUser) {
                userId = currentUser.objectId;
                usernameSaved = currentUser.username;
            }
            //NSLog(@"Username: %@, UserID: %@", usernameSaved, userId);
            
            NSNumber *zero = [NSNumber numberWithBool:false];
            PFObject *achievementBoard = [PFObject objectWithClassName:@"Achievements"];
            achievementBoard[@"score25"] = zero;
            achievementBoard[@"score50"] = zero;
            achievementBoard[@"score100"] = zero;
            achievementBoard[@"score150"] = zero;
            achievementBoard[@"burgers20"] = zero;
            achievementBoard[@"burgers60"] = zero;
            achievementBoard[@"burgers120"] = zero;
            achievementBoard[@"log_avoid20"] = zero;
            achievementBoard[@"log_avoid50"] = zero;
            achievementBoard[@"log_avoid100"] = zero;
            achievementBoard[@"taps500"] = zero;
            achievementBoard[@"taps1000"] = zero;
            achievementBoard[@"beginnerLuck"] = zero;
            achievementBoard[@"completedGame"] = zero;
            achievementBoard[@"userId"] = userId;
            [achievementBoard saveInBackground];
 
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
                //NSLog(@"User: %@, Score: %@", [object objectForKey:@"username"],[object objectForKey:@"score"]);
      
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
    CCNodeColor* colorNode = [CCNodeColor nodeWithColor:[CCColor darkGrayColor] width:250.0f height:18.0f];
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
    //NSLog(@"%@",[[scoreArray objectAtIndex:index]objectForKey:@"username"]);
    
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
    
    [self hideAchievements];
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
                //NSLog(@"User: %@, Score: %@", [object objectForKey:@"username"],[object objectForKey:@"score"]);
                
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
    [self hideAchievements];
}
//load users achievements from Parse
-(void)loadAchievements {
    PFQuery *query2 = [PFQuery queryWithClassName:@"Achievements"];
    [query2 whereKey:@"userId" equalTo:userId];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            for (PFObject *object in objects) {
                //NSLog(@"%@", object.objectId);
                score25 = [object objectForKey:@"score25"];
                score50 = [object objectForKey:@"score50"];
                score100 = [object objectForKey:@"score100"];
                score150 = [object objectForKey:@"score150"];
                burgers20 = [object objectForKey:@"burgers20"];
                burgers60 = [object objectForKey:@"burgers60"];
                burgers120 = [object objectForKey:@"burgers120"];
                log_avoid20 = [object objectForKey:@"log_avoid20"];
                log_avoid50 = [object objectForKey:@"log_avoid50"];
                log_avoid100 = [object objectForKey:@"log_avoid100"];
                taps500 = [object objectForKey:@"taps500"];
                taps1000 = [object objectForKey:@"taps1000"];
                beginnersLuck = [object objectForKey:@"beginnerLuck"];
                completedGame = [object objectForKey:@"completedGame"];
            }
        }
    }];
}
//display achievement labels and respective stars
-(void)showAchievements {
    [self loadAchievements];
    if (![_achievements isRunningInActiveScene]) {
        
        [self addChild:_achievements];
        NSNumber *zero = [NSNumber numberWithInt:0];

        if ([score25 isEqualToNumber:zero]) {
            //[self addChild:_score25empty];
        } else {
            [self addChild:_score25_filled];
        }
        if ([score50 isEqualToNumber:zero]) {
            //[self addChild:_score50empty];
        } else {
            [self addChild:_score50filled];
        }
        if ([score100 isEqualToNumber:zero]) {
            //[self addChild:_score100empty];
        } else {
            [self addChild:_score100filled];
        }
        if ([score150 isEqualToNumber:zero]) {
            //[self addChild:_score150empty];
        } else {
            [self addChild:_score150filled];
        }
        if ([burgers20 isEqualToNumber:zero]) {
           // [self addChild:_burgers20empty];
        } else {
            [self addChild:_burgers20filled];
        }
        if ([burgers60 isEqualToNumber:zero]) {
           // [self addChild:_burgers60empty];
        } else {
            [self addChild:_burgers60filled];
        }
        if ([burgers120 isEqualToNumber:zero]) {
           // [self addChild:_burgers120empty];
        } else {
            [self addChild:_burgers120filled];
        }
        if ([log_avoid20 isEqualToNumber:zero]) {
           // [self addChild:_logs20empty];
        } else {
            [self addChild:_logs20Filled];
        }
        if ([log_avoid50 isEqualToNumber:zero]) {
            //[self addChild:_logs50empty];
        } else {
            [self addChild:_logs50filled];
        }
        if ([log_avoid100 isEqualToNumber:zero]) {
            //[self addChild:_logs100empty];
        } else {
            [self addChild:_logs100filled];
        }
        if ([taps500 isEqualToNumber:zero]) {
           // [self addChild:_taps500empty];
        } else {
            [self addChild:_taps500filled];
        }
        if ([taps1000 isEqualToNumber:zero]) {
            //[self addChild:_taps1000empty];
        } else {
            [self addChild:_taps1000filled];
        }
        if ([completedGame isEqualToNumber:zero]) {
            //[self addChild:_completedempty];
        } else {
            [self addChild:_completedFilled];
        }
        if ([beginnersLuck isEqualToNumber:zero]) {
            //[self addChild:_beginnersLuckempty];
        } else {
            [self addChild:_beginnersLuckFilled];
        }
    }
}
//remove achievement assets to show leaderboards
-(void)hideAchievements {

    if ([_score25_filled isRunningInActiveScene]) {
        [self removeChild:_score25_filled];
    }
    if ([_score25empty isRunningInActiveScene]) {
        [self removeChild:_score25empty];
    }
    if ([_score50empty isRunningInActiveScene]) {
        [self removeChild:_score50empty];
    }
    if ([_score50filled isRunningInActiveScene]) {
        [self removeChild:_score50filled];
    }
    if ([_score100empty isRunningInActiveScene]) {
        [self removeChild:_score100empty];
    }
    if ([_score100filled isRunningInActiveScene]) {
        [self removeChild:_score100filled];
    }
    if ([_score150empty isRunningInActiveScene]) {
        [self removeChild:_score150empty];
    }
    if ([_score150filled isRunningInActiveScene]) {
        [self removeChild:_score150filled];
    }
    if ([_burgers20empty isRunningInActiveScene]) {
        [self removeChild:_burgers20empty];
    }
    if ([_burgers20filled isRunningInActiveScene]) {
        [self removeChild:_burgers20filled];
    }
    if ([_burgers60empty isRunningInActiveScene]) {
        [self removeChild:_burgers60empty];
    }
    if ([_burgers60filled isRunningInActiveScene]) {
        [self removeChild:_burgers60filled];
    }
    if ([_burgers120filled isRunningInActiveScene]) {
        [self removeChild:_burgers120filled];
    }
    if ([_burgers120empty isRunningInActiveScene]) {
        [self removeChild:_burgers120empty];
    }
    if ([_logs20empty isRunningInActiveScene]) {
        [self removeChild:_logs20empty];
    }
    if ([_logs20Filled isRunningInActiveScene]) {
        [self removeChild:_logs20Filled];
    }
    if ([_logs50empty isRunningInActiveScene]) {
        [self removeChild:_logs50empty];
    }
    if ([_logs50filled isRunningInActiveScene]) {
        [self removeChild:_logs50filled];
    }
    if ([_logs100filled isRunningInActiveScene]) {
        [self removeChild:_logs100filled];
    }
    if ([_logs100empty isRunningInActiveScene]) {
        [self removeChild:_logs100empty];
    }
    if ([_taps1000empty isRunningInActiveScene]) {
        [self removeChild:_taps1000empty];
    }
    if ([_taps1000filled isRunningInActiveScene]) {
        [self removeChild:_taps1000filled];
    }
    if ([_taps500empty isRunningInActiveScene]) {
        [self removeChild:_taps500empty];
    }
    if ([_taps500filled isRunningInActiveScene]) {
        [self removeChild:_taps500filled];
    }
    if ([_completedFilled isRunningInActiveScene]) {
        [self removeChild:_completedFilled];
    }
    if ([_completedempty isRunningInActiveScene]) {
        [self removeChild:_completedempty];
    }
    if ([_beginnersLuckFilled isRunningInActiveScene]) {
        [self removeChild:_beginnersLuckFilled];
    }
    if ([_beginnersLuckempty isRunningInActiveScene]) {
        [self removeChild:_beginnersLuckempty];
    }
    if ([_achievements isRunningInActiveScene]) {
        [self removeChild:_achievements];
    }
}

@end

