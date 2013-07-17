#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use LWP::UserAgent;
use Mail::Send;
use Time::HiRes qw(gettimeofday tv_interval);

my $email = 'pkeane@mail.utexas.edu';

my $ua = LWP::UserAgent->new;
$ua->agent("MyApp/0.1 ");
my ($elapsed,$date);

my @urls = 
qw{
http://dase.laits.utexas.edu/test.php
http://www.laits.utexas.edu
http://dev.laits.utexas.edu/dase/test.php
http://dev.laits.utexas.edu
http://www.laits.utexas.edu/germans_from_russia
http://www.utexas.edu
http://lib.utexas.edu
};

runTest(@urls);

sub runTest {
	my @urls = @_;
	my ($result,@results,$problem);
	for my $url (@urls) {
		$result = getResponseTime($url);
		push (@results,$result);
		if ($result->{elapsed} > 2.0) {
			$problem = 1;
		}
	}
	if ($problem) {
		notify(\@results);
	}
}

sub getResponseTime {
	my $url = shift;
	my $t0 = [gettimeofday];
	my $req = HTTP::Request->new(GET => $url);
	my $res = $ua->request($req);
	if ($res->is_success) {
		$date = $res->header('Date');
		$elapsed = tv_interval ($t0);
	}
	my $result; 
	$result = {
		url => $url,
		elapsed => $elapsed,
		date => $date,
	};
	return $result;
}

sub notify {
	print "sending mail to $email regarding problem\n";
	my $results = shift;
	my $message;
	for my $res (@$results) {
		$message .= "$res->{url} TIME:  $res->{elapsed} seconds  $res->{date}\n";
	}
	my $sender = Mail::Send->new;   
	$sender->subject( 'possible http problem' );
	$sender->to($email);
	my $fh = $sender->open;   # some default mailer
	print $fh $message;
	$fh->close or die "no go close mailer: $1";
}
