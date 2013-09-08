Program Wally;

Uses Memoria,RobotAdt;

Var M:TipoMat;
    Dim,T,InitX,InitY:Integer;
    Arrivo:RecArrivi;
    Passi:TipoMemoria;

Begin
 Writeln('PROGETTO DI PROGRAMMAZIONE 2003');
 InitRand;
 InizializzaGioco(M,InitX,InitY,Dim,T,Arrivo);
 AttivaMemoria(Passi);
 PreparaGiro(M,InitX,InitY,Dim,T,Arrivo,Passi);
 Stampa(Passi);
 Smemorizza(Passi);
 Readln;
End.