# Conversion script for wadoku.de's XML data into edict/edict2 format

This are basically XSL transformation files to be applied to the XML data.

* ```entry_export_edict.xsl``` will produce an UTF-8 encoded EDICT compatible file.
* ```entry_export_edict2.xsl``` will produce an UTF-8 encoded EDICT2 compatible file.

For convenience a helper perl script ```xslttransform.pl``` is included.

```
./xslttransform.pl xsl/entry_export_edict.xsl wadoku.xml > outputfile
```

