<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:mcr="xalan://org.mycore.common.xml.MCRXMLFunctions"
  xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation"
  xmlns:mods="http://www.loc.gov/mods/v3"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:cmd="http://www.cdlib.org/inside/diglib/copyrightMD"
  xmlns:exslt="http://exslt.org/common"
  xmlns:piUtil="xalan://org.mycore.pi.frontend.MCRIdentifierXSLUtils"
  exclude-result-prefixes="i18n mcr mods xlink cmd exslt piUtil"
>
  <xsl:import href="xslImport:modsmeta:metadata/mir-citation.xsl" />
  <xsl:include href="mods-dc-meta.xsl"/>
  <xsl:include href="mods-highwire.xsl" />
  <xsl:param name="MCR.URN.Resolver.MasterURL" select="''" />
  <xsl:param name="MCR.DOI.Resolver.MasterURL" select="''" />
  <xsl:param name="MIR.citationStyles" select="''" />
  <xsl:param name="MIR.altmetrics" select="'show'" />
  <xsl:param name="MIR.altmetrics.hide" select="'true'" />
  <xsl:param name="MIR.plumx" select="'hide'" />
  <xsl:param name="MIR.plumx.hide" select="'true'" />
  <xsl:param name="MIR.shariff" select="'show'" />
  <xsl:param name="MIR.shariff.theme" select="'white'" />
  <xsl:param name="MIR.shariff.buttonstyle" select="'icon'" />
  <xsl:param name="MIR.shariff.services" select="''" /> <!-- default: ['mail', 'twitter', 'facebook', 'whatsapp', 'linkedin', 'xing', 'pinterest', 'info'] -->
  <xsl:template match="/">

    <!-- ==================== Highwire Press Tags and Dublin Core as Meta Tags ==================== -->
    <citation_meta>
      <xsl:apply-templates select="mycoreobject/metadata/def.modsContainer/modsContainer/mods:mods" mode="dc-meta"/>
      <xsl:apply-templates select="mycoreobject/metadata/def.modsContainer/modsContainer/mods:mods" mode="highwire" />
    </citation_meta>

    <xsl:variable name="piServiceInformation" select="piUtil:getPIServiceInformation(mycoreobject/@ID)" />
    <xsl:variable name="mods" select="mycoreobject/metadata/def.modsContainer/modsContainer/mods:mods" />

    <div id="mir-citation">
      <xsl:if test="$MIR.shariff = 'show'">
        
        <xsl:variable name="modsTitle">
          <xsl:apply-templates select="$mods" mode="title" />
        </xsl:variable>
        <xsl:variable name="shariffURL">
          <xsl:choose>
            <xsl:when test="$piServiceInformation[@type='doi'][@inscribed='true']">
              <xsl:value-of select="concat($MCR.DOI.Resolver.MasterURL, //mods:mods/mods:identifier[@type='doi'])" />
            </xsl:when>
            <xsl:when test="$piServiceInformation[@type='dnbUrn'][@inscribed='true']">
              <xsl:value-of select="concat($MCR.URN.Resolver.MasterURL, //mods:mods/mods:identifier[@type='urn'])"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat($WebApplicationBaseURL, 'receive/', //mycoreobject/@ID)" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <!-- for more params see http://heiseonline.github.io/shariff/ -->
        <div class="shariff"
             data-theme="white"
             data-button-style="{$MIR.shariff.buttonstyle}"
             data-orientation="horizontal"
             data-mail-body="{$shariffURL}"
             data-mail-subject="{i18n:translate('mir.shariff.subject')}: {$modsTitle}"
             data-mail-url="mailto:"
             data-services="{$MIR.shariff.services}"
             data-url="{$shariffURL}" 
             ></div>
      </xsl:if>
      <xsl:if test="//mods:mods/mods:identifier[@type='doi'] and ($MIR.altmetrics = 'show' or $MIR.plumx = 'show')">
        <div id="mir-metric-badges" class="row">
          <xsl:if test="$MIR.altmetrics = 'show'">
            <script type='text/javascript' src='https://d1bxh8uas1mnw7.cloudfront.net/assets/embed.js'></script>
            <xsl:choose>
              <xsl:when test="$MIR.plumx = 'show'">
                <!-- use altmeltrics badge -->
                <div class="col-xs-6">
                  <div data-badge-type="1" data-badge-popover="right" data-doi="{//mods:mods/mods:identifier[@type='doi']}" data-hide-no-mentions="{$MIR.altmetrics.hide}" class="altmetric-embed"></div>
                </div>
              </xsl:when>
              <xsl:otherwise>
                <!-- show altmetrics donut -->
                <div class="col-xs-12">
                  <div data-badge-details="right" data-badge-type="donut" data-doi="{//mods:mods/mods:identifier[@type='doi']}" data-hide-no-mentions="{$MIR.altmetrics.hide}"
                    class="altmetric-embed"></div>
                </div>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
          <xsl:if test="$MIR.plumx = 'show'">
            <script type='text/javascript' src='//d39af2mgp1pqhg.cloudfront.net/widget-popup.js'></script>
            <xsl:choose>
              <xsl:when test="$MIR.altmetrics = 'show'">
                <!-- use PlumX badge-->
                <div class="col-xs-6">
                  <a href="https://plu.mx/plum/a/?doi={//mods:mods/mods:identifier[@type='doi']}" data-popup="right" data-badge="true" class="plumx-plum-print-popup plum-bigben-theme" data-site="plum" data-hide-when-empty="{$MIR.plumx.hide}">PlumX Metrics</a>
                </div>
              </xsl:when>
              <xsl:otherwise>
                <!-- use Plum Print-->
                <div class="col-xs-12">
                  <a href="https://plu.mx/plum/a/?doi={//mods:mods/mods:identifier[@type='doi']}" data-popup="right" data-size="large" class="plumx-plum-print-popup plum-bigben-theme" data-site="plum" data-hide-when-empty="{$MIR.plumx.hide}">PlumX Metrics</a>
                </div>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </div>
      </xsl:if>

      <div id="citation-style">
        <span>
          <strong>
            <xsl:value-of select="i18n:translate('mir.citationStyle')" />
          </strong>
          <i id="crossref-citation-error" class="fas fa-exclamation-circle hidden" title="{i18n:translate('mir.citationAlertService')}"></i>
        </span>
        <xsl:if test="//mods:mods/mods:identifier[@type='doi'] and string-length($MIR.citationStyles) &gt; 0">
          <xsl:variable name="cite-styles">
            <xsl:call-template name="Tokenizer"><!-- use split function from mycore-base/coreFunctions.xsl -->
              <xsl:with-param name="string" select="$MIR.citationStyles" />
              <xsl:with-param name="delimiter" select="','" />
            </xsl:call-template>
          </xsl:variable>
          <select class="form-control input-sm" id="crossref-cite" data-doi="{//mods:mods/mods:identifier[@type='doi']}">
            <option value="deutsche-sprache">deutsche-sprache</option>
            <xsl:for-each select="exslt:node-set($cite-styles)/token">
              <option value="{.}">
                <xsl:value-of select="." />
              </option>
            </xsl:for-each>
          </select>
        </xsl:if>
        <p id="default-citation-text">
          <xsl:apply-templates select="$mods" mode="authorList" />
          <xsl:apply-templates select="$mods" mode="title" />
          <xsl:apply-templates select="$mods" mode="originInfo" />
          <xsl:apply-templates select="$mods" mode="issn" />
        </p>
        <p id="crossref-citation-text" class="hidden">
        </p>
        <p id="crossref-citation-alert" class="alert alert-danger hidden"><xsl:value-of select="i18n:translate('mir.citationAlert')" /></p>
      </div>

      <p id="cite_link_box">
        <xsl:choose>
          <xsl:when test="$piServiceInformation[@type='doi'][@inscribed='true']">
            <xsl:variable name="doi" select="//mods:mods/mods:identifier[@type='doi']" />
            <a id="url_site_link" href="{$MCR.DOI.Resolver.MasterURL}{$doi}">
              <xsl:value-of select="$doi" />
            </a>
            <br />
            <a id="copy_cite_link" class="label label-info" href="#" title="{i18n:translate('mir.citationLink.title')}">
              <xsl:value-of select="i18n:translate('mir.citationLink')" />
            </a>
          </xsl:when>
          <xsl:when test="$piServiceInformation[@type='dnbUrn'][@inscribed='true']">
            <xsl:variable name="urn" select="//mods:mods/mods:identifier[@type='urn']" />
            <a id="url_site_link" href="{$MCR.URN.Resolver.MasterURL}{$urn}">
              <xsl:value-of select="$urn" />
            </a>
            <br />
            <a id="copy_cite_link" class="label label-info" href="#" title="{i18n:translate('mir.citationLink.title')}">
              <xsl:value-of select="i18n:translate('mir.citationLink')" />
            </a>
          </xsl:when>
          <xsl:otherwise>
            <a id="copy_cite_link" href="#" class="label label-info">
              <xsl:value-of select="i18n:translate('mir.citationLink')" />
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </p>
      <xsl:apply-templates select="//mods:mods" mode="identifierListModal" />
      <xsl:if test="//mods:mods/mods:identifier[@type='doi']">
        <script src="{$WebApplicationBaseURL}js/mir/citation.min.js"></script>
      </xsl:if>
    </div>

    <xsl:if test="mycoreobject/metadata/def.modsContainer/modsContainer/mods:mods/mods:accessCondition[contains('copyrightMD|use and reproduction', @type)]">
      <div id="mir-access-rights">
        <xsl:if test="mycoreobject/metadata/def.modsContainer/modsContainer/mods:mods/mods:accessCondition[@type='copyrightMD']">
          <p>
            <strong>
              <xsl:value-of select="i18n:translate('mir.rightsHolder')" />
            </strong>
            <xsl:text> </xsl:text>
            <xsl:value-of select="//mods:accessCondition[@type='copyrightMD']/cmd:copyright/cmd:rights.holder/cmd:name" />
          </p>
        </xsl:if>
        <xsl:if test="mycoreobject/metadata/def.modsContainer/modsContainer/mods:mods/mods:accessCondition[@type='use and reproduction']">
          <p>
            <strong>
              <xsl:value-of select="i18n:translate('mir.useAndReproduction')" />
            </strong>
            <br />
            <xsl:variable name="trimmed"
              select="substring-after(normalize-space(mycoreobject/metadata/def.modsContainer/modsContainer/mods:mods/mods:accessCondition[@type='use and reproduction']/@xlink:href),'#')" />
            <xsl:choose>
              <xsl:when test="contains($trimmed, 'cc_')">
                <xsl:apply-templates select="mycoreobject/metadata/def.modsContainer/modsContainer/mods:mods/mods:accessCondition[@type='use and reproduction']"
                  mode="cc-logo" />
              </xsl:when>
              <xsl:when test="contains($trimmed, 'rights_reserved')">
                <xsl:apply-templates select="mycoreobject/metadata/def.modsContainer/modsContainer/mods:mods/mods:accessCondition[@type='use and reproduction']"
                  mode="rights_reserved" />
              </xsl:when>
              <xsl:when test="contains($trimmed, 'oa_nlz')">
                <xsl:apply-templates select="mycoreobject/metadata/def.modsContainer/modsContainer/mods:mods/mods:accessCondition[@type='use and reproduction']"
                  mode="oa_nlz" />
              </xsl:when>
              <xsl:when test="contains($trimmed, 'oa')">
                <xsl:apply-templates select="mycoreobject/metadata/def.modsContainer/modsContainer/mods:mods/mods:accessCondition[@type='use and reproduction']"
                  mode="oa-logo" />
              </xsl:when>
              <xsl:when test="contains($trimmed, 'ogl')">
                <xsl:apply-templates select="mycoreobject/metadata/def.modsContainer/modsContainer/mods:mods/mods:accessCondition[@type='use and reproduction']"
                  mode="ogl-logo" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="mycoreobject/metadata/def.modsContainer/modsContainer/mods:mods/mods:accessCondition[@type='use and reproduction']" />
              </xsl:otherwise>
            </xsl:choose>
          </p>
        </xsl:if>
      </div>
    </xsl:if>

    <xsl:apply-imports />
  </xsl:template>

  <xsl:template match="mods:mods" mode="authorList">
    <xsl:choose>
      <xsl:when test="mods:name[mods:role/mods:roleTerm/text()='aut']">
        <xsl:for-each select="mods:name[mods:role/mods:roleTerm/text()='aut']">
          <xsl:choose>
            <xsl:when test="position() &lt; 4">
              <xsl:choose>
                <xsl:when test="mods:namePart[@type='family'] and mods:namePart[@type='given']">
                  <xsl:value-of select="mods:namePart[@type='family']" />
                  <tex>, </tex>
                  <xsl:value-of select="mods:namePart[@type='given']" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="mods:displayForm" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="position() = 4 and not(mods:etal)">
              <em>et al</em>
            </xsl:when>
          </xsl:choose>
          <xsl:if test="not(position()=last()) and position() &lt; 4 and not(mods:etal)">
            <xsl:text> / </xsl:text>
          </xsl:if>
          <xsl:if test="mods:etal">
            <em>et al</em>
          </xsl:if>
        </xsl:for-each>
        <xsl:text>: </xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="mods:mods" mode="identifierListModal">
    <div class="modal fade" id="identifierModal" tabindex="-1" role="dialog" aria-labelledby="modal frame" aria-hidden="true">
      <div class="modal-dialog" style="width: 930px">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close modalFrame-cancel" data-dismiss="modal" aria-label="Close">
              <i class="fas fa-times" aria-hidden="true"></i>
            </button>
            <h4 class="modal-title" id="modalFrame-title">
              <xsl:value-of select="i18n:translate('mir.citationLink')" />
            </h4>
          </div>
          <div id="modalFrame-body" class="modal-body" style="max-height: 560px; overflow: auto">
            <xsl:apply-templates select="mods:identifier[@type='urn' or @type='doi']" mode="identifierList" />
            <xsl:if test="not(mods:identifier[@type='urn' or @type='doi'])">
              <xsl:call-template name="identifierEntry">
                <xsl:with-param name="title" select="'Document-Link'" />
                <xsl:with-param name="id" select="concat($WebApplicationBaseURL, 'receive/', //mycoreobject/@ID)" />
              </xsl:call-template>
            </xsl:if>
          </div>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="mods:identifier[@type='urn' or @type='doi']" mode="identifierList">
    <xsl:variable name="identifier">
      <xsl:if test="contains(@type,'urn')">
        <xsl:text>URN</xsl:text>
      </xsl:if>
      <xsl:if test="contains(@type,'doi')">
        <xsl:text>DOI</xsl:text>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="url">
      <xsl:if test="contains(@type,'urn')">
        <xsl:value-of select="$MCR.URN.Resolver.MasterURL" />
      </xsl:if>
      <xsl:if test="contains(@type,'doi')">
        <xsl:value-of select="$MCR.DOI.Resolver.MasterURL" />
      </xsl:if>
    </xsl:variable>
    <xsl:call-template name="identifierEntry">
      <xsl:with-param name="title" select="concat($identifier, ' (', ., ')')" />
      <xsl:with-param name="id" select="concat($url, .)" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="mods:mods" mode="year">
    <xsl:variable name="dateIssued">
      <xsl:apply-templates mode="mods.datePublished" select="." />
    </xsl:variable>
    <xsl:if test="string-length($dateIssued) &gt; 0">
      <xsl:call-template name="formatISODate">
        <xsl:with-param name="date" select="$dateIssued" />
        <xsl:with-param name="format" select="i18n:translate('metaData.dateYear')" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="mods:mods" mode="originInfo">
    <xsl:variable name="place" select="mods:originInfo/mods:place/mods:placeTerm" />
    <xsl:variable name="edition" select="mods:originInfo/mods:edition" />
    <xsl:variable name="year">
      <xsl:apply-templates select="." mode="year" />
    </xsl:variable>
    <xsl:variable name="publisher" select="mods:originInfo/mods:publisher" />
    <xsl:if test="string-length($place) &gt; 0">
      <xsl:value-of select="$place" />
      <xsl:text>&#160;</xsl:text><!-- add whitespace -->
    </xsl:if>
    <xsl:if test="string-length($edition) &gt; 0">
      <sup>
        <xsl:value-of select="$edition" />
      </sup>
      <xsl:text>&#160;</xsl:text><!-- add whitespace -->
    </xsl:if>
    <xsl:if test="string-length($year) &gt; 0">
      <xsl:value-of select="$year" />
    </xsl:if>
    <xsl:if test="string-length($place) &gt; 0 or string-length($edition) &gt; 0 or string-length($year) &gt; 0">
      <xsl:text>. </xsl:text>
    </xsl:if>
    <xsl:if test="string-length($publisher) &gt; 0">
      <xsl:value-of select="$publisher" />
      <xsl:text>. </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="mods:mods" mode="issn">
    <xsl:variable name="issn" select="mods:identifier[@type='issn']" />
    <xsl:if test="string-length($issn) &gt; 0">
      <xsl:text>ISSN: </xsl:text>
      <xsl:value-of select="$issn"/>
      <xsl:value-of select="'.'" />
    </xsl:if>
  </xsl:template>

  <xsl:template match="mods:mods" mode="title">
    <xsl:variable name="title">
      <xsl:apply-templates select="." mode="mods.title" />
    </xsl:variable>
    <xsl:variable name="subtitle">
      <xsl:apply-templates select="." mode="mods.subtitle" />
    </xsl:variable>
    <xsl:if test="string-length($title) &gt; 0">
      <xsl:value-of select="$title"/>
      <xsl:text>. </xsl:text>
    </xsl:if>
    <xsl:if test="string-length($subtitle) &gt; 0">
      <xsl:value-of select="$subtitle"/>
      <xsl:text>. </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="identifierEntry">
    <xsl:param name="title" />
    <xsl:param name="id" />
    <xsl:if test="string-length($id) &gt; 0">
      <div class="mir_identifier">
        <p>
          <xsl:value-of select="$title" />
        </p>
        <div class="mir_copy_wrapper">
          <span class="fas fa-copy mir_copy_identifier" data-toggle="tooltip" data-placement="left" aria-hidden="true" title="Copy Identifier"
            data-org-title="Copy Identifier"
          ></span>
        </div>
        <pre>
          <a href="{$id}">
            <xsl:value-of select="$id" />
          </a>
        </pre>
        <input type="text" class="hidden mir_identifier_hidden_input" value="{$id}"></input>
      </div>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
