//
//  EffectLauncher.m
//  Dri
//
//  Created by  on 12/08/30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EffectLauncher.h"

@implementation EffectLauncher

@synthesize target_layer;

-(void)launch_particle:(NSString*)name position:(CGPoint)pos
{
    NSString* plistname = [NSString stringWithFormat:@"%@.plist", name];
    CCParticleSystem *particle = [[[CCParticleSystemQuad alloc] initWithFile:plistname] autorelease];
    particle.position = pos;
    particle.autoRemoveOnFinish = YES;
    [self.target_layer addChild:particle];
}

@end
