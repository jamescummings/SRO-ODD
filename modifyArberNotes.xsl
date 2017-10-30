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
  
  saxon -o:OutputFileName.xml -s:reg1.xml -xsl:modifyArberNotes.xsl
  
  repeat for each file name
  
  This is to do: 
  https://github.com/jamescummings/SRO-ODD/issues/4 
  https://github.com/jamescummings/SRO-ODD/issues/5
  https://github.com/jamescummings/SRO-ODD/issues/6
  https://github.com/jamescummings/SRO-ODD/issues/7
  https://github.com/jamescummings/SRO-ODD/issues/8
  https://github.com/jamescummings/SRO-ODD/issues/10
  https://github.com/jamescummings/SRO-ODD/issues/11
  https://github.com/jamescummings/SRO-ODD/issues/15
    
  -->
    
    <!-- We set the output method for XML -->
    <xsl:output method="xml" indent="yes"/>
    
    <!-- copy all -->
    <xsl:template match="@*|node()|comment()" priority="-1">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
 
 <!-- Github issues 4 -->
    <xsl:template match="note[@resp='#arber'][starts-with(lower-case(normalize-space(.)), 'arber: no sum stated')][not(*)]">
  <xsl:copy><xsl:apply-templates select="@*"/>
  <xsl:text>No sum stated</xsl:text>
  <xsl:value-of select="substring-after(lower-case(.),'stated')"/>    
  </xsl:copy>
    </xsl:template>     
    
    <!-- also doing https://github.com/jamescummings/SRO-ODD/issues/5 -->
    <xsl:template match="persName//hi[(@rend='smallcaps') or (@rend='bold')]"><xsl:apply-templates/></xsl:template>
    
    <!-- also doing https://github.com/jamescummings/SRO-ODD/issues/6 -->
    <xsl:template match="note[@resp='#arber']//note[@type='editorial']">
        <xsl:copy><xsl:apply-templates select="@*"/>[<hi rend="italics"><xsl:apply-templates/></hi>]</xsl:copy><xsl:text> </xsl:text>
    </xsl:template>
  
    <!-- https://github.com/jamescummings/SRO-ODD/issues/7 -->
    <xsl:template match="supplied"><xsl:copy><xsl:apply-templates select="@*"/>[<xsl:apply-templates/>]</xsl:copy></xsl:template>
    <xsl:template match="supplied//text()"><xsl:value-of select="normalize-space(.)"/></xsl:template>
        
        <!--https://github.com/jamescummings/SRO-ODD/issues/8 -->
    <xsl:template match="choice[corr][sic]"><xsl:apply-templates select="corr"/></xsl:template>
    
    
    <!--
        https://github.com/jamescummings/SRO-ODD/issues/10 CHECK B 1490
    https://github.com/jamescummings/SRO-ODD/issues/11 CHECK Alse B 1490
    
    -->
        <xsl:template match="ab[@type='metadata']"><xsl:copy><xsl:apply-templates select="@*"/>
        <xsl:apply-templates/>
        <xsl:if test="not(note[@type='status'][@subtype='annotated']) and ancestor::div[@type='entry']//note[@resp='#register']"><note type="status" subtype="annotated"/></xsl:if>
         <xsl:if test="not(note[@type='status'][@subtype='incomplete']) and 
             (ancestor::div[@type='entry']//seg[@type='fee'] or
             ancestor::div[@type='entry']//title or
             ancestor::div[@type='entry']//persName[contains(@role, 'enterer')])"><note type="status" subtype="incomplete"/>
         </xsl:if>
        </xsl:copy>
        </xsl:template>
    
    <!-- https://github.com/jamescummings/SRO-ODD/issues/15 CHECK A3-->
    <xsl:template match="persName/@rend"/>
        
   
    
    
</xsl:stylesheet>