<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs tei jc"
  xmlns:jc="http://james.blushingbunny.net/ns.html"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  version="2.0">
  
  <!-- 
  File to output information about titles in SRO Entries, for each SRO Entry it creates output only if 
  the number of titles and the number in the metadata do *not* match
  
  This is best run on the commandline with something like:
  
  saxon -o:OutputFileName.csv -s:Arber1.xml -xsl:find-titleErrors.xsl
  
  Then import the CSV into something like libreoffice or excel
  -->
  
  <!-- We set the output method for text because we are producing CSV -->
  <xsl:output method="text"/>
  
  <!-- We are matching the top-level document node since we're ignoring most of it. -->
  <xsl:template match="/">
    <!-- We output the column headings with a linebreak by having xsl:text end on next line -->  
    <xsl:text>"SRO ID", "Number of Titles", "Number of Works"
</xsl:text>
    <!-- For each title inside an entry... -->
<xsl:for-each select="//div[@type='entry'][count(.//title) ne number(.//ab[@type='metadata']/num[@type='works']/@value)]">
  <!-- We make a variable named 'output' which has all the columns we want. It is fine to 
  have them on separate lines and such because we will normalize-space it afterwards. -->
  <xsl:variable name="output">
    "<xsl:value-of select="ancestor-or-self::div[@type='entry']/@xml:id"/>", 
    "<xsl:value-of select="count(.//title)"/>",
    "<xsl:value-of select=".//ab[@type='metadata']/num[@type='works']/@value"/>"
 </xsl:variable>
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
