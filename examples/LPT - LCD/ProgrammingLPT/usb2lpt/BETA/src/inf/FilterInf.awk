#AWK-Skript zum Filtern der Ergebnis-INF-Datei
#Übergabevariablen:
# VER_INF=hauptversion,nebenversion,jahr,monat*100+tag
# HLP_LNG=hilfedateisprache, entweder "" oder "en"
#Heraus kommt eine reine ASCII-INF-Datei

BEGIN {
 FS="";		# kein Feld-Separator
 split(VER_INF,v,",");
 DriverVer=sprintf("%02d/%02d/%04d,%d.%02d.%04d.%04d",v[4]/100,v[4]%100,v[3],v[1],v[2],v[3],v[4]);
 helpsrc="usb2lpt.hlp";
 if (HLP_LNG) {
  helpsrc="..\\" HLP_LNG "\\" helpsrc;
 } 
}

/^;/{		# Ganzzeilen-Kommentar zeilenweise löschen
 next;
}

{
 sub(/\$VER_INF\$/,DriverVer);
 sub(/\$HELPSRC\$/,helpsrc);
 if (HLP_LNG) sub(/\$COMMA_HELPSRC\$/,"," helpsrc);
 else sub(/\$COMMA_HELPSRC\$/,"");
 sub(/\t*;.*/,"");	# Angehängten Kommentar löschen
 print;
}
