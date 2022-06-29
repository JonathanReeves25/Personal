C     Calculates thrust from equations provided by Mr. Calvin
      PROGRAM THRUST
      REAL :: MA, MDOTA, MDOTF, MDOT, MU
      LOGICAL :: AFT
      CHARACTER :: AFTER

      WRITE(*,1)"INDICATE MACH, ALT(FT), AND AFTERBURNER(T/F)"
      READ(*,*)MA, ALT, AFTER
      WRITE(*,*)

      DATA BETA, T04, T06, AI, RA /0.3,2250,3300,4.28,1716/
      DATA TA,PA,MA,GAM,CP /504,1862,0,1.4,0.24/
      RHOA = (PA)/(RA*TA)
      U = MA*SQRT(GAM*RA*TA)
      DATA PRC,ETAC,GAMC,PRF,ETAF,GAMF,PRB,ETAB,QR,CP3,GAM3,CP4,GAM4,
     &ETAT,GAMT,PRAB,ETAAB,CP5,GAM5,CP6,GAM6,ETAN,GAMN
     &/12,0.9,1.4,4.3,0.92,1.4,0.98,0.98,19000,0.25,1.38,0.26,1.33,
     &0.97,1.35,0.93,0.99,0.26,1.35,0.30,1.3,0.99,1.35/

      AFT = .FALSE.
      IF(AFTER.EQ."T".OR.AFTER.EQ."t") AFT = .TRUE.

      CALL ATM(TEMP, A, MU, PRES, DENS, ALT)
      TEMP=(0.4136)+(0.03246*MA)+(0.1638*MA**2)+(0.06432*MA**3)+
     &(0.001676*MA**4)
      MDOT = DENS*A*AI*TEMP

      T0A = TA*(1+(((GAM-1)/2)*MA**2))
      P0A = PA*(1+(((GAM-1)/2)*MA**2))**((GAM)/(GAM-1))
      WRITE(*,3)"T0A = ",T0A,"P0A = ",P0A

      T02 = T0A
      P02 = P0A*(1-(.5*((MA/3)**3)))
      WRITE(*,3)"T02 = ",T02,"P02 = ",P02

      T03 = T02 * (1+((1/ETAC)*(PRC**((GAMC-1)/(GAMC))-1)))
      P03 = P02 * PRC
      WRITE(*,3)"T03 = ",T03,"P03 = ",P03

      T08 = T02 * (1+((ETAF**-1)*(PRF**((GAMF-1)/(GAMF))-1)))
      P08 = P02 * PRF
      WRITE(*,3)"T08 = ",T08,"P08 = ",P08

      P04 = P03 * PRB
      F = (CP4*T04-CP3*T03)/(ETAB*QR-CP3*T03)
      WRITE(*,3)"T04 = ",T04,"P04 = ",P04
      WRITE(*,2)" F = ", F

      P05 = P04*(1-((CP*(T03-T02)+(BETA*CP*(T08-T02)))/
     &(ETAT*(1+F)*CP4*T04)))**((GAMT)/(GAMT-1))
      T05 = T04*(1-ETAT*(1-(P05/P04)**((GAMT-1)/GAMT)))
      WRITE(*,3)"T05 = ",T05,"P05 = ",P05

      P06 = P05 * PRAB
      IF(AFT.EQV..TRUE.)THEN
        FAB = (((1+BETA)*CP6*T06)-(BETA*CP*T08)-(CP5*T05))/
     &((ETAAB*QR)-(CP6*T06))
      ELSE
        FAB = 0
        T06 = T05
      ENDIF
      WRITE(*,2)" FAB = ", FAB

      PE = PA
      UE = SQRT(2*(GAMN/(GAMN-1))*RA*T06*ETAN*
     &(1-(PA/P06)**((GAMN-1)/(GAMN))))

      MDOTA = MDOT
      T = MDOTA*(((1+F+FAB)*UE)-U)
      MDOTF = MDOTA*(F+FAB)*32.174*3600
      TSFC = MDOTF/T
      WRITE(*,4)"UE = ", UE,"MDOTA = ",MDOTA,"THRUST = ",T,
     &"MDOTF = ",MDOTF,"TSFC = ",TSFC

1     FORMAT(">> ",A)
2     FORMAT(A10,F9.6,/)
3     FORMAT(A10,F9.2,/,A10,F9.2,/)
4     FORMAT(A10,F9.2,/,A10,F9.2,/,A10,F9.2,/,A10,F9.2,/,A10,F9.2,/)
      END

C PULLED FROM HW1 AND EDITED INTO A SUBROUTINE
      SUBROUTINE ATM (TEMP, A, MU, PRES, DENS, ALT)
      REAL MU
      IF (ALT.LT.36089.2) THEN
        TEMP = 518.67 - 0.00356616 * (ALT)
        A = SQRT(1.4 * 1719.49 * TEMP)
        MU = 0.00000037373 * ((TEMP / 518.67) ** 1.5) *
     &((518.67 + 198.72) / (TEMP + 198.72))
        PRES = 2116.22*(TEMP/518.67)**
     &(-((32.2)/(-(0.00356616)*1719.49)))
        DENS = 0.0023769*(TEMP/518.67)**
     &((-((32.2)/(-(0.00356616)*1719.49)))-1)
      ELSEIF(36089.2.LE.ALT.AND.ALT.LT.65616.8) THEN
        TEMP = 389.97
        A = SQRT(1.4*1719.49*TEMP)
        MU = 0.00000029691 * ((TEMP / 389.97) ** 1.5) *
     &((389.97 + 198.72) / (TEMP + 198.72))
        PRES = 472.681*EXP(-(32.2)*((I-36089)/(1719.49*389.97)))
        DENS = 0.000706*EXP(-(32.2)*((I-36089)/(1719.49*389.97)))
      ELSEIF(65616.8.LE.ALT.AND.ALT.LT.104987) THEN
        TEMP = 389.97 + 0.00054864 * ((ALT) - (65616))
        A = SQRT(1.4*1719.49*TEMP)
        MU = 0.00000029691 * ((TEMP / 389.97) ** 1.5) *
     &((389.97 + 198.72)/(TEMP + 198.72))
        PRES = 114345*(TEMP/389.97)**
     &(-((32.2)/(0.00054864*1719.49)))
        DENS = 0.000170836*(TEMP/389.97)**
     &((-((32.2)/(0.00054864*1719.49)))-1)
      ELSE
        TEMP = -1
        A = -1
        MU = -1
        PRES = -1
        DENS = -1
      ENDIF
      END
