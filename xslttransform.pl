#!/usr/bin/perl
use strict;
use warnings;
use XML::LibXSLT;
use XML::LibXML;

my $xslt = XML::LibXSLT->new();

if ($#ARGV lt 1) {
	print "Usage: <xsl> <xml>\n";
	exit(0);
}

open(FILE, "$ARGV[1]") or die "File not found: $ARGV[1]";
my $style_doc = XML::LibXML->load_xml(location=>"$ARGV[0]", no_cdata=>1);
my $stylesheet = $xslt->parse_stylesheet($style_doc);

my $record;
while ($record = <FILE>) {
	if ($record =~ /^<entry /) {
		my $source;
		my $results;
		$record .= <FILE> until $record =~ /<\/entry>$/;
		$source = XML::LibXML->load_xml(string => $record);
		$results = $stylesheet->transform($source);
		print $stylesheet->output_as_bytes($results);
		print "\n";
	}
}

close(FILE);

