//
//  BSCloud.h
//  MightyMan
//
//  Created by Bryan Smith on 11/16/13.
//  Copyright (c) 2013 Bryan Smith. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BSCloud : SKSpriteNode
+ (id) nodeForTextName:(NSString *)textureName at:(CGPoint)point;
@end
