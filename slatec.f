
C---------------------------------------------------------------
C besi0.f
C---------------------------------------------------------------

*DECK BESI0
      FUNCTION BESI0 (X)
C***BEGIN PROLOGUE  BESI0
C***PURPOSE  Compute the hyperbolic Bessel function of the first kind
C            of order zero.
C***LIBRARY   SLATEC (FNLIB)
C***CATEGORY  C10B1
C***TYPE      SINGLE PRECISION (BESI0-S, DBESI0-D)
C***KEYWORDS  FIRST KIND, FNLIB, HYPERBOLIC BESSEL FUNCTION,
C             MODIFIED BESSEL FUNCTION, ORDER ZERO, SPECIAL FUNCTIONS
C***AUTHOR  Fullerton, W., (LANL)
C***DESCRIPTION
C
C BESI0(X) computes the modified (hyperbolic) Bessel function
C of the first kind of order zero and real argument X.
C
C Series for BI0        on the interval  0.          to  9.00000D+00
C                                        with weighted error   2.46E-18
C                                         log weighted error  17.61
C                               significant figures required  17.90
C                                    decimal places required  18.15
C
C***REFERENCES  (NONE)
C***ROUTINES CALLED  BESI0E, CSEVL, INITS, R1MACH, XERMSG
C***REVISION HISTORY  (YYMMDD)
C   770401  DATE WRITTEN
C   890531  Changed all specific intrinsics to generic.  (WRB)
C   890531  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   900315  CALLs to XERROR changed to CALLs to XERMSG.  (THJ)
C   900326  Removed duplicate information from DESCRIPTION section.
C           (WRB)
C***END PROLOGUE  BESI0
      DIMENSION BI0CS(12)
      LOGICAL FIRST
      SAVE BI0CS, NTI0, XSML, XMAX, FIRST
      DATA BI0CS( 1) /   -.0766054725 2839144951E0 /
      DATA BI0CS( 2) /   1.9273379539 93808270E0 /
      DATA BI0CS( 3) /    .2282644586 920301339E0 /
      DATA BI0CS( 4) /    .0130489146 6707290428E0 /
      DATA BI0CS( 5) /    .0004344270 9008164874E0 /
      DATA BI0CS( 6) /    .0000094226 5768600193E0 /
      DATA BI0CS( 7) /    .0000001434 0062895106E0 /
      DATA BI0CS( 8) /    .0000000016 1384906966E0 /
      DATA BI0CS( 9) /    .0000000000 1396650044E0 /
      DATA BI0CS(10) /    .0000000000 0009579451E0 /
      DATA BI0CS(11) /    .0000000000 0000053339E0 /
      DATA BI0CS(12) /    .0000000000 0000000245E0 /
      DATA FIRST /.TRUE./
C***FIRST EXECUTABLE STATEMENT  BESI0
      IF (FIRST) THEN
         NTI0 = INITS (BI0CS, 12, 0.1*R1MACH(3))
         XSML = SQRT (4.5*R1MACH(3))
         XMAX = LOG (R1MACH(2))
      ENDIF
      FIRST = .FALSE.
C
      Y = ABS(X)
      IF (Y.GT.3.0) GO TO 20
C
      BESI0 = 1.0
      IF (Y.GT.XSML) BESI0 = 2.75 + CSEVL (Y*Y/4.5-1.0, BI0CS, NTI0)
      RETURN
C
 20   IF (Y .GT. XMAX) CALL XERMSG ('SLATEC', 'BESI0',
     +   'ABS(X) SO BIG I0 OVERFLOWS', 1, 2)
C
      BESI0 = EXP(Y) * BESI0E(X)
C
      RETURN
      END

C---------------------------------------------------------------
C besi0e.f
C---------------------------------------------------------------

*DECK BESI0E
      FUNCTION BESI0E (X)
C***BEGIN PROLOGUE  BESI0E
C***PURPOSE  Compute the exponentially scaled modified (hyperbolic)
C            Bessel function of the first kind of order zero.
C***LIBRARY   SLATEC (FNLIB)
C***CATEGORY  C10B1
C***TYPE      SINGLE PRECISION (BESI0E-S, DBSI0E-D)
C***KEYWORDS  EXPONENTIALLY SCALED, FIRST KIND, FNLIB,
C             HYPERBOLIC BESSEL FUNCTION, MODIFIED BESSEL FUNCTION,
C             ORDER ZERO, SPECIAL FUNCTIONS
C***AUTHOR  Fullerton, W., (LANL)
C***DESCRIPTION
C
C BESI0E(X) calculates the exponentially scaled modified (hyperbolic)
C Bessel function of the first kind of order zero for real argument X;
C i.e., EXP(-ABS(X))*I0(X).
C
C
C Series for BI0        on the interval  0.          to  9.00000D+00
C                                        with weighted error   2.46E-18
C                                         log weighted error  17.61
C                               significant figures required  17.90
C                                    decimal places required  18.15
C
C
C Series for AI0        on the interval  1.25000D-01 to  3.33333D-01
C                                        with weighted error   7.87E-17
C                                         log weighted error  16.10
C                               significant figures required  14.69
C                                    decimal places required  16.76
C
C
C Series for AI02       on the interval  0.          to  1.25000D-01
C                                        with weighted error   3.79E-17
C                                         log weighted error  16.42
C                               significant figures required  14.86
C                                    decimal places required  17.09
C
C***REFERENCES  (NONE)
C***ROUTINES CALLED  CSEVL, INITS, R1MACH
C***REVISION HISTORY  (YYMMDD)
C   770701  DATE WRITTEN
C   890313  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C***END PROLOGUE  BESI0E
      DIMENSION BI0CS(12), AI0CS(21), AI02CS(22)
      LOGICAL FIRST
      SAVE BI0CS, AI0CS, AI02CS, NTI0, NTAI0, NTAI02, XSML, FIRST
      DATA BI0CS( 1) /   -.0766054725 2839144951E0 /
      DATA BI0CS( 2) /   1.9273379539 93808270E0 /
      DATA BI0CS( 3) /    .2282644586 920301339E0 /
      DATA BI0CS( 4) /    .0130489146 6707290428E0 /
      DATA BI0CS( 5) /    .0004344270 9008164874E0 /
      DATA BI0CS( 6) /    .0000094226 5768600193E0 /
      DATA BI0CS( 7) /    .0000001434 0062895106E0 /
      DATA BI0CS( 8) /    .0000000016 1384906966E0 /
      DATA BI0CS( 9) /    .0000000000 1396650044E0 /
      DATA BI0CS(10) /    .0000000000 0009579451E0 /
      DATA BI0CS(11) /    .0000000000 0000053339E0 /
      DATA BI0CS(12) /    .0000000000 0000000245E0 /
      DATA AI0CS( 1) /    .0757599449 4023796E0 /
      DATA AI0CS( 2) /    .0075913808 1082334E0 /
      DATA AI0CS( 3) /    .0004153131 3389237E0 /
      DATA AI0CS( 4) /    .0000107007 6463439E0 /
      DATA AI0CS( 5) /   -.0000079011 7997921E0 /
      DATA AI0CS( 6) /   -.0000007826 1435014E0 /
      DATA AI0CS( 7) /    .0000002783 8499429E0 /
      DATA AI0CS( 8) /    .0000000082 5247260E0 /
      DATA AI0CS( 9) /   -.0000000120 4463945E0 /
      DATA AI0CS(10) /    .0000000015 5964859E0 /
      DATA AI0CS(11) /    .0000000002 2925563E0 /
      DATA AI0CS(12) /   -.0000000001 1916228E0 /
      DATA AI0CS(13) /    .0000000000 1757854E0 /
      DATA AI0CS(14) /    .0000000000 0112822E0 /
      DATA AI0CS(15) /   -.0000000000 0114684E0 /
      DATA AI0CS(16) /    .0000000000 0027155E0 /
      DATA AI0CS(17) /   -.0000000000 0002415E0 /
      DATA AI0CS(18) /   -.0000000000 0000608E0 /
      DATA AI0CS(19) /    .0000000000 0000314E0 /
      DATA AI0CS(20) /   -.0000000000 0000071E0 /
      DATA AI0CS(21) /    .0000000000 0000007E0 /
      DATA AI02CS( 1) /    .0544904110 1410882E0 /
      DATA AI02CS( 2) /    .0033691164 7825569E0 /
      DATA AI02CS( 3) /    .0000688975 8346918E0 /
      DATA AI02CS( 4) /    .0000028913 7052082E0 /
      DATA AI02CS( 5) /    .0000002048 9185893E0 /
      DATA AI02CS( 6) /    .0000000226 6668991E0 /
      DATA AI02CS( 7) /    .0000000033 9623203E0 /
      DATA AI02CS( 8) /    .0000000004 9406022E0 /
      DATA AI02CS( 9) /    .0000000000 1188914E0 /
      DATA AI02CS(10) /   -.0000000000 3149915E0 /
      DATA AI02CS(11) /   -.0000000000 1321580E0 /
      DATA AI02CS(12) /   -.0000000000 0179419E0 /
      DATA AI02CS(13) /    .0000000000 0071801E0 /
      DATA AI02CS(14) /    .0000000000 0038529E0 /
      DATA AI02CS(15) /    .0000000000 0001539E0 /
      DATA AI02CS(16) /   -.0000000000 0004151E0 /
      DATA AI02CS(17) /   -.0000000000 0000954E0 /
      DATA AI02CS(18) /    .0000000000 0000382E0 /
      DATA AI02CS(19) /    .0000000000 0000176E0 /
      DATA AI02CS(20) /   -.0000000000 0000034E0 /
      DATA AI02CS(21) /   -.0000000000 0000027E0 /
      DATA AI02CS(22) /    .0000000000 0000003E0 /
      DATA FIRST /.TRUE./
C***FIRST EXECUTABLE STATEMENT  BESI0E
      IF (FIRST) THEN
         NTI0 = INITS (BI0CS, 12, 0.1*R1MACH(3))
         NTAI0 = INITS (AI0CS, 21, 0.1*R1MACH(3))
         NTAI02 = INITS (AI02CS, 22, 0.1*R1MACH(3))
         XSML = SQRT (4.5*R1MACH(3))
      ENDIF
      FIRST = .FALSE.
C
      Y = ABS(X)
      IF (Y.GT.3.0) GO TO 20
C
      BESI0E = 1.0 - X
      IF (Y.GT.XSML) BESI0E = EXP(-Y) * ( 2.75 +
     1  CSEVL (Y*Y/4.5-1.0, BI0CS, NTI0) )
      RETURN
C
 20   IF (Y.LE.8.) BESI0E = (.375 + CSEVL ((48./Y-11.)/5., AI0CS, NTAI0)
     1  ) / SQRT(Y)
      IF (Y.GT.8.) BESI0E = (.375 + CSEVL (16./Y-1., AI02CS, NTAI02))
     1  / SQRT(Y)
C
      RETURN
      END

C---------------------------------------------------------------
C besk0.f
C---------------------------------------------------------------

*DECK BESK0
      FUNCTION BESK0 (X)
C***BEGIN PROLOGUE  BESK0
C***PURPOSE  Compute the modified (hyperbolic) Bessel function of the
C            third kind of order zero.
C***LIBRARY   SLATEC (FNLIB)
C***CATEGORY  C10B1
C***TYPE      SINGLE PRECISION (BESK0-S, DBESK0-D)
C***KEYWORDS  FNLIB, HYPERBOLIC BESSEL FUNCTION,
C             MODIFIED BESSEL FUNCTION, ORDER ZERO, SPECIAL FUNCTIONS,
C             THIRD KIND
C***AUTHOR  Fullerton, W., (LANL)
C***DESCRIPTION
C
C BESK0(X) calculates the modified (hyperbolic) Bessel function
C of the third kind of order zero for real argument X .GT. 0.0.
C
C Series for BK0        on the interval  0.          to  4.00000D+00
C                                        with weighted error   3.57E-19
C                                         log weighted error  18.45
C                               significant figures required  17.99
C                                    decimal places required  18.97
C
C***REFERENCES  (NONE)
C***ROUTINES CALLED  BESI0, BESK0E, CSEVL, INITS, R1MACH, XERMSG
C***REVISION HISTORY  (YYMMDD)
C   770401  DATE WRITTEN
C   890531  Changed all specific intrinsics to generic.  (WRB)
C   890531  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   900315  CALLs to XERROR changed to CALLs to XERMSG.  (THJ)
C   900326  Removed duplicate information from DESCRIPTION section.
C           (WRB)
C***END PROLOGUE  BESK0
      DIMENSION BK0CS(11)
      LOGICAL FIRST
      SAVE BK0CS, NTK0, XSML, XMAX, FIRST
      DATA BK0CS( 1) /   -.0353273932 3390276872E0 /
      DATA BK0CS( 2) /    .3442898999 246284869E0 /
      DATA BK0CS( 3) /    .0359799365 1536150163E0 /
      DATA BK0CS( 4) /    .0012646154 1144692592E0 /
      DATA BK0CS( 5) /    .0000228621 2103119451E0 /
      DATA BK0CS( 6) /    .0000002534 7910790261E0 /
      DATA BK0CS( 7) /    .0000000019 0451637722E0 /
      DATA BK0CS( 8) /    .0000000000 1034969525E0 /
      DATA BK0CS( 9) /    .0000000000 0004259816E0 /
      DATA BK0CS(10) /    .0000000000 0000013744E0 /
      DATA BK0CS(11) /    .0000000000 0000000035E0 /
      DATA FIRST /.TRUE./
C***FIRST EXECUTABLE STATEMENT  BESK0
      IF (FIRST) THEN
         NTK0 = INITS (BK0CS, 11, 0.1*R1MACH(3))
         XSML = SQRT (4.0*R1MACH(3))
         XMAXT = -LOG(R1MACH(1))
         XMAX = XMAXT - 0.5*XMAXT*LOG(XMAXT)/(XMAXT+0.5) - 0.01
      ENDIF
      FIRST = .FALSE.
C
      IF (X .LE. 0.) CALL XERMSG ('SLATEC', 'BESK0',
     +   'X IS ZERO OR NEGATIVE', 2, 2)
      IF (X.GT.2.) GO TO 20
C
      Y = 0.
      IF (X.GT.XSML) Y = X*X
      BESK0 = -LOG(0.5*X)*BESI0(X) - .25 + CSEVL (.5*Y-1., BK0CS, NTK0)
      RETURN
C
 20   BESK0 = 0.
      IF (X .GT. XMAX) CALL XERMSG ('SLATEC', 'BESK0',
     +   'X SO BIG K0 UNDERFLOWS', 1, 1)
      IF (X.GT.XMAX) RETURN
C
      BESK0 = EXP(-X) * BESK0E(X)
C
      RETURN
      END

C---------------------------------------------------------------
C besk0e.f
C---------------------------------------------------------------

*DECK BESK0E
      FUNCTION BESK0E (X)
C***BEGIN PROLOGUE  BESK0E
C***PURPOSE  Compute the exponentially scaled modified (hyperbolic)
C            Bessel function of the third kind of order zero.
C***LIBRARY   SLATEC (FNLIB)
C***CATEGORY  C10B1
C***TYPE      SINGLE PRECISION (BESK0E-S, DBSK0E-D)
C***KEYWORDS  EXPONENTIALLY SCALED, FNLIB, HYPERBOLIC BESSEL FUNCTION,
C             MODIFIED BESSEL FUNCTION, ORDER ZERO, SPECIAL FUNCTIONS,
C             THIRD KIND
C***AUTHOR  Fullerton, W., (LANL)
C***DESCRIPTION
C
C BESK0E(X) computes the exponentially scaled modified (hyperbolic)
C Bessel function of third kind of order zero for real argument
C X .GT. 0.0, i.e., EXP(X)*K0(X).
C
C Series for BK0        on the interval  0.          to  4.00000D+00
C                                        with weighted error   3.57E-19
C                                         log weighted error  18.45
C                               significant figures required  17.99
C                                    decimal places required  18.97
C
C Series for AK0        on the interval  1.25000D-01 to  5.00000D-01
C                                        with weighted error   5.34E-17
C                                         log weighted error  16.27
C                               significant figures required  14.92
C                                    decimal places required  16.89
C
C Series for AK02       on the interval  0.          to  1.25000D-01
C                                        with weighted error   2.34E-17
C                                         log weighted error  16.63
C                               significant figures required  14.67
C                                    decimal places required  17.20
C
C***REFERENCES  (NONE)
C***ROUTINES CALLED  BESI0, CSEVL, INITS, R1MACH, XERMSG
C***REVISION HISTORY  (YYMMDD)
C   770401  DATE WRITTEN
C   890531  Changed all specific intrinsics to generic.  (WRB)
C   890531  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   900315  CALLs to XERROR changed to CALLs to XERMSG.  (THJ)
C   900326  Removed duplicate information from DESCRIPTION section.
C           (WRB)
C***END PROLOGUE  BESK0E
      DIMENSION BK0CS(11), AK0CS(17), AK02CS(14)
      LOGICAL FIRST
      SAVE BK0CS, AK0CS, AK02CS, NTK0, NTAK0, NTAK02, XSML, FIRST
      DATA BK0CS( 1) /   -.0353273932 3390276872E0 /
      DATA BK0CS( 2) /    .3442898999 246284869E0 /
      DATA BK0CS( 3) /    .0359799365 1536150163E0 /
      DATA BK0CS( 4) /    .0012646154 1144692592E0 /
      DATA BK0CS( 5) /    .0000228621 2103119451E0 /
      DATA BK0CS( 6) /    .0000002534 7910790261E0 /
      DATA BK0CS( 7) /    .0000000019 0451637722E0 /
      DATA BK0CS( 8) /    .0000000000 1034969525E0 /
      DATA BK0CS( 9) /    .0000000000 0004259816E0 /
      DATA BK0CS(10) /    .0000000000 0000013744E0 /
      DATA BK0CS(11) /    .0000000000 0000000035E0 /
      DATA AK0CS( 1) /   -.0764394790 3327941E0 /
      DATA AK0CS( 2) /   -.0223565260 5699819E0 /
      DATA AK0CS( 3) /    .0007734181 1546938E0 /
      DATA AK0CS( 4) /   -.0000428100 6688886E0 /
      DATA AK0CS( 5) /    .0000030817 0017386E0 /
      DATA AK0CS( 6) /   -.0000002639 3672220E0 /
      DATA AK0CS( 7) /    .0000000256 3713036E0 /
      DATA AK0CS( 8) /   -.0000000027 4270554E0 /
      DATA AK0CS( 9) /    .0000000003 1694296E0 /
      DATA AK0CS(10) /   -.0000000000 3902353E0 /
      DATA AK0CS(11) /    .0000000000 0506804E0 /
      DATA AK0CS(12) /   -.0000000000 0068895E0 /
      DATA AK0CS(13) /    .0000000000 0009744E0 /
      DATA AK0CS(14) /   -.0000000000 0001427E0 /
      DATA AK0CS(15) /    .0000000000 0000215E0 /
      DATA AK0CS(16) /   -.0000000000 0000033E0 /
      DATA AK0CS(17) /    .0000000000 0000005E0 /
      DATA AK02CS( 1) /   -.0120186982 6307592E0 /
      DATA AK02CS( 2) /   -.0091748526 9102569E0 /
      DATA AK02CS( 3) /    .0001444550 9317750E0 /
      DATA AK02CS( 4) /   -.0000040136 1417543E0 /
      DATA AK02CS( 5) /    .0000001567 8318108E0 /
      DATA AK02CS( 6) /   -.0000000077 7011043E0 /
      DATA AK02CS( 7) /    .0000000004 6111825E0 /
      DATA AK02CS( 8) /   -.0000000000 3158592E0 /
      DATA AK02CS( 9) /    .0000000000 0243501E0 /
      DATA AK02CS(10) /   -.0000000000 0020743E0 /
      DATA AK02CS(11) /    .0000000000 0001925E0 /
      DATA AK02CS(12) /   -.0000000000 0000192E0 /
      DATA AK02CS(13) /    .0000000000 0000020E0 /
      DATA AK02CS(14) /   -.0000000000 0000002E0 /
      DATA FIRST /.TRUE./
C***FIRST EXECUTABLE STATEMENT  BESK0E
      IF (FIRST) THEN
         NTK0 = INITS (BK0CS, 11, 0.1*R1MACH(3))
         NTAK0 = INITS (AK0CS, 17, 0.1*R1MACH(3))
         NTAK02 = INITS (AK02CS, 14, 0.1*R1MACH(3))
         XSML = SQRT (4.0*R1MACH(3))
      ENDIF
      FIRST = .FALSE.
C
      IF (X .LE. 0.) CALL XERMSG ('SLATEC', 'BESK0E',
     +   'X IS ZERO OR NEGATIVE', 2, 2)
      IF (X.GT.2.) GO TO 20
C
      Y = 0.
      IF (X.GT.XSML) Y = X*X
      BESK0E = EXP(X) * (-LOG(0.5*X)*BESI0(X)
     1  - .25 + CSEVL (.5*Y-1., BK0CS, NTK0) )
      RETURN
C
 20   IF (X.LE.8.) BESK0E = (1.25 + CSEVL ((16./X-5.)/3., AK0CS, NTAK0))
     1  / SQRT(X)
      IF (X.GT.8.) BESK0E = (1.25 + CSEVL (16./X-1., AK02CS, NTAK02))
     1  / SQRT(X)
C
      RETURN
      END

C---------------------------------------------------------------
C csevl.f
C---------------------------------------------------------------

*DECK CSEVL
      FUNCTION CSEVL (X, CS, N)
C***BEGIN PROLOGUE  CSEVL
C***PURPOSE  Evaluate a Chebyshev series.
C***LIBRARY   SLATEC (FNLIB)
C***CATEGORY  C3A2
C***TYPE      SINGLE PRECISION (CSEVL-S, DCSEVL-D)
C***KEYWORDS  CHEBYSHEV SERIES, FNLIB, SPECIAL FUNCTIONS
C***AUTHOR  Fullerton, W., (LANL)
C***DESCRIPTION
C
C  Evaluate the N-term Chebyshev series CS at X.  Adapted from
C  a method presented in the paper by Broucke referenced below.
C
C       Input Arguments --
C  X    value at which the series is to be evaluated.
C  CS   array of N terms of a Chebyshev series.  In evaluating
C       CS, only half the first coefficient is summed.
C  N    number of terms in array CS.
C
C***REFERENCES  R. Broucke, Ten subroutines for the manipulation of
C                 Chebyshev series, Algorithm 446, Communications of
C                 the A.C.M. 16, (1973) pp. 254-256.
C               L. Fox and I. B. Parker, Chebyshev Polynomials in
C                 Numerical Analysis, Oxford University Press, 1968,
C                 page 56.
C***ROUTINES CALLED  R1MACH, XERMSG
C***REVISION HISTORY  (YYMMDD)
C   770401  DATE WRITTEN
C   890831  Modified array declarations.  (WRB)
C   890831  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   900315  CALLs to XERROR changed to CALLs to XERMSG.  (THJ)
C   900329  Prologued revised extensively and code rewritten to allow
C           X to be slightly outside interval (-1,+1).  (WRB)
C   920501  Reformatted the REFERENCES section.  (WRB)
C***END PROLOGUE  CSEVL
      REAL B0, B1, B2, CS(*), ONEPL, TWOX, X
      LOGICAL FIRST
      SAVE FIRST, ONEPL
      DATA FIRST /.TRUE./
C***FIRST EXECUTABLE STATEMENT  CSEVL
      IF (FIRST) ONEPL = 1.0E0 + R1MACH(4)
      FIRST = .FALSE.
      IF (N .LT. 1) CALL XERMSG ('SLATEC', 'CSEVL',
     +   'NUMBER OF TERMS .LE. 0', 2, 2)
      IF (N .GT. 1000) CALL XERMSG ('SLATEC', 'CSEVL',
     +   'NUMBER OF TERMS .GT. 1000', 3, 2)
      IF (ABS(X) .GT. ONEPL) CALL XERMSG ('SLATEC', 'CSEVL',
     +   'X OUTSIDE THE INTERVAL (-1,+1)', 1, 1)
C
      B1 = 0.0E0
      B0 = 0.0E0
      TWOX = 2.0*X
      DO 10 I = 1,N
         B2 = B1
         B1 = B0
         NI = N + 1 - I
         B0 = TWOX*B1 - B2 + CS(NI)
   10 CONTINUE
C
      CSEVL = 0.5E0*(B0-B2)
C
      RETURN
      END

C---------------------------------------------------------------
C d1mach.f
C---------------------------------------------------------------


      DOUBLE PRECISION FUNCTION D1MACH (I)
C***BEGIN PROLOGUE  D1MACH
C***PURPOSE  Return floating point machine dependent constants.
C***LIBRARY   SLATEC
C***CATEGORY  R1
C***TYPE      DOUBLE PRECISION (R1MACH-S, D1MACH-D)
C***KEYWORDS  MACHINE CONSTANTS
C***AUTHOR  Fox, P. A., (Bell Labs)
C           Hall, A. D., (Bell Labs)
C           Schryer, N. L., (Bell Labs)
C***DESCRIPTION
C
C   D1MACH can be used to obtain machine-dependent parameters for the
C   local machine environment.  It is a function subprogram with one
C   (input) argument, and can be referenced as follows:
C
C        D = D1MACH(I)
C
C   where I=1,...,5.  The (output) value of D above is determined by
C   the (input) value of I.  The results for various values of I are
C   discussed below.
C
C   D1MACH( 1) = B**(EMIN-1), the smallest positive magnitude.
C   D1MACH( 2) = B**EMAX*(1 - B**(-T)), the largest magnitude.
C   D1MACH( 3) = B**(-T), the smallest relative spacing.
C   D1MACH( 4) = B**(1-T), the largest relative spacing.
C   D1MACH( 5) = LOG10(B)
C
C   Assume double precision numbers are represented in the T-digit,
C   base-B form
C
C              sign (B**E)*( (X(1)/B) + ... + (X(T)/B**T) )
C
C   where 0 .LE. X(I) .LT. B for I=1,...,T, 0 .LT. X(1), and
C   EMIN .LE. E .LE. EMAX.
C
C   The values of B, T, EMIN and EMAX are provided in I1MACH as
C   follows:
C   I1MACH(10) = B, the base.
C   I1MACH(14) = T, the number of base-B digits.
C   I1MACH(15) = EMIN, the smallest exponent E.
C   I1MACH(16) = EMAX, the largest exponent E.
C
C   To alter this function for a particular environment, the desired
C   set of DATA statements should be activated by removing the C from
C   column 1.  Also, the values of D1MACH(1) - D1MACH(4) should be
C   checked for consistency with the local operating system.
C
C***REFERENCES  P. A. Fox, A. D. Hall and N. L. Schryer, Framework for
C                 a portable library, ACM Transactions on Mathematical
C                 Software 4, 2 (June 1978), pp. 177-188.
C***ROUTINES CALLED  XERMSG
C***REVISION HISTORY  (YYMMDD)
C   750101  DATE WRITTEN
C   890213  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   900315  CALLs to XERROR changed to CALLs to XERMSG.  (THJ)
C   900618  Added DEC RISC constants.  (WRB)
C   900723  Added IBM RS 6000 constants.  (WRB)
C   900911  Added SUN 386i constants.  (WRB)
C   910710  Added HP 730 constants.  (SMR)
C   911114  Added Convex IEEE constants.  (WRB)
C   920121  Added SUN -r8 compiler option constants.  (WRB)
C   920229  Added Touchstone Delta i860 constants.  (WRB)
C   920501  Reformatted the REFERENCES section.  (WRB)
C   920625  Added CONVEX -p8 and -pd8 compiler option constants.
C           (BKS, WRB)
C***END PROLOGUE  D1MACH
C
      INTEGER SMALL(4)
      INTEGER LARGE(4)
      INTEGER RIGHT(4)
      INTEGER DIVER(4)
      INTEGER LOG10(4)
C
      DOUBLE PRECISION DMACH(5)
      SAVE DMACH
C
      EQUIVALENCE (DMACH(1),SMALL(1))
      EQUIVALENCE (DMACH(2),LARGE(1))
      EQUIVALENCE (DMACH(3),RIGHT(1))
      EQUIVALENCE (DMACH(4),DIVER(1))
      EQUIVALENCE (DMACH(5),LOG10(1))
C
C     MACHINE CONSTANTS FOR THE AMIGA
C     ABSOFT FORTRAN COMPILER USING THE 68020/68881 COMPILER OPTION
C
C     DATA SMALL(1), SMALL(2) / Z'00100000', Z'00000000' /
C     DATA LARGE(1), LARGE(2) / Z'7FEFFFFF', Z'FFFFFFFF' /
C     DATA RIGHT(1), RIGHT(2) / Z'3CA00000', Z'00000000' /
C     DATA DIVER(1), DIVER(2) / Z'3CB00000', Z'00000000' /
C     DATA LOG10(1), LOG10(2) / Z'3FD34413', Z'509F79FF' /
C
C     MACHINE CONSTANTS FOR THE AMIGA
C     ABSOFT FORTRAN COMPILER USING SOFTWARE FLOATING POINT
C
C     DATA SMALL(1), SMALL(2) / Z'00100000', Z'00000000' /
C     DATA LARGE(1), LARGE(2) / Z'7FDFFFFF', Z'FFFFFFFF' /
C     DATA RIGHT(1), RIGHT(2) / Z'3CA00000', Z'00000000' /
C     DATA DIVER(1), DIVER(2) / Z'3CB00000', Z'00000000' /
C     DATA LOG10(1), LOG10(2) / Z'3FD34413', Z'509F79FF' /
C
C     MACHINE CONSTANTS FOR THE APOLLO
C
C     DATA SMALL(1), SMALL(2) / 16#00100000, 16#00000000 /
C     DATA LARGE(1), LARGE(2) / 16#7FFFFFFF, 16#FFFFFFFF /
C     DATA RIGHT(1), RIGHT(2) / 16#3CA00000, 16#00000000 /
C     DATA DIVER(1), DIVER(2) / 16#3CB00000, 16#00000000 /
C     DATA LOG10(1), LOG10(2) / 16#3FD34413, 16#509F79FF /
C
C     MACHINE CONSTANTS FOR THE BURROUGHS 1700 SYSTEM
C
C     DATA SMALL(1) / ZC00800000 /
C     DATA SMALL(2) / Z000000000 /
C     DATA LARGE(1) / ZDFFFFFFFF /
C     DATA LARGE(2) / ZFFFFFFFFF /
C     DATA RIGHT(1) / ZCC5800000 /
C     DATA RIGHT(2) / Z000000000 /
C     DATA DIVER(1) / ZCC6800000 /
C     DATA DIVER(2) / Z000000000 /
C     DATA LOG10(1) / ZD00E730E7 /
C     DATA LOG10(2) / ZC77800DC0 /
C
C     MACHINE CONSTANTS FOR THE BURROUGHS 5700 SYSTEM
C
C     DATA SMALL(1) / O1771000000000000 /
C     DATA SMALL(2) / O0000000000000000 /
C     DATA LARGE(1) / O0777777777777777 /
C     DATA LARGE(2) / O0007777777777777 /
C     DATA RIGHT(1) / O1461000000000000 /
C     DATA RIGHT(2) / O0000000000000000 /
C     DATA DIVER(1) / O1451000000000000 /
C     DATA DIVER(2) / O0000000000000000 /
C     DATA LOG10(1) / O1157163034761674 /
C     DATA LOG10(2) / O0006677466732724 /
C
C     MACHINE CONSTANTS FOR THE BURROUGHS 6700/7700 SYSTEMS
C
C     DATA SMALL(1) / O1771000000000000 /
C     DATA SMALL(2) / O7770000000000000 /
C     DATA LARGE(1) / O0777777777777777 /
C     DATA LARGE(2) / O7777777777777777 /
C     DATA RIGHT(1) / O1461000000000000 /
C     DATA RIGHT(2) / O0000000000000000 /
C     DATA DIVER(1) / O1451000000000000 /
C     DATA DIVER(2) / O0000000000000000 /
C     DATA LOG10(1) / O1157163034761674 /
C     DATA LOG10(2) / O0006677466732724 /
C
C     MACHINE CONSTANTS FOR THE CDC 170/180 SERIES USING NOS/VE
C
C     DATA SMALL(1) / Z"3001800000000000" /
C     DATA SMALL(2) / Z"3001000000000000" /
C     DATA LARGE(1) / Z"4FFEFFFFFFFFFFFE" /
C     DATA LARGE(2) / Z"4FFE000000000000" /
C     DATA RIGHT(1) / Z"3FD2800000000000" /
C     DATA RIGHT(2) / Z"3FD2000000000000" /
C     DATA DIVER(1) / Z"3FD3800000000000" /
C     DATA DIVER(2) / Z"3FD3000000000000" /
C     DATA LOG10(1) / Z"3FFF9A209A84FBCF" /
C     DATA LOG10(2) / Z"3FFFF7988F8959AC" /
C
C     MACHINE CONSTANTS FOR THE CDC 6000/7000 SERIES
C
C     DATA SMALL(1) / 00564000000000000000B /
C     DATA SMALL(2) / 00000000000000000000B /
C     DATA LARGE(1) / 37757777777777777777B /
C     DATA LARGE(2) / 37157777777777777777B /
C     DATA RIGHT(1) / 15624000000000000000B /
C     DATA RIGHT(2) / 00000000000000000000B /
C     DATA DIVER(1) / 15634000000000000000B /
C     DATA DIVER(2) / 00000000000000000000B /
C     DATA LOG10(1) / 17164642023241175717B /
C     DATA LOG10(2) / 16367571421742254654B /
C
C     MACHINE CONSTANTS FOR THE CELERITY C1260
C
C     DATA SMALL(1), SMALL(2) / Z'00100000', Z'00000000' /
C     DATA LARGE(1), LARGE(2) / Z'7FEFFFFF', Z'FFFFFFFF' /
C     DATA RIGHT(1), RIGHT(2) / Z'3CA00000', Z'00000000' /
C     DATA DIVER(1), DIVER(2) / Z'3CB00000', Z'00000000' /
C     DATA LOG10(1), LOG10(2) / Z'3FD34413', Z'509F79FF' /
C
C     MACHINE CONSTANTS FOR THE CONVEX
C     USING THE -fn OR -pd8 COMPILER OPTION
C
C     DATA DMACH(1) / Z'0010000000000000' /
C     DATA DMACH(2) / Z'7FFFFFFFFFFFFFFF' /
C     DATA DMACH(3) / Z'3CC0000000000000' /
C     DATA DMACH(4) / Z'3CD0000000000000' /
C     DATA DMACH(5) / Z'3FF34413509F79FF' /
C
C     MACHINE CONSTANTS FOR THE CONVEX
C     USING THE -fi COMPILER OPTION
C
C     DATA DMACH(1) / Z'0010000000000000' /
C     DATA DMACH(2) / Z'7FEFFFFFFFFFFFFF' /
C     DATA DMACH(3) / Z'3CA0000000000000' /
C     DATA DMACH(4) / Z'3CB0000000000000' /
C     DATA DMACH(5) / Z'3FD34413509F79FF' /
C
C     MACHINE CONSTANTS FOR THE CONVEX
C     USING THE -p8 COMPILER OPTION
C
C     DATA DMACH(1) / Z'00010000000000000000000000000000' /
C     DATA DMACH(2) / Z'7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF' /
C     DATA DMACH(3) / Z'3F900000000000000000000000000000' /
C     DATA DMACH(4) / Z'3F910000000000000000000000000000' /
C     DATA DMACH(5) / Z'3FFF34413509F79FEF311F12B35816F9' /
C
C     MACHINE CONSTANTS FOR THE CRAY
C
C     DATA SMALL(1) / 201354000000000000000B /
C     DATA SMALL(2) / 000000000000000000000B /
C     DATA LARGE(1) / 577767777777777777777B /
C     DATA LARGE(2) / 000007777777777777774B /
C     DATA RIGHT(1) / 376434000000000000000B /
C     DATA RIGHT(2) / 000000000000000000000B /
C     DATA DIVER(1) / 376444000000000000000B /
C     DATA DIVER(2) / 000000000000000000000B /
C     DATA LOG10(1) / 377774642023241175717B /
C     DATA LOG10(2) / 000007571421742254654B /
C
C     MACHINE CONSTANTS FOR THE DATA GENERAL ECLIPSE S/200
C
C     NOTE - IT MAY BE APPROPRIATE TO INCLUDE THE FOLLOWING CARD -
C     STATIC DMACH(5)
C
C     DATA SMALL /    20K, 3*0 /
C     DATA LARGE / 77777K, 3*177777K /
C     DATA RIGHT / 31420K, 3*0 /
C     DATA DIVER / 32020K, 3*0 /
C     DATA LOG10 / 40423K, 42023K, 50237K, 74776K /
C
C     MACHINE CONSTANTS FOR THE DEC RISC
C
C     DATA SMALL(1), SMALL(2) / Z'00000000', Z'00100000'/
C     DATA LARGE(1), LARGE(2) / Z'FFFFFFFF', Z'7FEFFFFF'/
C     DATA RIGHT(1), RIGHT(2) / Z'00000000', Z'3CA00000'/
C     DATA DIVER(1), DIVER(2) / Z'00000000', Z'3CB00000'/
C     DATA LOG10(1), LOG10(2) / Z'509F79FF', Z'3FD34413'/
C
C     MACHINE CONSTANTS FOR THE ELXSI 6400
C     (ASSUMING REAL*8 IS THE DEFAULT DOUBLE PRECISION)
C
C     DATA SMALL(1), SMALL(2) / '00100000'X,'00000000'X /
C     DATA LARGE(1), LARGE(2) / '7FEFFFFF'X,'FFFFFFFF'X /
C     DATA RIGHT(1), RIGHT(2) / '3CB00000'X,'00000000'X /
C     DATA DIVER(1), DIVER(2) / '3CC00000'X,'00000000'X /
C     DATA LOG10(1), LOG10(2) / '3FD34413'X,'509F79FF'X /
C
C     MACHINE CONSTANTS FOR THE HARRIS 220
C
C     DATA SMALL(1), SMALL(2) / '20000000, '00000201 /
C     DATA LARGE(1), LARGE(2) / '37777777, '37777577 /
C     DATA RIGHT(1), RIGHT(2) / '20000000, '00000333 /
C     DATA DIVER(1), DIVER(2) / '20000000, '00000334 /
C     DATA LOG10(1), LOG10(2) / '23210115, '10237777 /
C
C     MACHINE CONSTANTS FOR THE HONEYWELL 600/6000 SERIES
C
C     DATA SMALL(1), SMALL(2) / O402400000000, O000000000000 /
C     DATA LARGE(1), LARGE(2) / O376777777777, O777777777777 /
C     DATA RIGHT(1), RIGHT(2) / O604400000000, O000000000000 /
C     DATA DIVER(1), DIVER(2) / O606400000000, O000000000000 /
C     DATA LOG10(1), LOG10(2) / O776464202324, O117571775714 /
C
C     MACHINE CONSTANTS FOR THE HP 730
C
      DATA DMACH(1) / Z'0010000000000000' /
      DATA DMACH(2) / Z'7FEFFFFFFFFFFFFF' /
      DATA DMACH(3) / Z'3CA0000000000000' /
      DATA DMACH(4) / Z'3CB0000000000000' /
      DATA DMACH(5) / Z'3FD34413509F79FF' /
C
C     MACHINE CONSTANTS FOR THE HP 2100
C     THREE WORD DOUBLE PRECISION OPTION WITH FTN4
C
C     DATA SMALL(1), SMALL(2), SMALL(3) / 40000B,       0,       1 /
C     DATA LARGE(1), LARGE(2), LARGE(3) / 77777B, 177777B, 177776B /
C     DATA RIGHT(1), RIGHT(2), RIGHT(3) / 40000B,       0,    265B /
C     DATA DIVER(1), DIVER(2), DIVER(3) / 40000B,       0,    276B /
C     DATA LOG10(1), LOG10(2), LOG10(3) / 46420B,  46502B,  77777B /
C
C     MACHINE CONSTANTS FOR THE HP 2100
C     FOUR WORD DOUBLE PRECISION OPTION WITH FTN4
C
C     DATA SMALL(1), SMALL(2) /  40000B,       0 /
C     DATA SMALL(3), SMALL(4) /       0,       1 /
C     DATA LARGE(1), LARGE(2) /  77777B, 177777B /
C     DATA LARGE(3), LARGE(4) / 177777B, 177776B /
C     DATA RIGHT(1), RIGHT(2) /  40000B,       0 /
C     DATA RIGHT(3), RIGHT(4) /       0,    225B /
C     DATA DIVER(1), DIVER(2) /  40000B,       0 /
C     DATA DIVER(3), DIVER(4) /       0,    227B /
C     DATA LOG10(1), LOG10(2) /  46420B,  46502B /
C     DATA LOG10(3), LOG10(4) /  76747B, 176377B /
C
C     MACHINE CONSTANTS FOR THE HP 9000
C
C     DATA SMALL(1), SMALL(2) / 00040000000B, 00000000000B /
C     DATA LARGE(1), LARGE(2) / 17737777777B, 37777777777B /
C     DATA RIGHT(1), RIGHT(2) / 07454000000B, 00000000000B /
C     DATA DIVER(1), DIVER(2) / 07460000000B, 00000000000B /
C     DATA LOG10(1), LOG10(2) / 07764642023B, 12047674777B /
C
C     MACHINE CONSTANTS FOR THE IBM 360/370 SERIES,
C     THE XEROX SIGMA 5/7/9, THE SEL SYSTEMS 85/86, AND
C     THE PERKIN ELMER (INTERDATA) 7/32.
C
C     DATA SMALL(1), SMALL(2) / Z00100000, Z00000000 /
C     DATA LARGE(1), LARGE(2) / Z7FFFFFFF, ZFFFFFFFF /
C     DATA RIGHT(1), RIGHT(2) / Z33100000, Z00000000 /
C     DATA DIVER(1), DIVER(2) / Z34100000, Z00000000 /
C     DATA LOG10(1), LOG10(2) / Z41134413, Z509F79FF /
C
C     MACHINE CONSTANTS FOR THE IBM PC
C     ASSUMES THAT ALL ARITHMETIC IS DONE IN DOUBLE PRECISION
C     ON 8088, I.E., NOT IN 80 BIT FORM FOR THE 8087.
C
C     DATA SMALL(1) / 2.23D-308  /
C     DATA LARGE(1) / 1.79D+308  /
C     DATA RIGHT(1) / 1.11D-16   /
C     DATA DIVER(1) / 2.22D-16   /
C     DATA LOG10(1) / 0.301029995663981195D0 /
C
C     MACHINE CONSTANTS FOR THE IBM RS 6000
C
C     DATA DMACH(1) / Z'0010000000000000' /
C     DATA DMACH(2) / Z'7FEFFFFFFFFFFFFF' /
C     DATA DMACH(3) / Z'3CA0000000000000' /
C     DATA DMACH(4) / Z'3CB0000000000000' /
C     DATA DMACH(5) / Z'3FD34413509F79FF' /
C
C     MACHINE CONSTANTS FOR THE INTEL i860
C
C     DATA DMACH(1) / Z'0010000000000000' /
C     DATA DMACH(2) / Z'7FEFFFFFFFFFFFFF' /
C     DATA DMACH(3) / Z'3CA0000000000000' /
C     DATA DMACH(4) / Z'3CB0000000000000' /
C     DATA DMACH(5) / Z'3FD34413509F79FF' /
C
C     MACHINE CONSTANTS FOR THE PDP-10 (KA PROCESSOR)
C
C     DATA SMALL(1), SMALL(2) / "033400000000, "000000000000 /
C     DATA LARGE(1), LARGE(2) / "377777777777, "344777777777 /
C     DATA RIGHT(1), RIGHT(2) / "113400000000, "000000000000 /
C     DATA DIVER(1), DIVER(2) / "114400000000, "000000000000 /
C     DATA LOG10(1), LOG10(2) / "177464202324, "144117571776 /
C
C     MACHINE CONSTANTS FOR THE PDP-10 (KI PROCESSOR)
C
C     DATA SMALL(1), SMALL(2) / "000400000000, "000000000000 /
C     DATA LARGE(1), LARGE(2) / "377777777777, "377777777777 /
C     DATA RIGHT(1), RIGHT(2) / "103400000000, "000000000000 /
C     DATA DIVER(1), DIVER(2) / "104400000000, "000000000000 /
C     DATA LOG10(1), LOG10(2) / "177464202324, "476747767461 /
C
C     MACHINE CONSTANTS FOR PDP-11 FORTRAN SUPPORTING
C     32-BIT INTEGERS (EXPRESSED IN INTEGER AND OCTAL).
C
C     DATA SMALL(1), SMALL(2) /    8388608,           0 /
C     DATA LARGE(1), LARGE(2) / 2147483647,          -1 /
C     DATA RIGHT(1), RIGHT(2) /  612368384,           0 /
C     DATA DIVER(1), DIVER(2) /  620756992,           0 /
C     DATA LOG10(1), LOG10(2) / 1067065498, -2063872008 /
C
C     DATA SMALL(1), SMALL(2) / O00040000000, O00000000000 /
C     DATA LARGE(1), LARGE(2) / O17777777777, O37777777777 /
C     DATA RIGHT(1), RIGHT(2) / O04440000000, O00000000000 /
C     DATA DIVER(1), DIVER(2) / O04500000000, O00000000000 /
C     DATA LOG10(1), LOG10(2) / O07746420232, O20476747770 /
C
C     MACHINE CONSTANTS FOR PDP-11 FORTRAN SUPPORTING
C     16-BIT INTEGERS (EXPRESSED IN INTEGER AND OCTAL).
C
C     DATA SMALL(1), SMALL(2) /    128,      0 /
C     DATA SMALL(3), SMALL(4) /      0,      0 /
C     DATA LARGE(1), LARGE(2) /  32767,     -1 /
C     DATA LARGE(3), LARGE(4) /     -1,     -1 /
C     DATA RIGHT(1), RIGHT(2) /   9344,      0 /
C     DATA RIGHT(3), RIGHT(4) /      0,      0 /
C     DATA DIVER(1), DIVER(2) /   9472,      0 /
C     DATA DIVER(3), DIVER(4) /      0,      0 /
C     DATA LOG10(1), LOG10(2) /  16282,   8346 /
C     DATA LOG10(3), LOG10(4) / -31493, -12296 /
C
C     DATA SMALL(1), SMALL(2) / O000200, O000000 /
C     DATA SMALL(3), SMALL(4) / O000000, O000000 /
C     DATA LARGE(1), LARGE(2) / O077777, O177777 /
C     DATA LARGE(3), LARGE(4) / O177777, O177777 /
C     DATA RIGHT(1), RIGHT(2) / O022200, O000000 /
C     DATA RIGHT(3), RIGHT(4) / O000000, O000000 /
C     DATA DIVER(1), DIVER(2) / O022400, O000000 /
C     DATA DIVER(3), DIVER(4) / O000000, O000000 /
C     DATA LOG10(1), LOG10(2) / O037632, O020232 /
C     DATA LOG10(3), LOG10(4) / O102373, O147770 /
C
C     MACHINE CONSTANTS FOR THE SUN
C
C     DATA DMACH(1) / Z'0010000000000000' /
C     DATA DMACH(2) / Z'7FEFFFFFFFFFFFFF' /
C     DATA DMACH(3) / Z'3CA0000000000000' /
C     DATA DMACH(4) / Z'3CB0000000000000' /
C     DATA DMACH(5) / Z'3FD34413509F79FF' /
C
C     MACHINE CONSTANTS FOR THE SUN
C     USING THE -r8 COMPILER OPTION
C
C     DATA DMACH(1) / Z'00010000000000000000000000000000' /
C     DATA DMACH(2) / Z'7FFEFFFFFFFFFFFFFFFFFFFFFFFFFFFF' /
C     DATA DMACH(3) / Z'3F8E0000000000000000000000000000' /
C     DATA DMACH(4) / Z'3F8F0000000000000000000000000000' /
C     DATA DMACH(5) / Z'3FFD34413509F79FEF311F12B35816F9' /
C
C     MACHINE CONSTANTS FOR THE SUN 386i
C
C     DATA SMALL(1), SMALL(2) / Z'FFFFFFFD', Z'000FFFFF' /
C     DATA LARGE(1), LARGE(2) / Z'FFFFFFB0', Z'7FEFFFFF' /
C     DATA RIGHT(1), RIGHT(2) / Z'000000B0', Z'3CA00000' /
C     DATA DIVER(1), DIVER(2) / Z'FFFFFFCB', Z'3CAFFFFF'
C     DATA LOG10(1), LOG10(2) / Z'509F79E9', Z'3FD34413' /
C
C     MACHINE CONSTANTS FOR THE UNIVAC 1100 SERIES FTN COMPILER
C
C     DATA SMALL(1), SMALL(2) / O000040000000, O000000000000 /
C     DATA LARGE(1), LARGE(2) / O377777777777, O777777777777 /
C     DATA RIGHT(1), RIGHT(2) / O170540000000, O000000000000 /
C     DATA DIVER(1), DIVER(2) / O170640000000, O000000000000 /
C     DATA LOG10(1), LOG10(2) / O177746420232, O411757177572 /
C
C     MACHINE CONSTANTS FOR THE VAX (D-FLOATING)
C     (EXPRESSED IN INTEGER AND HEXADECIMAL)
C     THE HEX FORMAT BELOW MAY NOT BE SUITABLE FOR UNIX SYSYEMS
C     THE INTEGER FORMAT SHOULD BE OK FOR UNIX SYSTEMS
C
C     DATA SMALL(1), SMALL(2) /        128,           0 /
C     DATA LARGE(1), LARGE(2) /     -32769,          -1 /
C     DATA RIGHT(1), RIGHT(2) /       9344,           0 /
C     DATA DIVER(1), DIVER(2) /       9472,           0 /
C     DATA LOG10(1), LOG10(2) /  546979738,  -805796613 /
C
C     DATA SMALL(1), SMALL(2) / Z00000080, Z00000000 /
C     DATA LARGE(1), LARGE(2) / ZFFFF7FFF, ZFFFFFFFF /
C     DATA RIGHT(1), RIGHT(2) / Z00002480, Z00000000 /
C     DATA DIVER(1), DIVER(2) / Z00002500, Z00000000 /
C     DATA LOG10(1), LOG10(2) / Z209A3F9A, ZCFF884FB /
C
C     MACHINE CONSTANTS FOR THE VAX (G-FLOATING)
C     (EXPRESSED IN INTEGER AND HEXADECIMAL)
C     THE HEX FORMAT BELOW MAY NOT BE SUITABLE FOR UNIX SYSYEMS
C     THE INTEGER FORMAT SHOULD BE OK FOR UNIX SYSTEMS
C
C     DATA SMALL(1), SMALL(2) /         16,           0 /
C     DATA LARGE(1), LARGE(2) /     -32769,          -1 /
C     DATA RIGHT(1), RIGHT(2) /      15552,           0 /
C     DATA DIVER(1), DIVER(2) /      15568,           0 /
C     DATA LOG10(1), LOG10(2) /  1142112243, 2046775455 /
C
C     DATA SMALL(1), SMALL(2) / Z00000010, Z00000000 /
C     DATA LARGE(1), LARGE(2) / ZFFFF7FFF, ZFFFFFFFF /
C     DATA RIGHT(1), RIGHT(2) / Z00003CC0, Z00000000 /
C     DATA DIVER(1), DIVER(2) / Z00003CD0, Z00000000 /
C     DATA LOG10(1), LOG10(2) / Z44133FF3, Z79FF509F /
C
C***FIRST EXECUTABLE STATEMENT  D1MACH
      IF (I .LT. 1 .OR. I .GT. 5) CALL XERMSG ('SLATEC', 'D1MACH',
     +   'I OUT OF BOUNDS', 1, 2)
C
      D1MACH = DMACH(I)
      RETURN
C
      END


C---------------------------------------------------------------
C d9lgmc.f
C---------------------------------------------------------------

*DECK D9LGMC
      DOUBLE PRECISION FUNCTION D9LGMC (X)
C***BEGIN PROLOGUE  D9LGMC
C***SUBSIDIARY
C***PURPOSE  Compute the log Gamma correction factor so that
C            LOG(DGAMMA(X)) = LOG(SQRT(2*PI)) + (X-5.)*LOG(X) - X
C            + D9LGMC(X).
C***LIBRARY   SLATEC (FNLIB)
C***CATEGORY  C7E
C***TYPE      DOUBLE PRECISION (R9LGMC-S, D9LGMC-D, C9LGMC-C)
C***KEYWORDS  COMPLETE GAMMA FUNCTION, CORRECTION TERM, FNLIB,
C             LOG GAMMA, LOGARITHM, SPECIAL FUNCTIONS
C***AUTHOR  Fullerton, W., (LANL)
C***DESCRIPTION
C
C Compute the log gamma correction factor for X .GE. 10. so that
C LOG (DGAMMA(X)) = LOG(SQRT(2*PI)) + (X-.5)*LOG(X) - X + D9lGMC(X)
C
C Series for ALGM       on the interval  0.          to  1.00000E-02
C                                        with weighted error   1.28E-31
C                                         log weighted error  30.89
C                               significant figures required  29.81
C                                    decimal places required  31.48
C
C***REFERENCES  (NONE)
C***ROUTINES CALLED  D1MACH, DCSEVL, INITDS, XERMSG
C***REVISION HISTORY  (YYMMDD)
C   770601  DATE WRITTEN
C   890531  Changed all specific intrinsics to generic.  (WRB)
C   890531  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   900315  CALLs to XERROR changed to CALLs to XERMSG.  (THJ)
C   900720  Routine changed from user-callable to subsidiary.  (WRB)
C***END PROLOGUE  D9LGMC
      DOUBLE PRECISION X, ALGMCS(15), XBIG, XMAX, DCSEVL, D1MACH
      LOGICAL FIRST
      SAVE ALGMCS, NALGM, XBIG, XMAX, FIRST
      DATA ALGMCS(  1) / +.1666389480 4518632472 0572965082 2 D+0      /
      DATA ALGMCS(  2) / -.1384948176 0675638407 3298605913 5 D-4      /
      DATA ALGMCS(  3) / +.9810825646 9247294261 5717154748 7 D-8      /
      DATA ALGMCS(  4) / -.1809129475 5724941942 6330626671 9 D-10     /
      DATA ALGMCS(  5) / +.6221098041 8926052271 2601554341 6 D-13     /
      DATA ALGMCS(  6) / -.3399615005 4177219443 0333059966 6 D-15     /
      DATA ALGMCS(  7) / +.2683181998 4826987489 5753884666 6 D-17     /
      DATA ALGMCS(  8) / -.2868042435 3346432841 4462239999 9 D-19     /
      DATA ALGMCS(  9) / +.3962837061 0464348036 7930666666 6 D-21     /
      DATA ALGMCS( 10) / -.6831888753 9857668701 1199999999 9 D-23     /
      DATA ALGMCS( 11) / +.1429227355 9424981475 7333333333 3 D-24     /
      DATA ALGMCS( 12) / -.3547598158 1010705471 9999999999 9 D-26     /
      DATA ALGMCS( 13) / +.1025680058 0104709120 0000000000 0 D-27     /
      DATA ALGMCS( 14) / -.3401102254 3167487999 9999999999 9 D-29     /
      DATA ALGMCS( 15) / +.1276642195 6300629333 3333333333 3 D-30     /
      DATA FIRST /.TRUE./
C***FIRST EXECUTABLE STATEMENT  D9LGMC
      IF (FIRST) THEN
         NALGM = INITDS (ALGMCS, 15, REAL(D1MACH(3)) )
         XBIG = 1.0D0/SQRT(D1MACH(3))
         XMAX = EXP (MIN(LOG(D1MACH(2)/12.D0), -LOG(12.D0*D1MACH(1))))
      ENDIF
      FIRST = .FALSE.
C
      IF (X .LT. 10.D0) CALL XERMSG ('SLATEC', 'D9LGMC',
     +   'X MUST BE GE 10', 1, 2)
      IF (X.GE.XMAX) GO TO 20
C
      D9LGMC = 1.D0/(12.D0*X)
      IF (X.LT.XBIG) D9LGMC = DCSEVL (2.0D0*(10.D0/X)**2-1.D0, ALGMCS,
     1  NALGM) / X
      RETURN
C
 20   D9LGMC = 0.D0
      CALL XERMSG ('SLATEC', 'D9LGMC', 'X SO BIG D9LGMC UNDERFLOWS', 2,
     +   1)
      RETURN
C
      END

C---------------------------------------------------------------
C dbesi0.f
C---------------------------------------------------------------

*DECK DBESI0
      DOUBLE PRECISION FUNCTION DBESI0 (X)
C***BEGIN PROLOGUE  DBESI0
C***PURPOSE  Compute the hyperbolic Bessel function of the first kind
C            of order zero.
C***LIBRARY   SLATEC (FNLIB)
C***CATEGORY  C10B1
C***TYPE      DOUBLE PRECISION (BESI0-S, DBESI0-D)
C***KEYWORDS  FIRST KIND, FNLIB, HYPERBOLIC BESSEL FUNCTION,
C             MODIFIED BESSEL FUNCTION, ORDER ZERO, SPECIAL FUNCTIONS
C***AUTHOR  Fullerton, W., (LANL)
C***DESCRIPTION
C
C DBESI0(X) calculates the double precision modified (hyperbolic)
C Bessel function of the first kind of order zero and double
C precision argument X.
C
C Series for BI0        on the interval  0.          to  9.00000E+00
C                                        with weighted error   9.51E-34
C                                         log weighted error  33.02
C                               significant figures required  33.31
C                                    decimal places required  33.65
C
C***REFERENCES  (NONE)
C***ROUTINES CALLED  D1MACH, DBSI0E, DCSEVL, INITDS, XERMSG
C***REVISION HISTORY  (YYMMDD)
C   770701  DATE WRITTEN
C   890531  Changed all specific intrinsics to generic.  (WRB)
C   890531  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   900315  CALLs to XERROR changed to CALLs to XERMSG.  (THJ)
C***END PROLOGUE  DBESI0
      DOUBLE PRECISION X, BI0CS(18), XMAX, XSML, Y, D1MACH,
     1  DCSEVL, DBSI0E
      LOGICAL FIRST
      SAVE BI0CS, NTI0, XSML, XMAX, FIRST
      DATA BI0CS(  1) / -.7660547252 8391449510 8189497624 3285 D-1   /
      DATA BI0CS(  2) / +.1927337953 9938082699 5240875088 1196 D+1   /
      DATA BI0CS(  3) / +.2282644586 9203013389 3702929233 0415 D+0   /
      DATA BI0CS(  4) / +.1304891466 7072904280 7933421069 1888 D-1   /
      DATA BI0CS(  5) / +.4344270900 8164874513 7868268102 6107 D-3   /
      DATA BI0CS(  6) / +.9422657686 0019346639 2317174411 8766 D-5   /
      DATA BI0CS(  7) / +.1434006289 5106910799 6209187817 9957 D-6   /
      DATA BI0CS(  8) / +.1613849069 6617490699 1541971999 4611 D-8   /
      DATA BI0CS(  9) / +.1396650044 5356696994 9509270814 2522 D-10  /
      DATA BI0CS( 10) / +.9579451725 5054453446 2752317189 3333 D-13  /
      DATA BI0CS( 11) / +.5333981859 8625021310 1510774400 0000 D-15  /
      DATA BI0CS( 12) / +.2458716088 4374707746 9678591999 9999 D-17  /
      DATA BI0CS( 13) / +.9535680890 2487700269 4434133333 3333 D-20  /
      DATA BI0CS( 14) / +.3154382039 7214273367 8933333333 3333 D-22  /
      DATA BI0CS( 15) / +.9004564101 0946374314 6666666666 6666 D-25  /
      DATA BI0CS( 16) / +.2240647369 1236700160 0000000000 0000 D-27  /
      DATA BI0CS( 17) / +.4903034603 2428373333 3333333333 3333 D-30  /
      DATA BI0CS( 18) / +.9508172606 1226666666 6666666666 6666 D-33  /
      DATA FIRST /.TRUE./
C***FIRST EXECUTABLE STATEMENT  DBESI0
      IF (FIRST) THEN
         NTI0 = INITDS (BI0CS, 18, 0.1*REAL(D1MACH(3)))
         XSML = SQRT(4.5D0*D1MACH(3))
         XMAX = LOG (D1MACH(2))
      ENDIF
      FIRST = .FALSE.
C
      Y = ABS(X)
      IF (Y.GT.3.0D0) GO TO 20
C
      DBESI0 = 1.0D0
      IF (Y.GT.XSML) DBESI0 = 2.75D0 + DCSEVL (Y*Y/4.5D0-1.D0, BI0CS,
     1  NTI0)
      RETURN
C
 20   IF (Y .GT. XMAX) CALL XERMSG ('SLATEC', 'DBESI0',
     +   'ABS(X) SO BIG I0 OVERFLOWS', 2, 2)
C
      DBESI0 = EXP(Y) * DBSI0E(X)
C
      RETURN
      END

C---------------------------------------------------------------
C dbesk0.f
C---------------------------------------------------------------

*DECK DBESK0
      DOUBLE PRECISION FUNCTION DBESK0 (X)
C***BEGIN PROLOGUE  DBESK0
C***PURPOSE  Compute the modified (hyperbolic) Bessel function of the
C            third kind of order zero.
C***LIBRARY   SLATEC (FNLIB)
C***CATEGORY  C10B1
C***TYPE      DOUBLE PRECISION (BESK0-S, DBESK0-D)
C***KEYWORDS  FNLIB, HYPERBOLIC BESSEL FUNCTION,
C             MODIFIED BESSEL FUNCTION, ORDER ZERO, SPECIAL FUNCTIONS,
C             THIRD KIND
C***AUTHOR  Fullerton, W., (LANL)
C***DESCRIPTION
C
C DBESK0(X) calculates the double precision modified (hyperbolic)
C Bessel function of the third kind of order zero for double
C precision argument X.  The argument must be greater than zero
C but not so large that the result underflows.
C
C Series for BK0        on the interval  0.          to  4.00000E+00
C                                        with weighted error   3.08E-33
C                                         log weighted error  32.51
C                               significant figures required  32.05
C                                    decimal places required  33.11
C
C***REFERENCES  (NONE)
C***ROUTINES CALLED  D1MACH, DBESI0, DBSK0E, DCSEVL, INITDS, XERMSG
C***REVISION HISTORY  (YYMMDD)
C   770701  DATE WRITTEN
C   890531  Changed all specific intrinsics to generic.  (WRB)
C   890531  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   900315  CALLs to XERROR changed to CALLs to XERMSG.  (THJ)
C***END PROLOGUE  DBESK0
      DOUBLE PRECISION X, BK0CS(16), XMAX, XMAXT, XSML, Y,
     1  D1MACH, DCSEVL, DBESI0, DBSK0E
      LOGICAL FIRST
      SAVE BK0CS, NTK0, XSML, XMAX, FIRST
      DATA BK0CS(  1) / -.3532739323 3902768720 1140060063 153 D-1    /
      DATA BK0CS(  2) / +.3442898999 2462848688 6344927529 213 D+0    /
      DATA BK0CS(  3) / +.3597993651 5361501626 5721303687 231 D-1    /
      DATA BK0CS(  4) / +.1264615411 4469259233 8479508673 447 D-2    /
      DATA BK0CS(  5) / +.2286212103 1194517860 8269830297 585 D-4    /
      DATA BK0CS(  6) / +.2534791079 0261494573 0790013428 354 D-6    /
      DATA BK0CS(  7) / +.1904516377 2202088589 7214059381 366 D-8    /
      DATA BK0CS(  8) / +.1034969525 7633624585 1008317853 089 D-10   /
      DATA BK0CS(  9) / +.4259816142 7910825765 2445327170 133 D-13   /
      DATA BK0CS( 10) / +.1374465435 8807508969 4238325440 000 D-15   /
      DATA BK0CS( 11) / +.3570896528 5083735909 9688597333 333 D-18   /
      DATA BK0CS( 12) / +.7631643660 1164373766 7498666666 666 D-21   /
      DATA BK0CS( 13) / +.1365424988 4407818590 8053333333 333 D-23   /
      DATA BK0CS( 14) / +.2075275266 9066680831 9999999999 999 D-26   /
      DATA BK0CS( 15) / +.2712814218 0729856000 0000000000 000 D-29   /
      DATA BK0CS( 16) / +.3082593887 9146666666 6666666666 666 D-32   /
      DATA FIRST /.TRUE./
C***FIRST EXECUTABLE STATEMENT  DBESK0
      IF (FIRST) THEN
         NTK0 = INITDS (BK0CS, 16, 0.1*REAL(D1MACH(3)))
         XSML = SQRT(4.0D0*D1MACH(3))
         XMAXT = -LOG(D1MACH(1))
         XMAX = XMAXT - 0.5D0*XMAXT*LOG(XMAXT)/(XMAXT+0.5D0)
      ENDIF
      FIRST = .FALSE.
C
      IF (X .LE. 0.D0) CALL XERMSG ('SLATEC', 'DBESK0',
     +   'X IS ZERO OR NEGATIVE', 2, 2)
      IF (X.GT.2.0D0) GO TO 20
C
      Y = 0.D0
      IF (X.GT.XSML) Y = X*X
      DBESK0 = -LOG(0.5D0*X)*DBESI0(X) - 0.25D0 + DCSEVL (.5D0*Y-1.D0,
     1  BK0CS, NTK0)
      RETURN
C
 20   DBESK0 = 0.D0
      IF (X .GT. XMAX) CALL XERMSG ('SLATEC', 'DBESK0',
     +   'X SO BIG K0 UNDERFLOWS', 1, 1)
      IF (X.GT.XMAX) RETURN
C
      DBESK0 = EXP(-X) * DBSK0E(X)
C
      RETURN
      END

C---------------------------------------------------------------
C dbsi0e.f
C---------------------------------------------------------------

*DECK DBSI0E
      DOUBLE PRECISION FUNCTION DBSI0E (X)
C***BEGIN PROLOGUE  DBSI0E
C***PURPOSE  Compute the exponentially scaled modified (hyperbolic)
C            Bessel function of the first kind of order zero.
C***LIBRARY   SLATEC (FNLIB)
C***CATEGORY  C10B1
C***TYPE      DOUBLE PRECISION (BESI0E-S, DBSI0E-D)
C***KEYWORDS  EXPONENTIALLY SCALED, FIRST KIND, FNLIB,
C             HYPERBOLIC BESSEL FUNCTION, MODIFIED BESSEL FUNCTION,
C             ORDER ZERO, SPECIAL FUNCTIONS
C***AUTHOR  Fullerton, W., (LANL)
C***DESCRIPTION
C
C DBSI0E(X) calculates the double precision exponentially scaled
C modified (hyperbolic) Bessel function of the first kind of order
C zero for double precision argument X.  The result is the Bessel
C function I0(X) multiplied by EXP(-ABS(X)).
C
C Series for BI0        on the interval  0.          to  9.00000E+00
C                                        with weighted error   9.51E-34
C                                         log weighted error  33.02
C                               significant figures required  33.31
C                                    decimal places required  33.65
C
C Series for AI0        on the interval  1.25000E-01 to  3.33333E-01
C                                        with weighted error   2.74E-32
C                                         log weighted error  31.56
C                               significant figures required  30.15
C                                    decimal places required  32.39
C
C Series for AI02       on the interval  0.          to  1.25000E-01
C                                        with weighted error   1.97E-32
C                                         log weighted error  31.71
C                               significant figures required  30.15
C                                    decimal places required  32.63
C
C***REFERENCES  (NONE)
C***ROUTINES CALLED  D1MACH, DCSEVL, INITDS
C***REVISION HISTORY  (YYMMDD)
C   770701  DATE WRITTEN
C   890531  Changed all specific intrinsics to generic.  (WRB)
C   890531  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C***END PROLOGUE  DBSI0E
      DOUBLE PRECISION X, BI0CS(18), AI0CS(46), AI02CS(69),
     1  XSML, Y, D1MACH, DCSEVL
      LOGICAL FIRST
      SAVE BI0CS, AI0CS, AI02CS, NTI0, NTAI0, NTAI02, XSML, FIRST
      DATA BI0CS(  1) / -.7660547252 8391449510 8189497624 3285 D-1   /
      DATA BI0CS(  2) / +.1927337953 9938082699 5240875088 1196 D+1   /
      DATA BI0CS(  3) / +.2282644586 9203013389 3702929233 0415 D+0   /
      DATA BI0CS(  4) / +.1304891466 7072904280 7933421069 1888 D-1   /
      DATA BI0CS(  5) / +.4344270900 8164874513 7868268102 6107 D-3   /
      DATA BI0CS(  6) / +.9422657686 0019346639 2317174411 8766 D-5   /
      DATA BI0CS(  7) / +.1434006289 5106910799 6209187817 9957 D-6   /
      DATA BI0CS(  8) / +.1613849069 6617490699 1541971999 4611 D-8   /
      DATA BI0CS(  9) / +.1396650044 5356696994 9509270814 2522 D-10  /
      DATA BI0CS( 10) / +.9579451725 5054453446 2752317189 3333 D-13  /
      DATA BI0CS( 11) / +.5333981859 8625021310 1510774400 0000 D-15  /
      DATA BI0CS( 12) / +.2458716088 4374707746 9678591999 9999 D-17  /
      DATA BI0CS( 13) / +.9535680890 2487700269 4434133333 3333 D-20  /
      DATA BI0CS( 14) / +.3154382039 7214273367 8933333333 3333 D-22  /
      DATA BI0CS( 15) / +.9004564101 0946374314 6666666666 6666 D-25  /
      DATA BI0CS( 16) / +.2240647369 1236700160 0000000000 0000 D-27  /
      DATA BI0CS( 17) / +.4903034603 2428373333 3333333333 3333 D-30  /
      DATA BI0CS( 18) / +.9508172606 1226666666 6666666666 6666 D-33  /
      DATA AI0CS(  1) / +.7575994494 0237959427 2987203743 8 D-1      /
      DATA AI0CS(  2) / +.7591380810 8233455072 9297873320 4 D-2      /
      DATA AI0CS(  3) / +.4153131338 9237505018 6319749138 2 D-3      /
      DATA AI0CS(  4) / +.1070076463 4390730735 8242970217 0 D-4      /
      DATA AI0CS(  5) / -.7901179979 2128946607 5031948573 0 D-5      /
      DATA AI0CS(  6) / -.7826143501 4387522697 8898980690 9 D-6      /
      DATA AI0CS(  7) / +.2783849942 9488708063 8118538985 7 D-6      /
      DATA AI0CS(  8) / +.8252472600 6120271919 6682913319 8 D-8      /
      DATA AI0CS(  9) / -.1204463945 5201991790 5496089110 3 D-7      /
      DATA AI0CS( 10) / +.1559648598 5060764436 1228752792 8 D-8      /
      DATA AI0CS( 11) / +.2292556367 1033165434 7725480285 7 D-9      /
      DATA AI0CS( 12) / -.1191622884 2790646036 7777423447 8 D-9      /
      DATA AI0CS( 13) / +.1757854916 0324098302 1833124774 3 D-10     /
      DATA AI0CS( 14) / +.1128224463 2189005171 4441135682 4 D-11     /
      DATA AI0CS( 15) / -.1146848625 9272988777 2963387698 2 D-11     /
      DATA AI0CS( 16) / +.2715592054 8036628726 4365192160 6 D-12     /
      DATA AI0CS( 17) / -.2415874666 5626878384 4247572028 1 D-13     /
      DATA AI0CS( 18) / -.6084469888 2551250646 0609963922 4 D-14     /
      DATA AI0CS( 19) / +.3145705077 1754772937 0836026730 3 D-14     /
      DATA AI0CS( 20) / -.7172212924 8711877179 6217505917 6 D-15     /
      DATA AI0CS( 21) / +.7874493403 4541033960 8390960332 7 D-16     /
      DATA AI0CS( 22) / +.1004802753 0094624023 4524457183 9 D-16     /
      DATA AI0CS( 23) / -.7566895365 3505348534 2843588881 0 D-17     /
      DATA AI0CS( 24) / +.2150380106 8761198878 1205128784 5 D-17     /
      DATA AI0CS( 25) / -.3754858341 8308744291 5158445260 8 D-18     /
      DATA AI0CS( 26) / +.2354065842 2269925769 0075710532 2 D-19     /
      DATA AI0CS( 27) / +.1114667612 0479285302 2637335511 0 D-19     /
      DATA AI0CS( 28) / -.5398891884 3969903786 9677932270 9 D-20     /
      DATA AI0CS( 29) / +.1439598792 2407526770 4285840452 2 D-20     /
      DATA AI0CS( 30) / -.2591916360 1110934064 6081840196 2 D-21     /
      DATA AI0CS( 31) / +.2238133183 9985839074 3409229824 0 D-22     /
      DATA AI0CS( 32) / +.5250672575 3647711727 7221683199 9 D-23     /
      DATA AI0CS( 33) / -.3249904138 5332307841 7343228586 6 D-23     /
      DATA AI0CS( 34) / +.9924214103 2050379278 5728471040 0 D-24     /
      DATA AI0CS( 35) / -.2164992254 2446695231 4655429973 3 D-24     /
      DATA AI0CS( 36) / +.3233609471 9435940839 7333299199 9 D-25     /
      DATA AI0CS( 37) / -.1184620207 3967424898 2473386666 6 D-26     /
      DATA AI0CS( 38) / -.1281671853 9504986505 4833868799 9 D-26     /
      DATA AI0CS( 39) / +.5827015182 2793905116 0556885333 3 D-27     /
      DATA AI0CS( 40) / -.1668222326 0261097193 6450150399 9 D-27     /
      DATA AI0CS( 41) / +.3625309510 5415699757 0068480000 0 D-28     /
      DATA AI0CS( 42) / -.5733627999 0557135899 4595839999 9 D-29     /
      DATA AI0CS( 43) / +.3736796722 0630982296 4258133333 3 D-30     /
      DATA AI0CS( 44) / +.1602073983 1568519633 6551253333 3 D-30     /
      DATA AI0CS( 45) / -.8700424864 0572298845 2249599999 9 D-31     /
      DATA AI0CS( 46) / +.2741320937 9374811456 0341333333 3 D-31     /
      DATA AI02CS(  1) / +.5449041101 4108831607 8960962268 0 D-1      /
      DATA AI02CS(  2) / +.3369116478 2556940898 9785662979 9 D-2      /
      DATA AI02CS(  3) / +.6889758346 9168239842 6263914301 1 D-4      /
      DATA AI02CS(  4) / +.2891370520 8347564829 6692402323 2 D-5      /
      DATA AI02CS(  5) / +.2048918589 4690637418 2760534093 1 D-6      /
      DATA AI02CS(  6) / +.2266668990 4981780645 9327743136 1 D-7      /
      DATA AI02CS(  7) / +.3396232025 7083863451 5084396952 3 D-8      /
      DATA AI02CS(  8) / +.4940602388 2249695891 0482449783 5 D-9      /
      DATA AI02CS(  9) / +.1188914710 7846438342 4084525196 3 D-10     /
      DATA AI02CS( 10) / -.3149916527 9632413645 3864862961 9 D-10     /
      DATA AI02CS( 11) / -.1321581184 0447713118 7540739926 7 D-10     /
      DATA AI02CS( 12) / -.1794178531 5068061177 7943574026 9 D-11     /
      DATA AI02CS( 13) / +.7180124451 3836662336 7106429346 9 D-12     /
      DATA AI02CS( 14) / +.3852778382 7421427011 4089801777 6 D-12     /
      DATA AI02CS( 15) / +.1540086217 5214098269 1325823339 7 D-13     /
      DATA AI02CS( 16) / -.4150569347 2872220866 2689972015 6 D-13     /
      DATA AI02CS( 17) / -.9554846698 8283076487 0214494312 5 D-14     /
      DATA AI02CS( 18) / +.3811680669 3526224207 4605535511 8 D-14     /
      DATA AI02CS( 19) / +.1772560133 0565263836 0493266675 8 D-14     /
      DATA AI02CS( 20) / -.3425485619 6772191346 1924790328 2 D-15     /
      DATA AI02CS( 21) / -.2827623980 5165834849 4205593759 4 D-15     /
      DATA AI02CS( 22) / +.3461222867 6974610930 9706250813 4 D-16     /
      DATA AI02CS( 23) / +.4465621420 2967599990 1042054284 3 D-16     /
      DATA AI02CS( 24) / -.4830504485 9441820712 5525403795 4 D-17     /
      DATA AI02CS( 25) / -.7233180487 8747539545 6227240924 5 D-17     /
      DATA AI02CS( 26) / +.9921475412 1736985988 8046093981 0 D-18     /
      DATA AI02CS( 27) / +.1193650890 8459820855 0439949924 2 D-17     /
      DATA AI02CS( 28) / -.2488709837 1508072357 2054491660 2 D-18     /
      DATA AI02CS( 29) / -.1938426454 1609059289 8469781132 6 D-18     /
      DATA AI02CS( 30) / +.6444656697 3734438687 8301949394 9 D-19     /
      DATA AI02CS( 31) / +.2886051596 2892243264 8171383073 4 D-19     /
      DATA AI02CS( 32) / -.1601954907 1749718070 6167156200 7 D-19     /
      DATA AI02CS( 33) / -.3270815010 5923147208 9193567485 9 D-20     /
      DATA AI02CS( 34) / +.3686932283 8264091811 4600723939 3 D-20     /
      DATA AI02CS( 35) / +.1268297648 0309501530 1359529710 9 D-22     /
      DATA AI02CS( 36) / -.7549825019 3772739076 9636664410 1 D-21     /
      DATA AI02CS( 37) / +.1502133571 3778353496 3712789053 4 D-21     /
      DATA AI02CS( 38) / +.1265195883 5096485349 3208799248 3 D-21     /
      DATA AI02CS( 39) / -.6100998370 0836807086 2940891600 2 D-22     /
      DATA AI02CS( 40) / -.1268809629 2601282643 6872095924 2 D-22     /
      DATA AI02CS( 41) / +.1661016099 8907414578 4038487490 5 D-22     /
      DATA AI02CS( 42) / -.1585194335 7658855793 7970504881 4 D-23     /
      DATA AI02CS( 43) / -.3302645405 9682178009 5381766755 6 D-23     /
      DATA AI02CS( 44) / +.1313580902 8392397817 4039623117 4 D-23     /
      DATA AI02CS( 45) / +.3689040246 6711567933 1425637280 4 D-24     /
      DATA AI02CS( 46) / -.4210141910 4616891492 1978247249 9 D-24     /
      DATA AI02CS( 47) / +.4791954591 0828657806 3171401373 0 D-25     /
      DATA AI02CS( 48) / +.8459470390 2218217952 9971707412 4 D-25     /
      DATA AI02CS( 49) / -.4039800940 8728324931 4607937181 0 D-25     /
      DATA AI02CS( 50) / -.6434714653 6504313473 0100850469 5 D-26     /
      DATA AI02CS( 51) / +.1225743398 8756659903 4464736990 5 D-25     /
      DATA AI02CS( 52) / -.2934391316 0257089231 9879821175 4 D-26     /
      DATA AI02CS( 53) / -.1961311309 1949829262 0371205728 9 D-26     /
      DATA AI02CS( 54) / +.1503520374 8221934241 6229900309 8 D-26     /
      DATA AI02CS( 55) / -.9588720515 7448265520 3386388206 9 D-28     /
      DATA AI02CS( 56) / -.3483339380 8170454863 9441108511 4 D-27     /
      DATA AI02CS( 57) / +.1690903610 2630436730 6244960725 6 D-27     /
      DATA AI02CS( 58) / +.1982866538 7356030438 9400115718 8 D-28     /
      DATA AI02CS( 59) / -.5317498081 4918162145 7583002528 4 D-28     /
      DATA AI02CS( 60) / +.1803306629 8883929462 3501450390 1 D-28     /
      DATA AI02CS( 61) / +.6213093341 4548931758 8405311242 2 D-29     /
      DATA AI02CS( 62) / -.7692189292 7721618632 0072806673 0 D-29     /
      DATA AI02CS( 63) / +.1858252826 1117025426 2556016596 3 D-29     /
      DATA AI02CS( 64) / +.1237585142 2813957248 9927154554 1 D-29     /
      DATA AI02CS( 65) / -.1102259120 4092238032 1779478779 2 D-29     /
      DATA AI02CS( 66) / +.1886287118 0397044900 7787447943 1 D-30     /
      DATA AI02CS( 67) / +.2160196872 2436589131 4903141406 0 D-30     /
      DATA AI02CS( 68) / -.1605454124 9197432005 8446594965 5 D-30     /
      DATA AI02CS( 69) / +.1965352984 5942906039 3884807331 8 D-31     /
      DATA FIRST /.TRUE./
C***FIRST EXECUTABLE STATEMENT  DBSI0E
      IF (FIRST) THEN
         ETA = 0.1*REAL(D1MACH(3))
         NTI0 = INITDS (BI0CS, 18, ETA)
         NTAI0 = INITDS (AI0CS, 46, ETA)
         NTAI02 = INITDS (AI02CS, 69, ETA)
         XSML = SQRT(4.5D0*D1MACH(3))
      ENDIF
      FIRST = .FALSE.
C
      Y = ABS(X)
      IF (Y.GT.3.0D0) GO TO 20
C
      DBSI0E = 1.0D0 - X
      IF (Y.GT.XSML) DBSI0E = EXP(-Y) * (2.75D0 +
     1  DCSEVL (Y*Y/4.5D0-1.D0, BI0CS, NTI0) )
      RETURN
C
 20   IF (Y.LE.8.D0) DBSI0E = (0.375D0 + DCSEVL ((48.D0/Y-11.D0)/5.D0,
     1  AI0CS, NTAI0))/SQRT(Y)
      IF (Y.GT.8.D0) DBSI0E = (0.375D0 + DCSEVL (16.D0/Y-1.D0, AI02CS,
     1  NTAI02))/SQRT(Y)
C
      RETURN
      END

C---------------------------------------------------------------
C dbsk0e.f
C---------------------------------------------------------------

*DECK DBSK0E
      DOUBLE PRECISION FUNCTION DBSK0E (X)
C***BEGIN PROLOGUE  DBSK0E
C***PURPOSE  Compute the exponentially scaled modified (hyperbolic)
C            Bessel function of the third kind of order zero.
C***LIBRARY   SLATEC (FNLIB)
C***CATEGORY  C10B1
C***TYPE      DOUBLE PRECISION (BESK0E-S, DBSK0E-D)
C***KEYWORDS  EXPONENTIALLY SCALED, FNLIB, HYPERBOLIC BESSEL FUNCTION,
C             MODIFIED BESSEL FUNCTION, ORDER ZERO, SPECIAL FUNCTIONS,
C             THIRD KIND
C***AUTHOR  Fullerton, W., (LANL)
C***DESCRIPTION
C
C DBSK0E(X) computes the double precision exponentially scaled
C modified (hyperbolic) Bessel function of the third kind of
C order zero for positive double precision argument X.
C
C Series for BK0        on the interval  0.          to  4.00000E+00
C                                        with weighted error   3.08E-33
C                                         log weighted error  32.51
C                               significant figures required  32.05
C                                    decimal places required  33.11
C
C Series for AK0        on the interval  1.25000E-01 to  5.00000E-01
C                                        with weighted error   2.85E-32
C                                         log weighted error  31.54
C                               significant figures required  30.19
C                                    decimal places required  32.33
C
C Series for AK02       on the interval  0.          to  1.25000E-01
C                                        with weighted error   2.30E-32
C                                         log weighted error  31.64
C                               significant figures required  29.68
C                                    decimal places required  32.40
C
C***REFERENCES  (NONE)
C***ROUTINES CALLED  D1MACH, DBESI0, DCSEVL, INITDS, XERMSG
C***REVISION HISTORY  (YYMMDD)
C   770701  DATE WRITTEN
C   890531  Changed all specific intrinsics to generic.  (WRB)
C   890531  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   900315  CALLs to XERROR changed to CALLs to XERMSG.  (THJ)
C***END PROLOGUE  DBSK0E
      DOUBLE PRECISION X, BK0CS(16), AK0CS(38), AK02CS(33),
     1  XSML, Y, D1MACH, DCSEVL, DBESI0
      LOGICAL FIRST
      SAVE BK0CS, AK0CS, AK02CS, NTK0, NTAK0, NTAK02, XSML, FIRST
      DATA BK0CS(  1) / -.3532739323 3902768720 1140060063 153 D-1    /
      DATA BK0CS(  2) / +.3442898999 2462848688 6344927529 213 D+0    /
      DATA BK0CS(  3) / +.3597993651 5361501626 5721303687 231 D-1    /
      DATA BK0CS(  4) / +.1264615411 4469259233 8479508673 447 D-2    /
      DATA BK0CS(  5) / +.2286212103 1194517860 8269830297 585 D-4    /
      DATA BK0CS(  6) / +.2534791079 0261494573 0790013428 354 D-6    /
      DATA BK0CS(  7) / +.1904516377 2202088589 7214059381 366 D-8    /
      DATA BK0CS(  8) / +.1034969525 7633624585 1008317853 089 D-10   /
      DATA BK0CS(  9) / +.4259816142 7910825765 2445327170 133 D-13   /
      DATA BK0CS( 10) / +.1374465435 8807508969 4238325440 000 D-15   /
      DATA BK0CS( 11) / +.3570896528 5083735909 9688597333 333 D-18   /
      DATA BK0CS( 12) / +.7631643660 1164373766 7498666666 666 D-21   /
      DATA BK0CS( 13) / +.1365424988 4407818590 8053333333 333 D-23   /
      DATA BK0CS( 14) / +.2075275266 9066680831 9999999999 999 D-26   /
      DATA BK0CS( 15) / +.2712814218 0729856000 0000000000 000 D-29   /
      DATA BK0CS( 16) / +.3082593887 9146666666 6666666666 666 D-32   /
      DATA AK0CS(  1) / -.7643947903 3279414240 8297827008 8 D-1      /
      DATA AK0CS(  2) / -.2235652605 6998190520 2309555079 1 D-1      /
      DATA AK0CS(  3) / +.7734181154 6938582353 0061817404 7 D-3      /
      DATA AK0CS(  4) / -.4281006688 8860994644 5214643541 6 D-4      /
      DATA AK0CS(  5) / +.3081700173 8629747436 5001482666 0 D-5      /
      DATA AK0CS(  6) / -.2639367222 0096649740 6744889272 3 D-6      /
      DATA AK0CS(  7) / +.2563713036 4034692062 9408826574 2 D-7      /
      DATA AK0CS(  8) / -.2742705549 9002012638 5721191524 4 D-8      /
      DATA AK0CS(  9) / +.3169429658 0974995920 8083287340 3 D-9      /
      DATA AK0CS( 10) / -.3902353286 9621841416 0106571796 2 D-10     /
      DATA AK0CS( 11) / +.5068040698 1885754020 5009212728 6 D-11     /
      DATA AK0CS( 12) / -.6889574741 0078706795 4171355798 4 D-12     /
      DATA AK0CS( 13) / +.9744978497 8259176913 8820133683 1 D-13     /
      DATA AK0CS( 14) / -.1427332841 8845485053 8985534012 2 D-13     /
      DATA AK0CS( 15) / +.2156412571 0214630395 5806297652 7 D-14     /
      DATA AK0CS( 16) / -.3349654255 1495627721 8878205853 0 D-15     /
      DATA AK0CS( 17) / +.5335260216 9529116921 4528039260 1 D-16     /
      DATA AK0CS( 18) / -.8693669980 8907538076 3962237883 7 D-17     /
      DATA AK0CS( 19) / +.1446404347 8622122278 8776344234 6 D-17     /
      DATA AK0CS( 20) / -.2452889825 5001296824 0467875157 3 D-18     /
      DATA AK0CS( 21) / +.4233754526 2321715728 2170634240 0 D-19     /
      DATA AK0CS( 22) / -.7427946526 4544641956 9534129493 3 D-20     /
      DATA AK0CS( 23) / +.1323150529 3926668662 7796746240 0 D-20     /
      DATA AK0CS( 24) / -.2390587164 7396494513 3598146559 9 D-21     /
      DATA AK0CS( 25) / +.4376827585 9232261401 6571255466 6 D-22     /
      DATA AK0CS( 26) / -.8113700607 3451180593 3901141333 3 D-23     /
      DATA AK0CS( 27) / +.1521819913 8321729583 1037815466 6 D-23     /
      DATA AK0CS( 28) / -.2886041941 4833977702 3595861333 3 D-24     /
      DATA AK0CS( 29) / +.5530620667 0547179799 9261013333 3 D-25     /
      DATA AK0CS( 30) / -.1070377329 2498987285 9163306666 6 D-25     /
      DATA AK0CS( 31) / +.2091086893 1423843002 9632853333 3 D-26     /
      DATA AK0CS( 32) / -.4121713723 6462038274 1026133333 3 D-27     /
      DATA AK0CS( 33) / +.8193483971 1213076401 3568000000 0 D-28     /
      DATA AK0CS( 34) / -.1642000275 4592977267 8075733333 3 D-28     /
      DATA AK0CS( 35) / +.3316143281 4802271958 9034666666 6 D-29     /
      DATA AK0CS( 36) / -.6746863644 1452959410 8586666666 6 D-30     /
      DATA AK0CS( 37) / +.1382429146 3184246776 3541333333 3 D-30     /
      DATA AK0CS( 38) / -.2851874167 3598325708 1173333333 3 D-31     /
      DATA AK02CS(  1) / -.1201869826 3075922398 3934621245 2 D-1      /
      DATA AK02CS(  2) / -.9174852691 0256953106 5256107571 3 D-2      /
      DATA AK02CS(  3) / +.1444550931 7750058210 4884387805 7 D-3      /
      DATA AK02CS(  4) / -.4013614175 4357097286 7102107787 9 D-5      /
      DATA AK02CS(  5) / +.1567831810 8523106725 9034899033 3 D-6      /
      DATA AK02CS(  6) / -.7770110438 5217377103 1579975446 0 D-8      /
      DATA AK02CS(  7) / +.4611182576 1797178825 3313052958 6 D-9      /
      DATA AK02CS(  8) / -.3158592997 8605657705 2666580330 9 D-10     /
      DATA AK02CS(  9) / +.2435018039 3650411278 3588781432 9 D-11     /
      DATA AK02CS( 10) / -.2074331387 3983478977 0985337350 6 D-12     /
      DATA AK02CS( 11) / +.1925787280 5899170847 4273650469 3 D-13     /
      DATA AK02CS( 12) / -.1927554805 8389561036 0034718221 8 D-14     /
      DATA AK02CS( 13) / +.2062198029 1978182782 8523786964 4 D-15     /
      DATA AK02CS( 14) / -.2341685117 5792424026 0364019507 1 D-16     /
      DATA AK02CS( 15) / +.2805902810 6430422468 1517882845 8 D-17     /
      DATA AK02CS( 16) / -.3530507631 1618079458 1548246357 3 D-18     /
      DATA AK02CS( 17) / +.4645295422 9351082674 2421633706 6 D-19     /
      DATA AK02CS( 18) / -.6368625941 3442664739 2205346133 3 D-20     /
      DATA AK02CS( 19) / +.9069521310 9865155676 2234880000 0 D-21     /
      DATA AK02CS( 20) / -.1337974785 4236907398 4500531199 9 D-21     /
      DATA AK02CS( 21) / +.2039836021 8599523155 2208896000 0 D-22     /
      DATA AK02CS( 22) / -.3207027481 3678405000 6086997333 3 D-23     /
      DATA AK02CS( 23) / +.5189744413 6623099636 2635946666 6 D-24     /
      DATA AK02CS( 24) / -.8629501497 5405721929 6460799999 9 D-25     /
      DATA AK02CS( 25) / +.1472161183 1025598552 0803840000 0 D-25     /
      DATA AK02CS( 26) / -.2573069023 8670112838 1235199999 9 D-26     /
      DATA AK02CS( 27) / +.4601774086 6435165873 7664000000 0 D-27     /
      DATA AK02CS( 28) / -.8411555324 2010937371 3066666666 6 D-28     /
      DATA AK02CS( 29) / +.1569806306 6353689393 0154666666 6 D-28     /
      DATA AK02CS( 30) / -.2988226453 0057577889 7919999999 9 D-29     /
      DATA AK02CS( 31) / +.5796831375 2168365206 1866666666 6 D-30     /
      DATA AK02CS( 32) / -.1145035994 3476813321 5573333333 3 D-30     /
      DATA AK02CS( 33) / +.2301266594 2496828020 0533333333 3 D-31     /
      DATA FIRST /.TRUE./
C***FIRST EXECUTABLE STATEMENT  DBSK0E
      IF (FIRST) THEN
         ETA = 0.1*REAL(D1MACH(3))
         NTK0 = INITDS (BK0CS, 16, ETA)
         NTAK0 = INITDS (AK0CS, 38, ETA)
         NTAK02 = INITDS (AK02CS, 33, ETA)
         XSML = SQRT(4.0D0*D1MACH(3))
      ENDIF
      FIRST = .FALSE.
C
      IF (X .LE. 0.D0) CALL XERMSG ('SLATEC', 'DBSK0E',
     +   'X IS ZERO OR NEGATIVE', 2, 2)
      IF (X.GT.2.0D0) GO TO 20
C
      Y = 0.D0
      IF (X.GT.XSML) Y = X*X
      DBSK0E = EXP(X)*(-LOG(0.5D0*X)*DBESI0(X) - 0.25D0 +
     1  DCSEVL (.5D0*Y-1.D0, BK0CS, NTK0))
      RETURN
C
 20   IF (X.LE.8.D0) DBSK0E = (1.25D0 + DCSEVL ((16.D0/X-5.D0)/3.D0,
     1  AK0CS, NTAK0))/SQRT(X)
      IF (X.GT.8.D0) DBSK0E = (1.25D0 +
     1  DCSEVL (16.D0/X-1.D0, AK02CS, NTAK02))/SQRT(X)
C
      RETURN
      END

C---------------------------------------------------------------
C dcsevl.f
C---------------------------------------------------------------

*DECK DCSEVL
      DOUBLE PRECISION FUNCTION DCSEVL (X, CS, N)
C***BEGIN PROLOGUE  DCSEVL
C***PURPOSE  Evaluate a Chebyshev series.
C***LIBRARY   SLATEC (FNLIB)
C***CATEGORY  C3A2
C***TYPE      DOUBLE PRECISION (CSEVL-S, DCSEVL-D)
C***KEYWORDS  CHEBYSHEV SERIES, FNLIB, SPECIAL FUNCTIONS
C***AUTHOR  Fullerton, W., (LANL)
C***DESCRIPTION
C
C  Evaluate the N-term Chebyshev series CS at X.  Adapted from
C  a method presented in the paper by Broucke referenced below.
C
C       Input Arguments --
C  X    value at which the series is to be evaluated.
C  CS   array of N terms of a Chebyshev series.  In evaluating
C       CS, only half the first coefficient is summed.
C  N    number of terms in array CS.
C
C***REFERENCES  R. Broucke, Ten subroutines for the manipulation of
C                 Chebyshev series, Algorithm 446, Communications of
C                 the A.C.M. 16, (1973) pp. 254-256.
C               L. Fox and I. B. Parker, Chebyshev Polynomials in
C                 Numerical Analysis, Oxford University Press, 1968,
C                 page 56.
C***ROUTINES CALLED  D1MACH, XERMSG
C***REVISION HISTORY  (YYMMDD)
C   770401  DATE WRITTEN
C   890831  Modified array declarations.  (WRB)
C   890831  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   900315  CALLs to XERROR changed to CALLs to XERMSG.  (THJ)
C   900329  Prologued revised extensively and code rewritten to allow
C           X to be slightly outside interval (-1,+1).  (WRB)
C   920501  Reformatted the REFERENCES section.  (WRB)
C***END PROLOGUE  DCSEVL
      DOUBLE PRECISION B0, B1, B2, CS(*), ONEPL, TWOX, X, D1MACH
      LOGICAL FIRST
      SAVE FIRST, ONEPL
      DATA FIRST /.TRUE./
C***FIRST EXECUTABLE STATEMENT  DCSEVL
      IF (FIRST) ONEPL = 1.0D0 + D1MACH(4)
      FIRST = .FALSE.
      IF (N .LT. 1) CALL XERMSG ('SLATEC', 'DCSEVL',
     +   'NUMBER OF TERMS .LE. 0', 2, 2)
      IF (N .GT. 1000) CALL XERMSG ('SLATEC', 'DCSEVL',
     +   'NUMBER OF TERMS .GT. 1000', 3, 2)
      IF (ABS(X) .GT. ONEPL) CALL XERMSG ('SLATEC', 'DCSEVL',
     +   'X OUTSIDE THE INTERVAL (-1,+1)', 1, 1)
C
      B1 = 0.0D0
      B0 = 0.0D0
      TWOX = 2.0D0*X
      DO 10 I = 1,N
         B2 = B1
         B1 = B0
         NI = N + 1 - I
         B0 = TWOX*B1 - B2 + CS(NI)
   10 CONTINUE
C
      DCSEVL = 0.5D0*(B0-B2)
C
      RETURN
      END

C---------------------------------------------------------------
C de1.f
C---------------------------------------------------------------

*DECK DE1
      DOUBLE PRECISION FUNCTION DE1 (X)
C***BEGIN PROLOGUE  DE1
C***PURPOSE  Compute the exponential integral E1(X).
C***LIBRARY   SLATEC (FNLIB)
C***CATEGORY  C5
C***TYPE      DOUBLE PRECISION (E1-S, DE1-D)
C***KEYWORDS  E1 FUNCTION, EXPONENTIAL INTEGRAL, FNLIB,
C             SPECIAL FUNCTIONS
C***AUTHOR  Fullerton, W., (LANL)
C***DESCRIPTION
C
C DE1 calculates the double precision exponential integral, E1(X), for
C positive double precision argument X and the Cauchy principal value
C for negative X.  If principal values are used everywhere, then, for
C all X,
C
C    E1(X) = -Ei(-X)
C or
C    Ei(X) = -E1(-X).
C
C
C Series for AE10       on the interval -3.12500E-02 to  0.
C                                        with weighted error   4.62E-32
C                                         log weighted error  31.34
C                               significant figures required  29.70
C                                    decimal places required  32.18
C
C
C Series for AE11       on the interval -1.25000E-01 to -3.12500E-02
C                                        with weighted error   2.22E-32
C                                         log weighted error  31.65
C                               significant figures required  30.75
C                                    decimal places required  32.54
C
C
C Series for AE12       on the interval -2.50000E-01 to -1.25000E-01
C                                        with weighted error   5.19E-32
C                                         log weighted error  31.28
C                               significant figures required  30.82
C                                    decimal places required  32.09
C
C
C Series for E11        on the interval -4.00000E+00 to -1.00000E+00
C                                        with weighted error   8.49E-34
C                                         log weighted error  33.07
C                               significant figures required  34.13
C                                    decimal places required  33.80
C
C
C Series for E12        on the interval -1.00000E+00 to  1.00000E+00
C                                        with weighted error   8.08E-33
C                                         log weighted error  32.09
C                        approx significant figures required  30.4
C                                    decimal places required  32.79
C
C
C Series for AE13       on the interval  2.50000E-01 to  1.00000E+00
C                                        with weighted error   6.65E-32
C                                         log weighted error  31.18
C                               significant figures required  30.69
C                                    decimal places required  32.03
C
C
C Series for AE14       on the interval  0.          to  2.50000E-01
C                                        with weighted error   5.07E-32
C                                         log weighted error  31.30
C                               significant figures required  30.40
C                                    decimal places required  32.20
C
C***REFERENCES  (NONE)
C***ROUTINES CALLED  D1MACH, DCSEVL, INITDS, XERMSG
C***REVISION HISTORY  (YYMMDD)
C   770701  DATE WRITTEN
C   890531  Changed all specific intrinsics to generic.  (WRB)
C   891115  Modified prologue description.  (WRB)
C   891115  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   900315  CALLs to XERROR changed to CALLs to XERMSG.  (THJ)
C   920618  Removed space from variable names.  (RWC, WRB)
C***END PROLOGUE  DE1
      DOUBLE PRECISION X, AE10CS(50), AE11CS(60), AE12CS(41), E11CS(29),
     1  E12CS(25), AE13CS(50), AE14CS(64), XMAX, XMAXT, D1MACH, DCSEVL
      LOGICAL FIRST
      SAVE AE10CS, AE11CS, AE12CS, E11CS, E12CS, AE13CS, AE14CS,
     1 NTAE10, NTAE11, NTAE12, NTE11, NTE12, NTAE13, NTAE14, XMAX,
     2 FIRST
      DATA AE10CS(  1) / +.3284394579 6166990878 7384420188 1 D-1      /
      DATA AE10CS(  2) / -.1669920452 0313628514 7618434338 7 D-1      /
      DATA AE10CS(  3) / +.2845284724 3613468074 2489985325 2 D-3      /
      DATA AE10CS(  4) / -.7563944358 5162064894 8786693853 3 D-5      /
      DATA AE10CS(  5) / +.2798971289 4508591575 0484318087 9 D-6      /
      DATA AE10CS(  6) / -.1357901828 5345310695 2556392625 5 D-7      /
      DATA AE10CS(  7) / +.8343596202 0404692558 5610290490 6 D-9      /
      DATA AE10CS(  8) / -.6370971727 6402484382 7524298853 2 D-10     /
      DATA AE10CS(  9) / +.6007247608 8118612357 6083156158 4 D-11     /
      DATA AE10CS( 10) / -.7022876174 6797735907 5062615008 8 D-12     /
      DATA AE10CS( 11) / +.1018302673 7036876930 9665234688 3 D-12     /
      DATA AE10CS( 12) / -.1761812903 4308800404 0630996642 2 D-13     /
      DATA AE10CS( 13) / +.3250828614 2353606942 4403035387 7 D-14     /
      DATA AE10CS( 14) / -.5071770025 5058186788 2487225904 4 D-15     /
      DATA AE10CS( 15) / +.1665177387 0432942981 7248608415 6 D-16     /
      DATA AE10CS( 16) / +.3166753890 7975144006 7700353655 5 D-16     /
      DATA AE10CS( 17) / -.1588403763 6641415151 3311834353 8 D-16     /
      DATA AE10CS( 18) / +.4175513256 1380188330 0303461848 4 D-17     /
      DATA AE10CS( 19) / -.2892347749 7071419067 1071447885 2 D-18     /
      DATA AE10CS( 20) / -.2800625903 3966081035 0634058966 9 D-18     /
      DATA AE10CS( 21) / +.1322938639 5392709037 0758002378 1 D-18     /
      DATA AE10CS( 22) / -.1804447444 1773016272 8388783355 7 D-19     /
      DATA AE10CS( 23) / -.7905384086 5226160762 9164481760 4 D-20     /
      DATA AE10CS( 24) / +.4435711366 3695701039 4623583802 7 D-20     /
      DATA AE10CS( 25) / -.4264103994 9781208688 6530920655 5 D-21     /
      DATA AE10CS( 26) / -.3920101766 9371175415 5371316204 8 D-21     /
      DATA AE10CS( 27) / +.1527378051 3439942663 4375232697 1 D-21     /
      DATA AE10CS( 28) / +.1024849527 0493723393 1030878311 7 D-22     /
      DATA AE10CS( 29) / -.2134907874 7714335762 6271140588 2 D-22     /
      DATA AE10CS( 30) / +.3239139475 1600282670 6169470036 6 D-23     /
      DATA AE10CS( 31) / +.2142183762 2998899547 6264316829 6 D-23     /
      DATA AE10CS( 32) / -.8234609419 6010184147 0034808231 2 D-24     /
      DATA AE10CS( 33) / -.1524652829 6458094796 1369440114 0 D-24     /
      DATA AE10CS( 34) / +.1378208282 4606391346 6848036432 5 D-24     /
      DATA AE10CS( 35) / +.2131311202 8339478795 2322499925 3 D-26     /
      DATA AE10CS( 36) / -.2012649651 5264841218 1746676312 7 D-25     /
      DATA AE10CS( 37) / +.1995535662 2633580161 0631178267 3 D-26     /
      DATA AE10CS( 38) / +.2798995808 9840034649 4868652031 9 D-26     /
      DATA AE10CS( 39) / -.5534511845 3896266376 4081927782 3 D-27     /
      DATA AE10CS( 40) / -.3884995396 1599688616 8254402614 6 D-27     /
      DATA AE10CS( 41) / +.1121304434 5073593828 5068035467 9 D-27     /
      DATA AE10CS( 42) / +.5566568152 4237409482 5656383351 4 D-28     /
      DATA AE10CS( 43) / -.2045482929 8104997004 4853393817 6 D-28     /
      DATA AE10CS( 44) / -.8453813992 7123362334 1145749367 4 D-29     /
      DATA AE10CS( 45) / +.3565758433 4312915628 1611111628 7 D-29     /
      DATA AE10CS( 46) / +.1383653872 1256347055 3994909887 1 D-29     /
      DATA AE10CS( 47) / -.6062167864 4513724365 8453376477 8 D-30     /
      DATA AE10CS( 48) / -.2447198043 9893132674 3765511918 9 D-30     /
      DATA AE10CS( 49) / +.1006850640 9339983480 1154818048 0 D-30     /
      DATA AE10CS( 50) / +.4623685555 0148690156 6434146167 4 D-31     /
      DATA AE11CS(  1) / +.2026315064 7078889499 4012365173 81 D+0     /
      DATA AE11CS(  2) / -.7365514099 1203130439 5368987280 34 D-1     /
      DATA AE11CS(  3) / +.6390934911 8361915862 7532838400 20 D-2     /
      DATA AE11CS(  4) / -.6079725270 5247911780 6531533639 99 D-3     /
      DATA AE11CS(  5) / -.7370649862 0176629330 6814114934 84 D-4     /
      DATA AE11CS(  6) / +.4873285744 9450183453 4649924880 76 D-4     /
      DATA AE11CS(  7) / -.2383706484 0448290766 5884894602 35 D-5     /
      DATA AE11CS(  8) / -.3051861262 8561521027 0273322461 21 D-5     /
      DATA AE11CS(  9) / +.1705033157 2564559009 6880329929 07 D-6     /
      DATA AE11CS( 10) / +.2383420452 7487747258 6015981364 03 D-6     /
      DATA AE11CS( 11) / +.1078177255 6163166562 5968723640 20 D-7     /
      DATA AE11CS( 12) / -.1795569284 7399102653 6426914465 99 D-7     /
      DATA AE11CS( 13) / -.4128407234 1950457727 9123946404 36 D-8     /
      DATA AE11CS( 14) / +.6862214858 8631968618 3468445266 64 D-9     /
      DATA AE11CS( 15) / +.5313018312 0506356147 6020096759 61 D-9     /
      DATA AE11CS( 16) / +.7879688026 1490694831 3050228935 15 D-10    /
      DATA AE11CS( 17) / -.2626176232 9356522290 3416752712 32 D-10    /
      DATA AE11CS( 18) / -.1548368763 6308261963 1257562941 00 D-10    /
      DATA AE11CS( 19) / -.2581896237 7261390492 8024051225 91 D-11    /
      DATA AE11CS( 20) / +.5954287919 1591072658 9035299593 52 D-12    /
      DATA AE11CS( 21) / +.4645140038 7681525833 7849193214 05 D-12    /
      DATA AE11CS( 22) / +.1155785502 3255861496 2880062037 31 D-12    /
      DATA AE11CS( 23) / -.1047523687 0835799012 3175471896 70 D-14    /
      DATA AE11CS( 24) / -.1189665350 2709004368 1044892609 29 D-13    /
      DATA AE11CS( 25) / -.4774907749 0261778752 6430193499 50 D-14    /
      DATA AE11CS( 26) / -.8107764961 5772777976 2497347541 35 D-15    /
      DATA AE11CS( 27) / +.1343556925 0031554199 3769879981 78 D-15    /
      DATA AE11CS( 28) / +.1413453002 2913106260 2488738812 87 D-15    /
      DATA AE11CS( 29) / +.4945159257 3953173115 5206632328 83 D-16    /
      DATA AE11CS( 30) / +.7988404848 0080665648 8585873993 67 D-17    /
      DATA AE11CS( 31) / -.1400863218 8089809829 2487119353 93 D-17    /
      DATA AE11CS( 32) / -.1481424695 8417372107 7228040016 80 D-17    /
      DATA AE11CS( 33) / -.5582617364 6025601904 0106939371 13 D-18    /
      DATA AE11CS( 34) / -.1144207454 2191647264 7830725445 98 D-18    /
      DATA AE11CS( 35) / +.2537182387 9566853500 5240184799 23 D-20    /
      DATA AE11CS( 36) / +.1320532815 4805359813 2788633890 97 D-19    /
      DATA AE11CS( 37) / +.6293026108 1586809166 2874267894 85 D-20    /
      DATA AE11CS( 38) / +.1768827042 4882713734 9992613325 48 D-20    /
      DATA AE11CS( 39) / +.2326618798 5146045209 6742968874 32 D-21    /
      DATA AE11CS( 40) / -.6780306081 1125233043 7738318441 13 D-22    /
      DATA AE11CS( 41) / -.5944087695 9676373802 8741505318 91 D-22    /
      DATA AE11CS( 42) / -.2361821453 1184415968 5325925034 66 D-22    /
      DATA AE11CS( 43) / -.6021449972 4601478214 1684787445 76 D-23    /
      DATA AE11CS( 44) / -.6551790647 4348299071 3704441446 39 D-24    /
      DATA AE11CS( 45) / +.2938875529 7497724587 0420386993 49 D-24    /
      DATA AE11CS( 46) / +.2260160620 0642115173 2157287585 10 D-24    /
      DATA AE11CS( 47) / +.8953436924 5958628745 0912068730 87 D-25    /
      DATA AE11CS( 48) / +.2401592347 1098457555 7720674577 06 D-25    /
      DATA AE11CS( 49) / +.3411837688 8907172955 6664230434 13 D-26    /
      DATA AE11CS( 50) / -.7161707169 4630342052 3550133452 79 D-27    /
      DATA AE11CS( 51) / -.7562039065 9281725157 9286519807 99 D-27    /
      DATA AE11CS( 52) / -.3377461215 7467324637 9529207808 00 D-27    /
      DATA AE11CS( 53) / -.1047932570 3300941711 5264303322 45 D-27    /
      DATA AE11CS( 54) / -.2165455025 2170342240 8548802013 86 D-28    /
      DATA AE11CS( 55) / -.7529712574 5288269994 6892984320 00 D-30    /
      DATA AE11CS( 56) / +.1910317939 2798935768 6380840004 26 D-29    /
      DATA AE11CS( 57) / +.1149210496 6530338547 7907288337 06 D-29    /
      DATA AE11CS( 58) / +.4389697058 2661751514 4103591936 00 D-30    /
      DATA AE11CS( 59) / +.1232088323 9205686471 6471577258 66 D-30    /
      DATA AE11CS( 60) / +.2222017445 7553175317 5385811626 66 D-31    /
      DATA AE12CS(  1) / +.6362958979 6747038767 1298878068 03 D+0     /
      DATA AE12CS(  2) / -.1308116867 5067634385 8126711211 35 D+0     /
      DATA AE12CS(  3) / -.8436741021 3053930014 4876621297 52 D-2     /
      DATA AE12CS(  4) / +.2656849153 1006685413 0294280689 06 D-2     /
      DATA AE12CS(  5) / +.3282272178 1658133778 7921701425 17 D-3     /
      DATA AE12CS(  6) / -.2378344777 1430248269 5798078510 50 D-4     /
      DATA AE12CS(  7) / -.1143980430 8100055514 4470767970 47 D-4     /
      DATA AE12CS(  8) / -.1440594343 3238338455 2397176993 23 D-5     /
      DATA AE12CS(  9) / +.5241595665 1148829963 7728180616 64 D-8     /
      DATA AE12CS( 10) / +.3840730640 7844323480 9792030597 16 D-7     /
      DATA AE12CS( 11) / +.8588024486 0267195879 6605157593 44 D-8     /
      DATA AE12CS( 12) / +.1021922662 5855003286 3399695539 11 D-8     /
      DATA AE12CS( 13) / +.2174913232 3289724542 8213398059 92 D-10    /
      DATA AE12CS( 14) / -.2209023814 2623144809 5235038117 41 D-10    /
      DATA AE12CS( 15) / -.6345753354 4928753294 3836222088 01 D-11    /
      DATA AE12CS( 16) / -.1083774656 6857661115 3405397329 19 D-11    /
      DATA AE12CS( 17) / -.1190982287 2222586730 2622004402 77 D-12    /
      DATA AE12CS( 18) / -.2843868238 9265590299 5087660086 61 D-14    /
      DATA AE12CS( 19) / +.2508032702 6686769668 5871954875 46 D-14    /
      DATA AE12CS( 20) / +.7872964152 8559842431 5977264212 65 D-15    /
      DATA AE12CS( 21) / +.1547506634 7785217148 4843346373 29 D-15    /
      DATA AE12CS( 22) / +.2257532283 1665075055 2726081972 90 D-16    /
      DATA AE12CS( 23) / +.2223335286 7266608760 2813808366 93 D-17    /
      DATA AE12CS( 24) / +.1696781956 3544153513 4641946623 99 D-19    /
      DATA AE12CS( 25) / -.5760831625 5947682105 3100873045 33 D-19    /
      DATA AE12CS( 26) / -.1759123577 4646878055 6253694088 53 D-19    /
      DATA AE12CS( 27) / -.3628605637 5103174394 7553286826 66 D-20    /
      DATA AE12CS( 28) / -.5923556979 7328991652 5581434880 00 D-21    /
      DATA AE12CS( 29) / -.7603038092 6310191114 4291368959 99 D-22    /
      DATA AE12CS( 30) / -.6254784352 1711763842 6414284799 99 D-23    /
      DATA AE12CS( 31) / +.2548336075 9307648606 0376064000 00 D-24    /
      DATA AE12CS( 32) / +.2559861573 1739857020 1688746666 66 D-24    /
      DATA AE12CS( 33) / +.7137623935 7899318800 2070528000 00 D-25    /
      DATA AE12CS( 34) / +.1470375993 9567568181 5789568000 00 D-25    /
      DATA AE12CS( 35) / +.2510552476 5386733555 1986346666 66 D-26    /
      DATA AE12CS( 36) / +.3588666638 7790890886 5836373333 33 D-27    /
      DATA AE12CS( 37) / +.3988603515 6771301763 3177599999 99 D-28    /
      DATA AE12CS( 38) / +.2176367694 7356220478 8053333333 33 D-29    /
      DATA AE12CS( 39) / -.4614699848 7618942367 6074666666 66 D-30    /
      DATA AE12CS( 40) / -.2071351787 7481987707 1530666666 66 D-30    /
      DATA AE12CS( 41) / -.5189037856 3534371596 9706666666 66 D-31    /
      DATA E11CS(  1) / -.1611346165 5571494025 7206639275 66180 D+2  /
      DATA E11CS(  2) / +.7794072778 7426802769 2722458917 41497 D+1  /
      DATA E11CS(  3) / -.1955405818 8631419507 1272838128 14491 D+1  /
      DATA E11CS(  4) / +.3733729386 6277945611 5171908656 90209 D+0  /
      DATA E11CS(  5) / -.5692503191 0929019385 2638922200 51166 D-1  /
      DATA E11CS(  6) / +.7211077769 6600918537 8477248126 35813 D-2  /
      DATA E11CS(  7) / -.7810490144 9841593997 7151840890 64148 D-3  /
      DATA E11CS(  8) / +.7388093356 2621681878 9748813661 77858 D-4  /
      DATA E11CS(  9) / -.6202861875 8082045134 3581336079 09712 D-5  /
      DATA E11CS( 10) / +.4681600230 3176735524 4058238683 62657 D-6  /
      DATA E11CS( 11) / -.3209288853 3298649524 0725530272 28719 D-7  /
      DATA E11CS( 12) / +.2015199748 7404533394 8262622130 19548 D-8  /
      DATA E11CS( 13) / -.1167368681 6697793105 3562716950 15419 D-9  /
      DATA E11CS( 14) / +.6276270667 2039943397 7887483796 15573 D-11 /
      DATA E11CS( 15) / -.3148154167 2275441045 2467818023 93600 D-12 /
      DATA E11CS( 16) / +.1479904174 4493474210 8944722517 33333 D-13 /
      DATA E11CS( 17) / -.6545709158 3979673774 2634015880 53333 D-15 /
      DATA E11CS( 18) / +.2733687222 3137291142 5080127487 99999 D-16 /
      DATA E11CS( 19) / -.1081352434 9754406876 7217276245 33333 D-17 /
      DATA E11CS( 20) / +.4062832804 0434303295 3003485866 66666 D-19 /
      DATA E11CS( 21) / -.1453553935 8960455858 9143722666 66666 D-20 /
      DATA E11CS( 22) / +.4963274618 1648636830 1984426666 66666 D-22 /
      DATA E11CS( 23) / -.1620861269 6636044604 8665600000 00000 D-23 /
      DATA E11CS( 24) / +.5072144803 8607422226 4319999999 99999 D-25 /
      DATA E11CS( 25) / -.1523581113 3372207813 9733333333 33333 D-26 /
      DATA E11CS( 26) / +.4400151125 6103618696 5333333333 33333 D-28 /
      DATA E11CS( 27) / -.1223614194 5416231594 6666666666 66666 D-29 /
      DATA E11CS( 28) / +.3280921666 1066001066 6666666666 66666 D-31 /
      DATA E11CS( 29) / -.8493345226 8306432000 0000000000 00000 D-33 /
      DATA E12CS(  1) / -.3739021479 22027951166 869820482 7 D-1      /
      DATA E12CS(  2) / +.4272398606 2209577260 4917917652 8 D-1      /
      DATA E12CS(  3) / -.1303182079 8497005441 5392055219 726 D+0    /
      DATA E12CS(  4) / +.1441912402 4698890734 1095893982 137 D-1    /
      DATA E12CS(  5) / -.1346170780 5106802211 6121527983 553 D-2    /
      DATA E12CS(  6) / +.1073102925 3063779997 6115850970 073 D-3    /
      DATA E12CS(  7) / -.7429999516 1194364961 0283062223 163 D-5    /
      DATA E12CS(  8) / +.4537732569 0753713938 6383211511 827 D-6    /
      DATA E12CS(  9) / -.2476417211 3906013184 6547423802 912 D-7    /
      DATA E12CS( 10) / +.1220765813 7459095370 0228167846 102 D-8    /
      DATA E12CS( 11) / -.5485141480 6409239382 1357398028 261 D-10   /
      DATA E12CS( 12) / +.2263621421 3007879929 3688162377 002 D-11   /
      DATA E12CS( 13) / -.8635897271 6980097940 4172916282 240 D-13   /
      DATA E12CS( 14) / +.3062915536 6933299758 1032894881 279 D-14   /
      DATA E12CS( 15) / -.1014857188 5594414755 7128906734 933 D-15   /
      DATA E12CS( 16) / +.3154821740 3406987754 6855328426 666 D-17   /
      DATA E12CS( 17) / -.9236042407 6924095448 4015923200 000 D-19   /
      DATA E12CS( 18) / +.2555042679 7081400244 0435029333 333 D-20   /
      DATA E12CS( 19) / -.6699128056 8456684721 7882453333 333 D-22   /
      DATA E12CS( 20) / +.1669254054 3538731943 1987199999 999 D-23   /
      DATA E12CS( 21) / -.3962549251 8437964185 6000000000 000 D-25   /
      DATA E12CS( 22) / +.8981358965 9851133201 0666666666 666 D-27   /
      DATA E12CS( 23) / -.1947633669 9301643332 2666666666 666 D-28   /
      DATA E12CS( 24) / +.4048360190 2463003306 6666666666 666 D-30   /
      DATA E12CS( 25) / -.8079815676 9984512000 0000000000 000 D-32   /
      DATA AE13CS(  1) / -.6057732466 4060345999 3193827377 47 D+0     /
      DATA AE13CS(  2) / -.1125352434 8366090030 6497688527 18 D+0     /
      DATA AE13CS(  3) / +.1343226624 7902779492 4878593294 14 D-1     /
      DATA AE13CS(  4) / -.1926845187 3811457249 2468389913 03 D-2     /
      DATA AE13CS(  5) / +.3091183377 2060318335 5867374753 68 D-3     /
      DATA AE13CS(  6) / -.5356413212 9618418776 3935597951 47 D-4     /
      DATA AE13CS(  7) / +.9827812880 2474923952 4918827172 37 D-5     /
      DATA AE13CS(  8) / -.1885368984 9165182826 9028919389 10 D-5     /
      DATA AE13CS(  9) / +.3749431935 6894735406 9640421905 31 D-6     /
      DATA AE13CS( 10) / -.7682345587 0552639273 7334656805 56 D-7     /
      DATA AE13CS( 11) / +.1614327056 7198777552 9563000608 68 D-7     /
      DATA AE13CS( 12) / -.3466802211 4907354566 3090602260 27 D-8     /
      DATA AE13CS( 13) / +.7587542091 9036277572 8897470541 14 D-9     /
      DATA AE13CS( 14) / -.1688643332 9881412573 5145266367 03 D-9     /
      DATA AE13CS( 15) / +.3814570674 9552265682 8042509272 72 D-10    /
      DATA AE13CS( 16) / -.8733026632 4446292706 8517182723 34 D-11    /
      DATA AE13CS( 17) / +.2023672864 5867960961 7943110643 30 D-11    /
      DATA AE13CS( 18) / -.4741328303 9555834655 2103408201 60 D-12    /
      DATA AE13CS( 19) / +.1122117204 8389864324 7317999289 20 D-12    /
      DATA AE13CS( 20) / -.2680422543 4840309912 8268090933 95 D-13    /
      DATA AE13CS( 21) / +.6457851441 7716530343 5803690672 12 D-14    /
      DATA AE13CS( 22) / -.1568276050 1666478830 3057028491 94 D-14    /
      DATA AE13CS( 23) / +.3836786539 9315404861 8215164414 08 D-15    /
      DATA AE13CS( 24) / -.9451717302 7579130478 8710489325 56 D-16    /
      DATA AE13CS( 25) / +.2343481228 8949573293 8966664391 33 D-16    /
      DATA AE13CS( 26) / -.5845866158 0214714576 1231944198 82 D-17    /
      DATA AE13CS( 27) / +.1466622986 7947778605 8736174191 95 D-17    /
      DATA AE13CS( 28) / -.3699392347 6444472706 5925382744 74 D-18    /
      DATA AE13CS( 29) / +.9379015993 6721242136 0142918178 13 D-19    /
      DATA AE13CS( 30) / -.2389367322 1937873136 3082240873 81 D-19    /
      DATA AE13CS( 31) / +.6115062462 9497608051 9342238378 66 D-20    /
      DATA AE13CS( 32) / -.1571858532 7554025507 7198532881 06 D-20    /
      DATA AE13CS( 33) / +.4057238728 5585397769 5192944913 06 D-21    /
      DATA AE13CS( 34) / -.1051402655 4738034990 5663671227 73 D-21    /
      DATA AE13CS( 35) / +.2734966493 0638667785 8060031317 33 D-22    /
      DATA AE13CS( 36) / -.7140160408 0205796099 3555742719 99 D-23    /
      DATA AE13CS( 37) / +.1870555243 2235079986 7569242111 99 D-23    /
      DATA AE13CS( 38) / -.4916746816 6870480520 4780209493 33 D-24    /
      DATA AE13CS( 39) / +.1296498811 9684031730 9160871253 33 D-24    /
      DATA AE13CS( 40) / -.3429251568 8362864461 6239404373 33 D-25    /
      DATA AE13CS( 41) / +.9097224164 3887034329 1048209066 66 D-26    /
      DATA AE13CS( 42) / -.2420211231 4316856489 9348479999 99 D-26    /
      DATA AE13CS( 43) / +.6456361293 4639510757 6704750933 33 D-27    /
      DATA AE13CS( 44) / -.1726913273 5340541122 3159876266 66 D-27    /
      DATA AE13CS( 45) / +.4630861165 9151500715 1942314666 66 D-28    /
      DATA AE13CS( 46) / -.1244870363 7214131241 7551701333 33 D-28    /
      DATA AE13CS( 47) / +.3354457409 0520678532 9070079999 99 D-29    /
      DATA AE13CS( 48) / -.9059886852 1070774437 5439359999 99 D-30    /
      DATA AE13CS( 49) / +.2452414705 1474238587 2732160000 00 D-30    /
      DATA AE13CS( 50) / -.6652817873 3552062817 1079679999 99 D-31    /
      DATA AE14CS(  1) / -.1892918000 7530168254 9567994282 0 D+0      /
      DATA AE14CS(  2) / -.8648117855 2598714899 6881705682 4 D-1      /
      DATA AE14CS(  3) / +.7224101543 7465947470 2151483918 4 D-2      /
      DATA AE14CS(  4) / -.8097559457 5573861971 5965561018 1 D-3      /
      DATA AE14CS(  5) / +.1099913443 2661388671 7925115700 2 D-3      /
      DATA AE14CS(  6) / -.1717332998 9377673714 9535881448 7 D-4      /
      DATA AE14CS(  7) / +.2985627514 4792833228 2534249500 3 D-5      /
      DATA AE14CS(  8) / -.5659649145 7719300565 6016726715 5 D-6      /
      DATA AE14CS(  9) / +.1152680839 7141400192 2658350166 3 D-6      /
      DATA AE14CS( 10) / -.2495030440 2693382288 4212876506 5 D-7      /
      DATA AE14CS( 11) / +.5692324201 8337543670 3937036814 0 D-8      /
      DATA AE14CS( 12) / -.1359957664 8056003384 9003093917 6 D-8      /
      DATA AE14CS( 13) / +.3384662888 7608845901 8451292585 9 D-9      /
      DATA AE14CS( 14) / -.8737853904 4746819523 5084931658 0 D-10     /
      DATA AE14CS( 15) / +.2331588663 2226597186 1261340047 0 D-10     /
      DATA AE14CS( 16) / -.6411481049 2137859697 5316519632 6 D-11     /
      DATA AE14CS( 17) / +.1812246980 2048164333 8435948468 2 D-11     /
      DATA AE14CS( 18) / -.5253831761 5584606888 1940384046 6 D-12     /
      DATA AE14CS( 19) / +.1559218272 5919256988 5502860982 5 D-12     /
      DATA AE14CS( 20) / -.4729168297 0803987184 7642936946 6 D-13     /
      DATA AE14CS( 21) / +.1463761864 3932435020 7619949380 8 D-13     /
      DATA AE14CS( 22) / -.4617388988 7129241022 3217362360 4 D-14     /
      DATA AE14CS( 23) / +.1482710348 2893693237 8923966037 1 D-14     /
      DATA AE14CS( 24) / -.4841672496 2392291469 7316573441 7 D-15     /
      DATA AE14CS( 25) / +.1606215575 7002904081 1657196618 8 D-15     /
      DATA AE14CS( 26) / -.5408917538 9571709478 9502378425 2 D-16     /
      DATA AE14CS( 27) / +.1847470159 3468978813 7023140231 0 D-16     /
      DATA AE14CS( 28) / -.6395830792 7590944705 0061042505 0 D-17     /
      DATA AE14CS( 29) / +.2242780721 6997594572 5023327617 0 D-17     /
      DATA AE14CS( 30) / -.7961369173 9839475527 4455530864 6 D-18     /
      DATA AE14CS( 31) / +.2859308111 5401974598 0861992927 2 D-18     /
      DATA AE14CS( 32) / -.1038450244 7011371459 0069713744 6 D-18     /
      DATA AE14CS( 33) / +.3812040607 0979757808 6684100831 9 D-19     /
      DATA AE14CS( 34) / -.1413795417 7172007687 1756272369 6 D-19     /
      DATA AE14CS( 35) / +.5295367865 1827409583 0544259481 5 D-20     /
      DATA AE14CS( 36) / -.2002264245 0268259021 3721113143 9 D-20     /
      DATA AE14CS( 37) / +.7640262751 2751960147 3684861091 8 D-21     /
      DATA AE14CS( 38) / -.2941119006 8687878833 1126352336 2 D-21     /
      DATA AE14CS( 39) / +.1141823539 0789271930 3769148358 6 D-21     /
      DATA AE14CS( 40) / -.4469308475 9552984252 4702071848 9 D-22     /
      DATA AE14CS( 41) / +.1763262410 5717507706 3049140852 0 D-22     /
      DATA AE14CS( 42) / -.7009968187 9259023563 5151826234 0 D-23     /
      DATA AE14CS( 43) / +.2807573556 5583789222 8775750751 5 D-23     /
      DATA AE14CS( 44) / -.1132560944 9810864321 4188889156 2 D-23     /
      DATA AE14CS( 45) / +.4600574684 3750179461 5676423372 7 D-24     /
      DATA AE14CS( 46) / -.1881448598 9761334598 6460914810 8 D-24     /
      DATA AE14CS( 47) / +.7744916111 5077308454 4432847803 7 D-25     /
      DATA AE14CS( 48) / -.3208512760 5853689267 0270382626 1 D-25     /
      DATA AE14CS( 49) / +.1337445542 9108397606 1993042138 4 D-25     /
      DATA AE14CS( 50) / -.5608671881 8022170488 9477173521 0 D-26     /
      DATA AE14CS( 51) / +.2365839716 5285374837 1006947327 9 D-26     /
      DATA AE14CS( 52) / -.1003656195 0253053340 6583452685 6 D-26     /
      DATA AE14CS( 53) / +.4281490878 0941611312 8664255692 7 D-27     /
      DATA AE14CS( 54) / -.1836345261 8153181996 9132695825 0 D-27     /
      DATA AE14CS( 55) / +.7917798231 3495400000 9746867814 4 D-28     /
      DATA AE14CS( 56) / -.3431542358 7422203610 2501577523 1 D-28     /
      DATA AE14CS( 57) / +.1494705493 8971032374 7506600891 7 D-28     /
      DATA AE14CS( 58) / -.6542620279 8657054397 3904242005 3 D-29     /
      DATA AE14CS( 59) / +.2877581395 1991711143 4048735368 5 D-29     /
      DATA AE14CS( 60) / -.1271557211 7960247110 2798120004 2 D-29     /
      DATA AE14CS( 61) / +.5644615555 6487225223 8804462250 6 D-30     /
      DATA AE14CS( 62) / -.2516994994 2840951060 8061683029 3 D-30     /
      DATA AE14CS( 63) / +.1127259818 9275102063 7036880418 1 D-30     /
      DATA AE14CS( 64) / -.5069814875 8004608555 6258471936 0 D-31     /
      DATA FIRST /.TRUE./
C***FIRST EXECUTABLE STATEMENT  DE1
      IF (FIRST) THEN
         ETA = 0.1*REAL(D1MACH(3))
         NTAE10 = INITDS (AE10CS, 50, ETA)
         NTAE11 = INITDS (AE11CS, 60, ETA)
         NTAE12 = INITDS (AE12CS, 41, ETA)
         NTE11 = INITDS (E11CS, 29, ETA)
         NTE12 = INITDS (E12CS, 25, ETA)
         NTAE13 = INITDS (AE13CS, 50, ETA)
         NTAE14 = INITDS (AE14CS, 64, ETA)
C
         XMAXT = -LOG(D1MACH(1))
         XMAX = XMAXT - LOG(XMAXT)
      ENDIF
      FIRST = .FALSE.
C
      IF (X.GT.(-1.D0)) GO TO 50
      IF (X.GT.(-32.D0)) GO TO 20
      DE1 = EXP(-X)/X * (1.D0 + DCSEVL (64.D0/X+1.D0, AE10CS, NTAE10))
      RETURN
C
 20   IF (X.GT.(-8.D0)) GO TO 30
      DE1 = EXP(-X)/X * (1.D0 + DCSEVL ((64.D0/X+5.D0)/3.D0, AE11CS,
     1  NTAE11))
      RETURN
C
 30   IF (X.GT.(-4.D0)) GO TO 40
      DE1 = EXP(-X)/X * (1.D0 + DCSEVL (16.D0/X+3.D0, AE12CS, NTAE12))
      RETURN
C
 40   DE1 = -LOG(-X) + DCSEVL ((2.D0*X+5.D0)/3.D0, E11CS, NTE11)
      RETURN
C
 50   IF (X.GT.1.0D0) GO TO 60
      IF (X .EQ. 0.D0) CALL XERMSG ('SLATEC', 'DE1', 'X IS 0', 2, 2)
      DE1 = (-LOG(ABS(X)) - 0.6875D0 + X)  + DCSEVL (X, E12CS, NTE12)
      RETURN
C
 60   IF (X.GT.4.0D0) GO TO 70
      DE1 = EXP(-X)/X * (1.D0 + DCSEVL ((8.D0/X-5.D0)/3.D0, AE13CS,
     1  NTAE13))
      RETURN
C
 70   IF (X.GT.XMAX) GO TO 80
      DE1 = EXP(-X)/X * (1.D0 + DCSEVL (8.D0/X-1.D0, AE14CS, NTAE14))
      RETURN
C
 80   CALL XERMSG ('SLATEC', 'DE1', 'X SO BIG E1 UNDERFLOWS', 1, 1)
      DE1 = 0.D0
      RETURN
C
      END

C---------------------------------------------------------------
C dfac.f
C---------------------------------------------------------------

*DECK DFAC
      DOUBLE PRECISION FUNCTION DFAC (N)
C***BEGIN PROLOGUE  DFAC
C***PURPOSE  Compute the factorial function.
C***LIBRARY   SLATEC (FNLIB)
C***CATEGORY  C1
C***TYPE      DOUBLE PRECISION (FAC-S, DFAC-D)
C***KEYWORDS  FACTORIAL, FNLIB, SPECIAL FUNCTIONS
C***AUTHOR  Fullerton, W., (LANL)
C***DESCRIPTION
C
C DFAC(N) calculates the double precision factorial for integer
C argument N.
C
C***REFERENCES  (NONE)
C***ROUTINES CALLED  D9LGMC, DGAMLM, XERMSG
C***REVISION HISTORY  (YYMMDD)
C   770601  DATE WRITTEN
C   890531  Changed all specific intrinsics to generic.  (WRB)
C   890531  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   900315  CALLs to XERROR changed to CALLs to XERMSG.  (THJ)
C***END PROLOGUE  DFAC
      DOUBLE PRECISION FACN(31), SQ2PIL, X, XMAX, XMIN,  D9LGMC
      SAVE FACN, SQ2PIL, NMAX
      DATA FACN  (  1) / +.1000000000 0000000000 0000000000 000 D+1    /
      DATA FACN  (  2) / +.1000000000 0000000000 0000000000 000 D+1    /
      DATA FACN  (  3) / +.2000000000 0000000000 0000000000 000 D+1    /
      DATA FACN  (  4) / +.6000000000 0000000000 0000000000 000 D+1    /
      DATA FACN  (  5) / +.2400000000 0000000000 0000000000 000 D+2    /
      DATA FACN  (  6) / +.1200000000 0000000000 0000000000 000 D+3    /
      DATA FACN  (  7) / +.7200000000 0000000000 0000000000 000 D+3    /
      DATA FACN  (  8) / +.5040000000 0000000000 0000000000 000 D+4    /
      DATA FACN  (  9) / +.4032000000 0000000000 0000000000 000 D+5    /
      DATA FACN  ( 10) / +.3628800000 0000000000 0000000000 000 D+6    /
      DATA FACN  ( 11) / +.3628800000 0000000000 0000000000 000 D+7    /
      DATA FACN  ( 12) / +.3991680000 0000000000 0000000000 000 D+8    /
      DATA FACN  ( 13) / +.4790016000 0000000000 0000000000 000 D+9    /
      DATA FACN  ( 14) / +.6227020800 0000000000 0000000000 000 D+10   /
      DATA FACN  ( 15) / +.8717829120 0000000000 0000000000 000 D+11   /
      DATA FACN  ( 16) / +.1307674368 0000000000 0000000000 000 D+13   /
      DATA FACN  ( 17) / +.2092278988 8000000000 0000000000 000 D+14   /
      DATA FACN  ( 18) / +.3556874280 9600000000 0000000000 000 D+15   /
      DATA FACN  ( 19) / +.6402373705 7280000000 0000000000 000 D+16   /
      DATA FACN  ( 20) / +.1216451004 0883200000 0000000000 000 D+18   /
      DATA FACN  ( 21) / +.2432902008 1766400000 0000000000 000 D+19   /
      DATA FACN  ( 22) / +.5109094217 1709440000 0000000000 000 D+20   /
      DATA FACN  ( 23) / +.1124000727 7776076800 0000000000 000 D+22   /
      DATA FACN  ( 24) / +.2585201673 8884976640 0000000000 000 D+23   /
      DATA FACN  ( 25) / +.6204484017 3323943936 0000000000 000 D+24   /
      DATA FACN  ( 26) / +.1551121004 3330985984 0000000000 000 D+26   /
      DATA FACN  ( 27) / +.4032914611 2660563558 4000000000 000 D+27   /
      DATA FACN  ( 28) / +.1088886945 0418352160 7680000000 000 D+29   /
      DATA FACN  ( 29) / +.3048883446 1171386050 1504000000 000 D+30   /
      DATA FACN  ( 30) / +.8841761993 7397019545 4361600000 000 D+31   /
      DATA FACN  ( 31) / +.2652528598 1219105863 6308480000 000 D+33   /
      DATA SQ2PIL / 0.9189385332 0467274178 0329736405 62 D0 /
      DATA NMAX / 0 /
C***FIRST EXECUTABLE STATEMENT  DFAC
      IF (NMAX.NE.0) GO TO 10
      CALL DGAMLM (XMIN, XMAX)
      NMAX = XMAX - 1.D0
C
 10   IF (N .LT. 0) CALL XERMSG ('SLATEC', 'DFAC',
     +   'FACTORIAL OF NEGATIVE INTEGER UNDEFINED', 1, 2)
C
      IF (N.LE.30) DFAC = FACN(N+1)
      IF (N.LE.30) RETURN
C
      IF (N .GT. NMAX) CALL XERMSG ('SLATEC', 'DFAC',
     +   'N SO BIG FACTORIAL(N) OVERFLOWS', 2, 2)
C
      X = N + 1
      DFAC = EXP ((X-0.5D0)*LOG(X) - X + SQ2PIL + D9LGMC(X) )
C
      RETURN
      END

C---------------------------------------------------------------
C dgamlm.f
C---------------------------------------------------------------

*DECK DGAMLM
      SUBROUTINE DGAMLM (XMIN, XMAX)
C***BEGIN PROLOGUE  DGAMLM
C***PURPOSE  Compute the minimum and maximum bounds for the argument in
C            the Gamma function.
C***LIBRARY   SLATEC (FNLIB)
C***CATEGORY  C7A, R2
C***TYPE      DOUBLE PRECISION (GAMLIM-S, DGAMLM-D)
C***KEYWORDS  COMPLETE GAMMA FUNCTION, FNLIB, LIMITS, SPECIAL FUNCTIONS
C***AUTHOR  Fullerton, W., (LANL)
C***DESCRIPTION
C
C Calculate the minimum and maximum legal bounds for X in gamma(X).
C XMIN and XMAX are not the only bounds, but they are the only non-
C trivial ones to calculate.
C
C             Output Arguments --
C XMIN   double precision minimum legal value of X in gamma(X).  Any
C        smaller value of X might result in underflow.
C XMAX   double precision maximum legal value of X in gamma(X).  Any
C        larger value of X might cause overflow.
C
C***REFERENCES  (NONE)
C***ROUTINES CALLED  D1MACH, XERMSG
C***REVISION HISTORY  (YYMMDD)
C   770601  DATE WRITTEN
C   890531  Changed all specific intrinsics to generic.  (WRB)
C   890531  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   900315  CALLs to XERROR changed to CALLs to XERMSG.  (THJ)
C***END PROLOGUE  DGAMLM
      DOUBLE PRECISION XMIN, XMAX, ALNBIG, ALNSML, XLN, XOLD, D1MACH
C***FIRST EXECUTABLE STATEMENT  DGAMLM
      ALNSML = LOG(D1MACH(1))
      XMIN = -ALNSML
      DO 10 I=1,10
        XOLD = XMIN
        XLN = LOG(XMIN)
        XMIN = XMIN - XMIN*((XMIN+0.5D0)*XLN - XMIN - 0.2258D0 + ALNSML)
     1    / (XMIN*XLN+0.5D0)
        IF (ABS(XMIN-XOLD).LT.0.005D0) GO TO 20
 10   CONTINUE
      CALL XERMSG ('SLATEC', 'DGAMLM', 'UNABLE TO FIND XMIN', 1, 2)
C
 20   XMIN = -XMIN + 0.01D0
C
      ALNBIG = LOG (D1MACH(2))
      XMAX = ALNBIG
      DO 30 I=1,10
        XOLD = XMAX
        XLN = LOG(XMAX)
        XMAX = XMAX - XMAX*((XMAX-0.5D0)*XLN - XMAX + 0.9189D0 - ALNBIG)
     1    / (XMAX*XLN-0.5D0)
        IF (ABS(XMAX-XOLD).LT.0.005D0) GO TO 40
 30   CONTINUE
      CALL XERMSG ('SLATEC', 'DGAMLM', 'UNABLE TO FIND XMAX', 2, 2)
C
 40   XMAX = XMAX - 0.01D0
      XMIN = MAX (XMIN, -XMAX+1.D0)
C
      RETURN
      END

C---------------------------------------------------------------
C fdump.f
C---------------------------------------------------------------

*DECK FDUMP
      SUBROUTINE FDUMP
C***BEGIN PROLOGUE  FDUMP
C***PURPOSE  Symbolic dump (should be locally written).
C***LIBRARY   SLATEC (XERROR)
C***CATEGORY  R3
C***TYPE      ALL (FDUMP-A)
C***KEYWORDS  ERROR, XERMSG
C***AUTHOR  Jones, R. E., (SNLA)
C***DESCRIPTION
C
C        ***Note*** Machine Dependent Routine
C        FDUMP is intended to be replaced by a locally written
C        version which produces a symbolic dump.  Failing this,
C        it should be replaced by a version which prints the
C        subprogram nesting list.  Note that this dump must be
C        printed on each of up to five files, as indicated by the
C        XGETUA routine.  See XSETUA and XGETUA for details.
C
C     Written by Ron Jones, with SLATEC Common Math Library Subcommittee
C
C***REFERENCES  (NONE)
C***ROUTINES CALLED  (NONE)
C***REVISION HISTORY  (YYMMDD)
C   790801  DATE WRITTEN
C   861211  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C***END PROLOGUE  FDUMP
C***FIRST EXECUTABLE STATEMENT  FDUMP
      RETURN
      END

C---------------------------------------------------------------
C i1mach.f
C---------------------------------------------------------------


      INTEGER FUNCTION I1MACH (I)
C***BEGIN PROLOGUE  I1MACH
C***PURPOSE  Return integer machine dependent constants.
C***LIBRARY   SLATEC
C***CATEGORY  R1
C***TYPE      INTEGER (I1MACH-I)
C***KEYWORDS  MACHINE CONSTANTS
C***AUTHOR  Fox, P. A., (Bell Labs)
C           Hall, A. D., (Bell Labs)
C           Schryer, N. L., (Bell Labs)
C***DESCRIPTION
C
C   I1MACH can be used to obtain machine-dependent parameters for the
C   local machine environment.  It is a function subprogram with one
C   (input) argument and can be referenced as follows:
C
C        K = I1MACH(I)
C
C   where I=1,...,16.  The (output) value of K above is determined by
C   the (input) value of I.  The results for various values of I are
C   discussed below.
C
C   I/O unit numbers:
C     I1MACH( 1) = the standard input unit.
C     I1MACH( 2) = the standard output unit.
C     I1MACH( 3) = the standard punch unit.
C     I1MACH( 4) = the standard error message unit.
C
C   Words:
C     I1MACH( 5) = the number of bits per integer storage unit.
C     I1MACH( 6) = the number of characters per integer storage unit.
C
C   Integers:
C     assume integers are represented in the S-digit, base-A form
C
C                sign ( X(S-1)*A**(S-1) + ... + X(1)*A + X(0) )
C
C                where 0 .LE. X(I) .LT. A for I=0,...,S-1.
C     I1MACH( 7) = A, the base.
C     I1MACH( 8) = S, the number of base-A digits.
C     I1MACH( 9) = A**S - 1, the largest magnitude.
C
C   Floating-Point Numbers:
C     Assume floating-point numbers are represented in the T-digit,
C     base-B form
C                sign (B**E)*( (X(1)/B) + ... + (X(T)/B**T) )
C
C                where 0 .LE. X(I) .LT. B for I=1,...,T,
C                0 .LT. X(1), and EMIN .LE. E .LE. EMAX.
C     I1MACH(10) = B, the base.
C
C   Single-Precision:
C     I1MACH(11) = T, the number of base-B digits.
C     I1MACH(12) = EMIN, the smallest exponent E.
C     I1MACH(13) = EMAX, the largest exponent E.
C
C   Double-Precision:
C     I1MACH(14) = T, the number of base-B digits.
C     I1MACH(15) = EMIN, the smallest exponent E.
C     I1MACH(16) = EMAX, the largest exponent E.
C
C   To alter this function for a particular environment, the desired
C   set of DATA statements should be activated by removing the C from
C   column 1.  Also, the values of I1MACH(1) - I1MACH(4) should be
C   checked for consistency with the local operating system.
C
C***REFERENCES  P. A. Fox, A. D. Hall and N. L. Schryer, Framework for
C                 a portable library, ACM Transactions on Mathematical
C                 Software 4, 2 (June 1978), pp. 177-188.
C***ROUTINES CALLED  (NONE)
C***REVISION HISTORY  (YYMMDD)
C   750101  DATE WRITTEN
C   891012  Added VAX G-floating constants.  (WRB)
C   891012  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   900618  Added DEC RISC constants.  (WRB)
C   900723  Added IBM RS 6000 constants.  (WRB)
C   901009  Correct I1MACH(7) for IBM Mainframes. Should be 2 not 16.
C           (RWC)
C   910710  Added HP 730 constants.  (SMR)
C   911114  Added Convex IEEE constants.  (WRB)
C   920121  Added SUN -r8 compiler option constants.  (WRB)
C   920229  Added Touchstone Delta i860 constants.  (WRB)
C   920501  Reformatted the REFERENCES section.  (WRB)
C   920625  Added CONVEX -p8 and -pd8 compiler option constants.
C           (BKS, WRB)
C***END PROLOGUE  I1MACH
C
      INTEGER IMACH(16),OUTPUT
      SAVE IMACH
      EQUIVALENCE (IMACH(4),OUTPUT)
C
C     MACHINE CONSTANTS FOR THE AMIGA
C     ABSOFT COMPILER
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /          5 /
C     DATA IMACH( 4) /          6 /
C     DATA IMACH( 5) /         32 /
C     DATA IMACH( 6) /          4 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         31 /
C     DATA IMACH( 9) / 2147483647 /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         24 /
C     DATA IMACH(12) /       -126 /
C     DATA IMACH(13) /        127 /
C     DATA IMACH(14) /         53 /
C     DATA IMACH(15) /      -1022 /
C     DATA IMACH(16) /       1023 /
C
C     MACHINE CONSTANTS FOR THE APOLLO
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /          6 /
C     DATA IMACH( 4) /          6 /
C     DATA IMACH( 5) /         32 /
C     DATA IMACH( 6) /          4 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         31 /
C     DATA IMACH( 9) / 2147483647 /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         24 /
C     DATA IMACH(12) /       -125 /
C     DATA IMACH(13) /        129 /
C     DATA IMACH(14) /         53 /
C     DATA IMACH(15) /      -1021 /
C     DATA IMACH(16) /       1025 /
C
C     MACHINE CONSTANTS FOR THE BURROUGHS 1700 SYSTEM
C
C     DATA IMACH( 1) /          7 /
C     DATA IMACH( 2) /          2 /
C     DATA IMACH( 3) /          2 /
C     DATA IMACH( 4) /          2 /
C     DATA IMACH( 5) /         36 /
C     DATA IMACH( 6) /          4 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         33 /
C     DATA IMACH( 9) / Z1FFFFFFFF /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         24 /
C     DATA IMACH(12) /       -256 /
C     DATA IMACH(13) /        255 /
C     DATA IMACH(14) /         60 /
C     DATA IMACH(15) /       -256 /
C     DATA IMACH(16) /        255 /
C
C     MACHINE CONSTANTS FOR THE BURROUGHS 5700 SYSTEM
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /          7 /
C     DATA IMACH( 4) /          6 /
C     DATA IMACH( 5) /         48 /
C     DATA IMACH( 6) /          6 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         39 /
C     DATA IMACH( 9) / O0007777777777777 /
C     DATA IMACH(10) /          8 /
C     DATA IMACH(11) /         13 /
C     DATA IMACH(12) /        -50 /
C     DATA IMACH(13) /         76 /
C     DATA IMACH(14) /         26 /
C     DATA IMACH(15) /        -50 /
C     DATA IMACH(16) /         76 /
C
C     MACHINE CONSTANTS FOR THE BURROUGHS 6700/7700 SYSTEMS
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /          7 /
C     DATA IMACH( 4) /          6 /
C     DATA IMACH( 5) /         48 /
C     DATA IMACH( 6) /          6 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         39 /
C     DATA IMACH( 9) / O0007777777777777 /
C     DATA IMACH(10) /          8 /
C     DATA IMACH(11) /         13 /
C     DATA IMACH(12) /        -50 /
C     DATA IMACH(13) /         76 /
C     DATA IMACH(14) /         26 /
C     DATA IMACH(15) /     -32754 /
C     DATA IMACH(16) /      32780 /
C
C     MACHINE CONSTANTS FOR THE CDC 170/180 SERIES USING NOS/VE
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /          7 /
C     DATA IMACH( 4) /          6 /
C     DATA IMACH( 5) /         64 /
C     DATA IMACH( 6) /          8 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         63 /
C     DATA IMACH( 9) / 9223372036854775807 /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         47 /
C     DATA IMACH(12) /      -4095 /
C     DATA IMACH(13) /       4094 /
C     DATA IMACH(14) /         94 /
C     DATA IMACH(15) /      -4095 /
C     DATA IMACH(16) /       4094 /
C
C     MACHINE CONSTANTS FOR THE CDC 6000/7000 SERIES
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /          7 /
C     DATA IMACH( 4) /    6LOUTPUT/
C     DATA IMACH( 5) /         60 /
C     DATA IMACH( 6) /         10 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         48 /
C     DATA IMACH( 9) / 00007777777777777777B /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         47 /
C     DATA IMACH(12) /       -929 /
C     DATA IMACH(13) /       1070 /
C     DATA IMACH(14) /         94 /
C     DATA IMACH(15) /       -929 /
C     DATA IMACH(16) /       1069 /
C
C     MACHINE CONSTANTS FOR THE CELERITY C1260
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /          6 /
C     DATA IMACH( 4) /          0 /
C     DATA IMACH( 5) /         32 /
C     DATA IMACH( 6) /          4 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         31 /
C     DATA IMACH( 9) / Z'7FFFFFFF' /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         24 /
C     DATA IMACH(12) /       -126 /
C     DATA IMACH(13) /        127 /
C     DATA IMACH(14) /         53 /
C     DATA IMACH(15) /      -1022 /
C     DATA IMACH(16) /       1023 /
C
C     MACHINE CONSTANTS FOR THE CONVEX
C     USING THE -fn COMPILER OPTION
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /          7 /
C     DATA IMACH( 4) /          6 /
C     DATA IMACH( 5) /         32 /
C     DATA IMACH( 6) /          4 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         31 /
C     DATA IMACH( 9) / 2147483647 /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         24 /
C     DATA IMACH(12) /       -127 /
C     DATA IMACH(13) /        127 /
C     DATA IMACH(14) /         53 /
C     DATA IMACH(15) /      -1023 /
C     DATA IMACH(16) /       1023 /
C
C     MACHINE CONSTANTS FOR THE CONVEX
C     USING THE -fi COMPILER OPTION
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /          7 /
C     DATA IMACH( 4) /          6 /
C     DATA IMACH( 5) /         32 /
C     DATA IMACH( 6) /          4 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         31 /
C     DATA IMACH( 9) / 2147483647 /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         24 /
C     DATA IMACH(12) /       -125 /
C     DATA IMACH(13) /        128 /
C     DATA IMACH(14) /         53 /
C     DATA IMACH(15) /      -1021 /
C     DATA IMACH(16) /       1024 /
C
C     MACHINE CONSTANTS FOR THE CONVEX
C     USING THE -p8 COMPILER OPTION
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /          7 /
C     DATA IMACH( 4) /          6 /
C     DATA IMACH( 5) /         32 /
C     DATA IMACH( 6) /          4 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         63 /
C     DATA IMACH( 9) / 9223372036854775807 /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         53 /
C     DATA IMACH(12) /      -1023 /
C     DATA IMACH(13) /       1023 /
C     DATA IMACH(14) /        113 /
C     DATA IMACH(15) /     -16383 /
C     DATA IMACH(16) /      16383 /
C
C     MACHINE CONSTANTS FOR THE CONVEX
C     USING THE -pd8 COMPILER OPTION
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /          7 /
C     DATA IMACH( 4) /          6 /
C     DATA IMACH( 5) /         32 /
C     DATA IMACH( 6) /          4 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         63 /
C     DATA IMACH( 9) / 9223372036854775807 /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         53 /
C     DATA IMACH(12) /      -1023 /
C     DATA IMACH(13) /       1023 /
C     DATA IMACH(14) /         53 /
C     DATA IMACH(15) /      -1023 /
C     DATA IMACH(16) /       1023 /
C
C     MACHINE CONSTANTS FOR THE CRAY
C     USING THE 46 BIT INTEGER COMPILER OPTION
C
C     DATA IMACH( 1) /        100 /
C     DATA IMACH( 2) /        101 /
C     DATA IMACH( 3) /        102 /
C     DATA IMACH( 4) /        101 /
C     DATA IMACH( 5) /         64 /
C     DATA IMACH( 6) /          8 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         46 /
C     DATA IMACH( 9) / 1777777777777777B /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         47 /
C     DATA IMACH(12) /      -8189 /
C     DATA IMACH(13) /       8190 /
C     DATA IMACH(14) /         94 /
C     DATA IMACH(15) /      -8099 /
C     DATA IMACH(16) /       8190 /
C
C     MACHINE CONSTANTS FOR THE CRAY
C     USING THE 64 BIT INTEGER COMPILER OPTION
C
C     DATA IMACH( 1) /        100 /
C     DATA IMACH( 2) /        101 /
C     DATA IMACH( 3) /        102 /
C     DATA IMACH( 4) /        101 /
C     DATA IMACH( 5) /         64 /
C     DATA IMACH( 6) /          8 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         63 /
C     DATA IMACH( 9) / 777777777777777777777B /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         47 /
C     DATA IMACH(12) /      -8189 /
C     DATA IMACH(13) /       8190 /
C     DATA IMACH(14) /         94 /
C     DATA IMACH(15) /      -8099 /
C     DATA IMACH(16) /       8190 /
C
C     MACHINE CONSTANTS FOR THE DATA GENERAL ECLIPSE S/200
C
C     DATA IMACH( 1) /         11 /
C     DATA IMACH( 2) /         12 /
C     DATA IMACH( 3) /          8 /
C     DATA IMACH( 4) /         10 /
C     DATA IMACH( 5) /         16 /
C     DATA IMACH( 6) /          2 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         15 /
C     DATA IMACH( 9) /      32767 /
C     DATA IMACH(10) /         16 /
C     DATA IMACH(11) /          6 /
C     DATA IMACH(12) /        -64 /
C     DATA IMACH(13) /         63 /
C     DATA IMACH(14) /         14 /
C     DATA IMACH(15) /        -64 /
C     DATA IMACH(16) /         63 /
C
C     MACHINE CONSTANTS FOR THE DEC RISC
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /          6 /
C     DATA IMACH( 4) /          6 /
C     DATA IMACH( 5) /         32 /
C     DATA IMACH( 6) /          4 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         31 /
C     DATA IMACH( 9) / 2147483647 /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         24 /
C     DATA IMACH(12) /       -125 /
C     DATA IMACH(13) /        128 /
C     DATA IMACH(14) /         53 /
C     DATA IMACH(15) /      -1021 /
C     DATA IMACH(16) /       1024 /
C
C     MACHINE CONSTANTS FOR THE ELXSI 6400
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /          6 /
C     DATA IMACH( 4) /          6 /
C     DATA IMACH( 5) /         32 /
C     DATA IMACH( 6) /          4 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         32 /
C     DATA IMACH( 9) / 2147483647 /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         24 /
C     DATA IMACH(12) /       -126 /
C     DATA IMACH(13) /        127 /
C     DATA IMACH(14) /         53 /
C     DATA IMACH(15) /      -1022 /
C     DATA IMACH(16) /       1023 /
C
C     MACHINE CONSTANTS FOR THE HARRIS 220
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /          0 /
C     DATA IMACH( 4) /          6 /
C     DATA IMACH( 5) /         24 /
C     DATA IMACH( 6) /          3 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         23 /
C     DATA IMACH( 9) /    8388607 /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         23 /
C     DATA IMACH(12) /       -127 /
C     DATA IMACH(13) /        127 /
C     DATA IMACH(14) /         38 /
C     DATA IMACH(15) /       -127 /
C     DATA IMACH(16) /        127 /
C
C     MACHINE CONSTANTS FOR THE HONEYWELL 600/6000 SERIES
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /         43 /
C     DATA IMACH( 4) /          6 /
C     DATA IMACH( 5) /         36 /
C     DATA IMACH( 6) /          6 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         35 /
C     DATA IMACH( 9) / O377777777777 /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         27 /
C     DATA IMACH(12) /       -127 /
C     DATA IMACH(13) /        127 /
C     DATA IMACH(14) /         63 /
C     DATA IMACH(15) /       -127 /
C     DATA IMACH(16) /        127 /
C
C     MACHINE CONSTANTS FOR THE HP 730
C
      DATA IMACH( 1) /          5 /
      DATA IMACH( 2) /          6 /
      DATA IMACH( 3) /          6 /
      DATA IMACH( 4) /          6 /
      DATA IMACH( 5) /         32 /
      DATA IMACH( 6) /          4 /
      DATA IMACH( 7) /          2 /
      DATA IMACH( 8) /         31 /
      DATA IMACH( 9) / 2147483647 /
      DATA IMACH(10) /          2 /
      DATA IMACH(11) /         24 /
      DATA IMACH(12) /       -125 /
      DATA IMACH(13) /        128 /
      DATA IMACH(14) /         53 /
      DATA IMACH(15) /      -1021 /
      DATA IMACH(16) /       1024 /
C
C     MACHINE CONSTANTS FOR THE HP 2100
C     3 WORD DOUBLE PRECISION OPTION WITH FTN4
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /          4 /
C     DATA IMACH( 4) /          1 /
C     DATA IMACH( 5) /         16 /
C     DATA IMACH( 6) /          2 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         15 /
C     DATA IMACH( 9) /      32767 /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         23 /
C     DATA IMACH(12) /       -128 /
C     DATA IMACH(13) /        127 /
C     DATA IMACH(14) /         39 /
C     DATA IMACH(15) /       -128 /
C     DATA IMACH(16) /        127 /
C
C     MACHINE CONSTANTS FOR THE HP 2100
C     4 WORD DOUBLE PRECISION OPTION WITH FTN4
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /          4 /
C     DATA IMACH( 4) /          1 /
C     DATA IMACH( 5) /         16 /
C     DATA IMACH( 6) /          2 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         15 /
C     DATA IMACH( 9) /      32767 /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         23 /
C     DATA IMACH(12) /       -128 /
C     DATA IMACH(13) /        127 /
C     DATA IMACH(14) /         55 /
C     DATA IMACH(15) /       -128 /
C     DATA IMACH(16) /        127 /
C
C     MACHINE CONSTANTS FOR THE HP 9000
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /          6 /
C     DATA IMACH( 4) /          7 /
C     DATA IMACH( 5) /         32 /
C     DATA IMACH( 6) /          4 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         32 /
C     DATA IMACH( 9) / 2147483647 /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         24 /
C     DATA IMACH(12) /       -126 /
C     DATA IMACH(13) /        127 /
C     DATA IMACH(14) /         53 /
C     DATA IMACH(15) /      -1015 /
C     DATA IMACH(16) /       1017 /
C
C     MACHINE CONSTANTS FOR THE IBM 360/370 SERIES,
C     THE XEROX SIGMA 5/7/9, THE SEL SYSTEMS 85/86, AND
C     THE PERKIN ELMER (INTERDATA) 7/32.
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /          7 /
C     DATA IMACH( 4) /          6 /
C     DATA IMACH( 5) /         32 /
C     DATA IMACH( 6) /          4 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         31 /
C     DATA IMACH( 9) /  Z7FFFFFFF /
C     DATA IMACH(10) /         16 /
C     DATA IMACH(11) /          6 /
C     DATA IMACH(12) /        -64 /
C     DATA IMACH(13) /         63 /
C     DATA IMACH(14) /         14 /
C     DATA IMACH(15) /        -64 /
C     DATA IMACH(16) /         63 /
C
C     MACHINE CONSTANTS FOR THE IBM PC
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /          0 /
C     DATA IMACH( 4) /          0 /
C     DATA IMACH( 5) /         32 /
C     DATA IMACH( 6) /          4 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         31 /
C     DATA IMACH( 9) / 2147483647 /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         24 /
C     DATA IMACH(12) /       -125 /
C     DATA IMACH(13) /        127 /
C     DATA IMACH(14) /         53 /
C     DATA IMACH(15) /      -1021 /
C     DATA IMACH(16) /       1023 /
C
C     MACHINE CONSTANTS FOR THE IBM RS 6000
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /          6 /
C     DATA IMACH( 4) /          0 /
C     DATA IMACH( 5) /         32 /
C     DATA IMACH( 6) /          4 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         31 /
C     DATA IMACH( 9) / 2147483647 /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         24 /
C     DATA IMACH(12) /       -125 /
C     DATA IMACH(13) /        128 /
C     DATA IMACH(14) /         53 /
C     DATA IMACH(15) /      -1021 /
C     DATA IMACH(16) /       1024 /
C
C     MACHINE CONSTANTS FOR THE INTEL i860
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /          6 /
C     DATA IMACH( 4) /          6 /
C     DATA IMACH( 5) /         32 /
C     DATA IMACH( 6) /          4 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         31 /
C     DATA IMACH( 9) / 2147483647 /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         24 /
C     DATA IMACH(12) /       -125 /
C     DATA IMACH(13) /        128 /
C     DATA IMACH(14) /         53 /
C     DATA IMACH(15) /      -1021 /
C     DATA IMACH(16) /       1024 /
C
C     MACHINE CONSTANTS FOR THE PDP-10 (KA PROCESSOR)
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /          5 /
C     DATA IMACH( 4) /          6 /
C     DATA IMACH( 5) /         36 /
C     DATA IMACH( 6) /          5 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         35 /
C     DATA IMACH( 9) / "377777777777 /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         27 /
C     DATA IMACH(12) /       -128 /
C     DATA IMACH(13) /        127 /
C     DATA IMACH(14) /         54 /
C     DATA IMACH(15) /       -101 /
C     DATA IMACH(16) /        127 /
C
C     MACHINE CONSTANTS FOR THE PDP-10 (KI PROCESSOR)
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /          5 /
C     DATA IMACH( 4) /          6 /
C     DATA IMACH( 5) /         36 /
C     DATA IMACH( 6) /          5 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         35 /
C     DATA IMACH( 9) / "377777777777 /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         27 /
C     DATA IMACH(12) /       -128 /
C     DATA IMACH(13) /        127 /
C     DATA IMACH(14) /         62 /
C     DATA IMACH(15) /       -128 /
C     DATA IMACH(16) /        127 /
C
C     MACHINE CONSTANTS FOR PDP-11 FORTRAN SUPPORTING
C     32-BIT INTEGER ARITHMETIC.
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /          5 /
C     DATA IMACH( 4) /          6 /
C     DATA IMACH( 5) /         32 /
C     DATA IMACH( 6) /          4 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         31 /
C     DATA IMACH( 9) / 2147483647 /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         24 /
C     DATA IMACH(12) /       -127 /
C     DATA IMACH(13) /        127 /
C     DATA IMACH(14) /         56 /
C     DATA IMACH(15) /       -127 /
C     DATA IMACH(16) /        127 /
C
C     MACHINE CONSTANTS FOR PDP-11 FORTRAN SUPPORTING
C     16-BIT INTEGER ARITHMETIC.
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /          5 /
C     DATA IMACH( 4) /          6 /
C     DATA IMACH( 5) /         16 /
C     DATA IMACH( 6) /          2 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         15 /
C     DATA IMACH( 9) /      32767 /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         24 /
C     DATA IMACH(12) /       -127 /
C     DATA IMACH(13) /        127 /
C     DATA IMACH(14) /         56 /
C     DATA IMACH(15) /       -127 /
C     DATA IMACH(16) /        127 /
C
C     MACHINE CONSTANTS FOR THE SUN
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /          6 /
C     DATA IMACH( 4) /          6 /
C     DATA IMACH( 5) /         32 /
C     DATA IMACH( 6) /          4 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         31 /
C     DATA IMACH( 9) / 2147483647 /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         24 /
C     DATA IMACH(12) /       -125 /
C     DATA IMACH(13) /        128 /
C     DATA IMACH(14) /         53 /
C     DATA IMACH(15) /      -1021 /
C     DATA IMACH(16) /       1024 /
C
C     MACHINE CONSTANTS FOR THE SUN
C     USING THE -r8 COMPILER OPTION
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /          6 /
C     DATA IMACH( 4) /          6 /
C     DATA IMACH( 5) /         32 /
C     DATA IMACH( 6) /          4 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         31 /
C     DATA IMACH( 9) / 2147483647 /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         53 /
C     DATA IMACH(12) /      -1021 /
C     DATA IMACH(13) /       1024 /
C     DATA IMACH(14) /        113 /
C     DATA IMACH(15) /     -16381 /
C     DATA IMACH(16) /      16384 /
C
C     MACHINE CONSTANTS FOR THE UNIVAC 1100 SERIES FTN COMPILER
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /          1 /
C     DATA IMACH( 4) /          6 /
C     DATA IMACH( 5) /         36 /
C     DATA IMACH( 6) /          4 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         35 /
C     DATA IMACH( 9) / O377777777777 /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         27 /
C     DATA IMACH(12) /       -128 /
C     DATA IMACH(13) /        127 /
C     DATA IMACH(14) /         60 /
C     DATA IMACH(15) /      -1024 /
C     DATA IMACH(16) /       1023 /
C
C     MACHINE CONSTANTS FOR THE VAX (D-FLOATING)
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /          5 /
C     DATA IMACH( 4) /          6 /
C     DATA IMACH( 5) /         32 /
C     DATA IMACH( 6) /          4 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         31 /
C     DATA IMACH( 9) / 2147483647 /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         24 /
C     DATA IMACH(12) /       -127 /
C     DATA IMACH(13) /        127 /
C     DATA IMACH(14) /         56 /
C     DATA IMACH(15) /       -127 /
C     DATA IMACH(16) /        127 /
C
C     MACHINE CONSTANTS FOR THE VAX (G-FLOATING)
C
C     DATA IMACH( 1) /          5 /
C     DATA IMACH( 2) /          6 /
C     DATA IMACH( 3) /          5 /
C     DATA IMACH( 4) /          6 /
C     DATA IMACH( 5) /         32 /
C     DATA IMACH( 6) /          4 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         31 /
C     DATA IMACH( 9) / 2147483647 /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         24 /
C     DATA IMACH(12) /       -127 /
C     DATA IMACH(13) /        127 /
C     DATA IMACH(14) /         53 /
C     DATA IMACH(15) /      -1023 /
C     DATA IMACH(16) /       1023 /
C
C     MACHINE CONSTANTS FOR THE Z80 MICROPROCESSOR
C
C     DATA IMACH( 1) /          1 /
C     DATA IMACH( 2) /          1 /
C     DATA IMACH( 3) /          0 /
C     DATA IMACH( 4) /          1 /
C     DATA IMACH( 5) /         16 /
C     DATA IMACH( 6) /          2 /
C     DATA IMACH( 7) /          2 /
C     DATA IMACH( 8) /         15 /
C     DATA IMACH( 9) /      32767 /
C     DATA IMACH(10) /          2 /
C     DATA IMACH(11) /         24 /
C     DATA IMACH(12) /       -127 /
C     DATA IMACH(13) /        127 /
C     DATA IMACH(14) /         56 /
C     DATA IMACH(15) /       -127 /
C     DATA IMACH(16) /        127 /
C
C***FIRST EXECUTABLE STATEMENT  I1MACH
      IF (I .LT. 1  .OR.  I .GT. 16) GO TO 10
C
      I1MACH = IMACH(I)
      RETURN
C
   10 CONTINUE
      WRITE (UNIT = OUTPUT, FMT = 9000)
 9000 FORMAT ('1ERROR    1 IN I1MACH - I OUT OF BOUNDS')
C
C     CALL FDUMP
C
      STOP
      END


C---------------------------------------------------------------
C initds.f
C---------------------------------------------------------------

*DECK INITDS
      FUNCTION INITDS (OS, NOS, ETA)
C***BEGIN PROLOGUE  INITDS
C***PURPOSE  Determine the number of terms needed in an orthogonal
C            polynomial series so that it meets a specified accuracy.
C***LIBRARY   SLATEC (FNLIB)
C***CATEGORY  C3A2
C***TYPE      DOUBLE PRECISION (INITS-S, INITDS-D)
C***KEYWORDS  CHEBYSHEV, FNLIB, INITIALIZE, ORTHOGONAL POLYNOMIAL,
C             ORTHOGONAL SERIES, SPECIAL FUNCTIONS
C***AUTHOR  Fullerton, W., (LANL)
C***DESCRIPTION
C
C  Initialize the orthogonal series, represented by the array OS, so
C  that INITDS is the number of terms needed to insure the error is no
C  larger than ETA.  Ordinarily, ETA will be chosen to be one-tenth
C  machine precision.
C
C             Input Arguments --
C   OS     double precision array of NOS coefficients in an orthogonal
C          series.
C   NOS    number of coefficients in OS.
C   ETA    single precision scalar containing requested accuracy of
C          series.
C
C***REFERENCES  (NONE)
C***ROUTINES CALLED  XERMSG
C***REVISION HISTORY  (YYMMDD)
C   770601  DATE WRITTEN
C   890531  Changed all specific intrinsics to generic.  (WRB)
C   890831  Modified array declarations.  (WRB)
C   891115  Modified error message.  (WRB)
C   891115  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   900315  CALLs to XERROR changed to CALLs to XERMSG.  (THJ)
C***END PROLOGUE  INITDS
      DOUBLE PRECISION OS(*)
C***FIRST EXECUTABLE STATEMENT  INITDS
      IF (NOS .LT. 1) CALL XERMSG ('SLATEC', 'INITDS',
     +   'Number of coefficients is less than 1', 2, 1)
C
      ERR = 0.
      DO 10 II = 1,NOS
        I = NOS + 1 - II
        ERR = ERR + ABS(REAL(OS(I)))
        IF (ERR.GT.ETA) GO TO 20
   10 CONTINUE
C
   20 IF (I .EQ. NOS) CALL XERMSG ('SLATEC', 'INITDS',
     +   'Chebyshev series too short for specified accuracy', 1, 1)
      INITDS = I
C
      RETURN
      END

C---------------------------------------------------------------
C inits.f
C---------------------------------------------------------------

*DECK INITS
      FUNCTION INITS (OS, NOS, ETA)
C***BEGIN PROLOGUE  INITS
C***PURPOSE  Determine the number of terms needed in an orthogonal
C            polynomial series so that it meets a specified accuracy.
C***LIBRARY   SLATEC (FNLIB)
C***CATEGORY  C3A2
C***TYPE      SINGLE PRECISION (INITS-S, INITDS-D)
C***KEYWORDS  CHEBYSHEV, FNLIB, INITIALIZE, ORTHOGONAL POLYNOMIAL,
C             ORTHOGONAL SERIES, SPECIAL FUNCTIONS
C***AUTHOR  Fullerton, W., (LANL)
C***DESCRIPTION
C
C  Initialize the orthogonal series, represented by the array OS, so
C  that INITS is the number of terms needed to insure the error is no
C  larger than ETA.  Ordinarily, ETA will be chosen to be one-tenth
C  machine precision.
C
C             Input Arguments --
C   OS     single precision array of NOS coefficients in an orthogonal
C          series.
C   NOS    number of coefficients in OS.
C   ETA    single precision scalar containing requested accuracy of
C          series.
C
C***REFERENCES  (NONE)
C***ROUTINES CALLED  XERMSG
C***REVISION HISTORY  (YYMMDD)
C   770401  DATE WRITTEN
C   890831  Modified array declarations.  (WRB)
C   891115  Modified error message.  (WRB)
C   891115  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   900315  CALLs to XERROR changed to CALLs to XERMSG.  (THJ)
C***END PROLOGUE  INITS
      REAL OS(*)
C***FIRST EXECUTABLE STATEMENT  INITS
      IF (NOS .LT. 1) CALL XERMSG ('SLATEC', 'INITS',
     +   'Number of coefficients is less than 1', 2, 1)
C
      ERR = 0.
      DO 10 II = 1,NOS
        I = NOS + 1 - II
        ERR = ERR + ABS(OS(I))
        IF (ERR.GT.ETA) GO TO 20
   10 CONTINUE
C
   20 IF (I .EQ. NOS) CALL XERMSG ('SLATEC', 'INITS',
     +   'Chebyshev series too short for specified accuracy', 1, 1)
      INITS = I
C
      RETURN
      END

C---------------------------------------------------------------
C j4save.f
C---------------------------------------------------------------

*DECK J4SAVE
      FUNCTION J4SAVE (IWHICH, IVALUE, ISET)
C***BEGIN PROLOGUE  J4SAVE
C***SUBSIDIARY
C***PURPOSE  Save or recall global variables needed by error
C            handling routines.
C***LIBRARY   SLATEC (XERROR)
C***TYPE      INTEGER (J4SAVE-I)
C***KEYWORDS  ERROR MESSAGES, ERROR NUMBER, RECALL, SAVE, XERROR
C***AUTHOR  Jones, R. E., (SNLA)
C***DESCRIPTION
C
C     Abstract
C        J4SAVE saves and recalls several global variables needed
C        by the library error handling routines.
C
C     Description of Parameters
C      --Input--
C        IWHICH - Index of item desired.
C                = 1 Refers to current error number.
C                = 2 Refers to current error control flag.
C                = 3 Refers to current unit number to which error
C                    messages are to be sent.  (0 means use standard.)
C                = 4 Refers to the maximum number of times any
C                     message is to be printed (as set by XERMAX).
C                = 5 Refers to the total number of units to which
C                     each error message is to be written.
C                = 6 Refers to the 2nd unit for error messages
C                = 7 Refers to the 3rd unit for error messages
C                = 8 Refers to the 4th unit for error messages
C                = 9 Refers to the 5th unit for error messages
C        IVALUE - The value to be set for the IWHICH-th parameter,
C                 if ISET is .TRUE. .
C        ISET   - If ISET=.TRUE., the IWHICH-th parameter will BE
C                 given the value, IVALUE.  If ISET=.FALSE., the
C                 IWHICH-th parameter will be unchanged, and IVALUE
C                 is a dummy parameter.
C      --Output--
C        The (old) value of the IWHICH-th parameter will be returned
C        in the function value, J4SAVE.
C
C***SEE ALSO  XERMSG
C***REFERENCES  R. E. Jones and D. K. Kahaner, XERROR, the SLATEC
C                 Error-handling Package, SAND82-0800, Sandia
C                 Laboratories, 1982.
C***ROUTINES CALLED  (NONE)
C***REVISION HISTORY  (YYMMDD)
C   790801  DATE WRITTEN
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   900205  Minor modifications to prologue.  (WRB)
C   900402  Added TYPE section.  (WRB)
C   910411  Added KEYWORDS section.  (WRB)
C   920501  Reformatted the REFERENCES section.  (WRB)
C***END PROLOGUE  J4SAVE
      LOGICAL ISET
      INTEGER IPARAM(9)
      SAVE IPARAM
      DATA IPARAM(1),IPARAM(2),IPARAM(3),IPARAM(4)/0,2,0,10/
      DATA IPARAM(5)/1/
      DATA IPARAM(6),IPARAM(7),IPARAM(8),IPARAM(9)/0,0,0,0/
C***FIRST EXECUTABLE STATEMENT  J4SAVE
      J4SAVE = IPARAM(IWHICH)
      IF (ISET) IPARAM(IWHICH) = IVALUE
      RETURN
      END

C---------------------------------------------------------------
C r1mach.f
C---------------------------------------------------------------


      REAL FUNCTION R1MACH (I)
C***BEGIN PROLOGUE  R1MACH
C***PURPOSE  Return floating point machine dependent constants.
C***LIBRARY   SLATEC
C***CATEGORY  R1
C***TYPE      SINGLE PRECISION (R1MACH-S, D1MACH-D)
C***KEYWORDS  MACHINE CONSTANTS
C***AUTHOR  Fox, P. A., (Bell Labs)
C           Hall, A. D., (Bell Labs)
C           Schryer, N. L., (Bell Labs)
C***DESCRIPTION
C
C   R1MACH can be used to obtain machine-dependent parameters for the
C   local machine environment.  It is a function subprogram with one
C   (input) argument, and can be referenced as follows:
C
C        A = R1MACH(I)
C
C   where I=1,...,5.  The (output) value of A above is determined by
C   the (input) value of I.  The results for various values of I are
C   discussed below.
C
C   R1MACH(1) = B**(EMIN-1), the smallest positive magnitude.
C   R1MACH(2) = B**EMAX*(1 - B**(-T)), the largest magnitude.
C   R1MACH(3) = B**(-T), the smallest relative spacing.
C   R1MACH(4) = B**(1-T), the largest relative spacing.
C   R1MACH(5) = LOG10(B)
C
C   Assume single precision numbers are represented in the T-digit,
C   base-B form
C
C              sign (B**E)*( (X(1)/B) + ... + (X(T)/B**T) )
C
C   where 0 .LE. X(I) .LT. B for I=1,...,T, 0 .LT. X(1), and
C   EMIN .LE. E .LE. EMAX.
C
C   The values of B, T, EMIN and EMAX are provided in I1MACH as
C   follows:
C   I1MACH(10) = B, the base.
C   I1MACH(11) = T, the number of base-B digits.
C   I1MACH(12) = EMIN, the smallest exponent E.
C   I1MACH(13) = EMAX, the largest exponent E.
C
C   To alter this function for a particular environment, the desired
C   set of DATA statements should be activated by removing the C from
C   column 1.  Also, the values of R1MACH(1) - R1MACH(4) should be
C   checked for consistency with the local operating system.
C
C***REFERENCES  P. A. Fox, A. D. Hall and N. L. Schryer, Framework for
C                 a portable library, ACM Transactions on Mathematical
C                 Software 4, 2 (June 1978), pp. 177-188.
C***ROUTINES CALLED  XERMSG
C***REVISION HISTORY  (YYMMDD)
C   790101  DATE WRITTEN
C   890213  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   900315  CALLs to XERROR changed to CALLs to XERMSG.  (THJ)
C   900618  Added DEC RISC constants.  (WRB)
C   900723  Added IBM RS 6000 constants.  (WRB)
C   910710  Added HP 730 constants.  (SMR)
C   911114  Added Convex IEEE constants.  (WRB)
C   920121  Added SUN -r8 compiler option constants.  (WRB)
C   920229  Added Touchstone Delta i860 constants.  (WRB)
C   920501  Reformatted the REFERENCES section.  (WRB)
C   920625  Added CONVEX -p8 and -pd8 compiler option constants.
C           (BKS, WRB)
C   930201  Added DEC Alpha and SGI constants.  (RWC and WRB)
C***END PROLOGUE  R1MACH
C
      INTEGER SMALL(2)
      INTEGER LARGE(2)
      INTEGER RIGHT(2)
      INTEGER DIVER(2)
      INTEGER LOG10(2)
C
      REAL RMACH(5)
      SAVE RMACH
C
      EQUIVALENCE (RMACH(1),SMALL(1))
      EQUIVALENCE (RMACH(2),LARGE(1))
      EQUIVALENCE (RMACH(3),RIGHT(1))
      EQUIVALENCE (RMACH(4),DIVER(1))
      EQUIVALENCE (RMACH(5),LOG10(1))
C
C     MACHINE CONSTANTS FOR THE AMIGA
C     ABSOFT FORTRAN COMPILER USING THE 68020/68881 COMPILER OPTION
C
C     DATA SMALL(1) / Z'00800000' /
C     DATA LARGE(1) / Z'7F7FFFFF' /
C     DATA RIGHT(1) / Z'33800000' /
C     DATA DIVER(1) / Z'34000000' /
C     DATA LOG10(1) / Z'3E9A209B' /
C
C     MACHINE CONSTANTS FOR THE AMIGA
C     ABSOFT FORTRAN COMPILER USING SOFTWARE FLOATING POINT
C
C     DATA SMALL(1) / Z'00800000' /
C     DATA LARGE(1) / Z'7EFFFFFF' /
C     DATA RIGHT(1) / Z'33800000' /
C     DATA DIVER(1) / Z'34000000' /
C     DATA LOG10(1) / Z'3E9A209B' /
C
C     MACHINE CONSTANTS FOR THE APOLLO
C
C     DATA SMALL(1) / 16#00800000 /
C     DATA LARGE(1) / 16#7FFFFFFF /
C     DATA RIGHT(1) / 16#33800000 /
C     DATA DIVER(1) / 16#34000000 /
C     DATA LOG10(1) / 16#3E9A209B /
C
C     MACHINE CONSTANTS FOR THE BURROUGHS 1700 SYSTEM
C
C     DATA RMACH(1) / Z400800000 /
C     DATA RMACH(2) / Z5FFFFFFFF /
C     DATA RMACH(3) / Z4E9800000 /
C     DATA RMACH(4) / Z4EA800000 /
C     DATA RMACH(5) / Z500E730E8 /
C
C     MACHINE CONSTANTS FOR THE BURROUGHS 5700/6700/7700 SYSTEMS
C
C     DATA RMACH(1) / O1771000000000000 /
C     DATA RMACH(2) / O0777777777777777 /
C     DATA RMACH(3) / O1311000000000000 /
C     DATA RMACH(4) / O1301000000000000 /
C     DATA RMACH(5) / O1157163034761675 /
C
C     MACHINE CONSTANTS FOR THE CDC 170/180 SERIES USING NOS/VE
C
C     DATA RMACH(1) / Z"3001800000000000" /
C     DATA RMACH(2) / Z"4FFEFFFFFFFFFFFE" /
C     DATA RMACH(3) / Z"3FD2800000000000" /
C     DATA RMACH(4) / Z"3FD3800000000000" /
C     DATA RMACH(5) / Z"3FFF9A209A84FBCF" /
C
C     MACHINE CONSTANTS FOR THE CDC 6000/7000 SERIES
C
C     DATA RMACH(1) / 00564000000000000000B /
C     DATA RMACH(2) / 37767777777777777776B /
C     DATA RMACH(3) / 16414000000000000000B /
C     DATA RMACH(4) / 16424000000000000000B /
C     DATA RMACH(5) / 17164642023241175720B /
C
C     MACHINE CONSTANTS FOR THE CELERITY C1260
C
C     DATA SMALL(1) / Z'00800000' /
C     DATA LARGE(1) / Z'7F7FFFFF' /
C     DATA RIGHT(1) / Z'33800000' /
C     DATA DIVER(1) / Z'34000000' /
C     DATA LOG10(1) / Z'3E9A209B' /
C
C     MACHINE CONSTANTS FOR THE CONVEX
C     USING THE -fn COMPILER OPTION
C
C     DATA RMACH(1) / Z'00800000' /
C     DATA RMACH(2) / Z'7FFFFFFF' /
C     DATA RMACH(3) / Z'34800000' /
C     DATA RMACH(4) / Z'35000000' /
C     DATA RMACH(5) / Z'3F9A209B' /
C
C     MACHINE CONSTANTS FOR THE CONVEX
C     USING THE -fi COMPILER OPTION
C
C     DATA RMACH(1) / Z'00800000' /
C     DATA RMACH(2) / Z'7F7FFFFF' /
C     DATA RMACH(3) / Z'33800000' /
C     DATA RMACH(4) / Z'34000000' /
C     DATA RMACH(5) / Z'3E9A209B' /
C
C     MACHINE CONSTANTS FOR THE CONVEX
C     USING THE -p8 OR -pd8 COMPILER OPTION
C
C     DATA RMACH(1) / Z'0010000000000000' /
C     DATA RMACH(2) / Z'7FFFFFFFFFFFFFFF' /
C     DATA RMACH(3) / Z'3CC0000000000000' /
C     DATA RMACH(4) / Z'3CD0000000000000' /
C     DATA RMACH(5) / Z'3FF34413509F79FF' /
C
C     MACHINE CONSTANTS FOR THE CRAY
C
C     DATA RMACH(1) / 200034000000000000000B /
C     DATA RMACH(2) / 577767777777777777776B /
C     DATA RMACH(3) / 377224000000000000000B /
C     DATA RMACH(4) / 377234000000000000000B /
C     DATA RMACH(5) / 377774642023241175720B /
C
C     MACHINE CONSTANTS FOR THE DATA GENERAL ECLIPSE S/200
C     NOTE - IT MAY BE APPROPRIATE TO INCLUDE THE FOLLOWING CARD -
C     STATIC RMACH(5)
C
C     DATA SMALL /    20K,       0 /
C     DATA LARGE / 77777K, 177777K /
C     DATA RIGHT / 35420K,       0 /
C     DATA DIVER / 36020K,       0 /
C     DATA LOG10 / 40423K,  42023K /
C
C     MACHINE CONSTANTS FOR THE DEC ALPHA
C     USING G_FLOAT
C
C     DATA RMACH(1) / '00000080'X /
C     DATA RMACH(2) / 'FFFF7FFF'X /
C     DATA RMACH(3) / '00003480'X /
C     DATA RMACH(4) / '00003500'X /
C     DATA RMACH(5) / '209B3F9A'X /
C
C     MACHINE CONSTANTS FOR THE DEC ALPHA
C     USING IEEE_FLOAT
C
C     DATA RMACH(1) / '00800000'X /
C     DATA RMACH(2) / '7F7FFFFF'X /
C     DATA RMACH(3) / '33800000'X /
C     DATA RMACH(4) / '34000000'X /
C     DATA RMACH(5) / '3E9A209B'X /
C
C     MACHINE CONSTANTS FOR THE DEC RISC
C
C     DATA RMACH(1) / Z'00800000' /
C     DATA RMACH(2) / Z'7F7FFFFF' /
C     DATA RMACH(3) / Z'33800000' /
C     DATA RMACH(4) / Z'34000000' /
C     DATA RMACH(5) / Z'3E9A209B' /
C
C     MACHINE CONSTANTS FOR THE DEC VAX
C     (EXPRESSED IN INTEGER AND HEXADECIMAL)
C     THE HEX FORMAT BELOW MAY NOT BE SUITABLE FOR UNIX SYSTEMS
C     THE INTEGER FORMAT SHOULD BE OK FOR UNIX SYSTEMS
C
C     DATA SMALL(1) /       128 /
C     DATA LARGE(1) /    -32769 /
C     DATA RIGHT(1) /     13440 /
C     DATA DIVER(1) /     13568 /
C     DATA LOG10(1) / 547045274 /
C
C     DATA SMALL(1) / Z00000080 /
C     DATA LARGE(1) / ZFFFF7FFF /
C     DATA RIGHT(1) / Z00003480 /
C     DATA DIVER(1) / Z00003500 /
C     DATA LOG10(1) / Z209B3F9A /
C
C     MACHINE CONSTANTS FOR THE ELXSI 6400
C     (ASSUMING REAL*4 IS THE DEFAULT REAL)
C
C     DATA SMALL(1) / '00800000'X /
C     DATA LARGE(1) / '7F7FFFFF'X /
C     DATA RIGHT(1) / '33800000'X /
C     DATA DIVER(1) / '34000000'X /
C     DATA LOG10(1) / '3E9A209B'X /
C
C     MACHINE CONSTANTS FOR THE HARRIS 220
C
C     DATA SMALL(1), SMALL(2) / '20000000, '00000201 /
C     DATA LARGE(1), LARGE(2) / '37777777, '00000177 /
C     DATA RIGHT(1), RIGHT(2) / '20000000, '00000352 /
C     DATA DIVER(1), DIVER(2) / '20000000, '00000353 /
C     DATA LOG10(1), LOG10(2) / '23210115, '00000377 /
C
C     MACHINE CONSTANTS FOR THE HONEYWELL 600/6000 SERIES
C
C     DATA RMACH(1) / O402400000000 /
C     DATA RMACH(2) / O376777777777 /
C     DATA RMACH(3) / O714400000000 /
C     DATA RMACH(4) / O716400000000 /
C     DATA RMACH(5) / O776464202324 /
C
C     MACHINE CONSTANTS FOR THE HP 730
C
      DATA RMACH(1) / Z'00800000' /
      DATA RMACH(2) / Z'7F7FFFFF' /
      DATA RMACH(3) / Z'33800000' /
      DATA RMACH(4) / Z'34000000' /
      DATA RMACH(5) / Z'3E9A209B' /
C
C     MACHINE CONSTANTS FOR THE HP 2100
C     3 WORD DOUBLE PRECISION WITH FTN4
C
C     DATA SMALL(1), SMALL(2) / 40000B,       1 /
C     DATA LARGE(1), LARGE(2) / 77777B, 177776B /
C     DATA RIGHT(1), RIGHT(2) / 40000B,    325B /
C     DATA DIVER(1), DIVER(2) / 40000B,    327B /
C     DATA LOG10(1), LOG10(2) / 46420B,  46777B /
C
C     MACHINE CONSTANTS FOR THE HP 2100
C     4 WORD DOUBLE PRECISION WITH FTN4
C
C     DATA SMALL(1), SMALL(2) / 40000B,       1 /
C     DATA LARGE(1), LARGE(2) / 77777B, 177776B /
C     DATA RIGHT(1), RIGHT(2) / 40000B,    325B /
C     DATA DIVER(1), DIVER(2) / 40000B,    327B /
C     DATA LOG10(1), LOG10(2) / 46420B,  46777B /
C
C     MACHINE CONSTANTS FOR THE HP 9000
C
C     DATA SMALL(1) / 00004000000B /
C     DATA LARGE(1) / 17677777777B /
C     DATA RIGHT(1) / 06340000000B /
C     DATA DIVER(1) / 06400000000B /
C     DATA LOG10(1) / 07646420233B /
C
C     MACHINE CONSTANTS FOR THE IBM 360/370 SERIES,
C     THE XEROX SIGMA 5/7/9, THE SEL SYSTEMS 85/86  AND
C     THE PERKIN ELMER (INTERDATA) 7/32.
C
C     DATA RMACH(1) / Z00100000 /
C     DATA RMACH(2) / Z7FFFFFFF /
C     DATA RMACH(3) / Z3B100000 /
C     DATA RMACH(4) / Z3C100000 /
C     DATA RMACH(5) / Z41134413 /
C
C     MACHINE CONSTANTS FOR THE IBM PC
C
C     DATA SMALL(1) / 1.18E-38      /
C     DATA LARGE(1) / 3.40E+38      /
C     DATA RIGHT(1) / 0.595E-07     /
C     DATA DIVER(1) / 1.19E-07      /
C     DATA LOG10(1) / 0.30102999566 /
C
C     MACHINE CONSTANTS FOR THE IBM RS 6000
C
C     DATA RMACH(1) / Z'00800000' /
C     DATA RMACH(2) / Z'7F7FFFFF' /
C     DATA RMACH(3) / Z'33800000' /
C     DATA RMACH(4) / Z'34000000' /
C     DATA RMACH(5) / Z'3E9A209B' /
C
C     MACHINE CONSTANTS FOR THE INTEL i860
C
C     DATA RMACH(1) / Z'00800000' /
C     DATA RMACH(2) / Z'7F7FFFFF' /
C     DATA RMACH(3) / Z'33800000' /
C     DATA RMACH(4) / Z'34000000' /
C     DATA RMACH(5) / Z'3E9A209B' /
C
C     MACHINE CONSTANTS FOR THE PDP-10 (KA OR KI PROCESSOR)
C
C     DATA RMACH(1) / "000400000000 /
C     DATA RMACH(2) / "377777777777 /
C     DATA RMACH(3) / "146400000000 /
C     DATA RMACH(4) / "147400000000 /
C     DATA RMACH(5) / "177464202324 /
C
C     MACHINE CONSTANTS FOR PDP-11 FORTRAN SUPPORTING
C     32-BIT INTEGERS (EXPRESSED IN INTEGER AND OCTAL).
C
C     DATA SMALL(1) /    8388608 /
C     DATA LARGE(1) / 2147483647 /
C     DATA RIGHT(1) /  880803840 /
C     DATA DIVER(1) /  889192448 /
C     DATA LOG10(1) / 1067065499 /
C
C     DATA RMACH(1) / O00040000000 /
C     DATA RMACH(2) / O17777777777 /
C     DATA RMACH(3) / O06440000000 /
C     DATA RMACH(4) / O06500000000 /
C     DATA RMACH(5) / O07746420233 /
C
C     MACHINE CONSTANTS FOR PDP-11 FORTRAN SUPPORTING
C     16-BIT INTEGERS  (EXPRESSED IN INTEGER AND OCTAL).
C
C     DATA SMALL(1), SMALL(2) /   128,     0 /
C     DATA LARGE(1), LARGE(2) / 32767,    -1 /
C     DATA RIGHT(1), RIGHT(2) / 13440,     0 /
C     DATA DIVER(1), DIVER(2) / 13568,     0 /
C     DATA LOG10(1), LOG10(2) / 16282,  8347 /
C
C     DATA SMALL(1), SMALL(2) / O000200, O000000 /
C     DATA LARGE(1), LARGE(2) / O077777, O177777 /
C     DATA RIGHT(1), RIGHT(2) / O032200, O000000 /
C     DATA DIVER(1), DIVER(2) / O032400, O000000 /
C     DATA LOG10(1), LOG10(2) / O037632, O020233 /
C
C     MACHINE CONSTANTS FOR THE SILICON GRAPHICS
C
C     DATA RMACH(1) / Z'00800000' /
C     DATA RMACH(2) / Z'7F7FFFFF' /
C     DATA RMACH(3) / Z'33800000' /
C     DATA RMACH(4) / Z'34000000' /
C     DATA RMACH(5) / Z'3E9A209B' /
C
C     MACHINE CONSTANTS FOR THE SUN
C
C     DATA RMACH(1) / Z'00800000' /
C     DATA RMACH(2) / Z'7F7FFFFF' /
C     DATA RMACH(3) / Z'33800000' /
C     DATA RMACH(4) / Z'34000000' /
C     DATA RMACH(5) / Z'3E9A209B' /
C
C     MACHINE CONSTANTS FOR THE SUN
C     USING THE -r8 COMPILER OPTION
C
C     DATA RMACH(1) / Z'0010000000000000' /
C     DATA RMACH(2) / Z'7FEFFFFFFFFFFFFF' /
C     DATA RMACH(3) / Z'3CA0000000000000' /
C     DATA RMACH(4) / Z'3CB0000000000000' /
C     DATA RMACH(5) / Z'3FD34413509F79FF' /
C
C     MACHINE CONSTANTS FOR THE UNIVAC 1100 SERIES
C
C     DATA RMACH(1) / O000400000000 /
C     DATA RMACH(2) / O377777777777 /
C     DATA RMACH(3) / O146400000000 /
C     DATA RMACH(4) / O147400000000 /
C     DATA RMACH(5) / O177464202324 /
C
C     MACHINE CONSTANTS FOR THE Z80 MICROPROCESSOR
C
C     DATA SMALL(1), SMALL(2) /     0,    256/
C     DATA LARGE(1), LARGE(2) /    -1,   -129/
C     DATA RIGHT(1), RIGHT(2) /     0,  26880/
C     DATA DIVER(1), DIVER(2) /     0,  27136/
C     DATA LOG10(1), LOG10(2) /  8347,  32538/
C
C***FIRST EXECUTABLE STATEMENT  R1MACH
      IF (I .LT. 1 .OR. I .GT. 5) CALL XERMSG ('SLATEC', 'R1MACH',
     +   'I OUT OF BOUNDS', 1, 2)
C
      R1MACH = RMACH(I)
      RETURN
C
      END


C---------------------------------------------------------------
C xercnt.f
C---------------------------------------------------------------

*DECK XERCNT
      SUBROUTINE XERCNT (LIBRAR, SUBROU, MESSG, NERR, LEVEL, KONTRL)
C***BEGIN PROLOGUE  XERCNT
C***SUBSIDIARY
C***PURPOSE  Allow user control over handling of errors.
C***LIBRARY   SLATEC (XERROR)
C***CATEGORY  R3C
C***TYPE      ALL (XERCNT-A)
C***KEYWORDS  ERROR, XERROR
C***AUTHOR  Jones, R. E., (SNLA)
C***DESCRIPTION
C
C     Abstract
C        Allows user control over handling of individual errors.
C        Just after each message is recorded, but before it is
C        processed any further (i.e., before it is printed or
C        a decision to abort is made), a call is made to XERCNT.
C        If the user has provided his own version of XERCNT, he
C        can then override the value of KONTROL used in processing
C        this message by redefining its value.
C        KONTRL may be set to any value from -2 to 2.
C        The meanings for KONTRL are the same as in XSETF, except
C        that the value of KONTRL changes only for this message.
C        If KONTRL is set to a value outside the range from -2 to 2,
C        it will be moved back into that range.
C
C     Description of Parameters
C
C      --Input--
C        LIBRAR - the library that the routine is in.
C        SUBROU - the subroutine that XERMSG is being called from
C        MESSG  - the first 20 characters of the error message.
C        NERR   - same as in the call to XERMSG.
C        LEVEL  - same as in the call to XERMSG.
C        KONTRL - the current value of the control flag as set
C                 by a call to XSETF.
C
C      --Output--
C        KONTRL - the new value of KONTRL.  If KONTRL is not
C                 defined, it will remain at its original value.
C                 This changed value of control affects only
C                 the current occurrence of the current message.
C
C***REFERENCES  R. E. Jones and D. K. Kahaner, XERROR, the SLATEC
C                 Error-handling Package, SAND82-0800, Sandia
C                 Laboratories, 1982.
C***ROUTINES CALLED  (NONE)
C***REVISION HISTORY  (YYMMDD)
C   790801  DATE WRITTEN
C   861211  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   900206  Routine changed from user-callable to subsidiary.  (WRB)
C   900510  Changed calling sequence to include LIBRARY and SUBROUTINE
C           names, changed routine name from XERCTL to XERCNT.  (RWC)
C   920501  Reformatted the REFERENCES section.  (WRB)
C***END PROLOGUE  XERCNT
      CHARACTER*(*) LIBRAR, SUBROU, MESSG
C***FIRST EXECUTABLE STATEMENT  XERCNT
      RETURN
      END

C---------------------------------------------------------------
C xerhlt.f
C---------------------------------------------------------------

*DECK XERHLT
      SUBROUTINE XERHLT (MESSG)
C***BEGIN PROLOGUE  XERHLT
C***SUBSIDIARY
C***PURPOSE  Abort program execution and print error message.
C***LIBRARY   SLATEC (XERROR)
C***CATEGORY  R3C
C***TYPE      ALL (XERHLT-A)
C***KEYWORDS  ABORT PROGRAM EXECUTION, ERROR, XERROR
C***AUTHOR  Jones, R. E., (SNLA)
C***DESCRIPTION
C
C     Abstract
C        ***Note*** machine dependent routine
C        XERHLT aborts the execution of the program.
C        The error message causing the abort is given in the calling
C        sequence, in case one needs it for printing on a dayfile,
C        for example.
C
C     Description of Parameters
C        MESSG is as in XERMSG.
C
C***REFERENCES  R. E. Jones and D. K. Kahaner, XERROR, the SLATEC
C                 Error-handling Package, SAND82-0800, Sandia
C                 Laboratories, 1982.
C***ROUTINES CALLED  (NONE)
C***REVISION HISTORY  (YYMMDD)
C   790801  DATE WRITTEN
C   861211  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   900206  Routine changed from user-callable to subsidiary.  (WRB)
C   900510  Changed calling sequence to delete length of character
C           and changed routine name from XERABT to XERHLT.  (RWC)
C   920501  Reformatted the REFERENCES section.  (WRB)
C***END PROLOGUE  XERHLT
      CHARACTER*(*) MESSG
C***FIRST EXECUTABLE STATEMENT  XERHLT
      STOP
      END

C---------------------------------------------------------------
C xermsg.f
C---------------------------------------------------------------

*DECK XERMSG
      SUBROUTINE XERMSG (LIBRAR, SUBROU, MESSG, NERR, LEVEL)
C***BEGIN PROLOGUE  XERMSG
C***PURPOSE  Process error messages for SLATEC and other libraries.
C***LIBRARY   SLATEC (XERROR)
C***CATEGORY  R3C
C***TYPE      ALL (XERMSG-A)
C***KEYWORDS  ERROR MESSAGE, XERROR
C***AUTHOR  Fong, Kirby, (NMFECC at LLNL)
C***DESCRIPTION
C
C   XERMSG processes a diagnostic message in a manner determined by the
C   value of LEVEL and the current value of the library error control
C   flag, KONTRL.  See subroutine XSETF for details.
C
C    LIBRAR   A character constant (or character variable) with the name
C             of the library.  This will be 'SLATEC' for the SLATEC
C             Common Math Library.  The error handling package is
C             general enough to be used by many libraries
C             simultaneously, so it is desirable for the routine that
C             detects and reports an error to identify the library name
C             as well as the routine name.
C
C    SUBROU   A character constant (or character variable) with the name
C             of the routine that detected the error.  Usually it is the
C             name of the routine that is calling XERMSG.  There are
C             some instances where a user callable library routine calls
C             lower level subsidiary routines where the error is
C             detected.  In such cases it may be more informative to
C             supply the name of the routine the user called rather than
C             the name of the subsidiary routine that detected the
C             error.
C
C    MESSG    A character constant (or character variable) with the text
C             of the error or warning message.  In the example below,
C             the message is a character constant that contains a
C             generic message.
C
C                   CALL XERMSG ('SLATEC', 'MMPY',
C                  *'THE ORDER OF THE MATRIX EXCEEDS THE ROW DIMENSION',
C                  *3, 1)
C
C             It is possible (and is sometimes desirable) to generate a
C             specific message--e.g., one that contains actual numeric
C             values.  Specific numeric values can be converted into
C             character strings using formatted WRITE statements into
C             character variables.  This is called standard Fortran
C             internal file I/O and is exemplified in the first three
C             lines of the following example.  You can also catenate
C             substrings of characters to construct the error message.
C             Here is an example showing the use of both writing to
C             an internal file and catenating character strings.
C
C                   CHARACTER*5 CHARN, CHARL
C                   WRITE (CHARN,10) N
C                   WRITE (CHARL,10) LDA
C                10 FORMAT(I5)
C                   CALL XERMSG ('SLATEC', 'MMPY', 'THE ORDER'//CHARN//
C                  *   ' OF THE MATRIX EXCEEDS ITS ROW DIMENSION OF'//
C                  *   CHARL, 3, 1)
C
C             There are two subtleties worth mentioning.  One is that
C             the // for character catenation is used to construct the
C             error message so that no single character constant is
C             continued to the next line.  This avoids confusion as to
C             whether there are trailing blanks at the end of the line.
C             The second is that by catenating the parts of the message
C             as an actual argument rather than encoding the entire
C             message into one large character variable, we avoid
C             having to know how long the message will be in order to
C             declare an adequate length for that large character
C             variable.  XERMSG calls XERPRN to print the message using
C             multiple lines if necessary.  If the message is very long,
C             XERPRN will break it into pieces of 72 characters (as
C             requested by XERMSG) for printing on multiple lines.
C             Also, XERMSG asks XERPRN to prefix each line with ' *  '
C             so that the total line length could be 76 characters.
C             Note also that XERPRN scans the error message backwards
C             to ignore trailing blanks.  Another feature is that
C             the substring '$$' is treated as a new line sentinel
C             by XERPRN.  If you want to construct a multiline
C             message without having to count out multiples of 72
C             characters, just use '$$' as a separator.  '$$'
C             obviously must occur within 72 characters of the
C             start of each line to have its intended effect since
C             XERPRN is asked to wrap around at 72 characters in
C             addition to looking for '$$'.
C
C    NERR     An integer value that is chosen by the library routine's
C             author.  It must be in the range -99 to 999 (three
C             printable digits).  Each distinct error should have its
C             own error number.  These error numbers should be described
C             in the machine readable documentation for the routine.
C             The error numbers need be unique only within each routine,
C             so it is reasonable for each routine to start enumerating
C             errors from 1 and proceeding to the next integer.
C
C    LEVEL    An integer value in the range 0 to 2 that indicates the
C             level (severity) of the error.  Their meanings are
C
C            -1  A warning message.  This is used if it is not clear
C                that there really is an error, but the user's attention
C                may be needed.  An attempt is made to only print this
C                message once.
C
C             0  A warning message.  This is used if it is not clear
C                that there really is an error, but the user's attention
C                may be needed.
C
C             1  A recoverable error.  This is used even if the error is
C                so serious that the routine cannot return any useful
C                answer.  If the user has told the error package to
C                return after recoverable errors, then XERMSG will
C                return to the Library routine which can then return to
C                the user's routine.  The user may also permit the error
C                package to terminate the program upon encountering a
C                recoverable error.
C
C             2  A fatal error.  XERMSG will not return to its caller
C                after it receives a fatal error.  This level should
C                hardly ever be used; it is much better to allow the
C                user a chance to recover.  An example of one of the few
C                cases in which it is permissible to declare a level 2
C                error is a reverse communication Library routine that
C                is likely to be called repeatedly until it integrates
C                across some interval.  If there is a serious error in
C                the input such that another step cannot be taken and
C                the Library routine is called again without the input
C                error having been corrected by the caller, the Library
C                routine will probably be called forever with improper
C                input.  In this case, it is reasonable to declare the
C                error to be fatal.
C
C    Each of the arguments to XERMSG is input; none will be modified by
C    XERMSG.  A routine may make multiple calls to XERMSG with warning
C    level messages; however, after a call to XERMSG with a recoverable
C    error, the routine should return to the user.  Do not try to call
C    XERMSG with a second recoverable error after the first recoverable
C    error because the error package saves the error number.  The user
C    can retrieve this error number by calling another entry point in
C    the error handling package and then clear the error number when
C    recovering from the error.  Calling XERMSG in succession causes the
C    old error number to be overwritten by the latest error number.
C    This is considered harmless for error numbers associated with
C    warning messages but must not be done for error numbers of serious
C    errors.  After a call to XERMSG with a recoverable error, the user
C    must be given a chance to call NUMXER or XERCLR to retrieve or
C    clear the error number.
C***REFERENCES  R. E. Jones and D. K. Kahaner, XERROR, the SLATEC
C                 Error-handling Package, SAND82-0800, Sandia
C                 Laboratories, 1982.
C***ROUTINES CALLED  FDUMP, J4SAVE, XERCNT, XERHLT, XERPRN, XERSVE
C***REVISION HISTORY  (YYMMDD)
C   880101  DATE WRITTEN
C   880621  REVISED AS DIRECTED AT SLATEC CML MEETING OF FEBRUARY 1988.
C           THERE ARE TWO BASIC CHANGES.
C           1.  A NEW ROUTINE, XERPRN, IS USED INSTEAD OF XERPRT TO
C               PRINT MESSAGES.  THIS ROUTINE WILL BREAK LONG MESSAGES
C               INTO PIECES FOR PRINTING ON MULTIPLE LINES.  '$$' IS
C               ACCEPTED AS A NEW LINE SENTINEL.  A PREFIX CAN BE
C               ADDED TO EACH LINE TO BE PRINTED.  XERMSG USES EITHER
C               ' ***' OR ' *  ' AND LONG MESSAGES ARE BROKEN EVERY
C               72 CHARACTERS (AT MOST) SO THAT THE MAXIMUM LINE
C               LENGTH OUTPUT CAN NOW BE AS GREAT AS 76.
C           2.  THE TEXT OF ALL MESSAGES IS NOW IN UPPER CASE SINCE THE
C               FORTRAN STANDARD DOCUMENT DOES NOT ADMIT THE EXISTENCE
C               OF LOWER CASE.
C   880708  REVISED AFTER THE SLATEC CML MEETING OF JUNE 29 AND 30.
C           THE PRINCIPAL CHANGES ARE
C           1.  CLARIFY COMMENTS IN THE PROLOGUES
C           2.  RENAME XRPRNT TO XERPRN
C           3.  REWORK HANDLING OF '$$' IN XERPRN TO HANDLE BLANK LINES
C               SIMILAR TO THE WAY FORMAT STATEMENTS HANDLE THE /
C               CHARACTER FOR NEW RECORDS.
C   890706  REVISED WITH THE HELP OF FRED FRITSCH AND REG CLEMENS TO
C           CLEAN UP THE CODING.
C   890721  REVISED TO USE NEW FEATURE IN XERPRN TO COUNT CHARACTERS IN
C           PREFIX.
C   891013  REVISED TO CORRECT COMMENTS.
C   891214  Prologue converted to Version 4.0 format.  (WRB)
C   900510  Changed test on NERR to be -9999999 < NERR < 99999999, but
C           NERR .ne. 0, and on LEVEL to be -2 < LEVEL < 3.  Added
C           LEVEL=-1 logic, changed calls to XERSAV to XERSVE, and
C           XERCTL to XERCNT.  (RWC)
C   920501  Reformatted the REFERENCES section.  (WRB)
C***END PROLOGUE  XERMSG
      CHARACTER*(*) LIBRAR, SUBROU, MESSG
      CHARACTER*8 XLIBR, XSUBR
      CHARACTER*72  TEMP
      CHARACTER*20  LFIRST
C***FIRST EXECUTABLE STATEMENT  XERMSG
      LKNTRL = J4SAVE (2, 0, .FALSE.)
      MAXMES = J4SAVE (4, 0, .FALSE.)
C
C       LKNTRL IS A LOCAL COPY OF THE CONTROL FLAG KONTRL.
C       MAXMES IS THE MAXIMUM NUMBER OF TIMES ANY PARTICULAR MESSAGE
C          SHOULD BE PRINTED.
C
C       WE PRINT A FATAL ERROR MESSAGE AND TERMINATE FOR AN ERROR IN
C          CALLING XERMSG.  THE ERROR NUMBER SHOULD BE POSITIVE,
C          AND THE LEVEL SHOULD BE BETWEEN 0 AND 2.
C
      IF (NERR.LT.-9999999 .OR. NERR.GT.99999999 .OR. NERR.EQ.0 .OR.
     *   LEVEL.LT.-1 .OR. LEVEL.GT.2) THEN
         CALL XERPRN (' ***', -1, 'FATAL ERROR IN...$$ ' //
     *      'XERMSG -- INVALID ERROR NUMBER OR LEVEL$$ '//
     *      'JOB ABORT DUE TO FATAL ERROR.', 72)
         CALL XERSVE (' ', ' ', ' ', 0, 0, 0, KDUMMY)
         CALL XERHLT (' ***XERMSG -- INVALID INPUT')
         RETURN
      ENDIF
C
C       RECORD THE MESSAGE.
C
      I = J4SAVE (1, NERR, .TRUE.)
      CALL XERSVE (LIBRAR, SUBROU, MESSG, 1, NERR, LEVEL, KOUNT)
C
C       HANDLE PRINT-ONCE WARNING MESSAGES.
C
      IF (LEVEL.EQ.-1 .AND. KOUNT.GT.1) RETURN
C
C       ALLOW TEMPORARY USER OVERRIDE OF THE CONTROL FLAG.
C
      XLIBR  = LIBRAR
      XSUBR  = SUBROU
      LFIRST = MESSG
      LERR   = NERR
      LLEVEL = LEVEL
      CALL XERCNT (XLIBR, XSUBR, LFIRST, LERR, LLEVEL, LKNTRL)
C
      LKNTRL = MAX(-2, MIN(2,LKNTRL))
      MKNTRL = ABS(LKNTRL)
C
C       SKIP PRINTING IF THE CONTROL FLAG VALUE AS RESET IN XERCNT IS
C       ZERO AND THE ERROR IS NOT FATAL.
C
      IF (LEVEL.LT.2 .AND. LKNTRL.EQ.0) GO TO 30
      IF (LEVEL.EQ.0 .AND. KOUNT.GT.MAXMES) GO TO 30
      IF (LEVEL.EQ.1 .AND. KOUNT.GT.MAXMES .AND. MKNTRL.EQ.1) GO TO 30
      IF (LEVEL.EQ.2 .AND. KOUNT.GT.MAX(1,MAXMES)) GO TO 30
C
C       ANNOUNCE THE NAMES OF THE LIBRARY AND SUBROUTINE BY BUILDING A
C       MESSAGE IN CHARACTER VARIABLE TEMP (NOT EXCEEDING 66 CHARACTERS)
C       AND SENDING IT OUT VIA XERPRN.  PRINT ONLY IF CONTROL FLAG
C       IS NOT ZERO.
C
      IF (LKNTRL .NE. 0) THEN
         TEMP(1:21) = 'MESSAGE FROM ROUTINE '
         I = MIN(LEN(SUBROU), 16)
         TEMP(22:21+I) = SUBROU(1:I)
         TEMP(22+I:33+I) = ' IN LIBRARY '
         LTEMP = 33 + I
         I = MIN(LEN(LIBRAR), 16)
         TEMP(LTEMP+1:LTEMP+I) = LIBRAR (1:I)
         TEMP(LTEMP+I+1:LTEMP+I+1) = '.'
         LTEMP = LTEMP + I + 1
         CALL XERPRN (' ***', -1, TEMP(1:LTEMP), 72)
      ENDIF
C
C       IF LKNTRL IS POSITIVE, PRINT AN INTRODUCTORY LINE BEFORE
C       PRINTING THE MESSAGE.  THE INTRODUCTORY LINE TELLS THE CHOICE
C       FROM EACH OF THE FOLLOWING THREE OPTIONS.
C       1.  LEVEL OF THE MESSAGE
C              'INFORMATIVE MESSAGE'
C              'POTENTIALLY RECOVERABLE ERROR'
C              'FATAL ERROR'
C       2.  WHETHER CONTROL FLAG WILL ALLOW PROGRAM TO CONTINUE
C              'PROG CONTINUES'
C              'PROG ABORTED'
C       3.  WHETHER OR NOT A TRACEBACK WAS REQUESTED.  (THE TRACEBACK
C           MAY NOT BE IMPLEMENTED AT SOME SITES, SO THIS ONLY TELLS
C           WHAT WAS REQUESTED, NOT WHAT WAS DELIVERED.)
C              'TRACEBACK REQUESTED'
C              'TRACEBACK NOT REQUESTED'
C       NOTICE THAT THE LINE INCLUDING FOUR PREFIX CHARACTERS WILL NOT
C       EXCEED 74 CHARACTERS.
C       WE SKIP THE NEXT BLOCK IF THE INTRODUCTORY LINE IS NOT NEEDED.
C
      IF (LKNTRL .GT. 0) THEN
C
C       THE FIRST PART OF THE MESSAGE TELLS ABOUT THE LEVEL.
C
         IF (LEVEL .LE. 0) THEN
            TEMP(1:20) = 'INFORMATIVE MESSAGE,'
            LTEMP = 20
         ELSEIF (LEVEL .EQ. 1) THEN
            TEMP(1:30) = 'POTENTIALLY RECOVERABLE ERROR,'
            LTEMP = 30
         ELSE
            TEMP(1:12) = 'FATAL ERROR,'
            LTEMP = 12
         ENDIF
C
C       THEN WHETHER THE PROGRAM WILL CONTINUE.
C
         IF ((MKNTRL.EQ.2 .AND. LEVEL.GE.1) .OR.
     *       (MKNTRL.EQ.1 .AND. LEVEL.EQ.2)) THEN
            TEMP(LTEMP+1:LTEMP+14) = ' PROG ABORTED,'
            LTEMP = LTEMP + 14
         ELSE
            TEMP(LTEMP+1:LTEMP+16) = ' PROG CONTINUES,'
            LTEMP = LTEMP + 16
         ENDIF
C
C       FINALLY TELL WHETHER THERE SHOULD BE A TRACEBACK.
C
         IF (LKNTRL .GT. 0) THEN
            TEMP(LTEMP+1:LTEMP+20) = ' TRACEBACK REQUESTED'
            LTEMP = LTEMP + 20
         ELSE
            TEMP(LTEMP+1:LTEMP+24) = ' TRACEBACK NOT REQUESTED'
            LTEMP = LTEMP + 24
         ENDIF
         CALL XERPRN (' ***', -1, TEMP(1:LTEMP), 72)
      ENDIF
C
C       NOW SEND OUT THE MESSAGE.
C
      CALL XERPRN (' *  ', -1, MESSG, 72)
C
C       IF LKNTRL IS POSITIVE, WRITE THE ERROR NUMBER AND REQUEST A
C          TRACEBACK.
C
      IF (LKNTRL .GT. 0) THEN
         WRITE (TEMP, '(''ERROR NUMBER = '', I8)') NERR
         DO 10 I=16,22
            IF (TEMP(I:I) .NE. ' ') GO TO 20
   10    CONTINUE
C
   20    CALL XERPRN (' *  ', -1, TEMP(1:15) // TEMP(I:23), 72)
         CALL FDUMP
      ENDIF
C
C       IF LKNTRL IS NOT ZERO, PRINT A BLANK LINE AND AN END OF MESSAGE.
C
      IF (LKNTRL .NE. 0) THEN
         CALL XERPRN (' *  ', -1, ' ', 72)
         CALL XERPRN (' ***', -1, 'END OF MESSAGE', 72)
         CALL XERPRN ('    ',  0, ' ', 72)
      ENDIF
C
C       IF THE ERROR IS NOT FATAL OR THE ERROR IS RECOVERABLE AND THE
C       CONTROL FLAG IS SET FOR RECOVERY, THEN RETURN.
C
   30 IF (LEVEL.LE.0 .OR. (LEVEL.EQ.1 .AND. MKNTRL.LE.1)) RETURN
C
C       THE PROGRAM WILL BE STOPPED DUE TO AN UNRECOVERED ERROR OR A
C       FATAL ERROR.  PRINT THE REASON FOR THE ABORT AND THE ERROR
C       SUMMARY IF THE CONTROL FLAG AND THE MAXIMUM ERROR COUNT PERMIT.
C
      IF (LKNTRL.GT.0 .AND. KOUNT.LT.MAX(1,MAXMES)) THEN
         IF (LEVEL .EQ. 1) THEN
            CALL XERPRN
     *         (' ***', -1, 'JOB ABORT DUE TO UNRECOVERED ERROR.', 72)
         ELSE
            CALL XERPRN(' ***', -1, 'JOB ABORT DUE TO FATAL ERROR.', 72)
         ENDIF
         CALL XERSVE (' ', ' ', ' ', -1, 0, 0, KDUMMY)
         CALL XERHLT (' ')
      ELSE
         CALL XERHLT (MESSG)
      ENDIF
      RETURN
      END

C---------------------------------------------------------------
C xerprn.f
C---------------------------------------------------------------

*DECK XERPRN
      SUBROUTINE XERPRN (PREFIX, NPREF, MESSG, NWRAP)
C***BEGIN PROLOGUE  XERPRN
C***SUBSIDIARY
C***PURPOSE  Print error messages processed by XERMSG.
C***LIBRARY   SLATEC (XERROR)
C***CATEGORY  R3C
C***TYPE      ALL (XERPRN-A)
C***KEYWORDS  ERROR MESSAGES, PRINTING, XERROR
C***AUTHOR  Fong, Kirby, (NMFECC at LLNL)
C***DESCRIPTION
C
C This routine sends one or more lines to each of the (up to five)
C logical units to which error messages are to be sent.  This routine
C is called several times by XERMSG, sometimes with a single line to
C print and sometimes with a (potentially very long) message that may
C wrap around into multiple lines.
C
C PREFIX  Input argument of type CHARACTER.  This argument contains
C         characters to be put at the beginning of each line before
C         the body of the message.  No more than 16 characters of
C         PREFIX will be used.
C
C NPREF   Input argument of type INTEGER.  This argument is the number
C         of characters to use from PREFIX.  If it is negative, the
C         intrinsic function LEN is used to determine its length.  If
C         it is zero, PREFIX is not used.  If it exceeds 16 or if
C         LEN(PREFIX) exceeds 16, only the first 16 characters will be
C         used.  If NPREF is positive and the length of PREFIX is less
C         than NPREF, a copy of PREFIX extended with blanks to length
C         NPREF will be used.
C
C MESSG   Input argument of type CHARACTER.  This is the text of a
C         message to be printed.  If it is a long message, it will be
C         broken into pieces for printing on multiple lines.  Each line
C         will start with the appropriate prefix and be followed by a
C         piece of the message.  NWRAP is the number of characters per
C         piece; that is, after each NWRAP characters, we break and
C         start a new line.  In addition the characters '$$' embedded
C         in MESSG are a sentinel for a new line.  The counting of
C         characters up to NWRAP starts over for each new line.  The
C         value of NWRAP typically used by XERMSG is 72 since many
C         older error messages in the SLATEC Library are laid out to
C         rely on wrap-around every 72 characters.
C
C NWRAP   Input argument of type INTEGER.  This gives the maximum size
C         piece into which to break MESSG for printing on multiple
C         lines.  An embedded '$$' ends a line, and the count restarts
C         at the following character.  If a line break does not occur
C         on a blank (it would split a word) that word is moved to the
C         next line.  Values of NWRAP less than 16 will be treated as
C         16.  Values of NWRAP greater than 132 will be treated as 132.
C         The actual line length will be NPREF + NWRAP after NPREF has
C         been adjusted to fall between 0 and 16 and NWRAP has been
C         adjusted to fall between 16 and 132.
C
C***REFERENCES  R. E. Jones and D. K. Kahaner, XERROR, the SLATEC
C                 Error-handling Package, SAND82-0800, Sandia
C                 Laboratories, 1982.
C***ROUTINES CALLED  I1MACH, XGETUA
C***REVISION HISTORY  (YYMMDD)
C   880621  DATE WRITTEN
C   880708  REVISED AFTER THE SLATEC CML SUBCOMMITTEE MEETING OF
C           JUNE 29 AND 30 TO CHANGE THE NAME TO XERPRN AND TO REWORK
C           THE HANDLING OF THE NEW LINE SENTINEL TO BEHAVE LIKE THE
C           SLASH CHARACTER IN FORMAT STATEMENTS.
C   890706  REVISED WITH THE HELP OF FRED FRITSCH AND REG CLEMENS TO
C           STREAMLINE THE CODING AND FIX A BUG THAT CAUSED EXTRA BLANK
C           LINES TO BE PRINTED.
C   890721  REVISED TO ADD A NEW FEATURE.  A NEGATIVE VALUE OF NPREF
C           CAUSES LEN(PREFIX) TO BE USED AS THE LENGTH.
C   891013  REVISED TO CORRECT ERROR IN CALCULATING PREFIX LENGTH.
C   891214  Prologue converted to Version 4.0 format.  (WRB)
C   900510  Added code to break messages between words.  (RWC)
C   920501  Reformatted the REFERENCES section.  (WRB)
C***END PROLOGUE  XERPRN
      CHARACTER*(*) PREFIX, MESSG
      INTEGER NPREF, NWRAP
      CHARACTER*148 CBUFF
      INTEGER IU(5), NUNIT
      CHARACTER*2 NEWLIN
      PARAMETER (NEWLIN = '$$')
C***FIRST EXECUTABLE STATEMENT  XERPRN
      CALL XGETUA(IU,NUNIT)
C
C       A ZERO VALUE FOR A LOGICAL UNIT NUMBER MEANS TO USE THE STANDARD
C       ERROR MESSAGE UNIT INSTEAD.  I1MACH(4) RETRIEVES THE STANDARD
C       ERROR MESSAGE UNIT.
C
      N = I1MACH(4)
      DO 10 I=1,NUNIT
         IF (IU(I) .EQ. 0) IU(I) = N
   10 CONTINUE
C
C       LPREF IS THE LENGTH OF THE PREFIX.  THE PREFIX IS PLACED AT THE
C       BEGINNING OF CBUFF, THE CHARACTER BUFFER, AND KEPT THERE DURING
C       THE REST OF THIS ROUTINE.
C
      IF ( NPREF .LT. 0 ) THEN
         LPREF = LEN(PREFIX)
      ELSE
         LPREF = NPREF
      ENDIF
      LPREF = MIN(16, LPREF)
      IF (LPREF .NE. 0) CBUFF(1:LPREF) = PREFIX
C
C       LWRAP IS THE MAXIMUM NUMBER OF CHARACTERS WE WANT TO TAKE AT ONE
C       TIME FROM MESSG TO PRINT ON ONE LINE.
C
      LWRAP = MAX(16, MIN(132, NWRAP))
C
C       SET LENMSG TO THE LENGTH OF MESSG, IGNORE ANY TRAILING BLANKS.
C
      LENMSG = LEN(MESSG)
      N = LENMSG
      DO 20 I=1,N
         IF (MESSG(LENMSG:LENMSG) .NE. ' ') GO TO 30
         LENMSG = LENMSG - 1
   20 CONTINUE
   30 CONTINUE
C
C       IF THE MESSAGE IS ALL BLANKS, THEN PRINT ONE BLANK LINE.
C
      IF (LENMSG .EQ. 0) THEN
         CBUFF(LPREF+1:LPREF+1) = ' '
         DO 40 I=1,NUNIT
            WRITE(IU(I), '(A)') CBUFF(1:LPREF+1)
   40    CONTINUE
         RETURN
      ENDIF
C
C       SET NEXTC TO THE POSITION IN MESSG WHERE THE NEXT SUBSTRING
C       STARTS.  FROM THIS POSITION WE SCAN FOR THE NEW LINE SENTINEL.
C       WHEN NEXTC EXCEEDS LENMSG, THERE IS NO MORE TO PRINT.
C       WE LOOP BACK TO LABEL 50 UNTIL ALL PIECES HAVE BEEN PRINTED.
C
C       WE LOOK FOR THE NEXT OCCURRENCE OF THE NEW LINE SENTINEL.  THE
C       INDEX INTRINSIC FUNCTION RETURNS ZERO IF THERE IS NO OCCURRENCE
C       OR IF THE LENGTH OF THE FIRST ARGUMENT IS LESS THAN THE LENGTH
C       OF THE SECOND ARGUMENT.
C
C       THERE ARE SEVERAL CASES WHICH SHOULD BE CHECKED FOR IN THE
C       FOLLOWING ORDER.  WE ARE ATTEMPTING TO SET LPIECE TO THE NUMBER
C       OF CHARACTERS THAT SHOULD BE TAKEN FROM MESSG STARTING AT
C       POSITION NEXTC.
C
C       LPIECE .EQ. 0   THE NEW LINE SENTINEL DOES NOT OCCUR IN THE
C                       REMAINDER OF THE CHARACTER STRING.  LPIECE
C                       SHOULD BE SET TO LWRAP OR LENMSG+1-NEXTC,
C                       WHICHEVER IS LESS.
C
C       LPIECE .EQ. 1   THE NEW LINE SENTINEL STARTS AT MESSG(NEXTC:
C                       NEXTC).  LPIECE IS EFFECTIVELY ZERO, AND WE
C                       PRINT NOTHING TO AVOID PRODUCING UNNECESSARY
C                       BLANK LINES.  THIS TAKES CARE OF THE SITUATION
C                       WHERE THE LIBRARY ROUTINE HAS A MESSAGE OF
C                       EXACTLY 72 CHARACTERS FOLLOWED BY A NEW LINE
C                       SENTINEL FOLLOWED BY MORE CHARACTERS.  NEXTC
C                       SHOULD BE INCREMENTED BY 2.
C
C       LPIECE .GT. LWRAP+1  REDUCE LPIECE TO LWRAP.
C
C       ELSE            THIS LAST CASE MEANS 2 .LE. LPIECE .LE. LWRAP+1
C                       RESET LPIECE = LPIECE-1.  NOTE THAT THIS
C                       PROPERLY HANDLES THE END CASE WHERE LPIECE .EQ.
C                       LWRAP+1.  THAT IS, THE SENTINEL FALLS EXACTLY
C                       AT THE END OF A LINE.
C
      NEXTC = 1
   50 LPIECE = INDEX(MESSG(NEXTC:LENMSG), NEWLIN)
      IF (LPIECE .EQ. 0) THEN
C
C       THERE WAS NO NEW LINE SENTINEL FOUND.
C
         IDELTA = 0
         LPIECE = MIN(LWRAP, LENMSG+1-NEXTC)
         IF (LPIECE .LT. LENMSG+1-NEXTC) THEN
            DO 52 I=LPIECE+1,2,-1
               IF (MESSG(NEXTC+I-1:NEXTC+I-1) .EQ. ' ') THEN
                  LPIECE = I-1
                  IDELTA = 1
                  GOTO 54
               ENDIF
   52       CONTINUE
         ENDIF
   54    CBUFF(LPREF+1:LPREF+LPIECE) = MESSG(NEXTC:NEXTC+LPIECE-1)
         NEXTC = NEXTC + LPIECE + IDELTA
      ELSEIF (LPIECE .EQ. 1) THEN
C
C       WE HAVE A NEW LINE SENTINEL AT MESSG(NEXTC:NEXTC+1).
C       DON'T PRINT A BLANK LINE.
C
         NEXTC = NEXTC + 2
         GO TO 50
      ELSEIF (LPIECE .GT. LWRAP+1) THEN
C
C       LPIECE SHOULD BE SET DOWN TO LWRAP.
C
         IDELTA = 0
         LPIECE = LWRAP
         DO 56 I=LPIECE+1,2,-1
            IF (MESSG(NEXTC+I-1:NEXTC+I-1) .EQ. ' ') THEN
               LPIECE = I-1
               IDELTA = 1
               GOTO 58
            ENDIF
   56    CONTINUE
   58    CBUFF(LPREF+1:LPREF+LPIECE) = MESSG(NEXTC:NEXTC+LPIECE-1)
         NEXTC = NEXTC + LPIECE + IDELTA
      ELSE
C
C       IF WE ARRIVE HERE, IT MEANS 2 .LE. LPIECE .LE. LWRAP+1.
C       WE SHOULD DECREMENT LPIECE BY ONE.
C
         LPIECE = LPIECE - 1
         CBUFF(LPREF+1:LPREF+LPIECE) = MESSG(NEXTC:NEXTC+LPIECE-1)
         NEXTC  = NEXTC + LPIECE + 2
      ENDIF
C
C       PRINT
C
      DO 60 I=1,NUNIT
         WRITE(IU(I), '(A)') CBUFF(1:LPREF+LPIECE)
   60 CONTINUE
C
      IF (NEXTC .LE. LENMSG) GO TO 50
      RETURN
      END

C---------------------------------------------------------------
C xersve.f
C---------------------------------------------------------------

*DECK XERSVE
      SUBROUTINE XERSVE (LIBRAR, SUBROU, MESSG, KFLAG, NERR, LEVEL,
     +   ICOUNT)
C***BEGIN PROLOGUE  XERSVE
C***SUBSIDIARY
C***PURPOSE  Record that an error has occurred.
C***LIBRARY   SLATEC (XERROR)
C***CATEGORY  R3
C***TYPE      ALL (XERSVE-A)
C***KEYWORDS  ERROR, XERROR
C***AUTHOR  Jones, R. E., (SNLA)
C***DESCRIPTION
C
C *Usage:
C
C        INTEGER  KFLAG, NERR, LEVEL, ICOUNT
C        CHARACTER * (len) LIBRAR, SUBROU, MESSG
C
C        CALL XERSVE (LIBRAR, SUBROU, MESSG, KFLAG, NERR, LEVEL, ICOUNT)
C
C *Arguments:
C
C        LIBRAR :IN    is the library that the message is from.
C        SUBROU :IN    is the subroutine that the message is from.
C        MESSG  :IN    is the message to be saved.
C        KFLAG  :IN    indicates the action to be performed.
C                      when KFLAG > 0, the message in MESSG is saved.
C                      when KFLAG=0 the tables will be dumped and
C                      cleared.
C                      when KFLAG < 0, the tables will be dumped and
C                      not cleared.
C        NERR   :IN    is the error number.
C        LEVEL  :IN    is the error severity.
C        ICOUNT :OUT   the number of times this message has been seen,
C                      or zero if the table has overflowed and does not
C                      contain this message specifically.  When KFLAG=0,
C                      ICOUNT will not be altered.
C
C *Description:
C
C   Record that this error occurred and possibly dump and clear the
C   tables.
C
C***REFERENCES  R. E. Jones and D. K. Kahaner, XERROR, the SLATEC
C                 Error-handling Package, SAND82-0800, Sandia
C                 Laboratories, 1982.
C***ROUTINES CALLED  I1MACH, XGETUA
C***REVISION HISTORY  (YYMMDD)
C   800319  DATE WRITTEN
C   861211  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   900413  Routine modified to remove reference to KFLAG.  (WRB)
C   900510  Changed to add LIBRARY NAME and SUBROUTINE to calling
C           sequence, use IF-THEN-ELSE, make number of saved entries
C           easily changeable, changed routine name from XERSAV to
C           XERSVE.  (RWC)
C   910626  Added LIBTAB and SUBTAB to SAVE statement.  (BKS)
C   920501  Reformatted the REFERENCES section.  (WRB)
C***END PROLOGUE  XERSVE
      PARAMETER (LENTAB=10)
      INTEGER LUN(5)
      CHARACTER*(*) LIBRAR, SUBROU, MESSG
      CHARACTER*8  LIBTAB(LENTAB), SUBTAB(LENTAB), LIB, SUB
      CHARACTER*20 MESTAB(LENTAB), MES
      DIMENSION NERTAB(LENTAB), LEVTAB(LENTAB), KOUNT(LENTAB)
      SAVE LIBTAB, SUBTAB, MESTAB, NERTAB, LEVTAB, KOUNT, KOUNTX, NMSG
      DATA KOUNTX/0/, NMSG/0/
C***FIRST EXECUTABLE STATEMENT  XERSVE
C
      IF (KFLAG.LE.0) THEN
C
C        Dump the table.
C
         IF (NMSG.EQ.0) RETURN
C
C        Print to each unit.
C
         CALL XGETUA (LUN, NUNIT)
         DO 20 KUNIT = 1,NUNIT
            IUNIT = LUN(KUNIT)
            IF (IUNIT.EQ.0) IUNIT = I1MACH(4)
C
C           Print the table header.
C
            WRITE (IUNIT,9000)
C
C           Print body of table.
C
            DO 10 I = 1,NMSG
               WRITE (IUNIT,9010) LIBTAB(I), SUBTAB(I), MESTAB(I),
     *            NERTAB(I),LEVTAB(I),KOUNT(I)
   10       CONTINUE
C
C           Print number of other errors.
C
            IF (KOUNTX.NE.0) WRITE (IUNIT,9020) KOUNTX
            WRITE (IUNIT,9030)
   20    CONTINUE
C
C        Clear the error tables.
C
         IF (KFLAG.EQ.0) THEN
            NMSG = 0
            KOUNTX = 0
         ENDIF
      ELSE
C
C        PROCESS A MESSAGE...
C        SEARCH FOR THIS MESSG, OR ELSE AN EMPTY SLOT FOR THIS MESSG,
C        OR ELSE DETERMINE THAT THE ERROR TABLE IS FULL.
C
         LIB = LIBRAR
         SUB = SUBROU
         MES = MESSG
         DO 30 I = 1,NMSG
            IF (LIB.EQ.LIBTAB(I) .AND. SUB.EQ.SUBTAB(I) .AND.
     *         MES.EQ.MESTAB(I) .AND. NERR.EQ.NERTAB(I) .AND.
     *         LEVEL.EQ.LEVTAB(I)) THEN
                  KOUNT(I) = KOUNT(I) + 1
                  ICOUNT = KOUNT(I)
                  RETURN
            ENDIF
   30    CONTINUE
C
         IF (NMSG.LT.LENTAB) THEN
C
C           Empty slot found for new message.
C
            NMSG = NMSG + 1
            LIBTAB(I) = LIB
            SUBTAB(I) = SUB
            MESTAB(I) = MES
            NERTAB(I) = NERR
            LEVTAB(I) = LEVEL
            KOUNT (I) = 1
            ICOUNT    = 1
         ELSE
C
C           Table is full.
C
            KOUNTX = KOUNTX+1
            ICOUNT = 0
         ENDIF
      ENDIF
      RETURN
C
C     Formats.
C
 9000 FORMAT ('0          ERROR MESSAGE SUMMARY' /
     +   ' LIBRARY    SUBROUTINE MESSAGE START             NERR',
     +   '     LEVEL     COUNT')
 9010 FORMAT (1X,A,3X,A,3X,A,3I10)
 9020 FORMAT ('0OTHER ERRORS NOT INDIVIDUALLY TABULATED = ', I10)
 9030 FORMAT (1X)
      END

C---------------------------------------------------------------
C xgetua.f
C---------------------------------------------------------------

*DECK XGETUA
      SUBROUTINE XGETUA (IUNITA, N)
C***BEGIN PROLOGUE  XGETUA
C***PURPOSE  Return unit number(s) to which error messages are being
C            sent.
C***LIBRARY   SLATEC (XERROR)
C***CATEGORY  R3C
C***TYPE      ALL (XGETUA-A)
C***KEYWORDS  ERROR, XERROR
C***AUTHOR  Jones, R. E., (SNLA)
C***DESCRIPTION
C
C     Abstract
C        XGETUA may be called to determine the unit number or numbers
C        to which error messages are being sent.
C        These unit numbers may have been set by a call to XSETUN,
C        or a call to XSETUA, or may be a default value.
C
C     Description of Parameters
C      --Output--
C        IUNIT - an array of one to five unit numbers, depending
C                on the value of N.  A value of zero refers to the
C                default unit, as defined by the I1MACH machine
C                constant routine.  Only IUNIT(1),...,IUNIT(N) are
C                defined by XGETUA.  The values of IUNIT(N+1),...,
C                IUNIT(5) are not defined (for N .LT. 5) or altered
C                in any way by XGETUA.
C        N     - the number of units to which copies of the
C                error messages are being sent.  N will be in the
C                range from 1 to 5.
C
C***REFERENCES  R. E. Jones and D. K. Kahaner, XERROR, the SLATEC
C                 Error-handling Package, SAND82-0800, Sandia
C                 Laboratories, 1982.
C***ROUTINES CALLED  J4SAVE
C***REVISION HISTORY  (YYMMDD)
C   790801  DATE WRITTEN
C   861211  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   920501  Reformatted the REFERENCES section.  (WRB)
C***END PROLOGUE  XGETUA
      DIMENSION IUNITA(5)
C***FIRST EXECUTABLE STATEMENT  XGETUA
      N = J4SAVE(5,0,.FALSE.)
      DO 30 I=1,N
         INDEX = I+4
         IF (I.EQ.1) INDEX = 3
         IUNITA(I) = J4SAVE(INDEX,0,.FALSE.)
   30 CONTINUE
      RETURN
      END
