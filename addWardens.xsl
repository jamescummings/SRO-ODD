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
  
  saxon -o:OutputFileName.xml -s:reg1.xml -xsl:addWardens.xsl
  
  repeat for each file name
  
  This is to do: 
  
  6. Add Masters and Wardens to the metadata.
  
  
  

  -->
    
    <!-- We set the output method for XML -->
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:variable name="wardens" select="doc('wardensAndMasters.xml')"/>
    
    <!-- copy all -->
    <xsl:template match="@*|node()|comment()" priority="-1">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="div[@type='entry']/ab[@type='metadata']">
        <xsl:variable name="id" select="parent::div[@type='entry']/@xml:id"/>
        <xsl:variable name="date" select="date"/>
        <xsl:variable name="fromDate"><xsl:choose>
            <xsl:when test="$date/@when"><xsl:value-of select="$date/@when"/></xsl:when>
            <xsl:when test="$date/@notBefore"><xsl:value-of select="$date/@notBefore"/></xsl:when>
            <xsl:otherwise><xsl:message>Error getting fromDate at <xsl:value-of select="$id"/></xsl:message></xsl:otherwise>
        </xsl:choose>
        </xsl:variable>
        <xsl:variable name="toDate"><xsl:choose>
            <xsl:when test="$date/@when"><xsl:value-of select="$date/@when"/></xsl:when>
            <xsl:when test="$date/@notAfter"><xsl:value-of select="$date/@notAfter"/></xsl:when>
            <xsl:otherwise><xsl:message>Error getting fromDate at <xsl:value-of select="$id"/></xsl:message></xsl:otherwise>
        </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="wardenEntry" select="$wardens//item[xs:date(date/@from) le xs:date($fromDate)and xs:date($toDate) le xs:date(date/@to)][1]"/>
        
        <xsl:variable name="wardenNames">
            <xsl:choose>
                <xsl:when test="$wardenEntry//ditto[@type='wardens']"><xsl:copy-of select="$wardenEntry/preceding::tei:item[tei:persName/@role='warden'][1]/tei:persName[@role='warden']"/></xsl:when>
                <xsl:when test="$wardenEntry//persName[@role='warden']"><xsl:copy-of select="$wardenEntry//tei:persName[@role='warden']"/></xsl:when>
                <xsl:otherwise>
                    
                    <xsl:copy-of select="preceding::fw[.//persName/@role='warden'][1]//persName[@role='warden']"/>
                    
                    <xsl:message>Error for warden name at <xsl:value-of select="$id"/> (<xsl:value-of select="$fromDate"/> [<xsl:value-of select="$wardenEntry/date/@from"/>]) (<xsl:value-of select="$toDate"/>) [<xsl:value-of select="$wardenEntry/date/@to"/>]                
            <!--<xsl:copy-of select="$wardenEntry"/>--></xsl:message></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="masterName">
            <xsl:choose>
                <xsl:when test="$wardenEntry//ditto[@type='master']"><xsl:copy-of select="$wardenEntry/preceding::tei:item[tei:persName/@role='master'][1]/tei:persName[@role='master']"/></xsl:when>
                <xsl:when test="$wardenEntry//persName[@role='master']"><xsl:copy-of select="$wardenEntry//tei:persName[@role='master']"/></xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="preceding::fw[.//persName/@role='master'][1]//persName[@role='master']"/>
                    <xsl:message>Error for master name at <xsl:value-of select="$id"/> (<xsl:value-of select="$fromDate"/> [<xsl:value-of select="$wardenEntry/tei:date/@from"/>]) (<xsl:value-of select="$toDate"/>) [<xsl:value-of select="$wardenEntry/date/@to"/>]                
                   <!--<xsl:copy-of select="$wardenEntry"/>--></xsl:message></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
            <xsl:copy-of select="$wardenNames"/>
            <xsl:copy-of select="$masterName"/>
        </xsl:copy>
   </xsl:template>
    
  



    
    
    
</xsl:stylesheet>