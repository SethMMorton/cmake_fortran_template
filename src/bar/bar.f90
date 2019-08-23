module bar_module
  contains
  Subroutine bar(a, b)
    !DIR$ ATTRIBUTES DEFAULT, DLLEXPORT, DECORATE, ALIAS: 'bar' :: bar

  !   Performs the bar action

    Implicit None

    Integer, Intent(In)  :: a
    Integer, Intent(Out) :: b

    b = a + 100 - 7

  End Subroutine bar
end module bar_module
