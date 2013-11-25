//
//  SKSpriteNode+Positions.h
//  MightyMan
//
//  Created by Bryan Smith on 11/25/13.
//  Copyright (c) 2013 Bryan Smith. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKSpriteNode (Positions)
-(float)leftPosition;
-(float)rightPosition;
-(float)topPosition;
-(float)bottomPosition;
-(BOOL)isRunIntoWall:(SKSpriteNode*)wall thisTurnAtSpeed:(int)distancePerTurn;
@end
