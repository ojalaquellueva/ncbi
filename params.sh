#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Download data from NCBI ftp site (t/f)
# Set to false if data already present in data directory and does
# not need a refresh
download='t'

# URL of ncbi taxonomy ftp site
url="ftp://ftp.ncbi.nih.gov/pub/taxonomy"

# Name of file to download
src_file="taxdump.tar.gz"

# full target
src_url=$url"/"$src_file

# Path to db_config.sh
# For production, keep outside app working directory & supply
# absolute path
# For development, if keep inside working directory, then supply
# relative path
# Omit trailing slash
db_config_path="/home/boyle/bien3/ncbi"

# Path to general function directory
# If directory is outside app working directory, supply
# absolute path, otherwise supply relative path
# Omit trailing slash
#functions_path=""
functions_path="/home/boyle/functions/sh"

# Path to data directory
# Recommend call this "data"
# If directory is outside app working directory, supply
# absolute path, otherwise use relative path (i.e., no 
# forward slash at start).
# Recommend keeping outside app directory
# Omit trailing slash
data_base_dir="/home/boyle/bien3/ncbi/data"	# Absolute path
#data_base_dir="data"		 					# Relative path

# NCBI files & the tables to load them to.
# One name per line, no commas or quotes.
# Each line is a full table name and a file basename.
# Extension ".dmp" must be appended to basename to form the full 
# file name (e.g., "name.dmp"). Obviously this name convention 
# MUST be followed for the table names, and all files must be 
# present in data directory
tables="
citations
names
delnodes
division
gencode
merged
nodes
"

# Destination email for process notifications
# You must supply a valid email if you used the -m option
email="bboyle@email.arizona.edu"

# Short name for this operation, for screen echo and 
# notification emails. Number suffix matches script suffix
pname="Build database 'ncbi'"
pname2="Populate MPTT indexes"
pname3="Create ncbi_taxa"

# General process name prefix for email notifications
pname_header_prefix="BIEN notification: process"