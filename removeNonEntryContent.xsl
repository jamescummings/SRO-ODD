<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs tei jc"
    xmlns:jc="http://james.blushingbunny.net/ns.html"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">
    
    <!-- 
    This is best run on the commandline with something like:
  
  saxon -o:OutputFileName.xml -s:reg1.xml -xsl:removeNonEntryContent.xsl
  
  repeat for each file name
  
  This is to do: 
  
 8. Delete all non <div type="entry"> content (ie. <entryGrp>, <fw> etc. 
  
  

  -->
    
    <!-- We set the output method for XML -->
    <xsl:output method="xml" indent="yes"/>
    
    
    <!-- copy all -->
    <xsl:template match="@*|node()|comment()" priority="-1">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
 
 <xsl:template match="text">
     <xsl:copy>
         <body>
             <xsl:copy-of select=".//div[@type='entry']"/>
             
             
             <xsl:comment>Warning: This up-converted SRO XML has removed all non-entry markup and data.</xsl:comment>
         </body>
     </xsl:copy>
     
 </xsl:template>
    
    
</xsl:stylesheet>