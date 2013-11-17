//
//  BSCloud.m
//  MightyMan
//
//  Created by Bryan Smith on 11/16/13.
//  Copyright (c) 2013 Bryan Smith. All rights reserved.
//

#import "BSCloud.h"

@interface BSCloud ()
-(void)moveCloud;
@end

@implementation BSCloud

float totalCloudDuration = 20.0;
//float totalCloudDuration = 2.0;

+ (id) nodeForTextName:(NSString *)textureName at:(CGPoint)point {
    
    SKTextureAtlas *texture_atlas = [SKTextureAtlas atlasNamed:@"MightyMan"];
    
    SKTexture *cloudTexture = [texture_atlas textureNamed:textureName];
    
    BSCloud *cloud = [[BSCloud alloc] initWithTexture:cloudTexture];
    
    cloud.name = @"Cloud";
    cloud.position = point;
    cloud.zPosition = 0.0;
    
    [cloud moveCloud];
    
    return cloud;
}

-(void)moveCloud {
    float offScreenAdj = 40.0;
    
    float duration = [self getCloudDurationFromPosition:self.position.x];
    
    SKAction *move1 = [SKAction moveToX:-offScreenAdj                                   duration:duration];
    SKAction *move2 = [SKAction runBlock:^{
        [self setPosition: CGPointMake([self getLandscapeWidth] + offScreenAdj, self.position.y)];
    }];
    SKAction *move3 = [SKAction moveToX:-offScreenAdj                                   duration:totalCloudDuration];
    
    SKAction *loop = [SKAction repeatActionForever:[SKAction sequence:@[move2, move3]]];
    
    SKAction *go = [SKAction sequence:@[move1, loop]];
    
    [self runAction:go];
}

- (CGFloat) getCloudDurationFromPosition:(CGFloat) x {
    return totalCloudDuration * (x / [self getLandscapeWidth]);
}

- (float) getLandscapeWidth {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    return screenRect.size.height; // Since in landscape mode
}

@end
