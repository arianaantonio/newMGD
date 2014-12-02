//
//  Bear.m
//  SavingSebastian
//
//  Created by Ariana Antonio on 11/30/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Bear.h"

@implementation Bear

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"bear";
}
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    //play sound effect when player taps screen
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"BearRoar.wav"];
}

@end
