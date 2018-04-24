#!/bin/bash

#########################################################################
# Purpose: Makes table ncbi_taxa, consisting of all species and family
#	name in ncbi taxonomy database. Uses Modified Preorder Tree Traversal 
#	to add left and right indexes to NCBI nodes table. This allows 
#	retrieval of node ancestors or descendents in single query.
#
# Requirement: Fully populated database ncbi must exist. Run 
#	ncbi_1_import.sh first before running this script.
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x
#echo; echo "EXITING script `basename "$BASH_SOURCE"`"; exit 0

######################################################
# Set basic parameters, functions and options
######################################################

# Enable the following for strict debugging only:
#set -e

# The name of this file. Tells sourced scripts not to reload general  
# parameters and command line options as they are being called by  
# another script. Allows component scripts to be called individually  
# if needed
master=`basename "$0"`

# Get working directory
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

# Set local working directory
DIR_LOCAL=$DIR		# In that case, the same

# Load parameters, functions and get command-line options
source "$DIR/includes/startup_master.sh"

# Set data directory
DATA_DIR=$data_base_dir

# Adjust process name for emails and echo, if desired
pname=$pname2
pname_header=$pname_header_prefix" '"$pname"'"

# Confirm operation
source "$DIR/includes/confirm.sh"

#########################################################################
# Main
#########################################################################




: <<'COMMENT_BLOCK_1'




############################################
# Create indexes and constraints
############################################

echoi $e "Preparing source tables:"

echoi $e "- \"names\":"
echoi $e -n "-- Adding primary key..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/names_add_pk.sql
source "$DIR/includes/check_status.sh"

echoi $e "- \"nodes\":"
echoi $e -n "-- Adding mptt index columns..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/add_mptt_index_cols.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "-- Populating scientific name..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/add_names.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "-- Setting root parent ID to null..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/nodes_parent_id_set_null.sql
source "$DIR/includes/check_status.sh"

############################################
# Populate the mptt indexes
############################################

php $DIR/mptt.php




COMMENT_BLOCK_1




############################################
# Create ncbi_taxa
############################################

echoi $e -n "Creating table ncbi_taxa..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/create_ncbi_taxa.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "Populating higher taxa (slow)..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/populate_higher_taxa.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "Populating column major_higher_taxon..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/major_higher_taxon.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "Indexing ncbi_taxa..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/index_ncbi_taxa.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "Cleaning up..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/cleanup_ncbi_taxa.sql
source "$DIR/includes/check_status.sh"


######################################################
# Report total elapsed time and exit
######################################################

source "$DIR/includes/finish.sh"
