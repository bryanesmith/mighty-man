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
    
    BSMightyMan *mightyMan = [BSMightyMan
                               spriteNodeWithImageNamed:@"MightyMan.png"];
    mightyMan.position = CGPointMake(80, 40);
    mightyMan.size = CGSizeMake(53, 55);
    mightyMan.name = @"MightyMan";
    
    mightyMan.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:mightyMan.size];
    mightyMan.physicsBody.restitution = 0.0;
    mightyMan.physicsBody.mass = 1;
    
    
    return mightyMan;
}

@end
