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
@end
