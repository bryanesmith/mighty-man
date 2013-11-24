//
//  BSMyScene.m
//  MightyMan
//
//  Created by Bryan Smith on 11/14/13.
//  Copyright (c) 2013 Bryan Smith. All rights reserved.
//

#import "BSMyScene.h"

// Import: Data
#import "BSMightyMan.h"
#import "BSCloud.h"

@interface BSMyScene ()

//@property (nonatomic, weak) UITouch *touch;

@property (nonatomic, weak) UITouch *rightTouch;
@property (nonatomic, weak) UITouch *leftTouch;

@end

@implementation BSMyScene

static const uint32_t FrameCategory = 0x1 << 1;
static const uint32_t MightyMan = 0x1 << 2;
static const uint32_t GroundCategory = 0x1 << 1;

static const float CenterScreen = 250.0;

#pragma mark - SKScene methods

-(void)update:(NSTimeInterval)currentTime {
    
    if (self.rightTouch) {
        [self performStageAdvances];
    }
    
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        UIColor *bgColor = [UIColor colorWithRed:101/255.0
                                           green:159/255.0
                                            blue:255.0/255.0
                                           alpha:1.0];
        self.backgroundColor = bgColor;
        
        [self addGround];
        [self addMightyMan];
        [self addClouds]   ;
        
        self.physicsWorld.gravity = CGVectorMake(0, -3); // 0, -2
    }
    return self;
}

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

#pragma mark - Adding nodes

- (void) addMightyMan {
    BSMightyMan *mightyMan = [BSMightyMan node];
    
    mightyMan.physicsBody.categoryBitMask = MightyMan;
    mightyMan.physicsBody.collisionBitMask = GroundCategory;
//    mightyMan.contactTestBitMask = ...;
    
    [self addChild:mightyMan];
}

- (void) addGround {
    
    // http://stackoverflow.com/a/19353158
    for (int i = 0; i < 2; i++) {
        SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"MegaManPlatform.jpg"];
        
        ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground.size];
        
//        ground.anchorPoint = CGPointZero;
        ground.position = CGPointMake(i * ground.size.width, 20);
        ground.name = @"Ground";
        ground.physicsBody.dynamic = NO;
        ground.physicsBody.categoryBitMask = GroundCategory;
        ground.physicsBody.collisionBitMask = MightyMan;
        
        [self addChild:ground];
    }
}

- (void) addClouds {
    
    BSCloud *cloud1 = [BSCloud nodeForTextName:@"Cloud1"
                                            at:CGPointMake(200, 150)];
    [self addChild:cloud1];
    
    BSCloud *cloud2 = [BSCloud nodeForTextName:@"Cloud1"
                                            at:CGPointMake(350, 200)];
    [self addChild:cloud2];
    
    BSCloud *cloud3 = [BSCloud nodeForTextName:@"Cloud1"
                                            at:CGPointMake(550, 75)];
    [self addChild:cloud3];
}

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

#pragma mark - UIResponder

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    [self setTouch:touch];
    
    BOOL rightTouch = [self isRightTouch:touch];
    
    if (rightTouch) {
        [self performRun];
    } else {
        [self performShoot];
    }
}

-(void)touchesMoved:(NSSet *)touches
          withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    [self setTouch:touch];
    
    // Check for jump
    if ([self isHighTouch:self.rightTouch]) {
        [self performJump];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.touch = nil;
    
    UITouch *touch = [touches anyObject];
    BOOL isRight = [self isRightTouch:touch];
    
    if (isRight) {
        BSMightyMan *mightyMan = (BSMightyMan *)[self childNodeWithName:@"MightyMan"];
        [mightyMan performStand];
    }
}

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

#pragma mark - UIResponder

- (void) setTouch:(UITouch *)touch {
    BOOL isRight = [self isRightTouch:touch];
    if (isRight) {
        self.rightTouch = touch;
    } else {
        self.leftTouch = touch;
    }
}

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

#pragma mark - Test methods

- (BOOL) isRightTouch:(UITouch *)touch {
    CGPoint location = [touch locationInView:touch.view];
    return CenterScreen < location.x;
}

- (BOOL) isHighTouch:(UITouch *)touch {
    CGPoint location = [self.rightTouch locationInView:self.rightTouch.view];
    return location.y <= 125;
}

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

#pragma mark - Perform actions

- (void) performShoot {
    BSMightyMan *mightyMan = (BSMightyMan *)[self childNodeWithName:@"MightyMan"];
    [mightyMan performShoot];
}

- (void) performRun {
    
    BSMightyMan *mightyMan = (BSMightyMan *)[self childNodeWithName:@"MightyMan"];
    [mightyMan performRun];
    
    // Check for jump
    if ([self isHighTouch:self.rightTouch]) {
        [self performJump];
    }
}

- (void) performJump {
    BSMightyMan *mightyMan = (BSMightyMan *)[self childNodeWithName:@"MightyMan"];
    [mightyMan performJump];
}

- (void) performStageAdvances {
    [self enumerateChildNodesWithName:@"Ground"
                           usingBlock: ^(SKNode *node, BOOL *stop) {
                               SKSpriteNode *bg = (SKSpriteNode *) node;
                               bg.position = CGPointMake(bg.position.x - 3, bg.position.y);
                               
                               if (bg.position.x <= -bg.size.width) {
                                   bg.position = CGPointMake(bg.position.x + bg.size.width * 2, bg.position.y);
                               }
                           }];
}

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

#pragma mark - Handle touches

- (void) didEndContact:(SKPhysicsContact *)contact {
    NSLog(@"%@ hit %@ with impulse %f", contact.bodyA.node.name, contact.bodyB.node.name, contact.collisionImpulse);
}

@end
