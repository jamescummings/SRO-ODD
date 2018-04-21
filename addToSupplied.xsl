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
  
  saxon -o:OutputFileName.xml -s:reg1.xml -xsl:addToSupplied.xsl
  
  repeat for each file name
  
  This is to do: 
  
 7. convert <add> to <supplied> with the relevant @resp for the volume, (A and C are #EW, B is #EB). 
  
  

  -->
    
    <!-- We set the output method for XML -->
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="ab"/>
   
    <!-- copy all -->
    <xsl:template match="@*|node()|comment()" priority="-1">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:variable name="resp"><xsl:choose>
        <xsl:when test="//teiHeader//idno[@type='Register']='A'">#EW</xsl:when>
        <xsl:when test="//teiHeader//idno[@type='Register']='B'">#EB</xsl:when>
        <xsl:when test="//teiHeader//idno[@type='Register']='C'">#EW</xsl:when>
        <xsl:when test="//teiHeader//idno[@type='Register']='D'">#BH</xsl:when>
        <xsl:otherwise><xsl:message>ERROR: IDNO not found</xsl:message></xsl:otherwise>
    </xsl:choose></xsl:variable>
    
 
 
 <xsl:template match="add"><supplied resp="{$resp}"><xsl:apply-templates select="@*|node()"/></supplied></xsl:template>
    
    
    
</xsl:stylesheet>
