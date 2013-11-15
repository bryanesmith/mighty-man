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

static const uint32_t WallCategory = 0x1 << 1;
static const uint32_t MightyMan = 0x1 << 2;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        UIColor *bgColor = [UIColor colorWithRed: 135/255.0 green: 206/255.0 blue:250.0/255.0 alpha: 1.0];
        self.backgroundColor = bgColor;
        
        [self addGround];
        [self addMightyMan];
    }
    return self;
}

- (void) addMightyMan {
    BSMightyMan *mightyMan = [BSMightyMan node];
    mightyMan.physicsBody.categoryBitMask = MightyMan;
    mightyMan.physicsBody.collisionBitMask = WallCategory;
//    mightyMan = ...;
    
    [self addChild:mightyMan];
}

- (void) addGround {
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    NSLog(@"DEBUG: %f %f", self.frame.size.height, self.frame.size.width);
    
    self.physicsWorld.contactDelegate = self;
    self.physicsBody.categoryBitMask = WallCategory;
    self.physicsBody.collisionBitMask = MightyMan;
    
    self.physicsWorld.gravity = CGVectorMake(0, -0.5); // 0, -2
    self.name = @"ground";
}

- (void) didEndContact:(SKPhysicsContact *)contact {
    NSLog(@"%@ hit %@ with impulse %f", contact.bodyA.node.name, contact.bodyB.node.name, contact.collisionImpulse);
}

@end
