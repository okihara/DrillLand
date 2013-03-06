//
//  SaveData.h
//  Dri
//
//  Created by  on 13/03/06.
//  Copyright (c) 2013 Hiromitsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveData : NSObject
{
    NSString     *fileName;
}

- (void)save:(id)data;
- (id)get;
- (id)load;

@end
