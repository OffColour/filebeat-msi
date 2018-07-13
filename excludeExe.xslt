<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:wix="http://schemas.microsoft.com/wix/2006/wi"
                xmlns="http://schemas.microsoft.com/wix/2006/wi"
                exclude-result-prefixes="xsl wix">

  <xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

  <xsl:strip-space elements="*"/>

<xsl:template match="wix:Wix"> 
        <xsl:copy> 
            <xsl:processing-instruction name="include">filebeat.wxi</xsl:processing-instruction> 
            <xsl:apply-templates/> 
        </xsl:copy> 
    </xsl:template> 

<!-- ### Adding the Win64-attribute to all Components -->
  <xsl:template match="wix:Component">

    <xsl:copy>
      <xsl:apply-templates select="@*" />
        <!-- Adding the Win64-attribute as we have a x64 application -->
        <xsl:attribute name="Win64">yes</xsl:attribute>

        <!-- Now take the rest of the inner tag -->
        <xsl:apply-templates select="node()" />
    </xsl:copy>

  </xsl:template>

  <xsl:key name="ExeToRemove"
           match="wix:Component[contains(wix:File/@Source, '.exe')]"
           use="@Id" />

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Remove the exe files -->
  <xsl:template match="*[self::wix:Component or self::wix:ComponentRef]
                        [key('ExeToRemove', @Id)]" />
</xsl:stylesheet>