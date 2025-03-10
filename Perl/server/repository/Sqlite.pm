#!/usr/bin/perl
package Sqlite;

use strict;
use warnings;
use DBI;


sub connect {
    my $db_file = "server/db/airline.db";
    my $dbh;

    eval {
        $dbh = DBI->connect("dbi:SQLite:$db_file","","");
    };

    if ($@) {
        die "database is not connected\n"
    } else {
        print "database sqlite is connected\n";
    }

    return $dbh;
}

1;