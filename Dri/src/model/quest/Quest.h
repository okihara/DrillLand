//
//  Quest.h
//  Dri
//
//  Created by  on 12/10/02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Quest : NSObject
{
    uint quest_id;
    NSArray *condition_list;
}

-(id)initWithQuestId:(uint)quest_id_ conditions:(NSArray*)conditions;
-(void)judge:(void*)environment;

@end
