!===============================================================================
! The "take" operation
! Last edited: Sep 9, 2021 (WYP)
!===============================================================================
MODULE mod_moa_take

  USE mod_prec
  IMPLICIT NONE

  PRIVATE
  PUBLIC :: moa_take

  INTERFACE moa_take

    ! scalar take vector
    MODULE PROCEDURE take_sv_i_i,
                     take_sv_dl_dl, &
                     take_sv_i_f,  take_sv_dl_f, &
                     take_sv_i_dd, take_sv_dl_dd

  END INTERFACE moa_take

CONTAINS

!===============================================================================
! Helper function to print error message on overtake (for default integer type)
!===============================================================================
  LOGICAL FUNCTION check_overtake_i( sigma, n )

    USE ISO_FORTRAN_ENV, ONLY: u => error_unit
    IMPLICIT NONE

    ! Input arguments
    INTEGER, INTENT(IN) :: sigma, n

    ! Internal variables
    LOGICAL :: lvalid

    ! Initialize
    lvalid = .FALSE.

    IF( ABS(sigma) <= n ) THEN
      lvalid = .TRUE.
    ELSE
      lvalid = .FALSE.
      WRITE(u,'(A,I0,A,I0)') , 'Error[moa_take]: Overtake not allowed ', &
                               sigma, ' out of ', n
    END IF

    check_overtake_i = lvalid
    RETURN
  END FUNCTION check_overtake_i

!===============================================================================
! Helper function to print error message on overtake (for 64-bit integer)
!===============================================================================
  LOGICAL FUNCTION check_overtake_dl( sigma, n )

    USE ISO_FORTRAN_ENV, ONLY: u => error_unit
    IMPLICIT NONE

    ! Input arguments
    INTEGER(KIND=dl), INTENT(IN) :: sigma
    INTEGER, INTENT(IN) :: n

    ! Internal variables
    LOGICAL :: lvalid

    ! Initialize
    lvalid = .FALSE.

    IF( ABS(sigma) <= INT(n,KIND=dl) ) THEN
      lvalid = .TRUE.
    ELSE
      lvalid = .FALSE.
      WRITE(u,'(A,I0,A,I0)') , 'Error[moa_take]: Overtake not allowed ', &
                               sigma, ' out of ', n
    END IF

    check_overtake_dl = lvalid
    RETURN
  END FUNCTION check_overtake_dl

!===============================================================================
! Implementation of scalar take vector for default integer type
!===============================================================================
  FUNCTION take_sv_i_i( sigma, n ) RESULT( take )

    IMPLICIT NONE

    ! Arguments
    INTEGER, INTENT(IN) :: sigma
    INTEGER, INTENT(IN), TARGET :: vec(:)
    INTEGER, POINTER :: take(:)

    ! Internal variables
    INTEGER :: n
    LOGICAL :: lvalid

    n = SIZE( vec, 1 )
    lvalid = check_overtake_i( sigma, n )
    IF( lvalid ) THEN

      IF( sigma > 0 ) THEN

        ! Positive take
        take => vec( :sigma )

      ELSE

        ! Negative take
        ! Note how +1 is needed here to account for 1-based Fortran indexing
        take => vec( (n+sigma+1): )

      END IF

    ELSE

      ! Overtake
      NULLIFY(take)

    END IF

  END FUNCTION take_sv_i

!===============================================================================
! Implementation of scalar take vector for 64-bit integer type
!===============================================================================
  FUNCTION take_sv_dl_dl( sigma, n ) RESULT( take )

    IMPLICIT NONE

    ! Arguments
    INTEGER(KIND=dl), INTENT(IN) :: sigma
    INTEGER(KIND=dl), INTENT(IN), TARGET :: vec(:)
    INTEGER(KIND=dl), POINTER :: take(:)

    ! Internal variables
    INTEGER :: n
    LOGICAL :: lvalid

    n = SIZE( vec, 1 )
    lvalid = check_overtake_dl( sigma, n )
    IF( lvalid ) THEN

      IF( sigma > 0 ) THEN

        ! Positive take
        take => vec( :sigma )

      ELSE

        ! Negative take
        ! Note how +1 is needed here to account for 1-based Fortran indexing
        take => vec( (n+sigma+1): )

      END IF

    ELSE

      ! Overtake
      NULLIFY(take)

    END IF

  END FUNCTION take_sv_dl_dl

!===============================================================================
! Implementation of scalar take vector for default integer and real types
!===============================================================================
  FUNCTION take_sv_i_f( sigma, vec )

    IMPLICIT NONE

    ! Arguments
    INTEGER, INTENT(IN) :: sigma
    REAL, INTENT(IN), TARGET :: vec(:)
    REAL, POINTER :: take(:)

    ! Internal variables
    INTEGER :: n
    LOGICAL :: lvalid

    n = SIZE( vec, 1 )

    lvalid = check_overtake_i( sigma, n )
    IF( lvalid ) THEN

      IF( sigma > 0 ) THEN

        ! Positive take
        take => vec( :sigma )

      ELSE

        ! Negative take
        ! Note how +1 is needed here to account for 1-based Fortran indexing
        take => vec( (n+sigma+1): )

      END IF

    ELSE

      ! Overtake
      NULLIFY(take)

    END IF

  END FUNCTION take_sv_i_f

!===============================================================================
! Implementation of scalar take vector for 64-bit integer and default real type
!===============================================================================
  FUNCTION take_sv_dl_f( sigma, vec )

    IMPLICIT NONE

    ! Arguments
    INTEGER(KIND=dl), INTENT(IN) :: sigma
    REAL, INTENT(IN), TARGET :: vec(:)
    REAL, POINTER :: take(:)

    ! Internal variables
    INTEGER :: n
    LOGICAL :: lvalid

    n = SIZE( vec, 1 )

    lvalid = check_overtake_dl( sigma, n )
    IF( lvalid ) THEN

      IF( sigma > 0 ) THEN

        ! Positive take
        take => vec( :sigma )

      ELSE

        ! Negative take
        ! Note how +1 is needed here to account for 1-based Fortran indexing
        take => vec( (n+sigma+1): )

      END IF

    ELSE

      ! Overtake
      NULLIFY(take)

    END IF

  END FUNCTION take_sv_dl_f

!===============================================================================
! Implementation of scalar take vector for default integer type and 64-bit real
!===============================================================================
  FUNCTION take_sv_i_dd( sigma, vec )

    IMPLICIT NONE

    ! Arguments
    INTEGER, INTENT(IN) :: sigma
    REAL(KIND=dd), INTENT(IN), TARGET :: vec(:)
    REAL(KIND=dd), POINTER :: take(:)

    ! Internal variables
    INTEGER :: n
    LOGICAL :: lvalid

    n = SIZE( vec, 1 )

    lvalid = check_overtake_i( sigma, n )
    IF( lvalid ) THEN

      IF( sigma > 0 ) THEN

        ! Positive take
        take => vec( :sigma )

      ELSE

        ! Negative take
        ! Note how +1 is needed here to account for 1-based Fortran indexing
        take => vec( (n+sigma+1): )

      END IF

    ELSE

      ! Overtake
      NULLIFY(take)

    END IF

  END FUNCTION take_sv_i_dd

!===============================================================================
! Implementation of scalar take vector for 64-bit integer and default real type
!===============================================================================
  FUNCTION take_sv_dl_dd( sigma, vec )

    IMPLICIT NONE

    ! Arguments
    INTEGER(KIND=dl), INTENT(IN) :: sigma
    REAL(KIND=dd), INTENT(IN), TARGET :: vec(:)
    REAL(KIND=dd), POINTER :: take(:)

    ! Internal variables
    INTEGER :: n
    LOGICAL :: lvalid

    n = SIZE( vec, 1 )

    lvalid = check_overtake_dl( sigma, n )
    IF( lvalid ) THEN

      IF( sigma > 0 ) THEN

        ! Positive take
        take => vec( :sigma )

      ELSE

        ! Negative take
        ! Note how +1 is needed here to account for 1-based Fortran indexing
        take => vec( (n+sigma+1): )

      END IF

    ELSE

      ! Overtake
      NULLIFY(take)

    END IF

  END FUNCTION take_sv_dl_dd

!===============================================================================

END MODULE mod_moa_take
