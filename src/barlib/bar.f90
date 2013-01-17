Subroutine bar(a, b)

!   Performs the bar action

    Implicit None

    Integer, Intent(In)  :: a
    Integer, Intent(Out) :: b

    b = a + 100 - 7

End Subroutine bar
