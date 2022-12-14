// DIALOG(EX)
#define S10000	"Emulation"
#define S10001	"Emulierte Port&adresse:"
#define S10002	"LPT-&Erweiterung:"
#define S10003	"Anzapfungsmethode für IN- und OUT-Befehle"
#define S10004	"mittels &Debugregister"
#define S10005	"(erfasst alle Arten von IN- und OUT-Befehlen)"
#define S10006	"&Belegung erzwingen, auch wenn sie belegt erscheinen"
#define S10007	"Umleitung von &READ_PORT_UCHAR / WRITE_PORT_UCHAR"
#define S10008	"(schneller und stabiler)"
#define S10009	"Performance-Optionen"
#define S10010	"&Schreibcache für OUT-Befehle"
#define S10011	"(Zusammenfassung mehrerer OUT-Befehle zu einem USB-Paket)"
#define S10012	"Paketversendung er&zwingen nach"
#define S10014	"Rüc&klesen einer Kopie von Ausgabe-Registern"
#define S10015	"E&xakter…"
#define S10016	"(liefert zuletzt geschriebenen Wert bei IN-Befehl; funktioniert nicht wenn Ausgänge durch externe Hardware gesteuert werden)"

#define S10100	"Statistik"
#define S10101	"Debugregister-Anzapfung"
#define S10102	"&Null setzen"
#define S10103	"OUT-Befehle:"
#define S10104	"IN-Befehle:"
#define S10105	"Emulationsfehler:"
#define S10106	"(nicht unterstützter IN- oder OUT-Befehl, bspw. OUTSB)"
#define S10107	"Gestohlene Debugregister:"
#define S10108	"(Unbekannter Treiber hat die Debugregister überschrieben)"
#define S10109	"Überschriebene Debugregister werden mit einem 100-ms-Timer detektiert."
#define S10110	"Tatsächlich zugewiesen an:"
#define S10114	"Umleitung READ_PORT_UCHAR / WRITE_PORT_UCHAR"
#define S10115	"Null &setzen"
#define S10116	"Überlänge:"
#define S10117	"USB2LPT-&Extras…"
#define S10118	"Firmware-&Update…"
#define S10119	"haftmann#software, Technische Universität Chemnitz,\nFakultät für Elektrotechnik und Informationstechnik,\nProfessur für Mess- und Sensortechnik, 2006-2009"

#define S10200	"Rücklese-Kopie von Ausgaberegistern"
#define S10201	"&Datenport (Basisadresse + 0)"
#define S10202	"&Steuerport (Basisadresse + 2)"
#define S10203	"&Extra-Ports (ECP, EPP)"
#define S10204	"OK"
#define S10205	"Abbrechen"

#define S10302	"Eine falsch angegebene Adresse kann Ihren Computer zum »Einfrieren« bringen oder schlimmeres! Die Verwendung einer der drei Vorgaben gilt als sicher."
#define S10304	"Die LPT-Erweiterung bewirkt die Emulation weiterer Portadressen.\nSie wird vergleichsweise selten benötigt und die SPP-Einstellung ist OK."
#define S10305	"Diese und weitergehende Einstellungen können im Betrieb über Eigenschaftsseiten im Geräte-Manager vorgenommen werden."

#define S10400	"USB2LPT-Extras"
#define S10401	"Feature-Register"
#define S10402	"(Das Feature-Register wird im EEPROM des USB2LPT persistent gespeichert. Zugriff via DeviceIoControl)"
#define S10403	"Offene Kollektoren für &Datenport (+0)"
#define S10404	"Offene Kollektoren für &Steuerport (+2)"
#define S10405	"&Pullups (und 5V am Pin25, falls nachgerüstet) abschalten"
#define S10406	"&Direkter Ein/Ausgabemodus (USB2LPT wird zum I/O-Gerät)"
#define S10407	"(bewirkt schwache Ausgangsspannung 5V statt starke 3,3V)"
#define S10408	"(Ein graues Feld bedeutet: Offene Kollektoren im SPP-Modus, Push-Pull in allen anderen Modi)"
#define S10409	"(Energiesparmaßnahme)"
#define S10410	"(Invertierungen entfallen. Deshalb keine korrekte Parallelport-Simulation, für Zugriff mit DeviceIoControl.\nBei Rev.4 gibt es 20 statt 17 Ein/Ausgabeleitungen.\nRichtung einzeln schaltbar, für jedes Pin.)"
#define S10411	"Setzen && &Rücklesen"
#define S10412	"Kurzschluss&test (ohne Peripherie!)"
#define S10413	"Seriennummer"
#define S10414	"Firmware-Datum"

#define S10500	"Monitor"
#define S10501	"Daten&port (+0)"
#define S10502	"Lesen"
#define S10503	"&Statusport (+1)"
#define S10504	"S&teuerport (+2)"
#define S10506	"Byte ein&lesen"
#define S10507	"&Adresse"
#define S10508	"&Daten"
#define S10509	"Byte a&usgeben"
#define S10512	"FIFO voll"
#define S10513	"FIFO leer"
#define S10514	"Richtungsregister (USB2LPT-spezifisch)"

// STRINGTABLE
#define S16	"Möchten Sie wirklich diese nicht standardgemäße Portadresse verwenden?\n\nMit diesem Wert haben Sie die Lunte in der Hand, den Rechner ins Nirwana zu schicken!"
#define S17	"Die angegebene Portadresse ist keine gültige Hexadezimalzahl!"
#define S18	"Die Portadresse ist unzulässig: zu klein, zu groß oder nicht durch 4 teilbar!"
#define S19	"Bei nicht durch 8 teilbaren Portadressen ist keine EPP-Emulation möglich!"
#define S20	"Ungültige Angabe bei Zeitüberschreitung! (Darf nicht größer als 1000 ms sein.)"
#define S21	"Festlegung der emulierten Portadresse"
#define S22	"Die Portadresse muss mit der in Frage kommenden Anwendungssoftware in Übereinstimmung gebracht werden."
#define S23	"Die Firmware (Software im USB2LPT-Gerät) unterstützt das Feature-Register nicht!"
#define S24	"keine"	// Seriennummer
#define S25	"Direkt&hilfe"

#define S32	"Die Firmware konnte erfolgreich in den EEPROM geschrieben werden.\nGerät ab- und anstecken, um die neue Firmware zu starten."
#define S33	"Unklarer Fehler beim Schreiben der Firmware. Nicht abstecken und noch einmal versuchen. Das Gerät ist womöglich nicht mehr funktionstüchtig!"
#define S34	"Die Datei »%s« ist nicht als Firmware für dieses USB2LPT-Gerät bestimmt!"
#define S35	"Datum der aktuellen Firmware: %s\n\nDatum der zu brennenden Firmware: %s\n\nFortfahren?"
#define S36	"unbekannt"		// Firmware-Datum (frühe Ausgaben enthielten kein Datum)
#define S37	"Firmware\0*.iic"	// Filter für Datei-öffnen-Standarddialog
#define S38	"Einwandfreie Funktion."
#define S39	"Fehlfunktion entdeckt! Kurzschlusstest.EXE macht detaillierte Angaben."
#define S40	"Liegt an allen 17 Anschlüssen HIGH-Potenzial?"
#define S41	"Die Firmware der Low-Speed-USB2LPT mit ATmega-Controller kann hiermit nicht aktualisiert werden, aber es kann der Bootloader aktiviert werden, um anschließend mittels »bootloadHID.EXE« zu brennen.\n\nFortfahren?"

#define S48	"SPP (Nibble)\0Bidirektional\0AutoStrobe\0ECP\0EPP\0reserviert\0Test\0Konfiguration"
#define S49	"Extra-Bit\0reserviert\0Interruptanforderung\0Fehler\0eingeschaltet\0Papierende\0Bestätigung\0beschäftigt"
#define S50	"Strobe\0AutoFeed\0Rücksetzen\0Auswahl\0Interruptfreigabe\0Datenrichtung, 1 = Eingabe\0nicht vorhanden"
#define S51	"&Kommando\0&Adresse"		// Alternative Beschriftung für Wellenschalter (Radiobutton) 105/122
#define S52	"normal\0Nibble-Modus\0Byte-Modus\0ECP-Modus\0EPP-Modus"

// VERSIONINFO
#define I002	7,1
#define S003	"Eigenschaftsseiten-Lieferant"	// FileDescription
#define S005	"Freeware"			// LegalCopyright
#define S006	"h#s USB-zu-LPT-Konverter"	// ProductName
#define S007	"Kernmodus-Treiber"		// FileDescription für .SYS-Treiber

/* INF file strings (processed by makefile)
InstDisk="Treiberdiskette zu h#s USB-zu-LPT-Konverter"
DevDesc ="h#s USB-zu-LPT-Umsetzer"
SvcDesc ="h#s Treiber für USB-zu-LPT-Umsetzer (usb2lpt.sys)"
*/
