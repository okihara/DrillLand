# -*- coding: utf-8 -*-
MYNAME = 'Masataka Okihara'
MYCOMPANYNAME = 'HIROMITSU'

date = "12/09/16"
classname = ARGV[0] || 'Hoge'
puts classname

presen_path = '../Dri/src/view/effect/'
header_fname = "#{presen_path}Effect#{classname}.h"
impl_fname   = "#{presen_path}Effect#{classname}.m"

puts header_fname
puts impl_fname

puts '------------------------------------'

template_header = <<"TEMPLATE"
//
//  Effect#{classname}.h
//
//  Created by #{MYNAME} on #{date}.
//  Copyright (c) 2012 #{MYCOMPANYNAME} All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Effect.h"

@interface Effect#{classname} : NSObject<EffectProtocol>

@end

TEMPLATE

# puts template_header

template_impl = <<"TEMPLATE"
//
//  Effect#{classname}.m
//
//  Created by #{MYNAME} on #{date}.
//  Copyright (c) 2012 #{MYCOMPANYNAME} All rights reserved.
//

#import "Effect#{classname}.h"
#import "cocos2d.h"

@implementation Effect#{classname}

- (id)init {
    if(self=[super init]) {
        // implement
    }
    return self;
}

+ (CCFiniteTimeAction*)launch:(CCNode*)target params:(NSDictionary*)params effect_layer:(CCLayer*)effect_layer
{
    // implement
    return nil;
}

+ (BOOL)register_me:(NSObject<EffectLauncherProtocol>*)launcher {
    return [launcher register_effect:[Effect#{classname} class] name:@"#{classname.upcase}"];
}

@end

TEMPLATE

# puts template_impl

f = open(header_fname, 'w')
f.puts(template_header)
f.close

f = open(impl_fname, 'w')
f.puts(template_impl)
f.close
