C PROGRAM TO CALCULATE AND CREATE A GRAPH OF ATMOSPHERIC DATA
      PROGRAM ATMOSPHERE
C CREATE AND INITIALIZE VARIABLES
      REAL, DIMENSION(0:104988) :: ALT, TEMP, A, MU, PRES, DENS
      REAL VERT
C VERTICAL OR HORIZONTAL DATA PLOTING
      VERT = 1

      ALT(0) = 0
      TEMP(0) = 518.67
      MU(0) = 0.00000037373
      PRES(0) = 2116.22
      DENS(0) = 0.0023769
      DO 10 I = 1,104988
          ALT(I) = I
          TEMP(I) = 0
          A(I) = 0
          PRES(I) = 0
          DENS(I) = 0
10    CONTINUE
C CALCULATE DATA FOR LAYER 0
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
C CALCULATE DATA FOR LAYER 1
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
C CALCULATE DATA FOR LAYER 2
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
C SCALE EACH DATASET TO FIT WELL ON ONE GRAPH
      DO 50 I = 0, 104988
          TEMP(I) = TEMP(I) * 1
          A(I) = A(I) * .1
          MU(I) = MU(I) * 1000000000
          PRES(I) = PRES(I) * .1
          DENS(I) = DENS(I) * 100000
50    CONTINUE
C WRITE GRAPH TO POSTSCRIPT FILE FOR VIEWING
      OPEN(1, FILE = 'test.eps')
      WRITE(1,*)'%!PS-Adobe-3.0 EPSF-3.0 '
      WRITE(1,*)'%%comments '
      WRITE(1,*)'%%BoundingBox: 0 0 612 792 '
      WRITE(1,*)'/plot { '
      WRITE(1,*)'gsave '
      WRITE(1,*)'/y1 exch def '
      WRITE(1,*)'/x1 exch def '
      WRITE(1,*)'/nlines 5 def       %number of lines to be plotted '
      WRITE(1,*)'/ncol 6 def         %number of columns '
      WRITE(1,*)'/xcols [1 1 1 1 1] def         %column containing x'
     &,' data '
      WRITE(1,*)'/ycols [2 3 4 5 6] def         %column containing y'
     &,' data '
      WRITE(1,*)'/lnwd [1 1 1 1 1] def %linewidths '
      WRITE(1,*)'/red [1 0 0 0 1] def '
      WRITE(1,*)'/green [0 1 0 1 0] def '
      WRITE(1,*)'/blue [0 0 1 1 1] def '
      WRITE(1,*)'/wp 400 def  %width of plot '
      WRITE(1,*)'/hp 600 def  %height of plot '
      WRITE(1,*)'/xmin 0 def '
      WRITE(1,*)'/xmax 550 def '
      WRITE(1,*)'/ymin 0 def '
      WRITE(1,*)'/ymax 104987 def '
      WRITE(1,*)'/title (Standard Atmosphere) def '
      WRITE(1,*)'/xlabel (Altitude) def' 
      WRITE(1,*)'/lega (Temperature (R)) def '
      WRITE(1,*)'/legb (Speed of Sound (ft/s) (10^-1)) def '
      WRITE(1,*)'/legc (Dynamic Viscosity (slug*ft^-1*s^-1) (10^9)) '
     &,'def '
      WRITE(1,*)'/legd (Pressure (lbf*ft^-2) (10^-1)) def '
      WRITE(1,*)'/lege (Density (slug/ft^-3) (10^6)) def '
      WRITE(1,*)'/legx 171 def'
      WRITE(1,*)'/legy 90 def'
      WRITE(1,*)'/xtics [0 100 200 300 400 500]'
     &,' def' 
      WRITE(1,*)'/ytics [0 26247.5 52495 78742.5 104990] def' 
      WRITE(1,*)'/xtext [(0) (100) (200) (300) (400) (500)] def'
      WRITE(1,*)'/ytext [(0) (26247.5) (52495) (78742.5) (104,990)] def' 
      WRITE(1,*)'' 
      WRITE(1,*)'%****************End of the definitions section '
      WRITE(1,*)'%****************Begining of the data section' 
      WRITE(1,*)''
      WRITE(1,*)'/ary '
      WRITE(1,*)'[' 
C THIS DO LOOP IS FOR PRINTING DATA
      DO 60 I = 0,104988/4
          WRITE(1,*)ALT(I*4), TEMP(I*4), A(I*4), MU(I*4), PRES(I*4),
     &DENS(I*4)
60    CONTINUE
      WRITE(1,*)']' 
      WRITE(1,*)'def' 
      WRITE(1,*)
      WRITE(1,*)'%****************End of the data section '
      WRITE(1,*)'%****************Begining of the plotting engine '
      WRITE(1,*)''
      WRITE(1,*)'/nx xtics length def    %number of xtics '
      WRITE(1,*)'/ny ytics length def    %number of ytics' 
      WRITE(1,*)'/x2 x1 wp add def' 
      WRITE(1,*)'/y2 y1 hp add def '
      WRITE(1,*)'/sx xmax xmin sub def' 
      WRITE(1,*)'/sx wp sx div def '
      WRITE(1,*)'/sy ymax ymin sub def '
      WRITE(1,*)'/sy hp sy div def '
      WRITE(1,*)'x1 y1 moveto '
      WRITE(1,*)'x2 y1 lineto '
      WRITE(1,*)'x2 y2 lineto '
      WRITE(1,*)'x1 y2 lineto '
      WRITE(1,*)'x1 y1 lineto '
      WRITE(1,*)'2 setlinewidth      %2-point line '
      WRITE(1,*)'stroke '
      WRITE(1,*)'1 setlinewidth '
      WRITE(1,*)'/Helvetica findfont 12 scalefont setfont '
      WRITE(1,*)'0 1 nx 1 sub {/i exch def '
      WRITE(1,*)'xtics i get xmin sub sx mul x1 add y1 moveto 0 hp 100 '
     &,'div rlineto '
      WRITE(1,*)'0 -20 rmoveto xtext i get dup stringwidth pop 2 div ne'
     &,'g 0 rmoveto show} for '
      WRITE(1,*)'0 1 ny 1 sub {/i exch def '
      WRITE(1,*)'ytics i get ymin sub sy mul y1 add x1 exch moveto wp 1'
     &,'00 div 0 rlineto '
      WRITE(1,*)'-10 -3 rmoveto ytext i get dup stringwidth pop neg 0 r'
     &,'moveto show} for '
      WRITE(1,*)'stroke '
      WRITE(1,*)'0 1 nlines 1 sub {/j exch def '
      WRITE(1,*)'/xcol xcols j get 1 sub def '
      WRITE(1,*)'/ycol ycols j get 1 sub def '
      WRITE(1,*)'/lw lnwd j get def '
      WRITE(1,*)'/rd red j get def '
      WRITE(1,*)'/grn green j get def '
      WRITE(1,*)'/bl blue j get def '
      WRITE(1,*)'rd grn bl setrgbcolor '
      IF (VERT == 0) THEN
        WRITE(1,*)'ary xcol get xmin sub sx mul x1 add ary ycol get '
     &,'ymin sub sy mul y1 add '
      ELSE
        WRITE(1,*)'ary ycol get xmin sub sx mul x1 add ary xcol get '
     &,'ymin sub sy mul y1 add '
      END IF 
      WRITE(1,*)'moveto ncol ncol ary length 1 sub '
      WRITE(1,*)'{/i exch def '
      IF (VERT == 0) THEN
        WRITE(1,*)'/x i xcol add def '
        WRITE(1,*)'/y i ycol add def '
        WRITE(1,*)'ary x get xmin sub sx mul x1 add ary y get ymin'
     &,' sub sy mul y1 add lineto '
        WRITE(1,*)'} for '
      ELSE
        WRITE(1,*)'/x i ycol add def '
        WRITE(1,*)'/y i xcol add def '
        WRITE(1,*)'ary x get xmin sub sx mul x1 add ary y get ymin'
     &,' sub sy mul y1 add lineto '
        WRITE(1,*)'} for '
      END IF
      WRITE(1,*)'lw setlinewidth '
      WRITE(1,*)'stroke '
      WRITE(1,*)'} for '
      WRITE(1,*)'/center {dup stringwidth pop 2 div neg 0 rmoveto} def'
      WRITE(1,*)'0 0 0 setrgbcolor '
      WRITE(1,*)'/Helvetica findfont 16 scalefont setfont '
      WRITE(1,*)'wp 2 div x1 add hp y1 add 12 add moveto '
      WRITE(1,*)'title center show '
      WRITE(1,*)'/Helvetica findfont 12 scalefont setfont '
      WRITE(1,*)'wp 2 div x1 add y1 30 sub  moveto '
      WRITE(1,*)'xlabel center show'
      WRITE(1,*)'/Helvetica findfont 12 scalefont setfont 1 0 0 setr'
     &,'gbcolor '
      WRITE(1,*)'wp 8 div 7 mul legx sub x1 add y1 legy 12 0 mul sub'
     &,' sub  moveto '
      WRITE(1,*)'lega show'
      WRITE(1,*)'/Helvetica findfont 12 scalefont setfont 0 0 1 '
     &,'setrgbcolor'
      WRITE(1,*)'wp 8 div 7 mul legx sub x1 add y1 legy 12 1 mul sub'
     &,' sub  moveto '
      WRITE(1,*)'legb show'
      WRITE(1,*)'/Helvetica findfont 12 scalefont setfont 0 1 0 setrgb'
     &,'color'
      WRITE(1,*)'wp 8 div 7 mul legx sub x1 add y1 legy 12 2 mul sub'
     &,' sub  moveto '
      WRITE(1,*)'legc show'
      WRITE(1,*)'/Helvetica findfont 12 scalefont setfont 0 1 1 setrgb'
     &,'color'
      WRITE(1,*)'wp 8 div 7 mul legx sub x1 add y1 legy 12 3 mul sub'
     &,' sub  moveto '
      WRITE(1,*)'legd show'
      WRITE(1,*)'/Helvetica findfont 12 scalefont setfont 1 0 1 setrgb'
     &,'color'
      WRITE(1,*)'wp 8 div 7 mul legx sub x1 add y1 legy 12 4 mul sub'
     &,' sub  moveto '
      WRITE(1,*)'lege show'
      WRITE(1,*)'grestore '
      WRITE(1,*)'} def '
      WRITE(1,*)'/grazlogo { '
      WRITE(1,*)'/y exch def '
      WRITE(1,*)'/x exch def '
      WRITE(1,*)'1 0.043 0.43 setrgbcolor '
      WRITE(1,*)'/square { '
      WRITE(1,*)'newpath '
      WRITE(1,*)'moveto '
      WRITE(1,*)'20 0 rlineto '
      WRITE(1,*)'0 20 rlineto '
      WRITE(1,*)'-20 0 rlineto '
      WRITE(1,*)'closepath '
      WRITE(1,*)'fill '
      WRITE(1,*)'} def '
      WRITE(1,*)'11 x add y square '
      WRITE(1,*)'x 10 y add square '
      WRITE(1,*)'x 22 add y 10 add square '
      WRITE(1,*)'x 44 add y 10 add square '
      WRITE(1,*)'x 33 add y 20 add square '
      WRITE(1,*)'stroke '
      WRITE(1,*)'0 0 0 setrgbcolor '
      WRITE(1,*)'/Helvetica findfont [20 0 0 20 0 0] '
      WRITE(1,*)'makefont setfont '
      WRITE(1,*)'x 44 add y 8 sub moveto '
      WRITE(1,*)'(TUG) show '
      WRITE(1,*)'} def '
      WRITE(1,*)'100 150 plot '
      WRITE(1,*)'showpage '
      END
