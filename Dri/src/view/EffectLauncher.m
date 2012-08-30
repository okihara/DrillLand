//
//  EffectLauncher.m
//  Dri
//
//  Created by  on 12/08/30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EffectLauncher.h"
#import "XDMap.h"

@implementation EffectLauncher

@synthesize target_layer;

-(void)launch_particle:(NSString*)name position:(DLPoint)pos
{
    CCParticleSystem *particle = [[[CCParticleSystemQuad alloc] initWithFile:@"blood.plist"] autorelease];
    particle.position = ccp(pos.x, pos.y);
    particle.autoRemoveOnFinish = YES;
    [self.target_layer addChild:particle];
}

@end
