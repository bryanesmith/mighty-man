//
//  BSMightyMan.m
//  MightyMan
//
//  Created by Bryan Smith on 11/14/13.
//  Copyright (c) 2013 Bryan Smith. All rights reserved.
//

#import "BSMightyMan.h"

@interface BSMightyMan ()
@property (strong) SKTexture *standingFrame;
@property (strong) NSArray *runningFrames;
@end

@implementation BSMightyMan

static CGSize spriteSize;

+ (id) node {
    
    SKTextureAtlas *texture_atlas = [SKTextureAtlas atlasNamed:@"MightyMan"];
    SKTexture *standing = [texture_atlas textureNamed:@"MightyMan1"];
    
    BSMightyMan *mightyMan = [[BSMightyMan alloc] initWithTexture:standing];
    
    mightyMan.standingFrame = standing;
    mightyMan.runningFrames = @[ [texture_atlas textureNamed:@"MightyMan2"],
                                 [texture_atlas textureNamed:@"MightyMan3"],
                                 [texture_atlas textureNamed:@"MightyMan4"],
                                 [texture_atlas textureNamed:@"MightyMan3"]];
    
    mightyMan.position = CGPointMake(80, 70);
    spriteSize = CGSizeMake(67, 60);
    mightyMan.size = spriteSize;
    mightyMan.name = @"MightyMan";
    
    // There's some blank space, so physics body is smaller
    mightyMan.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 59)];
    mightyMan.physicsBody.restitution = 0.0;
    mightyMan.physicsBody.mass = 1;
    
    
    return mightyMan;
}

- (void) setRunning {
    [self removeAllActions];
    SKAction *loop = [SKAction repeatActionForever:[SKAction animateWithTextures:self.runningFrames
                                                                    timePerFrame:0.1375]];
    [self runAction:loop];
}

-(void) setStanding {
    [self removeAllActions];
    self.texture = self.standingFrame;
    
    // TODO: Is this necessary? Was experiencing sporadic skewing.
    self.size = spriteSize;
}

@end
