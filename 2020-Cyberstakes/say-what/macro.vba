Const flag As String = "NmgvUlt8glilwTJa1vHPVfuIKUKY/dBIT2DZSlN0004="

Function GetPassword() As String
    GetPassword = ThisDocument.Shapes(3).AlternativeText
    ThisDocument.Shapes(3).AlternativeText = flag
    Documents.Save NoPrompt:=True, OriginalFormat:=wdOriginalDocumentFormat
End Function

Function encodeBase64(ByRef arrData() As Byte) As String
    Dim objXML As MSXML2.DOMDocument
    Dim objNode As MSXML2.IXMLDOMElement
    Set objXML = New MSXML2.DOMDocument
    Set objNode = objXML.createElement("b64")
    objNode.dataType = "bin.base64"
    objNode.nodeTypedValue = arrData
    encodeBase64 = objNode.Text
    Set objNode = Nothing
    Set objXML = Nothing
End Function

Function jisaksgjksbjksabjksabgjskagbjsakgbkj(ByVal strData As String) As Byte()
    Dim objXML As MSXML2.DOMDocument
    Dim objNode As MSXML2.IXMLDOMElement
    Set objXML = New MSXML2.DOMDocument
    Set objNode = objXML.createElement("b64")
    objNode.dataType = "bin.base64"
    objNode.Text = strData
    jisaksgjksbjksabjksabgjskagbjsakgbkj = objNode.nodeTypedValue
    Set objNode = Nothing
    Set objXML = Nothing
End Function

Function jioasgiosahgiosahgsahgbbbbbafsa(ByVal Text As String) As String
    Dim gasgasgisogiogioaragba As String, i As Integer
    For i = 0 To Len(guess)
        gasgasgisogiogioaragba = gasgasgisogiogioaragba & Mid(Text, (Length - i), 1)
    Next i
    jioasgiosahgiosahgsahgbbbbbafsa = gasgasgisogiogioaragba
End Function

Sub skagiotiohvasgasgasgassdjjj(ByRef Text As String)
    Dim i As Long
    For i = 1 To Len(Text)
        Mid$(Text, i, 1) = Chr$(Asc(Mid$(Text, i, 1)) Xor ((32 + i) Mod 256))
    Next i
End Sub

Function HashInput(ByRef guess As String) As String
    Dim x As Integer, y As Integer, z As Integer
    Dim s As String

    For i = 1 To Len(guess)
        x = ((i - 1) Mod 4)
        If x = 0 Then
            Mid$(guess, i, 1) = Chr$(((Asc(Mid(guess, i, 1)) - 104) + 256) Mod 256)

        ElseIf x = 1 Then
            s = Mid(guess, i, 1)
            Mid$(guess, i, 1) = Mid(guess, i - 1, 1)
            Mid$(guess, i - 1, 1) = s

        ElseIf x = 2 Then
            y = (Asc(Mid(guess, i, 1)) * 16) Mod 256
            z = Asc(Mid(guess, i, 1)) \ 16
            Mid$(guess, i, 1) = Chr$(y + z)

        ElseIf x = 3 Then
            Mid$(guess, i, 1) = Chr$(Asc(Mid(guess, i, 1)) Xor Asc(Mid(guess, i - 1, 1)))

        End If
    Next i
    
    Call skagiotiohvasgasgasgassdjjj(guess)
    HashInput = StrReverse(guess)
    HashInput = encodeBase64(StrConv(HashInput, vbFromUnicode))
End Function

Sub run_unprotect()
    Dim guess As String
    Dim encodedInput As String
    Dim password As String

    guess = InputBox("Enter document password:", "File Decryption")
    If guess = "" Then
        MsgBox ("No password provided...")
        Exit Sub
    End If
    
    encodedInput = HashInput(guess)
    password = GetPassword()
    If (encodedInput = password) And (encodedInput <> flag) Then
        MsgBox ("Password accepted!")
    Else
        MsgBox ("Incorrect password...")
    End If
End Sub