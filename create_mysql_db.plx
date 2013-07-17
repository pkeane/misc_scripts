#!/usr/bin/perl

use strict;
use warnings;
use DBI;


my $newdb = 'project-name';
my $newdbpass = 'project-pass';

my $user = 'root-user';
my $pass = 'root-pass';

my $dsn = "DBI:mysql:host=localhost;database=mysql";
my $dbh = DBI->connect($dsn,$user,$pass) or die "cannot connect";

#$dbh->do("CREATE DATABASE $newdb");
$dbh->do("GRANT ALL ON $newdb.* TO $newdb\@localhost IDENTIFIED BY '$newdbpass'");
$dbh->do("FLUSH PRIVILEGES");


