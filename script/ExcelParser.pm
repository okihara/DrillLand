package Util::ExcelParser;

use strict;
use Encode;
use Spreadsheet::ParseExcel;
use Spreadsheet::ParseExcel::FmtJapan;

sub isString {
    my $var = shift;
    if (!ref($var) && defined($var) && ($var ^ $var) ne '0') {
        return 1;
    }
    return 0;
}

sub parseFile {
    my ($file, $in_code, $out_code) = @_;

    my %sheets;
    my $format   = Spreadsheet::ParseExcel::FmtJapan->new(Code => $in_code);
    my $parser   = Spreadsheet::ParseExcel->new();
    my $workbook = $parser->Parse($file, $format);

    for my $worksheet ($workbook->worksheets()) {

        my $name = $worksheet->get_name();
        my $cols = $worksheet->col_range();
        my $rows = $worksheet->row_range();
        Encode::from_to($name, $in_code, $out_code);
        my @keys;
        for (my $x = 0; $x <= $cols; $x++) {
            my $cell = $worksheet->get_cell(0, $x);
            my $value = $cell ? $cell->value() : undef;
            Encode::from_to($value, $in_code, $out_code);
            $keys[$x] = $value;
        }
        my @records;
        for (my $y = 1; $y <= $rows; $y++) {
            my %record;
            for (my $x = 0; $x <= $cols; $x++) {
                next if ($keys[$x] eq '');
                my $cell = $worksheet->get_cell($y, $x);
                my $value = $cell ? $cell->value() : undef;
                if (isString($value)) {
                    Encode::from_to($value, $in_code, $out_code);
                }
                $record{$keys[$x]} = $value;
            }
            push(@records, \%record);
        }
        $sheets{$name} = \@records;
    }
    return \%sheets;
}

1;
