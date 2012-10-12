# -*- coding: utf-8 -*-
MYNAME = 'Masataka Okihara'
MYCOMPANYNAME = 'HIROMITSU'

suffix = 'Behavior'
date = "12/09/16"
classname = (ARGV[0] || 'Hoge') + suffix
puts classname

presen_path = '../Dri/src/block_behavior/'
header_fname = presen_path + classname + '.h'
impl_fname   = presen_path + classname + '.m'

puts header_fname
puts impl_fname

puts '------------------------------------'

template_header = <<"TEMPLATE"
//
//  #{header_fname}
//
//  Created by #{MYNAME} on #{date}.
//  Copyright (c) 2012 #{MYCOMPANYNAME} All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlockModel.h"

@interface #{classname} : NSObject<BlockBehaivior>

@end

TEMPLATE

# puts template_header

template_impl = <<"TEMPLATE"
//
//  #{classname}.m
//
//  Created by #{MYNAME} on #{date}.
//  Copyright (c) 2012 #{MYCOMPANYNAME} All rights reserved.
//

#import "#{header_fname}"
#import "BlockModel.h"

@implementation #{classname}

-(void)on_hit:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // implement behaivior
}

-(void)on_update:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_
{
    // implement behaivior
}

-(void)on_damage:(BlockModel*)context_ dungeon:(DungeonModel*)dungeon_ damage:(int)damage_
{
    // implement behaivior
}

-(void)on_break:(BlockModel*)block dungeon:(DungeonModel*)dungeon_
{
    // implement behaivior
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
