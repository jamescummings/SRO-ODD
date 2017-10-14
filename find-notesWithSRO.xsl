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
  
  saxon -it:main -o:OutputFileName.csv -xsl:find-notesWithSRO.xsl
  

  -->
    
    <!-- We set the output method for text -->
    <xsl:output method="text" indent="yes"/>
  
  <xsl:variable name="path" select="'./?select=reg_*-renumbered.xml;recurse=no;on-error=warning'"/>
  <xsl:variable name="docs" select="collection($path)"/>
  
  
    <xsl:template name="main">
<xsl:text>"SROID", "Text of note"
</xsl:text>         
<xsl:for-each select="$docs//note[contains(normalize-space(.), 'SRO')]">
<xsl:variable name="ID" select="ancestor::div[@type='entry']/@xml:id"/>
<xsl:text>"</xsl:text><xsl:value-of select="normalize-space($ID)"/><xsl:text>", "</xsl:text><xsl:value-of select="normalize-space(.)"/><xsl:text>"
</xsl:text>    
</xsl:for-each>
</xsl:template>    
</xsl:stylesheet>