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
  
  saxon -o:OutputFileName.xml -s:reg1.xml -xsl:replace-notes.xsl
  
  repeat for each file name
  
  This is to do: 
  
  

3. Delete date text, and display @values in the metadata, having corrected date @values from Ian’s sheet at https://docs.google.com/spreadsheets/d/1TFHLZoZdzUKj4WNI9slQjphGQISflnEc8UPecg7dKZw/edit?usp=sharing

The spreadsheet is output as regDate.xml 

  -->
    
    <!-- We set the output method for XML -->
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:variable name="dates" select="doc('regDates.xml')"/>
    
    <!-- copy all -->
    <xsl:template match="@*|node()|comment()" priority="-1">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="div[@type='entry']/ab[@type='metadata']/date">
        <xsl:variable name="id" select="ancestor::div[@type='entry']/@xml:id"/>
        <xsl:variable name="row" select="$dates//row[cell[1]/normalize-space(.) = $id]"/>
        <xsl:choose>
                <xsl:when test="$row/cell[1]=''"><xsl:message>Date not matched: <xsl:value-of select="$id"/></xsl:message></xsl:when>
                <xsl:when test="string-length($row/cell[2]) gt 2">
                    <xsl:variable name="when" select="xs:date($row/cell[2]/normalize-space(.))" />
                    <date when="{$when}">
                        <xsl:value-of select="format-date($when,'[D] [MNn] [Y0001]')"/>
                    </date>
                </xsl:when>
                <xsl:when test="(string-length($row/cell[3]) gt 2) and (string-length($row/cell[4]) gt 2)">
                    <xsl:variable name="notBefore" select="xs:date($row/cell[3]/normalize-space(.))" />
                    <xsl:variable name="notAfter" select="xs:date($row/cell[4]/normalize-space(.))" />
                    <date notBefore="{$notBefore}" notAfter="{$notAfter}">
                        <xsl:value-of select="format-date($notBefore,'[D] [MNn] [Y0001]')"/> <xsl:text> - </xsl:text> <xsl:value-of select="format-date($notAfter,'[D] [MNn] [Y0001]')"/>
                    </date>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message>Date not matched, some other problem: <xsl:value-of select="$id"/></xsl:message>
                </xsl:otherwise>
            </xsl:choose>
   </xsl:template>
    
    
</xsl:stylesheet>