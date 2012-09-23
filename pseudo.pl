use strict;
use warnings;

package PM::TA::Event;
use Moo;
has date  => ( is => 'ro', required => 1 );
has intro => ( is => 'rw' );
has talks => ( is => 'rw', default => sub {[]} );

package PM::TA::Talk;
use Moo;
has title    => ( is => 'ro', required => 1 );
has speaker  => ( is => 'ro' );
has abstract => ( is => 'rw' );

package PM::TA::POD;
use parent 'Pod::Simple';

my ( $prev_type, $cur_type, $cur_event, $cur_talk );
my ( %events, %talks );

sub _handle_element_start {
    my ( $self, $name, $attrs ) = @_;
    $cur_type = $name;
}

sub _handle_text {
    my ( $self, $text ) = @_;

    if ( $cur_type eq 'head1' ) {
        print "* Creating new event ($text)\n";

        $cur_event = Event->new( date => $text );
        $events{ $cur_event->date } = $cur_event;
        $prev_type = $cur_type;
    } elsif ( $cur_type eq 'head2' ) {
        my ( $title, $speaker ) = split /\s*::\s*/, $text;
        $speaker ||= '';
        print "  ** Creating new talk: $title" . $speaker ? " by $speaker\n" : "\n";

        $cur_talk = Talk->new( title => $title, speaker => $speaker );
        push @{ $events{ $cur_event->date }->talks }, $cur_talk;
        $prev_type = $cur_type;
    } else {
        print "  (unrecognized type $cur_type)\n";
        if ( $prev_type eq 'head1' ) {
            $cur_event->intro($text);
        } elsif ( $prev_type eq 'head2' ) {
            print "  ++ Setting talk abstract\n";
            $cur_talk->abstract($text);
        }
    }
}

package main;
my $pta = PM::TA::POD->new;
$pta->parse_file('test.pod');

my $event = $events{'June 27, 2012'};
::p $event;
__END__
foreach my $event_date ( keys %events ) {
    ::p $events{$event_date}->talks;
}

__END__

=head1 PM::TA::POD - Pod parser for TA.pm events

=head1 SYNOPSIS

    my $ptp = PM::TA::POD;
    $ptp->parse_file('events.pod');

    # use %events

=head1 DESCRIPTION

TA.pm had a lot of events, and meets regularly so these events grow. While it's
not impossible to write HTML for all of them, there is a clear case for
adopting a standard format, and making it easy to change it in the future.

For that purpose, they were all writen in POD form (which is the most flexible
format available) and this script parses that form in order to create a
template, which will then be rendered to create a full static HTML file.

=head1 WHY NOT <insert other format>

Most other format (YAML, JSON, INI, XML) are serializing formats, and not meant
for flexible amounts of texts with flexible structures while still making it
easy for users to add new content. Yes, it's posisble with all those listed and
more, but they clearly make it harder for users to keep adding.

The POD format makes it extremely easy to add and remove and it's very simple
and easy to parse.

=head1 Structure

    =head1 date

    Possible description

    =head2 Talk name :: Speaker

    Possible description

You may also include a list in any description which will still be part of the
description and will be rendered as a list.

    =over 4

    =item * ITEM

    =item * ITEM

    =back

=head1 Objects structure

=head2 PM::TA::Event

Event objects hold each event.

=head3 Attributes

=over 4

=item * date

Event date in the format of "February 29, 1984".

=item * intro

Introduction to the event.

=item * talks

An arrayref of talks of type PM::TA::Talk, described below.

=back

=head2 PM::TA::Talk

=head3 Attributes

=over 4

=item * title

Talk title.

=item * speaker

Talk speaker.

=item * abstract

Abstract for the talk.

=back

