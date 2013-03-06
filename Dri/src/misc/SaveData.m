//
//  SavePoint.m
//  Dri
//
//  Created by  on 13/03/06.
//  Copyright (c) 2013 Hiromitsu. All rights reserved.
//

#import "SaveData.h"

@implementation SaveData

id cache;

- (id)init {
    self = [super init];
    if (self) {
        self->fileName = @"data.dat";
        cache = nil;
    }
    return self;
}

- (NSString *)_getFilePath
{
    NSString *directory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [directory stringByAppendingPathComponent:self->fileName];
    return filePath;
}

- (void)save:(id)data
{
    //NSArray *array = [NSArray arrayWithObjects:@"山田太郎", @"東京都中央区", nil];
    BOOL successful = [NSKeyedArchiver archiveRootObject:data toFile:[self _getFilePath]];
    if (successful) {
        NSLog(@"%@", @"データの保存に成功しました。");
        cache = data;
    }
}

- (id)get
{
    if (!cache) {
        cache = [self load];
    }
    return cache;
}

- (id)load
{
    id loadedData = [NSKeyedUnarchiver unarchiveObjectWithFile:[self _getFilePath]];
    if (loadedData) {
        NSLog(@"%@\n%@", @"データの読み込みに成功しました。", (NSArray*)loadedData);
    }
    return loadedData;
}

@end
