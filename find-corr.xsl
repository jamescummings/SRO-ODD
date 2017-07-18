<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs tei jc"
  xmlns:jc="http://james.blushingbunny.net/ns.html"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  version="2.0">
  
  <!-- 
  File to output information about choice/corr/sic in SRO Entries, for each it outputs the SRO ID, and the 
  string content of the corr/sic
  
  This is best run on the commandline with something like:
  
  saxon -o:OutputFileName.csv -s:reg1.xml -xsl:find-corr.xsl
  
  repeat for each file name, then merge the CSVs and import
  into something like libreoffice or excel
  -->
  
  <!-- We set the output method for text because we are producing CSV -->
  <xsl:output method="text"/>
  
  <!-- We are matching the top-level document node since we're ignoring most of it. -->
  <xsl:template match="/">
    <!-- We output the column headings with a linebreak by having xsl:text end on next line -->  
    <xsl:text>"SRO ID", "Choice?", "Sic Content", "Corr Content"
</xsl:text>
    <!-- For each title inside an entry... -->
    <xsl:for-each select="//div[@type='entry']//choice[corr or sic] | //div[@type='entry']//corr[not(ancestor::choice)] | //div[@type='entry']//sic[not(ancestor::choice)]">
  <!-- Find out what we are -->
      <xsl:variable name="name" select="name()"/>
  <!-- We make a variable named 'output' which has all the columns we want. It is fine to 
  have them on separate lines and such because we will normalize-space it afterwards. -->
  <xsl:variable name="output">
    <!-- get the SRO ID -->
    "<xsl:value-of select="ancestor::div[@type='entry']/@xml:id"/>",
    <xsl:choose>
  <!-- When we are a corr, we don't have a sic -->
      <xsl:when test="$name='corr'">
        "No", "", "<xsl:value-of select="jc:csvEscapeDoubleQuotes(normalize-space(.))"/>"
      </xsl:when>
      <!-- When we are sic we don't have a corr -->
      <xsl:when test="$name='sic'">
        "No", "<xsl:value-of select="jc:csvEscapeDoubleQuotes(normalize-space(.))"/>", ""
      </xsl:when>
      <!-- otherwise we're a choice -->
      <xsl:otherwise>
        "Yes", "<xsl:value-of select="jc:csvEscapeDoubleQuotes(normalize-space(sic))"/>", "<xsl:value-of select="jc:csvEscapeDoubleQuotes(normalize-space(corr))"/>"
      </xsl:otherwise>
    </xsl:choose>
   </xsl:variable>
      <!-- Output a normalize-space'd version of the variable -->
<xsl:value-of select="normalize-space($output)"/><xsl:text>
</xsl:text>
</xsl:for-each>    
</xsl:template>   
   
   
   
   
  <!-- CSV doesn't like spare double quotes lying around. So you escape them by putting two double quotes instead --> 
  <xsl:function name="jc:csvEscapeDoubleQuotes" as="xs:string">
    <xsl:param name="string" as="xs:string"/>
    <xsl:value-of select="replace($string, '&quot;', '&quot;&quot;')"/>
  </xsl:function>
  
   
  
</xsl:stylesheet>