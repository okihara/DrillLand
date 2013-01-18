//
//  InventoryScene.m
//
//  Created by Masataka Okihara on 12/09/16.
//  Copyright (c) 2012 HIROMITSU All rights reserved.
//

#import "InventoryScene.h"
#import "DungeonScene.h"
#import "MyItems.h"
#import "UserItem.h"
#import "DungeonModel.h"

@implementation InventoryScene

- (id)init:(DungeonModel*)dungeon_model_
{
    if( (self=[super init]) ) {
        
        self->dungeon_model = dungeon_model;
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"INVENTORY" fontName:DL_FONT_NAME fontSize:20];
        label.position =  ccp(160, 440);
        [self addChild:label];

        // enable touch
        self.isTouchEnabled = YES;

        // アイテムデータのセットアップ
        self->my_items = [MyItems new];
        // 準備 -------        
        {
            UserItem *item    = [UserItem new];
            [my_items add_item:item];
        }
        {
            UserItem *item    = [UserItem new];
            [my_items add_item:item];
        }
        {
            UserItem *item    = [UserItem new];
            [my_items add_item:item];
        }
        
        // IMPLEMENT:
        NSMutableArray *menu_items = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            NSString *item_name = [NSString stringWithFormat:@"item%03d", i];
            CCMenuItemFont *menu_item = [CCMenuItemFont itemWithString:item_name target:self selector:@selector(didPressButtonItems:)];
            ;
            [menu_items addObject:menu_item];
        }        
        CCMenu *menu = [CCMenu menuWithArray:menu_items];
        menu.position = ccp(160, 220);
        [menu alignItemsVertically];
        [self addChild:menu];
    }
        
    return self;
}

- (void)didPressButtonItems:(CCMenuItem *)sender
{
    BlockModel *player = self->dungeon_model.player;
    [self->my_items use:1 target:player dungeon:self->dungeon_model];
    
    [[CCDirector sharedDirector] popScene];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    // IMPLEMENT:
    // EXAMPLE:
    // [[CCDirector sharedDirector] replaceScene:[DungeonScene scene]];
}

+ (CCScene *)scene:(DungeonModel *)dungeon_model
{
    CCScene *scene = [CCScene node];
//    CCLayer *layer = [InventoryScene node];
    CCLayer *layer = [[[InventoryScene alloc] init:dungeon_model] autorelease];
    [scene addChild:layer];
    return scene;
}

@end

