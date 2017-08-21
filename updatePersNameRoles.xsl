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
  
  - Update @roles on <persName>s

  -->
    
    <!-- We set the output method for XML -->
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:variable name="persNameTable" select="doc('SRO-persNames.xml')"/>
   
   
    <!-- copy all -->
    <xsl:template match="@*|node()|comment()" priority="-1">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>



    <!-- 

  <row>
               <cell n="1">arber3</cell>
               <cell n="2">SRO5431+3</cell>
               <cell n="3"/>
               <cell n="4"/>
               <cell n="5"/>
               <cell n="6"/>
               <cell n="7"/>
               <cell n="8">Kinge of Spayne</cell>
               <cell n="9"/>
               <cell n="10"/>
               <cell n="11">stationer</cell>
               <cell n="12">non-stationer</cell>
               <cell n="13">&#xD;</cell>
            </row>
-->



<xsl:template match="div[@type='entry']//persName[not(ancestor::ab)]">
    <xsl:variable name="NameID">
        <xsl:variable name="num">
            <xsl:number count="persName" from="div[@type = 'entry']" level="any"/>
        </xsl:variable>
        <xsl:value-of select="concat(ancestor::div[@type = 'entry']/@xml:id, '+', $num)"/>
    </xsl:variable>
    <xsl:variable name="spreadsheetEntry" select="$persNameTable//row[cell[2]=$NameID][1]"/>
    <xsl:choose>
        <xsl:when test="$spreadsheetEntry/cell[12]/text()">
            <persName role="{$spreadsheetEntry/cell[12]}"><xsl:apply-templates select="@*[not(name()='role')]|node()"/></persName>  
        </xsl:when>
        <xsl:otherwise>
            <xsl:copy><xsl:apply-templates select="@*|node()"/></xsl:copy>
        </xsl:otherwise>
    </xsl:choose>
    
    
</xsl:template>
    
</xsl:stylesheet>

