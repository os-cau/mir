<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation"
                xmlns:mods="http://www.loc.gov/mods/v3"
                xmlns:xlink="http://www.w3.org/1999/xlink">
  <xsl:import href="xslImport:modsmeta:metadata/mir-file-upload.xsl"/>

  <xsl:template match="/">
    <xsl:variable name="objID" select="mycoreobject/@ID"/>
    <div id="mir-file-upload">
      <xsl:if test="key('rights', mycoreobject/@ID)/@write">
        <div data-upload-object="{$objID}" data-upload-target="/">
          <xsl:choose>
            <xsl:when test="count(mycoreobject/structure/derobjects/derobject)=0">
              <xsl:attribute name="class">drop-to-object mir-file-upload-box well</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="class">drop-to-object-optional mir-file-upload-box well</xsl:attribute>
              <xsl:attribute name="style">display:none;</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <i class="fa fa-upload"></i>
          <xsl:value-of disable-output-escaping="yes" select="concat(' ', i18n:translate('mir.upload.drop.derivate'))"/>
        </div>
        <script>
          mycore.upload.enable(document.querySelector(".drop-to-object,.drop-to-object-optional").parentElement);
        </script>
      </xsl:if>
    </div>
    <xsl:apply-imports/>

  </xsl:template>

</xsl:stylesheet>