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
#import "InventoryMenuItem.h"


@implementation InventoryScene

- (id)init:(DungeonModel*)dungeon_model_
{
    if( (self=[super init]) ) {

        self.isTouchEnabled = YES;

        CCLabelTTF *label = [CCLabelTTF labelWithString:@"INVENTORY" fontName:DL_FONT_NAME fontSize:20];
        label.position =  ccp(160, 440);
        [self addChild:label];
        
        // アイテムデータのセットアップ
        // 後で外から渡すように
        self->dungeon_model = dungeon_model_;
        self->my_items = dungeon_model_.player.my_items;

        // setup player status
        BlockModel *player = self->dungeon_model.player;
        NSString *strStatus = [NSString stringWithFormat:@"atk %d def %d", player.atk, player.def];
        CCLabelTTF *labelStatus = [CCLabelTTF labelWithString:strStatus
                                                     fontName:DL_FONT_NAME fontSize:20];
        labelStatus.position = ccp(160, 400);
        [self addChild:labelStatus];

        // setup item list
        self->menuItemList = [[NSMutableArray alloc] init];
        NSArray *item_list = [self->my_items getList];
        for (UserItem *user_item in item_list) {
            InventoryMenuItem *menu_item = [[[InventoryMenuItem alloc] initWithUserItem:user_item target:self selector:@selector(didPressButtonItems:)] autorelease];
            [self->menuItemList addObject:menu_item];
        }
        CCMenu *menu = [CCMenu menuWithArray:self->menuItemList];
        menu.position = ccp(160, 240);
        [menu alignItemsVertically];
        [self addChild:menu];
    }
    
    return self;
}

-(void)dealloc
{
    [self->menuItemList release];
    [super dealloc];
}

- (void)___didPressButtonItems:(CCMenuItem *)sender
{
    InventoryMenuItem *menuItem = (InventoryMenuItem *)sender;
    UserItem *userItem = menuItem.userItem;
    BlockModel *player = self->dungeon_model.player;
    [self->my_items use:userItem.uniqueId target:player dungeon:self->dungeon_model];

    DLEvent *event = [DLEvent eventWithType:DL_ON_UPDATE target:nil];
    [self->dungeon_model dispatchEvent:event];
    
    [[CCDirector sharedDirector] popScene];
}

- (void)didPressButtonItems:(CCMenuItem *)sender
{
    InventoryMenuItem *menuItem = (InventoryMenuItem *)sender;
    
    // TODO: onTap 2回呼んでるのがいけてない
    
    BOOL needUse = [menuItem onTap];

    // 全部 色変える
    for (InventoryMenuItem *menuItem in self->menuItemList) {
        menuItem.isSelected = NO;
    }
    [menuItem onTap];
    
    if (needUse) {
        [self ___didPressButtonItems:sender];
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    [[CCDirector sharedDirector] popScene];
}

+ (CCScene *)scene:(DungeonModel *)dungeon_model
{
    CCScene *scene = [CCScene node];
    CCLayer *layer = [[[InventoryScene alloc] init:dungeon_model] autorelease];
    [scene addChild:layer];
    return scene;
}

@end
