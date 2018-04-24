#!/bin/bash

#########################################################################
# Purpose: Creates and populates database 'ncbi' with NCBI Taxonomy 
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
pname=$pname
pname_header=$pname_header_prefix" '"$pname"'"

# Confirm operation
source "$DIR/includes/confirm.sh"

#########################################################################
# Main
#########################################################################

: <<'COMMENT_BLOCK_1'


# Check that data directory exists
if [ ! -d "$DATA_DIR" ]; then
	echo "ERROR: Data directory  \"$DATA_DIR\" doesn't exist. Please create it before before running this script."; echo
	exit 1
fi
COMMENT_BLOCK_1

# Prompt to replace dev schema exists before starting
# Safer to do this manually
#db_exists=$(exists_db_psql -d $db -u $user )
if psql -lqt | cut -d \| -f 1 | grep -qw $db; then
	echo "ERROR: Database '$db' already exists! Drop first before running this script."; echo
	exit 1
fi

############################################
# Download data
############################################

echoi $e "Downloading files from ftp site:"
if [[ "$download" == "t" ]]; then
	echoi $e " - Source url: $src_url"
	echoi $e " - Target directory: $DATA_DIR"
	
	# Delete file if it already exists
	if [ -f $DATA_DIR"/"$src_file ]; then	
		rm $DATA_DIR"/"$src_file
	fi
	
	echoi $e -n " - Downloading..."
	target_dir=$DATA_DIR"/"
	wget $src_url -P $target_dir -q
	source "$DIR/includes/check_status.sh"
	
	echoi $e -n " - Extracting..."	
	tar -xzf $DATA_DIR"/"$src_file -C $DATA_DIR"/"
	source "$DIR/includes/check_status.sh"
else 
	echoi $e "skipping download"
fi 

############################################
# Create empty user development schema 
############################################

# Create database as user postgres in case user $user does not have
# CREATE DATABASE privileges
echoi $e -n "Creating database '$db'..."
sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql --set ON_ERROR_STOP=1 -q -c "CREATE DATABASE ncbi"
source "$DIR/includes/check_status.sh"	

echoi $e -n "Changing owner of database '$db' to $user..."
sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql --set ON_ERROR_STOP=1 -q -c "ALTER DATABASE ncbi OWNER TO bien"
source "$DIR/includes/check_status.sh"	

# Create tables
echoi $e -n "Creating tables..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$sch_users_dev -f $DIR_LOCAL/sql/create_tables.sql
source "$DIR/includes/check_status.sh"

############################################
# Import NCBI data
############################################

echoi $e "Loading tables:"

for tbl in $tables; do
	echoi $i -n "- $tbl: "
	filename=$tbl".dmp"
	tempfile=$filename".tmp"
	
	# Fix character encoding if required
	if [[ `file $DATA_DIR/$filename` =~ "ISO-8859" ]]; then
		echoi $i -n "converting ISO-8859..."
		iconv -f ISO-8859-1 $DATA_DIR/$filename -t UTF-8 -o $DATA_DIR/$tempfile
	else
		cp $DATA_DIR/$filename $DATA_DIR/$tempfile
	fi
	
	# Remove tabs and save as temp file
	# tabs not needed because already delimited by pipe
	echoi $i -n "fixing tabs..."
	tr -d "\t" < $DATA_DIR/$tempfile > $DATA_DIR/temp
	mv $DATA_DIR/temp $DATA_DIR/$tempfile
		
	# Remove final delimiter, not needed in addition to line ending
	echoi $i -n "delimiters..."
	sed -r 's/(.*)|/\1xxxx/' $DATA_DIR/$tempfile | sed 's/|xxxx//g' > $DATA_DIR/temp
	mv $DATA_DIR/temp $DATA_DIR/$tempfile

	if [[ "$tbl" = "names" ]]; then
		echoi $i -n "misc errors..."
		sed -i 's/|Microtetraspora parvosata subsp. kistnae"/|Microtetraspora parvosata subsp. kistnae/g' $DATA_DIR/$tempfile
	elif [[ "$tbl" = "citations" ]]; then
		echoi $i -n "misc errors..."
		sed -i 's/\"Chemolithotrophic growth of Desulfovibrio sulfodismutans sp. nov. by disproportionation of inorganic sulfur compounds./\"Chemolithotrophic growth of Desulfovibrio sulfodismutans sp. nov. by disproportionation of inorganic sulfur compounds.\\"/g' $DATA_DIR/$tempfile
		sed -i 's/\"Culture purity assessments and morphological dissociation in the pleomorphic microorganism Bacterionema matruchotii. Appl. Microbiol./\"Culture purity assessments and morphological dissociation in the pleomorphic microorganism Bacterionema matruchotii. Appl. Microbiol.\\"/g' $DATA_DIR/$tempfile
		sed -i 's/ | DOI/. DOI/g' $DATA_DIR/$tempfile
		sed -i 's/Appleyard,S.A., Osterhage,D., Pogonoski,J. and White,W. |/Appleyard,S.A., Osterhage,D., Pogonoski,J. and White,W. /g' $DATA_DIR/$tempfile
		sed -i 's/\"Especies de Xanthomonas causantes de enfermedades en frutales de hueso y almendro: diagnostico, diversidad genetica y taxonomIa/\"Especies de Xanthomonas causantes de enfermedades en frutales de hueso y almendro: diagnostico, diversidad genetica y taxonomIa\\"/g' $DATA_DIR/$tempfile
		# These next two delete ridiculous record with multiple
		# embedded line endings
		sed -i 's/7|Dissanayake A.J. et al. Saprobic/xxxx7|Dissanayake A.J. et al. Saprobic/g' $DATA_DIR/$tempfile
		sed -i '/xxxx/d' $DATA_DIR/$tempfile 
	fi
			
	echoi $i -n "loading..."
	sql="
	\COPY ${tbl} FROM '${DATA_DIR}/${tempfile}' WITH CSV DELIMITER '|' QUOTE '\"';
	"
	PGOPTIONS='--client-min-messages=warning' psql -d $db -q << EOF
	\set ON_ERROR_STOP on
	$sql
EOF
	source "$DIR/includes/check_status.sh"
	
	rm $DATA_DIR/$tempfile
done

############################################
# Create indexes and constraints
############################################

echoi $e -n "Creating indexes and constraints..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -f $DIR_LOCAL/sql/add_indexes_constraints.sql
source "$DIR/includes/check_status.sh"

######################################################
# Report total elapsed time and exit
######################################################

source "$DIR/includes/finish.sh"
