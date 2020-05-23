<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Pruebas.aspx.cs" Inherits="Vistas_Pruebas" %>

<%@ Register Src="~/Controles/Examenes/CreacionExamen.ascx" TagPrefix="uc1" TagName="CreacionExamen" %>
<%@ Register Src="~/Controles/Examenes/ElaboracionExamen.ascx" TagPrefix="uc1" TagName="ElaboracionExamen" %>
<%@ Register Src="~/Controles/Examenes/CalificacionExamen.ascx" TagPrefix="uc1" TagName="CalificacionExamen" %>




<script type='text/javascript' src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
 

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <script src="../CKEditor4/ckeditor.js"></script>
  

</head>

<body>

    <form id="form1" runat="server">
       
      <textarea name="editor1" id="editor1" >
                This is my textarea to be replaced with CKEditor.
            </textarea>

        <script>

            
            CKEDITOR.replace("editor1");
      

        </script>

        </form>
</body>
</html>
