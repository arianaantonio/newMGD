//
//  RiverScene.m
//  SavingSebastian
//
//  Created by Ariana Antonio on 12/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "RiverScene.h"
#import "Bear.h"
//static const CGFloat scrollSpeed = 50.f;
static const CGFloat scrollSpeed = 30.f;
//static const CGFloat logScrollSpeed = 90.f;
static const CGFloat burgerScrollSpeed = 50.f;

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
    CCLabelTTF *_powerUpLabel;
    CCSprite *_poof;
    CCSprite *_endScene;
    CCButton *_replayButton;
    CCSprite *_burger;
    CCSprite *_burger1;
    CCSprite *_burger2;
    CCSprite *_burger3;
    CCSprite *_burger4;
    CCSprite *_burger5;
}
- (void)didLoadFromCCB {
    self.userInteractionEnabled = TRUE;
    
    isPaused = NO;
    isDead = NO;
    score = 0;
    first = 0;
    logScrollSpeed = 40.f;
    burgerCount = 0;
    skipLogCount = 0;
    isPowerUp = NO;
    
    //remove sprites to add later when game ends
    [self removeChild:_endScene];
    [self removeChild:_scoreLabel];
    [self removeChild:_gameOverLabel];
    [self removeChild:_highScoreLabel];
    [self removeChild:_replayButton];
    [self removeChild:_burger1];
    [self removeChild:_burger2];
    [self removeChild:_burger3];
    [self removeChild:_burger4];
    [self removeChild:_burger5];
    [self removeChild:_powerUpLabel];
    
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
    _burger = (CCSprite *)[CCBReader load:@"Burger"];
    _burger.physicsBody.collisionType = @"burger";
    _burger.physicsBody.sensor = TRUE;
    
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
    //NSLog(@"Left swipe");
    if (!isPaused) {
        //move fish to the left within the screen limit
        if (_fish.position.x > 100) {
            _fish.position = ccp(_fish.position.x -35, _fish.position.y);
        }
    }
}
- (void)swipeRight {
    //NSLog(@"Right swipe");
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
        _burger.position = ccp(_burger.position.x, _burger.position.y - delta * burgerScrollSpeed);
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
    
    //react to collisions only when NOT in power up mode
    if (!isPowerUp) {
        //move the fish down 50 and create poof right above fish
        _fish.position = ccp(_fish.position.x, _fish.position.y-20);
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
    }
    return TRUE;
}
//when log collides with bear
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair log:(CCNode *)log level:(CCNode *)level {
    
    //remove log
    if ([_log isRunningInActiveScene]) {
        [_physicsNode removeChild:_log];
        score++;
    }
    //if scrore is a multiplier of 10, increase the log speed
    if (score % 10 == 0) {
        NSLog(@"Multiple of 10: %i", score);
        logScrollSpeed = logScrollSpeed+5;
    }
    //if it's a multiplier of two and not in power up mode, generate a burger
    if (score % 2 == 0 && !isPowerUp) {
        if (![_burger isRunningInActiveScene]) {
            CGFloat random = ((double)arc4random_uniform(120) + 130);
            _burger = (CCSprite *)[CCBReader load:@"Burger"];
            //_burger.position = ccp(105,400);
            _burger.position = ccp(random,400);
            [_burger setScaleX:1.5];
            [_burger setScaleY:1.5];
            _burger.physicsBody.collisionType = @"burger";
            _burger.physicsBody.sensor = TRUE;
            [_physicsNode addChild:_burger];
        }
    }
    //if in power up mode increase count until it reaches 12 (5 log collisions), then end power up mode
    if (isPowerUp) {
        skipLogCount++;
        if (skipLogCount == 12) {
            isPowerUp = NO;
            skipLogCount = 0;
            [self removeChild:_burger1];
            [self removeChild:_burger2];
            [self removeChild:_burger3];
            [self removeChild:_burger4];
            [self removeChild:_burger5];
            [self removeChild:_powerUpLabel];
        }
    }
    //increment score
    _timerLabel.string = [NSString stringWithFormat:@"%i", score];
    return TRUE;
}
- (void)ccPhysicsCollisionSeparate:(CCPhysicsCollisionPair *)pair log:(CCNode *)log level:(CCNode *)level {
    
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
//detect when the fish "eats" a burger
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair burger:(CCNode *)burger hero:(CCNode *)hero {
    
    //removie it from the screen and increment count
    [_physicsNode removeChild:_burger];
    burgerCount++;
    NSLog(@"Burgers eaten: %i", burgerCount);
    
    //add sprites based on num eaten
    switch (burgerCount) {
        case 1:
            [self addChild:_burger1];
            break;
        case 2:
            [self addChild:_burger2];
            break;
        case 3:
            [self addChild:_burger3];
            break;
        case 4:
            [self addChild:_burger4];
            break;
        case 5:
            //at 5 eaten, begin power up mode and reset count
            [self addChild:_burger5];
            [self addChild:_powerUpLabel];
            isPowerUp = YES;
            burgerCount = 0;
        default:
            break;
    }
    return TRUE;
}
//remove burger if it gets to the bear
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair burger:(CCNode *)burger level:(CCNode *)level {
    [_physicsNode removeChild:_burger];
    return TRUE;
}
//when fish and log uncollide
- (void)ccPhysicsCollisionSeparate:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero log:(CCNode *)log {

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
