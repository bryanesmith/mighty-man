//
//  BSMyScene.m
//  MightyMan
//
//  Created by Bryan Smith on 11/14/13.
//  Copyright (c) 2013 Bryan Smith. All rights reserved.
//

#import "BSMyScene.h"
#import "BSMightyMan.h"

@implementation BSMyScene

static const uint32_t FrameCategory = 0x1 << 1;
static const uint32_t MightyMan = 0x1 << 2;
static const uint32_t GroundCategory = 0x1 << 1;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        UIColor *bgColor = [UIColor colorWithRed:135/255.0
                                           green:206/255.0
                                            blue:250.0/255.0
                                           alpha:1.0];
        self.backgroundColor = bgColor;
        
        [self addGround];
        [self addMightyMan];
        
        self.physicsWorld.gravity = CGVectorMake(0, -1.0); // 0, -2
    }
    return self;
}

- (void) addMightyMan {
    BSMightyMan *mightyMan = [BSMightyMan node];
    mightyMan.physicsBody.categoryBitMask = MightyMan;
    mightyMan.physicsBody.collisionBitMask = FrameCategory | GroundCategory;
//    mightyMan = ...;
    
    [self addChild:mightyMan];
}

- (void) addGround {
    SKShapeNode *ground = [[SKShapeNode alloc] init];
    CGRect groundRect = CGRectMake(0, 0, self.frame.size.width, 50);
    ground.path = [[UIBezierPath bezierPathWithRect:groundRect] CGPath];
//    ground.fillColor = [UIColor brownColor];
    
    ground.strokeColor = ground.fillColor;
    ground.name = @"Ground";
    ground.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:ground.path];
    
    [self addChild:ground];
    
    self.physicsWorld.contactDelegate = self;
    self.physicsBody.categoryBitMask = GroundCategory;
    self.physicsBody.collisionBitMask = MightyMan;
}

- (void) didEndContact:(SKPhysicsContact *)contact {
    NSLog(@"%@ hit %@ with impulse %f", contact.bodyA.node.name, contact.bodyB.node.name, contact.collisionImpulse);
}

@end
