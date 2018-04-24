#!/bin/bash

#########################################################################
# Purpose: Uses Modified Preorder Tree Traversal to add left and right 
#	indexes to NCBI nodes table. Allows retrieval of node ancestors or 
#	descendents in single query.
#
# Requirement: Fully populated database ncbi must already exist.
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


############################################
# Create indexes and constraints
############################################

echoi $e "Preparing table nodes:"

echoi $e -n "- Adding mptt index columns..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/add_mptt_index_cols.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "- Adding & populating scientific name column..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/add_names.sql
source "$DIR/includes/check_status.sh"

############################################
# Populate the mptt indexes
############################################

source "$DIR/mptt.php"

######################################################
# Report total elapsed time and exit
######################################################

source "$DIR/includes/finish.sh"
