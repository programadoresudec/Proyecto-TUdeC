PGDMP     9    )                x            tudec    12.2    12.2 �               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    17662    tudec    DATABASE     �   CREATE DATABASE tudec WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Spanish_Latin America.1252' LC_CTYPE = 'Spanish_Latin America.1252';
    DROP DATABASE tudec;
                postgres    false            	            2615    18068    comentarios    SCHEMA        CREATE SCHEMA comentarios;
    DROP SCHEMA comentarios;
                postgres    false                        2615    18069    cursos    SCHEMA        CREATE SCHEMA cursos;
    DROP SCHEMA cursos;
                postgres    false                        2615    18070    examenes    SCHEMA        CREATE SCHEMA examenes;
    DROP SCHEMA examenes;
                postgres    false                        2615    18071    mensajes    SCHEMA        CREATE SCHEMA mensajes;
    DROP SCHEMA mensajes;
                postgres    false                        2615    18072    notificaciones    SCHEMA        CREATE SCHEMA notificaciones;
    DROP SCHEMA notificaciones;
                postgres    false                        2615    18073    puntuaciones    SCHEMA        CREATE SCHEMA puntuaciones;
    DROP SCHEMA puntuaciones;
                postgres    false                        2615    18074    reportes    SCHEMA        CREATE SCHEMA reportes;
    DROP SCHEMA reportes;
                postgres    false            
            2615    18075 	   seguridad    SCHEMA        CREATE SCHEMA seguridad;
    DROP SCHEMA seguridad;
                postgres    false                        2615    18076    sugerencias    SCHEMA        CREATE SCHEMA sugerencias;
    DROP SCHEMA sugerencias;
                postgres    false                        2615    18077    temas    SCHEMA        CREATE SCHEMA temas;
    DROP SCHEMA temas;
                postgres    false                        2615    18078    usuarios    SCHEMA        CREATE SCHEMA usuarios;
    DROP SCHEMA usuarios;
                postgres    false            �            1255    18079    f_log_auditoria()    FUNCTION     �  CREATE FUNCTION seguridad.f_log_auditoria() RETURNS trigger
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
    	   seguridad          postgres    false    10            �            1259    18081    usuarios    TABLE     {  CREATE TABLE usuarios.usuarios (
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
       usuarios         heap    postgres    false    15                       1255    18087 i   field_audit(usuarios.usuarios, usuarios.usuarios, character varying, text, character varying, text, text)    FUNCTION     "  CREATE FUNCTION seguridad.field_audit(_data_new usuarios.usuarios, _data_old usuarios.usuarios, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
    	   seguridad          postgres    false    10    213    213            �            1259    18088    comentarios    TABLE       CREATE TABLE comentarios.comentarios (
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
       comentarios         heap    postgres    false    9            �            1259    18094    comentarios_id_seq    SEQUENCE     �   CREATE SEQUENCE comentarios.comentarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE comentarios.comentarios_id_seq;
       comentarios          postgres    false    9    214                       0    0    comentarios_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE comentarios.comentarios_id_seq OWNED BY comentarios.comentarios.id;
          comentarios          postgres    false    215            �            1259    18096    areas    TABLE     O   CREATE TABLE cursos.areas (
    area text NOT NULL,
    icono text NOT NULL
);
    DROP TABLE cursos.areas;
       cursos         heap    postgres    false    16            �            1259    18102    cursos    TABLE     D  CREATE TABLE cursos.cursos (
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
       cursos         heap    postgres    false    16            �            1259    18108    cursos_id_seq    SEQUENCE     �   CREATE SEQUENCE cursos.cursos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE cursos.cursos_id_seq;
       cursos          postgres    false    217    16                       0    0    cursos_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE cursos.cursos_id_seq OWNED BY cursos.cursos.id;
          cursos          postgres    false    218            �            1259    18110    estados_curso    TABLE     @   CREATE TABLE cursos.estados_curso (
    estado text NOT NULL
);
 !   DROP TABLE cursos.estados_curso;
       cursos         heap    postgres    false    16            �            1259    18116    inscripciones_cursos    TABLE     �   CREATE TABLE cursos.inscripciones_cursos (
    id integer NOT NULL,
    fk_nombre_de_usuario text NOT NULL,
    fk_id_curso integer NOT NULL,
    fecha_de_inscripcion date NOT NULL
);
 (   DROP TABLE cursos.inscripciones_cursos;
       cursos         heap    postgres    false    16            �            1259    18122    inscripciones_cursos_id_seq    SEQUENCE     �   CREATE SEQUENCE cursos.inscripciones_cursos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE cursos.inscripciones_cursos_id_seq;
       cursos          postgres    false    16    220                       0    0    inscripciones_cursos_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE cursos.inscripciones_cursos_id_seq OWNED BY cursos.inscripciones_cursos.id;
          cursos          postgres    false    221            �            1259    18124    ejecucion_examen    TABLE       CREATE TABLE examenes.ejecucion_examen (
    id integer NOT NULL,
    fk_nombre_de_usuario text NOT NULL,
    fk_id_examen integer NOT NULL,
    fecha_de_ejecucion timestamp with time zone NOT NULL,
    calificacion integer,
    respuestas text NOT NULL
);
 &   DROP TABLE examenes.ejecucion_examen;
       examenes         heap    postgres    false    8            �            1259    18130    ejecucion_examen_id_seq    SEQUENCE     �   CREATE SEQUENCE examenes.ejecucion_examen_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE examenes.ejecucion_examen_id_seq;
       examenes          postgres    false    222    8                       0    0    ejecucion_examen_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE examenes.ejecucion_examen_id_seq OWNED BY examenes.ejecucion_examen.id;
          examenes          postgres    false    223            �            1259    18132    examenes    TABLE     q   CREATE TABLE examenes.examenes (
    id integer NOT NULL,
    fk_id_tema integer,
    fecha_fin date NOT NULL
);
    DROP TABLE examenes.examenes;
       examenes         heap    postgres    false    8            �            1259    18135    examenes_id_seq    SEQUENCE     �   CREATE SEQUENCE examenes.examenes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE examenes.examenes_id_seq;
       examenes          postgres    false    224    8                       0    0    examenes_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE examenes.examenes_id_seq OWNED BY examenes.examenes.id;
          examenes          postgres    false    225            �            1259    18138 	   preguntas    TABLE     �   CREATE TABLE examenes.preguntas (
    id integer NOT NULL,
    fk_id_examen integer NOT NULL,
    fk_tipo_pregunta text NOT NULL,
    pregunta text NOT NULL,
    porcentaje integer NOT NULL
);
    DROP TABLE examenes.preguntas;
       examenes         heap    postgres    false    8            �            1259    18144    preguntas_id_seq    SEQUENCE     �   CREATE SEQUENCE examenes.preguntas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE examenes.preguntas_id_seq;
       examenes          postgres    false    226    8                        0    0    preguntas_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE examenes.preguntas_id_seq OWNED BY examenes.preguntas.id;
          examenes          postgres    false    227            �            1259    18146 
   respuestas    TABLE     �   CREATE TABLE examenes.respuestas (
    id integer NOT NULL,
    fk_id_preguntas integer NOT NULL,
    respuesta text NOT NULL,
    estado boolean NOT NULL
);
     DROP TABLE examenes.respuestas;
       examenes         heap    postgres    false    8            �            1259    18152    respuestas_id_seq    SEQUENCE     �   CREATE SEQUENCE examenes.respuestas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE examenes.respuestas_id_seq;
       examenes          postgres    false    228    8            !           0    0    respuestas_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE examenes.respuestas_id_seq OWNED BY examenes.respuestas.id;
          examenes          postgres    false    229            �            1259    18154    tipos_pregunta    TABLE     A   CREATE TABLE examenes.tipos_pregunta (
    tipo text NOT NULL
);
 $   DROP TABLE examenes.tipos_pregunta;
       examenes         heap    postgres    false    8            �            1259    18160    mensajes    TABLE       CREATE TABLE mensajes.mensajes (
    id integer NOT NULL,
    fk_nombre_de_usuario_emisor text NOT NULL,
    fk_nombre_de_usuario_receptor text NOT NULL,
    contenido text NOT NULL,
    imagenes text[],
    fecha timestamp without time zone NOT NULL,
    id_curso integer
);
    DROP TABLE mensajes.mensajes;
       mensajes         heap    postgres    false    17            �            1259    18166    mensajes_id_seq    SEQUENCE     �   CREATE SEQUENCE mensajes.mensajes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE mensajes.mensajes_id_seq;
       mensajes          postgres    false    17    231            "           0    0    mensajes_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE mensajes.mensajes_id_seq OWNED BY mensajes.mensajes.id;
          mensajes          postgres    false    232            �            1259    18168    notificaciones    TABLE     �   CREATE TABLE notificaciones.notificaciones (
    id integer NOT NULL,
    mensaje text NOT NULL,
    estado boolean NOT NULL,
    fk_nombre_de_usuario text NOT NULL
);
 *   DROP TABLE notificaciones.notificaciones;
       notificaciones         heap    postgres    false    7            �            1259    18174    notificaciones_id_seq    SEQUENCE     �   CREATE SEQUENCE notificaciones.notificaciones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE notificaciones.notificaciones_id_seq;
       notificaciones          postgres    false    7    233            #           0    0    notificaciones_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE notificaciones.notificaciones_id_seq OWNED BY notificaciones.notificaciones.id;
          notificaciones          postgres    false    234            �            1259    18176    puntuaciones    TABLE     �   CREATE TABLE puntuaciones.puntuaciones (
    id integer NOT NULL,
    emisor text NOT NULL,
    receptor text NOT NULL,
    puntuacion integer NOT NULL
);
 &   DROP TABLE puntuaciones.puntuaciones;
       puntuaciones         heap    postgres    false    18            �            1259    18182    puntuaciones_id_seq    SEQUENCE     �   CREATE SEQUENCE puntuaciones.puntuaciones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE puntuaciones.puntuaciones_id_seq;
       puntuaciones          postgres    false    18    235            $           0    0    puntuaciones_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE puntuaciones.puntuaciones_id_seq OWNED BY puntuaciones.puntuaciones.id;
          puntuaciones          postgres    false    236            �            1259    18184    motivos    TABLE     <   CREATE TABLE reportes.motivos (
    motivo text NOT NULL
);
    DROP TABLE reportes.motivos;
       reportes         heap    postgres    false    11            �            1259    18190    reportes    TABLE     \  CREATE TABLE reportes.reportes (
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
       reportes         heap    postgres    false    11            �            1259    18196    reportes_id_seq    SEQUENCE     �   CREATE SEQUENCE reportes.reportes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE reportes.reportes_id_seq;
       reportes          postgres    false    238    11            %           0    0    reportes_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE reportes.reportes_id_seq OWNED BY reportes.reportes.id;
          reportes          postgres    false    239            �            1259    18198 	   auditoria    TABLE     L  CREATE TABLE seguridad.auditoria (
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
    	   seguridad         heap    postgres    false    10            &           0    0    TABLE auditoria    COMMENT     b   COMMENT ON TABLE seguridad.auditoria IS 'Tabla que almacena la trazabilidad de la informaicón.';
       	   seguridad          postgres    false    240            '           0    0    COLUMN auditoria.id    COMMENT     E   COMMENT ON COLUMN seguridad.auditoria.id IS 'campo pk de la tabla ';
       	   seguridad          postgres    false    240            (           0    0    COLUMN auditoria.fecha    COMMENT     [   COMMENT ON COLUMN seguridad.auditoria.fecha IS 'ALmacen ala la fecha de la modificación';
       	   seguridad          postgres    false    240            )           0    0    COLUMN auditoria.accion    COMMENT     g   COMMENT ON COLUMN seguridad.auditoria.accion IS 'Almacena la accion que se ejecuto sobre el registro';
       	   seguridad          postgres    false    240            *           0    0    COLUMN auditoria.schema    COMMENT     n   COMMENT ON COLUMN seguridad.auditoria.schema IS 'Almanena el nomnbre del schema de la tabla que se modifico';
       	   seguridad          postgres    false    240            +           0    0    COLUMN auditoria.tabla    COMMENT     a   COMMENT ON COLUMN seguridad.auditoria.tabla IS 'Almacena el nombre de la tabla que se modifico';
       	   seguridad          postgres    false    240            ,           0    0    COLUMN auditoria.session    COMMENT     q   COMMENT ON COLUMN seguridad.auditoria.session IS 'Campo que almacena el id de la session que generó el cambio';
       	   seguridad          postgres    false    240            -           0    0    COLUMN auditoria.user_bd    COMMENT     �   COMMENT ON COLUMN seguridad.auditoria.user_bd IS 'Campo que almacena el user que se autentico en el motor para generar el cmabio';
       	   seguridad          postgres    false    240            .           0    0    COLUMN auditoria.data    COMMENT     e   COMMENT ON COLUMN seguridad.auditoria.data IS 'campo que almacena la modificaicón que se realizó';
       	   seguridad          postgres    false    240            /           0    0    COLUMN auditoria.pk    COMMENT     X   COMMENT ON COLUMN seguridad.auditoria.pk IS 'Campo que identifica el id del registro.';
       	   seguridad          postgres    false    240            �            1259    18204    auditoria_id_seq    SEQUENCE     |   CREATE SEQUENCE seguridad.auditoria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE seguridad.auditoria_id_seq;
    	   seguridad          postgres    false    10    240            0           0    0    auditoria_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE seguridad.auditoria_id_seq OWNED BY seguridad.auditoria.id;
       	   seguridad          postgres    false    241            �            1259    18206    autentication    TABLE     �   CREATE TABLE seguridad.autentication (
    id integer NOT NULL,
    nombre_de_usuario text NOT NULL,
    ip text,
    mac text,
    fecha_inicio timestamp without time zone,
    fecha_fin timestamp without time zone,
    session text
);
 $   DROP TABLE seguridad.autentication;
    	   seguridad         heap    postgres    false    10            �            1259    18212    autentication_id_seq    SEQUENCE     �   CREATE SEQUENCE seguridad.autentication_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE seguridad.autentication_id_seq;
    	   seguridad          postgres    false    10    242            1           0    0    autentication_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE seguridad.autentication_id_seq OWNED BY seguridad.autentication.id;
       	   seguridad          postgres    false    243            �            1259    18214    function_db_view    VIEW     �  CREATE VIEW seguridad.function_db_view AS
 SELECT pp.proname AS b_function,
    oidvectortypes(pp.proargtypes) AS b_type_parameters
   FROM (pg_proc pp
     JOIN pg_namespace pn ON ((pn.oid = pp.pronamespace)))
  WHERE ((pn.nspname)::text <> ALL (ARRAY[('pg_catalog'::character varying)::text, ('information_schema'::character varying)::text, ('admin_control'::character varying)::text, ('vial'::character varying)::text]));
 &   DROP VIEW seguridad.function_db_view;
    	   seguridad          postgres    false    10            �            1259    18219    sugerencias    TABLE     �   CREATE TABLE sugerencias.sugerencias (
    id integer NOT NULL,
    fk_nombre_de_usuario_emisor text,
    contenido text NOT NULL,
    estado boolean NOT NULL,
    imagenes text,
    titulo text NOT NULL,
    fecha timestamp with time zone NOT NULL
);
 $   DROP TABLE sugerencias.sugerencias;
       sugerencias         heap    postgres    false    13            �            1259    18225    sugerencias_id_seq    SEQUENCE     �   CREATE SEQUENCE sugerencias.sugerencias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE sugerencias.sugerencias_id_seq;
       sugerencias          postgres    false    13    245            2           0    0    sugerencias_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE sugerencias.sugerencias_id_seq OWNED BY sugerencias.sugerencias.id;
          sugerencias          postgres    false    246            �            1259    18227    temas    TABLE     �   CREATE TABLE temas.temas (
    id integer NOT NULL,
    fk_id_curso integer NOT NULL,
    titulo text NOT NULL,
    informacion text NOT NULL,
    imagenes text[]
);
    DROP TABLE temas.temas;
       temas         heap    postgres    false    6            �            1259    18233    temas_id_seq    SEQUENCE     �   CREATE SEQUENCE temas.temas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE temas.temas_id_seq;
       temas          postgres    false    247    6            3           0    0    temas_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE temas.temas_id_seq OWNED BY temas.temas.id;
          temas          postgres    false    248            �            1259    18235    estados_usuario    TABLE     D   CREATE TABLE usuarios.estados_usuario (
    estado text NOT NULL
);
 %   DROP TABLE usuarios.estados_usuario;
       usuarios         heap    postgres    false    15            �            1259    18241    roles    TABLE     7   CREATE TABLE usuarios.roles (
    rol text NOT NULL
);
    DROP TABLE usuarios.roles;
       usuarios         heap    postgres    false    15                       2604    18247    comentarios id    DEFAULT     z   ALTER TABLE ONLY comentarios.comentarios ALTER COLUMN id SET DEFAULT nextval('comentarios.comentarios_id_seq'::regclass);
 B   ALTER TABLE comentarios.comentarios ALTER COLUMN id DROP DEFAULT;
       comentarios          postgres    false    215    214                       2604    18248 	   cursos id    DEFAULT     f   ALTER TABLE ONLY cursos.cursos ALTER COLUMN id SET DEFAULT nextval('cursos.cursos_id_seq'::regclass);
 8   ALTER TABLE cursos.cursos ALTER COLUMN id DROP DEFAULT;
       cursos          postgres    false    218    217                       2604    18249    inscripciones_cursos id    DEFAULT     �   ALTER TABLE ONLY cursos.inscripciones_cursos ALTER COLUMN id SET DEFAULT nextval('cursos.inscripciones_cursos_id_seq'::regclass);
 F   ALTER TABLE cursos.inscripciones_cursos ALTER COLUMN id DROP DEFAULT;
       cursos          postgres    false    221    220                       2604    18250    ejecucion_examen id    DEFAULT     ~   ALTER TABLE ONLY examenes.ejecucion_examen ALTER COLUMN id SET DEFAULT nextval('examenes.ejecucion_examen_id_seq'::regclass);
 D   ALTER TABLE examenes.ejecucion_examen ALTER COLUMN id DROP DEFAULT;
       examenes          postgres    false    223    222                       2604    18251    examenes id    DEFAULT     n   ALTER TABLE ONLY examenes.examenes ALTER COLUMN id SET DEFAULT nextval('examenes.examenes_id_seq'::regclass);
 <   ALTER TABLE examenes.examenes ALTER COLUMN id DROP DEFAULT;
       examenes          postgres    false    225    224                       2604    18252    preguntas id    DEFAULT     p   ALTER TABLE ONLY examenes.preguntas ALTER COLUMN id SET DEFAULT nextval('examenes.preguntas_id_seq'::regclass);
 =   ALTER TABLE examenes.preguntas ALTER COLUMN id DROP DEFAULT;
       examenes          postgres    false    227    226                       2604    18253    respuestas id    DEFAULT     r   ALTER TABLE ONLY examenes.respuestas ALTER COLUMN id SET DEFAULT nextval('examenes.respuestas_id_seq'::regclass);
 >   ALTER TABLE examenes.respuestas ALTER COLUMN id DROP DEFAULT;
       examenes          postgres    false    229    228                       2604    18254    mensajes id    DEFAULT     n   ALTER TABLE ONLY mensajes.mensajes ALTER COLUMN id SET DEFAULT nextval('mensajes.mensajes_id_seq'::regclass);
 <   ALTER TABLE mensajes.mensajes ALTER COLUMN id DROP DEFAULT;
       mensajes          postgres    false    232    231                       2604    18255    notificaciones id    DEFAULT     �   ALTER TABLE ONLY notificaciones.notificaciones ALTER COLUMN id SET DEFAULT nextval('notificaciones.notificaciones_id_seq'::regclass);
 H   ALTER TABLE notificaciones.notificaciones ALTER COLUMN id DROP DEFAULT;
       notificaciones          postgres    false    234    233                       2604    18256    puntuaciones id    DEFAULT     ~   ALTER TABLE ONLY puntuaciones.puntuaciones ALTER COLUMN id SET DEFAULT nextval('puntuaciones.puntuaciones_id_seq'::regclass);
 D   ALTER TABLE puntuaciones.puntuaciones ALTER COLUMN id DROP DEFAULT;
       puntuaciones          postgres    false    236    235                       2604    18257    reportes id    DEFAULT     n   ALTER TABLE ONLY reportes.reportes ALTER COLUMN id SET DEFAULT nextval('reportes.reportes_id_seq'::regclass);
 <   ALTER TABLE reportes.reportes ALTER COLUMN id DROP DEFAULT;
       reportes          postgres    false    239    238                        2604    18258    auditoria id    DEFAULT     r   ALTER TABLE ONLY seguridad.auditoria ALTER COLUMN id SET DEFAULT nextval('seguridad.auditoria_id_seq'::regclass);
 >   ALTER TABLE seguridad.auditoria ALTER COLUMN id DROP DEFAULT;
    	   seguridad          postgres    false    241    240            !           2604    18259    autentication id    DEFAULT     z   ALTER TABLE ONLY seguridad.autentication ALTER COLUMN id SET DEFAULT nextval('seguridad.autentication_id_seq'::regclass);
 B   ALTER TABLE seguridad.autentication ALTER COLUMN id DROP DEFAULT;
    	   seguridad          postgres    false    243    242            "           2604    18260    sugerencias id    DEFAULT     z   ALTER TABLE ONLY sugerencias.sugerencias ALTER COLUMN id SET DEFAULT nextval('sugerencias.sugerencias_id_seq'::regclass);
 B   ALTER TABLE sugerencias.sugerencias ALTER COLUMN id DROP DEFAULT;
       sugerencias          postgres    false    246    245            #           2604    18261    temas id    DEFAULT     b   ALTER TABLE ONLY temas.temas ALTER COLUMN id SET DEFAULT nextval('temas.temas_id_seq'::regclass);
 6   ALTER TABLE temas.temas ALTER COLUMN id DROP DEFAULT;
       temas          postgres    false    248    247            �          0    18088    comentarios 
   TABLE DATA           �   COPY comentarios.comentarios (id, fk_nombre_de_usuario_emisor, fk_id_curso, fk_id_tema, fk_id_comentario, comentario, fecha_envio, imagenes) FROM stdin;
    comentarios          postgres    false    214   @       �          0    18096    areas 
   TABLE DATA           ,   COPY cursos.areas (area, icono) FROM stdin;
    cursos          postgres    false    216   �       �          0    18102    cursos 
   TABLE DATA           �   COPY cursos.cursos (id, fk_creador, fk_area, fk_estado, nombre, fecha_de_creacion, fecha_de_inicio, codigo_inscripcion, puntuacion, descripcion) FROM stdin;
    cursos          postgres    false    217   .!      �          0    18110    estados_curso 
   TABLE DATA           /   COPY cursos.estados_curso (estado) FROM stdin;
    cursos          postgres    false    219   "      �          0    18116    inscripciones_cursos 
   TABLE DATA           k   COPY cursos.inscripciones_cursos (id, fk_nombre_de_usuario, fk_id_curso, fecha_de_inscripcion) FROM stdin;
    cursos          postgres    false    220   )"      �          0    18124    ejecucion_examen 
   TABLE DATA           �   COPY examenes.ejecucion_examen (id, fk_nombre_de_usuario, fk_id_examen, fecha_de_ejecucion, calificacion, respuestas) FROM stdin;
    examenes          postgres    false    222   s"      �          0    18132    examenes 
   TABLE DATA           ?   COPY examenes.examenes (id, fk_id_tema, fecha_fin) FROM stdin;
    examenes          postgres    false    224   =#      �          0    18138 	   preguntas 
   TABLE DATA           _   COPY examenes.preguntas (id, fk_id_examen, fk_tipo_pregunta, pregunta, porcentaje) FROM stdin;
    examenes          postgres    false    226   v#      �          0    18146 
   respuestas 
   TABLE DATA           N   COPY examenes.respuestas (id, fk_id_preguntas, respuesta, estado) FROM stdin;
    examenes          postgres    false    228   D$                0    18154    tipos_pregunta 
   TABLE DATA           0   COPY examenes.tipos_pregunta (tipo) FROM stdin;
    examenes          postgres    false    230   �$                0    18160    mensajes 
   TABLE DATA           �   COPY mensajes.mensajes (id, fk_nombre_de_usuario_emisor, fk_nombre_de_usuario_receptor, contenido, imagenes, fecha, id_curso) FROM stdin;
    mensajes          postgres    false    231   2%                0    18168    notificaciones 
   TABLE DATA           [   COPY notificaciones.notificaciones (id, mensaje, estado, fk_nombre_de_usuario) FROM stdin;
    notificaciones          postgres    false    233   �%                0    18176    puntuaciones 
   TABLE DATA           N   COPY puntuaciones.puntuaciones (id, emisor, receptor, puntuacion) FROM stdin;
    puntuaciones          postgres    false    235   �%                0    18184    motivos 
   TABLE DATA           +   COPY reportes.motivos (motivo) FROM stdin;
    reportes          postgres    false    237   &      	          0    18190    reportes 
   TABLE DATA           �   COPY reportes.reportes (id, fk_nombre_de_usuario_denunciante, fk_nombre_de_usuario_denunciado, fk_motivo, descripcion, estado, fk_id_comentario, fk_id_mensaje, fecha) FROM stdin;
    reportes          postgres    false    238   _&                0    18198 	   auditoria 
   TABLE DATA           d   COPY seguridad.auditoria (id, fecha, accion, schema, tabla, session, user_bd, data, pk) FROM stdin;
 	   seguridad          postgres    false    240   '                0    18206    autentication 
   TABLE DATA           l   COPY seguridad.autentication (id, nombre_de_usuario, ip, mac, fecha_inicio, fecha_fin, session) FROM stdin;
 	   seguridad          postgres    false    242   �A                0    18219    sugerencias 
   TABLE DATA           w   COPY sugerencias.sugerencias (id, fk_nombre_de_usuario_emisor, contenido, estado, imagenes, titulo, fecha) FROM stdin;
    sugerencias          postgres    false    245   	D                0    18227    temas 
   TABLE DATA           N   COPY temas.temas (id, fk_id_curso, titulo, informacion, imagenes) FROM stdin;
    temas          postgres    false    247   �E                0    18235    estados_usuario 
   TABLE DATA           3   COPY usuarios.estados_usuario (estado) FROM stdin;
    usuarios          postgres    false    249   �G                0    18241    roles 
   TABLE DATA           &   COPY usuarios.roles (rol) FROM stdin;
    usuarios          postgres    false    250   �G      �          0    18081    usuarios 
   TABLE DATA           >  COPY usuarios.usuarios (nombre_de_usuario, fk_rol, fk_estado, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, correo_institucional, pass, fecha_desbloqueo, puntuacion, token, imagen_perfil, fecha_creacion, ultima_modificacion, vencimiento_token, session, descripcion, puntuacion_bloqueo) FROM stdin;
    usuarios          postgres    false    213   5H      4           0    0    comentarios_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('comentarios.comentarios_id_seq', 6, true);
          comentarios          postgres    false    215            5           0    0    cursos_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('cursos.cursos_id_seq', 8, true);
          cursos          postgres    false    218            6           0    0    inscripciones_cursos_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('cursos.inscripciones_cursos_id_seq', 2, true);
          cursos          postgres    false    221            7           0    0    ejecucion_examen_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('examenes.ejecucion_examen_id_seq', 4, true);
          examenes          postgres    false    223            8           0    0    examenes_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('examenes.examenes_id_seq', 2, true);
          examenes          postgres    false    225            9           0    0    preguntas_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('examenes.preguntas_id_seq', 30, true);
          examenes          postgres    false    227            :           0    0    respuestas_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('examenes.respuestas_id_seq', 32, true);
          examenes          postgres    false    229            ;           0    0    mensajes_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('mensajes.mensajes_id_seq', 2, true);
          mensajes          postgres    false    232            <           0    0    notificaciones_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('notificaciones.notificaciones_id_seq', 1, false);
          notificaciones          postgres    false    234            =           0    0    puntuaciones_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('puntuaciones.puntuaciones_id_seq', 8, true);
          puntuaciones          postgres    false    236            >           0    0    reportes_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('reportes.reportes_id_seq', 5, true);
          reportes          postgres    false    239            ?           0    0    auditoria_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('seguridad.auditoria_id_seq', 174, true);
       	   seguridad          postgres    false    241            @           0    0    autentication_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('seguridad.autentication_id_seq', 215, true);
       	   seguridad          postgres    false    243            A           0    0    sugerencias_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('sugerencias.sugerencias_id_seq', 32, true);
          sugerencias          postgres    false    246            B           0    0    temas_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('temas.temas_id_seq', 10, true);
          temas          postgres    false    248            )           2606    18263    comentarios comentarios_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT comentarios_pkey PRIMARY KEY (id);
 K   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT comentarios_pkey;
       comentarios            postgres    false    214            +           2606    18265    areas areas_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY cursos.areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (area);
 :   ALTER TABLE ONLY cursos.areas DROP CONSTRAINT areas_pkey;
       cursos            postgres    false    216            -           2606    18267    cursos cursos_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT cursos_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT cursos_pkey;
       cursos            postgres    false    217            /           2606    18269    estados_curso estado_curso_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY cursos.estados_curso
    ADD CONSTRAINT estado_curso_pkey PRIMARY KEY (estado);
 I   ALTER TABLE ONLY cursos.estados_curso DROP CONSTRAINT estado_curso_pkey;
       cursos            postgres    false    219            1           2606    18271 .   inscripciones_cursos inscripciones_cursos_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY cursos.inscripciones_cursos
    ADD CONSTRAINT inscripciones_cursos_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY cursos.inscripciones_cursos DROP CONSTRAINT inscripciones_cursos_pkey;
       cursos            postgres    false    220            3           2606    18273 &   ejecucion_examen ejecucion_examen_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY examenes.ejecucion_examen
    ADD CONSTRAINT ejecucion_examen_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY examenes.ejecucion_examen DROP CONSTRAINT ejecucion_examen_pkey;
       examenes            postgres    false    222            5           2606    18275    examenes examenes_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY examenes.examenes
    ADD CONSTRAINT examenes_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY examenes.examenes DROP CONSTRAINT examenes_pkey;
       examenes            postgres    false    224            7           2606    18277    preguntas preguntas_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY examenes.preguntas
    ADD CONSTRAINT preguntas_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY examenes.preguntas DROP CONSTRAINT preguntas_pkey;
       examenes            postgres    false    226            9           2606    18279    respuestas respuestas_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY examenes.respuestas
    ADD CONSTRAINT respuestas_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY examenes.respuestas DROP CONSTRAINT respuestas_pkey;
       examenes            postgres    false    228            ;           2606    18281 "   tipos_pregunta tipos_pregunta_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY examenes.tipos_pregunta
    ADD CONSTRAINT tipos_pregunta_pkey PRIMARY KEY (tipo);
 N   ALTER TABLE ONLY examenes.tipos_pregunta DROP CONSTRAINT tipos_pregunta_pkey;
       examenes            postgres    false    230            =           2606    18283    mensajes mensajes_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY mensajes.mensajes
    ADD CONSTRAINT mensajes_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY mensajes.mensajes DROP CONSTRAINT mensajes_pkey;
       mensajes            postgres    false    231            ?           2606    18285 "   notificaciones notificaciones_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY notificaciones.notificaciones
    ADD CONSTRAINT notificaciones_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY notificaciones.notificaciones DROP CONSTRAINT notificaciones_pkey;
       notificaciones            postgres    false    233            A           2606    18287    puntuaciones puntuaciones_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY puntuaciones.puntuaciones
    ADD CONSTRAINT puntuaciones_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY puntuaciones.puntuaciones DROP CONSTRAINT puntuaciones_pkey;
       puntuaciones            postgres    false    235            C           2606    18289    motivos motivos_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY reportes.motivos
    ADD CONSTRAINT motivos_pkey PRIMARY KEY (motivo);
 @   ALTER TABLE ONLY reportes.motivos DROP CONSTRAINT motivos_pkey;
       reportes            postgres    false    237            E           2606    18291    reportes reportes_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT reportes_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT reportes_pkey;
       reportes            postgres    false    238            I           2606    18293     autentication autentication_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY seguridad.autentication
    ADD CONSTRAINT autentication_pkey PRIMARY KEY (id);
 M   ALTER TABLE ONLY seguridad.autentication DROP CONSTRAINT autentication_pkey;
    	   seguridad            postgres    false    242            G           2606    18295     auditoria pk_seguridad_auditoria 
   CONSTRAINT     a   ALTER TABLE ONLY seguridad.auditoria
    ADD CONSTRAINT pk_seguridad_auditoria PRIMARY KEY (id);
 M   ALTER TABLE ONLY seguridad.auditoria DROP CONSTRAINT pk_seguridad_auditoria;
    	   seguridad            postgres    false    240            K           2606    18297    sugerencias sugerencias_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY sugerencias.sugerencias
    ADD CONSTRAINT sugerencias_pkey PRIMARY KEY (id);
 K   ALTER TABLE ONLY sugerencias.sugerencias DROP CONSTRAINT sugerencias_pkey;
       sugerencias            postgres    false    245            M           2606    18299    temas temas_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY temas.temas
    ADD CONSTRAINT temas_pkey PRIMARY KEY (id);
 9   ALTER TABLE ONLY temas.temas DROP CONSTRAINT temas_pkey;
       temas            postgres    false    247            O           2606    18301 $   estados_usuario estados_usuario_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY usuarios.estados_usuario
    ADD CONSTRAINT estados_usuario_pkey PRIMARY KEY (estado);
 P   ALTER TABLE ONLY usuarios.estados_usuario DROP CONSTRAINT estados_usuario_pkey;
       usuarios            postgres    false    249            Q           2606    18303    roles roles_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY usuarios.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (rol);
 <   ALTER TABLE ONLY usuarios.roles DROP CONSTRAINT roles_pkey;
       usuarios            postgres    false    250            %           2606    18305 $   usuarios unique_correo_institucional 
   CONSTRAINT     q   ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT unique_correo_institucional UNIQUE (correo_institucional);
 P   ALTER TABLE ONLY usuarios.usuarios DROP CONSTRAINT unique_correo_institucional;
       usuarios            postgres    false    213            '           2606    18307    usuarios usuarios_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (nombre_de_usuario);
 B   ALTER TABLE ONLY usuarios.usuarios DROP CONSTRAINT usuarios_pkey;
       usuarios            postgres    false    213            p           2620    18308    usuarios tg_usuarios_usuarios    TRIGGER     �   CREATE TRIGGER tg_usuarios_usuarios AFTER INSERT OR DELETE OR UPDATE ON usuarios.usuarios FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 8   DROP TRIGGER tg_usuarios_usuarios ON usuarios.usuarios;
       usuarios          postgres    false    213    251            T           2606    18309    comentarios fkcomentario107416    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario107416 FOREIGN KEY (fk_nombre_de_usuario_emisor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario107416;
       comentarios          postgres    false    2855    214    213            U           2606    18314    comentarios fkcomentario298131    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario298131 FOREIGN KEY (fk_id_tema) REFERENCES temas.temas(id);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario298131;
       comentarios          postgres    false    2893    214    247            V           2606    18319    comentarios fkcomentario605734    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario605734 FOREIGN KEY (fk_id_curso) REFERENCES cursos.cursos(id);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario605734;
       comentarios          postgres    false    2861    217    214            W           2606    18324    comentarios fkcomentario954929    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario954929 FOREIGN KEY (fk_id_comentario) REFERENCES comentarios.comentarios(id);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario954929;
       comentarios          postgres    false    2857    214    214            X           2606    18329    cursos fkcursos287281    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT fkcursos287281 FOREIGN KEY (fk_estado) REFERENCES cursos.estados_curso(estado);
 ?   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT fkcursos287281;
       cursos          postgres    false    2863    217    219            Y           2606    18334    cursos fkcursos395447    FK CONSTRAINT     v   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT fkcursos395447 FOREIGN KEY (fk_area) REFERENCES cursos.areas(area);
 ?   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT fkcursos395447;
       cursos          postgres    false    216    217    2859            Z           2606    18339    cursos fkcursos742472    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT fkcursos742472 FOREIGN KEY (fk_creador) REFERENCES usuarios.usuarios(nombre_de_usuario);
 ?   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT fkcursos742472;
       cursos          postgres    false    213    2855    217            [           2606    18344 &   inscripciones_cursos fkinscripcio18320    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.inscripciones_cursos
    ADD CONSTRAINT fkinscripcio18320 FOREIGN KEY (fk_id_curso) REFERENCES cursos.cursos(id);
 P   ALTER TABLE ONLY cursos.inscripciones_cursos DROP CONSTRAINT fkinscripcio18320;
       cursos          postgres    false    220    2861    217            \           2606    18349 '   inscripciones_cursos fkinscripcio893145    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.inscripciones_cursos
    ADD CONSTRAINT fkinscripcio893145 FOREIGN KEY (fk_nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 Q   ALTER TABLE ONLY cursos.inscripciones_cursos DROP CONSTRAINT fkinscripcio893145;
       cursos          postgres    false    2855    213    220            ]           2606    18354 #   ejecucion_examen fkejecucion_455924    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.ejecucion_examen
    ADD CONSTRAINT fkejecucion_455924 FOREIGN KEY (fk_nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 O   ALTER TABLE ONLY examenes.ejecucion_examen DROP CONSTRAINT fkejecucion_455924;
       examenes          postgres    false    222    2855    213            ^           2606    18359 #   ejecucion_examen fkejecucion_678612    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.ejecucion_examen
    ADD CONSTRAINT fkejecucion_678612 FOREIGN KEY (fk_id_examen) REFERENCES examenes.examenes(id);
 O   ALTER TABLE ONLY examenes.ejecucion_examen DROP CONSTRAINT fkejecucion_678612;
       examenes          postgres    false    224    2869    222            _           2606    18364    examenes fkexamenes946263    FK CONSTRAINT     |   ALTER TABLE ONLY examenes.examenes
    ADD CONSTRAINT fkexamenes946263 FOREIGN KEY (fk_id_tema) REFERENCES temas.temas(id);
 E   ALTER TABLE ONLY examenes.examenes DROP CONSTRAINT fkexamenes946263;
       examenes          postgres    false    224    247    2893            `           2606    18369    preguntas fkpreguntas592721    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.preguntas
    ADD CONSTRAINT fkpreguntas592721 FOREIGN KEY (fk_id_examen) REFERENCES examenes.examenes(id);
 G   ALTER TABLE ONLY examenes.preguntas DROP CONSTRAINT fkpreguntas592721;
       examenes          postgres    false    224    226    2869            a           2606    18374    preguntas fkpreguntas985578    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.preguntas
    ADD CONSTRAINT fkpreguntas985578 FOREIGN KEY (fk_tipo_pregunta) REFERENCES examenes.tipos_pregunta(tipo);
 G   ALTER TABLE ONLY examenes.preguntas DROP CONSTRAINT fkpreguntas985578;
       examenes          postgres    false    230    226    2875            b           2606    18379    respuestas fkrespuestas516290    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.respuestas
    ADD CONSTRAINT fkrespuestas516290 FOREIGN KEY (fk_id_preguntas) REFERENCES examenes.preguntas(id);
 I   ALTER TABLE ONLY examenes.respuestas DROP CONSTRAINT fkrespuestas516290;
       examenes          postgres    false    2871    226    228            c           2606    18384    mensajes fkmensajes16841    FK CONSTRAINT     �   ALTER TABLE ONLY mensajes.mensajes
    ADD CONSTRAINT fkmensajes16841 FOREIGN KEY (fk_nombre_de_usuario_receptor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 D   ALTER TABLE ONLY mensajes.mensajes DROP CONSTRAINT fkmensajes16841;
       mensajes          postgres    false    2855    213    231            d           2606    18389    mensajes fkmensajes33437    FK CONSTRAINT     �   ALTER TABLE ONLY mensajes.mensajes
    ADD CONSTRAINT fkmensajes33437 FOREIGN KEY (fk_nombre_de_usuario_emisor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 D   ALTER TABLE ONLY mensajes.mensajes DROP CONSTRAINT fkmensajes33437;
       mensajes          postgres    false    2855    213    231            e           2606    18394 !   notificaciones fknotificaci697604    FK CONSTRAINT     �   ALTER TABLE ONLY notificaciones.notificaciones
    ADD CONSTRAINT fknotificaci697604 FOREIGN KEY (fk_nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 S   ALTER TABLE ONLY notificaciones.notificaciones DROP CONSTRAINT fknotificaci697604;
       notificaciones          postgres    false    2855    233    213            f           2606    18399 %   puntuaciones puntuaciones_emisor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY puntuaciones.puntuaciones
    ADD CONSTRAINT puntuaciones_emisor_fkey FOREIGN KEY (emisor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 U   ALTER TABLE ONLY puntuaciones.puntuaciones DROP CONSTRAINT puntuaciones_emisor_fkey;
       puntuaciones          postgres    false    2855    235    213            g           2606    18404 '   puntuaciones puntuaciones_receptor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY puntuaciones.puntuaciones
    ADD CONSTRAINT puntuaciones_receptor_fkey FOREIGN KEY (receptor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 W   ALTER TABLE ONLY puntuaciones.puntuaciones DROP CONSTRAINT puntuaciones_receptor_fkey;
       puntuaciones          postgres    false    235    2855    213            h           2606    18409    reportes fkreportes338700    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT fkreportes338700 FOREIGN KEY (fk_motivo) REFERENCES reportes.motivos(motivo);
 E   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT fkreportes338700;
       reportes          postgres    false    2883    237    238            i           2606    18414    reportes fkreportes50539    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT fkreportes50539 FOREIGN KEY (fk_nombre_de_usuario_denunciado) REFERENCES usuarios.usuarios(nombre_de_usuario);
 D   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT fkreportes50539;
       reportes          postgres    false    2855    213    238            j           2606    18419    reportes fkreportes843275    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT fkreportes843275 FOREIGN KEY (fk_nombre_de_usuario_denunciante) REFERENCES usuarios.usuarios(nombre_de_usuario);
 E   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT fkreportes843275;
       reportes          postgres    false    213    238    2855            k           2606    18424 '   reportes reportes_fk_id_comentario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT reportes_fk_id_comentario_fkey FOREIGN KEY (fk_id_comentario) REFERENCES comentarios.comentarios(id);
 S   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT reportes_fk_id_comentario_fkey;
       reportes          postgres    false    238    214    2857            l           2606    18429 $   reportes reportes_fk_id_mensaje_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT reportes_fk_id_mensaje_fkey FOREIGN KEY (fk_id_mensaje) REFERENCES mensajes.mensajes(id);
 P   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT reportes_fk_id_mensaje_fkey;
       reportes          postgres    false    231    2877    238            m           2606    18434 '   autentication fk_autentication_usuarios    FK CONSTRAINT     �   ALTER TABLE ONLY seguridad.autentication
    ADD CONSTRAINT fk_autentication_usuarios FOREIGN KEY (nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 T   ALTER TABLE ONLY seguridad.autentication DROP CONSTRAINT fk_autentication_usuarios;
    	   seguridad          postgres    false    242    213    2855            n           2606    18439    sugerencias fksugerencia433827    FK CONSTRAINT     �   ALTER TABLE ONLY sugerencias.sugerencias
    ADD CONSTRAINT fksugerencia433827 FOREIGN KEY (fk_nombre_de_usuario_emisor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 M   ALTER TABLE ONLY sugerencias.sugerencias DROP CONSTRAINT fksugerencia433827;
       sugerencias          postgres    false    245    213    2855            o           2606    18444    temas fktemas249223    FK CONSTRAINT     v   ALTER TABLE ONLY temas.temas
    ADD CONSTRAINT fktemas249223 FOREIGN KEY (fk_id_curso) REFERENCES cursos.cursos(id);
 <   ALTER TABLE ONLY temas.temas DROP CONSTRAINT fktemas249223;
       temas          postgres    false    217    2861    247            R           2606    18449    usuarios fkusuarios355026    FK CONSTRAINT     |   ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT fkusuarios355026 FOREIGN KEY (fk_rol) REFERENCES usuarios.roles(rol);
 E   ALTER TABLE ONLY usuarios.usuarios DROP CONSTRAINT fkusuarios355026;
       usuarios          postgres    false    2897    250    213            S           2606    18454    usuarios fkusuarios94770    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT fkusuarios94770 FOREIGN KEY (fk_estado) REFERENCES usuarios.estados_usuario(estado);
 D   ALTER TABLE ONLY usuarios.usuarios DROP CONSTRAINT fkusuarios94770;
       usuarios          postgres    false    2895    249    213            �   c   x�3�t+J�K�4�4������ITH���WH-.I,�4202�50�54�rC���BUC�������)A���Sb�T��^b����4�f������� ��4�      �   k   x�s�L�K�L,Vp:��839���N?(5���8�X�371=5/�H���/v,JM,�wFסW����T��Ztxm"A��B��d��a3TX�IQ>a`U`�1z\\\ ?�X�      �   �   x�u�K
�0�����@el�p�(�� �nB�b�#�I�����Zt%��_�$9ucacMWXMr=���@�>�-y�[1���ΙD�BU���,�ӞCi]��Wgh|3Ɣq�s&�U�B�x5��ݗ�\xOc�A�*é"����%�v����?8i���Гc��3Pq�sVu
��4$�n:,K#5���N�B�DVf      �      x�KL.�,������ �9      �   :   x�3�t+J�K�4�4202�50�56�2�
BM��˘�73�45�����Y"F��� 8��      �   �   x�����0���)jg �D6�$F݀�
��R���b���,�Ht��.���hc�.C�͸����Gn��	Ɨ��|�%(}�#4��Ȫם�ݎ��Q��&㠡�ȶ�e;,���F)e4Z$���屨;ś��g�f�J�@)�,s���%������c]IE�Rt��ĝkSM�g���kW      �   )   x�3�4�4204�50�52�2�4r�tLu���b���� d�~      �   �   x���;�0���>*E�1!����:��8i$"�I��a�
]���0�����ߟ]�E%��@��d@{��F&��Ą�q?��&®9��T֋�R��>{�<^�{�	�I�Ck���|M[:e�l_����&|�����T�#�'�m�-`�g{��
���
E�*>�+�J��?�2ͷ�� �J�&R�'��m>      �   �   x�32�42���KO��L-:�6Q!%U!8?��<�(�����$�X��{xaIfrb1gP�)��J�؀�Ȝ3,�(%$k�9�&e���̰ T��8� NP~V��gl�	Ԝb�XI@�1z\\\ {)(~         M   x��=�+�$� 'U!9?O����D�������D._�\8��1)3�H��d&g���($%gd��s��qqq ��%q         g   x�3�t+J�K���L/M�150��/)JT(K�R(-.IMQ�Kp��q���*X�P��I/Ĭ�T�\ ���Z\����_�������x̉���� �:'=            x������ � �         1   x�3�t+J�K��N���4���M,.I-���L/M�150�4����� ��
�         H   x�s/�/N-�L,��OK�+N,VH�Q(-.M,���
p��r��+I��L�W�6� �JI-Rp/*-������ !@�      	   �   x�e�;�0D��)�GA��RD�D*�h�x��7��'�"(کF��� �`���{���B��}"�,�N�N=RL�=a;d�7;�B�P"�2��8�1�qE������e�;�z�f�%��z:�[��Ooxe�H�����}q=ֺ�B�n�6��n2����b��,�UjM�            x��]�rǕ�-?�J���>����:��8��r�I�����1E* ����}�}�<C^l�H@$PP�L�=}z��kw�#T�>T�!��`GbG�EH�>����~�����ڏ�.'7�뗏^]N�^����?y�'�.��ϗOF��\_�4��?���x����tq�!�`]���!��oeQ���yB��zVF;������ɥ��a2�����|ၳYՏ&i29��y������7����˛_J�Wi���؇���}(�VGxu}qu=��� g/��"J��|v������e�pq�����ĳ����t�)���t{�'7�?����|�K�����x*��A�U:??[���͓b����N�ݩ�~��_\��]Lǘ??��������E8{y�.�.����#L1��A��w}~U�򇗗�,���k.��2�����u��?�L�O���P�)�~���7)^7����<�>�[�v�n�ƈ3J?����>����*���������}��_�x	勿���C����������_��F�/~q=�����3_B��@�`I�5:�ZΞj�<ߕ��4�;��:�P�C�Xm��n4���L�_?u_?�ó���+�^���*a�t�5�N.��]A�5����1��U�"h�A0y/'�?:��7�B�|@���	G�����|�	���#�O���x��>F���H90��ד���|����d?��߾��*??�LI'E���%iKHQ|��8H�Sk�(�'ZL�bk��H����9�Ѐ��|�7��P��vg�߄�[��� ~���S�Pd�G#{���t4l��n\��{���7����&����o�j�Y��FY�1 ��g�"�L�)���Bq��>P냊Eq�OTY���=q�Qq�T`I��\o;�5bӰ6ag�߄�����'�0\�G�z��R�Ѳ�_�\�񳏿�ꛜ~��?�~YA��Ķ>���0�����@R���23����Hkֶ��)��zO���h~�'Ň����Fh]��v��7A{�{{D���W�������/���1Ȉy$�(e�����㕪���_�|9~�U�K�On��d5��7r�"=����O�8{q��E�'k�;E�k�u|"*z<R��p�*Y/�-ݞ�,��F�q��f�������ß���O�������
��b��.Z���L�`����zR��C[ȁb���4r�&$�f����M�$N+8d>nլF�uV,8���m��������{Ư�f��:�@0bj�8T;.66&1�82�^\ �Q'/�M���x@Z�"��6��*mM���1R�ArX1����$�I�C�o���s�^c
����籿��O�d�y%��K�������X������ς�rUMN�I0H@�3��"�mA�����p�Gg��sq��a0���=�eT�KpzH�E�������k��#o��r���:J��o�@�Kn��������~$��ІM<�6�?�?b�x���n���"��/T��q�ؑr���n1xy���3�
���Oο{��?�Z��$��4�[��nb��:L� �6�u�C��c�Zpb��勆c�G������z�n���`��[O|��y�����׾'�m�X��`q9Hv��Mx�E����1��z%XM�������d�i��O��֌ጁ[��#�sW��c�7��.H��qju�Z���o[
ڤ��m&p��؂(*�@ή����?�����L�$O&9N���-39�ӭ�H5���^�~�&��-�Q��Mc�`�n��?�#����W�{'>�3�݄�aH|��'�w �;�oL�*�G��E�7��������",) ��U���}����ϫ������:�L�aQ������.1��K��o���ϓ�/�L>{n/��
�=�MC6�*�1[d��Z���Ӿ��*�`�[�<]~���G�g;�I;P�vK{�4�6���Cv_!v�mj���%����&tߢ���H��6�����C'���q=�`�`j�XM�*N^�D��~����~N����R�|�?�vU��i��c�%6�m�lD��uJ�VQ\BL9%*���&����`y�a��m-
��%y|^����2G�܁u�3��+�(�����hߢ����= �U�GI~�������U��86ba�.#�s�\}�8[�dr�� �P޺ж^�(��xŶxA�-?\~#�f�����al��OA^VJ���A�y݅w��jĉ6����j��#�O�r����.}o]��ͲF�iP��Gz#��L��i���c\vޘz�րmK�"GD�.)g�E��a˔�{��? ���owP��v�]O�p�2����w�A~"�H�=ta8�w]����
N�'�m&��Ҩ� ���e�1���r�AQ&��X�T�1�+����)�WXac��C:����.�j4���9�#�O|�����*F���Q��N�c��Z��[�WQ$�Ͷ6�Dڤj?ʈU�lՆ��=+3��e�G� "��w'+IY��H�!5g���ۘ\H1���V�RT6RƛV�>��G_��բ͠�r4a�#�F�<\�j��>Y�w�(q+v7��b�-<3��B��vZW�	�kU[�70V�L�FB��Ĭ}hYLt��q	���C�p7??�����`���o�K��Y�����wq�A~�����х�_:�%���:0j�m�	��۴.1%bG�ĭJ�&eŎ@[��.|��	�9�T{�N����PaU��
p�$|݅����i��pN�A~"�F�=ua8�7�U���e	�J�����1&�d�X�DЌVyJѵ��єHX�u�݉����g�",o��uh�]�v5Z�m-�pg���'�x��G�#|��b�Z��,�H��E��h���y
I8&NT�!gc��+m�f�B^�s}J`|��K�������J
�H򬺐�۠���c��]$�G`�H���{�0b��[q���6Fܣ��k����r�]#$�>�aY��뽦ر��Ĉ&;BU��"��;����EPغ�{��q�D�RJd ���3#vk9də�iW>�	#7\��}�cĎ���`v���T�%�h�v�Ph#�gH�%�[��8:����1�ۢ*��u"��a�%���N�~D�^��"��әzB����놙���.���}��>�� �>��إ�\��c@������h���M=��c�9W��#x�Nc"[���������`���|�������������6�����j8��#�O$��J�ta8�7]��z�����)��3d�,��
�5��T�BN*��p��J*�MlY����8���V
�A/I�nmYt�!�����=��D������p�߭-����B�"uCVǬYX�V
�Ig��(CBXL�{ۘ�6�O��F��?:���O�?y�6ŇŃ^	-�:�ؑ�M��	��3��'�x��G��9C��̪Ӌ��}JδL<{�,���6dK�s�����[%�z����J�A*�N�ڜ[cum(z�M�DT(��#������p[��[�Z�
��w��̼}���g_=���֌�(�;��S��W	v�\;�QJр{!����f�P� ���~��x	u��N�X!�t�g̢L�4P�6)�A<���s�Z�Kڥ��Vڗ�>DL':?
:���U��!霻h���M�=�{��v�>��ѳy��沌��Ĥ�!T5T ��R�����5���z�a��[�Z�N��&�[ˠN��=N���9�`I��spȶ!�UQ�;EK�_<t���������c�7����������p�n���lc5�I� %�^����Z\�Vs�R��?��^Uۢ��� ^�h[R��j��J�:�$i�t[�!y�v-��DoX�`��GX�X���Է��F�p��:P�Sֻ�i��ֽ�
�#pV9�z��-8ž�m�NǨ�{\�(͐C��e�p����9� y��V]HSu׭S}�ޝ݁L��;rD���A�㏘��<l���F�F�!�a6 b
  Ϗ�����	s���
����ӻ��Q�C�����D�� �qq�Q�M�A�w	tjCΎ��r����p�j=�&����J�!��vU��֮��c��b�l��J��{�����ކEӲ�]�Ɩ�ARLh3R����Ht�D��[c�"&I>�P�^E��j5�����I�c�x��
(o���qj݁7R=�ѹ�2P{���� ��
��YVѵ��� �q�dm�wT_��gr�FML�RJ�42�X��>ӂ'�B�����c�F�k(���m�z�\�',��W f���'ۑ�lF�3#�z�B��`fg���f��T�Y�/mS��1����y��z�5*�P��IM0�>䠼H��&l����=߈�-#@������������`6ukh�n ߎ0�S��IְC�.�����a'�?q�Nܿ�����<h��o�$�*���X�xc`�O-@��a�">�-��F0%��׿H���8�%���������M���ŋ�0kM��b|V�{?+�� �z�-�	%J�5v�H7U��ދ-(R���l6w�MjzJ�E�t.���3ҝXYj	�zZ�Z��ʴ�1^\�-mB���l|n:-���	�<XyjM;���n�K��-e�[*�k<ᾎ	x�+��˽I��}���ꊵ��=�q�H>T�e�'�6Hŉ��y5����Gߦp=�\N>�l��4����w�����~R4��۫O6�4[���żi�u$�i�^+��W��@Nu��� Pl����ʵ�%��=�����qeL�;��ɗ�+���n������l Z�\��X�;�y7_>w%3��1�:mU�w��^�U�@���5��-ɤ�*07Łv��5�t%�uTիb��T���I�*a-[���p=IV\���D�TG4PSCD����x'Q
��A�U^>�5 �;R�h,$����h<Bl�H���?wE+��kj���ߚtD#�-oͱ= �yk]��Pw2�K�d+��kF��� �:�Au�S��/��V�T׎�q�����l7#��6s=KX�k��QlC����g��y� �(��kG�3Zp�,V>�vێ�i�,?�.Z�qW4*�DcH�j������*�L�$@l���_��H�;��q�`������\`o󸦡g.�h������>�?�uLP�mo��K�7�_��T������a@�(�[��ng��6�m$�i��%�u�ߤ��&�0��h�ݝE�+���7Z�X�cMQ�>��q^�>�������?�����w�[YZ��ҡ��*p��YP�u�6YlP9:�2��&!/Z�z�;Kc���٫7y���.�u��_g���>-�χL{>�|�1VL�%����B@/0�T=��rݰ�6�#����fpZ��N9�ܲqw,�m7C��C/$�K����@Қz�2=�w�J/��ﻰ���#m�#�I����}O�&��Ո�?�|�; Y��4��aз�?`�����E`N}�MDի�(�4On�^	���������Ϟ}��^����
'D��1���	�%D������mm���8�D�-� 9oONȃtBf���.�s`'�Ԣ�̯�RS���&UY����d��GCt�^�mCD�B��qNkmv3D��������$����u��
Cd��>���rm�SH��~��gV�tsƢp�J��[	Ѹ���*�oCt~����弝��^c�Z;���!\T�zj��g�Ӷk� ��Hn���E��F��Ȕ�+�Ж#Ig���������GҷF���*�ЦN��y?2;�jj�;R�s7��V��Ŵ/�$�q�һ�a6��HzD��X��H<���P�c����ީ��8N�.��G�;�:���w��ܭ�z�i�\�Nw`ϑ~Y�k�ݵ�6�sNm����ΧC��ck�mä�wG_�W+_E��^���Թ3u���dI!���f����yTjT5%�k��7:[��otiF�3#����h����M������m��w-�����?��뗽�8��-����((qz�6�vܝr��L�N3Y�=���<�Ϯ;!�iXk�)ok�Du�1�Mhv��3��ظ��դV[����|ay�����M�#{�Sn�z>#\��pCdt�6�=M��S)�}��,A��M�X���	wj�u34h�}Ve�C�3�����h{7��Gҝ�j#-� �ˏ��tK���V�pۅtb�#A�g��6�A�-@oO�/�,�Lͥw]�n�r��;4�#��Vz�-}߅]��z�,=KQ2��;��H߷�����[���(��aNSWz!7������;�'�����������v�%X����X\�]&=��m�7}�ｰ���L���"=����Z�/���jk�mo���(��KߵC�}Vk���Q�!=n+��'��(��K�d;u���Ü�Ӗғ�-}߅]�~� �%{?��J N���o��SO{���.�2���^�����Y,^-�O�m��i�X�E����ܲ���`D7�����]R��8�@w�-���U[V8���4�<���x�b�|���y{;"�!�����kNUY��]ičg�l�I�t�ʲ�kYY-�sV�F�}$Z�(��ӀxC�e}	���m��0�V�տ6|���8Np6         i  x���Kn�0�|�\ �̐��.(�]{�l��aYmْ����T-Z��|C�ѩ�{~�K��j+@ e�-}C�[����z!��"A��ȳX���<�a>w�X��p�,0(h�6�trM灅V��d?ٜl�'h���e�
�F�yTӤ�T���|��J��¡11�ǶK�����(Y���&�T�8�� �̏�� SmV8��[&�h<���uz�䘇��� �F�մ��a����r�V{i�I����Ѷ�K-H)�ౝr]W;~�c���ؔ�I��1o�#���\�Zɬ�QM�m/y(�*i3~W[ؾ9������+NZ��nL���??�p��%��~�tQ��e2Q�[y�8K��:)���W�d�il���u_��t(�躔/��+)X���E���풗m7O�J�7]5�@m!M&X��dy���s�Ǣ�ІӜW�T�uL1QV^�ȴ1�'�<-���K�S>w%\ot���(S�,c�_�6��(�^^��V��\싡/��a��8E<m�"��ب�2����AM�7u=�(�D�,o��+�u�������0�T�U�4�q�2'�n��1ӯ1;��X5���_�f#���m�!6��O�r
1         �  x��SM��0=����[͌?��J-B��mۃ���*M�$]���1�Ni7�
qY���yC���|�?�fY��eyؑ����_�Wˬ]-_��O��n�����S�5ݟ����_�w��o}���[��+�3!=���6Y���X5�%,@,'�-@9r�����=˲�n�8� $�V��H�B:L�uu�E1`�<�b�"P)��*bd(��zG|GN�#݅���=���ř�LR�4�4&J���&�O�Ӕ�$\Y.(�`$�Ix`3�5L*
�4E���-oo�����1�6��}���}�q�o|U5W@X5)�(B��k�tߧ��I9S����Ǧ.��n�*�X�4��'�^v��ͱ�3P������� I�;��#*%��ߊc ���{_��b3p���I�#-�"���`���f���T�         �  x�}R�n�@<{��?�
�%@�"Aǀ" ����]5Ϙ���7{���W���nv7Bly��{��}Z���$���3}��({���@͸�M�#9]I�`HM}`r��f>
S}Ճ4�vv:Hʘ9pR^bfM��t'ɝ4%Sc�y4X�]�r(T����K»�m�+�bp>�n�ώ�h���W��s_�{ӱ�=�2Ld6�I֓N��2	|FH<N9n��B�ः<H,RS�`�)�+���6} 0�5�F?�)�Y��Ѓ��jB`VA������ ��� ��V��L��9��`b@̟��c����$�Mۀ����ع��_=��#>�Q?77�6��i;䮘�4����86#���/a*�E��0�i%�#��,��`:/��/��F<��U�ˋ�m2}�:��0�+�.�q̧���k@׽�Wo�]Z��K��3���W��m�n*ߞ,����8�         C   x�ɱ�0����LD�8DB���t'u�ϡ�i��UXR�	WR��?��9��s.��,�         +   x�+(��MM���JL����,.)JL�/�*-.M,���qqq ��      �   W  x�}�MN�0�דS�I��IꮊH�U�b7�����Yt�}X�����
T��?����;	�:4R6�|հ�h�P�V^\�1��,,t��	+pyj ��>@���&c�Ť�5�~T���]Iȹ]��~�W���oã�:���hТ]��).�hLwI�a�A�9�IL�8���^��EBYQe%�G�p����(|��k�������G�A���9L\�`Ѳ:Vk�JY��lNkؼ
P��I�++��wD�K%�h�ks��u�|X��-l��?�W����=�K��s6�X
Z�[��3V����V(aӵ0;�=�l8�A���S����n�(�� i��     