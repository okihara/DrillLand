//
//  QuestFactory.m
//  Dri
//
//  Created by  on 12/10/03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestFactory.h"
#import "Quest.h"
#import "QuestCondition.h"
#import "PickCondition.h"
#import "HuntingCondition.h"

@implementation QuestFactory

+(Quest*)make_test_0
{
    QuestCondition *cond = [PickCondition new];
    Quest *quest = [[Quest alloc] initWithQuestId:0 conditions:[NSArray arrayWithObjects:cond, nil]];
    return quest;
}

+(Quest*)make_test_1
{
    QuestCondition *cond = [[HuntingCondition alloc] initWithTargetId:ID_ENEMY_BLOCK_0 required_num:3];
    Quest *quest = [[Quest alloc] initWithQuestId:0 conditions:[NSArray arrayWithObjects:cond, nil]];
    return quest;
}

+(Quest*)make_test_2
{
    QuestCondition *cond = [[HuntingCondition alloc] initWithTargetId:ID_ENEMY_BLOCK_1 required_num:1];
    Quest *quest = [[Quest alloc] initWithQuestId:0 conditions:[NSArray arrayWithObjects:cond, nil]];
    return quest;
}

@end
