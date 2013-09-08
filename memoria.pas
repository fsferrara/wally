(**************************************************************************)

UNIT Memoria;

(**************************************************************************)

INTERFACE

         CONST
              LungMemoria = 10; (*Numero elementi della memoria*)

         TYPE
             TipoElementoMemoria = RECORD
                      X,Y          : INTEGER;
                      Informazioni : CHAR
             end;     (*record*)

             Pnodo = ^TipoNodo;

             TipoNodo = RECORD
                      elem : TipoElementoMemoria;
                      next : Pnodo
             end;     (*record*)

             TipoMemoria = RECORD
                      nroelem    : INTEGER;
                      testa,fine : Pnodo
             end;    (*record*)

(**************************************************************************)

PROCEDURE AttivaMemoria(VAR Passi:TipoMemoria);
          (*OUT: attiva la memoria, adesso puoi usarla!*)

PROCEDURE Memorizza(VAR Passi:TipoMemoria;InitX,InitY:INTEGER;Info:CHAR);
          (*OUT: elemento memorizzato*)

PROCEDURE Smemorizza(VAR Passi:TipoMemoria);
          (*OUT: smemorizza tutta la memoria, e restituisce alla HEAP tutto
          ci• che gli spetta. Questo comando deve essere quindi eseguito
          per disattivare la memoria*)

PROCEDURE Stampa(VAR Passi:TipoMemoria);
          (*OUT: stampa gli ultimi LungMemoria elementi memorizzati*)

PROCEDURE Storia(Passi:TipoMemoria;N:Integer;StoriaX,StoriaY:INTEGER);
          (*OUT: ultima coordinata x registrata in StoriaX,
          da MaxInt se non esiste! Ultima coordinata y registrata
          in StoriaY, da MaxInt se non esiste*)

(**************************************************************************)
IMPLEMENTATION


PROCEDURE Scoda(VAR Passi:TipoMemoria);            (*OUT: scoda un elemento*)
VAR
   Temp:Pnodo;

BEGIN
     Temp := Passi.Testa;
     IF Temp <> NIL THEN
         WITH Passi DO
              Begin
                   Testa := Temp^.next;
                   IF Testa = NIL THEN Fine := NIL;
                   dispose(temp);
                   NroElem := NroElem-1
              End
END;


PROCEDURE AttivaMemoria(VAR Passi:TipoMemoria);         (*OUT: coda vuota*)
BEGIN
     WITH Passi DO
     Begin
          NroElem := 0;
          testa   := NIL;
          fine    := NIL
     End
END;


PROCEDURE Memorizza(VAR Passi:TipoMemoria;InitX,InitY:INTEGER;Info:CHAR);   (*OUT: elemento accodato*)
VAR
   x:TipoElementoMemoria;
   Temp:Pnodo;

BEGIN
     IF LungMemoria = Passi.NroElem THEN Scoda(Passi);

     new(temp);
     temp^.elem.X := InitX;
     temp^.elem.Y := InitY;
     temp^.elem.Informazioni := Info;
     temp^.next := NIL;

     WITH Passi DO
     Begin
          IF Testa = NIL THEN
              Testa := Temp
          ELSE
              Fine^.next := Temp;
          Fine := Temp;
          NroElem := NroElem +1
     End
END;


PROCEDURE Smemorizza(VAR Passi:TipoMemoria);
VAR
   I:INTEGER;
BEGIN
     WHILE Passi.testa <> NIL DO (*se la memoria non Š vuota esegue l'iterazione*)
     BEGIN
          Scoda(Passi)
     END
END;


PROCEDURE Stampa(VAR Passi:TipoMemoria);
VAR
   I:INTEGER;
   Temp:Pnodo;
BEGIN
     Temp := Passi.Testa;
     IF Passi.testa = NIL THEN
         Writeln('La memoria Š Vuota!!!')
     ELSE
         Begin
              I := 0;
              WHILE Temp <> NIL DO
                    Begin
                         I := I+1;

                         Write(I,') Coordinate X=',(Temp^.elem.X-1),' Y=',(Temp^.elem.Y-1));
                         Write('  -  Info: ');

                         CASE Temp^.elem.Informazioni OF
                              'N':Writeln('zona libera');
                              'O':Writeln('ostacolo');
                              'R':Writeln('ricarica');
                              'P':Writeln('punto di partenza');
                              'D':Writeln('punto di arrivo **');
                              'Z':Writeln('ostacolo e ricarica');
                         end; (*case*)

                         Temp := Temp^.Next
                    End
         End
END;


PROCEDURE Storia(Passi:TipoMemoria;N:Integer;StoriaX,StoriaY:INTEGER);
VAR
   Puntatore:Pnodo;
   I:INTEGER;
BEGIN
     Puntatore:=Passi.Testa;
     FOR I:=1 TO (Passi.NroElem-N) DO
      Puntatore := Puntatore^.Next;

     IF Puntatore<>NIL THEN
         Begin
              StoriaX := Puntatore^.elem.X;
              StoriaY := Puntatore^.elem.Y
         End
     ELSE
         Begin
              StoriaX := MaxInt;
              StoriaY := MaxInt
         End
END;


BEGIN                                                   (*MAIN UNIT*)
END.                                                    (*MAIN UNIT*)