      PROGRAM ALTITUDE
      REAL, DIMENSION(0:104988) :: ATEMP, AA, AMU, APRESS, ARHO, MDOT
      CALL ATM(ATEMP,AA,AMU,APRESS,ARHO)
      
      DO 10 WHILE (.TRUE.)
        WRITE(*,"(A)")"ENTER ALTITUDE>>"
        READ(*,*)ALT
        WRITE(*,1)"TEMP",ATEMP(ALT),"A",AA(ALT),"MU",AMU(ALT),"PRESS",
     &APRESS(ALT),"RHO",ARHO(ALT)
10    CONTINUE
1     FORMAT(A5,F9.2,/,A5,F9.2,/,A5,F9.2,/,A5,F9.2,/,A5,F9.2,/)
      END


      SUBROUTINE ATM (TEMP, A, MU, PRES, DENS)
      REAL, DIMENSION(0:104988) :: TEMP, A, MU, PRES, DENS
      REAL VERT
      TEMP(0) = 518.67
      MU(0) = 0.00000037373
      PRES(0) = 2116.22
      DENS(0) = 0.0023769
      DO 10 I = 1,65616
          TEMP(I) = 0
          A(I) = 0
          PRES(I) = 0
          DENS(I) = 0
10    CONTINUE
      DO 20 I = 0, 36089
          TEMP(I) = TEMP(0) - 0.00356616 * (I)
          A(I) = SQRT(1.4 * 1719.49 * TEMP(I))
          MU(I) = MU(0) * ((TEMP(I) / TEMP(0)) ** 1.5) *
     &((TEMP(0) + 198.72) / (TEMP(I) + 198.72))
          MU(I) = MU(I)
          PRES(I) = PRES(0)*(TEMP(I)/TEMP(0))**
     &(-((32.2)/(-(0.00356616)*1719.49)))
          DENS(I) = DENS(0)*(TEMP(I)/TEMP(0))**
     &((-((32.2)/(-(0.00356616)*1719.49)))-1)
20    CONTINUE
      DO 30 I = 36090, 65616
          TEMP(I) = TEMP(36089)
          A(I) = SQRT(1.4*1719.49*TEMP(I))
          MU(I) = MU(36089) * ((TEMP(I) / TEMP(36089)) ** 1.5) *
     &((TEMP(36089) + 198.72) / (TEMP(I) + 198.72))
          MU(I) = MU(I)
          PRES(I) = PRES(36089)*
     &EXP(-(32.2)*((I-36089)/(1719.49*TEMP(36089))))
          DENS(I) = DENS(36089)*
     &EXP(-(32.2)*((I-36089)/(1719.49*TEMP(36089))))
30    CONTINUE
      DO 40 I = 65617, 104988
          TEMP(I) = TEMP(65616) + 0.00054864 * ((I) - (65616))
          A(I) = SQRT(1.4*1719.49*TEMP(I))
          MU(I) = MU(65616) * ((TEMP(I) / TEMP(65616)) ** 1.5) *
     &((TEMP(65616) + 198.72) / (TEMP(I) + 198.72))
          MU(I) = MU(I)
          PRES(I) = PRES(65616)*(TEMP(I)/TEMP(65616))**
     &(-((32.2)/(0.00054864*1719.49)))
          DENS(I) = DENS(65616)*(TEMP(I)/TEMP(65616))**
     &((-((32.2)/(0.00054864*1719.49)))-1)
40    CONTINUE
      END
