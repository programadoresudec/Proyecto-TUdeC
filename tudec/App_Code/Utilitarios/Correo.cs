using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Web;

/// <summary>
/// Descripción breve de Correo
/// </summary>
public partial class Correo
{
    public Correo()
    {
    }

    public void enviarCorreo(String correoDestino, String userToken, String mensaje, String url)
    {
        try
        {
            var Emailtemplate = new System.IO.StreamReader(AppDomain.CurrentDomain.BaseDirectory.Insert(AppDomain.CurrentDomain.BaseDirectory.Length, "Recursos\\SendMail\\SenderMail.html"));
            var strBody = string.Format(Emailtemplate.ReadToEnd(), userToken);
            Emailtemplate.Close(); Emailtemplate.Dispose(); Emailtemplate = null;
            string hostPuerto = HttpContext.Current.Request.Url.Authority;
            strBody = strBody.Replace("#TOKEN#", "Por favor recupere su cuenta ingresando al siguiente link: " + "su link de acceso es: " +
               hostPuerto + url + "?" + userToken);
            //Configuración del Mensaje
            MailMessage mail = new MailMessage();
            SmtpClient SmtpServer = new SmtpClient("smtp.gmail.com");
            //Especificamos el correo desde el que se enviará el Email y el nombre de la persona que lo envía
            mail.From = new MailAddress("tudec@gmail.com", "udec");
            SmtpServer.Host = "smtp.gmail.com";
            //Aquí ponemos el asunto del correo
            mail.Subject = mensaje;
            //Aquí ponemos el mensaje que incluirá el correo
            mail.Body = strBody;
            //Especificamos a quien enviaremos el Email, no es necesario que sea Gmail, puede ser cualquier otro proveedor
            mail.To.Add(correoDestino);
            //Si queremos enviar archivos adjuntos tenemos que especificar la ruta en donde se encuentran
            //mail.Attachments.Add(new Attachment(@"C:\Documentos\carta.docx"));
            mail.IsBodyHtml = true;

            mail.Priority = MailPriority.Normal;
            //Configuracion del SMTP
            SmtpServer.Port = 587; //Puerto que utiliza Gmail para sus servicios
            //Especificamos las credenciales con las que enviaremos el mail
            SmtpServer.Credentials = new System.Net.NetworkCredential("tudec@gmail.com", "programadoresudec2020");
            SmtpServer.EnableSsl = true;
            SmtpServer.Send(mail);
            mail.Dispose();
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

}