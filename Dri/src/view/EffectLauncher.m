//
//  EffectLauncher.m
//  Dri
//
//  Created by  on 12/08/30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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

- (BOOL)register_effect:(NSObject<EffectProtocol>*)effect name:(NSString*)name
{
    [self->effect_map setObject:effect forKey:name];
    return YES;
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

// color flash
-(CCFiniteTimeAction*)launch_effect_flash:(NSString *)name target:(CCNode*)target params:(NSDictionary*)params
{
    return nil;
}

-(CCFiniteTimeAction*)launch_effect:(NSString *)name target:(CCNode*)target params:(NSDictionary*)params
{
    NSObject<EffectProtocol> *effect = [self->effect_map objectForKey:name];
    if (!effect) return nil;
    return [effect launch:target params:params effect_layer:self.target_layer];
}

@end
