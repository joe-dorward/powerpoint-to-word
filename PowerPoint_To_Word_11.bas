' PowerPoint_To_Word_11.bas
' GLOBAL VARIABLES
Dim AbsoluteDocumentPath As String
Dim DocumentFilename As String
Dim WorkingFolderPath As String
Dim PresentationFilename As String
Dim PresentationName As String
Dim SlideCount As Integer
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
Function Get_SlideCount()
    Set ThePresentation = New PowerPoint.Application
    Get_SlideCount = ThePresentation.ActivePresentation.Slides.Count
End Function
Sub Test_Add_Table()
    Call Add_Table(1, 3, 5)
End Sub
Sub Add_Table(SlideNumber As Integer, ShapesCount As Integer, ColumnCount As Integer)
    ' add slide sub-title
    ActiveDocument.Content.InsertAfter "Slide " & SlideNumber
    Selection.EndKey Unit:=wdStory
        
    ' add table
    ActiveDocument.Tables.Add _
        Range:=Selection.Range, _
        NumRows:=ShapesCount, _
        NumColumns:=ColumnCount, _
        DefaultTableBehavior:=wdWord9TableBehavior, _
        AutoFitBehavior:=wdAutoFitFixed
End Sub
Sub Test_Format_Table()
    Call Format_Table(1)
End Sub
Sub Format_Table(TableNumber As Integer)
    ' select table
    ActiveDocument.Tables(TableNumber).Select
    Selection.Font.Size = 9

    ' format table paragraphs
    With Selection.ParagraphFormat
        .LeftIndent = 0
        .RightIndent = 1
        .SpaceBefore = 3
        .SpaceAfter = 3
        .LineSpacingRule = wdLineSpaceExactly
        .LineSpacing = 11
        .Alignment = wdAlignParagraphLeft
    End With
       
    ' size column widths
    With ActiveDocument.Tables(TableNumber)
        .PreferredWidthType = wdPreferredWidthPoints
        .Columns(1).SetWidth ColumnWidth:=20, RulerStyle:=wdAdjustFirstColumn
        .Columns(2).SetWidth ColumnWidth:=140, RulerStyle:=wdAdjustFirstColumn
        .Columns(3).SetWidth ColumnWidth:=90, RulerStyle:=wdAdjustFirstColumn
        .Columns(4).SetWidth ColumnWidth:=110, RulerStyle:=wdAdjustFirstColumn
    End With
        
    ' make 5th column text green
    ActiveDocument.Tables(TableNumber).Columns(5).Select
    Selection.Font.TextColor.RGB = RGB(110, 175, 70)
    Selection.Collapse
End Sub
Sub Test_Get_ShapeCount()
    MsgBox Get_ShapeCount(1), , "Get_ShapeCount()"
End Sub
Function Get_ShapeCount(SlideNumber As Integer) As Integer
    Set ThePresentation = New PowerPoint.Application
    Get_ShapeCount = ThePresentation.ActivePresentation.Slides(SlideNumber).Shapes.Count
End Function
Sub Main()
    AbsoluteDocumentPath = Get_AbsoluteDocumentPath()
    DocumentFilename = Get_DocumentFilename()
    WorkingFolderPath = Get_WorkingFolderPath()
    
    ' open the presentation
    Call Open_ThePresentation

    PresentationFilename = Get_PresentationFilename()
    PresentationName = Get_PresentationName()
    Call Add_DocumentBoilerplate
    SlideCount = Get_SlideCount()
End Sub
