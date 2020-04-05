#!/usr/bin/perl

# identify and fix molecule formulas in OCR text

# Here's what I'd like to do:
# list a bunch of patterns of badly written formulas, 
# that I casn replace with a properly written formula, with subscripts
# But I'd like it to be exploratory, with a fall back of a catch-all pattern
# that tells me, here are some formulas that you have not identified precisely enough to be replaced 
# so I want to list a set of patterns to be tyried in order
# and in an exploratory way, I want to see what I haven't caught yet, 
# so I can add the required patterns and how they should be replaced
# so TODO: figure out how to create a bunch of Perl search (and replace) patterns
# taht I can try one by one

$patterns =<<END;
CH 3 N0 3	CH3NO3
 N 2 0 4 
 OF 2 
END

while (<>) {
	$note = "";
	# BUG should not be if else, should be a series of if, then the catchall which gives KO if a match
	# with maybe two notes: an OK to say something was replaced on the line, and a KO to say more needs to be done
	if (/CH 3 N0 3/) {
		s/CH 3 N0 3/CH3NO3/g;
		$note = "OK";
	} elsif (/CH 3 N0 2/) {
		s/CH 3 N0 2/CH3NO2/g;
		$note = "OK";
	} elsif (/N0 3/) {
		s/N0 3/NO3/g;
		$note = "OK";
	} elsif (/N0 2/) {
		s/N0 2/NO2/g;
		$note = "OK";
	} elsif (/N[ ]?0/) {
		# catchall
		$note = "KO";
	}
	print "$note $_" if $note;
}
