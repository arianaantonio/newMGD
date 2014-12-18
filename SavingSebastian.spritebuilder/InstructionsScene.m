//
//  InstructionsScene.m
//  SavingSebastian
//
//  Created by Ariana Antonio on 12/15/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "InstructionsScene.h"

@implementation InstructionsScene
{
    
}

- (void)didLoadFromCCB {
    self.userInteractionEnabled = TRUE;

}

//load main menu on click
-(void)backToMenu {
    
    CCScene *mainMenu = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainMenu];
}
@end
