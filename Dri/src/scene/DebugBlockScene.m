//
//  DebugBlockScene.m
//  Dri
//
//  Created by  on 12/10/23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DebugBlockScene.h"
#import "DL.h"
#import "HomeScene.h"
#import "BlockBuilder.h"
#import "BlockViewBuilder.h"
#import "BlockModel.h"
#import "BlockView.h"
#import "DLEvent.h"

@implementation DebugBlockScene

int max_num = 12;

int block_id_list[] = {
    ID_EMPTY,
    ID_NORMAL_BLOCK,
    ID_GROUPED_BLOCK_1,
    ID_GROUPED_BLOCK_2,
    ID_GROUPED_BLOCK_3,
    ID_UNBREAKABLE_BLOCK,
    
    ID_ENEMY_BLOCK_0, // BLUE SLIME
    ID_ENEMY_BLOCK_1, // RED  SLIME
    
    ID_ITEM_BLOCK_0, // POTION
    ID_ITEM_BLOCK_1, // DORAYAKI
    ID_ITEM_BLOCK_2, // DORAYAKI
    
    ID_PLAYER
};

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	CCLayer *layer = [DebugBlockScene node];
	[scene addChild:layer];
	return scene;
}

-(id)init
{
	if( (self=[super init]) ) {
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"DEBUG BLOCK" fontName:DL_FONT_NAME fontSize:20];
        label.position =  ccp(160, 440);
        [self addChild:label];
        
		// enable touch
        self.isTouchEnabled = YES;
        
        // IMPLEMENT:
        self->current_index = max_num - 1;//0;
        self->current_block_view = nil;
        
        
        // ---
        self->view_context = [[MockViewContext alloc] init];
        [self addChild:self->view_context];
        
        {
            CCMenu *menu = [CCMenu menuWithItems:
                            [CCMenuItemFont itemWithString:@"<<" target:self selector:@selector(didPressButton_prev:)],
                            [CCMenuItemFont itemWithString:@"BLOCK_ID" target:self selector:@selector(didPressButton_null:)],
                            [CCMenuItemFont itemWithString:@">>" target:self selector:@selector(didPressButton_next:)],
                            nil];
            menu.position = ccp(160, 400);
            [menu alignItemsHorizontally];
            [self->view_context addChild:menu];
        }
        
        {
            CCMenu *menu = [CCMenu menuWithItems:
                            [CCMenuItemFont itemWithString:@"ATTACK" target:self selector:@selector(didPressButton_attack:)],
                            [CCMenuItemFont itemWithString:@"DAMAGE" target:self selector:@selector(didPressButton_damage:)],
                            [CCMenuItemFont itemWithString:@"HEAL" target:self selector:@selector(didPressButton_heal:)],
                            [CCMenuItemFont itemWithString:@"DESTROY" target:self selector:@selector(didPressButton_destroy:)],
                            nil];
            menu.position = ccp(160, 100);
            [menu alignItemsVertically];
            [self->view_context addChild:menu];
        }
	}
	return self;
}

- (void)didPressButton_null:(CCMenuItem *)sender
{
}

-(void)change_block:(enum ID_BLOCK)block_id
{
    if (self->current_block_view) {
        [self->current_block_view removeFromParentAndCleanup:YES];
        self->current_block_view = nil;
    }
    
    BlockBuilder *block_builder = [[BlockBuilder alloc] init];
    BlockModel *block_model = [block_builder buildWithID:block_id];
    BlockView *block_view = [BlockViewBuilder build:block_model ctx:nil];
    
    block_view.position = ccp(160, 240);
    
    self->current_block_view = block_view;
    self->current_block_model = block_model;
    
    [self->view_context.block_layer addChild:self->current_block_view];
}

-(void)update_block
{
    [self change_block:block_id_list[self->current_index]];
}

- (void)handle_event_and_do_action:(DLEvent *)event
{
    CCAction *action = [self->current_block_view handleEvent:self->view_context event:event];
    if (action) {
        [self->current_block_view runAction:action];
    }
}

- (void)didPressButton_next:(CCMenuItem *)sender
{
    self->current_index += 1;
    if (self->current_index >= max_num) {
        self->current_index = max_num - 1;
    }    
    
    [self update_block];
}

- (void)didPressButton_prev:(CCMenuItem *)sender
{
    self->current_index -= 1;
    if (self->current_index < 0) {
        self->current_index = 0;
    }
    
    [self update_block];
}

- (void)didPressButton_attack:(CCMenuItem *)sender
{
    DLEvent *event = [DLEvent eventWithType:DL_ON_ATTACK target:self->current_block_model];
    [self handle_event_and_do_action:event];
}

- (void)didPressButton_damage:(CCMenuItem *)sender
{
    if (!self.isTouchEnabled) {
        return;
    }
    DLEvent *event = [DLEvent eventWithType:DL_ON_DAMAGE target:self->current_block_model];
    [event.params setObject:[NSNumber numberWithInt:9999] forKey:@"damage"];
    CCAction *action = [self->current_block_view handleEvent:self->view_context event:event];
    if (action) {
        self.isTouchEnabled = NO;
        CCSequence *seq = [CCSequence actions:(CCFiniteTimeAction*)action, [CCCallBlock actionWithBlock:^(){
            self.isTouchEnabled  = YES;
        }], nil];
        [self->current_block_view runAction:seq];
    }
}

- (void)didPressButton_heal:(CCMenuItem *)sender
{
    DLEvent *event = [DLEvent eventWithType:DL_ON_HEAL target:self->current_block_model];
    [event.params setObject:[NSNumber numberWithInt:9999] forKey:@"damage"];
    
    [self handle_event_and_do_action:event];
}

- (void)didPressButton_destroy:(CCMenuItem *)sender
{
    DLEvent *event = [DLEvent eventWithType:DL_ON_DESTROY target:self->current_block_model];
    
    [self handle_event_and_do_action:event];
    self->current_block_view = nil;
}

-(void)onEnterTransitionDidFinish
{
    [self update_block];
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    [[CCDirector sharedDirector] popScene];
}


@end
