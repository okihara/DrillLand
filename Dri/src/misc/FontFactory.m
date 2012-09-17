//
//  FontFactory.m
//  Dri
//
//  Created by  on 12/09/17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FontFactory.h"

@implementation FontFactory

+(CCLabelBMFont*)makeLabel:(NSString*)string
{
    return [FontFactory makeLabel:string color:ccc3(255, 255, 255)];
}

+(CCLabelBMFont*)makeLabel:(NSString*)string color:(ccColor3B)color
{
    CCLabelBMFont* label = [CCLabelBMFont labelWithString:string fntFile:@"ebit.fnt"];
    label.scale = 0.5;
    label.color = color;
    return label;
}

@end
