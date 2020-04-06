using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;


public class Login: Base
{
    public Login()
    {
        
    }

    public DbSet<EUsuario> TablaUsuario { get; set; }


    public EUsuario GetUsuario(string nombreUsuario, string pass)
    {

        EUsuario usuario = TablaUsuario.Where(x => x.NombreDeUsuario.Equals(nombreUsuario) && x.Pass.Equals(pass)).FirstOrDefault();
        return usuario;

    }

}