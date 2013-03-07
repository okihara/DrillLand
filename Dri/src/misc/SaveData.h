//
//  SaveData.h
//  Dri
//
//  Created by  on 13/03/06.
//  Copyright (c) 2013 Hiromitsu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define INITIAL_GOLD 3

@interface SaveData : NSObject
{
    NSString     *fileName;
}

- (void)setup;
- (void)save:(id)data;
- (id)get;
- (id)load;

@end
