//
//  EffectLauncher.m
//  Dri
//
//  Created by  on 12/08/30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EffectLauncher.h"
#import "DamageNumView.h"

@implementation EffectLauncher

@synthesize target_layer;


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

-(void)launch_effect2:(NSString *)name position:(CGPoint)pos param1:(int)p1
{
    [DamageNumView spawn:p1 target:self.target_layer position:pos color:ccc3(0, 240, 20)];
}


// effect -----------------------------------------------------------------------------

// shake
-(CCFiniteTimeAction*)launch_effect_shake:(NSString *)name target:(CCNode*)target params:(NSDictionary*)params
{
    int amp = 6;
    int times = 4;
    
    CCFiniteTimeAction *r  = [CCMoveBy actionWithDuration:0.016 position:ccp(amp,0)];
    CCFiniteTimeAction *l  = [CCMoveBy actionWithDuration:0.033 position:ccp(-amp*2,0)];
    CCFiniteTimeAction *r2 = [CCMoveBy actionWithDuration:0.033 position:ccp(amp*2,0)];
    CCFiniteTimeAction *o  = [CCMoveBy actionWithDuration:0.016 position:ccp(-amp,0)];
    
    CCFiniteTimeAction *repeat = [CCRepeat actionWithAction:[CCSequence actions:l, r2, nil] times:times];
    CCFiniteTimeAction *shake = [CCSequence actions:r, repeat, o, nil];
    
    return [CCTargetedAction actionWithTarget:target action:shake];
}

// color flash
-(CCFiniteTimeAction*)launch_effect_flash:(NSString *)name target:(CCNode*)target params:(NSDictionary*)params
{
    return nil;
}

-(CCFiniteTimeAction*)launch_effect:(NSString *)name target:(CCNode*)target params:(NSDictionary*)params
{
    if ([name isEqualToString:@"shake"]) {
        return [self launch_effect_shake:@"shake" target:target params:params];
    } else {
        NSNumber *num = (NSNumber*)[params objectForKey:@"damage"];
        int damage = num ? [num intValue] : 0;
        [DamageNumView spawn:damage target:self.target_layer position:target.position];
        return nil;
    }
}

@end
