Imports System

Class Game
    Private m_Board As Board
    Private m_Generations As Integer

    Public Sub New(ByRef board As Board, ByVal generations As Integer)
        m_Board = board
        m_Generations = generations
    End Sub

    Public Sub Run()
        For i = 1 To m_Generations
            m_Board.Draw()
            Console.Write(ChrW(&H1B) + "[" + m_Board.m_Height.ToString() + "A")
            NextGen()
        Next i
    End Sub

    Private Sub NextGen()
        Dim boardCopy As Board = New Board(m_Board)
        For i = 0 To (m_Board.m_Height - 1)
            For j = 0 To (m_Board.m_Width - 1)
                Dim cell As Boolean = boardCopy.GetCell(i, j)
                Dim adjacent As Integer = 0

                For n = -1 To 1
                    For m = -1 To 1
                        If ((n = 0) And (m = 0)) Then
                            Continue For
                        End If
                        If (boardCopy.GetCell(i + n, j + m)) Then
                            adjacent = adjacent + 1
                        End If
                    Next m
                Next n

                If (cell) Then
                    If (adjacent < 2) Then
                        cell = False
                    End If
                    If (adjacent > 3) Then
                        cell = False
                    End If
                Else
                    If (adjacent = 3) Then
                        cell = True
                    End If
                End If

                m_Board.m_Cells((i * m_Board.m_Width) + j) = cell
            Next j
        Next i
    End Sub

End Class

Module Program
    Sub Main(args As String())
        Dim height As Integer = 50
        Dim width As Integer = 100
        Dim generations As Integer = 500

        Dim board As Board = New Board(height, width)
        Dim game As Game = new Game(board, generations)
        game.Run()
    End Sub
End Module
