program GameOfLife
    implicit none

    interface
        function getCell(board, row, col, height, width) result (cell)
            logical, intent(in) :: board(:)
            integer, intent(in) :: row, col, height, width
            logical :: cell
        end function getCell

        subroutine nextGen(board, height, width)
            integer, intent(in) :: height, width
            logical, intent(inout) :: board(:)
        end subroutine nextGen

        subroutine printBoard(board)
            logical, intent(in) :: board(:)
        end subroutine printBoard
    end interface

    integer :: height, width, generations, i
    logical, allocatable :: board(:)
    real :: randomValue


    call random_seed()

    height = 50
    width = 100
    generations = 500

    allocate(board(height*width))

    do i = 1, size(board)
        call random_number(randomValue)
        if (randomValue < 0.5) then
            board(i) = .false.
        else
            board(i) = .true.
        end if
    end do

    do i = 1, generations
        call printBoard(board)
        write(*, "(A, '[', I0, 'A')", advance='no') char(27), height
        call nextGen(board, height, width)
    end do

    deallocate(board)

    stop
end program GameOfLife

function getCell(board, row, col, height, width) result (cell)
    implicit none
    logical, intent(in) :: board(:)
    integer, intent(in) :: row, col, height, width
    logical :: cell

    if (row >= 1 .and. col >= 1 .and. row <= height .and. col <= width) then
        cell = board((row-1)*width + col)
    else
        cell = .false.
    end if
end function getCell

subroutine nextGen(board, height, width)
    implicit none
    integer, intent(in) :: height, width
    logical, intent(inout) :: board(:)
    logical, allocatable :: boardCopy(:)

    integer :: i, j, n, m, adjacent
    logical :: cell

    interface
        function getCell(board, row, col, height, width) result (cell)
            logical, intent(in) :: board(:)
            integer, intent(in) :: row, col, height, width
            logical :: cell
        end function getCell
    end interface

    allocate(boardCopy(size(board)))

    do i = 1, size(board)
        boardCopy(i) = board(i)
    end do

    do i = 1, height
        do j = 1, width
            cell = getCell(boardCopy, i, j, height, width)
            adjacent = 0

            do n = -1, 1
                do m = -1, 1
                    if (n /= 0 .or. m /= 0) then
                        if (getCell(boardCopy, i+n, j+m, height, width)) then
                            adjacent = adjacent + 1
                        end if
                    end if
                end do
            end do

            if (cell) then
                if (adjacent < 2) then
                    cell = .false.
                end if
                if (adjacent > 3) then
                    cell = .false.
                end if
            else
                if (adjacent == 3) then
                    cell = .true.
                end if
            end if

            board((i-1)*width + j) = cell
        end do
    end do

    deallocate(boardCopy)
end subroutine nextGen

subroutine printBoard(board)
    implicit none
    logical, intent(in) :: board(:)

    integer :: i, j

    do i = 1, 50
        do j = 1, 100
            if (board((i-1)*100 + j)) then
                write(*, '(A)', advance='no') "██"
            else
                write(*, '(A)', advance='no') "  "
            end if
        end do
        write(*, '(A)') ''
    end do
end subroutine printBoard
