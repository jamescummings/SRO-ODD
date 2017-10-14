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
  
  saxon -o:OutputFileName.xml -s:reg1.xml -xsl:addAdditionalMetadata.xsl
  
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
 
 <!-- Github issues 21, 20, 19 -->
    <xsl:template match="ab[@type='metadata']">
      <ab type="metadata">
          <idno type="Liber"><xsl:value-of select="ancestor::TEI//publicationStmt/idno[@type='Liber']"/></idno>
          <idno type="SRONumber"><xsl:value-of select="substring-after(ancestor::div[@type='entry']/@xml:id, 'SRO')"/></idno>
          <xsl:variable name="sortDate"><xsl:choose>
              <xsl:when test="date/@when"><xsl:value-of select="date/@when"/></xsl:when>
              <xsl:when test="date/@notBefore"><xsl:value-of select="date/@notBefore"/></xsl:when>
              <xsl:otherwise><xsl:message>No date in <xsl:value-of select="ancestor::div[@type='entry']/@xml:id"/></xsl:message></xsl:otherwise>
          </xsl:choose></xsl:variable>
          <date type="SortDate" when="{$sortDate}"/>
           <date type="Register"><xsl:apply-templates select="date/@*|date/node()"/></date>
          <xsl:if test="count(ancestor::div[type='entry']//persName[@role='enterer']) gt 1">
              <note type="status" subtype="shared"/>
          </xsl:if>
          <xsl:if test="ancestor::div[type='entry']//orgName">
              <note type="status" subtype="stock"/>
          </xsl:if>
          <xsl:apply-templates select="node()[not(name()='date')]"/>
      </ab>             
    </xsl:template>     
    
    <!-- also doing github issue 9 -->
    <xsl:template match="note[not(ancestor::ab[@type='metadata'])][@type='editorial'][@resp='#register']">
        <xsl:copy><xsl:apply-templates select="@*[not(name()='resp')]|node()"/></xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>