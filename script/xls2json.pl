#!/usr/bin/perl

use strict;
use warnings;
use JSON::XS;
use Getopt::Long qw(:config auto_help);
use Data::Dumper;
$Data::Dumper::Indent = 1;
use ExcelParser;

my %options;
my $env;

BEGIN{
    %options = (
        env => "hoge",
        dryrun => 1
    );
    GetOptions(
        \%options,
        qw/dryrun=i env=s/
    );
    $env = $options{env};
}

my $file = $ARGV[0] || "";
die "need filename" unless ($file =~ /\.xls/ && -e $file);

my $sheets = Util::ExcelParser::parseFile($file, 'utf8', 'utf8');
my $json = JSON::XS->new->encode($sheets);

print $json;
