module bar_module
  contains
  Subroutine bar(a, b)
    !DIR$ ATTRIBUTES DEFAULT, DLLEXPORT, DECORATE, ALIAS: 'bar' :: bar
    !
    ! The above comment line is actually a series of Intel compiler directives
    ! useful for creating a shared library on all platforms

    ! Performs the bar action

    Implicit None

    Integer, Intent(In)  :: a
    Integer, Intent(Out) :: b

    b = a + 100 - 7

  End Subroutine bar
end module bar_module
