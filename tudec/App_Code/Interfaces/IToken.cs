using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for IToken
/// </summary>
public interface IToken
{
    EUsuario buscarUsuarioxToken(string token);
}