<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs tei jc"
    xmlns:jc="http://james.blushingbunny.net/ns.html" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">

    <!-- 
    This is best run on the commandline with something like:
  
  saxon -o:OutputFileName.xml -s:reg1.xml -xsl:initial-add-persName-sortKey.xsl
  
  repeat for each file name
  
  This is to do: 
  
  https://github.com/jamescummings/SRO-ODD/issues/18

  -->

    <!-- We set the output method for XML -->
    <xsl:output method="xml" indent="yes"/>

    <!-- copy all -->
    <xsl:template match="@* | node() | comment()" priority="-1" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>




    <xsl:template match="div[@type = 'entry']//persName">
        <xsl:copy>
            <xsl:attribute name="n">
                <xsl:value-of select="jc:nameSortKey(.)"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>

    </xsl:template>

    <xsl:function name="jc:nameSortKey">
        <xsl:param name="in-name"/>
        <xsl:variable name="name"><xsl:apply-templates mode="name" select="$in-name"/></xsl:variable>
        <xsl:variable name="output">
            <xsl:value-of select="$name/persName/surname"/>
            <xsl:value-of select="$name/persName/forename"/>
            <xsl:value-of
                select="$name/persName/*[name() != 'surname'][name() != 'forename']"/>
            <xsl:value-of select="$name/persName/text()"/>
        </xsl:variable>
        <xsl:value-of
            select="translate(lower-case(normalize-space($output)), '!£$%^*)(-_=+}{][:;@#~,./?|\` ', '')"
        />
    </xsl:function>
    
    <xsl:template match="hi|supplied|corr" mode="name"><xsl:apply-templates/></xsl:template>
    <xsl:template match="add|note|del" mode="name"/>
        
</xsl:stylesheet>
