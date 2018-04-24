<?php

//////////////////////////////////////////////////////////////////////
// Purpose: Populate left and left indices for hierarchical tree searches,
// 	using Modified Preorder Tree Traversal
//////////////////////////////////////////////////////////////////////

include "params.inc.php";

////////////////////////////////////////////////////////////
// Run preliminary checks and confirm operation
// All checks are made at beginning to avoid interrupting
// execution later on.
////////////////////////////////////////////////////////////

// Open connection to postgres
$conn_string = "host=$HOST dbname=$DB user=$USER";
$dbconn = pg_connect($conn_string) or die('\r\nCould not connect to database!\r\n');

if ($echo_on) echo "Performing tree traversal:\r\n";

// get root id and do some error checking
echo "- Getting root id...";
$sql = "
SELECT \"$id_fld\", \"$parent_id_fld\"
FROM \"$tbl\" 
WHERE \"$name_fld\"='$root_name';
";
if (!($result = pg_query($dbconn, $sql))) die("Failed to get id of root.\r\n");

// Get number of rows
$num_rows = pg_num_rows($result);

// Get parent_id for root; MUST be null
$row = pg_fetch_array($result);
$parent_id = $row[1];

if ($num_rows<1) {
	die("Error: no root\n");
} elseif ($num_rows>1) {
	die("Error: more than one root\n");
} elseif (!is_null($parent_id)) {
	die("Error: \"$parent_id_fld\" MUST be null for root (\"$parent_id_fld\"=$parent_id)\n");
} else {
	//$row = pg_fetch_row($result);
	$root_id=$row[0];
	echo $done;
}

// Populate left and right indexes using recursive tree traversal
// Begins at root, traverses tree and returns to root
echo "- Populating mptt indexes:\n";
$ind = 0; 	// starting value of index
if (!($r_ind=get_index($dbconn, $tbl, $root_id, $ind, $id_fld, $parent_id_fld, $left_index_fld, $right_index_fld))) {
	echo "Indexing error!\r\n";
}

////////////////////////////////
// Close connection and exit
////////////////////////////////

pg_close($dbconn);

//////////////////////////////////////////////////////////////////
// End script
//////////////////////////////////////////////////////////////////

?>
