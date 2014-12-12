//
//  RiverScene.m
//  SavingSebastian
//
//  Created by Ariana Antonio on 12/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "RiverScene.h"
#import "Bear.h"
static const CGFloat scrollSpeed = 50.f;
static const CGFloat logScrollSpeed = 90.f;

@implementation RiverScene
{
    CCPhysicsNode *_physicsNode;
    CCSprite *_fish;
    CCSprite *_bear;
    CCSprite *_log;
    CCLabelTTF *_timerLabel;
    CCSprite *_poof;
    CCNode *_leftBank;
}
- (void)didLoadFromCCB {
    self.userInteractionEnabled = TRUE;
    
    isPaused = NO;
    isDead = NO;
    score = 0;
    first = 0;

    //setting collision delegate
    _physicsNode.collisionDelegate = self;
    
    //setting fish to hero collision
    _fish.physicsBody.collisionType = @"hero";
    _fish.physicsBody.sensor = TRUE;
    NSLog(@"Fish: %f", _fish.position.x);
    
    //setting bear to level collision and telling it to fire when a collision occurs
    _bear.physicsBody.collisionType = @"level";
    _bear.physicsBody.sensor = TRUE;
    
    //_leftBank.physicsBody.collisionType = @"edge";
    //_leftBank.physicsBody.sensor = TRUE;
    
    //setting log to level collision and telling it to fire when a collision occurs
    _log = (CCSprite *)[CCBReader load:@"Log"];
    [_physicsNode addChild:_log];
    _log.physicsBody.collisionType = @"log";
    _log.physicsBody.sensor = TRUE;
    _log.position = ccp(200,420);
    //log range:120-250    arc4random_uniform(120) + 130
    
    //set up left swipe
    UISwipeGestureRecognizer *swipeLeftGesture= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeLeftGesture];
    
    //set up right swipe
    UISwipeGestureRecognizer *swipeRightGesture= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeRightGesture];

    startDate = [NSDate date];
    [self countdownTimer];
    _poof = (CCSprite *)[CCBReader load:@"Poof"];
    
}

-(void)countdownTimer{
    
    [myTimer fire];
    myTimer = [NSTimer scheduledTimerWithTimeInterval:.01f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    [myTimer fire];
}
//setting the timer
- (void)updateCounter:(NSTimer *)theTimer {

    _timerLabel.string = [NSString stringWithFormat:@"%i", score];
    timeInt++;
    //NSLog(@"%i", timeInt);
    
    //after 500 milliseconds, generate a log with a random x position
    if (timeInt == 500) {
        CGFloat random = ((double)arc4random_uniform(120) + 130);
        _log.position = ccp(random,400);
        [_physicsNode addChild:_log];
        timeInt = 0;
    }
}
- (void)swipeLeft {
    NSLog(@"Left swipe");
    if (!isPaused) {
        //move fish to the left within the screen limit
        if (_fish.position.x > 100) {
            _fish.position = ccp(_fish.position.x -35, _fish.position.y);
        }
    }
}
- (void)swipeRight {
    NSLog(@"Right swipe");
    if (!isPaused) {
        //move fish to the right within the screen limit
        if (_fish.position.x < 270) {
            _fish.position = ccp(_fish.position.x +35, _fish.position.y);
        }
    }
}
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    //get the location of the tap
    CGPoint tapLocation = [touch locationInView: [touch view]];
    tapLocation = [[CCDirector sharedDirector] convertToGL:tapLocation];
    
    //if it collides with the fish...
    if (CGRectContainsPoint( [_fish  boundingBox], tapLocation)) {
        if (!isPaused) {
            //NSLog(@"Fish tapped");
            
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
    if (!isPaused && !isDead) {
        _log.position = ccp(_log.position.x, _log.position.y - delta * logScrollSpeed);
        _fish.position = ccp(_fish.position.x, _fish.position.y - delta * scrollSpeed);
    }
}
//detecting when a collision occurs between the fish and the bear or log
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero level:(CCNode *)level {
    NSLog(@"You lost");
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"BearRoar.wav"];
    isDead = YES;
    [myTimer invalidate];
    
    //stop fish animation
    CCAnimationManager* animationManager = _fish.userObject;
    [animationManager setPaused:YES];
    NSString *newScoreStr = [NSString stringWithFormat:@"%i", score];
    
    //compare old score to new score
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *oldScore = [defaults objectForKey:@"highScore"];
    int oldInt = [oldScore intValue];
    
    if (oldInt < score) {
        //set a new high score in defaults
        NSLog(@"New high score!");
        [defaults setObject:newScoreStr forKey:@"highScore"];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"New high score!" message:[NSString stringWithFormat:@"You're dead. You finished with a score of %@. Please play again.", newScoreStr] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else if (oldInt > score) {
        //do nothing with defaults score
        NSLog(@"No new high score");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Ouch!" message:[NSString stringWithFormat:@"You're dead. You finished with a score of %@. Please play again.", newScoreStr] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        //set for first time
        [defaults setObject:newScoreStr forKey:@"highScore"];
        NSLog(@"First time");
    }
    
    NSLog(@"Number: %i", score);
    return TRUE;
}
//when fish collides with bear
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero log:(CCNode *)log {
    
    NSLog(@"Log collision");
    _fish.position = ccp(_fish.position.x, _log.position.y-100);
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"thud.mp3"];
    _poof.position = ccp(_fish.position.x, _fish.position.y+50);
 
    //add poof sprite if it doesn't already exists on node
    if (first == 0) {
        [self addChild:_poof];
        first++;
    } else {
        first = 0;
    }
    return TRUE;
}
//when log collides with bear
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair log:(CCNode *)log level:(CCNode *)level {
    [_physicsNode removeChild:_log];
    //increment score
    score++;
    _timerLabel.string = [NSString stringWithFormat:@"%i", score];
    return TRUE;
}
//when fish and log uncollide
- (void)ccPhysicsCollisionSeparate:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero log:(CCNode *)log {
    NSLog(@"Log separation");
    //set off timer to remove poof sprite, otherwise it's too fast to see
    newTimer = [NSTimer scheduledTimerWithTimeInterval:.01f target:self selector:@selector(poofTimer:) userInfo:nil repeats:YES];
    [newTimer fire];
    first = 0;
}

-(void)poofTimer:(NSTimer *)timer {
    
    //remove poof sprite after interval
    NSTimeInterval interval = [startDate timeIntervalSinceNow];
    double intpart;
    double fraction = modf(interval, &intpart);
    NSUInteger hundredths = ABS((int)(fraction*100));
    //NSLog(@"Time: %02lu", hundredths);
    if (hundredths > 30) {
        NSLog(@"Inside invalidate");
        [self removeChild:_poof];
        [newTimer invalidate];
    }
}
/*
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero edge:(CCNode *)edge {
    NSLog(@"Hit bank");
    //_fish.position = ccp(_fish.position.x+50, _fish.position.y);
    return TRUE;
}*/
//pause button hit
-(void)pause {
    NSLog(@"Paused");
    CCAnimationManager* animationManager = _fish.userObject;
    
    //toggle pause
    if (isPaused) {
        isPaused = NO;
        [animationManager setPaused:NO];
    } else {
        isPaused = YES;
        [animationManager setPaused:YES];
    }
}
-(void)restart {
    NSLog(@"Restarted");
    //load the main River Scene when user clicks "Restart"
    CCScene *riverScene = [CCBReader loadAsScene:@"RiverScene"];
    [[CCDirector sharedDirector] replaceScene:riverScene];
}
@end
