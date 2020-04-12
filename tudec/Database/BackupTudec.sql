PGDMP     	    9                x            tudec    12.2    12.2 �               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            	           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            
           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    189099    tudec    DATABASE     �   CREATE DATABASE tudec WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Spanish_Spain.1252' LC_CTYPE = 'Spanish_Spain.1252';
    DROP DATABASE tudec;
                postgres    false                        2615    189100    comentarios    SCHEMA        CREATE SCHEMA comentarios;
    DROP SCHEMA comentarios;
                postgres    false                        2615    189101    cursos    SCHEMA        CREATE SCHEMA cursos;
    DROP SCHEMA cursos;
                postgres    false                        2615    189102    examenes    SCHEMA        CREATE SCHEMA examenes;
    DROP SCHEMA examenes;
                postgres    false                        2615    189103    mensajes    SCHEMA        CREATE SCHEMA mensajes;
    DROP SCHEMA mensajes;
                postgres    false            
            2615    189104    notificaciones    SCHEMA        CREATE SCHEMA notificaciones;
    DROP SCHEMA notificaciones;
                postgres    false            	            2615    189105    reportes    SCHEMA        CREATE SCHEMA reportes;
    DROP SCHEMA reportes;
                postgres    false                        2615    189430 	   seguridad    SCHEMA        CREATE SCHEMA seguridad;
    DROP SCHEMA seguridad;
                postgres    false                        2615    189106    sugerencias    SCHEMA        CREATE SCHEMA sugerencias;
    DROP SCHEMA sugerencias;
                postgres    false                        2615    189107    temas    SCHEMA        CREATE SCHEMA temas;
    DROP SCHEMA temas;
                postgres    false                        2615    189108    usuarios    SCHEMA        CREATE SCHEMA usuarios;
    DROP SCHEMA usuarios;
                postgres    false            �            1255    189482    f_log_auditoria()    FUNCTION     �  CREATE FUNCTION seguridad.f_log_auditoria() RETURNS trigger
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
    	   seguridad          postgres    false    14            �            1259    189238    usuarios    TABLE     7  CREATE TABLE usuarios.usuarios (
    nombre_de_usuario text NOT NULL,
    fk_rol text NOT NULL,
    fk_estado text NOT NULL,
    primer_nombre text NOT NULL,
    segundo_nombre text,
    primer_apellido text NOT NULL,
    segundo_apellido text,
    correo_institucional text NOT NULL,
    pass text NOT NULL,
    fecha_desbloqueo date,
    puntuacion integer,
    token text NOT NULL,
    imagen_perfil text,
    fecha_creacion date NOT NULL,
    ultima_modificacion timestamp without time zone,
    vencimiento_token timestamp without time zone,
    session text
);
    DROP TABLE usuarios.usuarios;
       usuarios         heap    postgres    false    12                       1255    197288 i   field_audit(usuarios.usuarios, usuarios.usuarios, character varying, text, character varying, text, text)    FUNCTION     �  CREATE FUNCTION seguridad.field_audit(_data_new usuarios.usuarios, _data_old usuarios.usuarios, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
    	   seguridad          postgres    false    14    242    242            �            1259    189109    comentarios    TABLE       CREATE TABLE comentarios.comentarios (
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
       comentarios         heap    postgres    false    16            �            1259    189115    comentarios_id_seq    SEQUENCE     �   CREATE SEQUENCE comentarios.comentarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE comentarios.comentarios_id_seq;
       comentarios          postgres    false    212    16                       0    0    comentarios_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE comentarios.comentarios_id_seq OWNED BY comentarios.comentarios.id;
          comentarios          postgres    false    213            �            1259    189117    areas    TABLE     O   CREATE TABLE cursos.areas (
    area text NOT NULL,
    icono text NOT NULL
);
    DROP TABLE cursos.areas;
       cursos         heap    postgres    false    15            �            1259    189123    cursos    TABLE     .  CREATE TABLE cursos.cursos (
    id integer NOT NULL,
    fk_creador text NOT NULL,
    fk_area text NOT NULL,
    fk_estado text NOT NULL,
    nombre text NOT NULL,
    fecha_de_creacion date NOT NULL,
    fecha_de_inicio date NOT NULL,
    codigo_inscripcion text NOT NULL,
    puntuacion integer
);
    DROP TABLE cursos.cursos;
       cursos         heap    postgres    false    15            �            1259    189129    cursos_id_seq    SEQUENCE     �   CREATE SEQUENCE cursos.cursos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE cursos.cursos_id_seq;
       cursos          postgres    false    215    15                       0    0    cursos_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE cursos.cursos_id_seq OWNED BY cursos.cursos.id;
          cursos          postgres    false    216            �            1259    189131    estados_curso    TABLE     @   CREATE TABLE cursos.estados_curso (
    estado text NOT NULL
);
 !   DROP TABLE cursos.estados_curso;
       cursos         heap    postgres    false    15            �            1259    189137    inscripciones_cursos    TABLE     �   CREATE TABLE cursos.inscripciones_cursos (
    id integer NOT NULL,
    fk_nombre_de_usuario text NOT NULL,
    fk_id_curso integer NOT NULL,
    fecha_de_inscripcion date NOT NULL
);
 (   DROP TABLE cursos.inscripciones_cursos;
       cursos         heap    postgres    false    15            �            1259    189143    inscripciones_cursos_id_seq    SEQUENCE     �   CREATE SEQUENCE cursos.inscripciones_cursos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE cursos.inscripciones_cursos_id_seq;
       cursos          postgres    false    15    218                       0    0    inscripciones_cursos_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE cursos.inscripciones_cursos_id_seq OWNED BY cursos.inscripciones_cursos.id;
          cursos          postgres    false    219            �            1259    189145    ejecucion_examen    TABLE     �   CREATE TABLE examenes.ejecucion_examen (
    id integer NOT NULL,
    fk_nombre_de_usuario text NOT NULL,
    fk_id_examen integer NOT NULL,
    fecha_de_ejecucion date NOT NULL,
    calificacion integer NOT NULL
);
 &   DROP TABLE examenes.ejecucion_examen;
       examenes         heap    postgres    false    5            �            1259    189151    ejecucion_examen_id_seq    SEQUENCE     �   CREATE SEQUENCE examenes.ejecucion_examen_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE examenes.ejecucion_examen_id_seq;
       examenes          postgres    false    220    5                       0    0    ejecucion_examen_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE examenes.ejecucion_examen_id_seq OWNED BY examenes.ejecucion_examen.id;
          examenes          postgres    false    221            �            1259    189153    examenes    TABLE     �   CREATE TABLE examenes.examenes (
    id integer NOT NULL,
    fk_id_tema integer NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_fin date NOT NULL
);
    DROP TABLE examenes.examenes;
       examenes         heap    postgres    false    5            �            1259    189156    examenes_id_seq    SEQUENCE     �   CREATE SEQUENCE examenes.examenes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE examenes.examenes_id_seq;
       examenes          postgres    false    5    222                       0    0    examenes_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE examenes.examenes_id_seq OWNED BY examenes.examenes.id;
          examenes          postgres    false    223            �            1259    189158 	   preguntas    TABLE     �   CREATE TABLE examenes.preguntas (
    id integer NOT NULL,
    fk_id_examen integer NOT NULL,
    fk_tipo_pregunta text NOT NULL,
    pregunta text NOT NULL,
    porcentaje integer NOT NULL
);
    DROP TABLE examenes.preguntas;
       examenes         heap    postgres    false    5            �            1259    189164    preguntas_id_seq    SEQUENCE     �   CREATE SEQUENCE examenes.preguntas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE examenes.preguntas_id_seq;
       examenes          postgres    false    224    5                       0    0    preguntas_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE examenes.preguntas_id_seq OWNED BY examenes.preguntas.id;
          examenes          postgres    false    225            �            1259    189166 
   respuestas    TABLE     �   CREATE TABLE examenes.respuestas (
    id integer NOT NULL,
    fk_id_preguntas integer NOT NULL,
    respuesta text NOT NULL
);
     DROP TABLE examenes.respuestas;
       examenes         heap    postgres    false    5            �            1259    189172    respuestas_id_seq    SEQUENCE     �   CREATE SEQUENCE examenes.respuestas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE examenes.respuestas_id_seq;
       examenes          postgres    false    5    226                       0    0    respuestas_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE examenes.respuestas_id_seq OWNED BY examenes.respuestas.id;
          examenes          postgres    false    227            �            1259    189174    tipos_pregunta    TABLE     A   CREATE TABLE examenes.tipos_pregunta (
    tipo text NOT NULL
);
 $   DROP TABLE examenes.tipos_pregunta;
       examenes         heap    postgres    false    5            �            1259    189180    mensajes    TABLE     �   CREATE TABLE mensajes.mensajes (
    id integer NOT NULL,
    fk_nombre_de_usuario_emisor text NOT NULL,
    fk_nombre_de_usuario_receptor text NOT NULL,
    contenido text NOT NULL,
    imagenes text[]
);
    DROP TABLE mensajes.mensajes;
       mensajes         heap    postgres    false    17            �            1259    189186    mensajes_id_seq    SEQUENCE     �   CREATE SEQUENCE mensajes.mensajes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE mensajes.mensajes_id_seq;
       mensajes          postgres    false    17    229                       0    0    mensajes_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE mensajes.mensajes_id_seq OWNED BY mensajes.mensajes.id;
          mensajes          postgres    false    230            �            1259    189188    notificaciones    TABLE     �   CREATE TABLE notificaciones.notificaciones (
    id integer NOT NULL,
    mensaje text NOT NULL,
    estado boolean NOT NULL,
    fk_nombre_de_usuario text NOT NULL
);
 *   DROP TABLE notificaciones.notificaciones;
       notificaciones         heap    postgres    false    10            �            1259    189194    notificaciones_id_seq    SEQUENCE     �   CREATE SEQUENCE notificaciones.notificaciones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE notificaciones.notificaciones_id_seq;
       notificaciones          postgres    false    231    10                       0    0    notificaciones_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE notificaciones.notificaciones_id_seq OWNED BY notificaciones.notificaciones.id;
          notificaciones          postgres    false    232            �            1259    189196    motivos    TABLE     <   CREATE TABLE reportes.motivos (
    motivo text NOT NULL
);
    DROP TABLE reportes.motivos;
       reportes         heap    postgres    false    9            �            1259    189202    reportes    TABLE     J  CREATE TABLE reportes.reportes (
    id integer NOT NULL,
    fk_nombre_de_usuario_denunciante text NOT NULL,
    fk_nombre_de_usuario_denunciado text NOT NULL,
    fk_motivo text NOT NULL,
    descripcion text NOT NULL,
    estado boolean NOT NULL,
    fk_id_comentario integer,
    fk_id_mensaje integer,
    imagenes text[]
);
    DROP TABLE reportes.reportes;
       reportes         heap    postgres    false    9            �            1259    189208    reportes_id_seq    SEQUENCE     �   CREATE SEQUENCE reportes.reportes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE reportes.reportes_id_seq;
       reportes          postgres    false    234    9                       0    0    reportes_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE reportes.reportes_id_seq OWNED BY reportes.reportes.id;
          reportes          postgres    false    235            �            1259    189473 	   auditoria    TABLE     L  CREATE TABLE seguridad.auditoria (
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
    	   seguridad         heap    postgres    false    14                       0    0    TABLE auditoria    COMMENT     b   COMMENT ON TABLE seguridad.auditoria IS 'Tabla que almacena la trazabilidad de la informaicón.';
       	   seguridad          postgres    false    246                       0    0    COLUMN auditoria.id    COMMENT     E   COMMENT ON COLUMN seguridad.auditoria.id IS 'campo pk de la tabla ';
       	   seguridad          postgres    false    246                       0    0    COLUMN auditoria.fecha    COMMENT     [   COMMENT ON COLUMN seguridad.auditoria.fecha IS 'ALmacen ala la fecha de la modificación';
       	   seguridad          postgres    false    246                       0    0    COLUMN auditoria.accion    COMMENT     g   COMMENT ON COLUMN seguridad.auditoria.accion IS 'Almacena la accion que se ejecuto sobre el registro';
       	   seguridad          postgres    false    246                       0    0    COLUMN auditoria.schema    COMMENT     n   COMMENT ON COLUMN seguridad.auditoria.schema IS 'Almanena el nomnbre del schema de la tabla que se modifico';
       	   seguridad          postgres    false    246                       0    0    COLUMN auditoria.tabla    COMMENT     a   COMMENT ON COLUMN seguridad.auditoria.tabla IS 'Almacena el nombre de la tabla que se modifico';
       	   seguridad          postgres    false    246                       0    0    COLUMN auditoria.session    COMMENT     q   COMMENT ON COLUMN seguridad.auditoria.session IS 'Campo que almacena el id de la session que generó el cambio';
       	   seguridad          postgres    false    246                       0    0    COLUMN auditoria.user_bd    COMMENT     �   COMMENT ON COLUMN seguridad.auditoria.user_bd IS 'Campo que almacena el user que se autentico en el motor para generar el cmabio';
       	   seguridad          postgres    false    246                       0    0    COLUMN auditoria.data    COMMENT     e   COMMENT ON COLUMN seguridad.auditoria.data IS 'campo que almacena la modificaicón que se realizó';
       	   seguridad          postgres    false    246                       0    0    COLUMN auditoria.pk    COMMENT     X   COMMENT ON COLUMN seguridad.auditoria.pk IS 'Campo que identifica el id del registro.';
       	   seguridad          postgres    false    246            �            1259    189471    auditoria_id_seq    SEQUENCE     |   CREATE SEQUENCE seguridad.auditoria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE seguridad.auditoria_id_seq;
    	   seguridad          postgres    false    14    246                        0    0    auditoria_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE seguridad.auditoria_id_seq OWNED BY seguridad.auditoria.id;
       	   seguridad          postgres    false    245            �            1259    189444    autentication    TABLE     �   CREATE TABLE seguridad.autentication (
    id integer NOT NULL,
    nombre_de_usuario text NOT NULL,
    ip text,
    mac text,
    fecha_inicio timestamp without time zone,
    fecha_fin timestamp without time zone,
    session text
);
 $   DROP TABLE seguridad.autentication;
    	   seguridad         heap    postgres    false    14            �            1259    189442    autentication_id_seq    SEQUENCE     �   CREATE SEQUENCE seguridad.autentication_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE seguridad.autentication_id_seq;
    	   seguridad          postgres    false    244    14            !           0    0    autentication_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE seguridad.autentication_id_seq OWNED BY seguridad.autentication.id;
       	   seguridad          postgres    false    243            �            1259    189484    function_db_view    VIEW     �  CREATE VIEW seguridad.function_db_view AS
 SELECT pp.proname AS b_function,
    oidvectortypes(pp.proargtypes) AS b_type_parameters
   FROM (pg_proc pp
     JOIN pg_namespace pn ON ((pn.oid = pp.pronamespace)))
  WHERE ((pn.nspname)::text <> ALL (ARRAY[('pg_catalog'::character varying)::text, ('information_schema'::character varying)::text, ('admin_control'::character varying)::text, ('vial'::character varying)::text]));
 &   DROP VIEW seguridad.function_db_view;
    	   seguridad          postgres    false    14            �            1259    189210    sugerencias    TABLE     �   CREATE TABLE sugerencias.sugerencias (
    id integer NOT NULL,
    fk_nombre_de_usuario_emisor text,
    contenido text NOT NULL,
    estado boolean NOT NULL,
    imagenes text[]
);
 $   DROP TABLE sugerencias.sugerencias;
       sugerencias         heap    postgres    false    8            �            1259    189216    sugerencias_id_seq    SEQUENCE     �   CREATE SEQUENCE sugerencias.sugerencias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE sugerencias.sugerencias_id_seq;
       sugerencias          postgres    false    8    236            "           0    0    sugerencias_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE sugerencias.sugerencias_id_seq OWNED BY sugerencias.sugerencias.id;
          sugerencias          postgres    false    237            �            1259    189218    temas    TABLE     �   CREATE TABLE temas.temas (
    id integer NOT NULL,
    fk_id_curso integer NOT NULL,
    titulo text NOT NULL,
    informacion text NOT NULL,
    imagenes text[]
);
    DROP TABLE temas.temas;
       temas         heap    postgres    false    7            �            1259    189224    temas_id_seq    SEQUENCE     �   CREATE SEQUENCE temas.temas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE temas.temas_id_seq;
       temas          postgres    false    238    7            #           0    0    temas_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE temas.temas_id_seq OWNED BY temas.temas.id;
          temas          postgres    false    239            �            1259    189226    estados_usuario    TABLE     D   CREATE TABLE usuarios.estados_usuario (
    estado text NOT NULL
);
 %   DROP TABLE usuarios.estados_usuario;
       usuarios         heap    postgres    false    12            �            1259    189232    roles    TABLE     7   CREATE TABLE usuarios.roles (
    rol text NOT NULL
);
    DROP TABLE usuarios.roles;
       usuarios         heap    postgres    false    12                       2604    189244    comentarios id    DEFAULT     z   ALTER TABLE ONLY comentarios.comentarios ALTER COLUMN id SET DEFAULT nextval('comentarios.comentarios_id_seq'::regclass);
 B   ALTER TABLE comentarios.comentarios ALTER COLUMN id DROP DEFAULT;
       comentarios          postgres    false    213    212                       2604    189245 	   cursos id    DEFAULT     f   ALTER TABLE ONLY cursos.cursos ALTER COLUMN id SET DEFAULT nextval('cursos.cursos_id_seq'::regclass);
 8   ALTER TABLE cursos.cursos ALTER COLUMN id DROP DEFAULT;
       cursos          postgres    false    216    215                       2604    189246    inscripciones_cursos id    DEFAULT     �   ALTER TABLE ONLY cursos.inscripciones_cursos ALTER COLUMN id SET DEFAULT nextval('cursos.inscripciones_cursos_id_seq'::regclass);
 F   ALTER TABLE cursos.inscripciones_cursos ALTER COLUMN id DROP DEFAULT;
       cursos          postgres    false    219    218                       2604    189247    ejecucion_examen id    DEFAULT     ~   ALTER TABLE ONLY examenes.ejecucion_examen ALTER COLUMN id SET DEFAULT nextval('examenes.ejecucion_examen_id_seq'::regclass);
 D   ALTER TABLE examenes.ejecucion_examen ALTER COLUMN id DROP DEFAULT;
       examenes          postgres    false    221    220                       2604    189248    examenes id    DEFAULT     n   ALTER TABLE ONLY examenes.examenes ALTER COLUMN id SET DEFAULT nextval('examenes.examenes_id_seq'::regclass);
 <   ALTER TABLE examenes.examenes ALTER COLUMN id DROP DEFAULT;
       examenes          postgres    false    223    222                       2604    189249    preguntas id    DEFAULT     p   ALTER TABLE ONLY examenes.preguntas ALTER COLUMN id SET DEFAULT nextval('examenes.preguntas_id_seq'::regclass);
 =   ALTER TABLE examenes.preguntas ALTER COLUMN id DROP DEFAULT;
       examenes          postgres    false    225    224                       2604    189250    respuestas id    DEFAULT     r   ALTER TABLE ONLY examenes.respuestas ALTER COLUMN id SET DEFAULT nextval('examenes.respuestas_id_seq'::regclass);
 >   ALTER TABLE examenes.respuestas ALTER COLUMN id DROP DEFAULT;
       examenes          postgres    false    227    226                       2604    189251    mensajes id    DEFAULT     n   ALTER TABLE ONLY mensajes.mensajes ALTER COLUMN id SET DEFAULT nextval('mensajes.mensajes_id_seq'::regclass);
 <   ALTER TABLE mensajes.mensajes ALTER COLUMN id DROP DEFAULT;
       mensajes          postgres    false    230    229                       2604    189252    notificaciones id    DEFAULT     �   ALTER TABLE ONLY notificaciones.notificaciones ALTER COLUMN id SET DEFAULT nextval('notificaciones.notificaciones_id_seq'::regclass);
 H   ALTER TABLE notificaciones.notificaciones ALTER COLUMN id DROP DEFAULT;
       notificaciones          postgres    false    232    231                       2604    189253    reportes id    DEFAULT     n   ALTER TABLE ONLY reportes.reportes ALTER COLUMN id SET DEFAULT nextval('reportes.reportes_id_seq'::regclass);
 <   ALTER TABLE reportes.reportes ALTER COLUMN id DROP DEFAULT;
       reportes          postgres    false    235    234                       2604    189476    auditoria id    DEFAULT     r   ALTER TABLE ONLY seguridad.auditoria ALTER COLUMN id SET DEFAULT nextval('seguridad.auditoria_id_seq'::regclass);
 >   ALTER TABLE seguridad.auditoria ALTER COLUMN id DROP DEFAULT;
    	   seguridad          postgres    false    246    245    246                       2604    189447    autentication id    DEFAULT     z   ALTER TABLE ONLY seguridad.autentication ALTER COLUMN id SET DEFAULT nextval('seguridad.autentication_id_seq'::regclass);
 B   ALTER TABLE seguridad.autentication ALTER COLUMN id DROP DEFAULT;
    	   seguridad          postgres    false    243    244    244                       2604    189254    sugerencias id    DEFAULT     z   ALTER TABLE ONLY sugerencias.sugerencias ALTER COLUMN id SET DEFAULT nextval('sugerencias.sugerencias_id_seq'::regclass);
 B   ALTER TABLE sugerencias.sugerencias ALTER COLUMN id DROP DEFAULT;
       sugerencias          postgres    false    237    236                       2604    189255    temas id    DEFAULT     b   ALTER TABLE ONLY temas.temas ALTER COLUMN id SET DEFAULT nextval('temas.temas_id_seq'::regclass);
 6   ALTER TABLE temas.temas ALTER COLUMN id DROP DEFAULT;
       temas          postgres    false    239    238            �          0    189109    comentarios 
   TABLE DATA           �   COPY comentarios.comentarios (id, fk_nombre_de_usuario_emisor, fk_id_curso, fk_id_tema, fk_id_comentario, comentario, fecha_envio, imagenes) FROM stdin;
    comentarios          postgres    false    212   �      �          0    189117    areas 
   TABLE DATA           ,   COPY cursos.areas (area, icono) FROM stdin;
    cursos          postgres    false    214   �      �          0    189123    cursos 
   TABLE DATA           �   COPY cursos.cursos (id, fk_creador, fk_area, fk_estado, nombre, fecha_de_creacion, fecha_de_inicio, codigo_inscripcion, puntuacion) FROM stdin;
    cursos          postgres    false    215   ,      �          0    189131    estados_curso 
   TABLE DATA           /   COPY cursos.estados_curso (estado) FROM stdin;
    cursos          postgres    false    217   �      �          0    189137    inscripciones_cursos 
   TABLE DATA           k   COPY cursos.inscripciones_cursos (id, fk_nombre_de_usuario, fk_id_curso, fecha_de_inscripcion) FROM stdin;
    cursos          postgres    false    218         �          0    189145    ejecucion_examen 
   TABLE DATA           v   COPY examenes.ejecucion_examen (id, fk_nombre_de_usuario, fk_id_examen, fecha_de_ejecucion, calificacion) FROM stdin;
    examenes          postgres    false    220   K      �          0    189153    examenes 
   TABLE DATA           M   COPY examenes.examenes (id, fk_id_tema, fecha_inicio, fecha_fin) FROM stdin;
    examenes          postgres    false    222   h      �          0    189158 	   preguntas 
   TABLE DATA           _   COPY examenes.preguntas (id, fk_id_examen, fk_tipo_pregunta, pregunta, porcentaje) FROM stdin;
    examenes          postgres    false    224   �      �          0    189166 
   respuestas 
   TABLE DATA           F   COPY examenes.respuestas (id, fk_id_preguntas, respuesta) FROM stdin;
    examenes          postgres    false    226   �      �          0    189174    tipos_pregunta 
   TABLE DATA           0   COPY examenes.tipos_pregunta (tipo) FROM stdin;
    examenes          postgres    false    228   �      �          0    189180    mensajes 
   TABLE DATA           y   COPY mensajes.mensajes (id, fk_nombre_de_usuario_emisor, fk_nombre_de_usuario_receptor, contenido, imagenes) FROM stdin;
    mensajes          postgres    false    229   �      �          0    189188    notificaciones 
   TABLE DATA           [   COPY notificaciones.notificaciones (id, mensaje, estado, fk_nombre_de_usuario) FROM stdin;
    notificaciones          postgres    false    231   �      �          0    189196    motivos 
   TABLE DATA           +   COPY reportes.motivos (motivo) FROM stdin;
    reportes          postgres    false    233         �          0    189202    reportes 
   TABLE DATA           �   COPY reportes.reportes (id, fk_nombre_de_usuario_denunciante, fk_nombre_de_usuario_denunciado, fk_motivo, descripcion, estado, fk_id_comentario, fk_id_mensaje, imagenes) FROM stdin;
    reportes          postgres    false    234   3                0    189473 	   auditoria 
   TABLE DATA           d   COPY seguridad.auditoria (id, fecha, accion, schema, tabla, session, user_bd, data, pk) FROM stdin;
 	   seguridad          postgres    false    246   P                0    189444    autentication 
   TABLE DATA           l   COPY seguridad.autentication (id, nombre_de_usuario, ip, mac, fecha_inicio, fecha_fin, session) FROM stdin;
 	   seguridad          postgres    false    244   �      �          0    189210    sugerencias 
   TABLE DATA           h   COPY sugerencias.sugerencias (id, fk_nombre_de_usuario_emisor, contenido, estado, imagenes) FROM stdin;
    sugerencias          postgres    false    236   �      �          0    189218    temas 
   TABLE DATA           N   COPY temas.temas (id, fk_id_curso, titulo, informacion, imagenes) FROM stdin;
    temas          postgres    false    238   �      �          0    189226    estados_usuario 
   TABLE DATA           3   COPY usuarios.estados_usuario (estado) FROM stdin;
    usuarios          postgres    false    240   �                 0    189232    roles 
   TABLE DATA           &   COPY usuarios.roles (rol) FROM stdin;
    usuarios          postgres    false    241   "                0    189238    usuarios 
   TABLE DATA             COPY usuarios.usuarios (nombre_de_usuario, fk_rol, fk_estado, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, correo_institucional, pass, fecha_desbloqueo, puntuacion, token, imagen_perfil, fecha_creacion, ultima_modificacion, vencimiento_token, session) FROM stdin;
    usuarios          postgres    false    242   ]      $           0    0    comentarios_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('comentarios.comentarios_id_seq', 1, false);
          comentarios          postgres    false    213            %           0    0    cursos_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('cursos.cursos_id_seq', 8, true);
          cursos          postgres    false    216            &           0    0    inscripciones_cursos_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('cursos.inscripciones_cursos_id_seq', 2, true);
          cursos          postgres    false    219            '           0    0    ejecucion_examen_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('examenes.ejecucion_examen_id_seq', 1, false);
          examenes          postgres    false    221            (           0    0    examenes_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('examenes.examenes_id_seq', 1, false);
          examenes          postgres    false    223            )           0    0    preguntas_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('examenes.preguntas_id_seq', 1, false);
          examenes          postgres    false    225            *           0    0    respuestas_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('examenes.respuestas_id_seq', 1, false);
          examenes          postgres    false    227            +           0    0    mensajes_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('mensajes.mensajes_id_seq', 1, false);
          mensajes          postgres    false    230            ,           0    0    notificaciones_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('notificaciones.notificaciones_id_seq', 1, false);
          notificaciones          postgres    false    232            -           0    0    reportes_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('reportes.reportes_id_seq', 1, false);
          reportes          postgres    false    235            .           0    0    auditoria_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('seguridad.auditoria_id_seq', 22, true);
       	   seguridad          postgres    false    245            /           0    0    autentication_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('seguridad.autentication_id_seq', 1, false);
       	   seguridad          postgres    false    243            0           0    0    sugerencias_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('sugerencias.sugerencias_id_seq', 1, false);
          sugerencias          postgres    false    237            1           0    0    temas_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('temas.temas_id_seq', 1, false);
          temas          postgres    false    239                       2606    189257    comentarios comentarios_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT comentarios_pkey PRIMARY KEY (id);
 K   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT comentarios_pkey;
       comentarios            postgres    false    212                       2606    189259    areas areas_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY cursos.areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (area);
 :   ALTER TABLE ONLY cursos.areas DROP CONSTRAINT areas_pkey;
       cursos            postgres    false    214                        2606    189261    cursos cursos_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT cursos_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT cursos_pkey;
       cursos            postgres    false    215            "           2606    189263    estados_curso estado_curso_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY cursos.estados_curso
    ADD CONSTRAINT estado_curso_pkey PRIMARY KEY (estado);
 I   ALTER TABLE ONLY cursos.estados_curso DROP CONSTRAINT estado_curso_pkey;
       cursos            postgres    false    217            $           2606    189265 .   inscripciones_cursos inscripciones_cursos_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY cursos.inscripciones_cursos
    ADD CONSTRAINT inscripciones_cursos_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY cursos.inscripciones_cursos DROP CONSTRAINT inscripciones_cursos_pkey;
       cursos            postgres    false    218            &           2606    189267 &   ejecucion_examen ejecucion_examen_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY examenes.ejecucion_examen
    ADD CONSTRAINT ejecucion_examen_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY examenes.ejecucion_examen DROP CONSTRAINT ejecucion_examen_pkey;
       examenes            postgres    false    220            (           2606    189269    examenes examenes_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY examenes.examenes
    ADD CONSTRAINT examenes_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY examenes.examenes DROP CONSTRAINT examenes_pkey;
       examenes            postgres    false    222            *           2606    189271    preguntas preguntas_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY examenes.preguntas
    ADD CONSTRAINT preguntas_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY examenes.preguntas DROP CONSTRAINT preguntas_pkey;
       examenes            postgres    false    224            ,           2606    189273    respuestas respuestas_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY examenes.respuestas
    ADD CONSTRAINT respuestas_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY examenes.respuestas DROP CONSTRAINT respuestas_pkey;
       examenes            postgres    false    226            .           2606    189275 "   tipos_pregunta tipos_pregunta_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY examenes.tipos_pregunta
    ADD CONSTRAINT tipos_pregunta_pkey PRIMARY KEY (tipo);
 N   ALTER TABLE ONLY examenes.tipos_pregunta DROP CONSTRAINT tipos_pregunta_pkey;
       examenes            postgres    false    228            0           2606    189277    mensajes mensajes_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY mensajes.mensajes
    ADD CONSTRAINT mensajes_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY mensajes.mensajes DROP CONSTRAINT mensajes_pkey;
       mensajes            postgres    false    229            2           2606    189279 "   notificaciones notificaciones_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY notificaciones.notificaciones
    ADD CONSTRAINT notificaciones_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY notificaciones.notificaciones DROP CONSTRAINT notificaciones_pkey;
       notificaciones            postgres    false    231            4           2606    189281    motivos motivos_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY reportes.motivos
    ADD CONSTRAINT motivos_pkey PRIMARY KEY (motivo);
 @   ALTER TABLE ONLY reportes.motivos DROP CONSTRAINT motivos_pkey;
       reportes            postgres    false    233            6           2606    189283    reportes reportes_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT reportes_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT reportes_pkey;
       reportes            postgres    false    234            D           2606    189452     autentication autentication_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY seguridad.autentication
    ADD CONSTRAINT autentication_pkey PRIMARY KEY (id);
 M   ALTER TABLE ONLY seguridad.autentication DROP CONSTRAINT autentication_pkey;
    	   seguridad            postgres    false    244            F           2606    189481     auditoria pk_seguridad_auditoria 
   CONSTRAINT     a   ALTER TABLE ONLY seguridad.auditoria
    ADD CONSTRAINT pk_seguridad_auditoria PRIMARY KEY (id);
 M   ALTER TABLE ONLY seguridad.auditoria DROP CONSTRAINT pk_seguridad_auditoria;
    	   seguridad            postgres    false    246            8           2606    189285    sugerencias sugerencias_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY sugerencias.sugerencias
    ADD CONSTRAINT sugerencias_pkey PRIMARY KEY (id);
 K   ALTER TABLE ONLY sugerencias.sugerencias DROP CONSTRAINT sugerencias_pkey;
       sugerencias            postgres    false    236            :           2606    189287    temas temas_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY temas.temas
    ADD CONSTRAINT temas_pkey PRIMARY KEY (id);
 9   ALTER TABLE ONLY temas.temas DROP CONSTRAINT temas_pkey;
       temas            postgres    false    238            <           2606    189289 $   estados_usuario estados_usuario_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY usuarios.estados_usuario
    ADD CONSTRAINT estados_usuario_pkey PRIMARY KEY (estado);
 P   ALTER TABLE ONLY usuarios.estados_usuario DROP CONSTRAINT estados_usuario_pkey;
       usuarios            postgres    false    240            >           2606    189291    roles roles_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY usuarios.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (rol);
 <   ALTER TABLE ONLY usuarios.roles DROP CONSTRAINT roles_pkey;
       usuarios            postgres    false    241            @           2606    189491 $   usuarios unique_correo_institucional 
   CONSTRAINT     q   ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT unique_correo_institucional UNIQUE (correo_institucional);
 P   ALTER TABLE ONLY usuarios.usuarios DROP CONSTRAINT unique_correo_institucional;
       usuarios            postgres    false    242            B           2606    189293    usuarios usuarios_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (nombre_de_usuario);
 B   ALTER TABLE ONLY usuarios.usuarios DROP CONSTRAINT usuarios_pkey;
       usuarios            postgres    false    242            c           2620    189489    usuarios tg_usuarios_usuarios    TRIGGER     �   CREATE TRIGGER tg_usuarios_usuarios AFTER INSERT OR DELETE OR UPDATE ON usuarios.usuarios FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 8   DROP TRIGGER tg_usuarios_usuarios ON usuarios.usuarios;
       usuarios          postgres    false    248    242            G           2606    189294    comentarios fkcomentario107416    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario107416 FOREIGN KEY (fk_nombre_de_usuario_emisor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario107416;
       comentarios          postgres    false    2882    212    242            H           2606    189299    comentarios fkcomentario298131    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario298131 FOREIGN KEY (fk_id_tema) REFERENCES temas.temas(id);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario298131;
       comentarios          postgres    false    238    212    2874            I           2606    189304    comentarios fkcomentario605734    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario605734 FOREIGN KEY (fk_id_curso) REFERENCES cursos.cursos(id);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario605734;
       comentarios          postgres    false    215    212    2848            J           2606    189309    comentarios fkcomentario954929    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario954929 FOREIGN KEY (fk_id_comentario) REFERENCES comentarios.comentarios(id);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario954929;
       comentarios          postgres    false    212    212    2844            K           2606    189314    cursos fkcursos287281    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT fkcursos287281 FOREIGN KEY (fk_estado) REFERENCES cursos.estados_curso(estado);
 ?   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT fkcursos287281;
       cursos          postgres    false    217    215    2850            L           2606    189319    cursos fkcursos395447    FK CONSTRAINT     v   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT fkcursos395447 FOREIGN KEY (fk_area) REFERENCES cursos.areas(area);
 ?   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT fkcursos395447;
       cursos          postgres    false    214    215    2846            M           2606    189324    cursos fkcursos742472    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT fkcursos742472 FOREIGN KEY (fk_creador) REFERENCES usuarios.usuarios(nombre_de_usuario);
 ?   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT fkcursos742472;
       cursos          postgres    false    242    215    2882            N           2606    189329 &   inscripciones_cursos fkinscripcio18320    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.inscripciones_cursos
    ADD CONSTRAINT fkinscripcio18320 FOREIGN KEY (fk_id_curso) REFERENCES cursos.cursos(id);
 P   ALTER TABLE ONLY cursos.inscripciones_cursos DROP CONSTRAINT fkinscripcio18320;
       cursos          postgres    false    2848    215    218            O           2606    189334 '   inscripciones_cursos fkinscripcio893145    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.inscripciones_cursos
    ADD CONSTRAINT fkinscripcio893145 FOREIGN KEY (fk_nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 Q   ALTER TABLE ONLY cursos.inscripciones_cursos DROP CONSTRAINT fkinscripcio893145;
       cursos          postgres    false    218    242    2882            P           2606    189339 #   ejecucion_examen fkejecucion_455924    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.ejecucion_examen
    ADD CONSTRAINT fkejecucion_455924 FOREIGN KEY (fk_nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 O   ALTER TABLE ONLY examenes.ejecucion_examen DROP CONSTRAINT fkejecucion_455924;
       examenes          postgres    false    2882    220    242            Q           2606    189344 #   ejecucion_examen fkejecucion_678612    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.ejecucion_examen
    ADD CONSTRAINT fkejecucion_678612 FOREIGN KEY (fk_id_examen) REFERENCES examenes.examenes(id);
 O   ALTER TABLE ONLY examenes.ejecucion_examen DROP CONSTRAINT fkejecucion_678612;
       examenes          postgres    false    222    220    2856            R           2606    189349    examenes fkexamenes946263    FK CONSTRAINT     |   ALTER TABLE ONLY examenes.examenes
    ADD CONSTRAINT fkexamenes946263 FOREIGN KEY (fk_id_tema) REFERENCES temas.temas(id);
 E   ALTER TABLE ONLY examenes.examenes DROP CONSTRAINT fkexamenes946263;
       examenes          postgres    false    238    222    2874            S           2606    189354    preguntas fkpreguntas592721    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.preguntas
    ADD CONSTRAINT fkpreguntas592721 FOREIGN KEY (fk_id_examen) REFERENCES examenes.examenes(id);
 G   ALTER TABLE ONLY examenes.preguntas DROP CONSTRAINT fkpreguntas592721;
       examenes          postgres    false    224    2856    222            T           2606    189359    preguntas fkpreguntas985578    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.preguntas
    ADD CONSTRAINT fkpreguntas985578 FOREIGN KEY (fk_tipo_pregunta) REFERENCES examenes.tipos_pregunta(tipo);
 G   ALTER TABLE ONLY examenes.preguntas DROP CONSTRAINT fkpreguntas985578;
       examenes          postgres    false    224    2862    228            U           2606    189364    respuestas fkrespuestas516290    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.respuestas
    ADD CONSTRAINT fkrespuestas516290 FOREIGN KEY (fk_id_preguntas) REFERENCES examenes.preguntas(id);
 I   ALTER TABLE ONLY examenes.respuestas DROP CONSTRAINT fkrespuestas516290;
       examenes          postgres    false    2858    224    226            V           2606    189369    mensajes fkmensajes16841    FK CONSTRAINT     �   ALTER TABLE ONLY mensajes.mensajes
    ADD CONSTRAINT fkmensajes16841 FOREIGN KEY (fk_nombre_de_usuario_receptor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 D   ALTER TABLE ONLY mensajes.mensajes DROP CONSTRAINT fkmensajes16841;
       mensajes          postgres    false    229    2882    242            W           2606    189374    mensajes fkmensajes33437    FK CONSTRAINT     �   ALTER TABLE ONLY mensajes.mensajes
    ADD CONSTRAINT fkmensajes33437 FOREIGN KEY (fk_nombre_de_usuario_emisor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 D   ALTER TABLE ONLY mensajes.mensajes DROP CONSTRAINT fkmensajes33437;
       mensajes          postgres    false    2882    242    229            X           2606    189379 !   notificaciones fknotificaci697604    FK CONSTRAINT     �   ALTER TABLE ONLY notificaciones.notificaciones
    ADD CONSTRAINT fknotificaci697604 FOREIGN KEY (fk_nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 S   ALTER TABLE ONLY notificaciones.notificaciones DROP CONSTRAINT fknotificaci697604;
       notificaciones          postgres    false    242    231    2882            Y           2606    189384    reportes fkreportes338700    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT fkreportes338700 FOREIGN KEY (fk_motivo) REFERENCES reportes.motivos(motivo);
 E   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT fkreportes338700;
       reportes          postgres    false    234    233    2868            Z           2606    189389    reportes fkreportes50539    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT fkreportes50539 FOREIGN KEY (fk_nombre_de_usuario_denunciado) REFERENCES usuarios.usuarios(nombre_de_usuario);
 D   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT fkreportes50539;
       reportes          postgres    false    2882    234    242            [           2606    189394    reportes fkreportes843275    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT fkreportes843275 FOREIGN KEY (fk_nombre_de_usuario_denunciante) REFERENCES usuarios.usuarios(nombre_de_usuario);
 E   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT fkreportes843275;
       reportes          postgres    false    242    234    2882            \           2606    189399 '   reportes reportes_fk_id_comentario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT reportes_fk_id_comentario_fkey FOREIGN KEY (fk_id_comentario) REFERENCES comentarios.comentarios(id);
 S   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT reportes_fk_id_comentario_fkey;
       reportes          postgres    false    212    234    2844            ]           2606    189404 $   reportes reportes_fk_id_mensaje_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT reportes_fk_id_mensaje_fkey FOREIGN KEY (fk_id_mensaje) REFERENCES mensajes.mensajes(id);
 P   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT reportes_fk_id_mensaje_fkey;
       reportes          postgres    false    234    2864    229            b           2606    189453 '   autentication fk_autentication_usuarios    FK CONSTRAINT     �   ALTER TABLE ONLY seguridad.autentication
    ADD CONSTRAINT fk_autentication_usuarios FOREIGN KEY (nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 T   ALTER TABLE ONLY seguridad.autentication DROP CONSTRAINT fk_autentication_usuarios;
    	   seguridad          postgres    false    244    242    2882            ^           2606    189409    sugerencias fksugerencia433827    FK CONSTRAINT     �   ALTER TABLE ONLY sugerencias.sugerencias
    ADD CONSTRAINT fksugerencia433827 FOREIGN KEY (fk_nombre_de_usuario_emisor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 M   ALTER TABLE ONLY sugerencias.sugerencias DROP CONSTRAINT fksugerencia433827;
       sugerencias          postgres    false    236    242    2882            _           2606    189414    temas fktemas249223    FK CONSTRAINT     v   ALTER TABLE ONLY temas.temas
    ADD CONSTRAINT fktemas249223 FOREIGN KEY (fk_id_curso) REFERENCES cursos.cursos(id);
 <   ALTER TABLE ONLY temas.temas DROP CONSTRAINT fktemas249223;
       temas          postgres    false    2848    215    238            `           2606    189419    usuarios fkusuarios355026    FK CONSTRAINT     |   ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT fkusuarios355026 FOREIGN KEY (fk_rol) REFERENCES usuarios.roles(rol);
 E   ALTER TABLE ONLY usuarios.usuarios DROP CONSTRAINT fkusuarios355026;
       usuarios          postgres    false    2878    242    241            a           2606    189424    usuarios fkusuarios94770    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT fkusuarios94770 FOREIGN KEY (fk_estado) REFERENCES usuarios.estados_usuario(estado);
 D   ALTER TABLE ONLY usuarios.usuarios DROP CONSTRAINT fkusuarios94770;
       usuarios          postgres    false    242    240    2876            �      x������ � �      �   k   x�s�L�K�L,Vp:��839���N?(5���8�X�371=5/�H���/v,JM,�wFסW����T��Ztxm"A��B��d��a3TX�IQ>a`U`�1z\\\ ?�X�      �   �   x�u�A
�0EדS��i�4]+�"���MH[ZH��� ��sB���,�"��S��f�aC�`Ʉd=�Y�ؑ��f�%���X���l�r��`z�?��0:O�M���q�"E�#
��#������]�w4QES�EĶS E5��ѻ�wq\�7!��#�^F�hN�,V���J�$EG�      �      x�KL.�,������ �9      �   +   x�3�t+J�K�4�4202�50�56�2�
BM��+F��� �#	^      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �         (  x��[o�F���_a�yC�9s�Ӧ�כM�č�E��\Sֲ����`���#ō)JbhFR�T�Ț�\��|<3��	�Ǆ=rj�� DF(R�����>���hZMM����_Ώ�E5yW���'cSUW�i�-N�'ӑ��\����'��:��A8���pΤ_D!��pm(r`,ZÈZ�@�S̘���(�Y����,��?�jVT��ʋ��F������_��q(ͱ��M�[��a����d:���H~cޥ���b>l���&�W��Ɩ���w��|���j�\�>�?���.��b�SN��|�w�q���Ʀ,�}O>TvX�>Es������0�۸�߇���ۘ����m��&�Iq��7���a�d�J����I:�W7��c�V�kW�ey>�&�d:�a��!����9ui2i�7�t&~�����G��.��	n���Zq������nd��$��r������2��%��v }��E֗�q�w���z�V���s_����/�_o�- �&�&Vϳc,�we$,���@���Cy��R�i~<|�a�|z�_��8{�+t/8�h#	h��`T�M:ѯ�a^��00�� �"
L8��~����?���}��S�ID-�����z��~��7��n�5���@�Q�8�~�Uݰ�ߟ�W������.ޯ��c�4�@h`,с۴�H���$71%H�5�V�04%?^a��[�1ĿE�o^�wT��v�|ф�xR>Ⴉ��o�{!�����\�ے}�Hؚ�e#O���)�i?�?���wg!��z���/^ڋ��Dig�Nћ(, ���3B����>r)	J�@�qħ�I��t�|0����r�T�(��^5��d�dƄ��]��w��?���q}�Hؚ��r<��H���~��}�� 1����+d���8T�	zK=�F��N�!�^�42��pJ�`BYj51����O�w<!'l��8@�\��L$���9}��z�����������
Td�K-u?ş���T/~z{�_�-s������ C�!A�H�D��m�J4c��ԧ�PNj��@f�tA�]�n�P�s��v�kwf��q(�@�ފoC�^o�t�-(�ClO�
�f 5�����0D��L���"�4����J�)(f7N*"���tվ�����ٽ��]�)��h.	��) *�F4K3��T�jC��D[ʴ\f�������;���S,Ϝ<_u�+����8e&�\8��V���<igP+aX���N����e/=��B�%�.���(���)��ce��'-��~\���--b_�`��WN���{$0�$/�m�_��9��qT|��|�@h�"l/���{��4P�3�A�}��ft^=×H���חo޿\��*�J�,Z���so5 ���.�h�Ap4W��TQ2�^�;w�NY|>���X{���W��I��;Ȩ�Rn&���j��3�3L)彵����d7��>k}�Vd��hm(,]�E�����ۻ�z|����O2�^���������7A�`�VEJ��V!�F'�^(-pB�RB��F�o���˭߾�SŪ��ھ���3{�+aD�$3���W>���H8����d&�B�gn$׋6�}%޽|���m�ۑ�×���!�ϑu�Sz�b��ش��sc�_�kG�U��zv�F�\�so0�.�I��%����i�ڂO9�0��XG|Z�2k�A)���q�p/��ܲ�w�y�@�#�#��bD�]>a��D[Ξ��LQJ{[���l�=U�Cv2�T�޲y��;���R�_�G��	`
��            x������ � �      �      x������ � �      �      x������ � �      �   3   x�KL.�,��J�H�KOU(H,.�J-.H-JTHIUHI&&g��q��qqq y�4          +   x�+(��MM���JL����,.)JL�/�*-.M,���qqq ��         �   x�m�MN�0�ד�4r��wE�.���u7�m��Ćq̢7b��#�b�ӟBz�xF���̆0X�)#�h&�a3��GGp�	<��^M����`}��`�l�M�-A
%B�@�^-a�ĳF/D�*ݬj�ibo��>M�6��1�M�t�J��~�efo]��O�G�W�q�ղ�٪�A�s�k����w�Rd�wH�|��`��%�����y_�C��u��>���uUU�9'm�     