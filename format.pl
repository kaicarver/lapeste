#!/usr/bin/perl

# Add some newlines where missing in La Peste text
# to make copyediting less tedious

# Usage:
#   ./format.pl lapeste.md | \
#     perl -pe 's/\n\n\n+/\n\n/g' -0777 > formatted.md 

while (<>) {
    print "\n" if /^(-|–) /;
    #print length $_, " ";
    print $_;
    print "\n" if length($_) < 40;
}