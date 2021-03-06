PGDMP         9                x            tudec    12.2    12.2 �    9           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            :           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            ;           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            <           1262    18918    tudec    DATABASE     �   CREATE DATABASE tudec WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Spanish_Latin America.1252' LC_CTYPE = 'Spanish_Latin America.1252';
    DROP DATABASE tudec;
                postgres    false                        2615    18919    comentarios    SCHEMA        CREATE SCHEMA comentarios;
    DROP SCHEMA comentarios;
                postgres    false                        2615    18920    cursos    SCHEMA        CREATE SCHEMA cursos;
    DROP SCHEMA cursos;
                postgres    false            
            2615    18921    examenes    SCHEMA        CREATE SCHEMA examenes;
    DROP SCHEMA examenes;
                postgres    false                        2615    18922    mensajes    SCHEMA        CREATE SCHEMA mensajes;
    DROP SCHEMA mensajes;
                postgres    false                        2615    18923    notificaciones    SCHEMA        CREATE SCHEMA notificaciones;
    DROP SCHEMA notificaciones;
                postgres    false                        2615    18924    puntuaciones    SCHEMA        CREATE SCHEMA puntuaciones;
    DROP SCHEMA puntuaciones;
                postgres    false                        2615    18925    reportes    SCHEMA        CREATE SCHEMA reportes;
    DROP SCHEMA reportes;
                postgres    false                        2615    18926 	   seguridad    SCHEMA        CREATE SCHEMA seguridad;
    DROP SCHEMA seguridad;
                postgres    false                        2615    18927    sugerencias    SCHEMA        CREATE SCHEMA sugerencias;
    DROP SCHEMA sugerencias;
                postgres    false                        2615    18928    temas    SCHEMA        CREATE SCHEMA temas;
    DROP SCHEMA temas;
                postgres    false            	            2615    18929    usuarios    SCHEMA        CREATE SCHEMA usuarios;
    DROP SCHEMA usuarios;
                postgres    false            �            1255    18930    f_log_auditoria()    FUNCTION     �  CREATE FUNCTION seguridad.f_log_auditoria() RETURNS trigger
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
    	   seguridad          postgres    false    17            �            1259    18932    comentarios    TABLE     &  CREATE TABLE comentarios.comentarios (
    id integer NOT NULL,
    fk_nombre_de_usuario_emisor text NOT NULL,
    fk_id_curso integer,
    fk_id_tema integer,
    fk_id_comentario integer,
    comentario text NOT NULL,
    fecha_envio timestamp with time zone NOT NULL,
    imagenes text[]
);
 $   DROP TABLE comentarios.comentarios;
       comentarios         heap    postgres    false    16                       1255    18938 u   field_audit(comentarios.comentarios, comentarios.comentarios, character varying, text, character varying, text, text)    FUNCTION     �  CREATE FUNCTION seguridad.field_audit(_data_new comentarios.comentarios, _data_old comentarios.comentarios, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('fk_nombre_de_usuario_emisor_nuevo', _data_new.fk_nombre_de_usuario_emisor)::jsonb;
				_datos := _datos || json_build_object('fk_id_curso_nuevo', _data_new.fk_id_curso)::jsonb;
				_datos := _datos || json_build_object('fk_id_tema_nuevo', _data_new.fk_id_tema)::jsonb;
				_datos := _datos || json_build_object('fk_id_comentario_nuevo', _data_new.fk_id_comentario)::jsonb;
				_datos := _datos || json_build_object('comentario_nuevo', _data_new.comentario)::jsonb;
				_datos := _datos || json_build_object('fecha_envio_nuevo', _data_new.fecha_envio)::jsonb;
				_datos := _datos || json_build_object('imagenes_nuevo', _data_new.imagenes)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('fk_nombre_de_usuario_emisor_anterior', _data_old.fk_nombre_de_usuario_emisor)::jsonb;
				_datos := _datos || json_build_object('fk_id_curso_anterior', _data_old.fk_id_curso)::jsonb;
				_datos := _datos || json_build_object('fk_id_tema_anterior', _data_old.fk_id_tema)::jsonb;
				_datos := _datos || json_build_object('fk_id_comentario_anterior', _data_old.fk_id_comentario)::jsonb;
				_datos := _datos || json_build_object('comentario_anterior', _data_old.comentario)::jsonb;
				_datos := _datos || json_build_object('fecha_envio_anterior', _data_old.fecha_envio)::jsonb;
				_datos := _datos || json_build_object('imagenes_anterior', _data_old.imagenes)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.fk_nombre_de_usuario_emisor <> _data_new.fk_nombre_de_usuario_emisor
				THEN _datos := _datos || json_build_object('fk_nombre_de_usuario_emisor_anterior', _data_old.fk_nombre_de_usuario_emisor, 'fk_nombre_de_usuario_emisor_nuevo', _data_new.fk_nombre_de_usuario_emisor)::jsonb;
			END IF;
			IF _data_old.fk_id_curso <> _data_new.fk_id_curso
				THEN _datos := _datos || json_build_object('fk_id_curso_anterior', _data_old.fk_id_curso, 'fk_id_curso_nuevo', _data_new.fk_id_curso)::jsonb;
			END IF;
			IF _data_old.fk_id_tema <> _data_new.fk_id_tema
				THEN _datos := _datos || json_build_object('fk_id_tema_anterior', _data_old.fk_id_tema, 'fk_id_tema_nuevo', _data_new.fk_id_tema)::jsonb;
			END IF;
			IF _data_old.fk_id_comentario <> _data_new.fk_id_comentario
				THEN _datos := _datos || json_build_object('fk_id_comentario_anterior', _data_old.fk_id_comentario, 'fk_id_comentario_nuevo', _data_new.fk_id_comentario)::jsonb;
			END IF;
			IF _data_old.comentario <> _data_new.comentario
				THEN _datos := _datos || json_build_object('comentario_anterior', _data_old.comentario, 'comentario_nuevo', _data_new.comentario)::jsonb;
			END IF;
			IF _data_old.fecha_envio <> _data_new.fecha_envio
				THEN _datos := _datos || json_build_object('fecha_envio_anterior', _data_old.fecha_envio, 'fecha_envio_nuevo', _data_new.fecha_envio)::jsonb;
			END IF;
			IF _data_old.imagenes <> _data_new.imagenes
				THEN _datos := _datos || json_build_object('imagenes_anterior', _data_old.imagenes, 'imagenes_nuevo', _data_new.imagenes)::jsonb;
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
			'comentarios',
			'comentarios',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;
 �   DROP FUNCTION seguridad.field_audit(_data_new comentarios.comentarios, _data_old comentarios.comentarios, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text);
    	   seguridad          postgres    false    213    213    17            �            1259    18939    cursos    TABLE     D  CREATE TABLE cursos.cursos (
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
       cursos         heap    postgres    false    8                       1255    18945 a   field_audit(cursos.cursos, cursos.cursos, character varying, text, character varying, text, text)    FUNCTION     .  CREATE FUNCTION seguridad.field_audit(_data_new cursos.cursos, _data_old cursos.cursos, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('fk_creador_nuevo', _data_new.fk_creador)::jsonb;
				_datos := _datos || json_build_object('fk_area_nuevo', _data_new.fk_area)::jsonb;
				_datos := _datos || json_build_object('fk_estado_nuevo', _data_new.fk_estado)::jsonb;
				_datos := _datos || json_build_object('nombre_nuevo', _data_new.nombre)::jsonb;
				_datos := _datos || json_build_object('fecha_de_creacion_nuevo', _data_new.fecha_de_creacion)::jsonb;
				_datos := _datos || json_build_object('fecha_de_inicio_nuevo', _data_new.fecha_de_inicio)::jsonb;
				_datos := _datos || json_build_object('codigo_inscripcion_nuevo', _data_new.codigo_inscripcion)::jsonb;
				_datos := _datos || json_build_object('puntuacion_nuevo', _data_new.puntuacion)::jsonb;
				_datos := _datos || json_build_object('descripcion_nuevo', _data_new.descripcion)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('fk_creador_anterior', _data_old.fk_creador)::jsonb;
				_datos := _datos || json_build_object('fk_area_anterior', _data_old.fk_area)::jsonb;
				_datos := _datos || json_build_object('fk_estado_anterior', _data_old.fk_estado)::jsonb;
				_datos := _datos || json_build_object('nombre_anterior', _data_old.nombre)::jsonb;
				_datos := _datos || json_build_object('fecha_de_creacion_anterior', _data_old.fecha_de_creacion)::jsonb;
				_datos := _datos || json_build_object('fecha_de_inicio_anterior', _data_old.fecha_de_inicio)::jsonb;
				_datos := _datos || json_build_object('codigo_inscripcion_anterior', _data_old.codigo_inscripcion)::jsonb;
				_datos := _datos || json_build_object('puntuacion_anterior', _data_old.puntuacion)::jsonb;
				_datos := _datos || json_build_object('descripcion_anterior', _data_old.descripcion)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.fk_creador <> _data_new.fk_creador
				THEN _datos := _datos || json_build_object('fk_creador_anterior', _data_old.fk_creador, 'fk_creador_nuevo', _data_new.fk_creador)::jsonb;
			END IF;
			IF _data_old.fk_area <> _data_new.fk_area
				THEN _datos := _datos || json_build_object('fk_area_anterior', _data_old.fk_area, 'fk_area_nuevo', _data_new.fk_area)::jsonb;
			END IF;
			IF _data_old.fk_estado <> _data_new.fk_estado
				THEN _datos := _datos || json_build_object('fk_estado_anterior', _data_old.fk_estado, 'fk_estado_nuevo', _data_new.fk_estado)::jsonb;
			END IF;
			IF _data_old.nombre <> _data_new.nombre
				THEN _datos := _datos || json_build_object('nombre_anterior', _data_old.nombre, 'nombre_nuevo', _data_new.nombre)::jsonb;
			END IF;
			IF _data_old.fecha_de_creacion <> _data_new.fecha_de_creacion
				THEN _datos := _datos || json_build_object('fecha_de_creacion_anterior', _data_old.fecha_de_creacion, 'fecha_de_creacion_nuevo', _data_new.fecha_de_creacion)::jsonb;
			END IF;
			IF _data_old.fecha_de_inicio <> _data_new.fecha_de_inicio
				THEN _datos := _datos || json_build_object('fecha_de_inicio_anterior', _data_old.fecha_de_inicio, 'fecha_de_inicio_nuevo', _data_new.fecha_de_inicio)::jsonb;
			END IF;
			IF _data_old.codigo_inscripcion <> _data_new.codigo_inscripcion
				THEN _datos := _datos || json_build_object('codigo_inscripcion_anterior', _data_old.codigo_inscripcion, 'codigo_inscripcion_nuevo', _data_new.codigo_inscripcion)::jsonb;
			END IF;
			IF _data_old.puntuacion <> _data_new.puntuacion
				THEN _datos := _datos || json_build_object('puntuacion_anterior', _data_old.puntuacion, 'puntuacion_nuevo', _data_new.puntuacion)::jsonb;
			END IF;
			IF _data_old.descripcion <> _data_new.descripcion
				THEN _datos := _datos || json_build_object('descripcion_anterior', _data_old.descripcion, 'descripcion_nuevo', _data_new.descripcion)::jsonb;
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
			'cursos',
			'cursos',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;
 �   DROP FUNCTION seguridad.field_audit(_data_new cursos.cursos, _data_old cursos.cursos, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text);
    	   seguridad          postgres    false    17    214    214            �            1259    18946    estados_curso    TABLE     @   CREATE TABLE cursos.estados_curso (
    estado text NOT NULL
);
 !   DROP TABLE cursos.estados_curso;
       cursos         heap    postgres    false    8            �            1255    18952 o   field_audit(cursos.estados_curso, cursos.estados_curso, character varying, text, character varying, text, text)    FUNCTION     O  CREATE FUNCTION seguridad.field_audit(_data_new cursos.estados_curso, _data_old cursos.estados_curso, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		_column_data :=  _data_new.estado;
		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('estado_nuevo', _data_new.estado)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('estado_anterior', _data_old.estado)::jsonb;
				
		ELSE
			IF _data_old.estado <> _data_new.estado
				THEN _datos := _datos || json_build_object('estado_anterior', _data_old.estado, 'estado_nuevo', _data_new.estado)::jsonb;
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
			'cursos',
			'estados_curso',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;
 �   DROP FUNCTION seguridad.field_audit(_data_new cursos.estados_curso, _data_old cursos.estados_curso, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text);
    	   seguridad          postgres    false    17    215    215            �            1259    18953    inscripciones_cursos    TABLE     �   CREATE TABLE cursos.inscripciones_cursos (
    id integer NOT NULL,
    fk_nombre_de_usuario text NOT NULL,
    fk_id_curso integer NOT NULL,
    fecha_de_inscripcion date NOT NULL
);
 (   DROP TABLE cursos.inscripciones_cursos;
       cursos         heap    postgres    false    8                       1255    18959 }   field_audit(cursos.inscripciones_cursos, cursos.inscripciones_cursos, character varying, text, character varying, text, text)    FUNCTION     ~	  CREATE FUNCTION seguridad.field_audit(_data_new cursos.inscripciones_cursos, _data_old cursos.inscripciones_cursos, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('fk_nombre_de_usuario_nuevo', _data_new.fk_nombre_de_usuario)::jsonb;
				_datos := _datos || json_build_object('fk_id_curso_nuevo', _data_new.fk_id_curso)::jsonb;
				_datos := _datos || json_build_object('fecha_de_inscripcion_nuevo', _data_new.fecha_de_inscripcion)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('fk_nombre_de_usuario_anterior', _data_old.fk_nombre_de_usuario)::jsonb;
				_datos := _datos || json_build_object('fk_id_curso_anterior', _data_old.fk_id_curso)::jsonb;
				_datos := _datos || json_build_object('fecha_de_inscripcion_anterior', _data_old.fecha_de_inscripcion)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.fk_nombre_de_usuario <> _data_new.fk_nombre_de_usuario
				THEN _datos := _datos || json_build_object('fk_nombre_de_usuario_anterior', _data_old.fk_nombre_de_usuario, 'fk_nombre_de_usuario_nuevo', _data_new.fk_nombre_de_usuario)::jsonb;
			END IF;
			IF _data_old.fk_id_curso <> _data_new.fk_id_curso
				THEN _datos := _datos || json_build_object('fk_id_curso_anterior', _data_old.fk_id_curso, 'fk_id_curso_nuevo', _data_new.fk_id_curso)::jsonb;
			END IF;
			IF _data_old.fecha_de_inscripcion <> _data_new.fecha_de_inscripcion
				THEN _datos := _datos || json_build_object('fecha_de_inscripcion_anterior', _data_old.fecha_de_inscripcion, 'fecha_de_inscripcion_nuevo', _data_new.fecha_de_inscripcion)::jsonb;
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
			'cursos',
			'inscripciones_cursos',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;
 �   DROP FUNCTION seguridad.field_audit(_data_new cursos.inscripciones_cursos, _data_old cursos.inscripciones_cursos, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text);
    	   seguridad          postgres    false    216    216    17            �            1259    18960    ejecucion_examen    TABLE       CREATE TABLE examenes.ejecucion_examen (
    id integer NOT NULL,
    fk_nombre_de_usuario text NOT NULL,
    fk_id_examen integer NOT NULL,
    fecha_de_ejecucion timestamp without time zone NOT NULL,
    calificacion text,
    respuestas text NOT NULL
);
 &   DROP TABLE examenes.ejecucion_examen;
       examenes         heap    postgres    false    10            
           1255    18966 y   field_audit(examenes.ejecucion_examen, examenes.ejecucion_examen, character varying, text, character varying, text, text)    FUNCTION     �  CREATE FUNCTION seguridad.field_audit(_data_new examenes.ejecucion_examen, _data_old examenes.ejecucion_examen, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('fk_nombre_de_usuario_nuevo', _data_new.fk_nombre_de_usuario)::jsonb;
				_datos := _datos || json_build_object('fk_id_examen_nuevo', _data_new.fk_id_examen)::jsonb;
				_datos := _datos || json_build_object('fecha_de_ejecucion_nuevo', _data_new.fecha_de_ejecucion)::jsonb;
				_datos := _datos || json_build_object('calificacion_nuevo', _data_new.calificacion)::jsonb;
				_datos := _datos || json_build_object('respuestas_nuevo', _data_new.respuestas)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('fk_nombre_de_usuario_anterior', _data_old.fk_nombre_de_usuario)::jsonb;
				_datos := _datos || json_build_object('fk_id_examen_anterior', _data_old.fk_id_examen)::jsonb;
				_datos := _datos || json_build_object('fecha_de_ejecucion_anterior', _data_old.fecha_de_ejecucion)::jsonb;
				_datos := _datos || json_build_object('calificacion_anterior', _data_old.calificacion)::jsonb;
				_datos := _datos || json_build_object('respuestas_anterior', _data_old.respuestas)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.fk_nombre_de_usuario <> _data_new.fk_nombre_de_usuario
				THEN _datos := _datos || json_build_object('fk_nombre_de_usuario_anterior', _data_old.fk_nombre_de_usuario, 'fk_nombre_de_usuario_nuevo', _data_new.fk_nombre_de_usuario)::jsonb;
			END IF;
			IF _data_old.fk_id_examen <> _data_new.fk_id_examen
				THEN _datos := _datos || json_build_object('fk_id_examen_anterior', _data_old.fk_id_examen, 'fk_id_examen_nuevo', _data_new.fk_id_examen)::jsonb;
			END IF;
			IF _data_old.fecha_de_ejecucion <> _data_new.fecha_de_ejecucion
				THEN _datos := _datos || json_build_object('fecha_de_ejecucion_anterior', _data_old.fecha_de_ejecucion, 'fecha_de_ejecucion_nuevo', _data_new.fecha_de_ejecucion)::jsonb;
			END IF;
			IF _data_old.calificacion <> _data_new.calificacion
				THEN _datos := _datos || json_build_object('calificacion_anterior', _data_old.calificacion, 'calificacion_nuevo', _data_new.calificacion)::jsonb;
			END IF;
			IF _data_old.respuestas <> _data_new.respuestas
				THEN _datos := _datos || json_build_object('respuestas_anterior', _data_old.respuestas, 'respuestas_nuevo', _data_new.respuestas)::jsonb;
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
			'examenes',
			'ejecucion_examen',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;
 �   DROP FUNCTION seguridad.field_audit(_data_new examenes.ejecucion_examen, _data_old examenes.ejecucion_examen, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text);
    	   seguridad          postgres    false    17    217    217            �            1259    18967    examenes    TABLE     �   CREATE TABLE examenes.examenes (
    id integer NOT NULL,
    fk_id_tema integer,
    fecha_fin timestamp without time zone NOT NULL
);
    DROP TABLE examenes.examenes;
       examenes         heap    postgres    false    10                       1255    18970 i   field_audit(examenes.examenes, examenes.examenes, character varying, text, character varying, text, text)    FUNCTION     �  CREATE FUNCTION seguridad.field_audit(_data_new examenes.examenes, _data_old examenes.examenes, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('fk_id_tema_nuevo', _data_new.fk_id_tema)::jsonb;
				_datos := _datos || json_build_object('fecha_fin_nuevo', _data_new.fecha_fin)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('fk_id_tema_anterior', _data_old.fk_id_tema)::jsonb;
				_datos := _datos || json_build_object('fecha_fin_anterior', _data_old.fecha_fin)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.fk_id_tema <> _data_new.fk_id_tema
				THEN _datos := _datos || json_build_object('fk_id_tema_anterior', _data_old.fk_id_tema, 'fk_id_tema_nuevo', _data_new.fk_id_tema)::jsonb;
			END IF;
			IF _data_old.fecha_fin <> _data_new.fecha_fin
				THEN _datos := _datos || json_build_object('fecha_fin_anterior', _data_old.fecha_fin, 'fecha_fin_nuevo', _data_new.fecha_fin)::jsonb;
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
			'examenes',
			'examenes',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;
 �   DROP FUNCTION seguridad.field_audit(_data_new examenes.examenes, _data_old examenes.examenes, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text);
    	   seguridad          postgres    false    218    17    218            �            1259    18971 	   preguntas    TABLE     �   CREATE TABLE examenes.preguntas (
    id integer NOT NULL,
    fk_id_examen integer NOT NULL,
    fk_tipo_pregunta text NOT NULL,
    pregunta text NOT NULL,
    porcentaje integer NOT NULL
);
    DROP TABLE examenes.preguntas;
       examenes         heap    postgres    false    10                       1255    18977 k   field_audit(examenes.preguntas, examenes.preguntas, character varying, text, character varying, text, text)    FUNCTION     T
  CREATE FUNCTION seguridad.field_audit(_data_new examenes.preguntas, _data_old examenes.preguntas, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('fk_id_examen_nuevo', _data_new.fk_id_examen)::jsonb;
				_datos := _datos || json_build_object('fk_tipo_pregunta_nuevo', _data_new.fk_tipo_pregunta)::jsonb;
				_datos := _datos || json_build_object('pregunta_nuevo', _data_new.pregunta)::jsonb;
				_datos := _datos || json_build_object('porcentaje_nuevo', _data_new.porcentaje)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('fk_id_examen_anterior', _data_old.fk_id_examen)::jsonb;
				_datos := _datos || json_build_object('fk_tipo_pregunta_anterior', _data_old.fk_tipo_pregunta)::jsonb;
				_datos := _datos || json_build_object('pregunta_anterior', _data_old.pregunta)::jsonb;
				_datos := _datos || json_build_object('porcentaje_anterior', _data_old.porcentaje)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.fk_id_examen <> _data_new.fk_id_examen
				THEN _datos := _datos || json_build_object('fk_id_examen_anterior', _data_old.fk_id_examen, 'fk_id_examen_nuevo', _data_new.fk_id_examen)::jsonb;
			END IF;
			IF _data_old.fk_tipo_pregunta <> _data_new.fk_tipo_pregunta
				THEN _datos := _datos || json_build_object('fk_tipo_pregunta_anterior', _data_old.fk_tipo_pregunta, 'fk_tipo_pregunta_nuevo', _data_new.fk_tipo_pregunta)::jsonb;
			END IF;
			IF _data_old.pregunta <> _data_new.pregunta
				THEN _datos := _datos || json_build_object('pregunta_anterior', _data_old.pregunta, 'pregunta_nuevo', _data_new.pregunta)::jsonb;
			END IF;
			IF _data_old.porcentaje <> _data_new.porcentaje
				THEN _datos := _datos || json_build_object('porcentaje_anterior', _data_old.porcentaje, 'porcentaje_nuevo', _data_new.porcentaje)::jsonb;
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
			'examenes',
			'preguntas',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;
 �   DROP FUNCTION seguridad.field_audit(_data_new examenes.preguntas, _data_old examenes.preguntas, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text);
    	   seguridad          postgres    false    219    17    219            �            1259    18978 
   respuestas    TABLE     �   CREATE TABLE examenes.respuestas (
    id integer NOT NULL,
    fk_id_preguntas integer NOT NULL,
    respuesta text NOT NULL,
    estado boolean NOT NULL
);
     DROP TABLE examenes.respuestas;
       examenes         heap    postgres    false    10                       1255    18984 m   field_audit(examenes.respuestas, examenes.respuestas, character varying, text, character varying, text, text)    FUNCTION     �  CREATE FUNCTION seguridad.field_audit(_data_new examenes.respuestas, _data_old examenes.respuestas, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('fk_id_preguntas_nuevo', _data_new.fk_id_preguntas)::jsonb;
				_datos := _datos || json_build_object('respuesta_nuevo', _data_new.respuesta)::jsonb;
				_datos := _datos || json_build_object('estado_nuevo', _data_new.estado)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('fk_id_preguntas_anterior', _data_old.fk_id_preguntas)::jsonb;
				_datos := _datos || json_build_object('respuesta_anterior', _data_old.respuesta)::jsonb;
				_datos := _datos || json_build_object('estado_anterior', _data_old.estado)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.fk_id_preguntas <> _data_new.fk_id_preguntas
				THEN _datos := _datos || json_build_object('fk_id_preguntas_anterior', _data_old.fk_id_preguntas, 'fk_id_preguntas_nuevo', _data_new.fk_id_preguntas)::jsonb;
			END IF;
			IF _data_old.respuesta <> _data_new.respuesta
				THEN _datos := _datos || json_build_object('respuesta_anterior', _data_old.respuesta, 'respuesta_nuevo', _data_new.respuesta)::jsonb;
			END IF;
			IF _data_old.estado <> _data_new.estado
				THEN _datos := _datos || json_build_object('estado_anterior', _data_old.estado, 'estado_nuevo', _data_new.estado)::jsonb;
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
			'examenes',
			'respuestas',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;
 �   DROP FUNCTION seguridad.field_audit(_data_new examenes.respuestas, _data_old examenes.respuestas, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text);
    	   seguridad          postgres    false    220    17    220            �            1259    18985    mensajes    TABLE     �   CREATE TABLE mensajes.mensajes (
    id integer NOT NULL,
    fk_nombre_de_usuario_emisor text NOT NULL,
    fk_nombre_de_usuario_receptor text NOT NULL,
    contenido text NOT NULL,
    fecha timestamp without time zone NOT NULL,
    id_curso integer
);
    DROP TABLE mensajes.mensajes;
       mensajes         heap    postgres    false    18                       1255    18991 i   field_audit(mensajes.mensajes, mensajes.mensajes, character varying, text, character varying, text, text)    FUNCTION     �  CREATE FUNCTION seguridad.field_audit(_data_new mensajes.mensajes, _data_old mensajes.mensajes, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('fk_nombre_de_usuario_emisor_nuevo', _data_new.fk_nombre_de_usuario_emisor)::jsonb;
				_datos := _datos || json_build_object('fk_nombre_de_usuario_receptor_nuevo', _data_new.fk_nombre_de_usuario_receptor)::jsonb;
				_datos := _datos || json_build_object('contenido_nuevo', _data_new.contenido)::jsonb;
				_datos := _datos || json_build_object('fecha_nuevo', _data_new.fecha)::jsonb;
				_datos := _datos || json_build_object('id_curso_nuevo', _data_new.id_curso)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('fk_nombre_de_usuario_emisor_anterior', _data_old.fk_nombre_de_usuario_emisor)::jsonb;
				_datos := _datos || json_build_object('fk_nombre_de_usuario_receptor_anterior', _data_old.fk_nombre_de_usuario_receptor)::jsonb;
				_datos := _datos || json_build_object('contenido_anterior', _data_old.contenido)::jsonb;
				_datos := _datos || json_build_object('fecha_anterior', _data_old.fecha)::jsonb;
				_datos := _datos || json_build_object('id_curso_anterior', _data_old.id_curso)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.fk_nombre_de_usuario_emisor <> _data_new.fk_nombre_de_usuario_emisor
				THEN _datos := _datos || json_build_object('fk_nombre_de_usuario_emisor_anterior', _data_old.fk_nombre_de_usuario_emisor, 'fk_nombre_de_usuario_emisor_nuevo', _data_new.fk_nombre_de_usuario_emisor)::jsonb;
			END IF;
			IF _data_old.fk_nombre_de_usuario_receptor <> _data_new.fk_nombre_de_usuario_receptor
				THEN _datos := _datos || json_build_object('fk_nombre_de_usuario_receptor_anterior', _data_old.fk_nombre_de_usuario_receptor, 'fk_nombre_de_usuario_receptor_nuevo', _data_new.fk_nombre_de_usuario_receptor)::jsonb;
			END IF;
			IF _data_old.contenido <> _data_new.contenido
				THEN _datos := _datos || json_build_object('contenido_anterior', _data_old.contenido, 'contenido_nuevo', _data_new.contenido)::jsonb;
			END IF;
			IF _data_old.fecha <> _data_new.fecha
				THEN _datos := _datos || json_build_object('fecha_anterior', _data_old.fecha, 'fecha_nuevo', _data_new.fecha)::jsonb;
			END IF;
			IF _data_old.id_curso <> _data_new.id_curso
				THEN _datos := _datos || json_build_object('id_curso_anterior', _data_old.id_curso, 'id_curso_nuevo', _data_new.id_curso)::jsonb;
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
			'mensajes',
			'mensajes',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;
 �   DROP FUNCTION seguridad.field_audit(_data_new mensajes.mensajes, _data_old mensajes.mensajes, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text);
    	   seguridad          postgres    false    221    17    221            �            1259    19063    notificaciones    TABLE     �   CREATE TABLE notificaciones.notificaciones (
    id integer NOT NULL,
    mensaje text NOT NULL,
    estado boolean NOT NULL,
    fk_nombre_de_usuario text NOT NULL,
    fecha timestamp without time zone NOT NULL
);
 *   DROP TABLE notificaciones.notificaciones;
       notificaciones         heap    postgres    false    11                       1255    19341 �   field_audit(notificaciones.notificaciones, notificaciones.notificaciones, character varying, text, character varying, text, text)    FUNCTION     %
  CREATE FUNCTION seguridad.field_audit(_data_new notificaciones.notificaciones, _data_old notificaciones.notificaciones, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('mensaje_nuevo', _data_new.mensaje)::jsonb;
				_datos := _datos || json_build_object('estado_nuevo', _data_new.estado)::jsonb;
				_datos := _datos || json_build_object('fk_nombre_de_usuario_nuevo', _data_new.fk_nombre_de_usuario)::jsonb;
				_datos := _datos || json_build_object('fecha_nuevo', _data_new.fecha)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('mensaje_anterior', _data_old.mensaje)::jsonb;
				_datos := _datos || json_build_object('estado_anterior', _data_old.estado)::jsonb;
				_datos := _datos || json_build_object('fk_nombre_de_usuario_anterior', _data_old.fk_nombre_de_usuario)::jsonb;
				_datos := _datos || json_build_object('fecha_anterior', _data_old.fecha)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.mensaje <> _data_new.mensaje
				THEN _datos := _datos || json_build_object('mensaje_anterior', _data_old.mensaje, 'mensaje_nuevo', _data_new.mensaje)::jsonb;
			END IF;
			IF _data_old.estado <> _data_new.estado
				THEN _datos := _datos || json_build_object('estado_anterior', _data_old.estado, 'estado_nuevo', _data_new.estado)::jsonb;
			END IF;
			IF _data_old.fk_nombre_de_usuario <> _data_new.fk_nombre_de_usuario
				THEN _datos := _datos || json_build_object('fk_nombre_de_usuario_anterior', _data_old.fk_nombre_de_usuario, 'fk_nombre_de_usuario_nuevo', _data_new.fk_nombre_de_usuario)::jsonb;
			END IF;
			IF _data_old.fecha <> _data_new.fecha
				THEN _datos := _datos || json_build_object('fecha_anterior', _data_old.fecha, 'fecha_nuevo', _data_new.fecha)::jsonb;
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
			'notificaciones',
			'notificaciones',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;
 �   DROP FUNCTION seguridad.field_audit(_data_new notificaciones.notificaciones, _data_old notificaciones.notificaciones, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text);
    	   seguridad          postgres    false    238    17    238            �            1259    18992    puntuaciones    TABLE     �   CREATE TABLE puntuaciones.puntuaciones (
    id integer NOT NULL,
    emisor text NOT NULL,
    receptor text,
    puntuacion integer NOT NULL,
    id_curso integer
);
 &   DROP TABLE puntuaciones.puntuaciones;
       puntuaciones         heap    postgres    false    14                       1255    18998 y   field_audit(puntuaciones.puntuaciones, puntuaciones.puntuaciones, character varying, text, character varying, text, text)    FUNCTION     �	  CREATE FUNCTION seguridad.field_audit(_data_new puntuaciones.puntuaciones, _data_old puntuaciones.puntuaciones, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('emisor_nuevo', _data_new.emisor)::jsonb;
				_datos := _datos || json_build_object('receptor_nuevo', _data_new.receptor)::jsonb;
				_datos := _datos || json_build_object('puntuacion_nuevo', _data_new.puntuacion)::jsonb;
				_datos := _datos || json_build_object('id_curso_nuevo', _data_new.id_curso)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('emisor_anterior', _data_old.emisor)::jsonb;
				_datos := _datos || json_build_object('receptor_anterior', _data_old.receptor)::jsonb;
				_datos := _datos || json_build_object('puntuacion_anterior', _data_old.puntuacion)::jsonb;
				_datos := _datos || json_build_object('id_curso_anterior', _data_old.id_curso)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.emisor <> _data_new.emisor
				THEN _datos := _datos || json_build_object('emisor_anterior', _data_old.emisor, 'emisor_nuevo', _data_new.emisor)::jsonb;
			END IF;
			IF _data_old.receptor <> _data_new.receptor
				THEN _datos := _datos || json_build_object('receptor_anterior', _data_old.receptor, 'receptor_nuevo', _data_new.receptor)::jsonb;
			END IF;
			IF _data_old.puntuacion <> _data_new.puntuacion
				THEN _datos := _datos || json_build_object('puntuacion_anterior', _data_old.puntuacion, 'puntuacion_nuevo', _data_new.puntuacion)::jsonb;
			END IF;
			IF _data_old.id_curso <> _data_new.id_curso
				THEN _datos := _datos || json_build_object('id_curso_anterior', _data_old.id_curso, 'id_curso_nuevo', _data_new.id_curso)::jsonb;
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
			'puntuaciones',
			'puntuaciones',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;
 �   DROP FUNCTION seguridad.field_audit(_data_new puntuaciones.puntuaciones, _data_old puntuaciones.puntuaciones, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text);
    	   seguridad          postgres    false    222    17    222            �            1259    18999    motivos    TABLE     �   CREATE TABLE reportes.motivos (
    motivo text NOT NULL,
    dias_para_reportar integer NOT NULL,
    puntuacion_para_el_bloqueo integer NOT NULL
);
    DROP TABLE reportes.motivos;
       reportes         heap    postgres    false    5            �            1255    19005 g   field_audit(reportes.motivos, reportes.motivos, character varying, text, character varying, text, text)    FUNCTION     A  CREATE FUNCTION seguridad.field_audit(_data_new reportes.motivos, _data_old reportes.motivos, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		_column_data :=  _data_new.motivo;
		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('motivo_nuevo', _data_new.motivo)::jsonb;
				_datos := _datos || json_build_object('dias_para_reportar_nuevo', _data_new.dias_para_reportar)::jsonb;
				_datos := _datos || json_build_object('puntuacion_para_el_bloqueo_nuevo', _data_new.puntuacion_para_el_bloqueo)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('motivo_anterior', _data_old.motivo)::jsonb;
				_datos := _datos || json_build_object('dias_para_reportar_anterior', _data_old.dias_para_reportar)::jsonb;
				_datos := _datos || json_build_object('puntuacion_para_el_bloqueo_anterior', _data_old.puntuacion_para_el_bloqueo)::jsonb;
				
		ELSE
			IF _data_old.motivo <> _data_new.motivo
				THEN _datos := _datos || json_build_object('motivo_anterior', _data_old.motivo, 'motivo_nuevo', _data_new.motivo)::jsonb;
			END IF;
			IF _data_old.dias_para_reportar <> _data_new.dias_para_reportar
				THEN _datos := _datos || json_build_object('dias_para_reportar_anterior', _data_old.dias_para_reportar, 'dias_para_reportar_nuevo', _data_new.dias_para_reportar)::jsonb;
			END IF;
			IF _data_old.puntuacion_para_el_bloqueo <> _data_new.puntuacion_para_el_bloqueo
				THEN _datos := _datos || json_build_object('puntuacion_para_el_bloqueo_anterior', _data_old.puntuacion_para_el_bloqueo, 'puntuacion_para_el_bloqueo_nuevo', _data_new.puntuacion_para_el_bloqueo)::jsonb;
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
			'reportes',
			'motivos',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;
 �   DROP FUNCTION seguridad.field_audit(_data_new reportes.motivos, _data_old reportes.motivos, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text);
    	   seguridad          postgres    false    17    223    223            �            1259    19006    reportes    TABLE     \  CREATE TABLE reportes.reportes (
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
       reportes         heap    postgres    false    5                       1255    19012 i   field_audit(reportes.reportes, reportes.reportes, character varying, text, character varying, text, text)    FUNCTION     �  CREATE FUNCTION seguridad.field_audit(_data_new reportes.reportes, _data_old reportes.reportes, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('fk_nombre_de_usuario_denunciante_nuevo', _data_new.fk_nombre_de_usuario_denunciante)::jsonb;
				_datos := _datos || json_build_object('fk_nombre_de_usuario_denunciado_nuevo', _data_new.fk_nombre_de_usuario_denunciado)::jsonb;
				_datos := _datos || json_build_object('fk_motivo_nuevo', _data_new.fk_motivo)::jsonb;
				_datos := _datos || json_build_object('descripcion_nuevo', _data_new.descripcion)::jsonb;
				_datos := _datos || json_build_object('estado_nuevo', _data_new.estado)::jsonb;
				_datos := _datos || json_build_object('fk_id_comentario_nuevo', _data_new.fk_id_comentario)::jsonb;
				_datos := _datos || json_build_object('fk_id_mensaje_nuevo', _data_new.fk_id_mensaje)::jsonb;
				_datos := _datos || json_build_object('fecha_nuevo', _data_new.fecha)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('fk_nombre_de_usuario_denunciante_anterior', _data_old.fk_nombre_de_usuario_denunciante)::jsonb;
				_datos := _datos || json_build_object('fk_nombre_de_usuario_denunciado_anterior', _data_old.fk_nombre_de_usuario_denunciado)::jsonb;
				_datos := _datos || json_build_object('fk_motivo_anterior', _data_old.fk_motivo)::jsonb;
				_datos := _datos || json_build_object('descripcion_anterior', _data_old.descripcion)::jsonb;
				_datos := _datos || json_build_object('estado_anterior', _data_old.estado)::jsonb;
				_datos := _datos || json_build_object('fk_id_comentario_anterior', _data_old.fk_id_comentario)::jsonb;
				_datos := _datos || json_build_object('fk_id_mensaje_anterior', _data_old.fk_id_mensaje)::jsonb;
				_datos := _datos || json_build_object('fecha_anterior', _data_old.fecha)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.fk_nombre_de_usuario_denunciante <> _data_new.fk_nombre_de_usuario_denunciante
				THEN _datos := _datos || json_build_object('fk_nombre_de_usuario_denunciante_anterior', _data_old.fk_nombre_de_usuario_denunciante, 'fk_nombre_de_usuario_denunciante_nuevo', _data_new.fk_nombre_de_usuario_denunciante)::jsonb;
			END IF;
			IF _data_old.fk_nombre_de_usuario_denunciado <> _data_new.fk_nombre_de_usuario_denunciado
				THEN _datos := _datos || json_build_object('fk_nombre_de_usuario_denunciado_anterior', _data_old.fk_nombre_de_usuario_denunciado, 'fk_nombre_de_usuario_denunciado_nuevo', _data_new.fk_nombre_de_usuario_denunciado)::jsonb;
			END IF;
			IF _data_old.fk_motivo <> _data_new.fk_motivo
				THEN _datos := _datos || json_build_object('fk_motivo_anterior', _data_old.fk_motivo, 'fk_motivo_nuevo', _data_new.fk_motivo)::jsonb;
			END IF;
			IF _data_old.descripcion <> _data_new.descripcion
				THEN _datos := _datos || json_build_object('descripcion_anterior', _data_old.descripcion, 'descripcion_nuevo', _data_new.descripcion)::jsonb;
			END IF;
			IF _data_old.estado <> _data_new.estado
				THEN _datos := _datos || json_build_object('estado_anterior', _data_old.estado, 'estado_nuevo', _data_new.estado)::jsonb;
			END IF;
			IF _data_old.fk_id_comentario <> _data_new.fk_id_comentario
				THEN _datos := _datos || json_build_object('fk_id_comentario_anterior', _data_old.fk_id_comentario, 'fk_id_comentario_nuevo', _data_new.fk_id_comentario)::jsonb;
			END IF;
			IF _data_old.fk_id_mensaje <> _data_new.fk_id_mensaje
				THEN _datos := _datos || json_build_object('fk_id_mensaje_anterior', _data_old.fk_id_mensaje, 'fk_id_mensaje_nuevo', _data_new.fk_id_mensaje)::jsonb;
			END IF;
			IF _data_old.fecha <> _data_new.fecha
				THEN _datos := _datos || json_build_object('fecha_anterior', _data_old.fecha, 'fecha_nuevo', _data_new.fecha)::jsonb;
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
			'reportes',
			'reportes',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;
 �   DROP FUNCTION seguridad.field_audit(_data_new reportes.reportes, _data_old reportes.reportes, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text);
    	   seguridad          postgres    false    17    224    224            �            1259    19013    sugerencias    TABLE     �   CREATE TABLE sugerencias.sugerencias (
    id integer NOT NULL,
    fk_nombre_de_usuario_emisor text,
    contenido text NOT NULL,
    estado boolean NOT NULL,
    imagenes text,
    titulo text NOT NULL,
    fecha timestamp with time zone NOT NULL
);
 $   DROP TABLE sugerencias.sugerencias;
       sugerencias         heap    postgres    false    12                       1255    19019 u   field_audit(sugerencias.sugerencias, sugerencias.sugerencias, character varying, text, character varying, text, text)    FUNCTION     ?  CREATE FUNCTION seguridad.field_audit(_data_new sugerencias.sugerencias, _data_old sugerencias.sugerencias, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('fk_nombre_de_usuario_emisor_nuevo', _data_new.fk_nombre_de_usuario_emisor)::jsonb;
				_datos := _datos || json_build_object('contenido_nuevo', _data_new.contenido)::jsonb;
				_datos := _datos || json_build_object('estado_nuevo', _data_new.estado)::jsonb;
				_datos := _datos || json_build_object('imagenes_nuevo', _data_new.imagenes)::jsonb;
				_datos := _datos || json_build_object('titulo_nuevo', _data_new.titulo)::jsonb;
				_datos := _datos || json_build_object('fecha_nuevo', _data_new.fecha)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('fk_nombre_de_usuario_emisor_anterior', _data_old.fk_nombre_de_usuario_emisor)::jsonb;
				_datos := _datos || json_build_object('contenido_anterior', _data_old.contenido)::jsonb;
				_datos := _datos || json_build_object('estado_anterior', _data_old.estado)::jsonb;
				_datos := _datos || json_build_object('imagenes_anterior', _data_old.imagenes)::jsonb;
				_datos := _datos || json_build_object('titulo_anterior', _data_old.titulo)::jsonb;
				_datos := _datos || json_build_object('fecha_anterior', _data_old.fecha)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.fk_nombre_de_usuario_emisor <> _data_new.fk_nombre_de_usuario_emisor
				THEN _datos := _datos || json_build_object('fk_nombre_de_usuario_emisor_anterior', _data_old.fk_nombre_de_usuario_emisor, 'fk_nombre_de_usuario_emisor_nuevo', _data_new.fk_nombre_de_usuario_emisor)::jsonb;
			END IF;
			IF _data_old.contenido <> _data_new.contenido
				THEN _datos := _datos || json_build_object('contenido_anterior', _data_old.contenido, 'contenido_nuevo', _data_new.contenido)::jsonb;
			END IF;
			IF _data_old.estado <> _data_new.estado
				THEN _datos := _datos || json_build_object('estado_anterior', _data_old.estado, 'estado_nuevo', _data_new.estado)::jsonb;
			END IF;
			IF _data_old.imagenes <> _data_new.imagenes
				THEN _datos := _datos || json_build_object('imagenes_anterior', _data_old.imagenes, 'imagenes_nuevo', _data_new.imagenes)::jsonb;
			END IF;
			IF _data_old.titulo <> _data_new.titulo
				THEN _datos := _datos || json_build_object('titulo_anterior', _data_old.titulo, 'titulo_nuevo', _data_new.titulo)::jsonb;
			END IF;
			IF _data_old.fecha <> _data_new.fecha
				THEN _datos := _datos || json_build_object('fecha_anterior', _data_old.fecha, 'fecha_nuevo', _data_new.fecha)::jsonb;
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
			'sugerencias',
			'sugerencias',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;
 �   DROP FUNCTION seguridad.field_audit(_data_new sugerencias.sugerencias, _data_old sugerencias.sugerencias, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text);
    	   seguridad          postgres    false    225    17    225            �            1259    19020    temas    TABLE     �   CREATE TABLE temas.temas (
    id integer NOT NULL,
    fk_id_curso integer NOT NULL,
    titulo text NOT NULL,
    informacion text NOT NULL,
    imagenes text[]
);
    DROP TABLE temas.temas;
       temas         heap    postgres    false    7                       1255    19026 ]   field_audit(temas.temas, temas.temas, character varying, text, character varying, text, text)    FUNCTION     �	  CREATE FUNCTION seguridad.field_audit(_data_new temas.temas, _data_old temas.temas, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('fk_id_curso_nuevo', _data_new.fk_id_curso)::jsonb;
				_datos := _datos || json_build_object('titulo_nuevo', _data_new.titulo)::jsonb;
				_datos := _datos || json_build_object('informacion_nuevo', _data_new.informacion)::jsonb;
				_datos := _datos || json_build_object('imagenes_nuevo', _data_new.imagenes)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('fk_id_curso_anterior', _data_old.fk_id_curso)::jsonb;
				_datos := _datos || json_build_object('titulo_anterior', _data_old.titulo)::jsonb;
				_datos := _datos || json_build_object('informacion_anterior', _data_old.informacion)::jsonb;
				_datos := _datos || json_build_object('imagenes_anterior', _data_old.imagenes)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.fk_id_curso <> _data_new.fk_id_curso
				THEN _datos := _datos || json_build_object('fk_id_curso_anterior', _data_old.fk_id_curso, 'fk_id_curso_nuevo', _data_new.fk_id_curso)::jsonb;
			END IF;
			IF _data_old.titulo <> _data_new.titulo
				THEN _datos := _datos || json_build_object('titulo_anterior', _data_old.titulo, 'titulo_nuevo', _data_new.titulo)::jsonb;
			END IF;
			IF _data_old.informacion <> _data_new.informacion
				THEN _datos := _datos || json_build_object('informacion_anterior', _data_old.informacion, 'informacion_nuevo', _data_new.informacion)::jsonb;
			END IF;
			IF _data_old.imagenes <> _data_new.imagenes
				THEN _datos := _datos || json_build_object('imagenes_anterior', _data_old.imagenes, 'imagenes_nuevo', _data_new.imagenes)::jsonb;
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
			'temas',
			'temas',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;
 �   DROP FUNCTION seguridad.field_audit(_data_new temas.temas, _data_old temas.temas, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text);
    	   seguridad          postgres    false    226    17    226            �            1259    19027    usuarios    TABLE     {  CREATE TABLE usuarios.usuarios (
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
       usuarios         heap    postgres    false    9                       1255    19033 i   field_audit(usuarios.usuarios, usuarios.usuarios, character varying, text, character varying, text, text)    FUNCTION     "  CREATE FUNCTION seguridad.field_audit(_data_new usuarios.usuarios, _data_old usuarios.usuarios, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
    	   seguridad          postgres    false    227    227    17                       1255    19034 9   f_eliminar_usuarios_con_token_vencido_estado_activacion()    FUNCTION       CREATE FUNCTION usuarios.f_eliminar_usuarios_con_token_vencido_estado_activacion() RETURNS SETOF void
    LANGUAGE plpgsql
    AS $$

begin
	
	DELETE FROM usuarios.usuarios
	WHERE 
	fk_estado = 'espera de activacion' and vencimiento_token<current_timestamp;
	end

$$;
 R   DROP FUNCTION usuarios.f_eliminar_usuarios_con_token_vencido_estado_activacion();
       usuarios          postgres    false    9            �            1259    19035    comentarios_id_seq    SEQUENCE     �   CREATE SEQUENCE comentarios.comentarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE comentarios.comentarios_id_seq;
       comentarios          postgres    false    16    213            =           0    0    comentarios_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE comentarios.comentarios_id_seq OWNED BY comentarios.comentarios.id;
          comentarios          postgres    false    228            �            1259    19037    areas    TABLE     O   CREATE TABLE cursos.areas (
    area text NOT NULL,
    icono text NOT NULL
);
    DROP TABLE cursos.areas;
       cursos         heap    postgres    false    8            �            1259    19043    cursos_id_seq    SEQUENCE     �   CREATE SEQUENCE cursos.cursos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE cursos.cursos_id_seq;
       cursos          postgres    false    8    214            >           0    0    cursos_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE cursos.cursos_id_seq OWNED BY cursos.cursos.id;
          cursos          postgres    false    230            �            1259    19045    inscripciones_cursos_id_seq    SEQUENCE     �   CREATE SEQUENCE cursos.inscripciones_cursos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE cursos.inscripciones_cursos_id_seq;
       cursos          postgres    false    8    216            ?           0    0    inscripciones_cursos_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE cursos.inscripciones_cursos_id_seq OWNED BY cursos.inscripciones_cursos.id;
          cursos          postgres    false    231            �            1259    19047    ejecucion_examen_id_seq    SEQUENCE     �   CREATE SEQUENCE examenes.ejecucion_examen_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE examenes.ejecucion_examen_id_seq;
       examenes          postgres    false    217    10            @           0    0    ejecucion_examen_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE examenes.ejecucion_examen_id_seq OWNED BY examenes.ejecucion_examen.id;
          examenes          postgres    false    232            �            1259    19049    examenes_id_seq    SEQUENCE     �   CREATE SEQUENCE examenes.examenes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE examenes.examenes_id_seq;
       examenes          postgres    false    10    218            A           0    0    examenes_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE examenes.examenes_id_seq OWNED BY examenes.examenes.id;
          examenes          postgres    false    233            �            1259    19051    preguntas_id_seq    SEQUENCE     �   CREATE SEQUENCE examenes.preguntas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE examenes.preguntas_id_seq;
       examenes          postgres    false    10    219            B           0    0    preguntas_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE examenes.preguntas_id_seq OWNED BY examenes.preguntas.id;
          examenes          postgres    false    234            �            1259    19053    respuestas_id_seq    SEQUENCE     �   CREATE SEQUENCE examenes.respuestas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE examenes.respuestas_id_seq;
       examenes          postgres    false    10    220            C           0    0    respuestas_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE examenes.respuestas_id_seq OWNED BY examenes.respuestas.id;
          examenes          postgres    false    235            �            1259    19055    tipos_pregunta    TABLE     A   CREATE TABLE examenes.tipos_pregunta (
    tipo text NOT NULL
);
 $   DROP TABLE examenes.tipos_pregunta;
       examenes         heap    postgres    false    10            �            1259    19061    mensajes_id_seq    SEQUENCE     �   CREATE SEQUENCE mensajes.mensajes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE mensajes.mensajes_id_seq;
       mensajes          postgres    false    221    18            D           0    0    mensajes_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE mensajes.mensajes_id_seq OWNED BY mensajes.mensajes.id;
          mensajes          postgres    false    237            �            1259    19069    notificaciones_id_seq    SEQUENCE     �   CREATE SEQUENCE notificaciones.notificaciones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE notificaciones.notificaciones_id_seq;
       notificaciones          postgres    false    238    11            E           0    0    notificaciones_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE notificaciones.notificaciones_id_seq OWNED BY notificaciones.notificaciones.id;
          notificaciones          postgres    false    239            �            1259    19071    puntuaciones_id_seq    SEQUENCE     �   CREATE SEQUENCE puntuaciones.puntuaciones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE puntuaciones.puntuaciones_id_seq;
       puntuaciones          postgres    false    14    222            F           0    0    puntuaciones_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE puntuaciones.puntuaciones_id_seq OWNED BY puntuaciones.puntuaciones.id;
          puntuaciones          postgres    false    240            �            1259    19073    reportes_id_seq    SEQUENCE     �   CREATE SEQUENCE reportes.reportes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE reportes.reportes_id_seq;
       reportes          postgres    false    224    5            G           0    0    reportes_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE reportes.reportes_id_seq OWNED BY reportes.reportes.id;
          reportes          postgres    false    241            �            1259    19075 	   auditoria    TABLE     L  CREATE TABLE seguridad.auditoria (
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
    	   seguridad         heap    postgres    false    17            H           0    0    TABLE auditoria    COMMENT     b   COMMENT ON TABLE seguridad.auditoria IS 'Tabla que almacena la trazabilidad de la informaicón.';
       	   seguridad          postgres    false    242            I           0    0    COLUMN auditoria.id    COMMENT     E   COMMENT ON COLUMN seguridad.auditoria.id IS 'campo pk de la tabla ';
       	   seguridad          postgres    false    242            J           0    0    COLUMN auditoria.fecha    COMMENT     [   COMMENT ON COLUMN seguridad.auditoria.fecha IS 'ALmacen ala la fecha de la modificación';
       	   seguridad          postgres    false    242            K           0    0    COLUMN auditoria.accion    COMMENT     g   COMMENT ON COLUMN seguridad.auditoria.accion IS 'Almacena la accion que se ejecuto sobre el registro';
       	   seguridad          postgres    false    242            L           0    0    COLUMN auditoria.schema    COMMENT     n   COMMENT ON COLUMN seguridad.auditoria.schema IS 'Almanena el nomnbre del schema de la tabla que se modifico';
       	   seguridad          postgres    false    242            M           0    0    COLUMN auditoria.tabla    COMMENT     a   COMMENT ON COLUMN seguridad.auditoria.tabla IS 'Almacena el nombre de la tabla que se modifico';
       	   seguridad          postgres    false    242            N           0    0    COLUMN auditoria.session    COMMENT     q   COMMENT ON COLUMN seguridad.auditoria.session IS 'Campo que almacena el id de la session que generó el cambio';
       	   seguridad          postgres    false    242            O           0    0    COLUMN auditoria.user_bd    COMMENT     �   COMMENT ON COLUMN seguridad.auditoria.user_bd IS 'Campo que almacena el user que se autentico en el motor para generar el cmabio';
       	   seguridad          postgres    false    242            P           0    0    COLUMN auditoria.data    COMMENT     e   COMMENT ON COLUMN seguridad.auditoria.data IS 'campo que almacena la modificaicón que se realizó';
       	   seguridad          postgres    false    242            Q           0    0    COLUMN auditoria.pk    COMMENT     X   COMMENT ON COLUMN seguridad.auditoria.pk IS 'Campo que identifica el id del registro.';
       	   seguridad          postgres    false    242            �            1259    19081    auditoria_id_seq    SEQUENCE     |   CREATE SEQUENCE seguridad.auditoria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE seguridad.auditoria_id_seq;
    	   seguridad          postgres    false    242    17            R           0    0    auditoria_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE seguridad.auditoria_id_seq OWNED BY seguridad.auditoria.id;
       	   seguridad          postgres    false    243            �            1259    19083    autentication    TABLE     �   CREATE TABLE seguridad.autentication (
    id integer NOT NULL,
    nombre_de_usuario text NOT NULL,
    ip text,
    mac text,
    fecha_inicio timestamp without time zone,
    fecha_fin timestamp without time zone,
    session text
);
 $   DROP TABLE seguridad.autentication;
    	   seguridad         heap    postgres    false    17            �            1259    19089    autentication_id_seq    SEQUENCE     �   CREATE SEQUENCE seguridad.autentication_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE seguridad.autentication_id_seq;
    	   seguridad          postgres    false    17    244            S           0    0    autentication_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE seguridad.autentication_id_seq OWNED BY seguridad.autentication.id;
       	   seguridad          postgres    false    245            �            1259    19091    function_db_view    VIEW     �  CREATE VIEW seguridad.function_db_view AS
 SELECT pp.proname AS b_function,
    oidvectortypes(pp.proargtypes) AS b_type_parameters
   FROM (pg_proc pp
     JOIN pg_namespace pn ON ((pn.oid = pp.pronamespace)))
  WHERE ((pn.nspname)::text <> ALL (ARRAY[('pg_catalog'::character varying)::text, ('information_schema'::character varying)::text, ('admin_control'::character varying)::text, ('vial'::character varying)::text]));
 &   DROP VIEW seguridad.function_db_view;
    	   seguridad          postgres    false    17            �            1259    19096    sugerencias_id_seq    SEQUENCE     �   CREATE SEQUENCE sugerencias.sugerencias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE sugerencias.sugerencias_id_seq;
       sugerencias          postgres    false    12    225            T           0    0    sugerencias_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE sugerencias.sugerencias_id_seq OWNED BY sugerencias.sugerencias.id;
          sugerencias          postgres    false    247            �            1259    19098    temas_id_seq    SEQUENCE     �   CREATE SEQUENCE temas.temas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE temas.temas_id_seq;
       temas          postgres    false    226    7            U           0    0    temas_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE temas.temas_id_seq OWNED BY temas.temas.id;
          temas          postgres    false    248            �            1259    19100    estados_usuario    TABLE     D   CREATE TABLE usuarios.estados_usuario (
    estado text NOT NULL
);
 %   DROP TABLE usuarios.estados_usuario;
       usuarios         heap    postgres    false    9            �            1259    19106    roles    TABLE     7   CREATE TABLE usuarios.roles (
    rol text NOT NULL
);
    DROP TABLE usuarios.roles;
       usuarios         heap    postgres    false    9            %           2604    19112    comentarios id    DEFAULT     z   ALTER TABLE ONLY comentarios.comentarios ALTER COLUMN id SET DEFAULT nextval('comentarios.comentarios_id_seq'::regclass);
 B   ALTER TABLE comentarios.comentarios ALTER COLUMN id DROP DEFAULT;
       comentarios          postgres    false    228    213            &           2604    19113 	   cursos id    DEFAULT     f   ALTER TABLE ONLY cursos.cursos ALTER COLUMN id SET DEFAULT nextval('cursos.cursos_id_seq'::regclass);
 8   ALTER TABLE cursos.cursos ALTER COLUMN id DROP DEFAULT;
       cursos          postgres    false    230    214            '           2604    19114    inscripciones_cursos id    DEFAULT     �   ALTER TABLE ONLY cursos.inscripciones_cursos ALTER COLUMN id SET DEFAULT nextval('cursos.inscripciones_cursos_id_seq'::regclass);
 F   ALTER TABLE cursos.inscripciones_cursos ALTER COLUMN id DROP DEFAULT;
       cursos          postgres    false    231    216            (           2604    19115    ejecucion_examen id    DEFAULT     ~   ALTER TABLE ONLY examenes.ejecucion_examen ALTER COLUMN id SET DEFAULT nextval('examenes.ejecucion_examen_id_seq'::regclass);
 D   ALTER TABLE examenes.ejecucion_examen ALTER COLUMN id DROP DEFAULT;
       examenes          postgres    false    232    217            )           2604    19116    examenes id    DEFAULT     n   ALTER TABLE ONLY examenes.examenes ALTER COLUMN id SET DEFAULT nextval('examenes.examenes_id_seq'::regclass);
 <   ALTER TABLE examenes.examenes ALTER COLUMN id DROP DEFAULT;
       examenes          postgres    false    233    218            *           2604    19117    preguntas id    DEFAULT     p   ALTER TABLE ONLY examenes.preguntas ALTER COLUMN id SET DEFAULT nextval('examenes.preguntas_id_seq'::regclass);
 =   ALTER TABLE examenes.preguntas ALTER COLUMN id DROP DEFAULT;
       examenes          postgres    false    234    219            +           2604    19118    respuestas id    DEFAULT     r   ALTER TABLE ONLY examenes.respuestas ALTER COLUMN id SET DEFAULT nextval('examenes.respuestas_id_seq'::regclass);
 >   ALTER TABLE examenes.respuestas ALTER COLUMN id DROP DEFAULT;
       examenes          postgres    false    235    220            ,           2604    19119    mensajes id    DEFAULT     n   ALTER TABLE ONLY mensajes.mensajes ALTER COLUMN id SET DEFAULT nextval('mensajes.mensajes_id_seq'::regclass);
 <   ALTER TABLE mensajes.mensajes ALTER COLUMN id DROP DEFAULT;
       mensajes          postgres    false    237    221            1           2604    19120    notificaciones id    DEFAULT     �   ALTER TABLE ONLY notificaciones.notificaciones ALTER COLUMN id SET DEFAULT nextval('notificaciones.notificaciones_id_seq'::regclass);
 H   ALTER TABLE notificaciones.notificaciones ALTER COLUMN id DROP DEFAULT;
       notificaciones          postgres    false    239    238            -           2604    19121    puntuaciones id    DEFAULT     ~   ALTER TABLE ONLY puntuaciones.puntuaciones ALTER COLUMN id SET DEFAULT nextval('puntuaciones.puntuaciones_id_seq'::regclass);
 D   ALTER TABLE puntuaciones.puntuaciones ALTER COLUMN id DROP DEFAULT;
       puntuaciones          postgres    false    240    222            .           2604    19122    reportes id    DEFAULT     n   ALTER TABLE ONLY reportes.reportes ALTER COLUMN id SET DEFAULT nextval('reportes.reportes_id_seq'::regclass);
 <   ALTER TABLE reportes.reportes ALTER COLUMN id DROP DEFAULT;
       reportes          postgres    false    241    224            2           2604    19123    auditoria id    DEFAULT     r   ALTER TABLE ONLY seguridad.auditoria ALTER COLUMN id SET DEFAULT nextval('seguridad.auditoria_id_seq'::regclass);
 >   ALTER TABLE seguridad.auditoria ALTER COLUMN id DROP DEFAULT;
    	   seguridad          postgres    false    243    242            3           2604    19124    autentication id    DEFAULT     z   ALTER TABLE ONLY seguridad.autentication ALTER COLUMN id SET DEFAULT nextval('seguridad.autentication_id_seq'::regclass);
 B   ALTER TABLE seguridad.autentication ALTER COLUMN id DROP DEFAULT;
    	   seguridad          postgres    false    245    244            /           2604    19125    sugerencias id    DEFAULT     z   ALTER TABLE ONLY sugerencias.sugerencias ALTER COLUMN id SET DEFAULT nextval('sugerencias.sugerencias_id_seq'::regclass);
 B   ALTER TABLE sugerencias.sugerencias ALTER COLUMN id DROP DEFAULT;
       sugerencias          postgres    false    247    225            0           2604    19126    temas id    DEFAULT     b   ALTER TABLE ONLY temas.temas ALTER COLUMN id SET DEFAULT nextval('temas.temas_id_seq'::regclass);
 6   ALTER TABLE temas.temas ALTER COLUMN id DROP DEFAULT;
       temas          postgres    false    248    226                      0    18932    comentarios 
   TABLE DATA           �   COPY comentarios.comentarios (id, fk_nombre_de_usuario_emisor, fk_id_curso, fk_id_tema, fk_id_comentario, comentario, fecha_envio, imagenes) FROM stdin;
    comentarios          postgres    false    213   �      "          0    19037    areas 
   TABLE DATA           ,   COPY cursos.areas (area, icono) FROM stdin;
    cursos          postgres    false    229   �                0    18939    cursos 
   TABLE DATA           �   COPY cursos.cursos (id, fk_creador, fk_area, fk_estado, nombre, fecha_de_creacion, fecha_de_inicio, codigo_inscripcion, puntuacion, descripcion) FROM stdin;
    cursos          postgres    false    214                   0    18946    estados_curso 
   TABLE DATA           /   COPY cursos.estados_curso (estado) FROM stdin;
    cursos          postgres    false    215                    0    18953    inscripciones_cursos 
   TABLE DATA           k   COPY cursos.inscripciones_cursos (id, fk_nombre_de_usuario, fk_id_curso, fecha_de_inscripcion) FROM stdin;
    cursos          postgres    false    216   N                0    18960    ejecucion_examen 
   TABLE DATA           �   COPY examenes.ejecucion_examen (id, fk_nombre_de_usuario, fk_id_examen, fecha_de_ejecucion, calificacion, respuestas) FROM stdin;
    examenes          postgres    false    217   �                0    18967    examenes 
   TABLE DATA           ?   COPY examenes.examenes (id, fk_id_tema, fecha_fin) FROM stdin;
    examenes          postgres    false    218   �                0    18971 	   preguntas 
   TABLE DATA           _   COPY examenes.preguntas (id, fk_id_examen, fk_tipo_pregunta, pregunta, porcentaje) FROM stdin;
    examenes          postgres    false    219   J                0    18978 
   respuestas 
   TABLE DATA           N   COPY examenes.respuestas (id, fk_id_preguntas, respuesta, estado) FROM stdin;
    examenes          postgres    false    220   V      )          0    19055    tipos_pregunta 
   TABLE DATA           0   COPY examenes.tipos_pregunta (tipo) FROM stdin;
    examenes          postgres    false    236   	                0    18985    mensajes 
   TABLE DATA           �   COPY mensajes.mensajes (id, fk_nombre_de_usuario_emisor, fk_nombre_de_usuario_receptor, contenido, fecha, id_curso) FROM stdin;
    mensajes          postgres    false    221   |	      +          0    19063    notificaciones 
   TABLE DATA           b   COPY notificaciones.notificaciones (id, mensaje, estado, fk_nombre_de_usuario, fecha) FROM stdin;
    notificaciones          postgres    false    238   %                0    18992    puntuaciones 
   TABLE DATA           X   COPY puntuaciones.puntuaciones (id, emisor, receptor, puntuacion, id_curso) FROM stdin;
    puntuaciones          postgres    false    222   �                0    18999    motivos 
   TABLE DATA           [   COPY reportes.motivos (motivo, dias_para_reportar, puntuacion_para_el_bloqueo) FROM stdin;
    reportes          postgres    false    223   �                0    19006    reportes 
   TABLE DATA           �   COPY reportes.reportes (id, fk_nombre_de_usuario_denunciante, fk_nombre_de_usuario_denunciado, fk_motivo, descripcion, estado, fk_id_comentario, fk_id_mensaje, fecha) FROM stdin;
    reportes          postgres    false    224   E      /          0    19075 	   auditoria 
   TABLE DATA           d   COPY seguridad.auditoria (id, fecha, accion, schema, tabla, session, user_bd, data, pk) FROM stdin;
 	   seguridad          postgres    false    242   �      1          0    19083    autentication 
   TABLE DATA           l   COPY seguridad.autentication (id, nombre_de_usuario, ip, mac, fecha_inicio, fecha_fin, session) FROM stdin;
 	   seguridad          postgres    false    244   aY                0    19013    sugerencias 
   TABLE DATA           w   COPY sugerencias.sugerencias (id, fk_nombre_de_usuario_emisor, contenido, estado, imagenes, titulo, fecha) FROM stdin;
    sugerencias          postgres    false    225   |w                0    19020    temas 
   TABLE DATA           N   COPY temas.temas (id, fk_id_curso, titulo, informacion, imagenes) FROM stdin;
    temas          postgres    false    226   $z      5          0    19100    estados_usuario 
   TABLE DATA           3   COPY usuarios.estados_usuario (estado) FROM stdin;
    usuarios          postgres    false    249   �|      6          0    19106    roles 
   TABLE DATA           &   COPY usuarios.roles (rol) FROM stdin;
    usuarios          postgres    false    250   �|                 0    19027    usuarios 
   TABLE DATA           >  COPY usuarios.usuarios (nombre_de_usuario, fk_rol, fk_estado, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, correo_institucional, pass, fecha_desbloqueo, puntuacion, token, imagen_perfil, fecha_creacion, ultima_modificacion, vencimiento_token, session, descripcion, puntuacion_bloqueo) FROM stdin;
    usuarios          postgres    false    227   }      V           0    0    comentarios_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('comentarios.comentarios_id_seq', 14, true);
          comentarios          postgres    false    228            W           0    0    cursos_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('cursos.cursos_id_seq', 23, true);
          cursos          postgres    false    230            X           0    0    inscripciones_cursos_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('cursos.inscripciones_cursos_id_seq', 9, true);
          cursos          postgres    false    231            Y           0    0    ejecucion_examen_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('examenes.ejecucion_examen_id_seq', 7, true);
          examenes          postgres    false    232            Z           0    0    examenes_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('examenes.examenes_id_seq', 3, true);
          examenes          postgres    false    233            [           0    0    preguntas_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('examenes.preguntas_id_seq', 35, true);
          examenes          postgres    false    234            \           0    0    respuestas_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('examenes.respuestas_id_seq', 41, true);
          examenes          postgres    false    235            ]           0    0    mensajes_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('mensajes.mensajes_id_seq', 24, true);
          mensajes          postgres    false    237            ^           0    0    notificaciones_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('notificaciones.notificaciones_id_seq', 16, true);
          notificaciones          postgres    false    239            _           0    0    puntuaciones_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('puntuaciones.puntuaciones_id_seq', 10, true);
          puntuaciones          postgres    false    240            `           0    0    reportes_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('reportes.reportes_id_seq', 12, true);
          reportes          postgres    false    241            a           0    0    auditoria_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('seguridad.auditoria_id_seq', 515, true);
       	   seguridad          postgres    false    243            b           0    0    autentication_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('seguridad.autentication_id_seq', 482, true);
       	   seguridad          postgres    false    245            c           0    0    sugerencias_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('sugerencias.sugerencias_id_seq', 41, true);
          sugerencias          postgres    false    247            d           0    0    temas_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('temas.temas_id_seq', 11, true);
          temas          postgres    false    248            5           2606    19128    comentarios comentarios_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT comentarios_pkey PRIMARY KEY (id);
 K   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT comentarios_pkey;
       comentarios            postgres    false    213            U           2606    19130    areas areas_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY cursos.areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (area);
 :   ALTER TABLE ONLY cursos.areas DROP CONSTRAINT areas_pkey;
       cursos            postgres    false    229            7           2606    19132    cursos cursos_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT cursos_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT cursos_pkey;
       cursos            postgres    false    214            9           2606    19134    estados_curso estado_curso_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY cursos.estados_curso
    ADD CONSTRAINT estado_curso_pkey PRIMARY KEY (estado);
 I   ALTER TABLE ONLY cursos.estados_curso DROP CONSTRAINT estado_curso_pkey;
       cursos            postgres    false    215            ;           2606    19136 .   inscripciones_cursos inscripciones_cursos_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY cursos.inscripciones_cursos
    ADD CONSTRAINT inscripciones_cursos_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY cursos.inscripciones_cursos DROP CONSTRAINT inscripciones_cursos_pkey;
       cursos            postgres    false    216            =           2606    19138 &   ejecucion_examen ejecucion_examen_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY examenes.ejecucion_examen
    ADD CONSTRAINT ejecucion_examen_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY examenes.ejecucion_examen DROP CONSTRAINT ejecucion_examen_pkey;
       examenes            postgres    false    217            ?           2606    19140    examenes examenes_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY examenes.examenes
    ADD CONSTRAINT examenes_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY examenes.examenes DROP CONSTRAINT examenes_pkey;
       examenes            postgres    false    218            A           2606    19142    preguntas preguntas_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY examenes.preguntas
    ADD CONSTRAINT preguntas_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY examenes.preguntas DROP CONSTRAINT preguntas_pkey;
       examenes            postgres    false    219            C           2606    19144    respuestas respuestas_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY examenes.respuestas
    ADD CONSTRAINT respuestas_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY examenes.respuestas DROP CONSTRAINT respuestas_pkey;
       examenes            postgres    false    220            W           2606    19146 "   tipos_pregunta tipos_pregunta_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY examenes.tipos_pregunta
    ADD CONSTRAINT tipos_pregunta_pkey PRIMARY KEY (tipo);
 N   ALTER TABLE ONLY examenes.tipos_pregunta DROP CONSTRAINT tipos_pregunta_pkey;
       examenes            postgres    false    236            E           2606    19148    mensajes mensajes_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY mensajes.mensajes
    ADD CONSTRAINT mensajes_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY mensajes.mensajes DROP CONSTRAINT mensajes_pkey;
       mensajes            postgres    false    221            Y           2606    19150 "   notificaciones notificaciones_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY notificaciones.notificaciones
    ADD CONSTRAINT notificaciones_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY notificaciones.notificaciones DROP CONSTRAINT notificaciones_pkey;
       notificaciones            postgres    false    238            G           2606    19152    puntuaciones puntuaciones_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY puntuaciones.puntuaciones
    ADD CONSTRAINT puntuaciones_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY puntuaciones.puntuaciones DROP CONSTRAINT puntuaciones_pkey;
       puntuaciones            postgres    false    222            I           2606    19154    motivos motivos_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY reportes.motivos
    ADD CONSTRAINT motivos_pkey PRIMARY KEY (motivo);
 @   ALTER TABLE ONLY reportes.motivos DROP CONSTRAINT motivos_pkey;
       reportes            postgres    false    223            K           2606    19156    reportes reportes_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT reportes_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT reportes_pkey;
       reportes            postgres    false    224            ]           2606    19158     autentication autentication_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY seguridad.autentication
    ADD CONSTRAINT autentication_pkey PRIMARY KEY (id);
 M   ALTER TABLE ONLY seguridad.autentication DROP CONSTRAINT autentication_pkey;
    	   seguridad            postgres    false    244            [           2606    19160     auditoria pk_seguridad_auditoria 
   CONSTRAINT     a   ALTER TABLE ONLY seguridad.auditoria
    ADD CONSTRAINT pk_seguridad_auditoria PRIMARY KEY (id);
 M   ALTER TABLE ONLY seguridad.auditoria DROP CONSTRAINT pk_seguridad_auditoria;
    	   seguridad            postgres    false    242            M           2606    19162    sugerencias sugerencias_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY sugerencias.sugerencias
    ADD CONSTRAINT sugerencias_pkey PRIMARY KEY (id);
 K   ALTER TABLE ONLY sugerencias.sugerencias DROP CONSTRAINT sugerencias_pkey;
       sugerencias            postgres    false    225            O           2606    19164    temas temas_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY temas.temas
    ADD CONSTRAINT temas_pkey PRIMARY KEY (id);
 9   ALTER TABLE ONLY temas.temas DROP CONSTRAINT temas_pkey;
       temas            postgres    false    226            _           2606    19166 $   estados_usuario estados_usuario_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY usuarios.estados_usuario
    ADD CONSTRAINT estados_usuario_pkey PRIMARY KEY (estado);
 P   ALTER TABLE ONLY usuarios.estados_usuario DROP CONSTRAINT estados_usuario_pkey;
       usuarios            postgres    false    249            a           2606    19168    roles roles_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY usuarios.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (rol);
 <   ALTER TABLE ONLY usuarios.roles DROP CONSTRAINT roles_pkey;
       usuarios            postgres    false    250            Q           2606    19170 $   usuarios unique_correo_institucional 
   CONSTRAINT     q   ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT unique_correo_institucional UNIQUE (correo_institucional);
 P   ALTER TABLE ONLY usuarios.usuarios DROP CONSTRAINT unique_correo_institucional;
       usuarios            postgres    false    227            S           2606    19172    usuarios usuarios_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (nombre_de_usuario);
 B   ALTER TABLE ONLY usuarios.usuarios DROP CONSTRAINT usuarios_pkey;
       usuarios            postgres    false    227                       2620    19173 &   comentarios tg_comentarios_comentarios    TRIGGER     �   CREATE TRIGGER tg_comentarios_comentarios AFTER INSERT OR DELETE OR UPDATE ON comentarios.comentarios FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 D   DROP TRIGGER tg_comentarios_comentarios ON comentarios.comentarios;
       comentarios          postgres    false    213    251            �           2620    19174    areas tg_cursos_areas    TRIGGER     �   CREATE TRIGGER tg_cursos_areas AFTER INSERT OR DELETE OR UPDATE ON cursos.areas FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 .   DROP TRIGGER tg_cursos_areas ON cursos.areas;
       cursos          postgres    false    251    229            �           2620    19175    cursos tg_cursos_cursos    TRIGGER     �   CREATE TRIGGER tg_cursos_cursos AFTER INSERT OR DELETE OR UPDATE ON cursos.cursos FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 0   DROP TRIGGER tg_cursos_cursos ON cursos.cursos;
       cursos          postgres    false    214    251            �           2620    19176 %   estados_curso tg_cursos_estados_curso    TRIGGER     �   CREATE TRIGGER tg_cursos_estados_curso AFTER INSERT OR DELETE OR UPDATE ON cursos.estados_curso FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 >   DROP TRIGGER tg_cursos_estados_curso ON cursos.estados_curso;
       cursos          postgres    false    251    215            �           2620    19177 3   inscripciones_cursos tg_cursos_inscripciones_cursos    TRIGGER     �   CREATE TRIGGER tg_cursos_inscripciones_cursos AFTER INSERT OR DELETE OR UPDATE ON cursos.inscripciones_cursos FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 L   DROP TRIGGER tg_cursos_inscripciones_cursos ON cursos.inscripciones_cursos;
       cursos          postgres    false    251    216            �           2620    19178 -   ejecucion_examen tg_examenes_ejecucion_examen    TRIGGER     �   CREATE TRIGGER tg_examenes_ejecucion_examen AFTER INSERT OR DELETE OR UPDATE ON examenes.ejecucion_examen FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 H   DROP TRIGGER tg_examenes_ejecucion_examen ON examenes.ejecucion_examen;
       examenes          postgres    false    251    217            �           2620    19179    examenes tg_examenes_examenes    TRIGGER     �   CREATE TRIGGER tg_examenes_examenes AFTER INSERT OR DELETE OR UPDATE ON examenes.examenes FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 8   DROP TRIGGER tg_examenes_examenes ON examenes.examenes;
       examenes          postgres    false    251    218            �           2620    19180    preguntas tg_examenes_preguntas    TRIGGER     �   CREATE TRIGGER tg_examenes_preguntas AFTER INSERT OR DELETE OR UPDATE ON examenes.preguntas FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 :   DROP TRIGGER tg_examenes_preguntas ON examenes.preguntas;
       examenes          postgres    false    251    219            �           2620    19181 !   respuestas tg_examenes_respuestas    TRIGGER     �   CREATE TRIGGER tg_examenes_respuestas AFTER INSERT OR DELETE OR UPDATE ON examenes.respuestas FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 <   DROP TRIGGER tg_examenes_respuestas ON examenes.respuestas;
       examenes          postgres    false    251    220            �           2620    19182 )   tipos_pregunta tg_examenes_tipos_pregunta    TRIGGER     �   CREATE TRIGGER tg_examenes_tipos_pregunta AFTER INSERT OR DELETE OR UPDATE ON examenes.tipos_pregunta FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 D   DROP TRIGGER tg_examenes_tipos_pregunta ON examenes.tipos_pregunta;
       examenes          postgres    false    251    236            �           2620    19183    mensajes tg_mensajes_mensajes    TRIGGER     �   CREATE TRIGGER tg_mensajes_mensajes AFTER INSERT OR DELETE OR UPDATE ON mensajes.mensajes FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 8   DROP TRIGGER tg_mensajes_mensajes ON mensajes.mensajes;
       mensajes          postgres    false    251    221            �           2620    19184 /   notificaciones tg_notificaciones_notificaciones    TRIGGER     �   CREATE TRIGGER tg_notificaciones_notificaciones AFTER INSERT OR DELETE OR UPDATE ON notificaciones.notificaciones FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 P   DROP TRIGGER tg_notificaciones_notificaciones ON notificaciones.notificaciones;
       notificaciones          postgres    false    251    238            �           2620    19185 )   puntuaciones tg_puntuaciones_puntuaciones    TRIGGER     �   CREATE TRIGGER tg_puntuaciones_puntuaciones AFTER INSERT OR DELETE OR UPDATE ON puntuaciones.puntuaciones FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 H   DROP TRIGGER tg_puntuaciones_puntuaciones ON puntuaciones.puntuaciones;
       puntuaciones          postgres    false    222    251            �           2620    19186    motivos tg_reportes_motivos    TRIGGER     �   CREATE TRIGGER tg_reportes_motivos AFTER INSERT OR DELETE OR UPDATE ON reportes.motivos FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 6   DROP TRIGGER tg_reportes_motivos ON reportes.motivos;
       reportes          postgres    false    251    223            �           2620    19187    reportes tg_reportes_reportes    TRIGGER     �   CREATE TRIGGER tg_reportes_reportes AFTER INSERT OR DELETE OR UPDATE ON reportes.reportes FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 8   DROP TRIGGER tg_reportes_reportes ON reportes.reportes;
       reportes          postgres    false    224    251            �           2620    19188 &   sugerencias tg_sugerencias_sugerencias    TRIGGER     �   CREATE TRIGGER tg_sugerencias_sugerencias AFTER INSERT OR DELETE OR UPDATE ON sugerencias.sugerencias FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 D   DROP TRIGGER tg_sugerencias_sugerencias ON sugerencias.sugerencias;
       sugerencias          postgres    false    251    225            �           2620    19189    temas tg_temas_temas    TRIGGER     �   CREATE TRIGGER tg_temas_temas AFTER INSERT OR DELETE OR UPDATE ON temas.temas FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 ,   DROP TRIGGER tg_temas_temas ON temas.temas;
       temas          postgres    false    251    226            �           2620    19190 +   estados_usuario tg_usuarios_estados_usuario    TRIGGER     �   CREATE TRIGGER tg_usuarios_estados_usuario AFTER INSERT OR DELETE OR UPDATE ON usuarios.estados_usuario FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 F   DROP TRIGGER tg_usuarios_estados_usuario ON usuarios.estados_usuario;
       usuarios          postgres    false    249    251            �           2620    19191    roles tg_usuarios_roles    TRIGGER     �   CREATE TRIGGER tg_usuarios_roles AFTER INSERT OR DELETE OR UPDATE ON usuarios.roles FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 2   DROP TRIGGER tg_usuarios_roles ON usuarios.roles;
       usuarios          postgres    false    251    250            �           2620    19192    usuarios tg_usuarios_usuarios    TRIGGER     �   CREATE TRIGGER tg_usuarios_usuarios AFTER INSERT OR DELETE OR UPDATE ON usuarios.usuarios FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 8   DROP TRIGGER tg_usuarios_usuarios ON usuarios.usuarios;
       usuarios          postgres    false    227    251            b           2606    19193    comentarios fkcomentario107416    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario107416 FOREIGN KEY (fk_nombre_de_usuario_emisor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario107416;
       comentarios          postgres    false    227    213    2899            c           2606    19198    comentarios fkcomentario298131    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario298131 FOREIGN KEY (fk_id_tema) REFERENCES temas.temas(id);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario298131;
       comentarios          postgres    false    213    226    2895            d           2606    19203    comentarios fkcomentario605734    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario605734 FOREIGN KEY (fk_id_curso) REFERENCES cursos.cursos(id);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario605734;
       comentarios          postgres    false    214    213    2871            e           2606    19208    comentarios fkcomentario954929    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario954929 FOREIGN KEY (fk_id_comentario) REFERENCES comentarios.comentarios(id);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario954929;
       comentarios          postgres    false    213    2869    213            f           2606    19213    cursos fkcursos287281    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT fkcursos287281 FOREIGN KEY (fk_estado) REFERENCES cursos.estados_curso(estado);
 ?   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT fkcursos287281;
       cursos          postgres    false    214    2873    215            g           2606    19218    cursos fkcursos395447    FK CONSTRAINT     v   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT fkcursos395447 FOREIGN KEY (fk_area) REFERENCES cursos.areas(area);
 ?   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT fkcursos395447;
       cursos          postgres    false    2901    214    229            h           2606    19223    cursos fkcursos742472    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT fkcursos742472 FOREIGN KEY (fk_creador) REFERENCES usuarios.usuarios(nombre_de_usuario);
 ?   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT fkcursos742472;
       cursos          postgres    false    227    2899    214            i           2606    19228 &   inscripciones_cursos fkinscripcio18320    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.inscripciones_cursos
    ADD CONSTRAINT fkinscripcio18320 FOREIGN KEY (fk_id_curso) REFERENCES cursos.cursos(id);
 P   ALTER TABLE ONLY cursos.inscripciones_cursos DROP CONSTRAINT fkinscripcio18320;
       cursos          postgres    false    214    216    2871            j           2606    19233 '   inscripciones_cursos fkinscripcio893145    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.inscripciones_cursos
    ADD CONSTRAINT fkinscripcio893145 FOREIGN KEY (fk_nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 Q   ALTER TABLE ONLY cursos.inscripciones_cursos DROP CONSTRAINT fkinscripcio893145;
       cursos          postgres    false    227    216    2899            k           2606    19238 #   ejecucion_examen fkejecucion_455924    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.ejecucion_examen
    ADD CONSTRAINT fkejecucion_455924 FOREIGN KEY (fk_nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 O   ALTER TABLE ONLY examenes.ejecucion_examen DROP CONSTRAINT fkejecucion_455924;
       examenes          postgres    false    227    2899    217            l           2606    19243 #   ejecucion_examen fkejecucion_678612    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.ejecucion_examen
    ADD CONSTRAINT fkejecucion_678612 FOREIGN KEY (fk_id_examen) REFERENCES examenes.examenes(id);
 O   ALTER TABLE ONLY examenes.ejecucion_examen DROP CONSTRAINT fkejecucion_678612;
       examenes          postgres    false    218    217    2879            m           2606    19248    examenes fkexamenes946263    FK CONSTRAINT     |   ALTER TABLE ONLY examenes.examenes
    ADD CONSTRAINT fkexamenes946263 FOREIGN KEY (fk_id_tema) REFERENCES temas.temas(id);
 E   ALTER TABLE ONLY examenes.examenes DROP CONSTRAINT fkexamenes946263;
       examenes          postgres    false    218    226    2895            n           2606    19253    preguntas fkpreguntas592721    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.preguntas
    ADD CONSTRAINT fkpreguntas592721 FOREIGN KEY (fk_id_examen) REFERENCES examenes.examenes(id);
 G   ALTER TABLE ONLY examenes.preguntas DROP CONSTRAINT fkpreguntas592721;
       examenes          postgres    false    219    2879    218            o           2606    19258    preguntas fkpreguntas985578    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.preguntas
    ADD CONSTRAINT fkpreguntas985578 FOREIGN KEY (fk_tipo_pregunta) REFERENCES examenes.tipos_pregunta(tipo);
 G   ALTER TABLE ONLY examenes.preguntas DROP CONSTRAINT fkpreguntas985578;
       examenes          postgres    false    2903    219    236            p           2606    19263    respuestas fkrespuestas516290    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.respuestas
    ADD CONSTRAINT fkrespuestas516290 FOREIGN KEY (fk_id_preguntas) REFERENCES examenes.preguntas(id);
 I   ALTER TABLE ONLY examenes.respuestas DROP CONSTRAINT fkrespuestas516290;
       examenes          postgres    false    220    219    2881            q           2606    19268    mensajes fkmensajes16841    FK CONSTRAINT     �   ALTER TABLE ONLY mensajes.mensajes
    ADD CONSTRAINT fkmensajes16841 FOREIGN KEY (fk_nombre_de_usuario_receptor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 D   ALTER TABLE ONLY mensajes.mensajes DROP CONSTRAINT fkmensajes16841;
       mensajes          postgres    false    227    221    2899            r           2606    19273    mensajes fkmensajes33437    FK CONSTRAINT     �   ALTER TABLE ONLY mensajes.mensajes
    ADD CONSTRAINT fkmensajes33437 FOREIGN KEY (fk_nombre_de_usuario_emisor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 D   ALTER TABLE ONLY mensajes.mensajes DROP CONSTRAINT fkmensajes33437;
       mensajes          postgres    false    227    221    2899            }           2606    19278 !   notificaciones fknotificaci697604    FK CONSTRAINT     �   ALTER TABLE ONLY notificaciones.notificaciones
    ADD CONSTRAINT fknotificaci697604 FOREIGN KEY (fk_nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 S   ALTER TABLE ONLY notificaciones.notificaciones DROP CONSTRAINT fknotificaci697604;
       notificaciones          postgres    false    227    238    2899            s           2606    19283 %   puntuaciones puntuaciones_emisor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY puntuaciones.puntuaciones
    ADD CONSTRAINT puntuaciones_emisor_fkey FOREIGN KEY (emisor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 U   ALTER TABLE ONLY puntuaciones.puntuaciones DROP CONSTRAINT puntuaciones_emisor_fkey;
       puntuaciones          postgres    false    2899    227    222            t           2606    19288 '   puntuaciones puntuaciones_receptor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY puntuaciones.puntuaciones
    ADD CONSTRAINT puntuaciones_receptor_fkey FOREIGN KEY (receptor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 W   ALTER TABLE ONLY puntuaciones.puntuaciones DROP CONSTRAINT puntuaciones_receptor_fkey;
       puntuaciones          postgres    false    227    222    2899            u           2606    19293    reportes fkreportes50539    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT fkreportes50539 FOREIGN KEY (fk_nombre_de_usuario_denunciado) REFERENCES usuarios.usuarios(nombre_de_usuario);
 D   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT fkreportes50539;
       reportes          postgres    false    224    227    2899            v           2606    19298    reportes fkreportes843275    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT fkreportes843275 FOREIGN KEY (fk_nombre_de_usuario_denunciante) REFERENCES usuarios.usuarios(nombre_de_usuario);
 E   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT fkreportes843275;
       reportes          postgres    false    224    2899    227            w           2606    19303 '   reportes reportes_fk_id_comentario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT reportes_fk_id_comentario_fkey FOREIGN KEY (fk_id_comentario) REFERENCES comentarios.comentarios(id);
 S   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT reportes_fk_id_comentario_fkey;
       reportes          postgres    false    213    2869    224            x           2606    19308 $   reportes reportes_fk_id_mensaje_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT reportes_fk_id_mensaje_fkey FOREIGN KEY (fk_id_mensaje) REFERENCES mensajes.mensajes(id);
 P   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT reportes_fk_id_mensaje_fkey;
       reportes          postgres    false    224    2885    221            ~           2606    19313 '   autentication fk_autentication_usuarios    FK CONSTRAINT     �   ALTER TABLE ONLY seguridad.autentication
    ADD CONSTRAINT fk_autentication_usuarios FOREIGN KEY (nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 T   ALTER TABLE ONLY seguridad.autentication DROP CONSTRAINT fk_autentication_usuarios;
    	   seguridad          postgres    false    244    227    2899            y           2606    19318    sugerencias fksugerencia433827    FK CONSTRAINT     �   ALTER TABLE ONLY sugerencias.sugerencias
    ADD CONSTRAINT fksugerencia433827 FOREIGN KEY (fk_nombre_de_usuario_emisor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 M   ALTER TABLE ONLY sugerencias.sugerencias DROP CONSTRAINT fksugerencia433827;
       sugerencias          postgres    false    225    2899    227            z           2606    19323    temas fktemas249223    FK CONSTRAINT     v   ALTER TABLE ONLY temas.temas
    ADD CONSTRAINT fktemas249223 FOREIGN KEY (fk_id_curso) REFERENCES cursos.cursos(id);
 <   ALTER TABLE ONLY temas.temas DROP CONSTRAINT fktemas249223;
       temas          postgres    false    214    2871    226            {           2606    19328    usuarios fkusuarios355026    FK CONSTRAINT     |   ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT fkusuarios355026 FOREIGN KEY (fk_rol) REFERENCES usuarios.roles(rol);
 E   ALTER TABLE ONLY usuarios.usuarios DROP CONSTRAINT fkusuarios355026;
       usuarios          postgres    false    227    250    2913            |           2606    19333    usuarios fkusuarios94770    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT fkusuarios94770 FOREIGN KEY (fk_estado) REFERENCES usuarios.estados_usuario(estado);
 D   ALTER TABLE ONLY usuarios.usuarios DROP CONSTRAINT fkusuarios94770;
       usuarios          postgres    false    249    2911    227               �   x�u��
�0���S��$5F{��y��a�C����"B�!���A��6����:�#d���Cl��W9pN��8 ���tM�Q]���?��ݏ�ɏ���!+�\��d=��Q;�+�XF��v�š?�O��Oe%av�CwJ�d�,�j�o�����L�      "   k   x�s�L�K�L,Vp:��839���N?(5���8�X�371=5/�H���/v,JM,�wFסW����T��Ztxm"A��B��d��a3TX�IQ>a`U`�1z\\\ ?�X�         �  x����n�0�����`�M��r˶6�ڮ��(U�ɀN�0���M`O��q�)�@�����?>�ap&K�L��� �F?�f�����)}��vr��r���ŗMm���&ղT�L|�r2����10W�8��V�!�0�rUiU�3U�C�UK�تG����� �S=����Gpe��a@���~�&���7�=�˔W�_C`��v��RJ��k�U�=Z������uШ�QM�dEB�Z�*G�˦x����%��N�N.���6�S��V�f�����q8�8i��Ǽ��p#f��Ĕ�`Ƙ���G& �(]�F�m?�D�A����D��<L���}�u�&��F���������"��G�v��m2�/t��f!e����+�Cu��ԍ@�%�;���H��	�Gy�"mS�v�V���&8Ӄ�n^"��������jq�m��u8
<Ѷ1��]}�����1�����%o���\�j�Gx|��}|V6%�!\9d~            x�KL.�,��J͋O-.H-J����� ]@�         O   x�3�t+J�K�4�4202�50�56�2���L/M�150�K��Zp�#IX KX I"$,�,9�s29���F�\1z\\\ lt�         9  x��Q�N�0<;_a|NSۍ��HpA�P�S!��`�:Q� ��?VCK�D���ڇvf�3>8o�. S<���Ɛ0N�|/
�F ���]���le��N �f�Uթ��0�5\���l�izi쀋_�A<Aeo�$�}����}t�oz�d;��+�
)1Wu�r��m�����.eO���ɭ�=6�%�f��e�0d��b�ل�MX�$g�Q0sBp!*�~�5��|b�EA�c��m�!��6R�Kؾ�?�nv�0W����~�a���2�[S��t;bΞ�Rji}W���)�?�O=�q6���         D   x�Eɻ�0њ��( �86<K��#�F�U��ԙtz6r����o&GZ��`tH��ڣp� ��         �   x���=N�0�k�sǻ�Tm��H��Ќ,M�`�܇�+l�D.Ƭ�����ͼ��TT�f������λ!�4d�F�wyz��y�J�gGP?O?�M�ވ��
��X��!�����6,��a�~�ۯ����m����-M ׺1w��}v�A4�`�C��rΏh8 #�j��G�}ʌA��^2�@��Jj%�%���*������~i��ΐf�P~��q-���Jg?�{�Z襬�瘟�㉔�.�         �   x�]�;�0�g�9j��522���%�.*j��B�6����.a���(*��x��C���lP\��#�2��m�ay��l'h�o�_^�u��#��[���w}︣\�c�YT,jwu��N��5N��`e�L�L�������)�f1��ˁ*�6���e�4����h�s�Iדӧ���fY�      )   M   x��=�+�$� 'U!9?O����D�������D._�\8��1)3�H��d&g���($%gd��s��qqq ��%q         �  x��TMk�@=˿B��SV;�ߢi	NJ��K���[y�2������J��?:/�ߛ7;�f �l��<��g�T�'U�-��'}�?OW�	r�� �R�9�'��a��j|��g���)ҟUfU�X��[A�+�s�ɍ_.���9�	fr�L*��%f$;dG����nSP���r�I!�!��VeZog�E�l�<�^B��M�ٯ�
��fU�<�3_�M��W�:���uf3��[��a^ܟ�-�a��_�бͺ̶�%ԁ�ˢ�
|�=\ (T �����\	&�FP���6�_a�,.ƨ���8]�P�WP:��Wa,���Ϟ�uUg�b�kJ��h2�7�*I�-s(������S5�U].�(�&Q{Ԙ7D�����d:��ب�����m�Q�X��xy�"���?����
�;0�O��h�Z�mt<���1K�d�P�Isc�@m�PW�<��r��D]�)�V��RhI47��sȹ�$��w�z�Sg�����`�����Ƴ����\`LMp�m۞g�W�Ę\O�I�F�8�%�=E�	����r2�>A6L;$���e���v���������5�*-N��^�-�e��^�;��~�6 �N9#[���j2qۜk��hZa��7-���pt��սc���/ܠ��      +   N  x���MN!���p
.����0&ƍ�t�-i��f>\x-����6.�Z8�;6��@ l.�캼M�^�%�q��!�u�����4NyhH�Z)�"������s$�π�h�R�,�
���H�r�H���%׹��������i�e.2w�a~~})rS��]���y����Q^�lj�*u�����ED�����đ��S�[�`���pg�G���Um���r�����5�6"|m��Z�N�Ms����QQDڰrUs��.�!�a:]����r���ՠ=c ���0`!�����5�U襄�1Գ0K	���Z�]Np%ޏ�-!�D8�� �x��f�         F   x����M,.I-���L/M�150�4���2�t+J�K��N���4�XBEb��*̹�� Ō�b1z\\\ �-�         \   x�s/�/N-�L,�4�4��OK�+N,VH�Q(-.M,���4�4�
p��4�4�r��+I��L�W�6��44�4kII-Rp/*-�	�r��qqq ���         r   x�34���L/M�150�t+J�K�p���,�44����4202�50�52W04�20�25�3761�4�24��N�Ʉjs/�/N-�L,�p�i5B�mhled�gninih����� �0'      /      x��}ۖ�Ƒ������Y	̌��h�K�4-˺�����I �f��]��nY����Ü}�W��F�*�	ԅ�VS$��F2"���� @�'�}JfT�	}FeD0������O�~�����.����o?�z��9_��;���ڮV�]ݺ���f�n�R�������{�G7���j�C*m�.�2I,�I)�@bF���<�-'J�Iͭu�%4c�Af��[..*/,V��r��|�}����E�	����b�!��vK;K��&7��m���o�nn�Ձ�/�9�����^/�n����2^��[ҹ;_��E���.Y�]؏��/���[4�����2ǰ|��v�*B�v���7�n_,�z���������b~��(ߟ��J��Pz���]%�˹��Y|W��-V/��<E#�0��ۋ��w��t�͓VZ'��W>�Z��on�����#��nDW}i���\z%�G�}�.�p�9C��)a�������x������ϖ]�]���{�M�����Տ0z�.�7�����ur|��^��>���է�Y����W�	@�h�3P��m���Z��Մ��D������닏�]}z��|��Ͼt�.ZԽgqF�F:K3ət&�N�~�,O��88n&I��r�p֊u��=lx$��{^cqg�E
������˫��������a�p4�/�R,b���)�/W��/�<����?������gYƜt�9NhL�1���(j�6C	��,V���jp̥�6�=(�#*�ë���@Q�O��e��ٙ@�O��z�����W�p,���O���C$�h�^��:"��`�t�s���gn�j���~���W-�^m�R�ɘ��X�	#6c�+A'��6!)
~� �Rg����S��d*���'����ۂ�qq��ɺ�������t����!�p4]o�� PQRLS�7�_n��ɓo$�*s���͏-�>���&�iJ �YJ��� 6�D
�d�f�2�8!+��K��+-��*����K~A�)�8�������$*Z6ݧ�c��s��=���wJÇ���Jx�gT�q~&DD�2���͗�y�*
���f�奭�D]�>�>��]��\������}�����]Bu�oεkn���	�Q~F���&��n�vd�P��$���PF�i��_,_�?������/���-�/���`Rm��"cZAIJ���2b8�I�ʁ��6t��0D��J���f�����II�)�Yt�f�_��>����v��r����/@�f�(���g�ET ��I@����0	���"U�d~��M���I�<N�M�&R+�#�����$9�4M���Ԯ���5O_��)J�TQ���^��]�Uk�V�V�jƧ��g��5^J����ǰ|����jrB+�PHD�f�
�-b.�9Z�R��p�&����,C׌Hy�ߜ�2�������yu��3���)�p�����;촜61ۥ�G�-=���`�noE4X�Op`�<�4�������T���{��O�~�p<O�R��3\�g�DJP=������O� ��_<��߾hqw�4V�xgd� �"�8�(ͤ�L�2�tf!�.��Z�*�:y'ݝ�W��C�=��~h�o<��,�J&cR(u�>��u����{�r01Y������=��e��-�*2�)���!蒆7��	���S�*ϸ?���'ƾ�X�&�u��X�.֔#�Ʊ���N��Y��R'�CLah!�2g���,�_��grV�j���������lD"Tf
� �~�f}�=�>Vg���H�ӻ�j�\�����j�V������>>?����E>��Jի��L��S�z�қJqρ2{=�ɉ�
�٦u�J�[?��?�3xg��L�^�>�MI pF�'yl/�8 iU�����Ơ]��Z���7����Տ_�>y����B����b:����L7LLSt#�E��X'$uY�ck,(��Oa����G��'��4��r��Hs��)۹ ꬭ|;���16�P�q��n=��Q�9&9���<ul�����E?P)j����F� 9�F���߻��|� �J���_d�-f$Xp�4�`?�c�S��ՆH*I*�p�SD����_�Dhc-2���z�b=�[_e�"T����D�Lz��5����*�[�����J=w��|˿�J�Wڑ��ixQ����Gh[�Y�%�s��(�3-9SY������R[)1 ��p�^�HD�(������4G�.��k�r�s&G+0B4������޸	#������8 �?h�S�듂�]�`Y8��WM�*z��^��$�3N�#5_c2c��Ĥ��b�) ���E$cb�\�����/�
�ۜԵ�5��#6L�1��=����
�*� Y8��7u��g�D�TO�ׯ�ѥ!Y��4��3:�[��,!,K�S"��P-�� 7K!��B���*|�Vi-�)|F�܍5�$P%�75��<������{�U� �ɩ��'͸�*��r���Nfb�Y�m�͈o0�k̜k�Sf�㵢�ڔP`�����hA�I��,�4A1���Y��$.M��:_�s)љbDY�T���w�41բ�D��L5�Gsz&hD���x)����E{��{X�a�?�c��3߮H�q}�N88�ML2���JK�ߨʴI�	s4ͤMb.Tj������i|OS���
ca�	qJ�[�Ɛ��y����!@&���/j	���)|Q��1����L<gѯ�UlR%F� $�H�C�W.#�0*5��s�<ʀ��g��=w
�.*|���Щ�PXQsJ�/�읷�I�>�S@&P��L������I� >q�	��e	�q�.a�0�&JZ�B�p�8�Nh��R�A�\jb���HXmRn��T�[1��=e��֡�O��?#���x�e��
��)�Y8��7M�:)��8�W�K�ʄ.$q�?�'x�c����d�֖H���y>εq"(�������.�tJ"��N��9���?W�j��bCJ�������A�>�����5�W�y>�\�ƈ=J�����x/oV��D�	���ZN�B/ ��_�z;��L�)��0 (�,�	F��fN˔�&��Xjx�1�%�9�hz'o����1u�MD��%gu�6~��O��5Q����=�c�4;�YM
�K*�T(3�^ŞQ�YƜ��q�xj�%,Ɍ�R���($���AS�Ѱi�EL	(�<(�;��=+��*}�qO�,��,�θ�8�DO��hH�����P�!�<�.�R��?NA�c�qN�&V4�qߕ�s�8��ϹByJ-�F�c�*�_R���R%j�w�� 9[�Ȁ yʋF����o%>%�����A�߷RC�,O᫺D���"5#�)`1�h&��\QM��%��?6I2G��%X
¡���\����<(�;��K�"�Oz��ז��'�6�^���A��?�"�S��ڲP~ �/đc�n��i&��"aI,�̘ۙ�Q08u�SG�Lƽq����.�\�"E��΍�~P��{��}X8�Ӣ^g�����"E�Wg> �?(����Cd�x5gZ�9s���d��3�d&^�V4K�LGLc���k��k�N����"|tE(%G�L4���Y+-�$NP�3�cU��3�3�w�cTVS+���f��w̼�擧Ͼ���֌�\�O�KCN��P�fߙ�"B;�Y���ݴf]\~/��W��x	V ��D���(���g�	�2�IY̵#<M��Rm���e��qi�����')�u~'�y�EJ��S�s^�f�=B������ñ�6���<���E��}�T\c��b��6%�h�DJV+�rf�W%:6�$V�h��Pd�ךS�0P����І�t�%����l;eRc}�йg����2����w9�4��{��G�����jJӑ����t��R�=+2��q*�IyL(��R��՜��oc�"I��jI�ꘑ��jw�����='����rO��u������hZ��l����:O    }l� �����M]|wj��S�4�U�VI�a�hbHlM"8pM�֏�ϴK�LS��qE$�Y���d<�j����������$��4��6h����R>3o�a�h������ﰎ/_x�*0T��@�;c<b �8��Q׬��<�bǙ��˛{�r.ާfF�o�%2� �ܔ����
�V�ۛ�rns	��]	u	���R� c�j����ؤT0H���Mq\%i"�5�J'Yf�`�'Y��$�@:c�^�Ta	����S�"�neͷ$��X������ ���!J$c�����z�ބU��ɻ\D�r����q	#�)�b%R�1��<V�i`�p�%	�{�)I,A1����/4qu�u<��
"�;|�+=���70?Y��1��b����=��D�x�^5BH�j�(7z2�Im�a����~��D��q&b�e8(�8cm�TL-ӆ�$�䗩��bF��Y�`|xR��,-ψ�xBs�!v��|�x4N�+2�1�'�D��% ���.���dX��o�ɡ�D�qJ�43���zMC+�&	�z��iP��I�+D�!v2щ�ԩ���o���)���pw,@�EL0v�3�֙Y����x3@U2���HE��$���@M�t���+yO��ң�z��9�-�C��)�{�ƨ"�Ŕ��/7�!LR��1Mc�R�� ��bA��|��7M�!������]iݧ��\�`:M�g�j9G���
��o��lA�� $��/g*_�a� � ��+��cl^clF�I�D�l�~�3��0$�0u�@�ĥDűRVgc�H�d�R��L�,v`��J�V���SN�N|M
�k�֡$��6=R����5pi��,��9�s�:��PWh� t�vQ'כz5a�^Mщ�0t₏K�sУ���kWԸ�?�V��̟�����3�BI�^]�?��iF���:/L3�w Hb��b�2���D����M?�<^"��v��c&�{ȉR������o�����n-���I�51q��r����u̔�T
�Ө:�u@��0���L~��H�`&|��:���q�Wů�,�lh[VH7	�U¥���p?�V�+�i&���P�$7D�B��o%QB�Q�Cn>5 %$�C�=�f�Iw}�Y5~Q��]�^GU����)�;�k���g\��Oǐ�ٵ�Y�ԟ��Q�Q�����y�(�|TW;%u;��Go}�9��nG�@�Vs�ƭ���6�~��0TC�i{Ky��նw�T�<O��-�mZ�#�"^��]۵#2o��#���Ek��5^G��+)N��ڷu�*vD�*���$� t\�?~(H�I��F ��#3�%���V3��.\\!��3t�{��/6�3�gR��	ϻ1���� 1A��%�G�� �u�"�y�
�L�� ��A� ��K�Jo��L�h���P��?QЕ��Vj(��p� ��g&���������Y>��@_/�������`�Lb1��=�ꯆ��i�M(�R#I�	WN	f�$���ө�[%�����<���m�?��������a�{>D��s��JUۄ����-�ʊ�^ND~�.Up��I� /�x���S��2d >І��AW+��&��%�Iɂ]� ��X�E0����b_��(��R>!`$*8]>�']W��@Z05�0X�~�� 9��~�G����tu��7z0�O�w���M���p��w�j�'�5����y?�O���\>{��o�N���O[����e���d�J!����P�t�3߁�1NM�ZQf�~�~��S0��߉�F�rR�kE"���Q��T�;��<�_�!��7m�m0#�T��⣯z��Oʉ�>��y)�[����m�2G5��{� (_�s�g�p"�4� Nk�h*c���d4����1�lCt1��?��W��C�ak��Zg��";U1�#����{יA�C2E�Y"�� �&$��|	��$j�|+&�':�`PB�;��q�ī���Нpdj����:$_`��00��<Ѵ7!��\p�]Q@�I�1�4	��ǹ����|&��-	���ǥ�^,���[�+-�É�b�4&R:�G�ep�!W>,J�A�vy'27Ɛ�Y��HX.��,G��;�g��lm݊0Z7?Z.�ז.�K�4#@�y�mK�r����O	¥>������ƊdmE��s��������Z���m=2o[ ���Ǆ�eo:��jG���¢4"�����;D� ޲\����Vݳ߂x� S_�qq)�^Jy�]����("�r�u���a^
?Z1�����#5%i����s�d_����-��AsE�G�)�v����Rн�M3�<۷�$�lG�-�)�2 �Pe��!Dm)�D+���-_B�5H��0����q�T��K|MW(E͸�N�:$���lA�1� u ƪ�I�j�*��{SǞ��f���!�˱�C0����bO�� �Ğ2��[�C�m^�`ς�%l��SO�:��xDJ|��Ğ��؇��-U�ˀ]���/%6\���-�ӱثP�	[žt0e]�#��D����^�OFc���]�^�������VB�7�`c�7a؏ l{]b߰��熄���9س��3�}(a�ؗ�l����-�ԐC��X�������d��^6��׎����a?��a��~a�ؗ�^����!#�Lp�~Jj�g(Z_G~�Wq���
�!2�
���n��'��Yv��6��>�;g�4�c�K���4b�P���ľ�.M;�����6��i��Y0T��D	�80�S~�.a*�PGP�������'gΈ�g�%�Lj�x����_|�ъ���O�Y�kK�Ff$��8s$��B�LR-3�h���F��$��Y�ad�H�J~�M�?~c���h�1
����~�]I�~J+��v�k(Y��=~B z� 1JZKJ��D�~�s2ݼ[mxƭ��^|�ԗ�;��{S�?ºq�}���vW��[bЂ���%7�����/ߊPs���|�Xn_����w��b(�d��_T�
l漕�-�&��i�����|��j��]`-ԣ.�6��vi�RD�#"���>������<���*�ub�Z�F��x'S����%����o�8��w�&5DP�pq���osꨜhs<N��>��z���),[��6�w�]a�Jզ���:h�3����M��5[�d��K�-Z��>�{�`W��~�?+�ݫ� �e��Ͻ�L����X��&&���и�T�p��I���y��D���):_������_�W���l���3!:R����,�fYβ�lU�3D�� �}�I@�.�T�Ѝ=bkY��%�Hy_E�QqI��H	�͕}���|�!)ۜ~��BD��h(�~�q��qݶ�b�7����%�������b��=TϮ�'��6IP�׍��hYX�y�\1#Fӝ��]��@g\���}�`��d�zŌkU�Rq._�l4�� �
�J3�A���|1����륏>n�i6�U�u�;4�~:�)ͥަ?�iւ�����j��˯_��\��?�~~~�nn\���빍��b�z�"��c���1 �\\=�ɵz�k��s�t��~�O���s�=��?�Ү��/��s�>��7h)�g�*1bT����>�!�nF�A��F
���(E�+7��>[�=�C�ϱL�K+Sf�2���i�=�Y�6Oo^�˯A��~={�����TH�Ϝ���1�n�����y,�`��M/�uL~�!(I�o���:��.�0��Z	���(q��$l�U�{vLo�uN�)���cwX���:7J�v�'j|��M
�s�m{��,P�u����������'�n���6C;��NUQV������A�&�(Ecc�k9JH����Гc%�R���]t��XhDiT���0D��csŰ��&�����oM$ �������??:+aPlL�J܇��I.Ƈ�/*.�T��;�TP��	i����"J�bsT�͡,���(�:
»�B�)~���}Xs���42���x��#�!��1�{����٘!d�"��T    � �sKZ+Nq��yEF�-Q�Fs�@:d�]�>Y7R;UiEŻ@�N�ORV��>�X��<1�$�'��ڹ�k��{���-}�	r\���tu{�Eec��Lp��+^�M�����g��kU��^�~ۗ�/*������:��ѿ}���(����������s��������s�ڞG(-��X�W��:�cqa?H���ɵ�ÿ�?~/?���Q(Kx���;̛9U�\���6��ͭ�����m���y�-+߭��F/�D
��zĻKh�M�S_�����``�ԁ��9"���:4��wi '@�gH�H~2R���1��X@ĥ�j<0^�}�Dj	j��Rф�:}H���M֡)�+���¡�4_�Ahd4]����$JH>F
Kh��w+�⨞ W@jИF?ϗ ��6PmWֳ8qa|{�v[����c�������v���R�(�O߇ڿ�c��瑩0���HJ�\!�g����d:K�Md�8d4"�j�x����׎�Z�1�C����o�>�n_�'Wh��n���]W�Fwd��Yc�2���]58ؠaB4�P��W��tA���:�֔Ck�'f��g;j'x�N|�?�[O_.~l߈t���l��i�?�Xk��NGt��?I�eZdZ���14'fCt���*���ם᧯����b�?��o��2�ί��򲆨���
���ڵ�����m>`��e�_���Zs��+�P�W,9o��P���%�6r?}�rɶ���%s⏬)t��9��%��%�������:��Xq~Y��:bźe���^\�����ܺ
��J��p(r��5
�{�_���KnTG6oQ���]op֨#p-�u-�G3��Z֝�x>��|�j��]h���_o�ɻ^,� �j��)!�%��E��w7���w��|��]��.�#��������p�׷^���*���c�ٶ�l�����(�f��S7�.����f�}ِ�BG\�ߞ�S,�c\
j�b�;�ѻZ\-�j�Fa
3�7�2��'�=�S�[�*y�����G/��,׃�<�?�L���6����|ʆ�$�ߋ4��h�x�o����^�\��-f-�Ŗ,B*Z�B�{����M��{�XJd�g(to��y��[w�;�{��0�z���P���u�I'�mw\ʩ�O�H�m��(�۵N���)�3H����UD������g���Y,}��r���[��t��g[G��k; ����u�k�8t���#qoxTp��x�=r>X��Y������ ��%�r����9�1e�������h���[W������9�щ�3�"��l[كTQ�?�h�u�[���R�X먋�p*�2�F�8U6��c4��H���0N�2�A��<�G��������ؚ�3���k�^�Kox~��������yq�gȑZ����<F���]�q��ګ����5]z�����zp���d2�q�
!	P�\J�����M\��v+�W�\S�2�(XҊ���{ _b���%��c{�x&�O<�\�H2 %_�J__e����W���8�ɹ��\�Hd
��ʈ�Ɉr�#�	���c��_?����G_|���Ӌ�M��P�(kH
"�$Idj�F�P2�)$R�.�ij��b帠`,pD��Dw�%|TC���fT�g�F5�����@(
'��POT6����H�bH�(p֡�ĝ#��d
�Q�QJh�h�(�����r�!^��%V��#���W0#6����Px�W�:Yp?����xrq����r�Mh}b���
U�
� ���_��)s	Ί<}ݽ2�������2��b��,��hfDF�c.s1Y�f����A*�^���7����J��Y�D����!��I���%��ϙT �������A�����`:��H�8~u�
?H-?Ve�1�)P���!��T)}p#m��J�47)1 ��8��ń*�UFg:Q̂��K���:f.��=�����\�*��K���!7���ţJ֒�W�O�x�f� M�2b���Qܚ�ۂ7E��T"�!=ь�Y⤯/PF�6(��ā���~9B3-g�e�z`����q��+ ��2���h� O�^�5���H�6�]�:�l1�Z��t5�ڌ1��Ħ/W���+��e��Ú�@��>y.uy�E@����K�`�����$�B�$δJ�ĒLgB)���3���Mx���puiL���di����vi�"��zJ�ҒJyB�ӯ{X] �EC8:��N�ݣZt��u,�4i�]��5�>�FR/3~ͽFR�!��!pF �����'�4RN�z߆B^r�h�dd�Cׄ)�R�8��4���/��&�����r��C�K8�H�yN����������u�o�|�ɓ��+NO�~��=�MO��ٓ���K$@�|	W�9����S]K],R�^�([D��������я=f�~�� �y����˘|��k-դc���;��T}��֤���R� �z��gH��>;���.�B,UJ����[�!����A�G�l�[$����o�?;:���$c,owh6g;��Ke=������]��yWC0���OwjŶ���h�Z�H�T
��1ﷁ�ڈPW��	�k?!F�k���DD�1W�0j��)���0
��s������h�%��r�`&F�Ky~��HJCQQ���1��hp�0zZZ�
�jp�/���C &JB�!D��|Y��߄�h����a���5����j0��U0*�D��S�Q��m�z�}B�Œ&ʠ��D���:�Y�%��c�$EZ����5f=����f/���U���v��q?'y�=�k(^#�8'��6@n;U�}��+��UCo*_ܤL�uCݒB��o�}���?������X�������W�oSrs��B8\=��O?����/U�i�!�k�/��.2M�$NM��iR	���L�I'BSA2����3�h�2�����^��N���.��G���=���C�pk\S�c���z}���n���~�C�=����;;��������	ҚX��R.���q�k��=:<%���� ��;�i~� '軃�b{���Hۅ�S��SřU]� 9�7�P?gz��R�4-iWwB���&Fq��[�2�k;ndT��]W��Eu��nRaH��:�Fٔ�ب��Ç._D��o ӨC� ��I��L؄0�����C//�נ�N�yY��O�� �ZÊ'�h�`���d���_�:��Al�BN��y�"��<ʿ 9�M��1*� �	�Ib &J�����fI������#O�R�����O���^�x�ڷ[���^���q=K%��NU6���l���W:��Ti!��I�qio�%���#ڌɌfh��R��S�c�1���N�θm�Ʉ��3CA+K��##�yZ�/ �����Ņ�Xċ�~����r^��3�o^7�z���7;UCqu��BRϚqqFD$r�����QAb�bɨN�qnҔ%�W%��L�B� $���	)�g�Ti��B��?������J�?��`e��tla��_��s4K�y�-Ou4�/�W��2? �FFap%�N�ɝ˗H���OX_�6b2��U���� F�IT�`�՛9F#+!YJ)B7�m*��q�Y���f���)s����NdY�O}�����쯆�����[=:c�Q��(xM�ӝ�$Fk%�`�Iu��0��7�iD).��~=Ӓlߌ���<�3���Ց'<�#�$.�'e��g��1.Q�+��&�
E��u9��+���[&���5�ğ��/?�r{s�~�JҚw�V��8�l���	�8�]L"��X�E���?��U��*h�4����������)F\4��#���TPzR^�}JJ��AB���8~��$�&Ȣ�N�o��lBc��:�SL��/h�DFtL�ܨ�q�Ϊj2�ՐevO��g���VC�����k�B�*�������s/#�^�\O	���_�)49��
�
��Z�Gwcx?���"P*�W���v|^r�do�8Vů�b�:������'o%    R^�)��Ĵ?T���aF2B�T��������H�:�G�߿1|J���<�� l/$Ѫ��jA����!�`���&zb%�oh��2&q�@��θ�3�3�?�4�c�h
��39���W.Ic������q�7���_�,�O=s'�n|Nt?�Uis���,~�^"��K��1'����R�Tu�*���_�/��"Y�����d~o �P�V��e���s�����������?�/�쭌'�nԇԖ���	�������ِ�_B��n�ӕ����×�����f���I����.�D�&��}��+=�D�g�
�K�O�݇D��3a��z�^�:�h���Ҩ�0Ҩ|	�
LL���b�֎a8�4h>�����u��a����M?���ν��#�����O-��ݱ-�A���SqG�nw�O����&�m���Q��r��$�s�Du�&�T�,��c��tG�U�P���su{dmx���dmp�.�\{@����#����{�l�]CRv�"����1V�f��k"X�f?3"�@�������y�ͮ�\y����m��\%S]3~{1�/S*�f}�M�lT.�i� �"���w��T��������ڊc��]]º�D��ҧw8 �>j�����܂�)�;j�o�H��3��X��^u54*��~@�tXV�C�������gnr�8�Mq��#R�3��&RCÖ%��N��{ũc&�$qj���>�9�p�u�(�a�q�4#�h��7,�_f{D��B82�Aj���L���G���)Ì��-��>��ݑ����݂0����/9���s���Qr:��N���٩;!R��ԑ�7D��\��Q�z4I
���(?�0��Q�	}7I�>�S�x�I��5d��LϜ���4,G��z�ix����)`��Gm(��8��>JS��I��5l�O������`m؍����`G���)a�����{���:j������}�{�H��	����	�u<48"�1r�2�|oJ{}���%*��4ߴL�����p�G��3�k�~��U}�g<�H�7���ѥ��Q]G�TA3�=J_H�خ���]�Q���yM��!���5R�z�{������~���u4�
���������r�1l�XuM���`c=Ʇ`�UuN����`G��)a�� �!H��u�s<�4Q
H����)J}Ӳ�q%I�3��&I�ó��#Wz�6�Q�{V�k���nF�S瘛�l�Q
vs4Q
�z����p��}���I�d�{��n��3�b�H���>4��KĂ�_M�F�� VO��3�v��![����ƭ�_t'U�f�ԡ�}*^�2�������p��H?�q���3��As���G��P�E~�h�Ğ]�o�I;[]��m������Q:�l��Lk�n���:��+�o��C�yZ����I|h����I_d���fϖ�׋�M�<���vK����⤛�Yh��l����p�q����'oγ%�/��}��A���iV�t���Cѻ���j1{e��킷n�Ļ�Z�cԒཀྵ��YȹH��DWM��КҐ$M�)�W��l2}�C��� }��Itݲ�.n�9^������Q�Wn_�g�q8,4�.�����|�<�ۧ�u����U�m޾[F�
:<�w���Ga5]�]z�|6��l"�&US���p
�I���]�r�OaNa}<
k�p#:9��$
�����ߓxK�N�6H�zd��<��ۑs��p(w)[:���e�&���k���0�vbݍ���Ec8$-;��N����a�ʮf�bV���,��-���̽���'�,Q�-��K�{j{/����?	[,/[w� �q����b+%j9���GDj)hǕ�ϡqgJ\�U�f�/��]��Aߘ��㍴�_�DN��Ҏe^ٝ�S��q�嬺�R�8�l�#�I����*�e#|��?������֪�*#o��&c�#�-]�oj�!w9���p޲p	ɤ�a:���LQ��w��F�+�J"7����������%����k-&���F���y#�#��!* ����������h�b�|����)�J�hhl�����:�e.����j~�kWP���OJ���o߻z��Mm�#T`H����5J���lKP�\}V8�����~0�<���ɿ��"���x�����:�M��W=g�}��(��X�
M�:Ï�Z�g�nӐ��o"��5i@�y�ʔ��Ņ;�Gg�W�B����8��W����cn����~���gOuAv�͑g ��5,�C�K���63�y�Ж����7rp%������`�����a�n�`����h�F����kI[AOM2U�q����,�7$�4F��ov��mVw:Lݽp?�,��[����	ʎ�jѺ�R2%�^���x�P���΋�lbNEd�E��%�TW�w�_���M�AVՅ	��#��(�))�Df�&,K�����P"XL9@�׉��[���:S鈸��|���懎�z:oK�:/���򱜣����|���Fq����?������6�CV+�Mhmd�Y�7{�ĺ|�~h�IyYR���A��0��-"\`�d�v�j�!�xFI���J��th'��"�Lڌ�$��U�L�W*��ʨLd�햡���%B��Td����t�#B?�ʐiV���?$Zʩ��@T�~�6��v'����:o()�n�n�΋x��L�j��\���Z�7I'w�b��K�t.L�~��׼S雲�5+�S,�m�:x��s�K����W�����٣�~;&�QҞ�@`�[���su���l8[Z¨;�\�q0���x�����s;�j��O����ķ7~��Y.��?�?x\~�(�B���������󀗿z` ��N��I@�����7�z�ZHP.��q�b|3�M�$3���H�۪�H�rI��+�3�#��l4�/�ʿ{�uK�?�j`v�;�����W�byYc��?�`um�f��/��ݓ��by�^��qǧ��P�V����'w����)wYö������K�N�%����%D/�b��;� >�ే��:���~����\6`$(I���KW>��,�U.ޥ��r��Um��wכּ(�+R���C��}��q/��Q�w���!s����'9#ɉܦbΐa;�ϳN�lZ Z����V�4w�/�W�0y�|��^����.��G�b����_����]&w_��\�=~|�H��K���K�x��Os䏯/n�чx\@z����%��v�]�����g�gh�
�m���yz�r������p[�A��A���H��4q��K�q?ܼo/��Wg��D��x׷�_��������8�H܌�����[�*�\Է���Z�S���vL| ��O���/b��`	%������6�-�
�����*�X˵�ǫ��V��ݯ|j��/��̊[ K/=��#�E/�E��w7���wM����_����j��at`g�M���aQT�(J�P���Ow#ɺ3S�Oo׸�'���Vl(Y!����W+)9e��3CԻX\,���C�r�Jr-�,VL$-\�x���_��P)�f�~f�f��0���_;��"��.e��"�4��9�������uݡ*��s�M]�X5�����[�uݻ(W˙6l�j�4��s;7D�v��$�j�b�D���բy��FQ)-�=#d���&�M1M6��s�,$u�n7��������Vd���vv{5���e��> F��ݤt�P��aM�?+�Vtr���)��^�n�M�/�V�tz�����!)Ӑ�aqA~�1$��v�6/�S�w@p�HH�Z�nL<�d�F'�Ku%4�qHNTH�Y��z�r�Vp���ы�/?�>Ǿ��-9�o���>����8��ղGDb�sjI���D@#aι� �*
�z2��ؽrI^Q.5H-e�Tk�����T3k���<�?��;>���ؑ���o�{��������Mj����c?�P�] ��42H���o���ԫ��l�ݨ���f��aTl��A��Κ��X҂D��̺u��a@D|K�V�ap v
  ��k��A�PӹW��{�̋��'��{y��-��w������~�n�}��xt��ܜ�Ono���:����Kz3�S�}0�(8GKC�H��x��}!�7����m}n5�+���I�F�A��T�;��ԧ�C8v8���<V�V�l+'u'��O@"�oN�T%���Cr��v���lF�[����RT�K��ɸD/	��]<f�`).�c�����>�ᠩ�y�g?PĠ�`h���P_pVv�=�ges��}�+=�sV����X��1�L��5�������DRҙ�b{&h"YwgK$�0�I��LE~�$8���OT������\��_�:e�tT2eٟ�yK"FS�5
��j�n)�W�/�
�q6�)�bH���\���G6]v=�8�V��7��(@�-A&�h�����2zD��9����ߙ�?������ŷ?�����5��&��$�٬�Ju�p�M�����!�xfh�݀���9�,ymΎ�O��f�1�f����Ų�t/��2��IX��Lꠞ�u7E�3�LN���_��s#��X���u��X�bZm;q��Ѳ�_T��\�����I�����_G�c��	�և���#�W���p��>���PwyJ�PL���2lk�b�D�>N?�ON랗�y��2r�E��M�[�����3�T��n(�{h�j�j�Q���@fg��d��=
u�@�'��<��¶VI����iv�h�sԾx�j�{G%x&�2^Gǈ6��b��H�oV����Qh�v9
�����>���v�%��[���]��ɏ]<5<D"�u�T>�MGF���x����z�Һ���p��9�ͷ;�-��Z�m��Dh��Ƙ�f>&�4�H����_�dHY�o
k�@V$ϰ;��m?�ZMaoD����oJ8�sl�|n�T-���@r�ŉL����똨���'����~j�1���!� �� �n��M�n�˱R-�+�	Y�tF��4�M{���@i b�$ӑ��Ib�/���b�_���M 1����TFZI������yWDN7=[Z���``�a�uq�XP��%k�C�s�R���� �0p�|&#P����)@i����e����p]+j�b�uzt;�~g33��h㗷�Eǅ�Ce�}`R�:��U�0�dm���_��ܡI��]蒢�n��g���	�6j�������5e���A��X���Ё�6�w*��~��n��HA���%��@^y��G�Wo�Z\\���\�tc!�x��D�PE�h~��64�&R��~���XhOo���I�A��_�o�-�M��@���|�[�kNi����C��6���+z���C�(cԞ�:��$����!�mΐ���:����k�K��&S����|(�K�~y�8��!I��Ӂ�-��������d���o�)d�6C�x� ̉��<h�uW�8�����b�V:P����9V ���3	 �`!S��cEë�A0�XЙ��U0_$f 0� �0��������ݗ�u6�Vt}W�g�Ʃ�u��*�6ک�4�h��1A�t���Ýo�� �3Y	�"U,�[�y�Dד���j���K�UtEEð�[AAJZe)7�a&�O�k�SS6UnjK��K�T��E��(�B�n̦ʆ�3�#��"rʦ��Mm��~ɛ��P6�z�@�?%5jS�]�n|لM���ڒ�>ئ����ݕ�'g��-��e���ed ���I�n��m��p4頴�����3�w���t�u�������(�����FseZ?�dc_~m|�$xݛ���1M����`±��P�i[+zOl�y����Mw���B�4�(�+{9}�Sֽ���Z��,�i��`Ys��G��;Z~���JZ��r�]��"�d���ᛯHĩ&2�"��|��^�ߪ�b)���}`U|;uq�J�&4쬴������෋��v���o��c��Uq���k-����g"J���MI��Wx&����.U7�CXe����཮��D���,� u���o����f�F�f?�x��G����*�=E5ԩ�3��3Ȕ^0�PQ��b
���j(�4��̤J� �4ݶ����1�������rG^�[tC"����0������Q0cwM7���5��ӆ�!�9�o��{����ToHd�ze���!�B�/lT0��D�u*T�t�"ɔ�긪4�c��������{e~W'7-���h8	g�A����a��J�E����H�7�i�{�����F��#�"���Ux(�[d|>�H��oZd�_��Q���8t+NZ��M^U�Hshρ��7�}�Ъ�iQ��J��*�����_� �2��
�_��.st��04p � u���G�� k[¨�����t��a�e�Ð��Q4�Q�ϵTT�R�h��C1d�ru� (�_h���Σ�EP۳�A�L
ԣ�S�
��9�P��Cg{�5��#�څ��n�#��� ��!��LP���g,�Hr�S�K��4G Uo���E|�-���CIS>���;��^=:���[����HΆ2�o1b��Vk�d�m�t�~`Jl��a��^�F�x�$R���lz���ѻ����K�v      1      x��]I�,7�]g�B�0�Nz���J������y����)����4��L=��|�R�o�	�9ߨ�n��7r��M�k�/��M�To�0�"�A��P�!؍Iߧ�~�}Hq�Dz�{ҤKڳo�%=���b�
R����m�D�<A�Vo���W���~����<�h��ԊueS��'��R���]��� ��S�`���}l�!T|P~cZQy��q�f�ύ1O��%f��bK�A�������P�A��nL�	�uж��vҶ�=��$l�mo��.�w��l憭p�Sy��1���rcVs)�������6��I[^"�Кs��s�+��!�M1���/�}'h�A��nB2"�54%���/�-�x�w�۞Gl�!��?M^�l�]�S�w`���woV#n>�\��w�*��\���S�}h����o����%Xl� ���}�^���Y"�&|.��7��2�4��ƺ��8U�˼��N��*�Z|pr#L/��@S��7�����P�c���5�}��������pz�8e��чQ����q^�C��Ȝ�3��v,�g6���^@SWh�PU�W�=�3��^̂�!�Z�g
�N4�h�@�)��f�Ȥ.J��eV�e�J�s<�
�����0�Ӡ~�f�+_{L\�N&Շ/J!���D�D��f����|�Ӊ �I�"�=	+@����v"�URݤ��/��H
а�H|�+���v")��T��^�j7�j��$�/V����G�A���/��H�P��(V�\��ݘ��8�\���n����%!�Տv�"�x���S�bp7.��>�q�S+/�ݸ�
&-=*_�=7.��S0�ׯ~�A��sb&{	��E=@s&=�b�W2
�!5lk��Ȯ\�م���Z�2���ү~�+��?e�T��
'*2�řh�x�����А}��R�c�������8���ډ���!t�O��^�&��D���V� (��]���o�0O���҉��~0T D}1�҉��!@E�/_A;��}�k��F�}~�#N�*���$��r�v"#@s�������a{@h�C����u@��e����΄%K	�nd4EW�D/����?ż�@)����?E�$�$���C �W���|�1�/E�0%�`��~9��Δz���+�)ނ́P��h7Vrd%7�ʊ�h7Vrg�����+d7R2�� Ć�dWN
��}����I<WN��ᠰ}A�dWJJ�hH88��+h� 	�ڔP�T��G:�7�o�'����?���L�o�h���6��q�å�y��d�B�����W�0,Ur&�.\2�橘�u��uHߙz��2C��CyZ1�q�'g����66��#��9�Ph���vC\L��d�E��gַ����Yx��>�i��0,��X/s&���������W�#��}��DncL���1Xۃ�k[%�Ym�p �#/��D����$����"<�Œ��Å# ?��Y�H���YoqL�Ɋt�`.����c������Xb�cn���i°�+�i[���6,s@~��%2H2�߈����3Ȧ-I6�)�dWt�C���DA�aE�9̆��?��,��YZ'��i��Nd������l^>��X�r]�����N�j��w�9h�v}!!�5	�cl�=�9�i�2`�v�0җsI����e�e��2��:�i9o<.�#iGb���2mko�Ь[y��,�cb*�}dG
=��	�]��CByR�qh�0�Ƕ�S�9�:����O&�oG�to�mkʉWk�� �DA�YgV|�q�MD��vqD��*�
��(�q��7k{=M�<�#n�h�|Nx9LS۷��DA���@��i��I�36�sY5���0��B*@v����\�DJ3GRnDƬ���ك0�"�	��(��V���|Y��v,grC�K����ߙ��@+�'�W�R��{$�9�iN�=�(��>���;1�32���� C���{os�&YT$#��m��z:��c��}��?A]8��s�me�؉��+H2͕=�o>�Tl�6I�f������K�-
U�,2�@vN�xFyZA���H����N�d�I���Wf�A�.K�2���MٟUS�z�1���
���9iҺ�e8���8�ٱ�}'b�fJ�ak�-�}C��qT�c��y�M%�l߉���|Py P�.�$��p�{��*ٙ���@v"��Z��7,�s3�,�e��^V��kC�2�s��LS�e �!-"��UA�|)�0�6�'��Y
Dvb�o:|���"���cW�i2$gÖ�ږt��b������s��߼�Ӻ��>�l��������م�X5�nJqa= [˪���$c����lK��m�S�m���b��9��['���,% ���P��d�������X(�e��ͼ���^�� �ߧ�EV&�g�z��:J�Jd|�7���������kd�wxf�,YѕM�-do�1�e�c�E��}
d�xl̙ �7Oy����׵9ڮ-��% $3@�>-���ލ1I�T�ɂ��Ou�N/�<��	����Y���fi�M �0�ې�Q�M֐1�E�A�O���!�H�T�8$z��-Ayx3�}��4H$�'�?�ȦM�PEA��q�$$��MT��sS��}?nu��hn�"�n����(U�~IpS;�.�}���ʛ�-�\ ;�7x*�]v���[(�hfy�Y��ǀ�9M�Tf�}-mI�z2K۬��߫6������v�dϸE?DP&���a�d��~�<�l\�>�E�M��v���g֔�����w��y��q�ʛx�x"2�W�4�7���P��'-<��T9lP_�փ��v$y�r��U[K�tj�s�MJZB�-<j�H�>Q��q���V�Xb��Q[��iv�SYN�YVQX���.�>�����f�dAP%yttN��X�jm�RL�k{J�����cZ,[Ǐ����&�S �n�>�Q$��
�a�<������0�TF �P�t�����I3�Y����z�G|��c�%�Sn�ܶF�0�=��j/cN�b�H#ّ(Ƶs!��#��\J��ݐ��)P��ZvV4J�>`L��%��4>�k��|_y��-S_#s��)>jiOy�3�e� �dȊ	�i�DL�`�<��y��ɍ	��J��J��X�4=Y%��l����;ɸ�dFQ{@��l�p$�1Cs�<��xO�1�&p�Ozx^!��55d#ҋ��Y]�(O�8:����L�wL<�~����T1[�L0\�]0��rqX�a;�I��+`<������ɱ�a�Ȝ�<����M<�'9�K4 Z�R�C�B)<��[�A�°�ĺ��������)����ڪ��1��CB�<	��Ҫ�UKHrl��%�*��@kr��<<P ��!�'$���IE�0S:�1�E��h�2M���1�|)�|��+�.aP�|�]l�x줩����MQ��m^�=#A�m/N��L�<i�FVHF�Aⳅ�k�2M�I�e+ͻw<�yhy����h��I�I��<=뢥���p�-�Sې���㹄���ai��3�dMI"�n�`:�f��O��\C+[APB['��A�ϽN�t��=ő6xj��"�5�U�b���k?�#^�.��ie[�/����\$���@�F ����Y7�h*綒s���O�t��ē{d�����3f�ǂ.�@�V���X��ם,޹|r��4����u�n�!m��,i�}���ܨ����c�{D���ī�fq��X�e�&}/;pQ>��u�0K�����9��<�c+�b�AB.:�~rW�DDs����9��`e��M��>A~e�\����FoB
a��:��l��ao�
ە�C����F�J���~�lEQ�{��G�&�9`=E>D���bH�kDq{d�zk����*��wQV��]���9��G%��.ݗ.��C�S��s�w%/+P�ҕ��P�-��S��q�V%Y����m3�h�    ڕ�ܰQMm~ 3��dt�,�z9V֤�!x�l�X�w#}aj�KR�g��������L���F,%S\Fm��5��X��4�Q�֓��	@��Q���Vw���V�bA��[����]��YC�脍�]� i�0=,��Z
	�%k�I&�Zg^ӺȪ<�'E����'����^��,�QLS��{7tc�4�.���ۛ�5��ݙ�圈hߖ�V[��}�%8+��V+AIxvo�qI:ٌr;�tm�!]�u� c�\��Z��I�O���yO���%�S�N���7���� �WAΎ�Hξ��2-{$�w����?e�Mb��d+�c��R�:J΁��
�*t�7���'';h�t̸�--x��˹� N���l����.�f��2�m��*`�\y���b?@7 -�?�=R�KQ�UX�h )&.���Ѕ)�KŬ��3��u��Yug�Uɸ��� �T�
��}���nH�k�D`�nҸ(O�)����$�
4P5'�J��m�U.��^a�	�8����v�@���[�OU����.��*ͳC�Y��Ѧ��o$C�����P
����x.�a�&��L�ktg���6J�JakY�-u�6}������)�v�9G���W���s�ו�-· �l�q믝�n;i��0�p</U��q��a���!Y��37���n�w}|��X�G}��K�C��铃q�A����n:j�IiH��gEBR�q�jX�^T��3tg��G:$�qxD3`);��,�e9B� $k����y�\���	#Q�!b�%	jڦ��;�t7R�ݖ��llh�iV�.|��f����&�_���k��;�&�V�C��w0���'�)-���#Dҥb�!�j7�Zd����$���ݍ�+`�&�z�!��2f�ɶl̀g��F
ߍ��F���{[ e�g����'[�.�KP/�w-:�)��^����$�Б�;Bx ��\&HI}7�Zt�6(Xe��Np쌤kP�SXtΓ����\��b؍)�af^&:�]���&P.� UCx �s-��;�/+^�(�`Yx�#��j#K���nԵ�X��nva�P���g7n�%E?d5���l@]���xi�|���A���v�ҽΊ�E���~tS�]S����ƒ���u����;ڊ�x�o�z-��$ 3=���<9:2�;�gШ��(�q�|�:m�M�]z�S��&>������Ҡ ?�-��caM���A~�[T#��4e��˫s�ڈ��`�\ug��ri�w,��]b_
Ѷ1�b�y]ˎ]3�m��{�����no�L�=��A}4��-C�YP�t�� g濥�n�G�FV������Eam|����@I���Z�0g��c��GP���jȻ�|�0���ѷmb�K�m�1=d��uQy�ZeYX�;DiRճ���/��m���]ǀ���O� Q`���k�z��%,��t�4���
|���ߏ;}��9�#�߀�($��ڣ?`��׎���#fJ��>o	���蹍�\�S�M' ���\��>��h�۰��N�}Tc^�9���ػ��F��6�"�;���ܰ`��a�z�����E!��R*�NiqW�q^g(��]���W�)�l`��)�|����#O����&$���q���\q������{���2�X�������y;| �Ci;b/��_Q�{о9n��	�P���I��Rޛ����<O�Wc<�A�{�����;}�&�K��L�<�oN��[D�ť��1d��]��L0{�`9i��gE�X�|(&O ������D�sFv��	��J�mK�&ۼ-��Hc�59���RGm&�iL���nȸX-����ɣ��cRo�6I뼜g
��?T�I������ �m���]�A��(������l2�=���wz�&5�B��&���(
(��_}�v�Y���R�ަ9���KL���2={�Ga��)@RP�-�'�7����G���������v_֜�@�[Tnm��`�w�P<�?�JH�~H`�f0�/|s�fvasJ��~߂QaN�P������;3�F���+��\��4,.�R�p��'J�6�ݹ/|��3T�����Ov��	�=1��9�Ż��(||�N�#���g����I�e���xo�d�6�����&� �ȥ�wJs�q�?D
�Q�j�א��,�$)�"Z�yN�i����Z0꨸�M�XB����$j �LZ~�=���X	�,Y�0���-L!�K����F����<���캱_!1��xD�}��
~���IB|�Tb��s���~Ȕh8���v�!�Y]d�<��$bRw���%�&�m�ޝ�=�d��\�uadNa
�c���gW4�L�`���F\��7�q@�"n �J��r�,���:8KF��-1{�����Ǎ�P(��n���\ơW�f��S2�l�oG��qQ@)���V��Cx5�cx;��$w�^�y���Q�K��1W���<H�/̊�)3�Bf��|����vp.��k�Ğ:�C��C�9�,��eQX�}6�r�9�h�BQ'�t����,������0,�d�D����y_'AQA8��cc��)y�=E�ua���^(c
��}�S�0��z/��,S�K��&�����]���1`+ۯ~v�8хNs��`(�ua��x�r�2�/�"�wk��5�Y�R*�s*�5^�Wk�Oz�.��y�W)�6�~ȼ�O|O��*x,fZS_7$�xh�T��ݳ�9�m1þ>���<��,<�e�yW	D~��FV�7Rxܞ/������r"��/it���=y���L�����Y�O�ȸ�������M���T�<ʼ_�k|i�,�B�%ÝT�wF���[ѱ��m�4�M�-|�)Zs�K1�s�\�g���Z)-�5�x��5d�U�/�QC����ªu	�O�_2;D�[3�|0<�v�'�@h�K�/|h���O���N<SAX��UwC{�(Q�t�dJ�v��H�z�`�s͖w���$3��{\�c��'����ܼ��|�~�=[E?)���'�]7�D2F_|̓w�.�Q ����oC�J����׮��-iK��aE�)��QC������ ����zsX��F���n�]��+�5����0�_<|��m�<���A�Q+�NpO1��h.\�L��l���]#����$�v7��[�%>�ˆ�� ��V��E�dːT ��{<�Y��x�܇f�k\gޓ�T�~H������ �\1f+���tLFi ���kg���ƨ�s?��a�jxa��T�� ^GTM�˦_��;3����Ж�����@��:�ǒ����iǳ��[f�_,!)V�n�<�!� n�v��I+�IfJj�J�����C��x��[�q<�q(�q+�u�4\?�W�6h��Y�}M��oQOn"\GO�g�`��C�d�;Q�c���In����-ܧ����[ 3��,�R�^ս�~r����2�i9���ݡ�S0�&��o`�����n������g�_�����ŽMmJw���<ﹺ�c_v#/����k��KÉ��Rʗ��w{�6��e         �  x��U�n�@];_1ʂ]�����P��PQ!
+څC�*�ClW�_���I�$-RW-Iv��8��3��O�W��k�eu��W�K�n���W��<�.�g��K�O)��}Ƨ/��m�޿��͖�v���~鶮.��=�窱�1�z�YN���w�Y7�%�@�'�-@9r���i�{��>��$˲��J��Q(@���ˈkI_g���}|��.��SG�X&)@�B�ɻmV���	�cu���	W��5Ƀ��<�(,��N�Y��ًf��\��۴�C�֤����͘�$(,p��J�([����8c�g��ww��f�j��
f��J"7qtԮ����=O�]�"P��(*�;Ԫ�߈�T��V�aTS��8af�,����(���hR(�U����Mݹ�*_p���R45��q�E62P Tf0�6���-���~����E���b�!N��{Ҿۛ�xN�X�.��po���~u�0C���Xx�:�>�$�LI��Fƒ��|�Xşm���,C@[��a!W#ק�P��i�t�	nۃ���*�&$��5w��^���R��*���t�P�"ìJmYJ(�A<��x�9�9�V�Տ�/H����j��K�N�����v�Ԓ)��4�qE'��_�qo�         O  x�}S=o�@��_Ahv���I�K�.���`t���t�ޝ�$�&c�Nٺ������	����G�'�8�e�)�F���d����r�`��z0��@N3Ch�y*���K���[���o)D���x-=�@�Au��P�< �z�[�
jt��3^�#��Y����Ť�x�]}�_hằ�_%'�����/��EA�a���gaFρ��[�O�=C`g�zB1�";u�ź��V2p��{��k��C�^O��AK-U""����*��$&��t�TJ���vMĮ��;��2p坯w?S`��Pc�z���>��_?��+<D�^AH^�L.�t/�3p��v�mR���	���h��������F�s��59ҕ�;5��t��u�f�i��!�y!��ui43���|�먁�t�2@�h ����~��f_}�m ��'
x������tgi�'Q�-W�T�C��s]�+O�<�l�.�q���x�C�"ߤԜ��%ڍ��l6=ϊ��+�ɇi�ضb��C�5V���b��E�W�8)���lҦT,�E�Tޣc%�^�r����w��Ϙ�^�*@O��r��: ��}�      5   C   x�ɱ�0����LD�8DB���t'u�ϡ�i��UXR�	WR��?��9��s.��,�      6   +   x�+(��MM���JL����,.)JL�/�*-.M,���qqq ��          /  x��TKn�0]ӧ�,�O�(�A��A��fL����VQd��t�U������81#�
i4#ͼ�4�O��dH�:p��G ��c o�M�r�br+L�	�Lg{�0.���D*3:�Z;�"�x��&KH�|[wu�D�!�;~��}����U��?�o�;n`���������= E�����_�b
i���5v��������[E߭	��Ϩ�v����{]0�a�qz�\:��3�&�^���XgI�l���1���"�J�r�իH����s�t�̉�;�+p�,�J����IUr�(KWj!�1�v��)�3�f�<p�L-�X0U���Z>L���Խ �����i��c��	Y1�+jJ���TKT\��1��b�s�%�wZi���Z&���l!La-S�	�(u�;����m9�C�������8t�Sf٤(�����d����o�zWP��~���gXa��.B��D�C��$�����m^��<�|���������yp����pa�����%D���H0;V��ї�酲3,?p�Y6�.&��?UKq�     