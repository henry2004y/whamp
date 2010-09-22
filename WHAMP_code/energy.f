*********************************************************
*
* File energy.f
* The polarization vectors are here calculated from the
* matrix of cofactors (e.g., D. B. Melrose, Plasma Astrophysics, 
* Vol I, p. 43, Gordon and Breach, 1980).


      SUBROUTINE ENERGY(U1,U3,U2,U12,U32)
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 U1,U3,U2,U12,U32,A,B,C
      COMPLEX*16 ERG, CM(3,3), DDER(3,3), ECON, EE(6,4)
      include 'comcout.h'
C
C
      DO 1 I=1,6
      DO 1 J=1,4
   1  EE(I,J)=E(I,J)
C
      DDER(1,1)=EE(1,1)+EE(1,2)+U32
      DDER(1,2)=EE(2,1)+EE(2,2)
      DDER(1,3)=EE(3,1)+EE(3,2)-U1*U3
      DDER(2,2)=EE(4,1)+EE(4,2)+U2
      DDER(2,3)=EE(5,1)+EE(5,2)
      DDER(3,3)=EE(6,1)+EE(6,2)+U12
      DDER(2,1)=-DDER(1,2)
      DDER(3,1)=DDER(1,3)
      DDER(3,2)=-DDER(2,3)
C
      EE(1,1)=EE(1,1)-U32
      EE(3,1)=EE(3,1)+U1*U3
      EE(4,1)=EE(4,1)-U2
      EE(6,1)=EE(6,1)-U12 
*  Form the elements of the cofactor matrix
      CM(1,1)=EE(4,1)*EE(6,1)
     *       +EE(5,1)*EE(5,1)
***** Correction 1994-04-13 so that Im E_y < 0 now corresponds 
*     to L-mode waves again.   Kjell R.
*****  CM(2,1)=EE(2,1)*EE(6,1)
      CM(1,2)=EE(2,1)*EE(6,1)
     *       +EE(5,1)*EE(3,1)
      CM(1,3)=EE(2,1)*EE(5,1)
     *       -EE(4,1)*EE(3,1)
      CM(2,2)=EE(1,1)*EE(6,1)
     *       -EE(3,1)*EE(3,1)
***** Correction 1994-04-13 so that Im E_y < 0 now corresponds 
*     to L-mode waves again.   Kjell R.
****  CM(3,2)=EE(5,1)*EE(1,1)
      CM(2,3)=EE(5,1)*EE(1,1)
     *       +EE(3,1)*EE(2,1)
      CM(3,3)=EE(1,1)*EE(4,1)
     *       +EE(2,1)*EE(2,1)
***** Correction 1994-04-13 so that Im E_y < 0 now corresponds 
*     to L-mode waves again.   Kjell R.
****   CM(1,2)=-CM(2,1)
      CM(2,1) = -CM(1,2)
      CM(3,1)=CM(1,3)
****   CM(2,3)=-CM(3,2)
      CM(3,2) = -CM(2,3)
C
C
      V=1./299.792458
      DO 10 I=1,3
      EFL(I)=(0.,0.)
      DO 10 J=1,3
   10 EFL(I)=EFL(I)+CM(J,I)
C
      IF(ABS(EFL(1)).LT.1000.*ABS(EFL(3))) THEN
          ECON=CONJG(EFL(3))
      ELSE
          ECON=CONJG(EFL(1))
      ENDIF
C
      A=EFL(1)*ECON
      B=EFL(2)*ECON
      C=EFL(3)*ECON
C
      Q=A*CONJG(A)+B*CONJG(B)+C*CONJG(C)
      Q=SQRT(Q)
C
      EFL(1)=A/Q
      EFL(2)=B/Q
      EFL(3)=C/Q
      BFL(1)=-V*U3*EFL(2)
      BFL(2)=V*(U3*EFL(1)-U1*EFL(3))
      BFL(3)=V*U1*EFL(2)
C
      ERG=(0.,0.)
      DO 20 I=1,3
      DO 20 J=1,3
   20 ERG=ERG+ CONJG(EFL(I))*DDER(I,J)*EFL(J)
C
      ENE=ERG*CONJG(ERG)/(ERG+CONJG(ERG))
      END