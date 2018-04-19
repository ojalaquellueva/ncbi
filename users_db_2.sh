#!/bin/bash

#########################################################################
# Purpose: Create and populate BIEN schema 'users' in core database 
#	'vegbien' - Step 2
#
# Step 2: 
#	- Import manually-edited spreadsheet (CSV file) of user data
# 		and update users database. 
# 	- Populate missing links between parties and datasets
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x

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
# Import user spreadsheet and update users table
############################################

echoi $e "Importing revised party data from CSV:"

echoi $e -n "Creating temp table party_revised..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$sch_users_dev -v user_adm=$user -f $DIR_LOCAL/sql/create_party_revised.sql
source "$DIR/includes/check_status.sh"

# Import csv file to temp table
echoi $i -n "- Importing user data..."
sql="
\COPY party_revised FROM '${DATA_DIR}/${bien_users_revised_filename}' DELIMITER ',' CSV HEADER;
"
PGOPTIONS='--client-min-messages=warning' psql -d $db_private -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $sch_users_dev;
$sql
EOF
source "$DIR/includes/check_status.sh"

echoi $e -n "- Updating table party..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$sch_users_dev -f $DIR_LOCAL/sql/update_users.sql
source "$DIR/includes/check_status.sh"

: <<'COMMENT_BLOCK_1'
COMMENT_BLOCK_1

############################################
# Update part-source links
############################################

echoi $e -n "Updating source-party links..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$sch_users_dev -f $DIR_LOCAL/sql/update_source_party_links.sql
source "$DIR/includes/check_status.sh"

############################################
# Create simplified view of user-dataset
# relationships
############################################

echoi $e -n "Creating view user_dataset..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$sch_users_dev -f $DIR_LOCAL/sql/create_view_user_dataset.sql
source "$DIR/includes/check_status.sh"

############################################
# Set permissions
############################################

echoi $e "Setting permissions:"

curr_user='bien'
echoi $e -n "- User $curr_user..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v db=$db_private -v usr=$curr_user -v sch=$sch_users_dev -f $DIR_LOCAL/sql/set_permissions_admin.sql
source "$DIR/includes/check_status.sh"

curr_user='jmcgann'
echoi $e -n "- User $curr_user..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v db=$db_private -v usr=$curr_user -v sch=$sch_users_dev -f $DIR_LOCAL/sql/set_permissions_admin.sql
source "$DIR/includes/check_status.sh"

curr_user='bien_private'
echoi $e -n "- User $curr_user..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v db=$db_private -v usr=$curr_user -v sch=$sch_users_dev -f $DIR_LOCAL/sql/set_permissions_admin.sql
source "$DIR/includes/check_status.sh"

######################################################
# Report total elapsed time and exit
######################################################

source "$DIR/includes/finish.sh"
