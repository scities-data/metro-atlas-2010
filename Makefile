# Author: Rémi Louf <remi@sciti.es>
# 2000 US Metropolitan Atlas
# Census geographies for each Metropolitan Area in the US



# Extract all geographies
all: counties tracts blockgroups blocks msa us

# Census Geographies
us: shp_us
msa: shp_msa
counties: shp_counties
tracts: shp_tracts
blockgroups: shp_blockgroups
blocks: shp_blocks

# Other features
#roads:
#water:
#landmarks:
#topojson extraction




#
# DOWNLOAD DATA
#
download: download_us download_counties download_tracts download_blockgroups download_blocks



# Download definition of MSA and write county crosswalk
data/crosswalks/msa_county.csv data/names/msa.csv: data/gz/List1.xls
	mkdir -p data/crosswalks
	mkdir -p data/names	
	python bin/crosswalks/msa_counties.py

data/gz/List1.xls:
	mkdir -p $(dir $@)
	curl "https://www.census.gov/population/metro/files/lists/2013/$(notdir $@)" -o $@.download
	mv $@.download $@



# Download national boundaries
data/gz/%.tar.gz:
	mkdir -p $(dir $@)
	curl 'http://dds.cr.usgs.gov/pub/data/nationalatlas/$(notdir $@)' -o $@.download
	mv $@.download $@

data/shp/us/us_unmerged.shp: data/gz/nationalp010g_nt00797.tar.gz
	rm -rf $(basename $@)
	mkdir -p $(basename $@)
	tar -xzm -C $(basename $@) -f $<
	for file in $(basename $@)/*; do chmod 644 $$file; mv $$file $(basename $@).$${file##*.}; done
	rmdir $(basename $@)

download_us: data/shp/us/us_unmerged.shp 



## Download counties
data/gz/tl_2010_us_county10.zip:
	mkdir -p $(dir $@)
	curl 'http://www2.census.gov/geo/tiger/TIGER2010/COUNTY/2010/$(notdir $@)' -o $@.download
	mv $@.download $@

data/shp/us/counties.shp: data/gz/tl_2010_us_county10.zip
	rm -rf $(basename $@)
	mkdir -p $(basename $@)
	unzip -d $(basename $@) $<
	for file in $(basename $@)/*; do chmod 644 $$file; mv $$file $(basename $@).$${file##*.}; done
	rmdir $(basename $@)
	touch $@

download_counties: data/shp/us/counties.shp



## Download census tracts
data/gz/tl_2010_%_tract10.zip:
	mkdir -p $(dir $@)
	curl 'http://www2.census.gov/geo/tiger/TIGER2010/TRACT/2010/$(notdir $@)' -o $@.download
	mv $@.download $@

data/shp/state/%/tracts.shp: data/gz/tl_2010_%_tract10.zip
	rm -rf $(basename $@)
	mkdir -p $(basename $@)
	unzip -d $(basename $@) $<
	for file in $(basename $@)/*; do chmod 644 $$file; mv $$file $(basename $@).$${file##*.}; done
	rmdir $(basename $@)
	touch $@

download_tracts: data/shp/state/01/tracts.shp data/shp/state/02/tracts.shp data/shp/state/04/tracts.shp data/shp/state/05/tracts.shp data/shp/state/06/tracts.shp data/shp/state/08/tracts.shp data/shp/state/09/tracts.shp data/shp/state/10/tracts.shp data/shp/state/11/tracts.shp data/shp/state/12/tracts.shp data/shp/state/13/tracts.shp data/shp/state/15/tracts.shp data/shp/state/16/tracts.shp data/shp/state/17/tracts.shp data/shp/state/18/tracts.shp data/shp/state/19/tracts.shp data/shp/state/20/tracts.shp data/shp/state/21/tracts.shp data/shp/state/22/tracts.shp data/shp/state/23/tracts.shp data/shp/state/24/tracts.shp data/shp/state/25/tracts.shp data/shp/state/26/tracts.shp data/shp/state/27/tracts.shp data/shp/state/28/tracts.shp data/shp/state/29/tracts.shp data/shp/state/30/tracts.shp data/shp/state/31/tracts.shp data/shp/state/32/tracts.shp data/shp/state/33/tracts.shp data/shp/state/34/tracts.shp data/shp/state/35/tracts.shp data/shp/state/36/tracts.shp data/shp/state/37/tracts.shp data/shp/state/38/tracts.shp data/shp/state/39/tracts.shp data/shp/state/40/tracts.shp data/shp/state/41/tracts.shp data/shp/state/42/tracts.shp data/shp/state/44/tracts.shp data/shp/state/45/tracts.shp data/shp/state/46/tracts.shp data/shp/state/47/tracts.shp data/shp/state/48/tracts.shp data/shp/state/49/tracts.shp data/shp/state/50/tracts.shp data/shp/state/51/tracts.shp data/shp/state/53/tracts.shp data/shp/state/54/tracts.shp data/shp/state/55/tracts.shp data/shp/state/56/tracts.shp data/shp/state/60/tracts.shp data/shp/state/66/tracts.shp data/shp/state/69/tracts.shp data/shp/state/72/tracts.shp data/shp/state/78/tracts.shp 



## Download census block-groups
data/gz/tl_2010_%_bg10.zip:
	mkdir -p $(dir $@)
	curl 'http://www2.census.gov/geo/tiger/TIGER2010/BG/2010/$(notdir $@)' -o $@.download
	mv $@.download $@

data/shp/state/%/blockgroups.shp: data/gz/tl_2010_%_bg10.zip
	rm -rf $(basename $@)
	mkdir -p $(basename $@)
	unzip -d $(basename $@) $<
	for file in $(basename $@)/*; do chmod 644 $$file; mv $$file $(basename $@).$${file##*.}; done
	rmdir $(basename $@)
	touch $@

download_blockgroups: data/shp/state/01/blockgroups.shp data/shp/state/02/blockgroups.shp data/shp/state/04/blockgroups.shp data/shp/state/05/blockgroups.shp data/shp/state/06/blockgroups.shp data/shp/state/08/blockgroups.shp data/shp/state/09/blockgroups.shp data/shp/state/10/blockgroups.shp data/shp/state/11/blockgroups.shp data/shp/state/12/blockgroups.shp data/shp/state/13/blockgroups.shp data/shp/state/15/blockgroups.shp data/shp/state/16/blockgroups.shp data/shp/state/17/blockgroups.shp data/shp/state/18/blockgroups.shp data/shp/state/19/blockgroups.shp data/shp/state/20/blockgroups.shp data/shp/state/21/blockgroups.shp data/shp/state/22/blockgroups.shp data/shp/state/23/blockgroups.shp data/shp/state/24/blockgroups.shp data/shp/state/25/blockgroups.shp data/shp/state/26/blockgroups.shp data/shp/state/27/blockgroups.shp data/shp/state/28/blockgroups.shp data/shp/state/29/blockgroups.shp data/shp/state/30/blockgroups.shp data/shp/state/31/blockgroups.shp data/shp/state/32/blockgroups.shp data/shp/state/33/blockgroups.shp data/shp/state/34/blockgroups.shp data/shp/state/35/blockgroups.shp data/shp/state/36/blockgroups.shp data/shp/state/37/blockgroups.shp data/shp/state/38/blockgroups.shp data/shp/state/39/blockgroups.shp data/shp/state/40/blockgroups.shp data/shp/state/41/blockgroups.shp data/shp/state/42/blockgroups.shp data/shp/state/44/blockgroups.shp data/shp/state/45/blockgroups.shp data/shp/state/46/blockgroups.shp data/shp/state/47/blockgroups.shp data/shp/state/48/blockgroups.shp data/shp/state/49/blockgroups.shp data/shp/state/50/blockgroups.shp data/shp/state/51/blockgroups.shp data/shp/state/53/blockgroups.shp data/shp/state/54/blockgroups.shp data/shp/state/55/blockgroups.shp data/shp/state/56/blockgroups.shp data/shp/state/60/blockgroups.shp data/shp/state/66/blockgroups.shp data/shp/state/69/blockgroups.shp data/shp/state/72/blockgroups.shp data/shp/state/78/blockgroups.shp 



## Download census blocks
data/gz/tl_2010_%_tabblock10.zip:
	mkdir -p $(dir $@)
	curl 'http://www2.census.gov/geo/tiger/TIGER2010/TABBLOCK/2010/$(notdir $@)' -o $@.download
	mv $@.download $@

data/shp/state/%/blocks.shp: data/gz/tl_2010_%_tabblock10.zip
	rm -rf $(basename $@)
	mkdir -p $(basename $@)
	unzip -d $(basename $@) $<
	for file in $(basename $@)/*; do chmod 644 $$file; mv $$file $(basename $@).$${file##*.}; done
	rmdir $(basename $@)
	touch $@

download_blocks: data/shp/state/01/blocks.shp data/shp/state/02/blocks.shp data/shp/state/04/blocks.shp data/shp/state/05/blocks.shp data/shp/state/06/blocks.shp data/shp/state/08/blocks.shp data/shp/state/09/blocks.shp data/shp/state/10/blocks.shp data/shp/state/11/blocks.shp data/shp/state/12/blocks.shp data/shp/state/13/blocks.shp data/shp/state/15/blocks.shp data/shp/state/16/blocks.shp data/shp/state/17/blocks.shp data/shp/state/18/blocks.shp data/shp/state/19/blocks.shp data/shp/state/20/blocks.shp data/shp/state/21/blocks.shp data/shp/state/22/blocks.shp data/shp/state/23/blocks.shp data/shp/state/24/blocks.shp data/shp/state/25/blocks.shp data/shp/state/26/blocks.shp data/shp/state/27/blocks.shp data/shp/state/28/blocks.shp data/shp/state/29/blocks.shp data/shp/state/30/blocks.shp data/shp/state/31/blocks.shp data/shp/state/32/blocks.shp data/shp/state/33/blocks.shp data/shp/state/34/blocks.shp data/shp/state/35/blocks.shp data/shp/state/36/blocks.shp data/shp/state/37/blocks.shp data/shp/state/38/blocks.shp data/shp/state/39/blocks.shp data/shp/state/40/blocks.shp data/shp/state/41/blocks.shp data/shp/state/42/blocks.shp data/shp/state/44/blocks.shp data/shp/state/45/blocks.shp data/shp/state/46/blocks.shp data/shp/state/47/blocks.shp data/shp/state/48/blocks.shp data/shp/state/49/blocks.shp data/shp/state/50/blocks.shp data/shp/state/51/blocks.shp data/shp/state/53/blocks.shp data/shp/state/54/blocks.shp data/shp/state/55/blocks.shp data/shp/state/56/blocks.shp data/shp/state/60/blocks.shp data/shp/state/66/blocks.shp data/shp/state/69/blocks.shp data/shp/state/72/blocks.shp data/shp/state/78/blocks.shp 






##################
## Prepare data ##
##################

# Extract CBSA names
data/misc/cbsa_names.txt: data/gz/List1.xls
	mkdir -p $(dir $@)
	python2 bin/names/cbsa_names.py



# Blockgroups
## Crosswalk blockgroups and CBSA
data/crosswalks/cbsa_blockgroup.txt: download_blockgroups data/crosswalks/cbsa_county.txt
	mkdir -p $(dir $@)
	python2 bin/crosswalks/cbsa_blockgroup.py

## Shapefile blockgroups for each CBSA
shapefile_blockgroups: data/misc/cbsa_names.txt data/crosswalks/cbsa_blockgroup.txt
	mkdir -p data/shp/cbsa
	python2 bin/shp/blockgroups.py



# Tracts
## Crosswalk tracts and CBSA
data/crosswalks/cbsa_tract.txt: download_tracts data/crosswalks/cbsa_county.txt
	mkdir -p $(dir $@)
	python2 bin/crosswalks/cbsa_tract.py


# Counties
## Crosswalk counties and CBSA
data/crosswalks/cbsa_county.txt: data/gz/List1.xls
	mkdir -p $(dir $@)
	python2 bin/crosswalks/cbsa_county.py

## Shapefile counties for each CBSA
shapefile_counties: data/crosswalks/cbsa_county.txt data/misc/cbsa_names.txt 
	mkdir -p data/shp/cbsa
	python2 bin/shp/counties.py
