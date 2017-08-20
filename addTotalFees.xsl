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
  
  saxon -o:OutputFileName.xml -s:reg1.xml -xsl:addTotalFees.xsl
  
  repeat for each file name
  
  This is to do: 
  
  5. Add a Fee Total (in pence or in shillings and pence) of all the copies in an entry to the metadata; find entries without fees and  mark them up as containing a fee, value 0
  
  
  

  -->
    
    <!-- We set the output method for XML -->
    <xsl:output method="xml" indent="yes"/>
    
   
    <!-- copy all -->
    <xsl:template match="@*|node()|comment()" priority="-1">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
 
 <xsl:template match="div[@type='entry']/ab[@type='metadata']">
     <xsl:copy>
         <xsl:apply-templates select="@*"/>
         <xsl:choose>
             <xsl:when test="parent::div[@type='entry']//num[@type='totalPence']"><num type="totalEntryPence" value="{sum(parent::div[@type='entry']//num[@type='totalPence']/@value)}"/></xsl:when>
             <xsl:otherwise><num type="totalEntryPence" value="0"/></xsl:otherwise>
         </xsl:choose>
         <xsl:apply-templates/>
     </xsl:copy>
 </xsl:template>
    
    
    
    
    
    
</xsl:stylesheet>