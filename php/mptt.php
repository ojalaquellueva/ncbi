<?php

//////////////////////////////////////////////////////////////////////
// Purpose: Populate left and left indices for hierarchical tree searches,
// 	using Modified Preorder Tree Traversal
//////////////////////////////////////////////////////////////////////

include "params.inc";

////////////////////////////////////////////////////////////
// Run preliminary checks and confirm operations
// All checks are made at beginning to avoid interrupting
// execution later on.
////////////////////////////////////////////////////////////

// Confirm basic parameters 
$msg_proceed="
Populate MPTT indexes in table '$tbl' in database '$DB;'?
Enter 'Yes' to proceed, or 'No' to cancel: ";
$proceed=responseYesNoDie($msg_proceed);
if ($proceed===false) die("\r\nOperation cancelled\r\n");

// Check basic dependencies are present: directories, files
// This is currently pretty basic, but can be expanded as needed
//include_once "check_dependencies.inc";

// Checks completed
// Start timer and connect to mysql
echo "\r\nBegin operation\r\n";
include $timer_on;

// Open connection to postgres
$conn_string = "host=$HOST dbname=$DB user=$USER";
$dbconn = pg_connect($conn_string) or die('\r\nCould not connect to database!\r\n');

if ($echo_on) echo "Performing tree traversal:\r\n";

// Add root
// PK MUST be integer; modify if not
echo " Adding root...";
if ($add_root) {
	// get next value of PK
	$sql = "SELECT MAX($id_fld) AS max_id FROM $tbl;";
	$max_id = sql_get_first_result($sql,'max_id');
	//echo "  \r  \nmax_id=$max_id\r\n";
      	$root_id = $max_id + 1; 

	// Add root record
	$sql="INSERT INTO $tbl(\"$id_fld\",\"$name_fld\",\"$rank_fld\")
		SELECT $root_id, '$root_name', '$root_rank';";
	$msg_error = "Failed to add root record!";
	if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));
} else {
	echo "...skipping this step\n";
}

// get root id and do some error checking
echo " Getting root id...";
$sql = "SELECT \"$id_fld\" FROM \"$tbl\" WHERE \"$name_fld\"='$root_name';";
if (!($result = pg_query($dbconn, $sql))) die("Failed to get id of root.\r\n");
$num_rows = pg_num_rows($result);

if ($num_rows<1) {
	die("Error: no root");
} elseif ($num_rows>1) {
	die("Error: more than one root");
} else {
	$row = pg_fetch_row($result);
	$root_id=$row[0];
	echo $done;
}

// Add node above root for linking orphan taxa (no parentTaxonID)
// Indexing algorithm may fail if have multiple taxa linked to root.
echo " Adding pre-root...";
if ($preroot) {
	// get next value of PK
	$sql = "SELECT MAX($id_fld) AS max_id FROM $tbl;";
	$max_id = sql_get_first_result($sql,'max_id');
	//echo "  \r  \nmax_id=$max_id\r\n";
    $preroot_id = $max_id+1; 

	// Add root record
	$sql="
	INSERT INTO $tbl(\"$id_fld\",\"$parent_id_fld\",\"$name_fld\",\"$rank_fld\")
	SELECT $preroot_id, $root_id, 'preroot', 'preroot';
	";
	$msg_error = "Failed to add preroot record!";
	if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));

	// Fix all NULL parentIDs by setting to prerootID 
	// (except root itself --> must have NULL parentID)
	$sql = "
	UPDATE $tbl 
	SET \"$parent_id_fld\"=$preroot_id
	WHERE \"$parent_id_fld\" IS NULL AND $id_fld<>$root_id;
	";
	$msg_error = "Failed to set NULL \"$parent_id_fld\" to PK of preroot!";
	if (sql_execute($sql,$die_on_fail,$echo_on,'',$msg_error));
} else {
	echo "skipping this step\n";
}



/*

// Populate left and right indexes using recursive tree traversal
// Begins at root, traverses tree and returns to root
$ind = 0; 	// starting value of index
if (!($r_ind=get_index($tbl, $root_id, $ind, $id_fld, $parent_id_fld, $left_index_fld, $right_index_fld))) {
	echo "  Indexing error!\r\n";
}

if ($preroot) {
	// Remove root and set preroot to root, and left index to 1
	// this means there will be no left index=2...c'est la vie

	echo "    Removing pre-root...";
	// Delete root
	$sql="DELETE FROM $tbl
		WHERE \"$id_fld\"=$root_id;";
	$msg_error = "Failed to delete temporary root!";
	if (sql_execute($sql,$die_on_fail,$echo_on,'',$msg_error));

	// Reset preroot to root
	$sql="UPDATE $tbl
		SET \"$rank_fld\"='$root_rank', \"$name_fld\"='$root_name', \"$parent_id_fld\"=NULL, \"$left_index_fld\"=1
		WHERE \"$id_fld\"=$preroot_id;";
	$msg_error = "Failed to reset preroot to root!";
	if (sql_execute($sql,$die_on_fail,$echo_on,$msg_success,$msg_error));
}

*/

////////////////////////////////
// Close connection and exit
////////////////////////////////

pg_close($dbconn);
exit("Script completed!\n");

?>
