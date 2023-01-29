Class Board
    Public m_Cells As List(Of Boolean)
    Public m_Height As Integer
    Public m_Width As Integer

    Public Sub New(ByVal height As Integer, ByVal width As Integer)
        m_Height = height
        m_Width = width
        m_Cells = New List(Of Boolean)

        Dim random As Random = New Random
        For i = 1 To (height*width)
            m_Cells.Add(random.Next(2))
        Next i
    End Sub

    Public Sub New(ByRef other As Board)
        m_Cells = other.m_Cells.ToList()
        m_Height = other.m_Height
        m_Width = other.m_Width
    End Sub

    Public Sub Draw()
        For i = 0 To (m_Height-1)
            For j = 0 To (m_Width-1)
                If m_Cells((i * m_Width) + j) Then
                    Console.Write("██")
                Else
                    Console.Write("  ")
                End If
            Next j
            Console.WriteLine()
        Next i
    End Sub

    Public Function GetCell(ByVal row As Integer, ByVal col As Integer) As Boolean
        If (row >= 0) And (row < m_Height) And (col >= 0) And (col < m_Width) Then
            Return m_Cells((row * m_Width) + col)
        Else
            Return False
        End If
    End Function
End Class