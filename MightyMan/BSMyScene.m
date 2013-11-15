//
//  BSMyScene.m
//  MightyMan
//
//  Created by Bryan Smith on 11/14/13.
//  Copyright (c) 2013 Bryan Smith. All rights reserved.
//

#import "BSMyScene.h"

@implementation BSMyScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        UIColor *bgColor = [UIColor colorWithRed: 135/255.0 green: 206/255.0 blue:250.0/255.0 alpha: 1.0];
        self.backgroundColor = bgColor;
        
        
    }
    return self;
}

@end
