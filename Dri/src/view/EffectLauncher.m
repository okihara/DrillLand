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


-(void) make_particle02:(CGPoint)pos
{
    CCParticleSystem *fire = [[[CCParticleExplosion alloc] init] autorelease];
    fire.totalParticles = 4;
    fire.life = 1.0;
    fire.speed = 100;
    fire.position = pos;
    fire.autoRemoveOnFinish = YES;
    
    [self.target_layer addChild:fire];
}

-(void) make_particle01:(CGPoint)pos
{
    CCParticleSystem *fire = [[[CCParticleExplosion alloc] init] autorelease];
    fire.totalParticles = 14;
    fire.speed = 200;
    fire.gravity = ccp(0.0, -500.0);
    fire.position = pos;
    fire.life = 0.7;
    fire.autoRemoveOnFinish = YES;
    
    [self.target_layer addChild:fire];
}

-(void) make_particle:(CGPoint)pos
{
    [self make_particle01:pos];
    [self make_particle02:pos];
}

-(void)launch_particle_legacy:(NSString*)name position:(CGPoint)pos
{
    [self make_particle:pos];
}

- (void)launch_particle_plist:(NSString *)name pos:(CGPoint)pos
{
    NSString* plistname = [NSString stringWithFormat:@"%@.plist", name];
    CCParticleSystem *particle = [[[CCParticleSystemQuad alloc] initWithFile:plistname] autorelease];
    // particle no plist がない場合、落ちるよ
    particle.position = pos;
    particle.autoRemoveOnFinish = YES;
    [self.target_layer addChild:particle];
}

-(void)launch_particle:(NSString*)name position:(CGPoint)pos
{
    if ([name isEqualToString:@"block"]) {
        [self launch_particle_legacy:name position:pos];
    } else {
        [self launch_particle_plist:name pos:pos];
    }
}

@end
