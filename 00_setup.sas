/* === PLIK KONFIGURACYJNY (grupa B3) === */
/* ZMIEN TYLKO TA SCIEZKE: folder, w ktorym lezy b3.csv */
%let path = /workspaces/volume;
libname proj "&path";

%let seed = 20261125;

/* import CSV -> zbior SAS (robi sie przy kazdym uruchomieniu) */
proc import datafile="&path/b3.csv" out=proj.b3 dbms=csv replace;
  guessingrows=max;
run;

data proj.dane;
  set proj.b3;                       /* grupa B3 */
  R_Y = missing(y_newdeposit);       /* 1 = brak zmiennej celu */
run;

/* Wydruk wynikow (wymog c) */
ods pdf file="&path/wydruk_wynikow.pdf";