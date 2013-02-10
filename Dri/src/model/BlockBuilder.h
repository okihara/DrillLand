//
//  BlockBuilder.h
//  Dri
//
//  Created by  on 12/08/27.
//  Copyright 2012 Hiromitsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlockModel.h"

@interface BlockBuilder : NSObject {
}

-(BlockModel*)buildWithID:(enum ID_BLOCK)name;

@end
