<?xml version="1.0" encoding="UTF-8"?>
<!--
  Purpose:
    Transform DocBook document into XSL-FO file

    The page layout is based upon a grid of eight columns (the leftmost and
    rightmost column function as margins), each 22.5 mm wide, and five gutters,
    each 6 mm wide:
    |   C1  |  C2  |G1|  C3  |G2|  C4  |G3|  C5  |G4|  C6  |G5|  C7  |  C8  |

  Parameters:
    Too many to list here, see:
    http://docbook.sourceforge.net/release/xsl/current/doc/fo/index.html

  Input:
    DocBook 4/5 document

   Output:
     XSL-FO file

  Authors:    Thomas Schraitle <toms@opensuse.org>,
              Stefan Knorr <sknorr@suse.de>
  Copyright:  2014, Thomas Schraitle, Stefan Knorr

-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exsl="http://exslt.org/common"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  exclude-result-prefixes="exsl">

  <!-- FIXME: Better use a full URL for catalog-based resolution here? The
       caveat of doing that would of course be possible dependency issues,
       since we generally want matching stylesheets not any and all that are
       installed on the system. -->
  <xsl:import href="../../suse2013/fo/docbook.xsl"/>

  <xsl:include href="../version.xsl"/>

</xsl:stylesheet>
