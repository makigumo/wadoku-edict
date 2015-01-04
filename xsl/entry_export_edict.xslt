<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:wd="http://www.wadoku.de/xml/entry"
                version="1.0">
    <xsl:output method="text" encoding="UTF-8" indent="no"/>
    <xsl:strip-space elements="*"/>
<!--
# the EDICT file is in a relatively simple format based on the text data file of the SKK input-method. Each entry is in the form:

    KANJI [KANA] /(general information) gloss/gloss/.../

or

    KANA /(general information) gloss/gloss/.../

Where there are multiple senses, these are indicated by (1), (2), etc. before the first gloss in each sense. As this format only allows a single kanji headword and reading, entries are generated for each possible headword/reading combination. As the format restricts Japanese characters to the kanji and kana fields, any cross-reference data and other informational fields are omitted.

The EDICT file is distributed in JIS X 0208 coding in EUC-JP encapsulation;

# the EDICT2 file is in an expanded form of the original EDICT format. The main differences are the inclusion of multiple kanji headwords and readings, and the inclusion of cross-reference and other information fields, e.g.:

    KANJI-1;KANJI-2 [KANA-1;KANA-2] /(general information) (see xxxx) gloss/gloss/.../

The EDICT2 file is also distributed in JIS X 0208 coding in EUC-JP encapsulation;

# Part of Speech Marking

The following POS markings are currently used:

adj-i	adjective (keiyoushi)
adj-na	adjectival nouns or quasi-adjectives (keiyodoshi)
adj-no	nouns which may take the genitive case particle `no'
adj-pn	pre-noun adjectival (rentaishi)
adj-t	`taru' adjective
adj-f	noun or verb acting prenominally (other than the above)
adj	former adjective classification (being removed)
adv	adverb (fukushi)
adv-n	adverbial noun
adv-to	adverb taking the `to' particle
aux	auxiliary
aux-v	auxiliary verb
aux-adj	auxiliary adjective
conj	conjunction
ctr	counter
exp	Expressions (phrases, clauses, etc.)
int	interjection (kandoushi)
iv	irregular verb
n	noun (common) (futsuumeishi)
n-adv	adverbial noun (fukushitekimeishi)
n-pref	noun, used as a prefix
n-suf	noun, used as a suffix
n-t	noun (temporal) (jisoumeishi)
num	numeric
pn	pronoun
pref	prefix
prt	particle
suf	suffix
v1	Ichidan verb
v2a-s	Nidan verb with 'u' ending (archaic)
v4h	Yodan verb with `hu/fu' ending (archaic)
v4r	Yodan verb with `ru' ending (archaic)
v5	Godan verb (not completely classified)
v5aru	Godan verb - -aru special class
v5b	Godan verb with `bu' ending
v5g	Godan verb with `gu' ending
v5k	Godan verb with `ku' ending
v5k-s	Godan verb - iku/yuku special class
v5m	Godan verb with `mu' ending
v5n	Godan verb with `nu' ending
v5r	Godan verb with `ru' ending
v5r-i	Godan verb with `ru' ending (irregular verb)
v5s	Godan verb with `su' ending
v5t	Godan verb with `tsu' ending
v5u	Godan verb with `u' ending
v5u-s	Godan verb with `u' ending (special class)
v5uru	Godan verb - uru old class verb (old form of Eru)
v5z	Godan verb with `zu' ending
vz	Ichidan verb - zuru verb - (alternative form of -jiru verbs)
vi	intransitive verb
vk	kuru verb - special class
vn	irregular nu verb
vs	noun or participle which takes the aux. verb suru
vs-c	su verb - precursor to the modern suru
vs-i	suru verb - irregular
vs-s	suru verb - special class
vt	transitive verb

-->
    <xsl:template match="wd:entry">
        <xsl:for-each select="//wd:orth[not(@midashigo='true')]">
            <xsl:apply-templates/>
            <xsl:apply-templates select="//wd:reading/wd:hira"/>
            <xsl:apply-templates select="//wd:sense"/>
            <xsl:text>/</xsl:text>
            <xsl:if test="position()&lt;last()">
                <xsl:text>&#10;</xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="wd:orth">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="wd:hira">
        <xsl:text> [</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>]</xsl:text>
    </xsl:template>

    <xsl:template match="wd:pos"/>
    <xsl:template match="//wd:usg[@type='dom']"/>

    <xsl:template match="wd:sense">
        <xsl:if test="count(preceding-sibling::wd:sense)=0">
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="wd:tr">
        <xsl:text>/</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="wd:token">
        <xsl:variable name="neu">
            <xsl:call-template name="string-replace-all">
                <xsl:with-param name="text" select="."/>
                <xsl:with-param name="replace" select="'/'"/>
                <xsl:with-param name="by" select="'&#8725;'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="preceding-sibling::*[1][self::wd:bracket]">
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:value-of select="$neu"/>
    </xsl:template>

    <xsl:template match="wd:text">
        <xsl:variable name="neu">
            <xsl:call-template name="string-replace-all">
                <xsl:with-param name="text" select="."/>
                <xsl:with-param name="replace" select="'/'"/>
                <xsl:with-param name="by" select="'&#8725;'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="@hasPrecedingSpace='true'">
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:value-of select="$neu"/>
        <xsl:if test="@hasFollowingSpace='true'">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="wd:bracket[@meta]"/>

    <xsl:template match="wd:bracket">
        <xsl:if test="preceding-sibling::*[1]
        [self::wd:token or
         self::wd:def or
         self::wd:famn]">
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:if test="preceding-sibling::*[1][self::wd:text[not(@hasFollowingSpace)]]">
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:text>(</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>)</xsl:text>
    </xsl:template>

    <xsl:template match="wd:expl">
        <xsl:if test="count(preceding-sibling::*)&gt;0">
            <xsl:text>; </xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="wd:birthdeath">
        <xsl:if test="count(preceding-sibling::*)&gt;0">
            <xsl:text>; </xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="wd:jap">
        <xsl:if test="preceding-sibling::*[1][self::wd:transcr]">
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- ignoriere links -->
    <xsl:template match="wd:link"/>

    <xsl:template match="wd:usg[@type='hint']"/>
    <xsl:template match="wd:usg[@type='time']"/>
    <xsl:template match="wd:etym"/>
    <xsl:template match="wd:ref"/>
    <xsl:template match="wd:expl/wd:ref">
        <xsl:value-of select="./wd:jap"/>
    </xsl:template>
    <xsl:template match="wd:sref"/>
    <xsl:template match="wd:splitting"/>

    <xsl:template name="string-replace-all">
        <xsl:param name="text"/>
        <xsl:param name="replace"/>
        <xsl:param name="by"/>
        <xsl:choose>
            <xsl:when test="contains($text, $replace)">
                <xsl:value-of select="substring-before($text, $replace)"/>
                <xsl:value-of select="$by"/>
                <xsl:call-template name="string-replace-all">
                    <xsl:with-param name="text" select="substring-after($text, $replace)"/>
                    <xsl:with-param name="replace" select="$replace"/>
                    <xsl:with-param name="by" select="$by"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
