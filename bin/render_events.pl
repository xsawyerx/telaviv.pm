#!/usr/bin/perl

use strict;
use warnings;

use IO::All;
use Text::Haml;

@ARGV == 1 or die "$0 <file.haml>";

my $haml     = Text::Haml->new;
my $template = io( $ARGV[0] )->slurp;
my $output   = $haml->render($template);

print << "_END";
[% WRAPPER root.tt %]
<div class="post">
<h2 class="title">Previous Events</h2>
<div style="clear: both;">&nbsp;</div>
$output
</div>
[% END %]
_END

