%include "/workspaces/volume/00_setup.sas";

/*Ile jest brakow? (Y_NEWDEPOSIT, AGE)*/
title "Braki danych";
proc means data=proj.dane n nmiss mean;
  var y_newdeposit age;
run;
proc freq data=proj.dane;
  tables R_Y;
run;

/*Braki a cechy skokowe: test chi-kwadrat i V Cramera*/
title "Brak Y a cechy skokowe";
proc freq data=proj.dane;
  tables (contact education poutcome house_loan) * R_Y / chisq nocol nopercent;
run;

/*Braki a wiek (cecha ciagla): test t*/
title "AGE wg wskaznika braku";
proc ttest data=proj.dane;
  class R_Y;
  var age;
run;

/*Model logitowy: P(brak Y) w zaleznosci od wszystkich cech*/
title "Model logitowy dla wskaznika braku R_Y";
proc logistic data=proj.dane plots(only)=roc;
  class contact(ref='0') house_loan(ref='yes') poutcome(ref='unknown')
        education(ref='unknown') / param=ref;
  model R_Y(event='1') = contact age house_loan poutcome education;
run;

title;

ods pdf close;