//
//  BloddyPresentation.m
//  Dri
//
//  Created by  on 12/09/02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BloodyPresentation.h"
#import "DungeonView.h"

@implementation BloodyPresentation

-(CCAction*)handle_event:(DungeonView *)ctx event:(DLEvent*)e view:(BlockView *)view_
{
    BlockModel *b = (BlockModel*)e.target;
    
    switch (e.type) {
            
        case DL_ON_DAMAGE:
        {
            CCFiniteTimeAction *shake;
            if (b.type == ID_PLAYER) {
                shake = [ctx launch_effect:@"shake" target:ctx   params:nil];
            } else {
                shake = [ctx launch_effect:@"shake" target:view_ params:nil];
            }

            CCCallBlock *act = [CCCallBlock actionWithBlock:^{
                // effect
                [ctx launch_particle:@"blood" position:view_.position];
                // damage num
                [ctx launch_effect:@"damage" target:view_ params:e.params];
            }];
          
            return [CCSequence actions:shake, act, [CCDelayTime actionWithDuration:0.5], nil];
        }   
            break;
            
        // TODO: BloodyPresentation に書くものなのか？？
        // Healable Presentation 作る？
        case DL_ON_HEAL:
        {
            
            ccColor3B color = ccc3(0, 255, 0);
            NSDictionary *params = [NSDictionary
                                    dictionaryWithObject:[NSValue valueWithBytes:&color objCType:@encode(ccColor3B)]
                                    forKey:@"color"];
            {
                [ctx launch_effect:@"COLORFLASH" target:ctx.fade_layer params:params];
            }
            
            CCCallBlock *act = [CCCallBlock actionWithBlock:^{
                // effect
                [ctx launch_particle:@"heal" position:view_.position];
            }];
            
            CCCallBlock *act2 = [CCCallBlock actionWithBlock:^{
                // damage num
                [e.params setObject:[NSValue valueWithBytes:&color objCType:@encode(ccColor3B)] forKey:@"color"];
                [ctx launch_effect:@"damage" target:view_ params:e.params];
            }];
            
            return [CCSequence actions:act, [CCDelayTime actionWithDuration:1.5], act2, [CCDelayTime actionWithDuration:0.5], nil];
        }
            break;
            
        default:
            return nil;
            break;
    }
}

@end
