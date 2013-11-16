//
//  BSMightyMan.m
//  MightyMan
//
//  Created by Bryan Smith on 11/14/13.
//  Copyright (c) 2013 Bryan Smith. All rights reserved.
//

#import "BSMightyMan.h"

@implementation BSMightyMan

+ (id) node {
    
    // TODO: Switch to texture atlas and animate when moving
//    SKTextureAtlas *texture_atlas = [SKTextureAtlas atlasNamed:@"foo"];
//    BSMightyMan *mightyMan = [[BSMightyMan alloc] initWithTexture:[texture_atlas textureNamed:@"start"]];
//    mightyMan.frames = @[ [texture_atlas textureNamed:@"start"], [texture_atlas textureNamed:@"moving1"], ...];
    
    BSMightyMan *mightyMan = [BSMightyMan
                               spriteNodeWithImageNamed:@"MightyMan.png"];
    mightyMan.position = CGPointMake(50, 200);
    mightyMan.size = CGSizeMake(53, 55);
    mightyMan.zPosition = 1;
    mightyMan.name = @"MightyMan";
    mightyMan.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:mightyMan.size];
    mightyMan.physicsBody.restitution = 0.0;
    mightyMan.physicsBody.mass = 1;
    
    
    return mightyMan;
}

@end
