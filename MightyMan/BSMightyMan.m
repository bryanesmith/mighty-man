//
//  BSMightyMan.m
//  MightyMan
//
//  Created by Bryan Smith on 11/14/13.
//  Copyright (c) 2013 Bryan Smith. All rights reserved.
//

#import "BSMightyMan.h"
#import "SKSpriteNode+Positions.h"

enum BSMightyManState {
    BSMightyManRunning,
    BSMightyManStanding
};

@interface BSMightyMan ()
@property enum BSMightyManState state;
@property BOOL jumping;
@property BOOL shooting;
@property (strong, nonatomic) SKTexture *standingFrame;
@property (strong, nonatomic) NSArray *runningFrames;
@property (strong, nonatomic) NSArray *jumpingFrames;
@property (assign, nonatomic) CGSize physicsBodySize;
@end

@implementation BSMightyMan
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

#pragma mark - BSMightyMan methods

+ (id) node {
    
    SKTextureAtlas *texture_atlas = [SKTextureAtlas atlasNamed:@"MightyMan"];
    
    SKTexture *standing = [texture_atlas textureNamed:@"MightyMan1"];
    
    BSMightyMan *mightyMan = [[BSMightyMan alloc] initWithTexture:standing];
    
    mightyMan.standingFrame = standing;
    mightyMan.runningFrames = @[ [texture_atlas textureNamed:@"MightyMan2"],
                                 [texture_atlas textureNamed:@"MightyMan3"],
                                 [texture_atlas textureNamed:@"MightyMan4"],
                                 [texture_atlas textureNamed:@"MightyMan3"]];
    mightyMan.jumpingFrames = @[ [texture_atlas textureNamed:@"MightyMan5"] ];
    
    mightyMan.position = CGPointMake(60, 70);
    
    CGSize spriteSize = CGSizeMake(74, 74);
    mightyMan.size = spriteSize;
    mightyMan.name = @"MightyMan";
    mightyMan.zPosition = 1.0;
    
    // There's some blank space, so physics body is smaller
    mightyMan.physicsBodySize = CGSizeMake(40, 74);
    mightyMan.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:mightyMan.physicsBodySize];
    mightyMan.physicsBody.restitution = 0.0;
    mightyMan.physicsBody.mass = 1;
    
    return mightyMan;
}

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

#pragma mark - Override SKSpriteNode.Positions category

//
// NOTE: Because as far as I can tell (1) can't retrieve size from SKPhysicsBody and
//       (2) can't store structs in categories, the category uses the size of the SKNode
//       instead of the SKPhysicsBody.
//
//       That means that if the size of the physics body doesn't match the node, need
//       to override the values, as I do here. Major bummer. =(
//

-(float)leftPosition {
    return self.position.x - self.physicsBodySize.width / 2;
}

-(float)rightPosition {
    return self.position.x + self.physicsBodySize.width / 2;
}

-(float)bottomPosition {
    return self.position.y - self.physicsBodySize.height / 2;
}

-(float)topPosition {
    return self.position.y + self.physicsBodySize.height / 2;
}

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

#pragma mark - Perform actions

- (void) performClearActions {
    [self removeAllActions];
    self.jumping = NO;
    self.shooting = NO;
}

- (void) performRun {
    
    self.state = BSMightyManRunning;
    
    if (!self.jumping) {
        [self performClearActions];
    }
    
    SKAction *loop = [SKAction repeatActionForever:
                      [SKAction animateWithTextures:self.runningFrames
                                       timePerFrame:0.1375
                                             resize:YES
                                            restore:YES]];
    [self runAction:loop];
}

-(void) performStand {
    
    self.state = BSMightyManStanding;
    
    if (!self.jumping) {
        [self performClearActions];
        self.texture = self.standingFrame;
    }
}

- (void) performJump {
    
    if (!self.jumping) {
        
        self.jumping = YES;

        // Note: this takes around ___ seconds.
        CGVector force = CGVectorMake(0, 300);
        [self.physicsBody applyImpulse:force];
        
        SKAction *jumping = [SKAction animateWithTextures:self.jumpingFrames
                                             timePerFrame:1.3
                                                   resize:YES
                                                  restore:YES];
        
        SKAction *stop = [SKAction runBlock:^{
            self.jumping = NO;
            
            //
            // Edge case: check to see whether user removed right
            //            press during jump,
            //
            if (self.state == BSMightyManStanding) {
                [self performStand];
            }
        }];
        
        [self runAction:[SKAction sequence:@[jumping, stop]]];
    }
}

- (void) performShoot {
    
    if (!self.shooting) {
        
        self.shooting = YES;
        
        SKTextureAtlas *texture_atlas = [SKTextureAtlas atlasNamed:@"MightyMan"];
        SKTexture *shoot;
        if (self.jumping) {
            shoot = [texture_atlas textureNamed:@"MightyMan7"];
        } else {
            shoot = [texture_atlas textureNamed:@"MightyMan6"];
        }
        
        SKAction *showShoot = [SKAction animateWithTextures:@[shoot]
                                               timePerFrame:.35
                                                     resize:YES
                                                    restore:YES];
        
        SKAction *end = [SKAction runBlock:^{
            self.shooting = NO;
        }];
        
        [self runAction:[SKAction sequence:@[showShoot, end]]];
    }
}

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

#pragma mark - Test methods

- (BOOL) isJumping {
    return self.jumping;
}

- (BOOL) isShooting {
    return self.shooting;
}

- (BOOL) isGroundShooting {
    return self.isShooting && !self.isJumping;
}

@end
