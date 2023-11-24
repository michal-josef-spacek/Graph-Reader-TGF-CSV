use strict;
use warnings;

use Graph::Reader::TGF::CSV;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Graph::Reader::TGF::CSV::VERSION, 0.04, 'Version.');
