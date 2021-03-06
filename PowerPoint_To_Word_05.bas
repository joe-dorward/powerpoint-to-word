' PowerPoint_To_Word_05.bas
' GLOBAL VARIABLES
Dim AbsoluteDocumentPath As String
Dim DocumentFilename As String
Dim WorkingFolderPath As String
Dim PresentationFilename As String
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
Sub Main()
    AbsoluteDocumentPath = Get_AbsoluteDocumentPath()
    DocumentFilename = Get_DocumentFilename()
    WorkingFolderPath = Get_WorkingFolderPath()
    
    ' open the presentation
    Call Open_ThePresentation

    ' get presentation filename
    PresentationFilename = Get_PresentationFilename()
    MsgBox PresentationFilename, , "Get_PresentationFilename()"
End Sub
