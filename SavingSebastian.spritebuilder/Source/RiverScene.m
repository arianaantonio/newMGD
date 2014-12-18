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
    CCLabelTTF *_highScoreLabel;
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_gameOverLabel;
    CCSprite *_poof;
    CCSprite *_endScene;
    CCButton *_replayButton;
}
- (void)didLoadFromCCB {
    self.userInteractionEnabled = TRUE;
    
    isPaused = NO;
    isDead = NO;
    score = 0;
    first = 0;
    //remove sprites to add later when game ends
    [self removeChild:_endScene];
    [self removeChild:_scoreLabel];
    [self removeChild:_gameOverLabel];
    [self removeChild:_highScoreLabel];
    [self removeChild:_replayButton];

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
    _log = (CCSprite *)[CCBReader load:@"Log"];
    [_physicsNode addChild:_log];
    _log.physicsBody.collisionType = @"log";
    _log.physicsBody.sensor = TRUE;
    [_log setScaleX:.3];
    [_log setScaleY:.3];
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
    _poof = (CCSprite *)[CCBReader load:@"Poof"];
    
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

    //add end scene sprites
    [self addChild:_endScene];
    [self addChild:_scoreLabel];
    [self addChild:_gameOverLabel];
    [self addChild:_replayButton];
    [_physicsNode removeChild:_bear];
    [_physicsNode removeChild:_fish];
    if ([_log isRunningInActiveScene]) {
        [_physicsNode removeChild:_log];
    }
    
    //stop fish animation
    CCAnimationManager* animationManager = _fish.userObject;
    [animationManager setPaused:YES];
    NSString *newScoreStr = [NSString stringWithFormat:@"%i", score];
    
    //show score
    _scoreLabel.string = [NSString stringWithFormat:@"Score: %@", newScoreStr];
    
    //compare old score to new score
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *oldScore = [defaults objectForKey:@"highScore"];
    int oldInt = [oldScore intValue];
    
    if (oldInt < score) {
        //set a new high score in defaults
        NSLog(@"New high score!");
        [defaults setObject:newScoreStr forKey:@"highScore"];
        _highScoreLabel.string = @"NEW HIGH SCORE!";
    } else if (oldInt > score) {
        //do nothing with defaults score
        NSLog(@"No new high score");
        _highScoreLabel.string = @"";
    } else {
        //set for first time
        [defaults setObject:newScoreStr forKey:@"highScore"];
        NSLog(@"First time");
    }
    [self addChild:_highScoreLabel];
    NSLog(@"Number: %i", score);
    return TRUE;
}
//when fish collides with log
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero log:(CCNode *)log {
    
    NSLog(@"Log collision");
    
    //move the fish down 50 and create poof right above fish
    _fish.position = ccp(_fish.position.x, _fish.position.y-50);
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"thud.mp3"];
    _poof.position = ccp(_fish.position.x, _fish.position.y+50);
 
    //add poof sprite if it doesn't already exists on node
    if (first == 0) {
        if (![_poof isRunningInActiveScene]) {
            [self addChild:_poof];
        }
        first++;
    } else {
        first = 0;
    }
    return TRUE;
}
//when log collides with bear
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair log:(CCNode *)log level:(CCNode *)level {
    
    NSLog(@"Hit collision");
    
    //remove log
    if ([_log isRunningInActiveScene]) {
        [_physicsNode removeChild:_log];
        score++;
    }
    //increment score
    _timerLabel.string = [NSString stringWithFormat:@"%i", score];
    return TRUE;
}
- (void)ccPhysicsCollisionSeparate:(CCPhysicsCollisionPair *)pair log:(CCNode *)log level:(CCNode *)level {
    NSLog(@"Hit separate");
    
    if (![_log isRunningInActiveScene]) {
        
        //randomly generate new log
        CGFloat random = ((double)arc4random_uniform(120) + 130);
        _log = (CCSprite *)[CCBReader load:@"Log"];
        _log.position = ccp(random,400);
        [_log setScaleX:.3];
        [_log setScaleY:.3];
        _log.physicsBody.collisionType = @"log";
        _log.physicsBody.sensor = TRUE;
        [_physicsNode addChild:_log];
    }
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
        if ([_poof isRunningInActiveScene]) {
            [self removeChild:_poof];
        }
        [newTimer invalidate];
    }
}
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
//go back to main menu
-(void)backToMenu {
    CCScene *mainMenu = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainMenu];
}
@end
