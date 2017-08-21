#!/bin/bash
# This runs a series of transformations because it is better to do them modularly in case we detect a problem in one of them at a later date.
# This assumes there are 3 files, reg1.xml, reg2.xml, reg3.xml I could do this with a for loop but may want to run different scripts on different volumes.
shopt -s expand_aliases
source /home/jamesc/.aliases

#Register 1
echo "reg1.xml"
#1. Convert <note type =‘editorial’ resp=“#Arber”> to <note resp="#Arber> …. unless you can think of a reason to do the reverse (they are inconsistent at the moment). 
#2. Insert ‘Arber:' at beginning of Arber notes (but not to <supplied resp=‘Arber'>
echo "Converting notes"
saxon -o:reg1a.xml -s:reg1.xml -xsl:replace-notes.xsl

#3. Delete date text, and display @values in the metadata, having corrected date @values from Ian’s sheet
echo "Replacing Metadata Dates"
saxon -o:reg1b.xml -s:reg1a.xml -xsl:replaceMetadataDates.xsl

#5. Add a Fee Total (in pence or in shillings and pence) of all the copies in an entry to the metadata; find entries without fees and  mark them up as containing a fee, value 0
echo "Adding Fee Total"
saxon -o:reg1c.xml -s:reg1b.xml -xsl:addTotalFees.xsl

#6. Add Masters and Wardens to the metadata.
echo "Adding Masters and Wardens to the metadata"
saxon -o:reg1d.xml -s:reg1c.xml -xsl:addWardens.xsl

#7. convert <add> to <supplied> with the relevant @resp for the volume, (A and C are #EW, B is #EB).
echo "Converting <add> to <supplied> with relevant @resp"
saxon -o:reg1e.xml -s:reg1d.xml -xsl:addToSupplied.xsl

# Additional Regularise @role on persName
echo "Regularising @role on persName"
saxon -o:reg1f.xml -s:reg1e.xml -xsl:updatePersNameRoles.xsl


#8. Delete all non <div type="entry"> content (ie. <entryGrp>, <fw> etc.
echo "Removing all non-Entry material"
saxon -o:reg1-EntriesOnly.xml -s:reg1f.xml -xsl:removeNonEntryContent.xsl
echo "Done Register 1"



#Register 2
echo "reg2.xml"
#1. Convert <note type =‘editorial’ resp=“#Arber”> to <note resp="#Arber> …. unless you can think of a reason to do the reverse (they are inconsistent at the moment). 
#2. Insert ‘Arber:' at beginning of Arber notes (but not to <supplied resp=‘Arber'>
echo "Converting notes"
saxon -o:reg2a.xml -s:reg2.xml -xsl:replace-notes.xsl

#3. Delete date text, and display @values in the metadata, having corrected date @values from Ian’s shee
echo "Replacing Metadata Dates"
saxon -o:reg2b.xml -s:reg2a.xml -xsl:replaceMetadataDates.xsl

#5. Add a Fee Total (in pence or in shillings and pence) of all the copies in an entry to the metadata; find entries without fees and  mark them up as containing a fee, value 0
echo "Adding Fee Total"
saxon -o:reg2c.xml -s:reg2b.xml -xsl:addTotalFees.xsl

#6. Add Masters and Wardens to the metadata.
echo "Adding Masters and Wardens to the metadata"
saxon -o:reg2d.xml -s:reg2c.xml -xsl:addWardens.xsl

#7. convert <add> to <supplied> with the relevant @resp for the volume, (A and C are #EW, B is #EB).
echo "Converting <add> to <supplied> with relevant @resp"
saxon -o:reg2e.xml -s:reg2d.xml -xsl:addToSupplied.xsl

# Additional Regularise @role on persName
echo "Regularising @role on persName"
saxon -o:reg2f.xml -s:reg2e.xml -xsl:updatePersNameRoles.xsl

#8. Delete all non <div type="entry"> content (ie. <entryGrp>, <fw> etc.
echo "Removing all non-Entry material"
saxon -o:reg2-EntriesOnly.xml -s:reg2f.xml -xsl:removeNonEntryContent.xsl
echo "Done Register 2"




#Register 3
echo "reg3.xml"
#1. Convert <note type =‘editorial’ resp=“#Arber”> to <note resp="#Arber> …. unless you can think of a reason to do the reverse (they are inconsistent at the moment). 
#2. Insert ‘Arber:' at beginning of Arber notes (but not to <supplied resp=‘Arber'>
echo "Converting notes"
saxon -o:reg3a.xml -s:reg3.xml -xsl:replace-notes.xsl

#3. Delete date text, and display @values in the metadata, having corrected date @values from Ian’s sheet
echo "Replacing Metadata Dates"
saxon -o:reg3b.xml -s:reg3a.xml -xsl:replaceMetadataDates.xsl

#5. Add a Fee Total (in pence or in shillings and pence) of all the copies in an entry to the metadata; find entries without fees and  mark them up as containing a fee, value 0
echo "Adding Fee Total"
saxon -o:reg3c.xml -s:reg3b.xml -xsl:addTotalFees.xsl

#6. Add Masters and Wardens to the metadata.
echo "Adding Masters and Wardens to the metadata"
saxon -o:reg3d.xml -s:reg3c.xml -xsl:addWardens.xsl

#7. convert <add> to <supplied> with the relevant @resp for the volume, (A and C are #EW, B is #EB).
echo "Converting <add> to <supplied> with relevant @resp"
saxon -o:reg3e.xml -s:reg3d.xml -xsl:addToSupplied.xsl

# Additional Regularise @role on persName
echo "Regularising @role on persName"
saxon -o:reg3f.xml -s:reg3e.xml -xsl:updatePersNameRoles.xsl

#8. Delete all non <div type="entry"> content (ie. <entryGrp>, <fw> etc.
echo "Removing all non-Entry material"
saxon -o:reg3-EntriesOnly.xml -s:reg3f.xml -xsl:removeNonEntryContent.xsl
echo "Done Register 3"

