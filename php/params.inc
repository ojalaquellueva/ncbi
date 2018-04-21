<?php

//////////////////////////////////////////////////
// Paths to required functions and utilities
//
// If desired, $local_utilities_path and $global_utilities_path
// can be the same. I keep them separate to distinguish between
// TNRS-related functions and universal functions used by all
// PHP applications. Up to you.
//////////////////////////////////////////////////

$local_utilities_path="functions/php/";
$global_utilities_path="../functions/php/";

//////////////////////////////////////////////////
// Db connection info
//////////////////////////////////////////////////

$HOST = "localhost";	// Server name; 'localhost' if this machine
$USER = "bien";			// Postgres user name, must have full permissions
$DB = "ncbi";			// Name of database

//////////////////////////////////////////////////
// Adjust available memory
//////////////////////////////////////////////////

// Temporary PHP memory limit
// Increase this amount if scripts in taxamatch_tables/ 
// subdirectory trigger memory overflow error
// Comment out if not needed
ini_set("memory_limit","3000M");

//////////////////////////////////////////////////
// Load functions and utilities
//////////////////////////////////////////////////

include $global_utilities_path."functions.inc";
include $global_utilities_path."taxon_functions.inc";
include $global_utilities_path."sql_functions.inc";
$timer_on=$global_utilities_path."timer_on.inc";
$timer_off=$global_utilities_path."timer_off.inc";

//////////////////////////////////////////////////
// Error-reporting & runtime behavior
//////////////////////////////////////////////////

// echos error messages to screen
$echo_on = true;		

// aborts entire script on error
$die_on_fail = true;		

// default success and fail messages
$msg_success = "done\r\n";
$done = $msg_success; 
$msg_fail = "failed!\r\n";

//////////////////////////////////////////////////
// Tree traversal parameters
//////////////////////////////////////////////////

// These parameters affect population of left and right indices
// used for ancestor/descendent searches

// name of root
$root_name = "root";		

// name of root rank
$root_rank = "root";	

// Set FALSE if table already contains root record
$add_root = FALSE;		

// Adds temporary node above root during indexing
// Must set=TRUE if any taxa lack parentID in 
// original data ("orphan taxa") otherwise 
// traversal will fail
$preroot = FALSE;	

//////////////////////////////////////////////////
// Table & column names
//////////////////////////////////////////////////

$tbl = "nodes";			
$id_fld = "tax_id";					// Name of ID field (PK) for this table
$parent_id_fld = "parent_tax_id";	// Name of recursive FK to PK
$left_index_fld = "left_index";		// Name of left index field
$right_index_fld = "right_index";	// Name of right index field
$rank_fld="rank";					// Name of rank field
$root_name="root";					// Name of root; MUST be unique
$name_fld="scientific_name"			// Name of scientific name field


?>
