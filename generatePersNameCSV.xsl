<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0" xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:jc="http://james.blushingbunny.net/ns.html" exclude-result-prefixes="xs xd tei jc"
  version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
  <xsl:output method="text"/>
  <xd:doc>
    <xd:desc>
      <xd:p>Create persName Tables</xd:p>
      <xd:p>Version Date: 2018-03-14</xd:p>
    </xd:desc>
  </xd:doc>



  <!-- Set up the collection of files to be converted -->
  <!-- files and recurse parameters defaulting to '*.xml' and 'no' respectively -->
  <xsl:param name="files" select="'*.xml'"/>
  <xsl:param name="recurse" select="'yes'"/>
  <!-- path hard-coded to location on my desktop -->
  <xsl:variable name="path">
    <xsl:value-of select="concat('./?select=', $files, ';on-error=warning;recurse=', $recurse)"/>
  </xsl:variable>

  <!-- the main collection of all the documents we are dealing with -->
  <xsl:variable name="doc" select="collection($path)"/>



  <xsl:template name="main">
    <xsl:value-of
      select="
        jc:CSVify(
        ('File',
        'SROID+nameNum', 'ID Number for Person e.g. ADA001',
        'Standardised Name Title', 'Standardised Forename(s)',
        'Standardised Surname(s)', 'Standardised Roles', 'Original Full Name',
        'Original Forename(s)', 'Original Surname(s)', 'Original Roles', 'Corrected Roles', 'Original Sort Key', 'Corrected Sort Key','Notes'
        ))"/>
    <xsl:text>
</xsl:text>
    <xsl:for-each select="$doc//div[@type = 'entry'][@xml:id]//persName" >
      <xsl:sort select="@n" order="ascending"/>
      <xsl:sort select="normalize-space(lower-case(surname[1]))" order="ascending"/>
      <xsl:sort select="normalize-space(lower-case(forename[1]))" order="ascending"/>
      <xsl:sort select="normalize-space(lower-case(.))" order="ascending"/>
      <xsl:variable name="file" select="substring-before(tokenize(base-uri(), '/')[last()], '.')"/>
      <xsl:variable name="NameID">
        <xsl:variable name="num">
          <xsl:number count="persName" from="div[@type = 'entry']" level="any"/>
        </xsl:variable>
        <xsl:value-of select="concat(ancestor::div[@type = 'entry']/@xml:id, '+', $num)"/>
      </xsl:variable>
      <xsl:variable name="persNameID"> </xsl:variable>
      <xsl:variable name="StandardisedNameTitle"> </xsl:variable>
      <xsl:variable name="StandardisedForenames"> </xsl:variable>
      <xsl:variable name="StandardisedSurnames"> </xsl:variable>
      <xsl:variable name="StandardisedRoles"> </xsl:variable>
      <xsl:variable name="OriginalFullName">
      <xsl:apply-templates/>  
      </xsl:variable>
      <xsl:variable name="OriginalForenames">
        <xsl:value-of select="forename"/>
      </xsl:variable>
      <xsl:variable name="OriginalSurnames">
        <xsl:value-of select="surname"/>
      </xsl:variable>
      <xsl:variable name="OriginalRoles">
        <xsl:value-of select="@role"/>
      </xsl:variable>
      <xsl:variable name="CorrectedRoles"> </xsl:variable>
      <xsl:variable name="OriginalSortKey">
        <xsl:value-of select="@n"/>
      </xsl:variable>
      <xsl:variable name="CorrectedSortKey"> </xsl:variable>
      
      <xsl:variable name="Notes"> </xsl:variable>

        <xsl:value-of
          select="
            jc:CSVify(
            ($file,$NameID,
            $persNameID,
            $StandardisedNameTitle,
            $StandardisedForenames,
            $StandardisedSurnames,
            $StandardisedRoles,
            $OriginalFullName,
            $OriginalForenames,
            $OriginalSurnames,
            $OriginalRoles,
            $CorrectedRoles,
            $OriginalSortKey,
            $CorrectedSortKey,
            $Notes
            )
            )"/>
        <xsl:text>
</xsl:text>
      </xsl:for-each>
  </xsl:template>

<xsl:template match="persName/*">
<xsl:apply-templates/><xsl:text> </xsl:text>  
</xsl:template>
  

  <!-- Turn a sequence of items into a set of double-quoted comma-separated values. -->
  <xsl:function name="jc:CSVify">
    <xsl:param name="input" as="item()*"/>
    <xsl:variable name="output">
      <xsl:for-each select="$input">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="jc:csvEscapeDoubleQuotes(.)"/>
        <xsl:text>"</xsl:text>
        <xsl:if test="not(position() = last())">,</xsl:if>
        <xsl:text> </xsl:text>
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="normalize-space($output)"/>
  </xsl:function>

  <!-- CSV doesn't like spare double quotes lying around. So you escape them by putting two double quotes instead -->
  <xsl:function name="jc:csvEscapeDoubleQuotes" as="xs:string">
    <xsl:param name="string"/>
    <xsl:value-of select="replace($string, '&quot;', '&quot;&quot;')"/>
  </xsl:function>

</xsl:stylesheet>
