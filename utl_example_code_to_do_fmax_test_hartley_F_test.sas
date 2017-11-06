Example code to do Fmax test (Hartley's F test)

  Hartley's F test for homogeniety of variance
  FMaxRatio is simply max(variance)/min(variance)

   H0: sigama(control)=sigma(treatment 1)=sigma(treatment 2)   (variances are equal)
   HA: Variances are not equal

  INPUT
  =====
      CONTROL     TREAT 1    TREAT 2
      =======     =======    ========
     CTRL 4.17   TRT1 4.81  TRT2 6.31
     CTRL 5.58   TRT1 4.17  TRT2 5.12
     CTRL 5.18   TRT1 4.41  TRT2 5.54
     CTRL 6.11   TRT1 3.59  TRT2 5.50
     CTRL 4.50   TRT1 5.87  TRT2 5.37
     CTRL 4.61   TRT1 3.83  TRT2 5.29
     CTRL 5.17   TRT1 6.03  TRT2 4.92
     CTRL 4.53   TRT1 4.89  TRT2 6.15
     CTRL 5.33   TRT1 4.32  TRT2 5.80
     CTRL 5.14   TRT1 4.69  TRT2 5.26

   WORKING CODE
   ============
   SAS/IML/R or WPS/Proc R

     res<-aggregate(weight ~ group, data = PlantGrowth, var);
     max(res$weight)/min(res$weight);
     qmaxFratio(0.05,9,3, lower.tail=FALSE);  * FRatio table;

   OUTPUT
   ======
    Since Fmax statistic is < critical 5% (not in tail) then we fail to reject the null.

    WANT total obs=1
                         CRITICAL_
     Obs    STATISTIC       5PCT

      1      3.21600      5.33847

see
https://goo.gl/ez1Wji
https://communities.sas.com/t5/SAS-Statistical-Procedures/Example-code-to-do-Fmax-test-Hartley-s-F-test/m-p/410633

see
https://cran.r-project.org/web/packages/SuppDists/SuppDists.pdf

*                _               _       _
 _ __ ___   __ _| | _____     __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \   / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/  | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|   \__,_|\__,_|\__\__,_|

;

data have;
 input GROUP$ WEIGHT;
cards4;
 CTRL 4.17
 CTRL 5.58
 CTRL 5.18
 CTRL 6.11
 CTRL 4.50
 CTRL 4.61
 CTRL 5.17
 CTRL 4.53
 CTRL 5.33
 CTRL 5.14
 TRT1 4.81
 TRT1 4.17
 TRT1 4.41
 TRT1 3.59
 TRT1 5.87
 TRT1 3.83
 TRT1 6.03
 TRT1 4.89
 TRT1 4.32
 TRT1 4.69
 TRT2 6.31
 TRT2 5.12
 TRT2 5.54
 TRT2 5.50
 TRT2 5.37
 TRT2 5.29
 TRT2 4.92
 TRT2 6.15
 TRT2 5.80
 TRT2 5.26
;;;;
run;quit;


*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

%utl_submit_wps64('
libname sd1 sas7bdat "d:/sd1";
options set=R_HOME "C:/Program Files/R/R-3.3.2";
libname wrk sas7bdat "%sysfunc(pathname(work))";
proc r;
submit;
source("c:/Program Files/R/R-3.3.2/etc/Rprofile.site",echo=T);
library(dplyr);
library(SuppDists);
head(PlantGrowth);
summary(PlantGrowth);
res<-aggregate(weight ~ group, data = PlantGrowth, var);
want<-as.data.frame(t(c(max(res$weight)/min(res$weight),qmaxFratio(0.05,9,3, lower.tail=FALSE))));
colnames(want)<-c("statistic","critical_5pct");
want;
endsubmit;
import r=want data=wrk.want;
run;quit;
');

