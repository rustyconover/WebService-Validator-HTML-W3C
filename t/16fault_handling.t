# $Id$

use Test::More tests => 5;
use WebService::Validator::HTML::W3C;
use HTTP::Response;
use Data::Dumper;

my $v = WebService::Validator::HTML::W3C->new(detailed => 1);

ok ($v, 'object created');

if ( $ENV{ 'TEST_AUTHOR' } ) {
# A simple document with invalid utf8
    my $data = "<!DOCTYPE html><html><head><title>test</title></head><body>\xf0\x28\x8c\x28</body></html>";
    
    if ( $v->validate_markup($data) ) {
        ok(!$v->is_valid(), "Invalid utf-8 file is not valid");

        is(scalar(@{$v->errors}), 1, "One error found for invalid utf-8");

        my $e = $v->errors()->[0];
        
        is($e->msgid, "fatal_byte_error", "Error is fatal_byte_error");
        is($e->line, 1, "Error is on the proper line");
    }
} else {
    skip "TEST_AUTHOR environment variable not defined", 4 unless $ENV{ 'TEST_AUTHOR' };
}

