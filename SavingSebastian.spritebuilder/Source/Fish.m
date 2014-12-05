//
//  Fish.m
//  SavingSebastian
//
//  Created by Ariana Antonio on 11/30/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Fish.h"

@implementation Fish

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"fish";
    NSLog(@"Fish test");
}

@end
