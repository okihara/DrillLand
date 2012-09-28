//
//  EffectLauncher.m
//  Dri
//
//  Created by  on 12/08/30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/NSObjCRuntime.h>
#import "EffectLauncher.h"
#import "EffectShake.h"
#import "EffectDamageNum.h"
#import "EffectColorFlash.h"


@implementation EffectLauncher

@synthesize target_layer;

- (void)setup {
    [EffectShake register_me:self];
    [EffectDamageNum register_me:self];
    [EffectColorFlash register_me:self];
}

- (id)init {
    
    if(self=[super init]) {
        self->effect_map = [[NSMutableDictionary alloc] init];
        
        [self setup];
    }
    return self;
}

-(void) make_particle02:(CGPoint)pos
{
    CCParticleSystem *fire = [[[CCParticleExplosion alloc] init] autorelease];
    fire.totalParticles = 6;
    fire.life = 1.0;
    fire.speed = 100;
    fire.position = pos;
    fire.autoRemoveOnFinish = YES;
    
    [self.target_layer addChild:fire];
}

-(void) make_particle01:(CGPoint)pos
{
    CCParticleSystem *fire = [[[CCParticleExplosion alloc] init] autorelease];
    fire.totalParticles = 16;
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
    // TODO: particle no plist がない場合、落ちるよ
    particle.position = pos;
    particle.scale = 0.7;
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


// effect -----------------------------------------------------------------------------

- (BOOL)register_effect:(Class)effect_class name:(NSString*)name;
{
    // TODO: ここで validate すべき
    [self->effect_map setObject:[NSValue valueWithPointer:effect_class] forKey:name];
    return YES;
}

-(CCFiniteTimeAction*)launch_effect:(NSString *)name target:(CCNode*)target params:(NSDictionary*)params
{
    NSValue *value = [self->effect_map objectForKey:name];
    if (!value) return nil;
    Class effect = [value pointerValue];
    return [(id)effect launch:target params:params effect_layer:self.target_layer];
}

@end
