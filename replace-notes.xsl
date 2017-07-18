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
  
  
DONE: 1. Convert <note type =‘editorial’ resp=“#Arber”> to <note resp="#Arber> 
unless you can think of a reason to do the reverse (they are inconsistent at the moment).
JC: <note resp="#arber"> is fine if the assumption is made that all arber notes are editorial  

DONE: 2. Insert ‘Arber:' at beginning of Arber notes (but not to <supplied resp=‘Arber'>
 
DONE except for square brackets 5. <note type=editorial>s inside <note resp=Arber>s notes should have  
  @rend=italics and nest within an additional pair of square brackets
  
  -->
  
  <!-- We set the output method for XML -->
  <xsl:output method="xml" indent="yes"/>
  
  
<!-- copy all -->
  <xsl:template match="@*|node()|comment()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Make sure the resp has #Arber and ignore any other attributes and add 'Arber:' in front-->
  <xsl:template match="note[@resp='#arber']">
    <note resp="#Arber">Arber: <xsl:apply-templates/></note>
  </xsl:template>
  
  <xsl:template match="note[@resp='#arber']//note[@type='editorial']" priority="10">
    <note rend="italics"><xsl:apply-templates select="@*[not(name()='rend')]|node()"/></note>
  </xsl:template>
  
  
</xsl:stylesheet>