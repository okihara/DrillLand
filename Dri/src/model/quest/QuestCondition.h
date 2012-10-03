//
//  QuestCondition.h
//  Dri
//
//  Created by  on 12/10/02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DungeonModel.h"

@interface QuestCondition : NSObject<DungenModelObserver>
{
    uint type_id;
}

-(BOOL)judge:(void*)environment;

@end
