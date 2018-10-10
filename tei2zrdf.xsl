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
    
    <xsl:template match="/">
	<rdf:RDF>
        	<xsl:apply-templates/>
    	</rdf:RDF>

	<xsl:template match="titleStmt">
		<xsl:text>
			Versuche es
		</xsl:text>
	</xsl:template>
    </xsl:template>
    
</xsl:stylesheet>
