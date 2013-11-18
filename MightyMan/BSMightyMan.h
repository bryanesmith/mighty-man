//
//  BSMightyMan.h
//  MightyMan
//
//  Created by Bryan Smith on 11/14/13.
//  Copyright (c) 2013 Bryan Smith. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BSMightyMan : SKSpriteNode

+ (id) node;
- (void) setRunning;
- (void) setStanding;
- (void) jump;

@end
