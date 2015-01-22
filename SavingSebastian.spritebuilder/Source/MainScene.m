/*
* Ariana Antonio
* Saving Sebastian
*
*/

#import "MainScene.h"

@implementation MainScene


- (void)play {
    
    //load the main River Scene when user clicks "Play"
    CCScene *riverScene = [CCBReader loadAsScene:@"RiverScene"];
    [[CCDirector sharedDirector] replaceScene:riverScene];
    
    //play sound effect when player taps "Play"
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"BearRoar.wav"];
}
//load instructions scene on click
-(void)instructions {
    NSLog(@"Clicked instructions");
    CCScene *instructionsScene = [CCBReader loadAsScene:@"InstructionsScene"];
    [[CCDirector sharedDirector] replaceScene:instructionsScene];
}
//load credits scene on click
-(void)credits {
    NSLog(@"Clicked credits");
    CCScene *creditsScene = [CCBReader loadAsScene:@"CreditsScene"];
    [[CCDirector sharedDirector] replaceScene:creditsScene];
}
//load local leaderboard scene on click
-(void)local_leaderboard {
    NSLog(@"Clicked local leaderboards");
    CCScene *leaderboardScene = [CCBReader loadAsScene:@"LocalLeaderboard"];
    [[CCDirector sharedDirector] replaceScene:leaderboardScene];
}
//load global leaderboard scene on click
-(void) global_leaderboard {
    NSLog(@"Clicked global leaderboards");
    CCScene *leaderboardScene = [CCBReader loadAsScene:@"GlobalLeaderboard"];
    [[CCDirector sharedDirector] replaceScene:leaderboardScene];
}
@end
