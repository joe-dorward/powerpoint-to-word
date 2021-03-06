' PowerPoint_To_Word_07.bas
' GLOBAL VARIABLES
Dim AbsoluteDocumentPath As String
Dim DocumentFilename As String
Dim WorkingFolderPath As String
Dim PresentationFilename As String
Dim PresentationName As String
' --------------- --------------- --------------- --------------- ---------------
Function Get_AbsoluteDocumentPath() As String
    Get_AbsoluteDocumentPath = Application.ActiveDocument.FullName
End Function
Function Get_DocumentFilename()
    Get_DocumentFilename = Application.ActiveDocument.name
End Function
Function Get_WorkingFolderPath()
    Dim WorkingFolderPathLength As Integer

    WorkingFolderPathLength = Len(AbsoluteDocumentPath) - Len(DocumentFilename)
    Get_WorkingFolderPath = Left(AbsoluteDocumentPath, WorkingFolderPathLength)
End Function
Sub Open_ThePresentation()
    Set ThePresentation = New PowerPoint.Application
    
    ' create file dialog
    Dim TheFileDialog As FileDialog
    Set TheFileDialog = Application.FileDialog(FileDialogType:=msoFileDialogOpen)
    
    ' configure file dialog
    TheFileDialog.InitialFileName = WorkingFolderPath
    TheFileDialog.Title = "Select PowerPoint Presentation"
    TheFileDialog.Filters.Add "PowerPoint Presentations", "*.pptx", 1
    
    ' open file dialog
    TheFileDialog.Show

    ' open selected presentation
    ThePresentation.Presentations.Open TheFileDialog.SelectedItems.Item(1)
End Sub
Function Get_PresentationFilename()
    Set ThePresentation = New PowerPoint.Application
    Get_PresentationFilename = ThePresentation.ActivePresentation.name
End Function
Function Get_PresentationName()
    Set ThePresentation = New PowerPoint.Application
    Dim DotPosition As Integer

    DotPosition = InStr(PresentationFilename, ".")
    Get_PresentationName = Left(PresentationFilename, DotPosition - 1)
End Function
Sub Add_DocumentBoilerplate()
    ' add document title
    ActiveDocument.Content.InsertAfter PresentationName & vbLf & vbLf
    
    ' format document title
    ActiveDocument.Paragraphs(1).Range.Select
    Selection.Font.Size = 12
    Selection.Font.Bold = True
    Selection.Collapse
      
    ' add note to translator
    ActiveDocument.Content.InsertAfter "Note to translator: You should only translate the green text." & vbLf
End Sub
Sub Main()
    AbsoluteDocumentPath = Get_AbsoluteDocumentPath()
    DocumentFilename = Get_DocumentFilename()
    WorkingFolderPath = Get_WorkingFolderPath()
    
    ' open the presentation
    Call Open_ThePresentation

    PresentationFilename = Get_PresentationFilename()
    PresentationName = Get_PresentationName()
    Call Add_DocumentBoilerplate
End Sub
