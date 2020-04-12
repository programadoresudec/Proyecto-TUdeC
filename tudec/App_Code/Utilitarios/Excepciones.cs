using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Excepciones
/// </summary>
public class Excepciones
{
    public Excepciones()
    {
    }
    // Metodo que obtiene el error de postgres en la base de datos
    public TException GetInnerException<TException>(Exception exception)
    where TException : Exception
    {
        Exception innerException = exception;
        while (innerException != null)
        {
            if (innerException is TException result)
            {
                return result;
            }
            innerException = innerException.InnerException;
        }
        return null;
    }
}
