#!/usr/bin/perl
# google.plx
# A typical Google Web API Perl script
# Usage: perl googly.pl <query>

# Your Google API developer's key
my $google_key='ixR3FeJQFHJaBeMoyD/jE7S9cJ7UWEpG';

# Location of the GoogleSearch WSDL file
my $google_wdsl = "/home/pkeane/googleapi/GoogleSearch.wsdl";

use strict;

# Use the SOAP::Lite Perl module
use SOAP::Lite;

# Take the query from the command-line
my $query = shift @ARGV or die "Usage: perl google.plx <query>\n";

# Create a new SOAP::Lite instance, feeding it GoogleSearch.wsdl
my $google_search = SOAP::Lite->service("file:$google_wdsl");

# Query Google
my $results = $google_search -> 
    doGoogleSearch(
      $google_key, $query, 0, 10, "false", "",  "false",
      "", "latin1", "latin1"
    );

# No results?
@{$results->{resultElements}} or exit;

# Loop through the results
foreach my $result (@{$results->{resultElements}}) {
 # Print out the main bits of each result
 print
  join "\n",  
  $result->{title} || "no title",
  $result->{URL},
  $result->{snippet} || 'no snippet',
  "\n";
}
