# Builds PostGreSQL database 'ncbi' with content of ncbi taxonomy and creates
# additional table, ncbi_taxa, consisting of all NCBI species (binomial) and
# family names, plus their major higher taxa 

Author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents

I. Overview  
II. Usage  
III. Dependencies 

### I. Overview

Creates and populates database 'ncbi' with phylogeny and taxonomy from NCBI Taxonomy (https://www.ncbi.nlm.nih.gov/taxonomy). Content downloaded from NCBI Taxonomy ftp site (ftp://ftp.ncbi.nih.gov/pub/taxonomy).

Adds and populates right & left indexes using Modified Preorder Tree Traversal. Indexes allow retrieval of all descendents (children) or ancestors (parents) of a given node. Script 'mptt.php' (+required functions in functions/php/) is called in this step. Finally, creates table 'ncbi_taxa' by extracting all family and species names from ncbi taxonomy tables, and populates denormalized major higher taxon fields ('superkingdom', 'kingdom', 'phylum', 'class') using the MPTT indexes. This table used by BIEN to match and flag non-plant and non-embryophyte names in the BIEN database.

mptt_standalone.php: Standalone script which populates mptt indexes (left_index, right_index) in any hierarchically-structured table which uses (1) integer primary key and (2) integer recursive foreign key linking children to immediate parents. 

### II. Usage

1. Import ncbi taxonomy to postgres database 'ncbi':

```
./import_ncbi.sh [options]

```
* Parameters must be set in:
	** params.sh

* Options:  
-m: Send notification emails  
-s: Silent mode  


2. Create table ncbi_taxa in database "ncbi":

```
./ncbi_taxa.sh [options]

```

* Parameters must be set in:
	** params.sh
	** params.inc.php (used by 'mptt.php')

* Options:  
-m: Send notification emails  
-s: Silent mode  

3. Populate mptt indexes (left_index, right_index) in any hierarchically-structured table which uses (1) integer primary key and (2) integer recursive foreign key linking children to immediate parents. 

```
php mptt_standalone.php

```
 
* Parameters & options set in:
	** params.inc.php
	
III. Dependencies 

1. *nix OS (developed on Ubuntu 14.04.5)
2. PHP 5.+ (may not work on PHP >=7	