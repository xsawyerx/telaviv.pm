#!/usr/bin/perl

use strict;
use warnings;

use IO::All;
use Text::Haml;

my $filename = shift(@ARGV);

if (!defined($filename))
{
    die "$0 <file.haml>";
}

if (@ARGV)
{
    die "$0 accepts only parameter - <file.haml>";
}

my $haml     = Text::Haml->new;
my $template = io( $filename )->slurp;
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

