""" cbas_names.py

Extract the names of CBSAs from the list given by the OMB.
"""
from xlrd import open_workbook




#
# READ DATA
#
book = open_workbook('data/gz/List1.xls',on_demand=True)
for sheet_name in book.sheet_names():
    sheet = book.sheet_by_name(sheet_name)
    
    # Read
    ## CBSA fips
    cbsa_fips = []
    for i,cell in enumerate(sheet.col(0)): # 
        if i>2 and i<1885:
            cbsa_fips.append( (cell.value).encode('utf8') )

    ## Names
    names = []
    for i,cell in enumerate(sheet.col(3)): # 
        if i>2 and i<1885:
            names.append( (cell.value).encode('utf8') )

    ## Status
    status = []
    for i,cell in enumerate(sheet.col(4)): # 
        if i>2 and i<1885:
            status.append( (cell.value).encode('utf8') )

    ## County fips
    county_fips = []
    for i,(cell1,cell2) in enumerate(zip(sheet.col(9), sheet.col(10))): # 
        if i>2 and i<1885:
            county_fips.append( (cell1.value).encode('utf8') +
                                (cell2.value).encode('utf8') )
    

    # Assemble
    name_list = {}
    for name, c, county, status in zip(names, cbsa_fips, county_fips, status):
        name_list[c] = {'name': name,
                        'status': status}

    book.unload_sheet(sheet_name) 




#
# WRITE DATA
#

# Names
with open('data/misc/cbsa_names.txt', 'w') as output:
    output.write('CBSA FIPS CODE\tCBSA NAME\tSTATUS\n')
    for c in name_list:
        output.write('%s\t%s\t%s\n'%(c, name_list[c]['name'],
                                        name_list[c]['status']))
