#AWK-Skript zum Filtern der RC-Include-Dateien (schon in Codepage)
#f�r die [Strings]-Sektion in der .INF-Datei

/^\/\*/{
 o=1;
 next;
}

/\*\//{
 o=0;
}

{
 if (o) print;
}
