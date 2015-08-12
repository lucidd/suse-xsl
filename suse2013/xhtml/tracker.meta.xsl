<?xml version="1.0" encoding="UTF-8"?>
<!-- 
   Purpose:
     Transform DocManager elements into (X)HTML <meta/> tags to pass 
     information to create a "Report Bug" link

   Parameters:
     None

   Input:
     DocBook 5

   Output:
     HTML <meta/> tags

   See Also:
      * https://github.com/openSUSE/suse-xsl/issues/36
      * https://github.com/openSUSE/docmanager/issues/56

   Authors:    Thomas Schraitle
   Copyright:  2015, Thomas Schraitle

-->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dm="urn:x-suse:ns:docmanager"
    xmlns:exsl="http://exslt.org/common"
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="exsl date dm">
  
  
  <xsl:template name="create.tracker.meta">
    <xsl:param name="node" select="."/>
    <xsl:variable name="all.dm.nodes" select="$node/ancestor-or-self::*/*/dm:docmanager"/>
    <xsl:variable name="all.pi.nodes" select="(/processing-instruction('suse-bugtracker') |
                                               $node/ancestor-or-self::processing-instruction('suse-bugtracker'))[last()]"/>
    <xsl:variable name="bugtracker" select="$all.dm.nodes/dm:bugtracker"/>
    
    <xsl:variable name="tracker.url">
      <xsl:choose>
        <xsl:when test="($bugtracker/dm:url[normalize-space(.) != ''])[last()]">
          <xsl:value-of select="($bugtracker/dm:url[normalize-space(.) != ''])[last()]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="pi-attribute">
            <xsl:with-param name="pis" select="$all.pi.nodes"/>
            <xsl:with-param name="attribute">url</xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="tracker.type">
      <xsl:choose>
        <xsl:when test="contains($tracker.url, 'bugzilla.suse')">bsc</xsl:when>
        <xsl:when test="contains($tracker.url, 'github')">gh</xsl:when>
        <xsl:otherwise>unknown</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="tracker.assignee">
      <xsl:choose>
        <xsl:when test="($bugtracker/dm:assignee[normalize-space(.) != ''])[last()]">
          <xsl:value-of select="($bugtracker/dm:assignee[normalize-space(.) != ''])[last()]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="pi-attribute">
            <xsl:with-param name="pis" select="$all.pi.nodes"/>
            <xsl:with-param name="attribute">assignee</xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="tracker.component">
      <xsl:choose>
        <xsl:when test="($bugtracker/dm:component[normalize-space(.) != ''])[last()]">
          <xsl:value-of select="($bugtracker/dm:component[normalize-space(.) != ''])[last()]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="pi-attribute">
            <xsl:with-param name="pis" select="$all.pi.nodes"/>
            <xsl:with-param name="attribute">component</xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="tracker.product">
      <xsl:choose>
        <xsl:when test="($bugtracker/dm:product[normalize-space(.) != ''])[last()]">
          <xsl:value-of select="($bugtracker/dm:product[normalize-space(.) != ''])[last()]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="pi-attribute">
            <xsl:with-param name="pis" select="$all.pi.nodes"/>
            <xsl:with-param name="attribute">product</xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="tracker.version">
      <xsl:choose>
        <xsl:when test="($bugtracker/dm:version[normalize-space(.) != ''])[last()]">
          <xsl:value-of select="($bugtracker/dm:version[normalize-space(.) != ''])[last()]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="pi-attribute">
            <xsl:with-param name="pis" select="$all.pi.nodes"/>
            <xsl:with-param name="attribute">version</xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

<xsl:if test="$debug.bugtracker != 0">
    <xsl:message>Tracker: node=<xsl:value-of select="local-name($node)"/>
      len(all.dm.nodes) = <xsl:value-of select="count($all.dm.nodes)"/>
      len(all.pi.nodes) = <xsl:value-of select="count($all.pi.nodes)"/>
      bugtracker = <xsl:value-of select="count($bugtracker)"/>
      tracker.url = <xsl:value-of select="$tracker.url"/>
      tracker.type = <xsl:value-of select="$tracker.type"/>
      tracker.assignee = <xsl:value-of select="$tracker.assignee"/>
      tracker.component = <xsl:value-of select="$tracker.component"/>
      tracker.product = <xsl:value-of select="$tracker.product"/>
      tracker.version = <xsl:value-of select="$tracker.version"/>
    </xsl:message>
</xsl:if>
    
    <xsl:text>&#10;</xsl:text>
    <xsl:comment> Tracker </xsl:comment>

    <xsl:choose>
      <xsl:when test="$tracker.url">
        <meta name="tracker-url" content="{$tracker.url}"/>
        <meta name="tracker-type" content="{$tracker.type}"/>

        <xsl:if test="$tracker.assignee">
          <meta name="tracker-{$tracker.type}-assignee" content="{$tracker.assignee}"/>
        </xsl:if>

        <xsl:if test="$tracker.type = 'bsc'">
          <xsl:if test="$tracker.component">
            <meta name="tracker-bsc-component" content="{$tracker.component}"/>
          </xsl:if>
          <xsl:if test="$tracker.product">
            <meta name="tracker-bsc-product" content="{$tracker.product}"/>
          </xsl:if>
        </xsl:if>

        <xsl:if test="$tracker.version">
          <meta name="tracker-{$tracker.type}-version" content="{$tracker.version}"/>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="log.message">
          <xsl:with-param name="level">WARNING</xsl:with-param>
          <xsl:with-param name="context-desc">tracker</xsl:with-param>
          <!--<xsl:with-param name="context-desc-field-length" select="8"/>-->
          <xsl:with-param name="message">
            <xsl:text>Tracker URL not found. </xsl:text>
            <xsl:text>Check if there is an dm:docmanager/dm:bugtracker/dm:url available</xsl:text>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:comment> /Tracker </xsl:comment>
  </xsl:template>
  
</xsl:stylesheet>