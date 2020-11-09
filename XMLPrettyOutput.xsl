<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="margin">
		<xsl:param name="margin"/>
		<xsl:if test="$margin > 0">
			&#160;
			<xsl:call-template name="margin">
				<xsl:with-param name="margin" select="$margin - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="Attr"><span class="xmlpretty-attr">&#160;<xsl:value-of select="@name"/></span>="<span class="xmlpretty-attr-value"><xsl:value-of select="@value"/></span>"</xsl:template>

	<xsl:template match="Node">
		<div class="xmlpretty-node">

			<xsl:if test="count(parent::*) = 0">
				<style>
					.xmlpertty-text {color:black;}
					.xmlpretty-node {color:rgb(136, 18, 128);}
					.xmlpretty-attr {color:rgb(153, 69, 0);}
					.xmlpretty-attr-value {color:rgb(26, 26, 166);}
					* {font-size:13px;font-family:monospace;}
				</style>
			</xsl:if>

			<xsl:call-template name="margin">
				<xsl:with-param name="margin" select="@marginLeft"/>
			</xsl:call-template>

			&lt;<xsl:value-of select="@name"/>

			<xsl:apply-templates select="Attr"/>

			<xsl:choose>
				<xsl:when test="count(Node)">&gt;<br/>
					<xsl:apply-templates select="Node"/>
					<xsl:call-template name="margin">
						<xsl:with-param name="margin" select="@marginLeft"/>
					</xsl:call-template>&lt;/<xsl:value-of select="@name"/>&gt;
				</xsl:when>
				<xsl:otherwise>

					<xsl:choose>
						<xsl:when test="@value = ''">/&gt;</xsl:when>
						<xsl:otherwise>&gt;<span class="xmlpertty-text"><xsl:value-of select="@value"/></span>&lt;/<xsl:value-of select="@name"/>&gt;</xsl:otherwise>
					</xsl:choose>

				</xsl:otherwise>
			</xsl:choose>

		</div>
	</xsl:template>

</xsl:stylesheet>