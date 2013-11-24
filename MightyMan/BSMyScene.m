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

@property (nonatomic, weak) UITouch *rightTouch;
@property (nonatomic, weak) UITouch *leftTouch;
@property (nonatomic, strong) NSMutableArray *groundUnits;
@property (nonatomic, strong) NSArray *groundImageNames;

@end

@implementation BSMyScene

#pragma mark - Constants

static const uint32_t FrameCategory = 0x1 << 1;
static const uint32_t MightyManCategory = 0x1 << 2;
static const uint32_t GroundCategory = 0x1 << 1;

static const float ScreenLeftRightSplitPos = 250.0;
static const float ScreenTopBottomSplitPos = 125.0;

static const uint32_t GroundUnitsTotal = 4;


// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

#pragma mark - SKScene methods

-(void)update:(NSTimeInterval)currentTime {
    
    // Moving?
    if (self.rightTouch) {
        
        BSMightyMan *mightyMan = (BSMightyMan *)[self childNodeWithName:@"MightyMan"];
        
        // Don't move if shooting from the ground
        if (!mightyMan.isGroundShooting) {
            [self performStageAdvances];
        }
        
        [self addNecessaryGround];
    }
    
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        UIColor *bgColor = [UIColor colorWithRed:101/255.0
                                           green:159/255.0
                                            blue:255.0/255.0
                                           alpha:1.0];
        self.backgroundColor = bgColor;
        
        [self addNecessaryGround];
        [self addMightyMan];
        [self addClouds]   ;
        
        self.physicsWorld.gravity = CGVectorMake(0, -3); // 0, -2
        
        self.physicsWorld.contactDelegate = self;
    }
    return self;
}

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

#pragma mark - Adding nodes

- (void) addMightyMan {
    BSMightyMan *mightyMan = [BSMightyMan node];
    
    mightyMan.physicsBody.categoryBitMask = MightyManCategory;
    mightyMan.physicsBody.collisionBitMask = GroundCategory;
//    mightyMan.physicsBody.contactTestBitMask = GroundCategory;
    
    [self addChild:mightyMan];
}

- (void) addNecessaryGround {
    
    if (!self.groundUnits) {
        self.groundUnits = [[NSMutableArray alloc] init];
    }
    
    for (int i = self.groundUnits.count; i < GroundUnitsTotal; i++) {
        [self addGround];
    }
}

- (void) addGround {
    
    NSString *imgName = [self getRandomGroundImageName];
    SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:imgName];
    
    ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground.size];
    
    float x = 0;
    if (self.groundUnits.count > 0) {
        SKSpriteNode * lastGround = self.groundUnits.lastObject;
        x = lastGround.position.x + lastGround.size.width;
    } else {
        x = ground.size.width / 2;
    }
    
    //float y = 20;
    float y = ground.size.height / 2;
    ground.position = CGPointMake(x, y);
    ground.name = @"Ground";
    ground.physicsBody.dynamic = NO;
    ground.physicsBody.categoryBitMask = GroundCategory;
    ground.physicsBody.collisionBitMask = MightyManCategory;
//    ground.physicsBody.contactTestBitMask = MightyManCategory;
    
    [self addChild:ground];
    [self.groundUnits addObject:ground];
}

- (void) addClouds {
    
    BSCloud *cloud1 = [BSCloud nodeForTextName:@"Cloud1"
                                            at:CGPointMake(200, 150)];
    [self addChild:cloud1];
    
    BSCloud *cloud2 = [BSCloud nodeForTextName:@"Cloud2"
                                            at:CGPointMake(350, 200)];
    [self addChild:cloud2];
    
    BSCloud *cloud3 = [BSCloud nodeForTextName:@"Cloud1"
                                            at:CGPointMake(550, 75)];
    [self addChild:cloud3];
}

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

#pragma mark - Removing nodes

- (void) removeGround:(SKSpriteNode *) ground {
    [self.groundUnits removeObject:ground];
    [ground removeFromParent];
}

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

#pragma mark - UIResponder

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    [self setTouch:touch];
    
    BOOL rightTouch = [self isRightTouch:touch];
    
    if (rightTouch) {
        
        if ([self isHighTouch:self.rightTouch]) {
            [self performJump];
        } else {
            [self performRun];
        }
        
    } else {
        [self performShoot];
    }
}

-(void)touchesMoved:(NSSet *)touches
          withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    [self setTouch:touch];
    
    BOOL rightTouch = [self isRightTouch:touch];
    
    // Check for jump
    if (rightTouch) {
        if ([self isHighTouch:self.rightTouch]) {
            [self performJump];
        }
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

#pragma mark - Set game state

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
    return ScreenLeftRightSplitPos < location.x;
}

- (BOOL) isHighTouch:(UITouch *)touch {
    CGPoint location = [self.rightTouch locationInView:self.rightTouch.view];
    return location.y <= ScreenTopBottomSplitPos;
}

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

#pragma mark - Perform actions

- (void) performShoot {
    
    BSMightyMan *mightyMan = (BSMightyMan *)[self childNodeWithName:@"MightyMan"];
    
    // Prevent rapid fire
    if (mightyMan.isShooting) {
        return;
    }
    
    // Update might man
    [mightyMan performShoot];
    
    // Add and animate shot
    SKSpriteNode *photon = [SKSpriteNode spriteNodeWithImageNamed:@"Photon"];
    photon.name = @"Photon";
    
    CGPoint pos = CGPointMake(mightyMan.position.x, mightyMan.position.y);
    
    // Voodoo math: align photon with shooter
    if (mightyMan.isJumping) {
        pos.y += 7;
    } else {
        pos.y -= 7;
    }
    
    photon.position = pos;
    [self addChild:photon];
    
    SKAction *fly = [SKAction moveToX:self.size.width+photon.size.width
                             duration:1];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *sound = [SKAction playSoundFileNamed:@"shoot.m4a" waitForCompletion:NO];
    SKAction *fireAndRemove = [SKAction sequence:@[sound, fly, remove]];
    [photon runAction:fireAndRemove];
    
}

- (void) performRun {
    BSMightyMan *mightyMan = (BSMightyMan *)[self childNodeWithName:@"MightyMan"];
    [mightyMan performRun];
}

- (void) performJump {
    BSMightyMan *mightyMan = (BSMightyMan *)[self childNodeWithName:@"MightyMan"];
    [mightyMan performJump];
}

- (void) performStageAdvances {
    
    [self enumerateChildNodesWithName:@"Ground"
                           usingBlock: ^(SKNode *node, BOOL *stop) {
                               SKSpriteNode *ground = (SKSpriteNode *) node;
                               ground.position = CGPointMake(ground.position.x - 3, ground.position.y);
                               
                               BOOL disappeared = ground.position.x <= -ground.size.width;
                               
                               // If offscreen, remove
                               if (disappeared) {
                                   [self removeGround:ground];
                               }
                           }];
}

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

#pragma mark - Handle contact

- (void) didEndContact:(SKPhysicsContact *)contact {
    NSLog(@"%@ hit %@ with impulse %f", contact.bodyA.node.name, contact.bodyB.node.name, contact.collisionImpulse);
}


// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

#pragma mark - Random generators

- (NSString *) getRandomGroundImageName {
    
    if (! self.groundImageNames) {
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"MightyManPlatform"];
        self.groundImageNames = [[NSArray alloc] initWithArray:atlas.textureNames];
        
        // Sort by name so can use 1.jpg as consistent starting texture
        self.groundImageNames = [self.groundImageNames sortedArrayUsingSelector:@selector(compare:)];
    }
    
    int randomIdx = 0; // If no images, start with first image
    
    if (self.groundUnits.count > 0) {
        int count = self.groundImageNames.count;
        randomIdx = arc4random() % count;
    }
    
    return [self.groundImageNames objectAtIndex:randomIdx];
}

@end
