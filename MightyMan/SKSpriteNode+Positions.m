//
//  SKSpriteNode+Positions.m
//  MightyMan
//
//  Created by Bryan Smith on 11/25/13.
//  Copyright (c) 2013 Bryan Smith. All rights reserved.
//

#import "SKSpriteNode+Positions.h"

@implementation SKSpriteNode (Positions)

-(float)leftPosition {
    return self.position.x - self.size.width / 2;
}

-(float)rightPosition {
    return self.position.x + self.size.width / 2;
}

-(float)bottomPosition {
    return self.position.y - self.size.height / 2;
}

-(float)topPosition {
    return self.position.y + self.size.height / 2;
}

-(BOOL)isRunIntoWall:(SKSpriteNode*)wall thisTurnAtSpeed:(int)distancePerTurn {
    // TODO: logic to determine whether this object will run into a wall in under a turn
    return NO;
}

@end
