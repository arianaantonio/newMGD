//
//  RiverScene.m
//  SavingSebastian
//
//  Created by Ariana Antonio on 12/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "RiverScene.h"
#import "Bear.h"

@implementation RiverScene

CCPhysicsNode *physicsNode;
CCNode *_fish;
CCNode *_bear;
CCNode *_log;

- (void)didLoadFromCCB {
    self.userInteractionEnabled = TRUE;
    
    //setting collision delegate
    physicsNode.collisionDelegate = self;
    
    //setting fish to hero collision
    _fish.physicsBody.collisionType = @"hero";
    
    //setting bear to level collision and telling it to fire when a collision occurs
    _bear.physicsBody.collisionType = @"level";
    _bear.physicsBody.sensor = TRUE;
    
    //setting log to level collision and telling it to fire when a collision occurs
    _log.physicsBody.collisionType = @"level";
    _log.physicsBody.sensor = TRUE;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    //play sound effect when player taps screen
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"WaterDrip.wav"];
}

//detecting when a collision occurs between the fish and the bear or log
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero level:(CCNode *)level {
    NSLog(@"You lost");
    return TRUE;
}

@end
