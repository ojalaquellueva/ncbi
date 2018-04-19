# Creates and populates database 'ncbi' with ncbi taxonomy

Author: Brad Boyle (bboyle@email.arizona.edu)  

### Contents

I. Overview  
II. Usage  
III. Dependencies 

### I. Overview

Creates and populates database 'ncbi' with phylogeny and taxonomy from NCBI Taxonomy (https://www.ncbi.nlm.nih.gov/taxonomy). Content downloaded from NCBI Taxonomy ftp site (ftp://ftp.ncbi.nih.gov/pub/taxonomy).

Adds and populates right & left indexes using Modified Preorder Tree Traversal. Indexes allow retrieval of all descendents (children) or ancestors (parents) of a given node.

### II. Usage

```
./ncbi.sh [options]

```

* Options:  
-m: Send notification emails  
-s: Silent mode  

* Notes:
  * Operation will abort if any SQL fails
  * If table already exists, will replace
  * Recommend -m switch to generate start, stop and error emails (will abort  
    on error). Valid email must be provided in params.sh.
  * WARNING: Run from unix "screen" session; complete operation may take 
  	several days.