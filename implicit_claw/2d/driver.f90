program driver

! Driver program for a 2-dimensional Clawpack application.  We perform a few
! supplemental tasks in addition to the most basic driver functionality:
!   - Arrays are allocated dynamically, ensuring that maxmx==mx and my==my.
!   - Basic parameters of the spatial discretization are read into the common
!     block claw_config.

    implicit none

    common /claw_config/ mx, my, mbc, x_lower, y_lower, dx, dy, meqn

    character :: skip_me
    integer :: mx, my, maxm, meqn, mwaves, mbc, maux, i, mwork
    integer, dimension(:), allocatable :: mthlim
    double precision :: x_lower, x_upper, y_lower, y_upper, dx, dy
    double precision, dimension(:,:,:), allocatable :: q, aux
    double precision, dimension(:), allocatable :: work


    call opendatafile(55,'claw.data')
    read(55, *) skip_me    
    read(55, *) mx
    read(55, *) my
    do i=1,14
        read(55, *) skip_me
    end do
    read(55, *) maux
    read(55, *) meqn
    read(55, *) mwaves
    do i=1,2
        read(55, *) skip_me
    end do
    read(55, *), x_lower
    read(55, *), x_upper
    read(55, *), y_lower
    read(55, *), y_upper
    read(55, *) mbc
    close(55)

    dx = (x_upper - x_lower) / mx
    dy = (y_upper - y_lower) / my

    allocate(q(1-mbc:mx+mbc, 1-mbc:my+mbc, meqn))

    if (maux>0) then
        allocate(aux(1-mbc:mx+mbc, 1-mbc:my+mbc, maux))
    else
        allocate(aux(1,1,1))
    end if
    
    allocate(mthlim(mwaves))
    
    maxm = max0(mx,my)
    mwork = (maxm+2*mbc)*(10*meqn + mwaves + meqn*mwaves + 3*maux + 2)    &
             + 2 * (mx + 2*mbc) * (my + 2*mbc) * meqn
                          
    allocate(work(mwork))    

    call claw2ez(mx,my,meqn,mwaves,mbc,maux,mwork,mthlim,q,work,aux)

    stop 
end program driver
