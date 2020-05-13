PGDMP     0                    x            tudec    12.2    12.2 �               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    17662    tudec    DATABASE     �   CREATE DATABASE tudec WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Spanish_Latin America.1252' LC_CTYPE = 'Spanish_Latin America.1252';
    DROP DATABASE tudec;
                postgres    false                        2615    17663    comentarios    SCHEMA        CREATE SCHEMA comentarios;
    DROP SCHEMA comentarios;
                postgres    false                        2615    17664    cursos    SCHEMA        CREATE SCHEMA cursos;
    DROP SCHEMA cursos;
                postgres    false                        2615    17665    examenes    SCHEMA        CREATE SCHEMA examenes;
    DROP SCHEMA examenes;
                postgres    false                        2615    17666    mensajes    SCHEMA        CREATE SCHEMA mensajes;
    DROP SCHEMA mensajes;
                postgres    false                        2615    17667    notificaciones    SCHEMA        CREATE SCHEMA notificaciones;
    DROP SCHEMA notificaciones;
                postgres    false                        2615    17668    puntuaciones    SCHEMA        CREATE SCHEMA puntuaciones;
    DROP SCHEMA puntuaciones;
                postgres    false            
            2615    17669    reportes    SCHEMA        CREATE SCHEMA reportes;
    DROP SCHEMA reportes;
                postgres    false                        2615    17670 	   seguridad    SCHEMA        CREATE SCHEMA seguridad;
    DROP SCHEMA seguridad;
                postgres    false            	            2615    17671    sugerencias    SCHEMA        CREATE SCHEMA sugerencias;
    DROP SCHEMA sugerencias;
                postgres    false                        2615    17672    temas    SCHEMA        CREATE SCHEMA temas;
    DROP SCHEMA temas;
                postgres    false                        2615    17673    usuarios    SCHEMA        CREATE SCHEMA usuarios;
    DROP SCHEMA usuarios;
                postgres    false            �            1255    17674    f_log_auditoria()    FUNCTION     �  CREATE FUNCTION seguridad.f_log_auditoria() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	 DECLARE
		_pk TEXT :='';		-- Representa la llave primaria de la tabla que esta siedno modificada.
		_sql TEXT;		-- Variable para la creacion del procedured.
		_column_guia RECORD; 	-- Variable para el FOR guarda los nombre de las columnas.
		_column_key RECORD; 	-- Variable para el FOR guarda los PK de las columnas.
		_session TEXT;	-- Almacena el usuario que genera el cambio.
		_user_db TEXT;		-- Almacena el usuario de bd que genera la transaccion.
		_control INT;		-- Variabel de control par alas llaves primarias.
		_count_key INT = 0;	-- Cantidad de columnas pertenecientes al PK.
		_sql_insert TEXT;	-- Variable para la construcción del insert del json de forma dinamica.
		_sql_delete TEXT;	-- Variable para la construcción del delete del json de forma dinamica.
		_sql_update TEXT;	-- Variable para la construcción del update del json de forma dinamica.
		_new_data RECORD; 	-- Fila que representa los campos nuevos del registro.
		_old_data RECORD;	-- Fila que representa los campos viejos del registro.

	BEGIN

			-- Se genera la evaluacion para determianr el tipo de accion sobre la tabla
		 IF (TG_OP = 'INSERT') THEN
			_new_data := NEW;
			_old_data := NEW;
		ELSEIF (TG_OP = 'UPDATE') THEN
			_new_data := NEW;
			_old_data := OLD;
		ELSE
			_new_data := OLD;
			_old_data := OLD;
		END IF;

		-- Se genera la evaluacion para determianr el tipo de accion sobre la tabla
		IF ((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = TG_TABLE_SCHEMA AND table_name = TG_TABLE_NAME AND column_name = 'id' ) > 0) THEN
			_pk := _new_data.id;
		ELSE
			_pk := '-1';
		END IF;

		-- Se valida que exista el campo modified_by
		IF ((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = TG_TABLE_SCHEMA AND table_name = TG_TABLE_NAME AND column_name = 'session') > 0) THEN
			_session := _new_data.session;
		ELSE
			_session := '';
		END IF;

		-- Se guarda el susuario de bd que genera la transaccion
		_user_db := (SELECT CURRENT_USER);

		-- Se evalua que exista el procedimeinto adecuado
		IF (SELECT COUNT(*) FROM seguridad.function_db_view acfdv WHERE acfdv.b_function = 'field_audit' AND acfdv.b_type_parameters = TG_TABLE_SCHEMA || '.'|| TG_TABLE_NAME || ', '|| TG_TABLE_SCHEMA || '.'|| TG_TABLE_NAME || ', character varying, character varying, character varying, text, character varying, text, text') > 0
			THEN
				-- Se realiza la invocación del procedured generado dinamivamente
				PERFORM seguridad.field_audit(_new_data, _old_data, TG_OP, _session, _user_db , _pk, ''::text);
		ELSE
			-- Se empieza la construcción del Procedured generico
			_sql := 'CREATE OR REPLACE FUNCTION seguridad.field_audit( _data_new '|| TG_TABLE_SCHEMA || '.'|| TG_TABLE_NAME || ', _data_old '|| TG_TABLE_SCHEMA || '.'|| TG_TABLE_NAME || ', _accion character varying, _session text, _user_db character varying, _table_pk text, _init text)'
			|| ' RETURNS TEXT AS ''
'
			|| '
'
	|| '	DECLARE
'
	|| '		_column_data TEXT;
	 	_datos jsonb;
	 	
'
	|| '	BEGIN
			_datos = ''''{}'''';
';
			-- Se evalua si hay que actualizar la pk del registro de auditoria.
			IF _pk = '-1'
				THEN
					_sql := _sql
					|| '
		_column_data := ';

					-- Se genera el update con la clave pk de la tabla
					SELECT
						COUNT(isk.column_name)
					INTO
						_control
					FROM
						information_schema.table_constraints istc JOIN information_schema.key_column_usage isk ON isk.constraint_name = istc.constraint_name
					WHERE
						istc.table_schema = TG_TABLE_SCHEMA
					 AND	istc.table_name = TG_TABLE_NAME
					 AND	istc.constraint_type ilike '%primary%';

					-- Se agregan las columnas que componen la pk de la tabla.
					FOR _column_key IN SELECT
							isk.column_name
						FROM
							information_schema.table_constraints istc JOIN information_schema.key_column_usage isk ON isk.constraint_name = istc.constraint_name
						WHERE
							istc.table_schema = TG_TABLE_SCHEMA
						 AND	istc.table_name = TG_TABLE_NAME
						 AND	istc.constraint_type ilike '%primary%'
						ORDER BY 
							isk.ordinal_position  LOOP

						_sql := _sql || ' _data_new.' || _column_key.column_name;
						
						_count_key := _count_key + 1 ;
						
						IF _count_key < _control THEN
							_sql :=	_sql || ' || ' || ''''',''''' || ' ||';
						END IF;
					END LOOP;
				_sql := _sql || ';';
			END IF;

			_sql_insert:='
		IF _accion = ''''INSERT''''
			THEN
				';
			_sql_delete:='
		ELSEIF _accion = ''''DELETE''''
			THEN
				';
			_sql_update:='
		ELSE
			';

			-- Se genera el ciclo de agregado de columnas para el nuevo procedured
			FOR _column_guia IN SELECT column_name, data_type FROM information_schema.columns WHERE table_schema = TG_TABLE_SCHEMA AND table_name = TG_TABLE_NAME
				LOOP
						
					_sql_insert:= _sql_insert || '_datos := _datos || json_build_object('''''
					|| _column_guia.column_name
					|| '_nuevo'
					|| ''''', '
					|| '_data_new.'
					|| _column_guia.column_name;

					IF _column_guia.data_type IN ('bytea', 'USER-DEFINED') THEN 
						_sql_insert:= _sql_insert
						||'::text';
					END IF;

					_sql_insert:= _sql_insert || ')::jsonb;
				';

					_sql_delete := _sql_delete || '_datos := _datos || json_build_object('''''
					|| _column_guia.column_name
					|| '_anterior'
					|| ''''', '
					|| '_data_old.'
					|| _column_guia.column_name;

					IF _column_guia.data_type IN ('bytea', 'USER-DEFINED') THEN 
						_sql_delete:= _sql_delete
						||'::text';
					END IF;

					_sql_delete:= _sql_delete || ')::jsonb;
				';

					_sql_update := _sql_update || 'IF _data_old.' || _column_guia.column_name;

					IF _column_guia.data_type IN ('bytea','USER-DEFINED') THEN 
						_sql_update:= _sql_update
						||'::text';
					END IF;

					_sql_update:= _sql_update || ' <> _data_new.' || _column_guia.column_name;

					IF _column_guia.data_type IN ('bytea','USER-DEFINED') THEN 
						_sql_update:= _sql_update
						||'::text';
					END IF;

					_sql_update:= _sql_update || '
				THEN _datos := _datos || json_build_object('''''
					|| _column_guia.column_name
					|| '_anterior'
					|| ''''', '
					|| '_data_old.'
					|| _column_guia.column_name;

					IF _column_guia.data_type IN ('bytea','USER-DEFINED') THEN 
						_sql_update:= _sql_update
						||'::text';
					END IF;

					_sql_update:= _sql_update
					|| ', '''''
					|| _column_guia.column_name
					|| '_nuevo'
					|| ''''', _data_new.'
					|| _column_guia.column_name;

					IF _column_guia.data_type IN ('bytea', 'USER-DEFINED') THEN 
						_sql_update:= _sql_update
						||'::text';
					END IF;

					_sql_update:= _sql_update
					|| ')::jsonb;
			END IF;
			';
			END LOOP;

			-- Se le agrega la parte final del procedured generico
			
			_sql:= _sql || _sql_insert || _sql_delete || _sql_update
			|| ' 
		END IF;

		INSERT INTO seguridad.auditoria
		(
			fecha,
			accion,
			schema,
			tabla,
			pk,
			session,
			user_bd,
			data
		)
		VALUES
		(
			CURRENT_TIMESTAMP,
			_accion,
			''''' || TG_TABLE_SCHEMA || ''''',
			''''' || TG_TABLE_NAME || ''''',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;'''
|| '
LANGUAGE plpgsql;';

			-- Se genera la ejecución de _sql, es decir se crea el nuevo procedured de forma generica.
			EXECUTE _sql;

		-- Se realiza la invocación del procedured generado dinamivamente
			PERFORM seguridad.field_audit(_new_data, _old_data, TG_OP::character varying, _session, _user_db, _pk, ''::text);

		END IF;

		RETURN NULL;

END;
$$;
 +   DROP FUNCTION seguridad.f_log_auditoria();
    	   seguridad          postgres    false    17            �            1259    17676    usuarios    TABLE     {  CREATE TABLE usuarios.usuarios (
    nombre_de_usuario text NOT NULL,
    fk_rol text NOT NULL,
    fk_estado text NOT NULL,
    primer_nombre text NOT NULL,
    segundo_nombre text,
    primer_apellido text NOT NULL,
    segundo_apellido text,
    correo_institucional text NOT NULL,
    pass text NOT NULL,
    fecha_desbloqueo timestamp without time zone,
    puntuacion integer,
    token text,
    imagen_perfil text,
    fecha_creacion date NOT NULL,
    ultima_modificacion timestamp without time zone,
    vencimiento_token timestamp without time zone,
    session text,
    descripcion text,
    puntuacion_bloqueo integer
);
    DROP TABLE usuarios.usuarios;
       usuarios         heap    postgres    false    14            �            1255    17682 i   field_audit(usuarios.usuarios, usuarios.usuarios, character varying, text, character varying, text, text)    FUNCTION     "  CREATE FUNCTION seguridad.field_audit(_data_new usuarios.usuarios, _data_old usuarios.usuarios, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		_column_data :=  _data_new.nombre_de_usuario;
		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('nombre_de_usuario_nuevo', _data_new.nombre_de_usuario)::jsonb;
				_datos := _datos || json_build_object('fk_rol_nuevo', _data_new.fk_rol)::jsonb;
				_datos := _datos || json_build_object('fk_estado_nuevo', _data_new.fk_estado)::jsonb;
				_datos := _datos || json_build_object('primer_nombre_nuevo', _data_new.primer_nombre)::jsonb;
				_datos := _datos || json_build_object('segundo_nombre_nuevo', _data_new.segundo_nombre)::jsonb;
				_datos := _datos || json_build_object('primer_apellido_nuevo', _data_new.primer_apellido)::jsonb;
				_datos := _datos || json_build_object('segundo_apellido_nuevo', _data_new.segundo_apellido)::jsonb;
				_datos := _datos || json_build_object('correo_institucional_nuevo', _data_new.correo_institucional)::jsonb;
				_datos := _datos || json_build_object('pass_nuevo', _data_new.pass)::jsonb;
				_datos := _datos || json_build_object('fecha_desbloqueo_nuevo', _data_new.fecha_desbloqueo)::jsonb;
				_datos := _datos || json_build_object('puntuacion_nuevo', _data_new.puntuacion)::jsonb;
				_datos := _datos || json_build_object('token_nuevo', _data_new.token)::jsonb;
				_datos := _datos || json_build_object('imagen_perfil_nuevo', _data_new.imagen_perfil)::jsonb;
				_datos := _datos || json_build_object('fecha_creacion_nuevo', _data_new.fecha_creacion)::jsonb;
				_datos := _datos || json_build_object('ultima_modificacion_nuevo', _data_new.ultima_modificacion)::jsonb;
				_datos := _datos || json_build_object('vencimiento_token_nuevo', _data_new.vencimiento_token)::jsonb;
				_datos := _datos || json_build_object('session_nuevo', _data_new.session)::jsonb;
				_datos := _datos || json_build_object('descripcion_nuevo', _data_new.descripcion)::jsonb;
				_datos := _datos || json_build_object('puntuacion_bloqueo_nuevo', _data_new.puntuacion_bloqueo)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('nombre_de_usuario_anterior', _data_old.nombre_de_usuario)::jsonb;
				_datos := _datos || json_build_object('fk_rol_anterior', _data_old.fk_rol)::jsonb;
				_datos := _datos || json_build_object('fk_estado_anterior', _data_old.fk_estado)::jsonb;
				_datos := _datos || json_build_object('primer_nombre_anterior', _data_old.primer_nombre)::jsonb;
				_datos := _datos || json_build_object('segundo_nombre_anterior', _data_old.segundo_nombre)::jsonb;
				_datos := _datos || json_build_object('primer_apellido_anterior', _data_old.primer_apellido)::jsonb;
				_datos := _datos || json_build_object('segundo_apellido_anterior', _data_old.segundo_apellido)::jsonb;
				_datos := _datos || json_build_object('correo_institucional_anterior', _data_old.correo_institucional)::jsonb;
				_datos := _datos || json_build_object('pass_anterior', _data_old.pass)::jsonb;
				_datos := _datos || json_build_object('fecha_desbloqueo_anterior', _data_old.fecha_desbloqueo)::jsonb;
				_datos := _datos || json_build_object('puntuacion_anterior', _data_old.puntuacion)::jsonb;
				_datos := _datos || json_build_object('token_anterior', _data_old.token)::jsonb;
				_datos := _datos || json_build_object('imagen_perfil_anterior', _data_old.imagen_perfil)::jsonb;
				_datos := _datos || json_build_object('fecha_creacion_anterior', _data_old.fecha_creacion)::jsonb;
				_datos := _datos || json_build_object('ultima_modificacion_anterior', _data_old.ultima_modificacion)::jsonb;
				_datos := _datos || json_build_object('vencimiento_token_anterior', _data_old.vencimiento_token)::jsonb;
				_datos := _datos || json_build_object('session_anterior', _data_old.session)::jsonb;
				_datos := _datos || json_build_object('descripcion_anterior', _data_old.descripcion)::jsonb;
				_datos := _datos || json_build_object('puntuacion_bloqueo_anterior', _data_old.puntuacion_bloqueo)::jsonb;
				
		ELSE
			IF _data_old.nombre_de_usuario <> _data_new.nombre_de_usuario
				THEN _datos := _datos || json_build_object('nombre_de_usuario_anterior', _data_old.nombre_de_usuario, 'nombre_de_usuario_nuevo', _data_new.nombre_de_usuario)::jsonb;
			END IF;
			IF _data_old.fk_rol <> _data_new.fk_rol
				THEN _datos := _datos || json_build_object('fk_rol_anterior', _data_old.fk_rol, 'fk_rol_nuevo', _data_new.fk_rol)::jsonb;
			END IF;
			IF _data_old.fk_estado <> _data_new.fk_estado
				THEN _datos := _datos || json_build_object('fk_estado_anterior', _data_old.fk_estado, 'fk_estado_nuevo', _data_new.fk_estado)::jsonb;
			END IF;
			IF _data_old.primer_nombre <> _data_new.primer_nombre
				THEN _datos := _datos || json_build_object('primer_nombre_anterior', _data_old.primer_nombre, 'primer_nombre_nuevo', _data_new.primer_nombre)::jsonb;
			END IF;
			IF _data_old.segundo_nombre <> _data_new.segundo_nombre
				THEN _datos := _datos || json_build_object('segundo_nombre_anterior', _data_old.segundo_nombre, 'segundo_nombre_nuevo', _data_new.segundo_nombre)::jsonb;
			END IF;
			IF _data_old.primer_apellido <> _data_new.primer_apellido
				THEN _datos := _datos || json_build_object('primer_apellido_anterior', _data_old.primer_apellido, 'primer_apellido_nuevo', _data_new.primer_apellido)::jsonb;
			END IF;
			IF _data_old.segundo_apellido <> _data_new.segundo_apellido
				THEN _datos := _datos || json_build_object('segundo_apellido_anterior', _data_old.segundo_apellido, 'segundo_apellido_nuevo', _data_new.segundo_apellido)::jsonb;
			END IF;
			IF _data_old.correo_institucional <> _data_new.correo_institucional
				THEN _datos := _datos || json_build_object('correo_institucional_anterior', _data_old.correo_institucional, 'correo_institucional_nuevo', _data_new.correo_institucional)::jsonb;
			END IF;
			IF _data_old.pass <> _data_new.pass
				THEN _datos := _datos || json_build_object('pass_anterior', _data_old.pass, 'pass_nuevo', _data_new.pass)::jsonb;
			END IF;
			IF _data_old.fecha_desbloqueo <> _data_new.fecha_desbloqueo
				THEN _datos := _datos || json_build_object('fecha_desbloqueo_anterior', _data_old.fecha_desbloqueo, 'fecha_desbloqueo_nuevo', _data_new.fecha_desbloqueo)::jsonb;
			END IF;
			IF _data_old.puntuacion <> _data_new.puntuacion
				THEN _datos := _datos || json_build_object('puntuacion_anterior', _data_old.puntuacion, 'puntuacion_nuevo', _data_new.puntuacion)::jsonb;
			END IF;
			IF _data_old.token <> _data_new.token
				THEN _datos := _datos || json_build_object('token_anterior', _data_old.token, 'token_nuevo', _data_new.token)::jsonb;
			END IF;
			IF _data_old.imagen_perfil <> _data_new.imagen_perfil
				THEN _datos := _datos || json_build_object('imagen_perfil_anterior', _data_old.imagen_perfil, 'imagen_perfil_nuevo', _data_new.imagen_perfil)::jsonb;
			END IF;
			IF _data_old.fecha_creacion <> _data_new.fecha_creacion
				THEN _datos := _datos || json_build_object('fecha_creacion_anterior', _data_old.fecha_creacion, 'fecha_creacion_nuevo', _data_new.fecha_creacion)::jsonb;
			END IF;
			IF _data_old.ultima_modificacion <> _data_new.ultima_modificacion
				THEN _datos := _datos || json_build_object('ultima_modificacion_anterior', _data_old.ultima_modificacion, 'ultima_modificacion_nuevo', _data_new.ultima_modificacion)::jsonb;
			END IF;
			IF _data_old.vencimiento_token <> _data_new.vencimiento_token
				THEN _datos := _datos || json_build_object('vencimiento_token_anterior', _data_old.vencimiento_token, 'vencimiento_token_nuevo', _data_new.vencimiento_token)::jsonb;
			END IF;
			IF _data_old.session <> _data_new.session
				THEN _datos := _datos || json_build_object('session_anterior', _data_old.session, 'session_nuevo', _data_new.session)::jsonb;
			END IF;
			IF _data_old.descripcion <> _data_new.descripcion
				THEN _datos := _datos || json_build_object('descripcion_anterior', _data_old.descripcion, 'descripcion_nuevo', _data_new.descripcion)::jsonb;
			END IF;
			IF _data_old.puntuacion_bloqueo <> _data_new.puntuacion_bloqueo
				THEN _datos := _datos || json_build_object('puntuacion_bloqueo_anterior', _data_old.puntuacion_bloqueo, 'puntuacion_bloqueo_nuevo', _data_new.puntuacion_bloqueo)::jsonb;
			END IF;
			 
		END IF;

		INSERT INTO seguridad.auditoria
		(
			fecha,
			accion,
			schema,
			tabla,
			pk,
			session,
			user_bd,
			data
		)
		VALUES
		(
			CURRENT_TIMESTAMP,
			_accion,
			'usuarios',
			'usuarios',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;
 �   DROP FUNCTION seguridad.field_audit(_data_new usuarios.usuarios, _data_old usuarios.usuarios, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text);
    	   seguridad          postgres    false    213    17    213            �            1259    17683    comentarios    TABLE       CREATE TABLE comentarios.comentarios (
    id integer NOT NULL,
    fk_nombre_de_usuario_emisor text NOT NULL,
    fk_id_curso integer,
    fk_id_tema integer,
    fk_id_comentario integer,
    comentario text NOT NULL,
    fecha_envio date NOT NULL,
    imagenes text[]
);
 $   DROP TABLE comentarios.comentarios;
       comentarios         heap    postgres    false    15            �            1259    17689    comentarios_id_seq    SEQUENCE     �   CREATE SEQUENCE comentarios.comentarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE comentarios.comentarios_id_seq;
       comentarios          postgres    false    15    214                       0    0    comentarios_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE comentarios.comentarios_id_seq OWNED BY comentarios.comentarios.id;
          comentarios          postgres    false    215            �            1259    17691    areas    TABLE     O   CREATE TABLE cursos.areas (
    area text NOT NULL,
    icono text NOT NULL
);
    DROP TABLE cursos.areas;
       cursos         heap    postgres    false    6            �            1259    17697    cursos    TABLE     D  CREATE TABLE cursos.cursos (
    id integer NOT NULL,
    fk_creador text NOT NULL,
    fk_area text NOT NULL,
    fk_estado text NOT NULL,
    nombre text NOT NULL,
    fecha_de_creacion date NOT NULL,
    fecha_de_inicio date NOT NULL,
    codigo_inscripcion text NOT NULL,
    puntuacion integer,
    descripcion text
);
    DROP TABLE cursos.cursos;
       cursos         heap    postgres    false    6            �            1259    17703    cursos_id_seq    SEQUENCE     �   CREATE SEQUENCE cursos.cursos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE cursos.cursos_id_seq;
       cursos          postgres    false    217    6                       0    0    cursos_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE cursos.cursos_id_seq OWNED BY cursos.cursos.id;
          cursos          postgres    false    218            �            1259    17705    estados_curso    TABLE     @   CREATE TABLE cursos.estados_curso (
    estado text NOT NULL
);
 !   DROP TABLE cursos.estados_curso;
       cursos         heap    postgres    false    6            �            1259    17711    inscripciones_cursos    TABLE     �   CREATE TABLE cursos.inscripciones_cursos (
    id integer NOT NULL,
    fk_nombre_de_usuario text NOT NULL,
    fk_id_curso integer NOT NULL,
    fecha_de_inscripcion date NOT NULL
);
 (   DROP TABLE cursos.inscripciones_cursos;
       cursos         heap    postgres    false    6            �            1259    17717    inscripciones_cursos_id_seq    SEQUENCE     �   CREATE SEQUENCE cursos.inscripciones_cursos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE cursos.inscripciones_cursos_id_seq;
       cursos          postgres    false    220    6                       0    0    inscripciones_cursos_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE cursos.inscripciones_cursos_id_seq OWNED BY cursos.inscripciones_cursos.id;
          cursos          postgres    false    221            �            1259    17719    ejecucion_examen    TABLE       CREATE TABLE examenes.ejecucion_examen (
    id integer NOT NULL,
    fk_nombre_de_usuario text NOT NULL,
    fk_id_examen integer NOT NULL,
    fecha_de_ejecucion timestamp with time zone NOT NULL,
    calificacion integer,
    respuestas text NOT NULL
);
 &   DROP TABLE examenes.ejecucion_examen;
       examenes         heap    postgres    false    8            �            1259    17725    ejecucion_examen_id_seq    SEQUENCE     �   CREATE SEQUENCE examenes.ejecucion_examen_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE examenes.ejecucion_examen_id_seq;
       examenes          postgres    false    222    8                       0    0    ejecucion_examen_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE examenes.ejecucion_examen_id_seq OWNED BY examenes.ejecucion_examen.id;
          examenes          postgres    false    223            �            1259    17727    examenes    TABLE     �   CREATE TABLE examenes.examenes (
    id integer NOT NULL,
    fk_id_tema integer,
    fecha_inicio date NOT NULL,
    fecha_fin date NOT NULL
);
    DROP TABLE examenes.examenes;
       examenes         heap    postgres    false    8            �            1259    17730    examenes_id_seq    SEQUENCE     �   CREATE SEQUENCE examenes.examenes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE examenes.examenes_id_seq;
       examenes          postgres    false    224    8                        0    0    examenes_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE examenes.examenes_id_seq OWNED BY examenes.examenes.id;
          examenes          postgres    false    225            �            1259    17732 	   preguntas    TABLE     �   CREATE TABLE examenes.preguntas (
    id integer NOT NULL,
    fk_id_examen integer NOT NULL,
    fk_tipo_pregunta text NOT NULL,
    pregunta text NOT NULL,
    porcentaje integer NOT NULL
);
    DROP TABLE examenes.preguntas;
       examenes         heap    postgres    false    8            �            1259    17738    preguntas_id_seq    SEQUENCE     �   CREATE SEQUENCE examenes.preguntas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE examenes.preguntas_id_seq;
       examenes          postgres    false    8    226            !           0    0    preguntas_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE examenes.preguntas_id_seq OWNED BY examenes.preguntas.id;
          examenes          postgres    false    227            �            1259    17740 
   respuestas    TABLE     �   CREATE TABLE examenes.respuestas (
    id integer NOT NULL,
    fk_id_preguntas integer NOT NULL,
    respuesta text NOT NULL,
    estado boolean NOT NULL
);
     DROP TABLE examenes.respuestas;
       examenes         heap    postgres    false    8            �            1259    17746    respuestas_id_seq    SEQUENCE     �   CREATE SEQUENCE examenes.respuestas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE examenes.respuestas_id_seq;
       examenes          postgres    false    228    8            "           0    0    respuestas_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE examenes.respuestas_id_seq OWNED BY examenes.respuestas.id;
          examenes          postgres    false    229            �            1259    17748    tipos_pregunta    TABLE     A   CREATE TABLE examenes.tipos_pregunta (
    tipo text NOT NULL
);
 $   DROP TABLE examenes.tipos_pregunta;
       examenes         heap    postgres    false    8            �            1259    17754    mensajes    TABLE       CREATE TABLE mensajes.mensajes (
    id integer NOT NULL,
    fk_nombre_de_usuario_emisor text NOT NULL,
    fk_nombre_de_usuario_receptor text NOT NULL,
    contenido text NOT NULL,
    imagenes text[],
    fecha timestamp without time zone NOT NULL,
    id_curso integer NOT NULL
);
    DROP TABLE mensajes.mensajes;
       mensajes         heap    postgres    false    7            �            1259    17760    mensajes_id_seq    SEQUENCE     �   CREATE SEQUENCE mensajes.mensajes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE mensajes.mensajes_id_seq;
       mensajes          postgres    false    231    7            #           0    0    mensajes_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE mensajes.mensajes_id_seq OWNED BY mensajes.mensajes.id;
          mensajes          postgres    false    232            �            1259    17762    notificaciones    TABLE     �   CREATE TABLE notificaciones.notificaciones (
    id integer NOT NULL,
    mensaje text NOT NULL,
    estado boolean NOT NULL,
    fk_nombre_de_usuario text NOT NULL
);
 *   DROP TABLE notificaciones.notificaciones;
       notificaciones         heap    postgres    false    11            �            1259    17768    notificaciones_id_seq    SEQUENCE     �   CREATE SEQUENCE notificaciones.notificaciones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE notificaciones.notificaciones_id_seq;
       notificaciones          postgres    false    233    11            $           0    0    notificaciones_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE notificaciones.notificaciones_id_seq OWNED BY notificaciones.notificaciones.id;
          notificaciones          postgres    false    234            �            1259    17770    puntuaciones    TABLE     �   CREATE TABLE puntuaciones.puntuaciones (
    id integer NOT NULL,
    emisor text NOT NULL,
    receptor text NOT NULL,
    puntuacion integer NOT NULL
);
 &   DROP TABLE puntuaciones.puntuaciones;
       puntuaciones         heap    postgres    false    18            �            1259    17776    puntuaciones_id_seq    SEQUENCE     �   CREATE SEQUENCE puntuaciones.puntuaciones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE puntuaciones.puntuaciones_id_seq;
       puntuaciones          postgres    false    18    235            %           0    0    puntuaciones_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE puntuaciones.puntuaciones_id_seq OWNED BY puntuaciones.puntuaciones.id;
          puntuaciones          postgres    false    236            �            1259    17778    motivos    TABLE     <   CREATE TABLE reportes.motivos (
    motivo text NOT NULL
);
    DROP TABLE reportes.motivos;
       reportes         heap    postgres    false    10            �            1259    17784    reportes    TABLE     \  CREATE TABLE reportes.reportes (
    id integer NOT NULL,
    fk_nombre_de_usuario_denunciante text NOT NULL,
    fk_nombre_de_usuario_denunciado text NOT NULL,
    fk_motivo text NOT NULL,
    descripcion text NOT NULL,
    estado boolean NOT NULL,
    fk_id_comentario integer,
    fk_id_mensaje integer,
    fecha timestamp without time zone
);
    DROP TABLE reportes.reportes;
       reportes         heap    postgres    false    10            �            1259    17790    reportes_id_seq    SEQUENCE     �   CREATE SEQUENCE reportes.reportes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE reportes.reportes_id_seq;
       reportes          postgres    false    10    238            &           0    0    reportes_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE reportes.reportes_id_seq OWNED BY reportes.reportes.id;
          reportes          postgres    false    239            �            1259    17792 	   auditoria    TABLE     L  CREATE TABLE seguridad.auditoria (
    id bigint NOT NULL,
    fecha timestamp without time zone NOT NULL,
    accion character varying(100),
    schema character varying(200) NOT NULL,
    tabla character varying(200),
    session text,
    user_bd character varying(100) NOT NULL,
    data jsonb NOT NULL,
    pk text NOT NULL
);
     DROP TABLE seguridad.auditoria;
    	   seguridad         heap    postgres    false    17            '           0    0    TABLE auditoria    COMMENT     b   COMMENT ON TABLE seguridad.auditoria IS 'Tabla que almacena la trazabilidad de la informaicón.';
       	   seguridad          postgres    false    240            (           0    0    COLUMN auditoria.id    COMMENT     E   COMMENT ON COLUMN seguridad.auditoria.id IS 'campo pk de la tabla ';
       	   seguridad          postgres    false    240            )           0    0    COLUMN auditoria.fecha    COMMENT     [   COMMENT ON COLUMN seguridad.auditoria.fecha IS 'ALmacen ala la fecha de la modificación';
       	   seguridad          postgres    false    240            *           0    0    COLUMN auditoria.accion    COMMENT     g   COMMENT ON COLUMN seguridad.auditoria.accion IS 'Almacena la accion que se ejecuto sobre el registro';
       	   seguridad          postgres    false    240            +           0    0    COLUMN auditoria.schema    COMMENT     n   COMMENT ON COLUMN seguridad.auditoria.schema IS 'Almanena el nomnbre del schema de la tabla que se modifico';
       	   seguridad          postgres    false    240            ,           0    0    COLUMN auditoria.tabla    COMMENT     a   COMMENT ON COLUMN seguridad.auditoria.tabla IS 'Almacena el nombre de la tabla que se modifico';
       	   seguridad          postgres    false    240            -           0    0    COLUMN auditoria.session    COMMENT     q   COMMENT ON COLUMN seguridad.auditoria.session IS 'Campo que almacena el id de la session que generó el cambio';
       	   seguridad          postgres    false    240            .           0    0    COLUMN auditoria.user_bd    COMMENT     �   COMMENT ON COLUMN seguridad.auditoria.user_bd IS 'Campo que almacena el user que se autentico en el motor para generar el cmabio';
       	   seguridad          postgres    false    240            /           0    0    COLUMN auditoria.data    COMMENT     e   COMMENT ON COLUMN seguridad.auditoria.data IS 'campo que almacena la modificaicón que se realizó';
       	   seguridad          postgres    false    240            0           0    0    COLUMN auditoria.pk    COMMENT     X   COMMENT ON COLUMN seguridad.auditoria.pk IS 'Campo que identifica el id del registro.';
       	   seguridad          postgres    false    240            �            1259    17798    auditoria_id_seq    SEQUENCE     |   CREATE SEQUENCE seguridad.auditoria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE seguridad.auditoria_id_seq;
    	   seguridad          postgres    false    240    17            1           0    0    auditoria_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE seguridad.auditoria_id_seq OWNED BY seguridad.auditoria.id;
       	   seguridad          postgres    false    241            �            1259    17800    autentication    TABLE     �   CREATE TABLE seguridad.autentication (
    id integer NOT NULL,
    nombre_de_usuario text NOT NULL,
    ip text,
    mac text,
    fecha_inicio timestamp without time zone,
    fecha_fin timestamp without time zone,
    session text
);
 $   DROP TABLE seguridad.autentication;
    	   seguridad         heap    postgres    false    17            �            1259    17806    autentication_id_seq    SEQUENCE     �   CREATE SEQUENCE seguridad.autentication_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE seguridad.autentication_id_seq;
    	   seguridad          postgres    false    17    242            2           0    0    autentication_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE seguridad.autentication_id_seq OWNED BY seguridad.autentication.id;
       	   seguridad          postgres    false    243            �            1259    17808    function_db_view    VIEW     �  CREATE VIEW seguridad.function_db_view AS
 SELECT pp.proname AS b_function,
    oidvectortypes(pp.proargtypes) AS b_type_parameters
   FROM (pg_proc pp
     JOIN pg_namespace pn ON ((pn.oid = pp.pronamespace)))
  WHERE ((pn.nspname)::text <> ALL (ARRAY[('pg_catalog'::character varying)::text, ('information_schema'::character varying)::text, ('admin_control'::character varying)::text, ('vial'::character varying)::text]));
 &   DROP VIEW seguridad.function_db_view;
    	   seguridad          postgres    false    17            �            1259    17813    sugerencias    TABLE     �   CREATE TABLE sugerencias.sugerencias (
    id integer NOT NULL,
    fk_nombre_de_usuario_emisor text,
    contenido text NOT NULL,
    estado boolean NOT NULL,
    imagenes text,
    titulo text NOT NULL,
    fecha timestamp without time zone NOT NULL
);
 $   DROP TABLE sugerencias.sugerencias;
       sugerencias         heap    postgres    false    9            �            1259    17819    sugerencias_id_seq    SEQUENCE     �   CREATE SEQUENCE sugerencias.sugerencias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE sugerencias.sugerencias_id_seq;
       sugerencias          postgres    false    9    245            3           0    0    sugerencias_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE sugerencias.sugerencias_id_seq OWNED BY sugerencias.sugerencias.id;
          sugerencias          postgres    false    246            �            1259    17821    temas    TABLE     �   CREATE TABLE temas.temas (
    id integer NOT NULL,
    fk_id_curso integer NOT NULL,
    titulo text NOT NULL,
    informacion text NOT NULL,
    imagenes text[]
);
    DROP TABLE temas.temas;
       temas         heap    postgres    false    12            �            1259    17827    temas_id_seq    SEQUENCE     �   CREATE SEQUENCE temas.temas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE temas.temas_id_seq;
       temas          postgres    false    247    12            4           0    0    temas_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE temas.temas_id_seq OWNED BY temas.temas.id;
          temas          postgres    false    248            �            1259    17829    estados_usuario    TABLE     D   CREATE TABLE usuarios.estados_usuario (
    estado text NOT NULL
);
 %   DROP TABLE usuarios.estados_usuario;
       usuarios         heap    postgres    false    14            �            1259    17835    roles    TABLE     7   CREATE TABLE usuarios.roles (
    rol text NOT NULL
);
    DROP TABLE usuarios.roles;
       usuarios         heap    postgres    false    14                       2604    17841    comentarios id    DEFAULT     z   ALTER TABLE ONLY comentarios.comentarios ALTER COLUMN id SET DEFAULT nextval('comentarios.comentarios_id_seq'::regclass);
 B   ALTER TABLE comentarios.comentarios ALTER COLUMN id DROP DEFAULT;
       comentarios          postgres    false    215    214                       2604    17842 	   cursos id    DEFAULT     f   ALTER TABLE ONLY cursos.cursos ALTER COLUMN id SET DEFAULT nextval('cursos.cursos_id_seq'::regclass);
 8   ALTER TABLE cursos.cursos ALTER COLUMN id DROP DEFAULT;
       cursos          postgres    false    218    217                       2604    17843    inscripciones_cursos id    DEFAULT     �   ALTER TABLE ONLY cursos.inscripciones_cursos ALTER COLUMN id SET DEFAULT nextval('cursos.inscripciones_cursos_id_seq'::regclass);
 F   ALTER TABLE cursos.inscripciones_cursos ALTER COLUMN id DROP DEFAULT;
       cursos          postgres    false    221    220                       2604    17844    ejecucion_examen id    DEFAULT     ~   ALTER TABLE ONLY examenes.ejecucion_examen ALTER COLUMN id SET DEFAULT nextval('examenes.ejecucion_examen_id_seq'::regclass);
 D   ALTER TABLE examenes.ejecucion_examen ALTER COLUMN id DROP DEFAULT;
       examenes          postgres    false    223    222                       2604    17845    examenes id    DEFAULT     n   ALTER TABLE ONLY examenes.examenes ALTER COLUMN id SET DEFAULT nextval('examenes.examenes_id_seq'::regclass);
 <   ALTER TABLE examenes.examenes ALTER COLUMN id DROP DEFAULT;
       examenes          postgres    false    225    224                       2604    17846    preguntas id    DEFAULT     p   ALTER TABLE ONLY examenes.preguntas ALTER COLUMN id SET DEFAULT nextval('examenes.preguntas_id_seq'::regclass);
 =   ALTER TABLE examenes.preguntas ALTER COLUMN id DROP DEFAULT;
       examenes          postgres    false    227    226                       2604    17847    respuestas id    DEFAULT     r   ALTER TABLE ONLY examenes.respuestas ALTER COLUMN id SET DEFAULT nextval('examenes.respuestas_id_seq'::regclass);
 >   ALTER TABLE examenes.respuestas ALTER COLUMN id DROP DEFAULT;
       examenes          postgres    false    229    228                       2604    17848    mensajes id    DEFAULT     n   ALTER TABLE ONLY mensajes.mensajes ALTER COLUMN id SET DEFAULT nextval('mensajes.mensajes_id_seq'::regclass);
 <   ALTER TABLE mensajes.mensajes ALTER COLUMN id DROP DEFAULT;
       mensajes          postgres    false    232    231                       2604    17849    notificaciones id    DEFAULT     �   ALTER TABLE ONLY notificaciones.notificaciones ALTER COLUMN id SET DEFAULT nextval('notificaciones.notificaciones_id_seq'::regclass);
 H   ALTER TABLE notificaciones.notificaciones ALTER COLUMN id DROP DEFAULT;
       notificaciones          postgres    false    234    233                       2604    17850    puntuaciones id    DEFAULT     ~   ALTER TABLE ONLY puntuaciones.puntuaciones ALTER COLUMN id SET DEFAULT nextval('puntuaciones.puntuaciones_id_seq'::regclass);
 D   ALTER TABLE puntuaciones.puntuaciones ALTER COLUMN id DROP DEFAULT;
       puntuaciones          postgres    false    236    235                       2604    17851    reportes id    DEFAULT     n   ALTER TABLE ONLY reportes.reportes ALTER COLUMN id SET DEFAULT nextval('reportes.reportes_id_seq'::regclass);
 <   ALTER TABLE reportes.reportes ALTER COLUMN id DROP DEFAULT;
       reportes          postgres    false    239    238                        2604    17852    auditoria id    DEFAULT     r   ALTER TABLE ONLY seguridad.auditoria ALTER COLUMN id SET DEFAULT nextval('seguridad.auditoria_id_seq'::regclass);
 >   ALTER TABLE seguridad.auditoria ALTER COLUMN id DROP DEFAULT;
    	   seguridad          postgres    false    241    240            !           2604    17853    autentication id    DEFAULT     z   ALTER TABLE ONLY seguridad.autentication ALTER COLUMN id SET DEFAULT nextval('seguridad.autentication_id_seq'::regclass);
 B   ALTER TABLE seguridad.autentication ALTER COLUMN id DROP DEFAULT;
    	   seguridad          postgres    false    243    242            "           2604    17854    sugerencias id    DEFAULT     z   ALTER TABLE ONLY sugerencias.sugerencias ALTER COLUMN id SET DEFAULT nextval('sugerencias.sugerencias_id_seq'::regclass);
 B   ALTER TABLE sugerencias.sugerencias ALTER COLUMN id DROP DEFAULT;
       sugerencias          postgres    false    246    245            #           2604    17855    temas id    DEFAULT     b   ALTER TABLE ONLY temas.temas ALTER COLUMN id SET DEFAULT nextval('temas.temas_id_seq'::regclass);
 6   ALTER TABLE temas.temas ALTER COLUMN id DROP DEFAULT;
       temas          postgres    false    248    247            �          0    17683    comentarios 
   TABLE DATA           �   COPY comentarios.comentarios (id, fk_nombre_de_usuario_emisor, fk_id_curso, fk_id_tema, fk_id_comentario, comentario, fecha_envio, imagenes) FROM stdin;
    comentarios          postgres    false    214   �!      �          0    17691    areas 
   TABLE DATA           ,   COPY cursos.areas (area, icono) FROM stdin;
    cursos          postgres    false    216   H"      �          0    17697    cursos 
   TABLE DATA           �   COPY cursos.cursos (id, fk_creador, fk_area, fk_estado, nombre, fecha_de_creacion, fecha_de_inicio, codigo_inscripcion, puntuacion, descripcion) FROM stdin;
    cursos          postgres    false    217   �"      �          0    17705    estados_curso 
   TABLE DATA           /   COPY cursos.estados_curso (estado) FROM stdin;
    cursos          postgres    false    219   �#      �          0    17711    inscripciones_cursos 
   TABLE DATA           k   COPY cursos.inscripciones_cursos (id, fk_nombre_de_usuario, fk_id_curso, fecha_de_inscripcion) FROM stdin;
    cursos          postgres    false    220   �#      �          0    17719    ejecucion_examen 
   TABLE DATA           �   COPY examenes.ejecucion_examen (id, fk_nombre_de_usuario, fk_id_examen, fecha_de_ejecucion, calificacion, respuestas) FROM stdin;
    examenes          postgres    false    222   $      �          0    17727    examenes 
   TABLE DATA           M   COPY examenes.examenes (id, fk_id_tema, fecha_inicio, fecha_fin) FROM stdin;
    examenes          postgres    false    224   �$      �          0    17732 	   preguntas 
   TABLE DATA           _   COPY examenes.preguntas (id, fk_id_examen, fk_tipo_pregunta, pregunta, porcentaje) FROM stdin;
    examenes          postgres    false    226   %                 0    17740 
   respuestas 
   TABLE DATA           N   COPY examenes.respuestas (id, fk_id_preguntas, respuesta, estado) FROM stdin;
    examenes          postgres    false    228   �%                0    17748    tipos_pregunta 
   TABLE DATA           0   COPY examenes.tipos_pregunta (tipo) FROM stdin;
    examenes          postgres    false    230   B&                0    17754    mensajes 
   TABLE DATA           �   COPY mensajes.mensajes (id, fk_nombre_de_usuario_emisor, fk_nombre_de_usuario_receptor, contenido, imagenes, fecha, id_curso) FROM stdin;
    mensajes          postgres    false    231   �&                0    17762    notificaciones 
   TABLE DATA           [   COPY notificaciones.notificaciones (id, mensaje, estado, fk_nombre_de_usuario) FROM stdin;
    notificaciones          postgres    false    233   '                0    17770    puntuaciones 
   TABLE DATA           N   COPY puntuaciones.puntuaciones (id, emisor, receptor, puntuacion) FROM stdin;
    puntuaciones          postgres    false    235   3'      	          0    17778    motivos 
   TABLE DATA           +   COPY reportes.motivos (motivo) FROM stdin;
    reportes          postgres    false    237   t'      
          0    17784    reportes 
   TABLE DATA           �   COPY reportes.reportes (id, fk_nombre_de_usuario_denunciante, fk_nombre_de_usuario_denunciado, fk_motivo, descripcion, estado, fk_id_comentario, fk_id_mensaje, fecha) FROM stdin;
    reportes          postgres    false    238   �'                0    17792 	   auditoria 
   TABLE DATA           d   COPY seguridad.auditoria (id, fecha, accion, schema, tabla, session, user_bd, data, pk) FROM stdin;
 	   seguridad          postgres    false    240   �(                0    17800    autentication 
   TABLE DATA           l   COPY seguridad.autentication (id, nombre_de_usuario, ip, mac, fecha_inicio, fecha_fin, session) FROM stdin;
 	   seguridad          postgres    false    242   �=                0    17813    sugerencias 
   TABLE DATA           w   COPY sugerencias.sugerencias (id, fk_nombre_de_usuario_emisor, contenido, estado, imagenes, titulo, fecha) FROM stdin;
    sugerencias          postgres    false    245   `N                0    17821    temas 
   TABLE DATA           N   COPY temas.temas (id, fk_id_curso, titulo, informacion, imagenes) FROM stdin;
    temas          postgres    false    247   P                0    17829    estados_usuario 
   TABLE DATA           3   COPY usuarios.estados_usuario (estado) FROM stdin;
    usuarios          postgres    false    249   �Q                0    17835    roles 
   TABLE DATA           &   COPY usuarios.roles (rol) FROM stdin;
    usuarios          postgres    false    250   �Q      �          0    17676    usuarios 
   TABLE DATA           >  COPY usuarios.usuarios (nombre_de_usuario, fk_rol, fk_estado, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, correo_institucional, pass, fecha_desbloqueo, puntuacion, token, imagen_perfil, fecha_creacion, ultima_modificacion, vencimiento_token, session, descripcion, puntuacion_bloqueo) FROM stdin;
    usuarios          postgres    false    213   R      5           0    0    comentarios_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('comentarios.comentarios_id_seq', 2, true);
          comentarios          postgres    false    215            6           0    0    cursos_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('cursos.cursos_id_seq', 8, true);
          cursos          postgres    false    218            7           0    0    inscripciones_cursos_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('cursos.inscripciones_cursos_id_seq', 2, true);
          cursos          postgres    false    221            8           0    0    ejecucion_examen_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('examenes.ejecucion_examen_id_seq', 4, true);
          examenes          postgres    false    223            9           0    0    examenes_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('examenes.examenes_id_seq', 1, false);
          examenes          postgres    false    225            :           0    0    preguntas_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('examenes.preguntas_id_seq', 29, true);
          examenes          postgres    false    227            ;           0    0    respuestas_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('examenes.respuestas_id_seq', 30, true);
          examenes          postgres    false    229            <           0    0    mensajes_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('mensajes.mensajes_id_seq', 2, true);
          mensajes          postgres    false    232            =           0    0    notificaciones_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('notificaciones.notificaciones_id_seq', 1, false);
          notificaciones          postgres    false    234            >           0    0    puntuaciones_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('puntuaciones.puntuaciones_id_seq', 8, true);
          puntuaciones          postgres    false    236            ?           0    0    reportes_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('reportes.reportes_id_seq', 5, true);
          reportes          postgres    false    239            @           0    0    auditoria_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('seguridad.auditoria_id_seq', 126, true);
       	   seguridad          postgres    false    241            A           0    0    autentication_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('seguridad.autentication_id_seq', 154, true);
       	   seguridad          postgres    false    243            B           0    0    sugerencias_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('sugerencias.sugerencias_id_seq', 32, true);
          sugerencias          postgres    false    246            C           0    0    temas_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('temas.temas_id_seq', 3, true);
          temas          postgres    false    248            )           2606    17857    comentarios comentarios_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT comentarios_pkey PRIMARY KEY (id);
 K   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT comentarios_pkey;
       comentarios            postgres    false    214            +           2606    17859    areas areas_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY cursos.areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (area);
 :   ALTER TABLE ONLY cursos.areas DROP CONSTRAINT areas_pkey;
       cursos            postgres    false    216            -           2606    17861    cursos cursos_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT cursos_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT cursos_pkey;
       cursos            postgres    false    217            /           2606    17863    estados_curso estado_curso_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY cursos.estados_curso
    ADD CONSTRAINT estado_curso_pkey PRIMARY KEY (estado);
 I   ALTER TABLE ONLY cursos.estados_curso DROP CONSTRAINT estado_curso_pkey;
       cursos            postgres    false    219            1           2606    17865 .   inscripciones_cursos inscripciones_cursos_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY cursos.inscripciones_cursos
    ADD CONSTRAINT inscripciones_cursos_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY cursos.inscripciones_cursos DROP CONSTRAINT inscripciones_cursos_pkey;
       cursos            postgres    false    220            3           2606    17867 &   ejecucion_examen ejecucion_examen_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY examenes.ejecucion_examen
    ADD CONSTRAINT ejecucion_examen_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY examenes.ejecucion_examen DROP CONSTRAINT ejecucion_examen_pkey;
       examenes            postgres    false    222            5           2606    17869    examenes examenes_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY examenes.examenes
    ADD CONSTRAINT examenes_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY examenes.examenes DROP CONSTRAINT examenes_pkey;
       examenes            postgres    false    224            7           2606    17871    preguntas preguntas_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY examenes.preguntas
    ADD CONSTRAINT preguntas_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY examenes.preguntas DROP CONSTRAINT preguntas_pkey;
       examenes            postgres    false    226            9           2606    17873    respuestas respuestas_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY examenes.respuestas
    ADD CONSTRAINT respuestas_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY examenes.respuestas DROP CONSTRAINT respuestas_pkey;
       examenes            postgres    false    228            ;           2606    17875 "   tipos_pregunta tipos_pregunta_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY examenes.tipos_pregunta
    ADD CONSTRAINT tipos_pregunta_pkey PRIMARY KEY (tipo);
 N   ALTER TABLE ONLY examenes.tipos_pregunta DROP CONSTRAINT tipos_pregunta_pkey;
       examenes            postgres    false    230            =           2606    17877    mensajes mensajes_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY mensajes.mensajes
    ADD CONSTRAINT mensajes_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY mensajes.mensajes DROP CONSTRAINT mensajes_pkey;
       mensajes            postgres    false    231            ?           2606    17879 "   notificaciones notificaciones_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY notificaciones.notificaciones
    ADD CONSTRAINT notificaciones_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY notificaciones.notificaciones DROP CONSTRAINT notificaciones_pkey;
       notificaciones            postgres    false    233            A           2606    17881    puntuaciones puntuaciones_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY puntuaciones.puntuaciones
    ADD CONSTRAINT puntuaciones_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY puntuaciones.puntuaciones DROP CONSTRAINT puntuaciones_pkey;
       puntuaciones            postgres    false    235            C           2606    17883    motivos motivos_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY reportes.motivos
    ADD CONSTRAINT motivos_pkey PRIMARY KEY (motivo);
 @   ALTER TABLE ONLY reportes.motivos DROP CONSTRAINT motivos_pkey;
       reportes            postgres    false    237            E           2606    17885    reportes reportes_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT reportes_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT reportes_pkey;
       reportes            postgres    false    238            I           2606    17887     autentication autentication_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY seguridad.autentication
    ADD CONSTRAINT autentication_pkey PRIMARY KEY (id);
 M   ALTER TABLE ONLY seguridad.autentication DROP CONSTRAINT autentication_pkey;
    	   seguridad            postgres    false    242            G           2606    17889     auditoria pk_seguridad_auditoria 
   CONSTRAINT     a   ALTER TABLE ONLY seguridad.auditoria
    ADD CONSTRAINT pk_seguridad_auditoria PRIMARY KEY (id);
 M   ALTER TABLE ONLY seguridad.auditoria DROP CONSTRAINT pk_seguridad_auditoria;
    	   seguridad            postgres    false    240            K           2606    17891    sugerencias sugerencias_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY sugerencias.sugerencias
    ADD CONSTRAINT sugerencias_pkey PRIMARY KEY (id);
 K   ALTER TABLE ONLY sugerencias.sugerencias DROP CONSTRAINT sugerencias_pkey;
       sugerencias            postgres    false    245            M           2606    17893    temas temas_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY temas.temas
    ADD CONSTRAINT temas_pkey PRIMARY KEY (id);
 9   ALTER TABLE ONLY temas.temas DROP CONSTRAINT temas_pkey;
       temas            postgres    false    247            O           2606    17895 $   estados_usuario estados_usuario_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY usuarios.estados_usuario
    ADD CONSTRAINT estados_usuario_pkey PRIMARY KEY (estado);
 P   ALTER TABLE ONLY usuarios.estados_usuario DROP CONSTRAINT estados_usuario_pkey;
       usuarios            postgres    false    249            Q           2606    17897    roles roles_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY usuarios.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (rol);
 <   ALTER TABLE ONLY usuarios.roles DROP CONSTRAINT roles_pkey;
       usuarios            postgres    false    250            %           2606    17899 $   usuarios unique_correo_institucional 
   CONSTRAINT     q   ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT unique_correo_institucional UNIQUE (correo_institucional);
 P   ALTER TABLE ONLY usuarios.usuarios DROP CONSTRAINT unique_correo_institucional;
       usuarios            postgres    false    213            '           2606    17901    usuarios usuarios_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (nombre_de_usuario);
 B   ALTER TABLE ONLY usuarios.usuarios DROP CONSTRAINT usuarios_pkey;
       usuarios            postgres    false    213            q           2620    17902    usuarios tg_usuarios_usuarios    TRIGGER     �   CREATE TRIGGER tg_usuarios_usuarios AFTER INSERT OR DELETE OR UPDATE ON usuarios.usuarios FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 8   DROP TRIGGER tg_usuarios_usuarios ON usuarios.usuarios;
       usuarios          postgres    false    251    213            T           2606    17903    comentarios fkcomentario107416    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario107416 FOREIGN KEY (fk_nombre_de_usuario_emisor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario107416;
       comentarios          postgres    false    213    2855    214            U           2606    17908    comentarios fkcomentario298131    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario298131 FOREIGN KEY (fk_id_tema) REFERENCES temas.temas(id);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario298131;
       comentarios          postgres    false    214    2893    247            V           2606    17913    comentarios fkcomentario605734    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario605734 FOREIGN KEY (fk_id_curso) REFERENCES cursos.cursos(id);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario605734;
       comentarios          postgres    false    217    2861    214            W           2606    17918    comentarios fkcomentario954929    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario954929 FOREIGN KEY (fk_id_comentario) REFERENCES comentarios.comentarios(id);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario954929;
       comentarios          postgres    false    2857    214    214            X           2606    17923    cursos fkcursos287281    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT fkcursos287281 FOREIGN KEY (fk_estado) REFERENCES cursos.estados_curso(estado);
 ?   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT fkcursos287281;
       cursos          postgres    false    217    2863    219            Y           2606    17928    cursos fkcursos395447    FK CONSTRAINT     v   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT fkcursos395447 FOREIGN KEY (fk_area) REFERENCES cursos.areas(area);
 ?   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT fkcursos395447;
       cursos          postgres    false    217    216    2859            Z           2606    17933    cursos fkcursos742472    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT fkcursos742472 FOREIGN KEY (fk_creador) REFERENCES usuarios.usuarios(nombre_de_usuario);
 ?   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT fkcursos742472;
       cursos          postgres    false    2855    213    217            [           2606    17938 &   inscripciones_cursos fkinscripcio18320    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.inscripciones_cursos
    ADD CONSTRAINT fkinscripcio18320 FOREIGN KEY (fk_id_curso) REFERENCES cursos.cursos(id);
 P   ALTER TABLE ONLY cursos.inscripciones_cursos DROP CONSTRAINT fkinscripcio18320;
       cursos          postgres    false    220    217    2861            \           2606    17943 '   inscripciones_cursos fkinscripcio893145    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.inscripciones_cursos
    ADD CONSTRAINT fkinscripcio893145 FOREIGN KEY (fk_nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 Q   ALTER TABLE ONLY cursos.inscripciones_cursos DROP CONSTRAINT fkinscripcio893145;
       cursos          postgres    false    220    213    2855            ]           2606    17948 #   ejecucion_examen fkejecucion_455924    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.ejecucion_examen
    ADD CONSTRAINT fkejecucion_455924 FOREIGN KEY (fk_nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 O   ALTER TABLE ONLY examenes.ejecucion_examen DROP CONSTRAINT fkejecucion_455924;
       examenes          postgres    false    222    213    2855            ^           2606    17953 #   ejecucion_examen fkejecucion_678612    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.ejecucion_examen
    ADD CONSTRAINT fkejecucion_678612 FOREIGN KEY (fk_id_examen) REFERENCES examenes.examenes(id);
 O   ALTER TABLE ONLY examenes.ejecucion_examen DROP CONSTRAINT fkejecucion_678612;
       examenes          postgres    false    222    224    2869            _           2606    17958    examenes fkexamenes946263    FK CONSTRAINT     |   ALTER TABLE ONLY examenes.examenes
    ADD CONSTRAINT fkexamenes946263 FOREIGN KEY (fk_id_tema) REFERENCES temas.temas(id);
 E   ALTER TABLE ONLY examenes.examenes DROP CONSTRAINT fkexamenes946263;
       examenes          postgres    false    224    247    2893            `           2606    17963    preguntas fkpreguntas592721    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.preguntas
    ADD CONSTRAINT fkpreguntas592721 FOREIGN KEY (fk_id_examen) REFERENCES examenes.examenes(id);
 G   ALTER TABLE ONLY examenes.preguntas DROP CONSTRAINT fkpreguntas592721;
       examenes          postgres    false    226    224    2869            a           2606    17968    preguntas fkpreguntas985578    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.preguntas
    ADD CONSTRAINT fkpreguntas985578 FOREIGN KEY (fk_tipo_pregunta) REFERENCES examenes.tipos_pregunta(tipo);
 G   ALTER TABLE ONLY examenes.preguntas DROP CONSTRAINT fkpreguntas985578;
       examenes          postgres    false    226    230    2875            b           2606    17973    respuestas fkrespuestas516290    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.respuestas
    ADD CONSTRAINT fkrespuestas516290 FOREIGN KEY (fk_id_preguntas) REFERENCES examenes.preguntas(id);
 I   ALTER TABLE ONLY examenes.respuestas DROP CONSTRAINT fkrespuestas516290;
       examenes          postgres    false    228    2871    226            c           2606    17978    mensajes fkmensajes16841    FK CONSTRAINT     �   ALTER TABLE ONLY mensajes.mensajes
    ADD CONSTRAINT fkmensajes16841 FOREIGN KEY (fk_nombre_de_usuario_receptor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 D   ALTER TABLE ONLY mensajes.mensajes DROP CONSTRAINT fkmensajes16841;
       mensajes          postgres    false    2855    213    231            d           2606    17983    mensajes fkmensajes33437    FK CONSTRAINT     �   ALTER TABLE ONLY mensajes.mensajes
    ADD CONSTRAINT fkmensajes33437 FOREIGN KEY (fk_nombre_de_usuario_emisor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 D   ALTER TABLE ONLY mensajes.mensajes DROP CONSTRAINT fkmensajes33437;
       mensajes          postgres    false    231    213    2855            e           2606    18053    mensajes mensajes_id_curso_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY mensajes.mensajes
    ADD CONSTRAINT mensajes_id_curso_fkey FOREIGN KEY (id_curso) REFERENCES cursos.cursos(id);
 K   ALTER TABLE ONLY mensajes.mensajes DROP CONSTRAINT mensajes_id_curso_fkey;
       mensajes          postgres    false    2861    231    217            f           2606    17988 !   notificaciones fknotificaci697604    FK CONSTRAINT     �   ALTER TABLE ONLY notificaciones.notificaciones
    ADD CONSTRAINT fknotificaci697604 FOREIGN KEY (fk_nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 S   ALTER TABLE ONLY notificaciones.notificaciones DROP CONSTRAINT fknotificaci697604;
       notificaciones          postgres    false    2855    233    213            g           2606    17993 %   puntuaciones puntuaciones_emisor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY puntuaciones.puntuaciones
    ADD CONSTRAINT puntuaciones_emisor_fkey FOREIGN KEY (emisor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 U   ALTER TABLE ONLY puntuaciones.puntuaciones DROP CONSTRAINT puntuaciones_emisor_fkey;
       puntuaciones          postgres    false    235    213    2855            h           2606    17998 '   puntuaciones puntuaciones_receptor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY puntuaciones.puntuaciones
    ADD CONSTRAINT puntuaciones_receptor_fkey FOREIGN KEY (receptor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 W   ALTER TABLE ONLY puntuaciones.puntuaciones DROP CONSTRAINT puntuaciones_receptor_fkey;
       puntuaciones          postgres    false    2855    235    213            i           2606    18003    reportes fkreportes338700    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT fkreportes338700 FOREIGN KEY (fk_motivo) REFERENCES reportes.motivos(motivo);
 E   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT fkreportes338700;
       reportes          postgres    false    237    238    2883            j           2606    18008    reportes fkreportes50539    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT fkreportes50539 FOREIGN KEY (fk_nombre_de_usuario_denunciado) REFERENCES usuarios.usuarios(nombre_de_usuario);
 D   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT fkreportes50539;
       reportes          postgres    false    213    238    2855            k           2606    18013    reportes fkreportes843275    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT fkreportes843275 FOREIGN KEY (fk_nombre_de_usuario_denunciante) REFERENCES usuarios.usuarios(nombre_de_usuario);
 E   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT fkreportes843275;
       reportes          postgres    false    238    2855    213            l           2606    18018 '   reportes reportes_fk_id_comentario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT reportes_fk_id_comentario_fkey FOREIGN KEY (fk_id_comentario) REFERENCES comentarios.comentarios(id);
 S   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT reportes_fk_id_comentario_fkey;
       reportes          postgres    false    2857    214    238            m           2606    18023 $   reportes reportes_fk_id_mensaje_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT reportes_fk_id_mensaje_fkey FOREIGN KEY (fk_id_mensaje) REFERENCES mensajes.mensajes(id);
 P   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT reportes_fk_id_mensaje_fkey;
       reportes          postgres    false    231    2877    238            n           2606    18028 '   autentication fk_autentication_usuarios    FK CONSTRAINT     �   ALTER TABLE ONLY seguridad.autentication
    ADD CONSTRAINT fk_autentication_usuarios FOREIGN KEY (nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 T   ALTER TABLE ONLY seguridad.autentication DROP CONSTRAINT fk_autentication_usuarios;
    	   seguridad          postgres    false    213    242    2855            o           2606    18033    sugerencias fksugerencia433827    FK CONSTRAINT     �   ALTER TABLE ONLY sugerencias.sugerencias
    ADD CONSTRAINT fksugerencia433827 FOREIGN KEY (fk_nombre_de_usuario_emisor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 M   ALTER TABLE ONLY sugerencias.sugerencias DROP CONSTRAINT fksugerencia433827;
       sugerencias          postgres    false    245    213    2855            p           2606    18038    temas fktemas249223    FK CONSTRAINT     v   ALTER TABLE ONLY temas.temas
    ADD CONSTRAINT fktemas249223 FOREIGN KEY (fk_id_curso) REFERENCES cursos.cursos(id);
 <   ALTER TABLE ONLY temas.temas DROP CONSTRAINT fktemas249223;
       temas          postgres    false    2861    247    217            R           2606    18043    usuarios fkusuarios355026    FK CONSTRAINT     |   ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT fkusuarios355026 FOREIGN KEY (fk_rol) REFERENCES usuarios.roles(rol);
 E   ALTER TABLE ONLY usuarios.usuarios DROP CONSTRAINT fkusuarios355026;
       usuarios          postgres    false    250    2897    213            S           2606    18048    usuarios fkusuarios94770    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT fkusuarios94770 FOREIGN KEY (fk_estado) REFERENCES usuarios.estados_usuario(estado);
 D   ALTER TABLE ONLY usuarios.usuarios DROP CONSTRAINT fkusuarios94770;
       usuarios          postgres    false    213    249    2895            �   9   x�3�t+J�K�4�4������ITH���WH-.I,�4202�50�54�r��qqq UY]      �   k   x�s�L�K�L,Vp:��839���N?(5���8�X�371=5/�H���/v,JM,�wFסW����T��Ztxm"A��B��d��a3TX�IQ>a`U`�1z\\\ ?�X�      �   �   x�u�K
�0�����@el�p�(�� �nB�b�#�I�����Zt%��_�$9ucacMWXMr=���@�>�-y�[1���ΙD�BU���,�ӞCi]��Wgh|3Ɣq�s&�U�B�x5��ݗ�\xOc�A�*é"����%�v����?8i���Гc��3Pq�sVu
��4$�n:,K#5���N�B�DVf      �      x�KL.�,������ �9      �   :   x�3�t+J�K�4�4202�50�56�2�
BM��˘�73�45�����Y"F��� 8��      �   �   x�����0���)jg �D6�$F݀�
��R���b���,�Ht��.���hc�.C�͸����Gn��	Ɨ��|�%(}�#4��Ȫם�ݎ��Q��&㠡�ȶ�e;,���F)e4Z$���屨;ś��g�f�J�@)�,s���%������c]IE�Rt��ĝkSM�g���kW      �       x�3�4�4204�50�521M L�=... R      �   �   x�e�;�0Dk�{)�T���@)hh֎%,m���C�� ዱ�@ �ռ7��R�šL��H�wP&g5B0q�&&��1�;���٬���s}{m.7b/2A>2I�s��Bכ���`Pk���wʚ����RE6�t���)��A_�Ջ.+�;dU�s.��X9Ϥ�/HCT�          t   x�32�42���KO��L-:�6Q!%U!8?��<�(�����$�X��{xaIfrb1gP�)��J�؀�Ȝ3,�(%$k�9�&e���̰ T��8� NP~V������ n/%         M   x��=�+�$� 'U!9?O����D�������D._�\8��1)3�H��d&g���($%gd��s��qqq ��%q         g   x�3�t+J�K���L/M�150��/)JT(K�R(-.IMQ�Kp��q���*X��)��V�Q%�
�@:_!��$Q!-�$39_!+q���� Z%&S            x������ � �         1   x�3�t+J�K��N���4���M,.I-���L/M�150�4����� ��
�      	   H   x�s/�/N-�L,��OK�+N,VH�Q(-.M,���
p��r��+I��L�W�6� �JI-Rp/*-������ !@�      
   �   x�e�1�0Eg��QQ�T�"�	q��u!��%I8=i��
�˃e�������m�����y�0nT	�4G���k �r����ZР@K-�
ePɃ#̂�3T�#g#p
���%�q�#��}��`|�\��A��l��.�x�
C�Ў��MXs}w�'��cif�u+����M�            x��[sǕǟ�O���z���<�c;Z��-���T�T}UhS��N�[��}�J 8�0�@A�+21�����ӧ/����)؉�	�N��O���/�������OO/f7��7O^_�._N��������ً���������y��K�s����ӓˋ���͇��ut.V���	�EH���%xVF;��JѲ����ak���bzq�t��S��fy6;���������7��ҧ��_ʳ�y꟦�����_|���Zx}u~y5��~#����ڕ�k��������<}q~�*L��]�i~y�t��9�ݿ��|�퓛o��/��w�Ҏ�^^M�=������N�;��O���N)����?��E�Q��c���/�N��m\�?��_n�K?��~�����i>��x�{�7�z�0�tB�����e�._��H��4�����tZ���|vyzyծ�g�G����U���O��O��r������>�>�[�v�*n�Έ3J?���?~���a��痹~6�K�˟�P߷n�*�WT�������m��~~[�˷�S��m��w�~�������+�_nh��t�X�ρf���k-a�Y�5�C}��jk�����0�u������}���X�{-J(*cp:{(�Ig�|֮���I��E�*M�:
f�����=��j�=�{'�(��3��~�ʗ�ۡЏ�T�f��_V��#�f;�7{���7�>�������?�����:+ʬ (�%Ԕ��:�5�K��9�`���'Y̔S���#��ȿV�v���}q�D*�h�[#��o������{G�X�b	����쁥&['��?u����Y>�i��|�����5�7ʺ�!L�� �h%V�|!n?�5��@�G���ԟ��������kQ�%�=����-j¦cm�֬ߤ���v(�#��X�h�w�� �H-��������_~��Vߗ��O�u��ؗ������(:t5��Zi���$K��t̢�"�Y�@�)���@ax�����}����&h;]AK������|��}��z���x��Rzk��L�'"�R�<���?]k
����/�W~�$�`=���d=`�9��6[�C�'_����g��ɝ����M�&?��=�(�b8k���ݡ[����B�t��8�s~��b����/~�����������BF��W�J!k0bL�y��c�*(Ul�h�8����͇:�u��o�'qZ�>ǳ�V�a؞Ê�[;�M�^�n��>:�����h��g
��C�e�b��$FG�
܋��5��%���Կ�#H0.XQ|4Vik�G@��{�J)��g���Ŀ5�!���J�� i�̗�?O���l��y���K������a�������Ϣ�f]MN��0JD����sCU�����t�Gg��\J��a4꘺�v���6Z��t����e�ԕ��G�p�Cnpв߁ٻ����e�W:���k;:�[0� �ǰ�M��U����*m(��!l��E�KUixZ��D���m��:�f�%~�j��gg?<��߮	w2i���!"&I�a�P�������r��je녆S��\��������6@������T�ӵ�H�1�	����ĎM�֐�dk�o��-��N����`="Ew�#��~�a���1�3p��z�maN���e���#�x�$��CI)�!k�R(�DI��DQ��Jq��C�I�N��#9�2��4��i3ݪ�TWafw��Y*��{T�tl&�6�A��g#������|�d_+�x~oz�I��@����@�o�{�oL�*�'��E鷕���������b�Ģ�Q���M��?���E��k���ۇeۯ�f����,M����,��f�~?��=?5kZ�X�7�T�Xd����i_�h��J5����G���S� �َ���4|�@�4�v���}ξB�K۴�W���k��}����:���徫������}�@;-Y��46W�j�W�Qo��"���_�.��P�?��ϋ]7p�4ẑ)�����M���Ni�*�ˈ�d�D%2����(�y_�-��=���[Q d(��yK�rR��1*䞬��)�\}��m��l��-��N� ��I�=��FX߹�F0�o
�6pl����l)%
s�a��b5�)��TSy�b^�(��xŶFA%D��o���Y)�j�v
��"����!:`��p^��]Eu�D�퇩�C�	��r����C���0�ͪE��P�n�Fz#�cd&��U��6�8oL��Kk�rBd�rV�BSNh,����U}�n����ɻ��:��1�/?�����G��0�]�"xB���S���w��_CUR�����bƚ�R�%**�d#	�+�k�[Ft�X #�~�v֊�g�O���P�N#o��j�������0���Q����c��Z��K��!�-�6�dڤ�|�	��٪U�w��,�V�M�$clߝ�de���E�X͜f�K	)��S�r���l1��7A�>��_��֣-���s	4aO��N�<ސ�u}�h�SQ�����͋Q����f*$�c`]1f�.���o`����b��deHE�XLr��q�����Cx���y�ReUsa�
E����蚲@���-v��}�ߡȏ�|Y�[�ҳ�9tցQ[.����o\2bjƎ���D�U�&Ŏ@[���	|�W���������Gh��AMM��}_��=���Rv��~�"?���-�|ӳQm����,�
C�pa$���^��d�lk����*O9��BJ�f¢�K��?L�/dEX��>��t���ph�g��,���C�����?���[��j��[�n�vIG%,Z���bN�3�h�ٔ�+k��J�j����\�@M��#��2R�
\�V`j%UJ{�<����2�Ρ6�X�>��P�G�?������V�+�<�3\���P��;����j�]'$�#ޖa��;�۹�#�������8BU�Ě�;_��	�EPغ���8"t9
e2����֏�	������ؗ�k�#7�$�
��������S�
��K�� �my��F���e���H���bqژġZ�*!'��:6[�y	���x���I�;D0v7�3�4�%M�3+��YB��}��>��q�}�������ۖ{��k���₁�{7m[2bL���*���w3�������u������,5�\V�9��<�uO�m¨j�PZ������Vjf���-��.ڒrc� B,Pt����z� s�|�%�X�"�A��\}�X��\�%p���ZV
�^I�~mYt[!����������!�0���e1mC�V�Scݐթh�H1HU;�B�a0d�)���Լ7�� �>f�$����v�>!�&+�j�{=Z�uf���v��Wgޡȏ�|�b�՜�Wsfն�E��]J�t��xq[Y-9����4�n+��Vn��ہ*Ҳ+�F�L��8m�cu�!V�.&C&�H�m������.*��U��y������_~����Q�x�7����
}��>ǫ{jn3�SJшk!v����fw��Q%漆I4�%�7��;Ig�4�2�`e����۬8E��c��iPTZ=.k�S)JXi_��0q~8_��U��>q�}5s%zWE���;vw�>���i>D���\V��&1i�v�UUA����>��5����7�N6�}�*�p�R-A���Zu�P��c�[����%�*�`�ӆ�VE����~�йIj4��P؇��Co���Ŀ����<��U+ �Y�4Ơh��{F/ŧ��8(`�Y*p�g�2��jz���`��UL6�:�W;��Ԏ#oJ�N͗��붧hQm'zÚG��e}��{�?�r0X��Q��m��N�HXo{��F�{�FG�r*x��-8žm_lNN���k\�(�Pb��Np���`�ZJ ��MN�������)��{�.�~C���;rD���Q������
��U`TE��8�����5�m�	�����
�� �  o�󳬌Q�c�Z�KD�%�4ϸ���Ѩ�&�(ʻ:�X�c�̱Ē<��!g��$��[�J�>��vU�M'l�ZkTf�}��^C`�rP�����a��o�Ѵ�j���5aP�B�H*���$gk�9C	0K�9��{���*h4��N�?��::�a.+젾�ǩuO�HmW<F���ڡƏ\\����Y5�mf��QN�$)�:�*���/(�M��$PΞ42�Y��>��u1y�a��G����T���xۗ��(W�	˄C��5������aP]<��=I��X�Uf4�3JBp���8d>�M�*TT'� z;7��M��֨ce=j�-�h},Qy����6zI�&�jl�m��	�����,TDB�����b6mih;n `�FN��&������[;����d�V�_��M�m<���-O�$�n�����Fc`���F�ڰ�N�C�lS�jk��@n�֧�S"�_����g��o7����f�t_���i��y��������N�RC]��O����UrH���^���m6��Mj�K�Eٴ/�������`�ˡΐර�iqI�������{ ���%dt������Xy[M;��n����/c�4�7z�]m��7����&����E�g7�TW�58tS�E��MC�!O�q�C�A����t���)ǫ��b�ɗ�+������x��'_�Y����/O6�4h�����I��3�W�rC{6oȩ~C�:4T������kG_Q��=�~�d~��2f�����w��n�n�����ɢ!Zm�\��X;8�y?_>�{f�f#b�wzP�I��v�W;��*~�*ҷz&m�sWh���M�g�U��ءS��Ն��*a-j���ᶓ��+��@�^�@�?7�T(�wCT}�0ԁ\����ڜ��RUҡ��w�'������~�*�]gMr;�&��O�ַ���O�㼵�[ch+��!R� ���F��� ��H��#Lm�}���@��HmGjHkY�Þ��fna��C]�{�m�c��~���W��j�~��UG�b��a���~D�'�b�#�����q���F5���P�}_�ڒ�V%��4	�h��%�oɶ�F�����np���i�^�����eü������ލ	���������=�귢&�<��b����~�2?5��\��Z����[����~���oR@z	64���vvg���=���>����h�             x��[I��8<�^QhI��������������]�P�j�ΊT����(�D��?���:��������v?�����_:�_�	��߸�����vG�?����8�e��1�$)�`��0,��_��]`t��.
ŕ�7X��2c:��!	6�-��.�����@
pp<�znfYi�w���\˪����d�K��{�����v% ǯK���Dp�G��l����E8l 4�t,��r�`�!�� ���,q���x���ԭ�;A["?�ɷ�x�Hi>�'�'�!�و8������������Cz6����E��Fy�E)/D\�sY�O�����r�<,W�1y�+��'$�	�A?p��uI=�g3W9���
O���VVc\��l������y��tL����\�g7��dC؞�R|�T<�����Ŏ7��'��#<����&��>���� ^#��	�~� Zi+ɹP_��9%J���3 ۞WI�w]ԍiZBbq�n���jĄ������h� F����o�׉
F�m���C��v?���{\!�r�ۂ~MA�����z��z��v�s�D��c٧�Z��lQT��?	����$~]�G�s�"A(F��>/�-޲=��9�$�x��R#��Zҹ}���^�h�\�Z�8R���e�%��/��{���X�}ʟ�.�2\�@�\"e#�R��#��&�A7^�@Ei#e?�8���=`P�
����{*�i���������%�'T���W��Md���L����禔ɀ^Sz.\���s���639E\���l\�Kd����=9QP������`��ܣ�|`�'��"�&���qA�$~�������Ѥz������7��sN����0�&`��׏��J1�l�q<����<<�ᨐ3�=��Pr�:Vg"����S
Y_���B>�'V�k����͉,=�
s�qq���d�"�X�6s�0���ź��&�x��pLX���%y�����YHW��.} 5�S�U��#6� ���{�'dc�lFY��z�L���9Y3�����{�Q��"�*�G~R�ߓxh���a�Q��ź��GA2�¸�RV2�嶏Lo۾���P����|�-�GA���ญ.�1���a���d[��xƶ����{4Ł�ХC��2벺�D?\�,٫5��Yx��h��Bx�Y���ٸ`�B�7�l�_N�d�=�k<�r�:��e��|nK��6)��oF.g��	�;BN©s����O�&&����~�ʷ��H>�((SϚ���'ܧ��1ݲ:�+���O�U�U�a�^N]���$ˋ����l�=�IS_S�Ep;5��ӑ�j,��v_�1c����F�2ϐ�:+'ܢY���m�cgޣˣ%��p���A�MC���CS:�{������9
u<s�è�Y�����:#��\-y�����_�v<��;���0VNyRdCN����-�'M�G:����e���t��2u�p(4�qoą�a�^0����=p	cWW�^���Y9L=��� �9 p�l�J'_��ˢk���y���\�LZ����_mɷ�SB5�)è���8�r�KT�C�԰�J��<"�a7�M�����ʴk��d~��s:���A'��rn�<�)3�(\��d�ކr<|�I:��^��PWK.6H�BX�?PM�\��䅿.�)��"*���ŢY�R�5B��L�7��',�w<%�d�=����Y#�d	���s�%Ǵz\p��L��Ϛ�j���<�����(�����:3W�#¾G~���LUd��q���<��$mJ��I?5�a����_7��������e�1�*�m� �|��t����a�vMÃ������aH���=�y�0-�-��p���4�{����l��N�5۲�R�XlZf��wb��3H�}�eݼ�<�f*JK��19��G�uk��
�_1�D���%�gK��v;q��6��Քd�,WͳT���0�!
&��������.Hv��,��b*�@�C\4+�S�G�z��&M.a���\S?�j��W��t�_a�X��z?����+�yG���h��z���|YD��8q���E;��� �p^�-s��"�-�6Ք.�L,u�v�IEH��è�>��Y��A�٤�Y�\�n�[��LM�8�P)��>�E
�*�d߻ˁ��7Kݢ��Y9���i�J��*
:��~2�頷�[��>���(.4oceKR:�sYo����ro�δ[�����-���h�|������Da�wh'ؑV����#n�b�ڬk��﹟W�X,�{�wƜ0�{"�C��$^�0M�|�d&�n)I?��r��N��:�V>����� EW��X���Vз��;,�9�<�e����<Y�a5FEگ�TAd�w�g��t�%RP�Yϛ0�$k�l	֠����r�'��C�7��ϒ��Y�aXi�eVaP��mo����T�H:	d��.9&a�����[��V�f�y��i� �-����/X!��wV��"{o� �^���
�SM�~�͞Ƞ�v�'�v�F~��'0�I�d�M��˒${)��=5b&�
�b�>/ڸ��2N;�{�[~ºf�$��
�[����'�2s
��ԓM=�b�79,cp/��0�/����5���	�=��D��jw�t]9A�7��?%�7`r�z�����O�Uz���s�;�C��0�$����l�%�RgE�V]5�%eZF��tJO��kh~�hp@)�����2�Db2z�eŨ�g[Ca$�p�Po�N4T�A3PU>X������\}� ����%J�����	�_�)�m��=>������c��DF�9��_v�J_K>'ۼj?��{�~B�k���	��ά�����~X�%UZt,�]G�OD�6B#��|]r�l �a�C,���y��}Y�y���|R����1��*��m��'���T���)Z�6�4yYOS�Ws�4Al:����oR[�T���Ѣ]�!�u<�Z���_�6¾�my\kx�#��o�qɒ4���[ڨ���[b��&���-aF��`M�uQ��\�K����ֳş�]c�9"�v]��q�=�¸!Ϋ�E��s��B��}���Е�����p�ª)#��I��Z�I>����t�G
zn�x<���q��ISҿE�p�~b�H�7�*Mrr�B|�Mۭ���_��v�q3gr���	A��U��%0�I�ΣmE��q�c]�c��[u���2�f��?�����!ܚ�	��=j�s��������U�`�h���(���E6�.�Qy1�8Eqբe�obS1��vW��Ӭ�2n]�k�h�*�E�
�M~���9J%L��0��!�[WFQ]Ŋ��7�}��'6?�ygw)ڧ�
)�.y�T.@��"c6�-�����f��;{*����v�Y��l)�6�t��]Ol4�Ԕ��~���П�0d���;duLp#�Ƴ���i��"�x1!��LZ�.feT-�}��ꨦ��V�s�}%�eɫ~�\�@�M;4A�}��6c<T���-�2WQ����f?d�<�Fc�Mռ�6ׇ��\v0L}�D�����_���,�l��[��ϫ�j�FH�!i�>��4��A�����Ie
k(��\O�7�k�e!����ܠ�A�Pz~6�r�MZ"�ĺ��^2+s��t�B9ԘtL��<�ş���榉*|��a6W�$K�D@�q��-�Գq�kl�|�����A��&�/�D6wU"ƽ0�}���P��'�̥|Y�G�`R8T��n������頎�"������=�bKi�G(��:�����[��b�Ŷ����������_,\����ER��2}3�X̍�*w�/36���DU��:bT���ͭ[*s�h\��79~�aQ ��Y=E��a]l[�R�N^�� �56�J��s�B�s6`�;�i-K��:��̴ş�Ҽ�>|2����i����w���/��p�=<�1� �B���;'l�1�Q;���N��h�zn�%��*�l��B�Գ��kl�����9���q��"�yK�"����k^`K3��!I�+�;���>�c�����N�=��g5��� �   {�ؿv�_ ��D�xf��;�<��1`Cg��V�؞9r������B7�26�vz'�!"��l���L���w<T��e�'1�ʡh�hjX�KR�g,DY�)6G��/�BvD�6�2X�L$�X7��&z��.���[��F!�sn��+/����<%��3N~�G=&L3�4���O۲��6M�         �  x�œMn�0���)/�;�Q"\E�"E�"h����$֕!S�~�^����ZN	YdS�+��7|)�l����w�,��n��;ֵŻś�j����۸Mz�c���<.�o�ڮ�֟n�\�;��PT�[��ʕ�R:��Ŗ���p�&� W���d�Z�, �(��T��x���ږ8�.��!ZV#�*H�0�c�BI>7���T��E�uf�YR��(�b~F�VF��
���1߱!8�=�n���U?w*2+4HH�H�����_������Rq�B�%�}|hB�CU�b��C��c�X�V���PX�VO��PS)"�uS��c@�B�k����u3q�,H��k���C�������ŭ�H9�i"�x��>/��?�'0L�ⵯ��`#mƳD"*죩-�~�Y�ͥ0$�pJ�?e	N=         u  x�}R=O�@��_�U��cs�TF��.��td`bc��Nڒ"ĐS|~~~~�꺺��Z����0:��m 3��]�-%
�i��P ݌����4~�-��p������ՉrG�D@0�ԂZV��P(0�:C,IN}�#�鼪6����,�;7~.�+���7�+�AA�!2��D�I���2
�
@N���B�`�y"�P��:�b]A�ҰQ�Y�$�L�^�k�ܛ�-I�Z�BdX(γ�M�ғ��{hw(�e�]Wbם2� 6?&����^˘��q_4n&�����C����q��a;=�d`��v�kQ�i�����(G���MJ�Q�H�0~yJ�HW�Ԙ��s��a����)�7         3   x�KL.�,��J�H�KOU(H,.�J-.H-JTHIUHI&&g��q��qqq y�4         +   x�+(��MM���JL����,.)JL�/�*-.M,���qqq ��      �   �  x�}R�n� ]㯘�fV��V���(jw�����.�]̢��EW���XM�&�4�t��
8/js���(%S��G0�a�qj4�AgI�x���7�&$_���Lz�'���{5��jc�� E=��Ƴ�(��6���i��B"4L�B� ,��6ȥd�����,�P��*]J�[V�78�tK�-�^�6<�gb�g��8���x��F�to�	���]����	,���?�����Y��h�;�r�ue��� Q��ȅ>c�>Ag�,^�����Gg���rҹ�̀p�wM�/e$/D\0)�fs]"-Q�$�­^����E��:����cw�j���݇Nh1��[�}]��Dz?�.�������/�.�w�6���M�G>?�"�7�ƿ� [�㟠՞��Ѳd�DV���-^8X$�4I�?� �     