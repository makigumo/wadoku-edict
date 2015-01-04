<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:wd="http://www.wadoku.de/xml/entry"
                version="1.0">
    <xsl:import href="entry_export_edict.xslt"/>
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

adj	adjective (keiyoushi)
adj-na	adjectival nouns or quasi-adjectives (keiyodoshi)
adj-no	nouns which may take the genitive case particle `no'
adj-pn	pre-noun adjectival (rentaishi)
adj-t	`taru' adjective
adv	adverb (fukushi)
adv-n	adverbial noun
adv-to	adverb taking the `to' particle
aux	auxiliary
aux-v	auxiliary verb
aux-adj	auxiliary adjective
conj	conjunction
exp	Expressions (phrases, clauses, etc.)
id	idiomatic expression
int	interjection (kandoushi)
iv	irregular verb
n	noun (common) (futsuumeishi)
n-adv	adverbial noun (fukushitekimeishi)
n-pref	noun, used as a prefix
n-suf	noun, used as a suffix
n-t	noun (temporal) (jisoumeishi)
neg	negative (in a negative sentence, or with negative verb)
neg-v	negative verb (when used with)
num	numeric
pref	prefix
prt	particle
suf	suffix
v1	Ichidan verb
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
vi	intransitive verb
vk	kuru verb - special class
vs	noun or participle which takes the aux. verb suru
vs-i	suru verb - irregular
vs-s	suru verb - special class
vt	transitive verb
vz	zuru verb - (alternative form of -jiru verbs)


-->
    <xsl:template match="wd:entry">
        <xsl:apply-templates select="//wd:orth"/>
        <xsl:apply-templates select="//wd:reading/wd:hira"/>
        <xsl:apply-templates select="//wd:sense"/>
        <xsl:text>/</xsl:text>
    </xsl:template>

    <xsl:template match="wd:orth">
        <xsl:choose>
            <xsl:when test="@midashigo='true'"/>
            <xsl:otherwise>
                <xsl:apply-templates />
		        <xsl:if test="count(following-sibling::wd:orth[not(@midashigo='true')])>0" >
			        <xsl:text >;</xsl:text>
		        </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
