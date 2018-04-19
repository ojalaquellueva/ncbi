<?php

//////////////////////////////////////////////////////////////////////
// Purpose:
// Check and index taxon table, including tree traversal
//////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
// Parameters etc originally loaded by master file
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////


include "global_params.inc";

////////////////////////////////////////////////////////////
// Run preliminary checks and confirm operations
// All checks are made at beginning to avoid interrupting
// execution later on.
////////////////////////////////////////////////////////////

$HOST=="localhost"?$hostname=exec('hostname -f'):$hostname=$HOST;
$db_backup_display=$use_db_backup===true?"\r\n  Backup database: $DB_BACKUP":"";
$replace_db_display=$replace_db?'Yes':'No';

// Confirm basic parameters 
$msg_proceed="
Rebuilding TNRS database with the following settings:\r\n
  Host: $hostname
  Main database: $DB
  Replace database: $replace_db_display".$db_backup_display."\r\n  Sources: $sources\r\n
Enter 'Yes' to proceed, or 'No' to cancel: ";
$proceed=responseYesNoDie($msg_proceed);
if ($proceed===false) die("\r\nOperation cancelled\r\n");

// Check if database exists
$cmd="mysql -u $USER --password=$PWD -e \"USE '$DB'\" 2>/dev/null";
exec($cmd,$output,$exitcode);
$dbexists=$exitcode;

// Confirm replacement of database if requested
if ($replace_db & !$dbexists) {
	$msg_conf_replace_db="\r\nPrevious database `$DB` will be deleted! Are you sure you want to proceed? (Y/N): ";
	$replace_db=responseYesNoDie($msg_conf_replace_db);
	if ($replace_db===false) die ("\r\nOperation cancelled\r\n");
}

// Confirm deletion of backup database
if ($use_db_backup) {
	$cmd="mysql -u $USER --password=$PWD -e \"USE '$DB_BACKUP'\" 2>/dev/null";
	exec($cmd,$output,$exitcode);
	$dbexists=$exitcode;
	$msg_confirm_delete_db_backup="\r\nAlso replace previous backup database '".$DB_BACKUP."'? (Y/N): ";
	$delete_db_backup=true;
	if (!$dbexists) {
		$delete_db_backup=responseYesNoDie($msg_confirm_delete_db_backup);
		if ($delete_db_backup===false) die ("\r\nOperation cancelled\r\n");		
	}
}

// Check basic dependencies are present: directories, files
// This is currently pretty basic, but can be expanded as needed
include_once "check_dependencies.inc";

// Checks completed
// Start timer and connect to mysql
echo "\r\nBegin operation\r\n";
include $timer_on;
$dbh = mysql_connect($HOST,$USER,$PWD,FALSE,128);
if (!$dbh) die("\r\nCould not connect to database!\r\n");

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
// END Parameters loaded by master file
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////



echo "Preparing staging table for source '$sourceName':\r\n";

//////////////////////////////////////////////////////////////////////
// Check for anomalies in raw names, as loaded to staging table
// Report these errors in error table
// Fix some basic errors by joining to error table
//////////////////////////////////////////////////////////////////////

// Sets NULL any instance of parentNameID=0 or acceptedNameID=0
include "zero_id_set_null.inc";

// Create error table
include "create_error_table.inc";

// Flag bad nameIDs, parentNameIDs, acceptedNameIDs
include "flag_errors.inc";

// Remove orphan parentNameIDs and acceptedNameIDs from staging table
include "fix_errors.inc";

//////////////////////////////////////////////////////////////////////
// More fixes: 
// - translate character set codes
// - flag hybrids and standardize hybrid "x"
// - attempt to link to parent any names with NULL parentNameID
// - populate left and right indexes using modified tree traversal
// - extract atomic name components
// - parse infraspecific taxa if missing
// - standardize infraspecific rank indicators
// - add higher taxa
// - compose redundant nameWithAuthor field
// - create indexed field rankGroup
// - update error table to include only names with errors that 
//   cannot be fixed
//////////////////////////////////////////////////////////////////////

// Fix character set issues, if necessary
// Can turn this step off in params.inc
// by setting $fix_chars=false
include "fix_character_sets.inc";	
	
// Flag hybrids so can exclude in later steps
include "fix_hybrid_x.inc";

// Flag hybrids so can exclude in later steps
include "flag_hybrids.inc";

// Set to NULL any orphan values of parentID
include "delete_orphan_parentIDs.inc";

// Flag any records with parentID=NULL
include "flag_null_parentID.inc";

// Attempt to link to parent any record with parentID=NULL
// Parses "parent" part of name string
// And joins to parent string to discover ID
include "find_parent.inc";

// Find families of genera which have been added by
// parsing in preceding step
include "find_family.inc";

// Remove any duplicate names before indexing
include "delete_duplicates.inc";

// populate right and left indices via modified tree traversal
include "index_taxa.inc";

// Parse name components for any remaining unparsed names
// Also fixes parsing issues peculiar to tropicos 
include "parse_taxa.inc";

// NOTE: need to alter above script to parse name
// components of newly-added parents!!!!!

// Standardize infraspecific rank indicators
// Infraspecific name components must have been parsed prior to this step
include "standardize_rank_indicators.inc";

// Extract higher taxa and atomic name components for remaining taxa
include "higher_taxa.inc";

// Populate nameWithAuthor field
include "nameWithAuthor.inc";

// Populate `rankGroup`
// Distinguishes family, genus, and 'species-and-below' from everything else
// Plan (not yet implemented) is to use to join by genus or family to other
// classifications, and vice versa.
// Under construction
include "rank_groups.inc";

// Set empty strings to NULL
include "standardizeNulls.inc";

// Update error table & remove names without errors
include "update_error_table.inc";

//////////////////////////////////////////////////////////////////
// Close connection and report total time elapsed 
//////////////////////////////////////////////////////////////////

mysql_close($dbh);
include $timer_off;
$msg = "\r\nTotal time elapsed: " . $tsecs . " seconds.\r\n"; 
$msg = $msg . "********* Operation completed " . $curr_time . " *********";
if  ($echo_on) echo $msg . "\r\n\r\n"; 

//////////////////////////////////////////////////////////////////
// End script
//////////////////////////////////////////////////////////////////

?>
