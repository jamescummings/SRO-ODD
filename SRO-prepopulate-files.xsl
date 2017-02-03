<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs xd tei "
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output indent="yes" encoding="UTF-8" method="xml"/>
    <xsl:param name="start">0</xsl:param>
    
    
    <xsl:template match="@*|node()|comment()|processing-instruction()" priority="-1">
        <xsl:copy><xsl:apply-templates select="@*|node()|comment()|processing-instruction()"/></xsl:copy>
    </xsl:template>
   
    <xsl:template match="div[@type='year']">
        <div type="folio"><xsl:apply-templates select="@*[not(name()='type')]|node()"/></div>
    </xsl:template>
    
    <xsl:template match="title/@rend|persName/@rend|surname/@rend"/>
    
    <xsl:template match="div[@type='entry']/list">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="div[@type='entry']/list/item[not(ancestor::item)][not(ancestor::p)]">
        <p><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="div[@type='entry']/list/item/p">
        <note><xsl:apply-templates/></note>
    </xsl:template>
    
    
    
    
    
    <xsl:template match="div[@type='entry']">
        <xsl:variable name="startNum"><xsl:number value="$start"/></xsl:variable>
        <xsl:variable name="num"><xsl:number count="div[@type='entry']" level="any" /></xsl:variable>
        <xsl:variable name="ID"><xsl:value-of select="concat('SRO', $num+$startNum)"/></xsl:variable>  
        <div type="entry" xml:id="{$ID}">
            <xsl:apply-templates/>
            <!-- add in metadata block -->
            <ab type="metadata">
                
                
                <!-- date -->
                <xsl:variable name="date">
                    
                    
                    
                    <xsl:variable name="prevDate">
                        <xsl:choose>
                            <xsl:when test="ancestor::div[@type='entryGrp']/head/date"><xsl:copy-of select="ancestor::div[@type='entryGrp'][1]/head[1]/date[1]"/></xsl:when>
                            <xsl:when test="ancestor::div[@type='entries']/head/date"><xsl:copy-of select="ancestor::div[@type='entryGrp'][1]/head[1]/date[1]"/></xsl:when>
                            <xsl:when test="preceding::fw[1]/date[1]"><xsl:copy-of select="preceding::fw[1]/date[1]"/></xsl:when>
                            <xsl:otherwise><date/></xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    
                    
                    <xsl:choose>
                        <xsl:when test="$prevDate/date[@when]"><date when="{$prevDate/date/@when}"><xsl:value-of select="normalize-space($prevDate)"/></date></xsl:when>
                        <xsl:when test="$prevDate/date[@from][@to]">
                            <date notBefore="{$prevDate/date/@from}" notAfter="{$prevDate/date/@to}"><xsl:apply-templates select="$prevDate/date/@type"/><xsl:value-of select="normalize-space($prevDate)"/></date>
                         </xsl:when>
                        <xsl:otherwise>
                            <date><xsl:apply-templates select="$prevDate/date/@*"/><xsl:value-of select="normalize-space($prevDate)"/></date></xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:copy-of select="$date"/>
            
            
                <!-- RegisterRef -->
                <idno type="RegisterRef">Register <xsl:value-of select="ancestor::TEI/teiHeader/fileDesc/publicationStmt/idno[@type='Register']"/>, f.<xsl:value-of select="preceding::pb[not(starts-with(@n, 'I'))][1]/@n"/></idno>
                
                
                <!-- ArberRef -->
                <idno type="ArberRef">
                    <xsl:value-of select="following::pb[starts-with(@n, 'I')][1]/@n"/>
                    </idno>
                
                <!-- RegisterID -->
                <idno type="RegisterID">?</idno>
                <!-- Number of works -->
                <num type="works" value="0"/>
                <!-- status -->
                <note type="status" subtype="unknown"/>
            </ab>
        </div>
    </xsl:template>
    
    
</xsl:stylesheet>