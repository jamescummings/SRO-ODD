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
  
  saxon -o:OutputFileName.xml -s:reg1.xml -xsl:renumber-SRO-IDs.xsl startingNumber=12345
  
  repeat for each file name
  
  This is to do: 
  
 Renumbering of SRO IDs 
  
  

  -->
    
    <!-- We set the output method for XML -->
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:param name="startingNumber" select="'0'"/>
    
    <!-- copy all -->
    <xsl:template match="@*|node()|comment()" priority="-1">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
 
 <xsl:template match="body">
     <xsl:copy>
             <xsl:for-each select=".//div[@type='entry']">
                 <xsl:variable name="num"><xsl:number count="div[@type='entry']" level="any" from="body"/></xsl:variable>
                 <xsl:variable name="ID" select="concat('SRO', string(number($num) + number($startingNumber)))"/>
                 <div type="entry" xml:id="{$ID}">
                     <xsl:apply-templates/>
                 </div>
                 <xsl:if test="position()=last()"><xsl:message>Starting Number for Next Volume: <xsl:value-of select="substring-after($ID, 'SRO')"/></xsl:message></xsl:if>
             </xsl:for-each>
             
             
             <xsl:comment>Warning: This up-converted SRO XML has removed all non-entry markup and data.</xsl:comment>
     </xsl:copy>
     
     <xsl:result-document href="old2newID-{$startingNumber}.csv" method="text">
<xsl:text>"OldID", "NewID"
</xsl:text>         
<xsl:for-each select=".//div[@type='entry']">   
<xsl:variable name="num"><xsl:number count="div[@type='entry']" level="any" from="body"/></xsl:variable>
<xsl:variable name="ID" select="concat('SRO', string(number($num) + number($startingNumber)))"/>
<xsl:variable name="oldID" select="@xml:id"/>
<xsl:text>"</xsl:text><xsl:value-of select="normalize-space($oldID)"/><xsl:text>", "</xsl:text><xsl:value-of select="$ID"/><xsl:text>"
</xsl:text>    
</xsl:for-each>
</xsl:result-document>
</xsl:template>    
</xsl:stylesheet>