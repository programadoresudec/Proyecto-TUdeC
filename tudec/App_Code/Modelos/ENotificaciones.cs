using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

[Table("notificaciones", Schema = "notificaciones")]
public class ENotificaciones
{

    private int id;
    private string mensaje;
    private Boolean estado;
    private string nombreDeUsuario;

    public int Id { get => id; set => id = value; }
    public string Mensaje { get => mensaje; set => mensaje = value; }
    public bool Estado { get => estado; set => estado = value; }
    public string NombreDeUsuario { get => nombreDeUsuario; set => nombreDeUsuario = value; }

}
