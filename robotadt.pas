(**************************************************************************)

Unit RobotAdt;

(**************************************************************************)

Interface

Uses Memoria;

Const DimMax=20;
      DimVett=5;
      Ricarica=20; {Indica il valore di ogni ricarica}
      TempoCarico=10; {Indica per quanti passi Wally dopo essersi caricato non lo far… pi—}

Type RecArrivi=Record
               X,Y,Distanza:Integer;
               NuovaDestinazione:Boolean;
               NuovaX,NuovaY,NuovaDistanza:Integer;
               End;

     TipoMat=Array[1..DimMax,1..DimMax] Of Char;
     TipoArrivi=Array[1..DimVett] Of RecArrivi;
     TipoVista=Array[1..5,1..5] Of Char;

(**************************************************************************)
Procedure InitRand;

Procedure InizializzaGioco(Var M:TipoMat;Var InitX,InitY,Dim,T:Integer;Var Arrivo:RecArrivi);

Procedure PreparaGiro(Var M:TipoMat;Var InitX,InitY:Integer;Dim,T:Integer;Var Arrivo:RecArrivi;Var Passi:TipoMemoria);
(**************************************************************************)

Implementation

Procedure InitRand; {Inizializza il generatore casuale}
Var Dep,I,RanSeed,Temp:Integer;
 Begin
  Randomize;
  Temp:=Random(10000); {Temp Š il seme}
  RanSeed:=Trunc(Temp);
  Temp:=Random(100);
  For I:=1 To Trunc(Temp) Do
   Dep:=Random(4);
 End;

Function Casuale:Integer; {Assume valori da 0 a 3}
Var Temp:Integer;
 Begin
  Temp:=Random(40000);
  Casuale:=abs(Trunc(Temp/10000));
 End;

Function CasualeDim(Dim:Integer):Integer; {Assume valori da 1 a Dim-2}
Var Temp:Integer;
 Begin
  Temp:=Random(40000);
  CasualeDim:=(Temp MOD Dim-1)+1;
 End;

Procedure InizializzaGioco(Var M:TipoMat;Var InitX,InitY,Dim,T:Integer;Var Arrivo:RecArrivi);
Var NumArrivi,I,J,TempX,TempY:Integer;
    Vett:TipoArrivi;
 Begin
  {Setta la dimensione della matrice}
  Write('Inserisci la dimensione dell''area di gioco (Min. 2-Max. ',DimMax-2,'):');
  Readln(Dim);
  Dim:=Dim+2; {Vanno considerate due dimensioni in pi—, usate per la cornice}
  {Crea la matrice}
  For I:=2 To Dim-1 Do
   Begin
    M[1,I]:=Chr(196);
    M[Dim,I]:=Chr(196);
    M[I,1]:=Chr(179);
    M[I,Dim]:=Chr(179);
    For J:=2 To Dim-1 Do
     Begin
      M[I,J]:=' '
     End
   End;
  M[1,1]:=Chr(218);
  M[Dim,1]:=Chr(192);
  M[1,Dim]:=Chr(191);
  M[Dim,Dim]:=Chr(217);
  {Setta la vita del robot}
  Write('Inserire l''autonomia di Wally:');
  Readln(T);
  {Setta le coordinate iniziali}
  Write('Inserisci la coordinata x (min. 1, max. ',Dim-2,') di partenza di Wally:');
  Readln(InitX);
  InitX:=InitX+1; {Viene incrementata di 1 perchŠ la prima riga Š occupata dalla cornice}
  Write('Inserisci la coordinata y (min. 1, max. ',Dim-2,') di partenza di Wally:');
  Readln(InitY);
  InitY:=InitY+1; {Viene incrementata di 1 perchŠ la prima colonna Š occupata dalla cornice}
  {Setta le coordinate degli arrivi e calcola il pi— vicino}
  Write('Quanti punti d''arrivo inserire (max. ',DimVett,')?: ');
  Readln(NumArrivi);
  If NumArrivi > 0 Then
   Begin
    For I:=1 To NumArrivi Do
     Begin
      Write('Inserisci la coord. x (min. 1, max. ',Dim-2,') della destinazione num. ',I,':');
      Readln(Vett[I].X);
      Vett[I].X := Vett[I].X + 1;
      Write('Inserisci la coord. y (min. 1, max. ',Dim-2,') della destinazione num. ',I,':');
      Readln(Vett[I].Y);
      Vett[I].Y := Vett[I].Y + 1;
      Vett[I].Distanza:=Abs(InitX-(Vett[I].X))+Abs(InitY-(Vett[I].Y));
      M[(Vett[I].X),(Vett[I].Y)]:='D';
     End;
    Arrivo:=Vett[1];
    For I:=2 To NumArrivi Do {Trova verso quale punto d'arrivo dirigersi (quello che si raggiunge col minor numero di passi)}
     Begin
      If (Arrivo.Distanza)>(Vett[I].Distanza) Then
       Arrivo:=Vett[I];
     End;
    Arrivo.NuovaDestinazione:=False;
    Arrivo.NuovaX:=MaxInt;
    Arrivo.NuovaY:=MaxInt;
    Arrivo.NuovaDistanza:=MaxInt;
   End
  Else
   Begin
    Arrivo.Distanza:=MaxInt;
    Arrivo.X:=MaxInt;
    Arrivo.Y:=MaxInt;
    Arrivo.NuovaDestinazione:=False;
    Arrivo.NuovaX:=MaxInt;
    Arrivo.NuovaY:=MaxInt;
    Arrivo.NuovaDistanza:=MaxInt;
   End;
   {Setta gli ostacoli}
   Write('Quanti ostacoli inserire?:');
   Readln(J);
   I:=1;
   While I<=J Do
   Begin
    TempX:=CasualeDim(Dim);
    TempY:=CasualeDim(Dim);
    If M[TempX,TempY]=' ' Then
     Begin
      I:=I+1;
      M[TempX,TempY]:='O';
     End;
   End;
   {Setta le ricariche}
   Write('Quanti ricariche inserire?:');
   Readln(J);
   I:=1;
   While I<=J Do
   Begin
    TempX:=CasualeDim(Dim);
    TempY:=CasualeDim(Dim);
    If M[TempX,TempY]=' ' Then
     Begin
      I:=I+1;
      M[TempX,TempY]:='R';
     End;
   End;
 End;

Procedure Visualizza(M:TipoMat;Dim:Integer);
Var I,J:Integer;
 Begin
  For I:=1 to Dim Do
   Begin
    For J:=1 to Dim Do
     Write(M[I,J]);
    Writeln;
   End;
  Writeln;
 End;

Function Consentita(Var M:TipoMat;InitX,InitY,Dim,Dir,Carico:Integer):Boolean;
Var StatoFunzione:Boolean;
 Begin
  StatoFunzione:=False;
  Case Dir Of {0=Nord;1=Est;2=Sud;3=Ovest}
   0:If InitX>2 Then StatoFunzione:=True;
   1:If InitY<(Dim-1) Then StatoFunzione:=True;
   2:If InitX<(Dim-1) Then StatoFunzione:=True;
   3:If InitY>2 Then StatoFunzione:=True;
  End; {Case}
  If StatoFunzione Then
   Begin
    Case Dir Of
     0:InitX:=InitX-1;
     1:InitY:=InitY+1;
     2:InitX:=InitX+1;
     3:InitY:=InitY-1;
    End; {Case}
    If (M[InitX,InitY]='O') Or ((M[InitX,InitY]='R') And (Carico>0)) Then
     StatoFunzione:=False;
   End;
  Consentita:=StatoFunzione;
 End;

Procedure MuoviIntelligente(InitX,InitY:Integer;Arrivo:RecArrivi;VAR Dir:Integer);
 Begin
  If Arrivo.NuovaDestinazione Then
   Begin
    Arrivo.X:=Arrivo.NuovaX;
    Arrivo.Y:=Arrivo.NuovaY;
   End;
  Repeat
   If (Casuale MOD 2) = 1 Then
    Begin
     If InitX<Arrivo.X Then Dir:=2
     Else
      Begin
       If InitX>Arrivo.X Then Dir:=0
       Else Dir:=4;
      End;
    End
   Else
    Begin
     If InitY<Arrivo.Y Then Dir:=1
     Else
      Begin
       If InitY>Arrivo.Y Then Dir:=3
       Else Dir:=4;
      End;
    End;
  Until (Dir in [0..3]);
 End;

Function Informazione(Carico:Integer;Visione:TipoVista):Char;
Var I,J:Integer;
    Ostacolo,Ricarica:Boolean;
 Begin
  Ostacolo:=False;
  Ricarica:=False;
  For I:=1 To 5 Do
   For J:=1 To 5 Do
    Begin
     If Carico>0 Then
      Begin
       Case Visione[I,J] Of
        'O':Ostacolo:=True;
        'R':Ostacolo:=True;
       End (*Case*)
      End
     Else
      Begin
       Case Visione[I,J] Of
        'O':Ostacolo:=True;
        'R':Ricarica:=True;
       End (*Case*)
      End
    End;
  If Ostacolo And Ricarica Then
   Informazione:='Z' {Ci sono sia ostacoli che ricariche}
  Else
   Begin
    If Ostacolo Then
     Informazione:='O'
    Else
     Begin
      If Ricarica Then
       Informazione:='R'
      Else
       Informazione:='N'
     End
   End
 End;

Procedure Muovi(Var M:TipoMat;Var InitX,InitY:Integer;Dir:Integer;Var T,Carico:Integer);
 Begin
  Case Dir Of
   0:InitX:=InitX-1;
   1:InitY:=InitY+1;
   2:InitX:=InitX+1;
   3:InitY:=InitY-1;
  End; {Case}
  If (M[InitX,InitY]='R') And (Carico<=0) Then
   Begin
    T:=T+Ricarica;
    Carico:=TempoCarico;
   End;
  If Carico>0 Then
   Writeln('Wally potr… ricaricarsi di nuovo tra ',Carico,' passi');
 End;

Procedure CalcolaDistanza(InitX,InitY:Integer;Var Arrivo:RecArrivi);
 Begin
  If Arrivo.NuovaDestinazione Then
   Arrivo.NuovaDistanza:=Abs(InitX-(Arrivo.NuovaX))+Abs(InitY-(Arrivo.NuovaY))
  Else
   Begin
    If Arrivo.Distanza<>MaxInt Then
     Arrivo.Distanza:=Abs(InitX-(Arrivo.X))+Abs(InitY-(Arrivo.Y))
    Else
     Arrivo.Distanza:=MaxInt;
   End;
 End;

Function ObiettivoRaggiunto(Arrivo:RecArrivi;InitX,InitY:Integer):Boolean;
 Begin
  If Arrivo.NuovaDestinazione Then
   Begin
    ObiettivoRaggiunto:=((Arrivo.NuovaX=InitX)And(Arrivo.NuovaY=InitY))
   End
  Else
   ObiettivoRaggiunto:=False
 End;

Procedure ScansaOstacolo(InitX,InitY:Integer;Var Arrivo:RecArrivi;Var Dir:Integer;Visione:TipoVista;Passi:TipoMemoria);
Var StoriaX,StoriaY,I,X,Y:Integer;
    Necessario,SfruttaMemoria:Boolean;
 Begin
  MuoviIntelligente(InitX,InitY,Arrivo,Dir);
  SfruttaMemoria:=False;
  Necessario:=False;
  X:=MaxInt;
  Y:=MaxInt;
  Case Dir Of
   0:If Visione[2,3]='O' Then Necessario:=True;
   1:If Visione[3,4]='O' Then Necessario:=True;
   2:If Visione[4,3]='O' Then Necessario:=True;
   3:If Visione[3,2]='O' Then Necessario:=True;
  End; (*case*)
  If Necessario Then
   Begin
    Case Dir Of
     0:Begin
        If (Visione[3,2]=' ') And (Visione[2,2]=' ') Then
         Begin
          X:=2;
          Y:=2;
         End
        Else
         Begin
          If (Visione[3,4]=' ') And (Visione[2,4]=' ') Then
           Begin
            X:=2;
            Y:=4;
           End
          Else
           SfruttaMemoria:=True;
         End
       End;
     1:Begin
        If (Visione[2,3]=' ') And (Visione[2,4]=' ') Then
         Begin
          X:=2;
          Y:=4;
         End
        Else
         Begin
          If (Visione[4,3]=' ') And (Visione[4,4]=' ') Then
           Begin
            X:=4;
            Y:=4;
           End
          Else
           SfruttaMemoria:=True;
         End
       End;
     2:Begin
        If (Visione[3,4]=' ') And (Visione[4,4]=' ') Then
         Begin
          X:=4;
          Y:=4;
         End
        Else
         Begin
          If (Visione[3,2]=' ') And (Visione[4,2]=' ') Then
           Begin
            X:=4;
            Y:=2;
           End
          Else
           SfruttaMemoria:=True;
         End
       End;
     3:Begin
        If (Visione[4,3]=' ') And (Visione[4,2]=' ') Then
         Begin
          X:=4;
          Y:=2;
         End
        Else
         Begin
          If (Visione[2,3]=' ') And (Visione[2,2]=' ') Then
           Begin
            X:=2;
            Y:=2;
           End
          Else
           SfruttaMemoria:=True;
         End
       End;
    End; (*case*)
    If SfruttaMemoria Then
     Begin
      For I:=1 To 5 Do
       Begin
        Storia(Passi,I,StoriaX,StoriaY);
        IF StoriaX=MaxInt Then
         Begin
          X:=StoriaX;
          Y:=StoriaY;
         End
       End
     End;
    If X<>MaxInt Then
     Begin
      Arrivo.NuovaDestinazione:=True;
      Case X Of
       1:Arrivo.NuovaX:=InitX-2;
       2:Arrivo.NuovaX:=InitX-1;
       3:Arrivo.NuovaX:=InitX;
       4:Arrivo.NuovaX:=InitX+1;
       5:Arrivo.NuovaX:=InitX+2;
      end; (*case*)
      Case Y Of
       1:Arrivo.NuovaY:=InitY-2;
       2:Arrivo.NuovaY:=InitY-1;
       3:Arrivo.NuovaY:=InitY;
       4:Arrivo.NuovaY:=InitY+1;
       5:Arrivo.NuovaY:=InitY+2;
      end; (*case*)
     end;
   End;
  MuoviIntelligente(InitX,InitY,Arrivo,Dir);
 End;

Procedure MangiaRicarica(InitX,InitY:Integer;Var Arrivo:RecArrivi;Var Dir:Integer;Visione:TipoVista;Passi:TipoMemoria);
Var I,J,X,Y:Integer;
    Recuperabile,AttenzioneOstacoli:Boolean;
 Begin
  Recuperabile:=True;
  AttenzioneOstacoli:=False;
  For I:=1 To 5 Do
   For J:=1 To 5 Do
    Begin
     If Visione[I,J]='R' Then
      Begin
       X:=I;
       Y:=J;
      End;
     If (Visione[I,J]='O') Then
      AttenzioneOstacoli:=True;
    End;
  If AttenzioneOstacoli Then
   Begin
    If (Visione[2,3]='R') Then
     Begin
      X:=2;
      Y:=3;
     End
    Else
     Begin
      If (Visione[3,4]='R') Then
       Begin
        X:=3;
        Y:=4;
       End
      Else
       Begin
        If (Visione[4,3]='R') Then
         Begin
          X:=4;
          Y:=3;
         End
        Else
         Begin
          If (Visione[3,2]='R') Then
           Begin
            X:=3;
            Y:=2;
           End
          Else
           Begin
            Recuperabile:=False;
           End
         End
       End
     End
   End;
  If Recuperabile Then
   Begin
    Arrivo.NuovaDestinazione:=True;
    Case X Of
     1:Arrivo.NuovaX:=InitX-2;
     2:Arrivo.NuovaX:=InitX-1;
     3:Arrivo.NuovaX:=InitX;
     4:Arrivo.NuovaX:=InitX+1;
     5:Arrivo.NuovaX:=InitX+2;
    end; (*case*)
    Case Y Of
     1:Arrivo.NuovaY:=InitY-2;
     2:Arrivo.NuovaY:=InitY-1;
     3:Arrivo.NuovaY:=InitY;
     4:Arrivo.NuovaY:=InitY+1;
     5:Arrivo.NuovaY:=InitY+2;
    end; (*case*)
    MuoviIntelligente(InitX,InitY,Arrivo,Dir);
   End
  Else
   Begin
    ScansaOstacolo(InitX,InitY,Arrivo,Dir,Visione,Passi);
   End
 End;

Procedure TrovaDir(Var M:TipoMat;T,InitX,InitY,Dim,Carico:Integer;Var Arrivo:RecArrivi;Var Dir:Integer;
                   Visione:TipoVista;Passi:TipoMemoria);
Var Conto:Integer;
    Veduto:Char;
 Begin
  If Arrivo.NuovaDestinazione Then
   Begin
    Conto:=1;
    Repeat
     Conto:=Conto+1;
     If Conto>10 Then
      Begin
       Dir:=Casuale
      End
     Else
      Begin
       MuoviIntelligente(InitX,InitY,Arrivo,Dir);
      End;
    Until Consentita(M,InitX,InitY,Dim,Dir,Carico) Or (Conto>30);
   End
  Else
   Begin
    Conto:=1;
    Repeat
     Conto:=Conto+1;
     If Conto>10 Then
      Begin
       Dir:=Casuale
      End
     Else
      Begin
       If Arrivo.Distanza>T Then
        Begin
         If (Informazione(Carico,Visione)='R') Or (Informazione(Carico,Visione)='Z') Then
          MangiaRicarica(InitX,InitY,Arrivo,Dir,Visione,Passi)
         Else
          Begin
           Dir:=Casuale;
          End
        End
       Else
        Begin
         MuoviIntelligente(InitX,InitY,Arrivo,Dir);
         Veduto := Informazione(Carico,Visione);
         Case Veduto Of
          'O':ScansaOstacolo(InitX,InitY,Arrivo,Dir,Visione,Passi);
          'R':MangiaRicarica(InitX,InitY,Arrivo,Dir,Visione,Passi);
          'Z':MangiaRicarica(InitX,InitY,Arrivo,Dir,Visione,Passi);
         End; (*case*)
        End;
      End;
    Until Consentita(M,InitX,InitY,Dim,Dir,Carico) Or (Conto>30);
   End;
   {Conto indica il numero di tentativi per trovare la direzione}

  If Conto>30 Then
   Begin
    Writeln('Impossibile Muoversi!!!');
    Stampa(Passi);
    Readln;
    Smemorizza(Passi);
    Halt;
   End;
 End;

Procedure Vista(Var M:TipoMat;Dim,InitX,InitY:Integer;Var Visione:TipoVista);
Var I,J:Integer;
 Begin
  For I:=1 To 5 Do
   Begin
    For J:=1 To 5 Do
     Begin
      If ((InitX+(I-3)) In [2..Dim-1]) And ((InitY+(J-3)) In [2..Dim-1]) Then
       Visione[I,J]:=M[(InitX+(I-3)),(InitY+(J-3))]
      Else
       Visione[I,J]:='-';
     End;
   End;
 End;

Procedure Giro(Var M:TipoMat;Var Visione:TipoVista;Var InitX,InitY:Integer;
               Dim,T:Integer;Var Arrivo:RecArrivi;Var Carico:Integer;Var Passi:TipoMemoria);
Var I,J,Dir:Integer;
 Begin
  If M[InitX,InitY]<>'D' Then
   Begin
    Vista(M,Dim,InitX,InitY,Visione);
    If M[InitX,InitY]='P' Then
     Memorizza(Passi,InitX,InitY,'P')
    Else
     Memorizza(Passi,InitX,InitY,Informazione(Carico,Visione));
    M[InitX,InitY]:=Chr(2);
    Writeln('Vita di Wally >> ',T);
    Visualizza(M,Dim);
    Readln;
    If T>0 Then
     Begin
      TrovaDir(M,T,InitX,InitY,Dim,Carico,Arrivo,Dir,Visione,Passi);
      M[InitX,InitY]:=' ';
      Muovi(M,InitX,InitY,Dir,T,Carico);
      If ObiettivoRaggiunto(Arrivo,InitX,InitY) Then
       Begin
        Arrivo.NuovaDestinazione:=False;
        Arrivo.NuovaX:=MaxInt;
        Arrivo.NuovaY:=MaxInt;
        Arrivo.NuovaDistanza:=MaxInt;
       End;
      CalcolaDistanza(InitX,InitY,Arrivo);
      If Carico>0 Then Carico:=Carico-1;
      Giro(M,Visione,InitX,InitY,Dim,T-1,Arrivo,Carico,Passi);
     End;
   End
  Else
   Begin
    Memorizza(Passi,InitX,InitY,'D');
    Writeln('Sei Arrivato Al Punto Di Uscita!!!');
    M[InitX,InitY]:=Chr(2);
    Visualizza(M,Dim);
    Readln;
   End;
 End;

Procedure PreparaGiro(Var M:TipoMat;Var InitX,InitY:Integer;Dim,T:Integer;Var Arrivo:RecArrivi;Var Passi:TipoMemoria);
Var Carico:Integer;
    Visione:TipoVista;
 Begin
  M[InitX,InitY]:='P';
  Carico:=0;
  Giro(M,Visione,InitX,InitY,Dim,T,Arrivo,Carico,Passi);
 End;

{Main}
Begin
End.