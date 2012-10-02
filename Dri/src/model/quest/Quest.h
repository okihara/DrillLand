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
    NSMutableArray *condition_list;
}

-(void)judge:(void*)environment;

@end
