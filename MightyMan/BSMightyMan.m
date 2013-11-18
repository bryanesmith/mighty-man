//
//  BSMightyMan.m
//  MightyMan
//
//  Created by Bryan Smith on 11/14/13.
//  Copyright (c) 2013 Bryan Smith. All rights reserved.
//

#import "BSMightyMan.h"

@interface BSMightyMan ()
@property NSString *state;
@property BOOL jumping;
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
    
    mightyMan.position = CGPointMake(60, 70);
    
    spriteSize = CGSizeMake(70, 70);
    mightyMan.size = spriteSize;
    mightyMan.name = @"MightyMan";
    mightyMan.zPosition = 1.0;
    
    // There's some blank space, so physics body is smaller
    mightyMan.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:spriteSize];
    mightyMan.physicsBody.restitution = 0.1;
    mightyMan.physicsBody.mass = 1;
    
    return mightyMan;
}

- (void) setRunning {
    
    self.state = @"BSRunning";
    
    if (!self.jumping) {
        [self removeAllActions];
    }
    
    SKAction *loop = [SKAction repeatActionForever:
                      [SKAction animateWithTextures:self.runningFrames
                                       timePerFrame:0.1375
                                             resize:YES
                                            restore:YES]];
    [self runAction:loop];
}

-(void) setStanding {
    
    self.state = @"BSStanding";
    
    if (!self.jumping) {
        [self removeAllActions];
        self.texture = self.standingFrame;
    }
}

- (void) jump {
    
    if (!self.jumping) {
        
        self.jumping = YES;

        // Note: this takes around ___ seconds.
        CGVector force = CGVectorMake(0, 300);
        [self.physicsBody applyImpulse:force];
        
        SKAction *jumping = [SKAction animateWithTextures:self.runningFrames
                                             timePerFrame:0.35
                                                   resize:YES
                                                  restore:YES];
        SKAction *stop = [SKAction runBlock:^{
            self.jumping = NO;
            
            // Check if mega man let go during jump
            if ([self.state isEqualToString:@"BSStanding"]) {
                [self setStanding];
            }
        }];
        
        [self runAction:[SKAction sequence:@[jumping, stop]]];
    }
}

@end
