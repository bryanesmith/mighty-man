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

+ (id) node {
    
    SKTextureAtlas *texture_atlas = [SKTextureAtlas atlasNamed:@"MightyMan"];
    SKTexture *standing = [texture_atlas textureNamed:@"MightyMan1"];
    
    BSMightyMan *mightyMan = [[BSMightyMan alloc] initWithTexture:standing];
    
    mightyMan.standingFrame = standing;
    mightyMan.runningFrames = @[ [texture_atlas textureNamed:@"MightyMan2"],
                                 [texture_atlas textureNamed:@"MightyMan3"],
                                 [texture_atlas textureNamed:@"MightyMan4"]];
    
    mightyMan.position = CGPointMake(80, 40);
    mightyMan.size = CGSizeMake(53, 55);
    mightyMan.name = @"MightyMan";
    
    mightyMan.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:mightyMan.size];
    mightyMan.physicsBody.restitution = 0.0;
    mightyMan.physicsBody.mass = 1;
    
    
    return mightyMan;
}

- (void) setRunning {
    [self removeAllActions];
    SKAction *loop = [SKAction repeatActionForever:[SKAction animateWithTextures:self.runningFrames
                                                                    timePerFrame:0.15]];
    [self runAction:loop];
}

-(void) setStanding {
    [self removeAllActions];
    self.texture = self.standingFrame;
}

@end
