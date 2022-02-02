program TalentProbe (input, output);
{Eine DSA Talentprobe wird automatisiert.}

{Version:   1.1
Builder:    postboote}
    
    const
    LEER2 = '  ';
    LEER4 = '    ';
    LEER6 = '      ';
    LEER8 = '        ';
    ANZAHL = 32500;

    type
    tDice = 0..20;
    tIndex = 1..maxint;
    tFeldProbe = array [tindex] of  record
                                        soll : shortint;
                                        ist : shortint;
                                        kosten : shortint;
                                        bestanden : boolean;
                                    end;
    tFeldQuali = array [1..6] of   integer;
    tFeldKrit = array [1..3] of integer;
    tFeldNegative = array [1..3] of integer;

    var
    Probe       : tFeldProbe;
    Qualitaet : tFeldQuali;
    FeldKritische : tFeldKrit;
    FeldNegative : tFeldNegative;
    i,
    j          : tIndex;
    Modifikator,
    TalentpunkteSave,
    Talentpunkte,
    BegabungSave,
    BegabungAnzahl,
    AnzahlKritBestanden,
    AnzahlKritBestandenGesammt,
    AnzahlKritMisserfolg,
    AnzahlKritMisserfolgGesammt,
    AnzahlErfolge,
    AnzahlMisserfolge : integer;
    HilfDice : tDice;
    Erfolg : boolean;
    Rechenhelf1,
    Rechenhelf2,
    Rechenhelf3 : real;

{----------}

    procedure InitialisiereFeld (var ioProbe : tFeldProbe);
    {Probe wird initialisiert}
    begin
        Probe[i].soll := 0;
        Probe[i].ist := 0;
        Probe[i].kosten := 0;
        Probe[i].bestanden := false;
    end; {Initialisieren}

{----------}

    procedure SollFestlegen    (var ioProbe : tFeldProbe;
                                inModifikator : integer);
    {Der Sollwert wird festgelegt, dieser Wert muss unterboten werden um die Probe zu bestehen.}
    begin
        write ('Geben Sie Attributswert ', i, ' ein: ');
        readln (Probe[i].soll);
        Probe[i].soll := (1+ Probe[i].soll + inModifikator);
    end; {Attributswerte}

{----------}

    procedure ProbeWuerfeln (var ioProbe : tFeldProbe);
    {Ist-Wert wird festgelegt und mit Soll Wert verglichen. wenn ist < soll --> bestanden := true}
    begin
        Probe[i].ist := (1 + random(20));
        if Probe[i].ist > Probe[i].soll then
            Probe[i].kosten := (Probe[i].ist - Probe[i].soll)
        else
            Probe[i].bestanden := true;
    end; {ProbeWuerfeln}

{----------}

    procedure Ausgleichen (var ioProbe : tFeldProbe);
    {Bei nicht bestanden wird versucht auszugleichen}
    begin
        {Ein Wuerfel wird durch Begabung neu gerollt}
        while (BegabungAnzahl > 0) and (not Probe[i].bestanden) do
        begin
            HilfDice := 1 + random (20);
            if Probe[i].ist > HilfDice then
            begin
                Probe[i].ist := HilfDice;
                if Probe[i].ist < Probe[i].soll then
                    Probe[i].bestanden := true;
            end; {if Probe < Hilfdice}
            BegabungAnzahl := BegabungAnzahl - 1;
        end; {if BegabungAnzahl}

        {Wenn noch immer nicht bestanden}
        if (Talentpunkte > Probe[i].kosten) and not Probe[i].bestanden and (Probe[i].ist <> 20) then
        begin
            Talentpunkte := Talentpunkte - Probe[i].kosten;
            Probe[i].ist := Probe[i].ist - Probe[i].kosten;
            Probe[i].kosten := 0;
            Probe[i].bestanden := true;
        end;
    end; {Ausgleichen}

{----------}

    procedure Kritische (inProbe : tFeldProbe);
    {Es wird nach Kritischen Erfolgen und Misserfolgen gesucht}
    begin          
        if Probe[i].ist = 1 then
        begin
            HilfDice := (1 + random (20));
            if HilfDice < Probe[i].soll then
            begin
                AnzahlKritBestanden := AnzahlKritBestanden +1;
                AnzahlKritBestandenGesammt := AnzahlKritBestandenGesammt +1;
            end;
        end
        else
            if Probe[i].ist = 20 then
            begin
                HilfDice := (1 + random (20));
                if HilfDice > Probe[i].soll then
                begin
                    AnzahlKritMisserfolg := AnzahlKritMisserfolg + 1;
                    AnzahlKritMisserfolgGesammt := AnzahlKritMisserfolgGesammt + 1;
                end;
            end;
    end; {Kritische}

{----------}

    procedure ErfolgAbfragen (inProbe : tFeldProbe);
    {Wenn alle 3 Attributsproben Bestanden sind ist die gesammte Probe bestanden}
    begin
        if Probe[1].bestanden and Probe[2].bestanden and Probe[3].bestanden then
            Erfolg := true;

        if Erfolg then
        begin
            AnzahlErfolge := AnzahlErfolge + 1;
            {Die Qualitaet wird ueberprueft}
            if (Talentpunkte < 4) then
            begin
                Qualitaet[1] := Qualitaet[1] + 1;
                write ('Erfolg! Qualitaetsstufe 1!');
            end;

            if (Talentpunkte < 7) and (Talentpunkte > 3) then
            begin
                Qualitaet[2] := Qualitaet[2] + 1;
                write ('Erfolg! Qualitaetsstufe 2!');
            end;

            if (Talentpunkte < 10) and (Talentpunkte > 6) then
            begin
                Qualitaet[3] := Qualitaet[3] + 1;
                write ('Erfolg! Qualitaetsstufe 3!');
            end;

            if (Talentpunkte < 13) and (Talentpunkte > 9) then
            begin
                Qualitaet[4] := Qualitaet[4] + 1;
                write ('Erfolg! Qualitaetsstufe 4!');
            end;

            if (Talentpunkte < 16) and (Talentpunkte > 12) then
            begin
                Qualitaet[5] := Qualitaet[5] + 1;
                write ('Erfolg! Qualitaetsstufe 5!');
            end;

            if (Talentpunkte > 15) then
            begin
                Qualitaet[6] := Qualitaet[6] + 1;
                write ('Erfolg! Qualitaetsstufe 6!');
            end;

            {Die Anzahl der Kritischen Erfolge (gesammt) wird bestimmt}
            if AnzahlKritBestanden > 0 then
            begin
                write (AnzahlKritBestanden:10, ' Kritische Erfolg(e)');
                if AnzahlKritBestanden = 1 then
                    FeldKritische[1] := FeldKritische[1] + 1;
                if AnzahlKritBestanden = 2 then
                    FeldKritische[2] := FeldKritische[2] + 1;
                if AnzahlKritBestanden = 3 then
                    FeldKritische[3] := FeldKritische[3] + 1;
            end;                
            writeln ();
        end; {if unterteil}

        if not (Probe[1].bestanden and Probe[2].bestanden and Probe[3].bestanden) then
        begin
            AnzahlMisserfolge := AnzahlMisserfolge +1;
            if AnzahlKritMisserfolg = 0 then
                writeln ('Fehlschlag!')
            else
            begin
                write ('Kritischer Fehlschlag!');
                writeln (AnzahlKritMisserfolg:14, ' Kritische Fehlschlaege');
                if AnzahlKritMisserfolg = 1 then
                    FeldNegative[1] := FeldNegative[1] + 1;
                if AnzahlKritMisserfolg = 2 then
                    FeldNegative[2] := FeldNegative[2] + 1;
                if AnzahlKritMisserfolg = 3 then
                    FeldNegative[3] := FeldNegative[3] + 1;
            end;
        end;
    end; {ErfolgAbfragen}

{----------------------------------------------------------------------------------}

begin
    randomize;
    {Modifikator wird festgelegt}
    writeln ('Geben Sie einen Schwirigkeitsmodifikator ein.');
    writeln (LEER4, '0 = Keine Veraenderung');
    writeln (LEER4, 'Negative Zahl = Erschwert');
    writeln (LEER4, 'Positive Zahl = Erleichtert');
    write (LEER4);
    readln (Modifikator);
    writeln ();

    {Talentpunkte werden festgelegt}
    write ('Geben Sie die Anzahl der Talentpunkte an:', LEER4);
    readln (TalentpunkteSave);

    {Begagung wird erfragt}
    write ('Wie viele Wuerfel duerfen durch Begabungen neu gerollt werden? (0 - 3)', LEER4);
    readln (BegabungSave);

    {Werte werden Initialisiert.
    Zuerst auf 0 / false, dann auf die Eingegebenen Werte.}
    for i := 1 to 3 do
    begin
        InitialisiereFeld (Probe);
        SollFestlegen (Probe, Modifikator);
    end;

    {Die oben festgelegte ANZAHL an Wuerfeldurchgaengen wird durchgefuehrt.}
    for j := 1 to ANZAHL do
    begin
        Erfolg := false;
        Talentpunkte := TalentpunkteSave;
        BegabungAnzahl := BegabungSave;
        AnzahlKritBestanden := 0;
        AnzahlKritMisserfolg := 0;

        write ('# ', j, ': ');
        {Die 3 Attributwerte werden jeweils einzeln durchlaufen}
        for i := 1 to 3 do
        begin
            Probe[i].bestanden := false;
            ProbeWuerfeln(Probe);
            Ausgleichen (Probe);
            Kritische (Probe);
        end;

        Erfolgabfragen (Probe);

    end; {for j -> ANZAHL}

    AnzahlKritBestanden := AnzahlKritBestandenGesammt;
    {Abschliessende Ausgabe}
    writeln ();
    writeln ();
    writeln ('--------------------------------------------------');
    writeln ('--------------------------------------------------');
    writeln ();
    writeln (LEER4, ANZAHL:5, ' Durchgefuehrte Proben');

    {Erfolge}
    Rechenhelf1 := ((AnzahlErfolge / ANZAHL) * 100);
    write (LEER4, AnzahlErfolge:5, ' Erfolge');
    writeln (LEER4, LEER4, LEER4, LEER4, LEER2, ' (', Rechenhelf1:3:2, '%)');
    writeln (LEER4, LEER4, AnzahlKritBestandenGesammt:5, ' Kritische Teilerfolge (Bestaetigt)');
    for i := 1 to 3 do
    begin
        Rechenhelf1 := (FeldKritische[i] / Anzahl)*100;
        write (LEER8, i:7, 'x Krit:', FeldKritische[i]:6);
        writeln (LEER8, '(', Rechenhelf1:3:2, '%)');
        AnzahlKritBestanden := AnzahlKritBestanden - (FeldKritische[i]*i); {Berechnet fehlgeschlagene Kritische (durch insgesammt nicht geschaffte Probe)}

    end;
    writeln ();

    {Qualitaetsstufen werden ausgegeben}
    for i := 1 to 6 do
    begin
        Rechenhelf1 := ((Qualitaet[i] / Anzahl)*100);
        writeln (LEER8, Qualitaet[i]:5, ' Qualitaetsstufe ', i, LEER4, ' (', Rechenhelf1:3:2, '%)'); {Kommastellen}
    end;
    writeln (LEER8, LEER6, 'Kritische Erfolge beeinflussen aktuell die Qualitaetsstufe nicht!');

    {Misserfolge}
    Rechenhelf1 := AnzahlKritBestanden; {Sind jetzt Kritische Treffer, welche durch Fehlschlag unwirksam sind, ueberbleibsel von oben}
    writeln ();
    writeln (LEER4, AnzahlMisserfolge:5, ' Misserfolge');
    write (LEER8, AnzahlKritBestanden:5,  ' durch Fehlschlag unwirksame Krits');
    writeln (LEER4,' (', ((Rechenhelf1 / ANZAHL)*100):3:2, '%)');
    writeln (LEER4, LEER4, AnzahlKritMisserfolgGesammt:5,' Kritische Misserfolge');
    for i := 1 to 3 do
    begin
        Rechenhelf1 := FeldNegative[i];
        write (LEER8, i:7, 'x Krit:', FeldNegative[i]:6);
        writeln (LEER8, '(', ((Rechenhelf1 / ANZAHL)*100):3:2, '%)');
    end;
    writeln ();
    writeln ('--------------------------------------------------');
    writeln ('--------------------------------------------------');
    readln ();

end.