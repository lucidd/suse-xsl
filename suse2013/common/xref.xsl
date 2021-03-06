<?xml version="1.0" encoding="UTF-8"?>
<!--
  Purpose:
    Collect common linking templates, independant of any target format

  Author(s):  Stefan Knorr <sknorr@suse.de>
              Thomas Schraitle <toms@opensuse.org>

  Copyright:  2015 Thomas Schraitle

-->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  exclude-result-prefixes="xlink fo">


<xsl:template match="*" mode="intra.title.markup">
  <xsl:param name="linkend"/>
  <xsl:param name="first" select="0"/>
  <xsl:message>Element <xsl:value-of select="local-name(.)"/> cannot be used for intra xref linking.</xsl:message>
  <xsl:message>- affected ID: <xsl:value-of select="(./@id|./@xml:id)[last()]"/></xsl:message>
</xsl:template>


<xsl:template name="create.linkto.other.book">
  <xsl:param name="target"/>
  <xsl:variable name="refelem" select="local-name($target)"/>
  <xsl:variable name="target.article" select="$target/ancestor-or-self::article"/>
  <xsl:variable name="target.book" select="$target/ancestor-or-self::book"/>
  <xsl:variable name="lang" select="ancestor-or-self::*/@lang"/>
  <xsl:variable name="text">
    <xsl:apply-templates select="$target" mode="intra.title.markup">
      <xsl:with-param name="linkend" select="@linkend"/>
    </xsl:apply-templates>
  </xsl:variable>

  <!--<xsl:message>====== create.linkto.other.book:
    linkend=<xsl:value-of select="@linkend"/>
     target=<xsl:value-of select="local-name($target)"/>
    refelem=<xsl:value-of select="$refelem"/>
       text=<xsl:value-of select="$text"/>
  </xsl:message>-->

  <xsl:copy-of select="$text"/>
</xsl:template>


<!-- ################################################################### -->
  <xsl:template match="sect1" mode="intra.title.markup">
    <xsl:param name="linkend"/>
    <xsl:param name="first" select="0"/>
    <!--<xsl:message>sect1 intra.title.markup
  <xsl:call-template name="xpath.location"/>
  </xsl:message>-->
    <xsl:apply-templates select="parent::*" mode="intra.title.markup"/>
    <xsl:text>, </xsl:text>
    <xsl:call-template name="substitute-markup">
      <xsl:with-param name="template">
        <xsl:call-template name="gentext.template">
          <xsl:with-param name="context" select="'xref'"/>
          <xsl:with-param name="name"  select="concat('intra-', local-name())"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="sect2|sect3|sect4|sect5" mode="intra.title.markup">
    <xsl:param name="linkend"/>
    <xsl:param name="first" select="0"/>
    <!--<xsl:message><xsl:value-of select="local-name(.)"/> intra.title.markup
  <xsl:call-template name="xpath.location"/>
  </xsl:message>-->
    <xsl:apply-templates
      select="ancestor::appendix|ancestor::article|
      ancestor::chapter|ancestor::glossary|ancestor::preface"
      mode="intra.title.markup"/>
    <xsl:text>, </xsl:text>
    <xsl:call-template name="substitute-markup">
      <xsl:with-param name="template">
        <xsl:call-template name="gentext.template">
          <xsl:with-param name="context" select="'xref'"/>
          <xsl:with-param name="name"  select="concat('intra-', local-name())"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="appendix|chapter" mode="intra.title.markup">
    <xsl:param name="linkend"/>
    <xsl:param name="first" select="0"/>
    <!--<xsl:message><xsl:value-of select="local-name(.)"/> intra.title.markup
  <xsl:call-template name="xpath.location"/>
  </xsl:message>-->
    <!-- We don't want parts -->
    <xsl:apply-templates select="ancestor::book" mode="intra.title.markup"/>
    <xsl:text>, </xsl:text>
    <xsl:call-template name="substitute-markup">
      <xsl:with-param name="template">
        <xsl:call-template name="gentext.template">
          <xsl:with-param name="context" select="'xref'"/>
          <xsl:with-param name="name"  select="concat('intra-', local-name())"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="preface" mode="intra.title.markup">
    <xsl:param name="linkend"/>
    <xsl:param name="first" select="0"/>
    <xsl:apply-templates select="parent::*" mode="intra.title.markup"/>
    <!--<xsl:apply-templates select="." mode="title.markup"/>-->

    <xsl:text>, </xsl:text>
    <xsl:call-template name="substitute-markup">
      <xsl:with-param name="template">
        <xsl:call-template name="gentext.template">
          <xsl:with-param name="context" select="'xref'"/>
          <xsl:with-param name="name"  select="concat('intra-', local-name())"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="part" mode="intra.title.markup">
    <xsl:param name="linkend"/>
    <xsl:param name="first" select="0"/>
    <!-- We don't want parts, so skip them -->
    <xsl:apply-templates select="parent::*" mode="intra.title.markup"/>
  </xsl:template>


  <xsl:template match="article|book" mode="intra.title.markup">
    <xsl:param name="linkend"/>
    <xsl:param name="first" select="0"/>
    <!--<xsl:message><xsl:value-of select="local-name(.)"/> intra.title.markup
  <xsl:call-template name="xpath.location"/>
  </xsl:message>-->
    <xsl:call-template name="substitute-markup">
      <xsl:with-param name="template">
        <xsl:call-template name="gentext.template">
          <xsl:with-param name="context" select="'xref'"/>
          <xsl:with-param name="name"  select="concat('intra-', local-name())"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="variablelist" mode="intra.title.markup">
    <xsl:param name="linkend"/>
    <xsl:param name="first" select="0"/>

    <xsl:apply-templates select="parent::*"
      mode="intra.title.markup"/>
    <xsl:if test="title">
      <xsl:text>, </xsl:text>
      <xsl:apply-templates select="." mode="title.markup"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="varlistentry" mode="intra.title.markup">
    <xsl:param name="linkend"/>
    <xsl:param name="first" select="0"/>
    <xsl:apply-templates select="ancestor::appendix|ancestor::article|
      ancestor::chapter|ancestor::glossary|ancestor::preface"
      mode="intra.title.markup"/>
    <xsl:value-of select="concat(' ', term[1])"/>
  </xsl:template>

</xsl:stylesheet>