//
//  BSMyScene.m
//  MightyMan
//
//  Created by Bryan Smith on 11/14/13.
//  Copyright (c) 2013 Bryan Smith. All rights reserved.
//

#import "BSMyScene.h"
#import "BSMightyMan.h"

@interface BSMyScene ()

@property (nonatomic, weak) UITouch *touch;

@end

@implementation BSMyScene

static const uint32_t FrameCategory = 0x1 << 1;
static const uint32_t MightyMan = 0x1 << 2;
static const uint32_t GroundCategory = 0x1 << 1;

-(void)update:(NSTimeInterval)currentTime {
    
    if (self.touch) {
        [self enumerateChildNodesWithName:@"Ground" usingBlock: ^(SKNode *node, BOOL *stop) {
            SKSpriteNode *bg = (SKSpriteNode *) node;
            bg.position = CGPointMake(bg.position.x - 3, bg.position.y);
            
            if (bg.position.x <= -bg.size.width) {
                bg.position = CGPointMake(bg.position.x + bg.size.width * 2, bg.position.y);
            }
        }];
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
        [self addClouds];
        
        self.physicsWorld.gravity = CGVectorMake(0, -1.5); // 0, -2
    }
    return self;
}

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

float totalCloudDuration = 60.0;
- (void) addClouds {
    SKSpriteNode *cloud1 = [SKSpriteNode spriteNodeWithImageNamed:@"Cloud1.png"];
    cloud1.name = @"Cloud1";
    cloud1.position = CGPointMake(200, 150);
    [self moveCloud:cloud1];
    [self addChild:cloud1];
    
    SKSpriteNode *cloud2 = [SKSpriteNode spriteNodeWithImageNamed:@"Cloud2.png"];
    cloud2.name = @"Cloud2";
    cloud2.position = CGPointMake(400, 200);
    [self moveCloud:cloud2];
    
    [self addChild:cloud2];
}

- (void) moveCloud:(SKSpriteNode *) cloud {
    
    float offScreenAdj = 40.0;
    
    float duration = [self getCloudDurationFromPosition:cloud.position.x];
    
    SKAction *move1 = [SKAction moveToX: -offScreenAdj                                   duration:duration];
    SKAction *move2 = [SKAction runBlock:^{
        [cloud setPosition: CGPointMake(self.size.width + offScreenAdj, cloud.position.y)];
    }];
    SKAction *move3 = [SKAction moveToX: -offScreenAdj                                   duration:totalCloudDuration];
    
    SKAction *loop = [SKAction repeatActionForever:[SKAction sequence:@[move2, move3]]];
    
    SKAction *go = [SKAction sequence:@[move1, loop]];
    
    [cloud runAction:go];
}

- (CGFloat) getCloudDurationFromPosition:(CGFloat) x {
    return totalCloudDuration * (x / self.size.width);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.touch = [touches anyObject];
    
    BSMightyMan *mightyMan = (BSMightyMan *)[self childNodeWithName:@"MightyMan"];
    [mightyMan setRunning];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    self.touch = [touches anyObject];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.touch = nil;
    
    BSMightyMan *mightyMan = (BSMightyMan *)[self childNodeWithName:@"MightyMan"];
    [mightyMan setStanding];
}

- (void) didEndContact:(SKPhysicsContact *)contact {
    NSLog(@"%@ hit %@ with impulse %f", contact.bodyA.node.name, contact.bodyB.node.name, contact.collisionImpulse);
}

@end
