<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.tei-c.org/ns/1.0"
      xpath-default-namespace="http://www.tei-c.org/ns/1.0"
      xmlns:jc="http://james.blushingbunny.net/ns.html"
    version="2.0" xml:space="default">
  <xsl:output method="xml" indent="yes" />
  <xsl:strip-space elements="*"/>
  
    <xsl:param name="num"/>
    
    <xsl:template match="/">
      <list>
        <xsl:variable name="items">
        <xsl:for-each select="//fw[.//date][.//persName[@role='warden']]">
          <xsl:variable name="wardens">
            <xsl:for-each select=".//persName[@role='warden']">
              <xsl:sort/>
              <xsl:copy>
                <xsl:apply-templates select="node() | @*"/>
              </xsl:copy>
            </xsl:for-each>
          </xsl:variable>
          <xsl:variable name="master">
            <xsl:for-each select=".//persName[@role='master']">
              <xsl:sort/>
              <xsl:copy>
                <xsl:apply-templates select="node() | @*"/>
              </xsl:copy>
            </xsl:for-each>
          </xsl:variable>
          <xsl:variable name="date">
            <xsl:for-each select=".//date[@from | @to |@when][1]">
            <xsl:apply-templates select="."/>
            </xsl:for-each>
          </xsl:variable>
          <item>
          <xsl:copy-of select="$date"/>
          <xsl:copy-of select="$wardens"/>
          <xsl:copy-of select="$master"/>
          </item>
        </xsl:for-each>
        </xsl:variable>
        <xsl:for-each select="$items/item[not(deep-equal(., preceding-sibling::*[1]))]">
            <xsl:if test="not(deep-equal(., preceding-sibling::item[1]))"><item xml:id="{concat('arber', $num, '-', position())}">
              <xsl:copy-of select="date"/>
              <xsl:choose>
                <xsl:when test="deep-equal(persName[@role='warden'], preceding-sibling::*[1]/persName[@role='warden'])"><ditto type="wardens"/></xsl:when>
                <xsl:otherwise><xsl:copy-of select="persName[@role='warden']"/></xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="deep-equal(persName[@role='master'], preceding-sibling::*[1]/persName[@role='master'])"><ditto type="master"/></xsl:when>
                <xsl:otherwise><xsl:copy-of select="persName[@role='master']"/></xsl:otherwise>
              </xsl:choose>
              </item></xsl:if>
        </xsl:for-each>
      </list>
    </xsl:template>
  
  <xsl:template match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="date/text() | persName/text() | forename/text() | surname/text()"><xsl:value-of select="normalize-space(.)"/></xsl:template>
  
  <xsl:template match="surname">
    <xsl:copy><xsl:value-of select="jc:titleCase(normalize-space(.))"/></xsl:copy>
  </xsl:template>
  
  <xsl:template match="date"><xsl:copy><xsl:apply-templates select="@*"/>
  <xsl:choose>
    <xsl:when test="ends-with(., '.')"><xsl:value-of select="substring(normalize-space(.), 0, string-length(normalize-space(.)))"/></xsl:when>
    <xsl:otherwise><xsl:value-of select="normalize-space(.)"/></xsl:otherwise>
  </xsl:choose>
  </xsl:copy></xsl:template>
  
  
  <xsl:function name="jc:titleCase">
    <xsl:param name="text" />
    <xsl:for-each select="tokenize($text,' ')">
      <xsl:value-of select="upper-case(substring(.,1,1))" />
      <xsl:value-of select="lower-case(substring(.,2))" />
      <xsl:if test="position() ne last()">
        <xsl:text> </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:function>
  
</xsl:stylesheet>