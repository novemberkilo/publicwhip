# $Id: SQLfragments.pm,v 1.2 2005/01/14 09:01:31 theyworkforyou Exp $
# Set of reusable standard SQL statements.

# This is free software, and you are welcome to redistribute it under
# certain conditions.  However, it comes with ABSOLUTELY NO WARRANTY.
# For details see the file LICENSE.html in the top level of the source.

package PublicWhip::SQLfragments;
use strict;

sub divisions_query_start {
	return "
		select pw_division.division_id,
		       division_number, division_date, division_name, source_url,
		       rebellions, turnout, motion from pw_division, pw_cache_divinfo where
		       pw_division.division_id = pw_cache_divinfo.division_id ";
}

sub divisions_controversial {
	return "
		 and rebellions > 10
		 and pw_division.division_id = pw_cache_divinfo.division_id 
            order by division_date desc
	";
}


sub parliament_query_range_div
{
   my $parliament= shift;
   return " division_date <= '" .  $parliament->{"to"} . "' and division_date >= '".  $parliament->{"from"} . "' ";
}




1;
