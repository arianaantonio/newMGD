//
//  RiverScene.m
//  SavingSebastian
//
//  Created by Ariana Antonio on 12/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "RiverScene.h"
#import "Bear.h"
static const CGFloat scrollSpeed = 60.f;

@implementation RiverScene
{
CCPhysicsNode *_physicsNode;
CCSprite *_fish;
CCSprite *_bear;
CCSprite *_log;
}
- (void)didLoadFromCCB {
    self.userInteractionEnabled = TRUE;
    
    isPaused = NO;

    //setting collision delegate
    _physicsNode.collisionDelegate = self;
    
    //setting fish to hero collision
    _fish.physicsBody.collisionType = @"hero";
    _fish.physicsBody.sensor = TRUE;
    NSLog(@"Fish: %f", _fish.position.x);
    
    //setting bear to level collision and telling it to fire when a collision occurs
    _bear.physicsBody.collisionType = @"level";
    _bear.physicsBody.sensor = TRUE;
    
    //setting log to level collision and telling it to fire when a collision occurs
    _log.physicsBody.collisionType = @"level";
    _log.physicsBody.sensor = TRUE;
    
    //set up left swipe
    UISwipeGestureRecognizer *swipeLeftGesture= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeLeftGesture];
    
    //set up right swipe
    UISwipeGestureRecognizer *swipeRightGesture= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeRightGesture];
    
}
- (void)swipeLeft {
    NSLog(@"Left swipe");
    if (!isPaused) {
        //move fish to the left
        _fish.position = ccp(_fish.position.x -35, _fish.position.y);
    }
}
- (void)swipeRight {
    NSLog(@"Right swipe");
    if (!isPaused) {
        //move fish to the right
        _fish.position = ccp(_fish.position.x +35, _fish.position.y);
    }
}
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    //get the location of the tap
    CGPoint tapLocation = [touch locationInView: [touch view]];
    tapLocation = [[CCDirector sharedDirector] convertToGL:tapLocation];
    
    //if it collides with the fish...
    if (CGRectContainsPoint( [_fish  boundingBox], tapLocation)) {
        if (!isPaused) {
            NSLog(@"Fish tapped");
            
            //play sound effect when player taps screen
            OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
            [audio playEffect:@"WaterDrip.wav"];
            
            //move the fish up 10
            _fish.position = ccp(_fish.position.x, _fish.position.y +10);
        }
    }
}
//update position of fish and log based on CCTime
- (void)update:(CCTime)delta {
    if (!isPaused) {
        _log.position = ccp(_log.position.x, _log.position.y - delta * scrollSpeed);
        _fish.position = ccp(_fish.position.x, _fish.position.y - delta * scrollSpeed);
    }
}
//detecting when a collision occurs between the fish and the bear or log
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero level:(CCNode *)level {
    NSLog(@"You lost");
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"BearRoar.wav"];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Ouch!" message:@"You're dead. Please play again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    return TRUE;
}
-(void)pause {
    NSLog(@"Paused");
    
    //toggle pause
    if (isPaused) {
        isPaused = NO;
    } else {
        isPaused = YES;
    }
}
-(void)restart {
    NSLog(@"Restarted");
    //load the main River Scene when user clicks "Restart"
    CCScene *riverScene = [CCBReader loadAsScene:@"RiverScene"];
    [[CCDirector sharedDirector] replaceScene:riverScene];
}
@end
