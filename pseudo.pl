use strict;
use warnings;

package Event;
use Moo;
has date  => ( is => 'ro' );
has intro => ( is => 'rw' );
has talks => ( is => 'rw', default => sub {[]} );

package Talk;
use Moo;
has title    => ( is => 'ro' );
has speaker  => ( is => 'ro' );
has abstract => ( is => 'rw' );

package PseudoTA;
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
        print "  ** Creating new talk: $title by $speaker\n";

        $cur_talk = Talk->new( title => $title, speaker => $speaker );
        push @{ $events{ $cur_event->date }->talks }, $cur_talk;
        $prev_type = $cur_type;
    } else {
        if ( $prev_type eq 'head1' ) {
            $cur_event->intro($text);
        } elsif ( $prev_type eq 'head2' ) {
            print "  ++ Setting talk abstract\n";
            $cur_talk->abstract($text);
        }
    }
}

package main;
my $pta = PseudoTA->new;
$pta->parse_file('test.pod');

foreach my $event_date ( keys %events ) {
    ::p $events{$event_date}->talks;
}
