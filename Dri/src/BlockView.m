//
//  BlockView.m
//  Dri
//
//  Created by  on 12/08/18.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BlockView.h"
#import "BlockModel.h"
#import "DungeonView.h"

@implementation BlockView


-(void)setup
{
    self->events = [[NSMutableArray array] retain];
}

-(id) init
{
	if (self=[super init]) {
        [self setup];
	}
	return self;
}

-(void)dealloc
{
    [self->events release];
    [super dealloc];
}


// TODO: プレゼンテーションにそのまま渡す
-(void)update_presentation:(DungeonView*)ctx model:(BlockModel*)b
{
    for (NSDictionary* event in self->events) {
        int type = [(NSNumber*)[event objectForKey:@"type"] intValue];
        BlockModel* b = (BlockModel*)[event objectForKey:@"model"];

        if (b.type == ID_PLAYER){
            
            switch (type) {
                    
                case 0:
                    break;
                case 1:
                    [ctx launch_particle:@"blood" position:self.position];
                    break;
                case 2:
                    break;
                default:
                    break;
            }
            
        } else {
            
            switch (type) {
                case 0:
                    break;
                case 1:
                    [ctx launch_particle:@"hit2" position:self.position];
                    break;
                case 2:
                    [ctx launch_particle:@"block" position:self.position];
                    break;
                default:
                    break;
            }
            
        }
        
    }
    
    [self->events removeAllObjects];
}

-(BOOL)handle_event:(DungeonView*)ctx type:(int)type model:(BlockModel*)b
{
    NSDictionary* event = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:type], @"type", b, @"model", nil];
    [self->events addObject:event];
    return YES;
}

//----------------------------------------------------------------
// animation

-(void)play_anime:(NSString*)name
{
    CCAnimation *anim = [[CCAnimationCache sharedAnimationCache] animationByName:name];
    CCAction* act = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:anim]];
    [self runAction:act];   
}


//===============================================================
//
// どちらかというと builder
//
//===============================================================

+ (void)add_route_num:(BlockModel *)b ctx:(DungeonModel *)ctx block:(BlockView *)block
{
    // 経路探索の結果を数字で表示
    int c = [ctx.route_map get:b.pos];
    CCLabelTTF *cost = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", c] fontName:@"AppleGothic" fontSize:20];
    cost.position =  ccp(40, 30);
    cost.color = ccc3(0, 0, 255);
    [block addChild:cost];
}

+ (void)add_can_destroy_num:(BlockModel *)b block:(BlockView *)block
{
    // 破壊できるか表示
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"1" fontName:@"AppleGothic" fontSize:20];
    label.position =  ccp(30, 30);
    label.color = ccc3(0, 0, 0);
    label.visible = b.can_tap; // タップ出来ないときは数字を見せない
    [block addChild:label];
}

+(BlockView *) create:(BlockModel*)b ctx:(DungeonModel*)ctx
{
    // ブロック
    NSString *filename;
    switch (b.type) {
        case ID_NORMAL_BLOCK:
            filename = @"block01.png";
            break;
        case ID_GROUPED_BLOCK_1:
            filename = @"block02.png";
            break;
        case ID_GROUPED_BLOCK_2:
            filename = @"block03.png";
            break;
        case ID_GROUPED_BLOCK_3:
            filename = @"block04.png";
            break;
        case ID_ENEMY_BLOCK_0:
            filename = @"mon001.png";
            break;
        case ID_ENEMY_BLOCK_1:
            filename = @"mon002.png";
            break;
        case ID_UNBREAKABLE_BLOCK:
            filename = @"block99.png";
            break;
        default:
            filename = @"block00.png";
            break;
    }
    
    BlockView* block = [BlockView spriteWithFile:filename];
    [block setup];
    
    [self add_can_destroy_num:b block:block];
//    [self add_route_num:b ctx:ctx block:block];
    
    return block;
}

@end
