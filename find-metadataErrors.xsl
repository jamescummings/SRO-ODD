<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs tei jc"
  xmlns:jc="http://james.blushingbunny.net/ns.html"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  version="2.0">
  
  <!-- 
  File to output information about references in SRO Entries, for each SRO Entry it creates output
saying whether any of: 
<idno type="RegisterRef">Register B, f.130r</idno>
<idno type="ArberRef">II. 293</idno>
<idno type="RegisterID">TSC-1-F-02-01_1576-1595_0304_f130r</idno>
haven't changed rom the preceding ab/@type='metadata'block

  This is best run on the commandline with something like:
  
  saxon -o:OutputFileName.csv -s:Arber1.xml -xsl:find-metadataErrors.xsl
  
  Then import the CSV into something like libreoffice or excel
  -->
  
  <!-- We set the output method for text because we are producing CSV -->
  <xsl:output method="text"/>
  
  <!-- We are matching the top-level document node since we're ignoring most of it. -->
  <xsl:template match="/">
    <!-- We output the column headings with a linebreak by having xsl:text end on next line -->  
    <xsl:text>"SRO ID", "Changed RegisterRef", "Changed ArberRef", "Changed RegisterID"
</xsl:text>
    <!-- For each title inside an entry... -->
<xsl:for-each select="//div[@type='entry']">
  <!-- We make a variable named 'output' which has all the columns we want. It is fine to 
  have them on separate lines and such because we will normalize-space it afterwards. -->
  
    <xsl:variable name="RegisterRef" select=".//ab[@type='metadata']/idno[@type='RegisterRef']"/>
    <xsl:variable name="ArberRef" select=".//ab[@type='metadata']/idno[@type='ArberRef']"/>
    <xsl:variable name="RegisterID" select=".//ab[@type='metadata']/idno[@type='RegisterID']"/>
    <xsl:variable name="pRegisterRef" select="preceding-sibling::div[@type='entry']//ab[@type='metadata']/idno[@type='RegisterRef']"/>
    <xsl:variable name="pArberRef" select="preceding-sibling::div[@type='entry']//ab[@type='metadata']/idno[@type='ArberRef']"/>
    <xsl:variable name="pRegisterID" select="preceding-sibling::div[@type='entry']//ab[@type='metadata']/idno[@type='RegisterID']"/>
    <!--<xsl:if test="($RegisterRef = $pRegisterRef) or ($ArberRef = $pArberRef) or ($RegisterID = $pRegisterID)">-->
      <xsl:variable name="output">  
  "<xsl:value-of select="ancestor-or-self::div[@type='entry']/@xml:id"/>",
      "<xsl:choose>
        <xsl:when test="($RegisterRef = $pRegisterRef)">same</xsl:when>
        <xsl:otherwise>diff</xsl:otherwise>
      </xsl:choose>",  
      "<xsl:choose>
        <xsl:when test="($ArberRef = $pArberRef)">same</xsl:when>
        <xsl:otherwise>diff</xsl:otherwise>
      </xsl:choose>",
      "<xsl:choose>
        <xsl:when test="($pRegisterID = $pRegisterID)">same</xsl:when>
        <xsl:otherwise>diff</xsl:otherwise>
      </xsl:choose>"
      </xsl:variable>
 <xsl:value-of select="normalize-space($output)"/><xsl:text>
</xsl:text><!--</xsl:if>-->
</xsl:for-each>    
</xsl:template>   
   
   
   
   
  <!-- CSV doesn't like spare double quotes lying around. So you escape them by putting two double quotes instead --> 
  <xsl:function name="jc:csvEscapeDoubleQuotes" as="xs:string">
    <xsl:param name="string" as="xs:string"/>
    <xsl:value-of select="replace($string, '&quot;', '&quot;&quot;')"/>
  </xsl:function>
  
   
  
</xsl:stylesheet>