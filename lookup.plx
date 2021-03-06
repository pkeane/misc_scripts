#!/usr/bin/perl -w
#
# Dict - looks up definitions, synonyms and antonyms of words.
# Comments, suggestions, contempt? Email adam@bregenzer.net.
#
# This code is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
#

use strict; $|++;
use LWP;
use Net::Dict;
use Sort::Array "Discard_Duplicates";
use URI::Escape;

my $word = $ARGV[0]; # the word to look-up
die "You didn't pass a word!\n" unless $word;
print "Definitions for word '$word':\n";

# get the dict.org results.
my $dict = Net::Dict->new('dict.org');
my $defs = $dict->define($word);
foreach my $def (@{$defs}) {
    my ($db, $definition) = @{$def};
    print $definition . "\n";
}

# base URL for thesaurus.com requests
# as well as the surrounding HTML of
# the data we want. cleaner regexps.
my $base_url       = "http://thesaurus.reference.com/search?q=";
my $middle_html    = ":</b>&nbsp;&nbsp;</td><td>";
my $end_html       = "</td></tr>";
my $highlight_html = "<b style=\"background: #ffffaa\">";

# grab the thesaurus results.
my $ua = LWP::UserAgent->new(agent => 'Mozilla/4.76 [en] (Win98; U)');
my $data = $ua->get("$base_url" . uri_escape($word))->content;

# holders for matches.
my (@synonyms, @antonyms);

# and now loop through them all.
while ($data =~ /Entry(.*?)<b>Source:<\/b>(.*)/) {
    my $match = $1; $data = $2;

    # strip out the bold marks around the matched word.
    $match =~ s/${highlight_html}([^<]+)<\/b>/$1/;

    # push our results into our various arrays.
    if ($match =~ /Synonyms${middle_html}([^<]*)${end_html}/) {
        push @synonyms, (split /, /, $1);
    }
    elsif ($match =~ /Antonyms${middle_html}([^<]*)${end_html}/) {
        push @antonyms, (split /, /, $1);
    }
}

# sort them with sort::array,
# and return unique matches.
if ($#synonyms > 0) {
    @synonyms = Discard_Duplicates(
        sorting      => 'ascending',
        empty_fields => 'delete',
        data         => \@synonyms,
    );

    print "Synonyms for $word:\n";
    my $quotes = ''; # purtier.
    foreach my $nym (@synonyms) {
        print $quotes . $nym;
        $quotes = ', ';
    } print "\n\n";
}

# same thing as above.
if ($#antonyms > 0) {
    @antonyms = Discard_Duplicates(
        sorting      => 'ascending',
        empty_fields => 'delete',
        data         => \@antonyms,
    );

    print "Antonyms for $word:\n";
    my $quotes = ''; # purtier.
    foreach my $nym (@antonyms) {
        print $quotes . $nym;
        $quotes = ', ';
    } print "\n";
}
