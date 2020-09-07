using System;
using System.Net.Mail;
using System.Web;

/// <summary>
/// Descripción breve de Correo
/// </summary>
public partial class Correo
{ 
    public void enviarCorreo(string correoDestino, string userToken, string mensaje, string url, string estado)
    {
        // inicializar variable var
        var Emailtemplate = (dynamic)null;
         if (estado.Equals(Constantes.ESTADO_EN_ESPERA))
            {
                Emailtemplate = new System.IO.StreamReader
                (AppDomain.CurrentDomain.BaseDirectory.Insert
                (AppDomain.CurrentDomain.BaseDirectory.Length,
                "Recursos\\SendMail\\ActivarCuenta.html"));
            }
            else if (estado.Equals(Constantes.ESTADO_CAMBIO_PASS))
            {
                Emailtemplate = new System.IO.StreamReader
               (AppDomain.CurrentDomain.BaseDirectory.Insert
               (AppDomain.CurrentDomain.BaseDirectory.Length,
               "Recursos\\SendMail\\CambiarPassword.html"));
            }    

            
            var strBody = string.Format(Emailtemplate.ReadToEnd(), userToken);
            Emailtemplate.Close();
            Emailtemplate.Dispose();
            Emailtemplate = null;
            string hostPuerto = HttpContext.Current.Request.Url.Authority;
            strBody = strBody.Replace("token", "http://" + hostPuerto +  url + userToken);
            //Configuración del Mensaje
            MailMessage mail = new MailMessage();
            //Especificamos el correo desde el que se enviará el Email y el nombre de la persona que lo envía
            mail.From = new MailAddress("tudec@tudecCundi.com", "TUdeC");
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
            String HOST = "smtp.gmail.com";

            // The port you will connect to on the Amazon SES SMTP endpoint. We
            // are choosing port 587 because we will use STARTTLS to encrypt
            // the connection.
            int PORT = 587;
            using (var client = new SmtpClient(HOST, PORT))
            {
                client.EnableSsl = true;
                client.UseDefaultCredentials = false;
                // Pass SMTP credentials
                client.Credentials = new System.Net.NetworkCredential(Constantes.CORREO, Constantes.PASSWORD);
                // Enable SSL encryption
                // Try to send the message. Show status in console.
                try
                {
                    client.Send(mail);
                    mail.Dispose();
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
    }
}