Program foo

!   FOO!!! This is the best foo implementatiton ever!

    use constants

    Implicit None

    Real(KINDR) :: r
    Integer     :: i

    write(stdout,*) "Hello, world!"
    r = FIVE
    write(stdout,*) r
    call bar (5, i)
    write(stdout,*) i

End Program foo
