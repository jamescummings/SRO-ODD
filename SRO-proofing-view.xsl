<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs xd tei " xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml" version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output indent="yes" encoding="UTF-8" method="xml"/>

    <xsl:template match="TEI">
        <html>
            <head>
                <title>SRO Proofing View: <xsl:value-of
                        select="/TEI/teiHeader/fileDesc/titleStmt/title[1]"/></title>
                <style type="text/css">
                    body{
                        margin-left: 5%;
                        margin-right: 5%;
                    }
                
                div.entryList{font-size:75%;}
                div.entry{margin:2%; padding:1%; border:1px black solid;}
                ul.ab-metadata{margin-left:auto; margin-right:auto; width:50%; background-color:#EFEFEF; padding:2%;}
                span.label{font-weight:bold;}
                span.divType{font-weight:bold; font-size:110%;}
                span.persName{background-color:FFDDDD;}
                span.title{font-weight:bold; font-variant:italic; font-size:110%;}
                </style>

            </head>
            <body>
                <h1>SRO Proofing View: <xsl:value-of
                        select="/TEI/teiHeader/fileDesc/titleStmt/title[1]"/></h1>
                <div class="entryList"><xsl:for-each select="//div[@type='entry'][@xml:id]">
                    <a href="{concat('#', @xml:id)}"><xsl:value-of select="@xml:id"/></a><xsl:text> </xsl:text>
                </xsl:for-each></div>
                <xsl:apply-templates select="text/body"/>
            </body>
        </html>
    </xsl:template>

    <!-- 
    
    
    <moduleRef key="namesdates" include="orgName persName surname forename placeName"/>
    moduleRef key="core"
    include="p foreign hi desc gap unclear num date list item head note pb lb respStmt resp title choice abbr expan corr sic orig reg add"/>
    
    Header not displayed
    moduleRef key="header"
    include="teiHeader fileDesc titleStmt funder principal publicationStmt distributor availability licence sourceDesc encodingDesc projectDesc revisionDesc change idno"/>
    
    
    <moduleRef key="transcr" include="fw space am ex supplied"/>
    
    <moduleRef key="linking" include="ab anchor seg"/>
    
    <moduleRef key="textstructure" include="TEI text body div"/>
    
    -->

    <xsl:template match="orgName | surname | forename | placeName">
        <span class="{name()}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>


    <xsl:template match="persName">
        <span class="{name()}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

     <xsl:template match="p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="foreign | desc | unclear">
        <span class="{name()}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="hi">
        <span class="{concat(name(), ' ', @rend)}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="choice">
        <span class="{name()}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="abbr | orig | sic">
        <span class="{name()}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="expan | reg | corr">
        <span class="{name()}">
            <xsl:text> [</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>] </xsl:text>
        </span>
    </xsl:template>
    <xsl:template match="gap">
        <span class="{name()}">
            <xsl:text> ... </xsl:text>
        </span>
    </xsl:template>

    <xsl:template
        match="num[@type = 'halfpence' or @type = 'pence' or @type = 'poundsAsPence' or @type = 'shillingsAsPence']">
        <span class="{concat(name(), ' ', @type)}" title="{concat(@type, ': ',@value)}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="num">
        <span class="{concat(name(), ' ', @type)}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="list">
        <ul>
            <xsl:apply-templates select="@* | node()"/>
        </ul>
    </xsl:template>
    <xsl:template match="item">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

    <xsl:template match="pb">
        <span class="{name()}">[<xsl:value-of select="@n"/>]</span>
    </xsl:template>
    <xsl:template match="lb">
        <br/>
    </xsl:template>
    <xsl:template match="add">
        <span class="{name()}"><xsl:apply-templates/></span>
    </xsl:template>
    
    <xsl:template match="title">
        <span class="{name()}"><xsl:apply-templates/></span>
    </xsl:template>
    
    <xsl:template match="head">
        <h4><xsl:apply-templates select="@*|node()"/></h4>
    </xsl:template>
    
    
    
    
    <xsl:template match="date">
        <span class="{name()}"><xsl:if test="@*"><xsl:attribute name="title"><xsl:for-each select="@*"><xsl:value-of select="concat(name(),': ', ., '; ')"/></xsl:for-each></xsl:attribute></xsl:if><xsl:apply-templates/></span>
    </xsl:template>
    
    
    <xsl:template match="idno">
        <span class="{name()}"><xsl:if test="@*"><xsl:attribute name="title"><xsl:for-each select="@*"><xsl:value-of select="concat(name(),': ', ., '; ')"/></xsl:for-each></xsl:attribute></xsl:if><xsl:apply-templates/><xsl:text> </xsl:text></span>
    </xsl:template>
    
    
    <xsl:template match="note">
        <span class="{name()}"><xsl:if test="@*"><xsl:attribute name="title"><xsl:for-each select="@*"><xsl:value-of select="concat(name(),': ', ., '; ')"/></xsl:for-each></xsl:attribute></xsl:if><xsl:apply-templates/><xsl:text> </xsl:text></span>
    </xsl:template>
    
    
    <!-- 
     respStmt resp 
   -->


<xsl:template match="fw">
    <p class="fw"><xsl:apply-templates/></p>
</xsl:template>
    
    <xsl:template match="am">
        <span class="{name()}"><xsl:apply-templates/></span>
    </xsl:template>
    
    
    <xsl:template match="ex">
        <span class="{name()}"><xsl:apply-templates/></span>
    </xsl:template>
    
    
    <xsl:template match="supplied">
        <span class="{name()}"><xsl:text>(</xsl:text><xsl:apply-templates/><xsl:text>)</xsl:text></span>
    </xsl:template>
    
    
    <xsl:template match="space">
        <span class="{name()}"><xsl:text>[</xsl:text><xsl:apply-templates/><xsl:text>]</xsl:text></span>
    </xsl:template>
    
    
    <xsl:template match="anchor[@type='noteStart']"><span class="noteStart">[</span></xsl:template>
    <xsl:template match="anchor[@type='noteEnd']"><span class="noteEnd">]</span></xsl:template>
    
    <xsl:template match="seg">
     <span class="{concat(@type, ' ', @rend)}"><xsl:apply-templates/></span>   
    </xsl:template>
    
    <xsl:template match="div">
       <div class="{concat(@type, ' ', @rend)}">
           <xsl:if test="@xml:id"><xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute></xsl:if>
           <xsl:if test="@type"><span class="divType">[<xsl:value-of select="@type"/><xsl:if test="@xml:id"><xsl:value-of select="concat(': ', @xml:id)"/></xsl:if>]</span></xsl:if>
           <xsl:apply-templates/>
       </div> 
    </xsl:template>
    
    <xsl:template match="text|body"><xsl:apply-templates/></xsl:template>
    


    <xsl:template match="ab[@type='metadata']">
        <p class="ab-metadata">
            <ul class="ab-metadata"><xsl:apply-templates/></ul>
        </p>    
    </xsl:template>
    


    <xsl:template match="ab[@type='metadata']/num[@type][@value]">
        <li class="{name()}"><xsl:if test="@*"><xsl:attribute name="title"><xsl:for-each select="@*"><xsl:value-of select="concat(name(),': ', ., '; ')"/></xsl:for-each></xsl:attribute></xsl:if><span class="label"><xsl:value-of select="@type"/>: <xsl:value-of select="@value"/> </span><xsl:apply-templates/></li>
    </xsl:template>
    
    <xsl:template match="ab[@type='metadata']/note">
        <li class="{name()}"><xsl:if test="@*"><xsl:attribute name="title"><xsl:for-each select="@*"><xsl:value-of select="concat(name(),': ', ., '; ')"/></xsl:for-each></xsl:attribute></xsl:if><span class="label"><xsl:value-of select="@type"/>: <xsl:value-of select="@subtype"/> </span><xsl:apply-templates/><xsl:text> </xsl:text></li>
    </xsl:template>
    
    
    <xsl:template match="ab[@type='metadata']/idno[@type]">
        <li class="{name()}"><xsl:if test="@*"><xsl:attribute name="title"><xsl:for-each select="@*"><xsl:value-of select="concat(name(),': ', ., '; ')"/></xsl:for-each></xsl:attribute></xsl:if><span class="label"><xsl:value-of select="@type"/>: </span><xsl:apply-templates/></li>
    </xsl:template>
    
    
    <xsl:template match="ab[@type='metadata']/date">
        <li class="{name()}"><xsl:if test="@*"><xsl:attribute name="title"><xsl:for-each select="@*"><xsl:value-of select="concat(name(),': ', ., '; ')"/></xsl:for-each></xsl:attribute></xsl:if><span class="label">Date: </span> <xsl:apply-templates/></li>
    </xsl:template>
    
    
    
    

<!-- @rend -->
    <xsl:template match="@rend">
        <xsl:attribute name="class">
            <xsl:value-of select="."/>
        </xsl:attribute>

    </xsl:template>


</xsl:stylesheet>
