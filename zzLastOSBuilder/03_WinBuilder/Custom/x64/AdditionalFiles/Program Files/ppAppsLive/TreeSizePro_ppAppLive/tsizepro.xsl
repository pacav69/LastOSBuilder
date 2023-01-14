<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" version="4.0" encoding="UTF-8" indent="yes" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" doctype-system="http://www.w3.org/TR/html4/loose.dtd" />

<!-- These declarations define the behavior of the size units. If you want to have a kB conversion for example, replace "$MB" with "$kB"
However, the unit identifier is printed statically. Be sure to change them, too. -->
<!-- <xsl:decimal-format decimal-separator="," grouping-separator="." /> --> <!-- setting decimal number format e.g.: 1.000,00 -->
<xsl:variable name="kB">1024</xsl:variable> <!-- kB divisor -->
<xsl:variable name="MB">1048576</xsl:variable> <!-- MB divisor -->
<xsl:variable name="GB">1073741824</xsl:variable> <!-- GB divisor -->
<xsl:variable name="Drivefs">#,##0.0#</xsl:variable> <!-- GB format string -->
<xsl:variable name="Folderfs">#,##0.00</xsl:variable> <!-- MB format string -->

<xsl:template match="/Root"> <!-- the main template -->
	<html>
	<head>
		<title>TreeSize Professional Report, <xsl:value-of select="Date" /></title>
		<style type="text/css"> <!-- these are all the stylesheet definitions used in the output -->
			body {font-family: Arial;} /* font of the other tags */
			h1,h2,h3 {text-align: center;} /* center headlines */
			table {font-family: Arial Narrow, Arial; padding:2px; width:100%;} /* tree-table design */
			/*
				Note: If you experience UTF-8 problems, i.e. characters, which are not displayed correctly, you may want to use
				Arial instead of Arial Narrow, here. While testing, we had the problem that some arabic letters were not
				available in Arial Narrow. If you are working with a system, which does not make frequent use of non Latin Characters
				you should still use Arial Narrow, if possible.
			*/
			th {border-bottom-color: #000; border-bottom-style: solid; border-bottom-width: 1px;} /* line drawn on the bottom of the th's */
			.box {display: none;} /* invisible div's */
			.boxon {display: block;} /* visible div's */
			.tree {font-family: Courier;} /* indention and '+'/'-' font */
			.error {background-color: #FFFF88;} /* background to visualize scanning errors */
			.tabbig {width: 30%; text-align: left; white-space: nowrap; cursor: pointer;} /* name column */
			.tab {width: 10%; text-align: center; white-space: nowrap;} /* size column */
			.tabright {width: 10%; text-align: right; white-space: nowrap;} /* compression column */
		</style>
		<script type="text/javascript">
			<!-- JavaScript functions to create tree effects view design -->
			function SwitchDisplay(node) // function which changes the visibility of the div's
			{
				var nextnode = node.nextSibling;  // get next sibling node
				if (nextnode.style.display != "block") // change visibility into the opposite
				{
					nextnode.style.display = "block";
				}
				else
				{
					nextnode.style.display = "none";
				}
				SwitchTreeSymbol(node);
			}

			function SwitchTreeSymbol(node) // function which switches the + into - and vice versa
			{
				var targetnode = node.firstChild.firstChild.firstChild.firstChild.firstChild.firstChild; // get suitable node (the span-tag)
				if ( targetnode != null) // check if node is available
				{
					s = new String(targetnode.nodeValue); // get the node's text
					if ((i = s.indexOf("+")) != -1) // switch tree symbol into it's opposite
					{
					targetnode.nodeValue = (s.substr(0,i) + "-" + s.substr(i+1,s.length));
					}
					else if ((i = s.indexOf("-")) != -1)
					{
					targetnode.nodeValue = (s.substr(0,i) + "+" + s.substr(i+1,s.length));
					}
				}
			}

			function twodigits(n) // function which creates an extended date, e.g. "1" becomes "01"
			{
				if (n &lt; 10) // if (n less than 10)
					return "0" + n;
				else
					return n;
			}

			function TimeConversion(highfiletime) // converts the FileTime value into JavaScript's intern time and then into a
			{
			// human-readable format. However, this is not 100% accurate, because
			// only the upper 32 bits of the Windows timestamp are converted.
				if (highfiletime != 0)
				{
					highfiletime = (highfiletime - 27111902) * 429.4967296;
					var javatime = new Date(highfiletime * 1000); // JavaScript's intern time: milliseconds since 01.01.1970 00:00:00
					return twodigits(javatime.getDate()) + "." + twodigits((javatime.getMonth() + 1)) + "." + javatime.getFullYear();
				}
				else
					return "";
			}
			</script>
		</head>
		<body>
		<xsl:apply-templates select="Date" />
		<xsl:choose> <!-- distinguish single from multi scan -->
			<xsl:when test="@Type = 'TVirtualRoot'">
				<xsl:call-template name="TableSetup" />
				<xsl:apply-templates select="./Root/Folder" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="SingleScan" />
			</xsl:otherwise>
		</xsl:choose>
	</body>
	</html>
</xsl:template>

<xsl:template name="SingleScan"> <!-- single scan drive and folder details -->
	<xsl:apply-templates select="Title" />
	<xsl:if test="(ArchiveBitFilesOnly != 0) or (CreatedPastDaysOnly != 0) or (Filter/pattern != '*') or (ExpandedOnly != 0)">
		<h3><xsl:text>Includes:</xsl:text>
			<xsl:apply-templates select="ArchiveBitFilesOnly" />
			<xsl:apply-templates select="CreatedPastDaysOnly" />
			<xsl:apply-templates select="Filter" />
			<xsl:apply-templates select="ExpandedOnly" />			
		</h3>
	</xsl:if>
	<xsl:apply-templates select="ExcludePatterns" />
	<h3>
		<xsl:text>Drive:</xsl:text>
		<xsl:text>&#160;&#160;</xsl:text><xsl:apply-templates select="UsedBytesOnDrive" />
		<xsl:text>&#160;&#160;</xsl:text><xsl:apply-templates select="FreeBytesOnDrive" />
		<xsl:text>&#160;&#160;</xsl:text><xsl:apply-templates select="BytesPerCluster" /><xsl:text>&#160;Bytes</xsl:text>
		<xsl:text>&#160;&#160;Filesystem:&#160;(</xsl:text><xsl:apply-templates select="Filesystem" /><xsl:text>)</xsl:text>
	</h3>
	<h3>
		<xsl:text>This Folder:</xsl:text>
		<xsl:apply-templates select="./Folder/SizeData" />
	</h3>
	<br />
	<xsl:call-template name="TableSetup" />
	<xsl:apply-templates select = "./Folder/Folder">
		<xsl:with-param name="anc_fix" select="1" /> <!-- ancestor count fix needed in single scan -->
	</xsl:apply-templates>
</xsl:template>

<xsl:template name="TableSetup">
	<table cellspacing="0">
		<tr>
		<th class="tabbig">Name:</th>
		<th class="tabright">Size:</th>
		<th class="tabright">Allocated:</th>
		<th class="tabright">Wasted:</th>
		<th class="tabright">Files:</th>
		<th class="tabright">Folders:</th>
		<th class="tabright">Last&#160;Change:</th>
		<th class="tab">Compression:</th>
		</tr>
	</table>
</xsl:template>

<xsl:template match="Date"> <!-- Headline with Date -->
	<h1 align="center">
		<xsl:text>TreeSize Professional Report, </xsl:text>
		<xsl:value-of select="." />
	</h1>
</xsl:template>

<xsl:template match="Title">
	<h2 align="center">
		<xsl:value-of select="." />
	</h2>
</xsl:template>

<xsl:template match="ArchiveBitFilesOnly">
	<xsl:if test=". != 0">
		<xsl:text> Only Files created in the past.</xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="CreatedPastDaysOnly">
	<xsl:if test=". != 0">
		<xsl:text> Only Files with Archive Bit set.</xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="Filter">
	<xsl:if test="pattern != '*' ">
		<xsl:value-of select="pattern" />
	</xsl:if>
</xsl:template>

<xsl:template match="ExpandedOnly">
	<xsl:if test=". != 0">
		<xsl:text> Only expanded Directories.</xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="ExcludePatterns">
	<xsl:if test="pattern">
		<xsl:text>Excludes: </xsl:text>
		<xsl:for-each select="pattern">
			<xsl:value-of select="." />
			<xsl:if test="position() != last()">, </xsl:if>
		</xsl:for-each>
	</xsl:if>
</xsl:template>

<xsl:template match="UsedBytesOnDrive"> <!-- drive size -->
	<xsl:text>Size:&#160;</xsl:text>
	<xsl:value-of select="format-number(. div $GB,$Drivefs)" />
	<xsl:text>&#160;GB</xsl:text>
</xsl:template>

<xsl:template match="FreeBytesOnDrive"> <!-- free size on drive -->
	<xsl:text>Free:&#160;</xsl:text>
	<xsl:value-of select="format-number(. div $GB,$Drivefs)" />
	<xsl:text>&#160;GB</xsl:text>
</xsl:template>

<xsl:template match="BytesPerCluster"> <!-- bytes per cluster -->
	<xsl:text>Bytes per Cluster:&#160;</xsl:text>
	<xsl:value-of select="." />
</xsl:template>

<xsl:template match="Filesystem"> <!-- used filesystem -->
	<xsl:value-of select="." />
</xsl:template>

<xsl:template match="/Root/Folder/SizeData">
	<xsl:text>&#160;&#160;Size:&#160;</xsl:text>
		<xsl:value-of select="format-number(@Size div $MB,$Folderfs)" /> <!-- formatting numbers -->
	<xsl:text>&#160;MB</xsl:text>
	<xsl:text>&#160;&#160;Allocated:&#160;</xsl:text>
		<xsl:value-of select="format-number(@Allocated div $MB,$Folderfs)" />
	<xsl:text>&#160;MB</xsl:text>
	<xsl:text>&#160;&#160;Wasted:&#160;</xsl:text>
		<xsl:value-of select="format-number(@Wasted div $MB,$Folderfs)" />
	<xsl:text>&#160;MB</xsl:text>
	<xsl:text>&#160;&#160;Files:&#160;</xsl:text>
		<xsl:value-of select="@Files" />
	<xsl:text>&#160;&#160;Folders:&#160;</xsl:text>
		<xsl:value-of select="@Folders" />
	<xsl:text>&#160;&#160;Compression:&#160;</xsl:text>
	<xsl:choose> <!-- Compression Test -->
		<xsl:when test="@Compression = 1">
			<xsl:text>no</xsl:text>
		</xsl:when>
		<xsl:when test="@Compression = 2">
			<xsl:text>yes</xsl:text>
		</xsl:when>
		<xsl:when test="@Compression = 3">
			<xsl:text>partial</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>unknown</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="Folder">
	<xsl:param name="anc_fix" select="0" /> <!-- ancestor count fix needed for single scan -->
	<div onClick="SwitchDisplay(this);">
		<table cellspacing="0">
			<tr>
				<td class="tabbig" title="{Name}">
					<xsl:variable name="anc_count" select="(count(ancestor::Folder) - $anc_fix)" />
					<span class="tree">
						<xsl:call-template name="IndentRecursiveLoop"> <!-- indention and tree symbol -->
							<xsl:with-param name="counter" select="$anc_count" />
						</xsl:call-template>
					</span>
					<xsl:if test="Error"> <!-- visualize scanning errors -->
						<span class="error" title="An Error occurred during the scan process!">
							<xsl:text>&#160;!&#160;</xsl:text>
						</span>
						</xsl:if>
					<xsl:call-template name="strlengthcheck">  <!-- truncates long names -->
						<xsl:with-param name="indention" select="$anc_count" />
					</xsl:call-template>
				</td>
				<xsl:apply-templates select="SizeData">
					<xsl:with-param name="LastChange" select="LastChangeDate/@High" />
				</xsl:apply-templates>
			</tr>
		</table>
	</div>
	<div class="box"> <!-- make new nodes invisible, because of the tree structure -->
		<xsl:for-each select="Folder">
			<xsl:apply-templates select="."> <!-- recursion -->
				<xsl:with-param name="anc_fix" select="$anc_fix" /> <!-- ancestor count fix needed for single scan -->
			</xsl:apply-templates>
		</xsl:for-each>
	</div>
</xsl:template>

<xsl:template name="strlengthcheck"> <!-- truncates long names and adds "..." -->
	<xsl:param name="indention" />
	<xsl:choose>
		<xsl:when test="(string-length(Name) + $indention) &gt;= 28">
			<xsl:value-of select="substring(Name,1,(25-$indention))" />
			<xsl:text>...</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="Name" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="IndentRecursiveLoop"> <!-- makes indention used to make the tree hierarchy visible -->
	<xsl:param name="counter" />
	<xsl:choose>
		<xsl:when test="$counter &gt; 0">
			<xsl:text>&#160;&#160;</xsl:text>
			<xsl:call-template name="IndentRecursiveLoop">
				<xsl:with-param name="counter" select="($counter)-1" />
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="count(./Folder)">
			<xsl:text>+&#160;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>&#160;&#160;</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="SizeData">
	<xsl:param name="LastChange" />
	<td class="tabright">
		<xsl:value-of select="format-number(@Size div $MB,$Folderfs)" />
		<xsl:text>&#160;MB</xsl:text>
	</td>
	<td class="tabright">
		<xsl:value-of select="format-number(@Allocated div $MB,$Folderfs)" />
		<xsl:text>&#160;MB</xsl:text>
	</td>
	<td class="tabright">
		<xsl:value-of select="format-number(@Wasted div $MB,$Folderfs)" />
		<xsl:text>&#160;MB</xsl:text>
	</td>
	<td class="tabright">
		<xsl:value-of select="@Files" />
	</td>
	<td class="tabright">
		<xsl:value-of select="@Folders" />
	</td>
	<xsl:variable name="uid" select="generate-id(@Size)" /> <!-- generating unique id -->
	<td class="tabright" id="{$uid}">&#160;
	<xsl:text>&#160;</xsl:text>
	</td>
	<script type="text/javascript">
		document.getElementById("<xsl:value-of select="$uid" />").firstChild.nodeValue = TimeConversion(<xsl:value-of select="$LastChange" />);
	</script>
	<td class="tab">
		<xsl:choose> <!-- Compression Test -->
			<xsl:when test="@Compression = 1">
				<xsl:text>no</xsl:text>
			</xsl:when>
			<xsl:when test="@Compression = 2">
				<xsl:text>yes</xsl:text>
			</xsl:when>
			<xsl:when test="@Compression = 3">
				<xsl:text>partial</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>unknown</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</td>
</xsl:template>

</xsl:stylesheet>
