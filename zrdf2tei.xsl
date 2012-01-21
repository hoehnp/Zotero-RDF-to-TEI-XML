<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:vcard="http://nwalsh.com/rdf/vCard#" 
    xmlns:foaf="http://xmlns.com/foaf/0.1/" 
    xmlns:z="http://www.zotero.org/namespaces/export#"
    xmlns:dcterms="http://purl.org/dc/terms/" 
    xmlns:bib="http://purl.org/net/biblio#" 
    xmlns:link="http://purl.org/rss/1.0/modules/link/"
    xmlns:prism="http://prismstandard.org/namespaces/1.2/basic/" 
    exclude-result-prefixes="xs rdf tei dc vcard foaf z dcterms bib link prism"
    >
    
    <xsl:output method="xml" escape-uri-attributes="yes" indent="yes"/>
    
    <xsl:template match="/rdf:RDF">
        <listBibl>
            <head>Works Cited</head>
            <xsl:apply-templates/>
        </listBibl>
    </xsl:template>
    
    <xsl:template match="bib:Memo"/>
    <xsl:template match="z:Attachment"/>
    
    <xsl:template match="bib:Book">
        <xsl:variable name="cl-id">
            <xsl:choose>
                <xsl:when test="contains(@rdf:about, '#')"><xsl:value-of select="substring-after(@rdf:about, '#')"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="@rdf:about"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="bibl">
            <xsl:attribute name="id">cl-<xsl:value-of select="generate-id(.)"/></xsl:attribute>
            <xsl:attribute name="type">book</xsl:attribute>
            <title level="m" type="main">
                <xsl:value-of select="dc:title"/>
            </title>
            <title level="m" type="short">
                <xsl:value-of select="z:shortTitle"/>
            </title>
            <xsl:apply-templates select="bib:authors | bib:editors"/>
            <xsl:apply-templates select="dc:publisher/foaf:Organization"/>
            <date>
                <xsl:choose>
                    <xsl:when test="contains(dc:date, '-')">
                        <xsl:value-of select="substring-before(dc:date, '-')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="dc:date"/>
                    </xsl:otherwise>
                </xsl:choose>
            </date>
            <xsl:apply-templates select="bib:pages"/>
            <idno type="checklist"><xsl:value-of select="$cl-id"/></idno>
            <xsl:apply-templates select="dc:identifier"/>
            <xsl:for-each select="dcterms:isPartOf">
                <xsl:apply-templates select="bib:Series"/>
            </xsl:for-each>
            <xsl:apply-templates select="dc:subject"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="rdf:li">
        <!-- aiieeeee -->
    </xsl:template>
    
    <xsl:template match="bib:Article">
        <xsl:variable name="cl-id">
            <xsl:choose>
                <xsl:when test="contains(@rdf:about, '#')"><xsl:value-of select="substring-after(@rdf:about, '#')"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="@rdf:about"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="bibl">
            <xsl:attribute name="id">cl-<xsl:value-of select="generate-id(.)"/></xsl:attribute>
            <xsl:attribute name="type">article</xsl:attribute>
                <title level="a" type="main"><xsl:value-of select="dc:title"/></title>
                <xsl:apply-templates select="bib:authors"/>
                <title>
                    <xsl:value-of select="following-sibling::bib:Journal[1]/dc:title"/>
                </title>
                <imprint>
                    <date><xsl:value-of select="dc:date"/></date>
                    <biblScope type="vol"><xsl:value-of select="following-sibling::bib:Journal[1]/prism:volume"/></biblScope>
                    <biblScope type="issue"><xsl:value-of select="following-sibling::bib:Journal[1]/prism:number"/></biblScope>
                    <biblScope type="pp"><xsl:value-of select="bib:pages"/></biblScope>
                </imprint>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="bib:Journal"/>
    
    <xsl:template match="bib:Document"/>
    
    <xsl:template match="rdf:Description">
        <xsl:choose>
            <xsl:when test="z:itemType = 'conferencePaper'">
                <biblStruct>
                    <analytic>
                        <title>
                            <xsl:value-of select="dc:title"/>
                        </title>
                        <xsl:apply-templates select="bib:authors"/>
                        
                    </analytic>
                </biblStruct>
            </xsl:when>
            <!-- add outputs for other kinds of objects you collect -->
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="z:Collection"/>
    
    <xsl:template match="bib:authors | bib:editors">
        <xsl:for-each select="rdf:Seq/rdf:li">
            <xsl:element name="{substring-before(local-name(../..),'s')}">
                <xsl:attribute name="n"><xsl:value-of select="count(preceding-sibling::rdf:li)+1"/></xsl:attribute>
                <persName>
                    <surname>
                        <xsl:value-of select="foaf:Person/foaf:surname"/>
                    </surname>
                    <forename>
                        <xsl:value-of select="foaf:Person/foaf:givenname"/>
                    </forename>
                </persName>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
        
    <xsl:template match="foaf:Organization[parent::dc:publisher]">
        <xsl:for-each select="vcard:adr/vcard:Address/vcard:locality">
            <pubPlace>
                <xsl:value-of select="."/>
            </pubPlace>
        </xsl:for-each>
        <xsl:for-each select="foaf:name">
            <publisher>
                <xsl:value-of select="."/>
            </publisher>
        </xsl:for-each>
    </xsl:template>   
    
    <xsl:template match="bib:pages">
        <note type="pageCount"><xsl:value-of select="."/></note>
    </xsl:template>
    
    <xsl:template match="bib:Series">
        <series>
            <xsl:for-each select="dc:title">
                <title level="s"><xsl:value-of select="."/></title>
            </xsl:for-each>
        </series>
    </xsl:template>
    
    <xsl:template match="dc:subject">
        <note type="subject"><xsl:value-of select="."/></note>
    </xsl:template>
   <xsl:template match="dc:identifier[contains(., 'ISBN')]">
        <idno type="ISBN"><xsl:value-of select="normalize-space(substring-after(., 'ISBN'))"/></idno>
    </xsl:template>
    
    <xsl:template match="dc:identifier[dcterms:URI]">
        <ptr target="{dcterms:URI/rdf:value}"/>
    </xsl:template>
    
    
</xsl:stylesheet>