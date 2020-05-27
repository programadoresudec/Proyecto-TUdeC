PGDMP                         x            tudec    12.2    12.2 �    9           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
       comentarios         heap    postgres    false    16            �            1255    18938 u   field_audit(comentarios.comentarios, comentarios.comentarios, character varying, text, character varying, text, text)    FUNCTION     �  CREATE FUNCTION seguridad.field_audit(_data_new comentarios.comentarios, _data_old comentarios.comentarios, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
    	   seguridad          postgres    false    17    213    213            �            1259    18939    cursos    TABLE     D  CREATE TABLE cursos.cursos (
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
       cursos         heap    postgres    false    8                       1255    18945 a   field_audit(cursos.cursos, cursos.cursos, character varying, text, character varying, text, text)    FUNCTION     .  CREATE FUNCTION seguridad.field_audit(_data_new cursos.cursos, _data_old cursos.cursos, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
    	   seguridad          postgres    false    214    214    17            �            1259    18946    estados_curso    TABLE     @   CREATE TABLE cursos.estados_curso (
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
    	   seguridad          postgres    false    215    215    17            �            1259    18953    inscripciones_cursos    TABLE     �   CREATE TABLE cursos.inscripciones_cursos (
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
    	   seguridad          postgres    false    216    17    216            �            1259    18960    ejecucion_examen    TABLE     �   CREATE TABLE examenes.ejecucion_examen (
    id integer NOT NULL,
    fk_nombre_de_usuario text NOT NULL,
    fk_id_examen integer NOT NULL,
    fecha_de_ejecucion timestamp with time zone NOT NULL,
    calificacion text,
    respuestas text NOT NULL
);
 &   DROP TABLE examenes.ejecucion_examen;
       examenes         heap    postgres    false    10                       1255    18966 y   field_audit(examenes.ejecucion_examen, examenes.ejecucion_examen, character varying, text, character varying, text, text)    FUNCTION     �  CREATE FUNCTION seguridad.field_audit(_data_new examenes.ejecucion_examen, _data_old examenes.ejecucion_examen, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
    	   seguridad          postgres    false    217    217    17            �            1259    18967    examenes    TABLE     q   CREATE TABLE examenes.examenes (
    id integer NOT NULL,
    fk_id_tema integer,
    fecha_fin date NOT NULL
);
    DROP TABLE examenes.examenes;
       examenes         heap    postgres    false    10                       1255    18970 i   field_audit(examenes.examenes, examenes.examenes, character varying, text, character varying, text, text)    FUNCTION     �  CREATE FUNCTION seguridad.field_audit(_data_new examenes.examenes, _data_old examenes.examenes, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
       examenes         heap    postgres    false    10                       1255    18977 k   field_audit(examenes.preguntas, examenes.preguntas, character varying, text, character varying, text, text)    FUNCTION     T
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
    	   seguridad          postgres    false    219    219    17            �            1259    18978 
   respuestas    TABLE     �   CREATE TABLE examenes.respuestas (
    id integer NOT NULL,
    fk_id_preguntas integer NOT NULL,
    respuesta text NOT NULL,
    estado boolean NOT NULL
);
     DROP TABLE examenes.respuestas;
       examenes         heap    postgres    false    10                       1255    18984 m   field_audit(examenes.respuestas, examenes.respuestas, character varying, text, character varying, text, text)    FUNCTION     �  CREATE FUNCTION seguridad.field_audit(_data_new examenes.respuestas, _data_old examenes.respuestas, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
    	   seguridad          postgres    false    17    220    220            �            1259    18985    mensajes    TABLE     �   CREATE TABLE mensajes.mensajes (
    id integer NOT NULL,
    fk_nombre_de_usuario_emisor text NOT NULL,
    fk_nombre_de_usuario_receptor text NOT NULL,
    contenido text NOT NULL,
    fecha timestamp without time zone NOT NULL,
    id_curso integer
);
    DROP TABLE mensajes.mensajes;
       mensajes         heap    postgres    false    18                       1255    18991 i   field_audit(mensajes.mensajes, mensajes.mensajes, character varying, text, character varying, text, text)    FUNCTION     '  CREATE FUNCTION seguridad.field_audit(_data_new mensajes.mensajes, _data_old mensajes.mensajes, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
				_datos := _datos || json_build_object('imagenes_nuevo', _data_new.imagenes)::jsonb;
				_datos := _datos || json_build_object('fecha_nuevo', _data_new.fecha)::jsonb;
				_datos := _datos || json_build_object('id_curso_nuevo', _data_new.id_curso)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('fk_nombre_de_usuario_emisor_anterior', _data_old.fk_nombre_de_usuario_emisor)::jsonb;
				_datos := _datos || json_build_object('fk_nombre_de_usuario_receptor_anterior', _data_old.fk_nombre_de_usuario_receptor)::jsonb;
				_datos := _datos || json_build_object('contenido_anterior', _data_old.contenido)::jsonb;
				_datos := _datos || json_build_object('imagenes_anterior', _data_old.imagenes)::jsonb;
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
			IF _data_old.imagenes <> _data_new.imagenes
				THEN _datos := _datos || json_build_object('imagenes_anterior', _data_old.imagenes, 'imagenes_nuevo', _data_new.imagenes)::jsonb;
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
       notificaciones         heap    postgres    false    11                       1255    19341 �   field_audit(notificaciones.notificaciones, notificaciones.notificaciones, character varying, text, character varying, text, text)    FUNCTION     %
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
       puntuaciones         heap    postgres    false    14                       1255    18998 y   field_audit(puntuaciones.puntuaciones, puntuaciones.puntuaciones, character varying, text, character varying, text, text)    FUNCTION     �	  CREATE FUNCTION seguridad.field_audit(_data_new puntuaciones.puntuaciones, _data_old puntuaciones.puntuaciones, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
    	   seguridad          postgres    false    223    17    223            �            1259    19006    reportes    TABLE     \  CREATE TABLE reportes.reportes (
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
       reportes         heap    postgres    false    5                       1255    19012 i   field_audit(reportes.reportes, reportes.reportes, character varying, text, character varying, text, text)    FUNCTION     �  CREATE FUNCTION seguridad.field_audit(_data_new reportes.reportes, _data_old reportes.reportes, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
       sugerencias         heap    postgres    false    12                       1255    19019 u   field_audit(sugerencias.sugerencias, sugerencias.sugerencias, character varying, text, character varying, text, text)    FUNCTION     ?  CREATE FUNCTION seguridad.field_audit(_data_new sugerencias.sugerencias, _data_old sugerencias.sugerencias, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
    	   seguridad          postgres    false    17    225    225            �            1259    19020    temas    TABLE     �   CREATE TABLE temas.temas (
    id integer NOT NULL,
    fk_id_curso integer NOT NULL,
    titulo text NOT NULL,
    informacion text NOT NULL,
    imagenes text[]
);
    DROP TABLE temas.temas;
       temas         heap    postgres    false    7                       1255    19026 ]   field_audit(temas.temas, temas.temas, character varying, text, character varying, text, text)    FUNCTION     �	  CREATE FUNCTION seguridad.field_audit(_data_new temas.temas, _data_old temas.temas, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
    	   seguridad          postgres    false    226    226    17            �            1259    19027    usuarios    TABLE     {  CREATE TABLE usuarios.usuarios (
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
       usuarios         heap    postgres    false    9                       1255    19033 i   field_audit(usuarios.usuarios, usuarios.usuarios, character varying, text, character varying, text, text)    FUNCTION     "  CREATE FUNCTION seguridad.field_audit(_data_new usuarios.usuarios, _data_old usuarios.usuarios, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
    	   seguridad          postgres    false    17    227    227                       1255    19034 9   f_eliminar_usuarios_con_token_vencido_estado_activacion()    FUNCTION       CREATE FUNCTION usuarios.f_eliminar_usuarios_con_token_vencido_estado_activacion() RETURNS SETOF void
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
       comentarios          postgres    false    213    16            =           0    0    comentarios_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE comentarios.comentarios_id_seq OWNED BY comentarios.comentarios.id;
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
       examenes          postgres    false    218    10            A           0    0    examenes_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE examenes.examenes_id_seq OWNED BY examenes.examenes.id;
          examenes          postgres    false    233            �            1259    19051    preguntas_id_seq    SEQUENCE     �   CREATE SEQUENCE examenes.preguntas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE examenes.preguntas_id_seq;
       examenes          postgres    false    219    10            B           0    0    preguntas_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE examenes.preguntas_id_seq OWNED BY examenes.preguntas.id;
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
       mensajes          postgres    false    18    221            D           0    0    mensajes_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE mensajes.mensajes_id_seq OWNED BY mensajes.mensajes.id;
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
       sugerencias          postgres    false    225    12            T           0    0    sugerencias_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE sugerencias.sugerencias_id_seq OWNED BY sugerencias.sugerencias.id;
          sugerencias          postgres    false    247            �            1259    19098    temas_id_seq    SEQUENCE     �   CREATE SEQUENCE temas.temas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE temas.temas_id_seq;
       temas          postgres    false    7    226            U           0    0    temas_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE temas.temas_id_seq OWNED BY temas.temas.id;
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
    comentarios          postgres    false    213   4      "          0    19037    areas 
   TABLE DATA           ,   COPY cursos.areas (area, icono) FROM stdin;
    cursos          postgres    false    229   Q                0    18939    cursos 
   TABLE DATA           �   COPY cursos.cursos (id, fk_creador, fk_area, fk_estado, nombre, fecha_de_creacion, fecha_de_inicio, codigo_inscripcion, puntuacion, descripcion) FROM stdin;
    cursos          postgres    false    214   �                0    18946    estados_curso 
   TABLE DATA           /   COPY cursos.estados_curso (estado) FROM stdin;
    cursos          postgres    false    215   �                0    18953    inscripciones_cursos 
   TABLE DATA           k   COPY cursos.inscripciones_cursos (id, fk_nombre_de_usuario, fk_id_curso, fecha_de_inscripcion) FROM stdin;
    cursos          postgres    false    216   �                0    18960    ejecucion_examen 
   TABLE DATA           �   COPY examenes.ejecucion_examen (id, fk_nombre_de_usuario, fk_id_examen, fecha_de_ejecucion, calificacion, respuestas) FROM stdin;
    examenes          postgres    false    217   0                0    18967    examenes 
   TABLE DATA           ?   COPY examenes.examenes (id, fk_id_tema, fecha_fin) FROM stdin;
    examenes          postgres    false    218   "                0    18971 	   preguntas 
   TABLE DATA           _   COPY examenes.preguntas (id, fk_id_examen, fk_tipo_pregunta, pregunta, porcentaje) FROM stdin;
    examenes          postgres    false    219   [                0    18978 
   respuestas 
   TABLE DATA           N   COPY examenes.respuestas (id, fk_id_preguntas, respuesta, estado) FROM stdin;
    examenes          postgres    false    220   2      )          0    19055    tipos_pregunta 
   TABLE DATA           0   COPY examenes.tipos_pregunta (tipo) FROM stdin;
    examenes          postgres    false    236   �                0    18985    mensajes 
   TABLE DATA           �   COPY mensajes.mensajes (id, fk_nombre_de_usuario_emisor, fk_nombre_de_usuario_receptor, contenido, fecha, id_curso) FROM stdin;
    mensajes          postgres    false    221   +	      +          0    19063    notificaciones 
   TABLE DATA           b   COPY notificaciones.notificaciones (id, mensaje, estado, fk_nombre_de_usuario, fecha) FROM stdin;
    notificaciones          postgres    false    238   x                0    18992    puntuaciones 
   TABLE DATA           X   COPY puntuaciones.puntuaciones (id, emisor, receptor, puntuacion, id_curso) FROM stdin;
    puntuaciones          postgres    false    222   �                0    18999    motivos 
   TABLE DATA           [   COPY reportes.motivos (motivo, dias_para_reportar, puntuacion_para_el_bloqueo) FROM stdin;
    reportes          postgres    false    223   $                0    19006    reportes 
   TABLE DATA           �   COPY reportes.reportes (id, fk_nombre_de_usuario_denunciante, fk_nombre_de_usuario_denunciado, fk_motivo, descripcion, estado, fk_id_comentario, fk_id_mensaje, fecha) FROM stdin;
    reportes          postgres    false    224   �      /          0    19075 	   auditoria 
   TABLE DATA           d   COPY seguridad.auditoria (id, fecha, accion, schema, tabla, session, user_bd, data, pk) FROM stdin;
 	   seguridad          postgres    false    242   �      1          0    19083    autentication 
   TABLE DATA           l   COPY seguridad.autentication (id, nombre_de_usuario, ip, mac, fecha_inicio, fecha_fin, session) FROM stdin;
 	   seguridad          postgres    false    244   �E                0    19013    sugerencias 
   TABLE DATA           w   COPY sugerencias.sugerencias (id, fk_nombre_de_usuario_emisor, contenido, estado, imagenes, titulo, fecha) FROM stdin;
    sugerencias          postgres    false    225   k`                0    19020    temas 
   TABLE DATA           N   COPY temas.temas (id, fk_id_curso, titulo, informacion, imagenes) FROM stdin;
    temas          postgres    false    226   �b      5          0    19100    estados_usuario 
   TABLE DATA           3   COPY usuarios.estados_usuario (estado) FROM stdin;
    usuarios          postgres    false    249   �d      6          0    19106    roles 
   TABLE DATA           &   COPY usuarios.roles (rol) FROM stdin;
    usuarios          postgres    false    250   �d                 0    19027    usuarios 
   TABLE DATA           >  COPY usuarios.usuarios (nombre_de_usuario, fk_rol, fk_estado, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, correo_institucional, pass, fecha_desbloqueo, puntuacion, token, imagen_perfil, fecha_creacion, ultima_modificacion, vencimiento_token, session, descripcion, puntuacion_bloqueo) FROM stdin;
    usuarios          postgres    false    227   0e      V           0    0    comentarios_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('comentarios.comentarios_id_seq', 9, true);
          comentarios          postgres    false    228            W           0    0    cursos_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('cursos.cursos_id_seq', 21, true);
          cursos          postgres    false    230            X           0    0    inscripciones_cursos_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('cursos.inscripciones_cursos_id_seq', 8, true);
          cursos          postgres    false    231            Y           0    0    ejecucion_examen_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('examenes.ejecucion_examen_id_seq', 5, true);
          examenes          postgres    false    232            Z           0    0    examenes_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('examenes.examenes_id_seq', 1, true);
          examenes          postgres    false    233            [           0    0    preguntas_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('examenes.preguntas_id_seq', 30, true);
          examenes          postgres    false    234            \           0    0    respuestas_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('examenes.respuestas_id_seq', 32, true);
          examenes          postgres    false    235            ]           0    0    mensajes_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('mensajes.mensajes_id_seq', 19, true);
          mensajes          postgres    false    237            ^           0    0    notificaciones_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('notificaciones.notificaciones_id_seq', 1, true);
          notificaciones          postgres    false    239            _           0    0    puntuaciones_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('puntuaciones.puntuaciones_id_seq', 9, true);
          puntuaciones          postgres    false    240            `           0    0    reportes_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('reportes.reportes_id_seq', 5, true);
          reportes          postgres    false    241            a           0    0    auditoria_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('seguridad.auditoria_id_seq', 349, true);
       	   seguridad          postgres    false    243            b           0    0    autentication_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('seguridad.autentication_id_seq', 451, true);
       	   seguridad          postgres    false    245            c           0    0    sugerencias_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('sugerencias.sugerencias_id_seq', 39, true);
          sugerencias          postgres    false    247            d           0    0    temas_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('temas.temas_id_seq', 8, true);
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
       cursos          postgres    false    251    214            �           2620    19176 %   estados_curso tg_cursos_estados_curso    TRIGGER     �   CREATE TRIGGER tg_cursos_estados_curso AFTER INSERT OR DELETE OR UPDATE ON cursos.estados_curso FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 >   DROP TRIGGER tg_cursos_estados_curso ON cursos.estados_curso;
       cursos          postgres    false    251    215            �           2620    19177 3   inscripciones_cursos tg_cursos_inscripciones_cursos    TRIGGER     �   CREATE TRIGGER tg_cursos_inscripciones_cursos AFTER INSERT OR DELETE OR UPDATE ON cursos.inscripciones_cursos FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 L   DROP TRIGGER tg_cursos_inscripciones_cursos ON cursos.inscripciones_cursos;
       cursos          postgres    false    251    216            �           2620    19178 -   ejecucion_examen tg_examenes_ejecucion_examen    TRIGGER     �   CREATE TRIGGER tg_examenes_ejecucion_examen AFTER INSERT OR DELETE OR UPDATE ON examenes.ejecucion_examen FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 H   DROP TRIGGER tg_examenes_ejecucion_examen ON examenes.ejecucion_examen;
       examenes          postgres    false    217    251            �           2620    19179    examenes tg_examenes_examenes    TRIGGER     �   CREATE TRIGGER tg_examenes_examenes AFTER INSERT OR DELETE OR UPDATE ON examenes.examenes FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 8   DROP TRIGGER tg_examenes_examenes ON examenes.examenes;
       examenes          postgres    false    218    251            �           2620    19180    preguntas tg_examenes_preguntas    TRIGGER     �   CREATE TRIGGER tg_examenes_preguntas AFTER INSERT OR DELETE OR UPDATE ON examenes.preguntas FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 :   DROP TRIGGER tg_examenes_preguntas ON examenes.preguntas;
       examenes          postgres    false    219    251            �           2620    19181 !   respuestas tg_examenes_respuestas    TRIGGER     �   CREATE TRIGGER tg_examenes_respuestas AFTER INSERT OR DELETE OR UPDATE ON examenes.respuestas FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 <   DROP TRIGGER tg_examenes_respuestas ON examenes.respuestas;
       examenes          postgres    false    251    220            �           2620    19182 )   tipos_pregunta tg_examenes_tipos_pregunta    TRIGGER     �   CREATE TRIGGER tg_examenes_tipos_pregunta AFTER INSERT OR DELETE OR UPDATE ON examenes.tipos_pregunta FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 D   DROP TRIGGER tg_examenes_tipos_pregunta ON examenes.tipos_pregunta;
       examenes          postgres    false    251    236            �           2620    19183    mensajes tg_mensajes_mensajes    TRIGGER     �   CREATE TRIGGER tg_mensajes_mensajes AFTER INSERT OR DELETE OR UPDATE ON mensajes.mensajes FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 8   DROP TRIGGER tg_mensajes_mensajes ON mensajes.mensajes;
       mensajes          postgres    false    251    221            �           2620    19184 /   notificaciones tg_notificaciones_notificaciones    TRIGGER     �   CREATE TRIGGER tg_notificaciones_notificaciones AFTER INSERT OR DELETE OR UPDATE ON notificaciones.notificaciones FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 P   DROP TRIGGER tg_notificaciones_notificaciones ON notificaciones.notificaciones;
       notificaciones          postgres    false    238    251            �           2620    19185 )   puntuaciones tg_puntuaciones_puntuaciones    TRIGGER     �   CREATE TRIGGER tg_puntuaciones_puntuaciones AFTER INSERT OR DELETE OR UPDATE ON puntuaciones.puntuaciones FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 H   DROP TRIGGER tg_puntuaciones_puntuaciones ON puntuaciones.puntuaciones;
       puntuaciones          postgres    false    222    251            �           2620    19186    motivos tg_reportes_motivos    TRIGGER     �   CREATE TRIGGER tg_reportes_motivos AFTER INSERT OR DELETE OR UPDATE ON reportes.motivos FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 6   DROP TRIGGER tg_reportes_motivos ON reportes.motivos;
       reportes          postgres    false    223    251            �           2620    19187    reportes tg_reportes_reportes    TRIGGER     �   CREATE TRIGGER tg_reportes_reportes AFTER INSERT OR DELETE OR UPDATE ON reportes.reportes FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 8   DROP TRIGGER tg_reportes_reportes ON reportes.reportes;
       reportes          postgres    false    224    251            �           2620    19188 &   sugerencias tg_sugerencias_sugerencias    TRIGGER     �   CREATE TRIGGER tg_sugerencias_sugerencias AFTER INSERT OR DELETE OR UPDATE ON sugerencias.sugerencias FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 D   DROP TRIGGER tg_sugerencias_sugerencias ON sugerencias.sugerencias;
       sugerencias          postgres    false    251    225            �           2620    19189    temas tg_temas_temas    TRIGGER     �   CREATE TRIGGER tg_temas_temas AFTER INSERT OR DELETE OR UPDATE ON temas.temas FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 ,   DROP TRIGGER tg_temas_temas ON temas.temas;
       temas          postgres    false    226    251            �           2620    19190 +   estados_usuario tg_usuarios_estados_usuario    TRIGGER     �   CREATE TRIGGER tg_usuarios_estados_usuario AFTER INSERT OR DELETE OR UPDATE ON usuarios.estados_usuario FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 F   DROP TRIGGER tg_usuarios_estados_usuario ON usuarios.estados_usuario;
       usuarios          postgres    false    249    251            �           2620    19191    roles tg_usuarios_roles    TRIGGER     �   CREATE TRIGGER tg_usuarios_roles AFTER INSERT OR DELETE OR UPDATE ON usuarios.roles FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 2   DROP TRIGGER tg_usuarios_roles ON usuarios.roles;
       usuarios          postgres    false    251    250            �           2620    19192    usuarios tg_usuarios_usuarios    TRIGGER     �   CREATE TRIGGER tg_usuarios_usuarios AFTER INSERT OR DELETE OR UPDATE ON usuarios.usuarios FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 8   DROP TRIGGER tg_usuarios_usuarios ON usuarios.usuarios;
       usuarios          postgres    false    227    251            b           2606    19193    comentarios fkcomentario107416    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario107416 FOREIGN KEY (fk_nombre_de_usuario_emisor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario107416;
       comentarios          postgres    false    2899    213    227            c           2606    19198    comentarios fkcomentario298131    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario298131 FOREIGN KEY (fk_id_tema) REFERENCES temas.temas(id);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario298131;
       comentarios          postgres    false    226    213    2895            d           2606    19203    comentarios fkcomentario605734    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario605734 FOREIGN KEY (fk_id_curso) REFERENCES cursos.cursos(id);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario605734;
       comentarios          postgres    false    214    2871    213            e           2606    19208    comentarios fkcomentario954929    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario954929 FOREIGN KEY (fk_id_comentario) REFERENCES comentarios.comentarios(id);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario954929;
       comentarios          postgres    false    213    213    2869            f           2606    19213    cursos fkcursos287281    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT fkcursos287281 FOREIGN KEY (fk_estado) REFERENCES cursos.estados_curso(estado);
 ?   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT fkcursos287281;
       cursos          postgres    false    215    214    2873            g           2606    19218    cursos fkcursos395447    FK CONSTRAINT     v   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT fkcursos395447 FOREIGN KEY (fk_area) REFERENCES cursos.areas(area);
 ?   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT fkcursos395447;
       cursos          postgres    false    229    214    2901            h           2606    19223    cursos fkcursos742472    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT fkcursos742472 FOREIGN KEY (fk_creador) REFERENCES usuarios.usuarios(nombre_de_usuario);
 ?   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT fkcursos742472;
       cursos          postgres    false    227    214    2899            i           2606    19228 &   inscripciones_cursos fkinscripcio18320    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.inscripciones_cursos
    ADD CONSTRAINT fkinscripcio18320 FOREIGN KEY (fk_id_curso) REFERENCES cursos.cursos(id);
 P   ALTER TABLE ONLY cursos.inscripciones_cursos DROP CONSTRAINT fkinscripcio18320;
       cursos          postgres    false    214    216    2871            j           2606    19233 '   inscripciones_cursos fkinscripcio893145    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.inscripciones_cursos
    ADD CONSTRAINT fkinscripcio893145 FOREIGN KEY (fk_nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 Q   ALTER TABLE ONLY cursos.inscripciones_cursos DROP CONSTRAINT fkinscripcio893145;
       cursos          postgres    false    2899    227    216            k           2606    19238 #   ejecucion_examen fkejecucion_455924    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.ejecucion_examen
    ADD CONSTRAINT fkejecucion_455924 FOREIGN KEY (fk_nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 O   ALTER TABLE ONLY examenes.ejecucion_examen DROP CONSTRAINT fkejecucion_455924;
       examenes          postgres    false    2899    217    227            l           2606    19243 #   ejecucion_examen fkejecucion_678612    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.ejecucion_examen
    ADD CONSTRAINT fkejecucion_678612 FOREIGN KEY (fk_id_examen) REFERENCES examenes.examenes(id);
 O   ALTER TABLE ONLY examenes.ejecucion_examen DROP CONSTRAINT fkejecucion_678612;
       examenes          postgres    false    218    217    2879            m           2606    19248    examenes fkexamenes946263    FK CONSTRAINT     |   ALTER TABLE ONLY examenes.examenes
    ADD CONSTRAINT fkexamenes946263 FOREIGN KEY (fk_id_tema) REFERENCES temas.temas(id);
 E   ALTER TABLE ONLY examenes.examenes DROP CONSTRAINT fkexamenes946263;
       examenes          postgres    false    218    2895    226            n           2606    19253    preguntas fkpreguntas592721    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.preguntas
    ADD CONSTRAINT fkpreguntas592721 FOREIGN KEY (fk_id_examen) REFERENCES examenes.examenes(id);
 G   ALTER TABLE ONLY examenes.preguntas DROP CONSTRAINT fkpreguntas592721;
       examenes          postgres    false    218    2879    219            o           2606    19258    preguntas fkpreguntas985578    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.preguntas
    ADD CONSTRAINT fkpreguntas985578 FOREIGN KEY (fk_tipo_pregunta) REFERENCES examenes.tipos_pregunta(tipo);
 G   ALTER TABLE ONLY examenes.preguntas DROP CONSTRAINT fkpreguntas985578;
       examenes          postgres    false    236    2903    219            p           2606    19263    respuestas fkrespuestas516290    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.respuestas
    ADD CONSTRAINT fkrespuestas516290 FOREIGN KEY (fk_id_preguntas) REFERENCES examenes.preguntas(id);
 I   ALTER TABLE ONLY examenes.respuestas DROP CONSTRAINT fkrespuestas516290;
       examenes          postgres    false    219    220    2881            q           2606    19268    mensajes fkmensajes16841    FK CONSTRAINT     �   ALTER TABLE ONLY mensajes.mensajes
    ADD CONSTRAINT fkmensajes16841 FOREIGN KEY (fk_nombre_de_usuario_receptor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 D   ALTER TABLE ONLY mensajes.mensajes DROP CONSTRAINT fkmensajes16841;
       mensajes          postgres    false    227    221    2899            r           2606    19273    mensajes fkmensajes33437    FK CONSTRAINT     �   ALTER TABLE ONLY mensajes.mensajes
    ADD CONSTRAINT fkmensajes33437 FOREIGN KEY (fk_nombre_de_usuario_emisor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 D   ALTER TABLE ONLY mensajes.mensajes DROP CONSTRAINT fkmensajes33437;
       mensajes          postgres    false    227    221    2899            }           2606    19278 !   notificaciones fknotificaci697604    FK CONSTRAINT     �   ALTER TABLE ONLY notificaciones.notificaciones
    ADD CONSTRAINT fknotificaci697604 FOREIGN KEY (fk_nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 S   ALTER TABLE ONLY notificaciones.notificaciones DROP CONSTRAINT fknotificaci697604;
       notificaciones          postgres    false    227    2899    238            s           2606    19283 %   puntuaciones puntuaciones_emisor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY puntuaciones.puntuaciones
    ADD CONSTRAINT puntuaciones_emisor_fkey FOREIGN KEY (emisor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 U   ALTER TABLE ONLY puntuaciones.puntuaciones DROP CONSTRAINT puntuaciones_emisor_fkey;
       puntuaciones          postgres    false    222    227    2899            t           2606    19288 '   puntuaciones puntuaciones_receptor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY puntuaciones.puntuaciones
    ADD CONSTRAINT puntuaciones_receptor_fkey FOREIGN KEY (receptor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 W   ALTER TABLE ONLY puntuaciones.puntuaciones DROP CONSTRAINT puntuaciones_receptor_fkey;
       puntuaciones          postgres    false    227    222    2899            u           2606    19293    reportes fkreportes50539    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT fkreportes50539 FOREIGN KEY (fk_nombre_de_usuario_denunciado) REFERENCES usuarios.usuarios(nombre_de_usuario);
 D   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT fkreportes50539;
       reportes          postgres    false    227    2899    224            v           2606    19298    reportes fkreportes843275    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT fkreportes843275 FOREIGN KEY (fk_nombre_de_usuario_denunciante) REFERENCES usuarios.usuarios(nombre_de_usuario);
 E   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT fkreportes843275;
       reportes          postgres    false    227    2899    224            w           2606    19303 '   reportes reportes_fk_id_comentario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT reportes_fk_id_comentario_fkey FOREIGN KEY (fk_id_comentario) REFERENCES comentarios.comentarios(id);
 S   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT reportes_fk_id_comentario_fkey;
       reportes          postgres    false    213    2869    224            x           2606    19308 $   reportes reportes_fk_id_mensaje_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT reportes_fk_id_mensaje_fkey FOREIGN KEY (fk_id_mensaje) REFERENCES mensajes.mensajes(id);
 P   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT reportes_fk_id_mensaje_fkey;
       reportes          postgres    false    221    224    2885            ~           2606    19313 '   autentication fk_autentication_usuarios    FK CONSTRAINT     �   ALTER TABLE ONLY seguridad.autentication
    ADD CONSTRAINT fk_autentication_usuarios FOREIGN KEY (nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 T   ALTER TABLE ONLY seguridad.autentication DROP CONSTRAINT fk_autentication_usuarios;
    	   seguridad          postgres    false    244    227    2899            y           2606    19318    sugerencias fksugerencia433827    FK CONSTRAINT     �   ALTER TABLE ONLY sugerencias.sugerencias
    ADD CONSTRAINT fksugerencia433827 FOREIGN KEY (fk_nombre_de_usuario_emisor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 M   ALTER TABLE ONLY sugerencias.sugerencias DROP CONSTRAINT fksugerencia433827;
       sugerencias          postgres    false    2899    225    227            z           2606    19323    temas fktemas249223    FK CONSTRAINT     v   ALTER TABLE ONLY temas.temas
    ADD CONSTRAINT fktemas249223 FOREIGN KEY (fk_id_curso) REFERENCES cursos.cursos(id);
 <   ALTER TABLE ONLY temas.temas DROP CONSTRAINT fktemas249223;
       temas          postgres    false    2871    226    214            {           2606    19328    usuarios fkusuarios355026    FK CONSTRAINT     |   ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT fkusuarios355026 FOREIGN KEY (fk_rol) REFERENCES usuarios.roles(rol);
 E   ALTER TABLE ONLY usuarios.usuarios DROP CONSTRAINT fkusuarios355026;
       usuarios          postgres    false    2913    227    250            |           2606    19333    usuarios fkusuarios94770    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT fkusuarios94770 FOREIGN KEY (fk_estado) REFERENCES usuarios.estados_usuario(estado);
 D   ALTER TABLE ONLY usuarios.usuarios DROP CONSTRAINT fkusuarios94770;
       usuarios          postgres    false    2911    227    249                  x������ � �      "   k   x�s�L�K�L,Vp:��839���N?(5���8�X�371=5/�H���/v,JM,�wFסW����T��Ztxm"A��B��d��a3TX�IQ>a`U`�1z\\\ ?�X�         �  x����n�0ǯ��"/d;�n���i0�jh:M��]Oq:o��S��8&Q[ aX��_��;�p���ya�`ޙG�v�g�y�(�|�����$�-X֛�����67Xk�q�S�^F!Wtɛ��^!�m�M3������ə����W�t��X��<��B��мϾd8�뺶LDpiʝ��aޔ�1��%a��~�A�k���zv���Gw-� ��&hN�3���]3zc�B��>&�n�����L$'���?��&�e��3E��jÒ�V�K�_�x��	�#�Rr}�Bo\��]�?�%�Uo�O��1
�B�C+�.�rO��V���l����EXX�GG��H9��A4�&�a�G� W�((�w2-S?"�cQ�M^9�T�[��Ԑ�8���Qf�Z�11����_Y~+&4��O%t�eR�G�T�7�evuK@���Oir���u�58��0⃤���)H<��c�'Z=v            x�KL.�,��J͋O-.H-J����� ]@�         A   x�3�t+J�K�4�4202�50�56�2���L/M�150�K��Zp�#IX KX I"$,�b���� q�f         �   x����N�0@g�+��$:�v�z+C�V���2�'r�.�?ֵ?F������{ox�l�5"AB
*�k&���*[堖�49�I���k�k�0Xn��z�vޱ��z	XY]ߍ��~��{n
�<'H^���<	��Y��	]���Ȱvv��o=V8�5��z�S��ބ�yv����<��k&QI5�a3:���L�S�f F/���B�K��P�OĒ3J�;qO��         )   x�3�4�4204�50�52�2� r�tLu��b���� d�|         �   x���;�0Dk�{��O���ڱ���v�}(�B$r1�DA9�y3��Ddb�w�چh�����&�آxܷ�����.���b��o�ɭR%�"'�GN�g*���U&�K�ب�š}��KeM��f��i��9Rz�ڶ��d/^�I�CV�aε�� Fƙ��=�sM0���tN|�<��a$�|�k�         �   x�32�42���KO��L-:�6Q!%U!8?��<�(�����$�X��{xaIfrb1gP�)��J�؀�Ȝ3,�(%$k�9�&e���̰ T��8� NP~V��gl�	��Z\P�Z\��`3B3����� -I/�      )   M   x��=�+�$� 'U!9?O����D�������D._�\8��1)3�H��d&g���($%gd��s��qqq ��%q         =  x��TMo�@=�_��ȧ,;���ne5�S�͡\z�{�7��2$���3�BlGB�@�{�fg�,$�CQ����|�[�XR���<��i���	g�]\�"�2Wr{3�b��d�Ϛ��-ȟ���<��(��O�^lCr��ۺG2u	�p��4�Js�3�=�']���n	�L�L9ꤐ� \�
��4��l�i�}���s(+߶����PЪ^��c�?��������*���MjS���a]�]p[Ta�����}U�����m�b���g��
W �����L	*�F`�z��.ۗ�n7�)Wl�wJ6>������V(Mq��CS7鷘j��~�m��þ<REI�qK�`U�XU�Ʃ��.��Z.�FQ{ҘD�ȭ�3�h\��ب�޹'���Ŗ�6�q~
�"��ȿ����
�z0��S�Д[�mt<���1#K�l�������9�Ac]��p|���uU��v�
	�u�3�"I�}��W��(0'Y4=�����y\oG����iNvm{���j���2?%	i与�ޙ(�,����|�/ϐ� ��[:�L^�z�      +   N   x�3��HT��IMOL�W(�KT(.MO-J�K�L��,��M,.I-�4202�50�52W04�2��22�344033����� �y         >   x����M,.I-���L/M�150�4���2�t+J�K��N���4�XBEb�8M9͹b���� @f         \   x�s/�/N-�L,�4�4��OK�+N,VH�Q(-.M,���4�4�
p��4�4�r��+I��L�W�6��44�4kII-Rp/*-�	�r��qqq ���            x������ � �      /      x��}mwǑ�g�W�j7ɹg�QWuW�p�ʎ�8��$9�d�G�g���D@*�������Þ�m����j $���0�D��lKĠ���꩗���P��P�A�=&{:��|���'�^|p5���x���w_~p1�^�L���|x�ӗ�W������ë�<L.��0y�ˣ���7�|�!�̺ :Vg��sE*9/�@�"�J�L"Ϭ�>��i�Rb�x�r2>-�p>���4L����}�W���o�����/��E���<��r��g��8�������o�AFg��I������Y��<����|K>
'�٤C�ʿ�&au�K��������'�W�����pz:*t�'�|S����/Wa\���;և�b|::���x^.�[!�M|�m8�Fg�p~9~YY�%U/f2	I�2~����y��l���QV��l<���G�����U|V��g��U�����$�Iȯ�l���|pE��1��Đ3B��'���I7��痁?�4	w���{��"^�xM��_� ��C������^~]�ėj���r_~�Y��g�&���`�������ϷV��QdEx:���%��/N?�p���'�맿�u�ݸ�5aZ���:<ZI\�v,��x�k[(�eR�4E�����t����F�P�: ޫ��K<21��l��mR^~n@A���;����ao�O�Z�2�N�������_�̿~�8�����7��󋢐A!��
(吂}��;H蜒�!V��On1Ȑ��aq�{��!!Uh��B��
�<&�|AZ٭!�M�W\��D�����.��7�7}P�AG��#��?v�O?yF�������|�~S��FX�yc�$��) �-d����*�(c'��A�>9+�D0����=��*�_XIp@���&q�L��1[c}�|��P����`}M�ֻu} �)���������>���᷏�v�}���-��T���� ,r+yf:�3ORj��Me��^�D�����B���:dDU��1�D3���}�6�.?7�t��|���*�����K�=:V�(�8����׏kU���_�b<9�e�����c��W��$E]j܇_�N��)	�Q~gR{��]�'���G����>�����	Z��9H�:HH�h2θ��S5���������NF���j�_�T�r�E�THk0�,�c�pJ�,ep�9Æ͌#'4�T�,��jV���<���ς�=k�c�8K������v���������A	�f�@VTA±�	�bˍ���$�HNpO.�QO�ɴ,����(5.�`U��όښ�H'o#�$����n�>��4��7
����2 �拉?�3?��6�V��mX���/~��t��'�����if��ۓ#kB�Q��H*ϔ�,e���Cn�,��̣�ګP욁�̈����y/[H�њ��C:/Tk<F͈���
���[�61��=��`_#��k	��[80�@^�C�p~eoz8���Zqg]����"�ϓ/�J���p�!��18;�r�9~�b�����/���W5�N�R�F�N�bNy�0� Ph��NuV��c!K�����F�A�Jwg���=������7����\��d�0�}Ga�a�(�	��!ik�o���N�o3�7+A=Dvr�Ua�4iûO�t֌�W���*�I��[ƾ7��.���B�ӐZ�(��i�@@�yZd&Si�m
S !�B(
������활i1��t�P�3�+�X�D�`f��i^���(V���oe���F�Hr�����"{�xo����69���o;��@�A��J�cR�iZ6�ov�[�����	k�(�:�mڂ^�����zo�/?S���>��}lf�1�c%f�=�~<�e0a�u<��A��-�:��.������L?a�G��B��ԙ�6OEH�¢r
]
9��ڳU�<���CQ��;�F���\���pw�6�@����L�0�JX:d9bU�M,�"e��[�6�^�����Z�>��]�桳`��fG=�[�Mm��S���ڀ��<���������/�������Ea�2aN��@���E�
��.�uB�9���`�\���߄�����Y����?��@]A_ĸ~.N �:d�UE�Y�&�g�����P�h�@�p�� �:�OA�U���Cx����]�2daeK�(����>���ZISdX8��SKi�5�p�Y /�e/�2J3�V�]��s��s�^��L�a�#D�ԝ�U�橈�i�}�kS�ǀB~���>|צ;���ua�o�5�L��v�C׭��eJI��i+H�k\�1���րi*1E�#*�p�R�t�*�/ .V�����wl���<����7��B~�w�;��� �U5BK�H�S�e+�v�g�Fy&�,��
 [`Ɓ�,B�	Yd&ʱ`��E�:V��=�[
�Q�0���!|)����H4���uMP������}U�ܛ%�#�:��<Y��6�,�A$6
����^F�R���Ǭ�-��;�������&DI��,a	��0�2S���+���H�ಐ�dU�w�B.la�0ޤ��[y���oMlk��$�L�ĊD+8&H��J�/e5�\�[��iSb+�Y��f�du�Ya,W(�����KE��70V�������
 /��RE&wF�Sy@;��һ{���-,V�HtH�_݀�fy���7�7a��B~��w/j��|�h��
���-�Y�>˷I]n�pĎ��J)��eބB('A[��R�x�WHPJE�5w��!�;5
p�|]�YY��B��9�
�=��1���|S�1q�� �Ƕ�(p�+$f��ўr�3%��6�����B+��K]��#a��������XI�=�>�\݇v1����V����(���� ��.��ݺF�MPkm���
���:�H����2��do��<�N�X녶�q#/ƹ>�80���ߖL}��x�SbQ: �+Q�x�:q����6����}�w U�Q���VTw�լ	���;l��F	��{���3��$���k�+=abu�(uv,��9��I��2���x�`u����u��SY!%����@~+o����1s�\Ri:䖳ªH��I9&������{;vG�X�ߛS����%�h 㶼�����2h���R��x!��hcr��v�"�RG�Rl�,��@�{`�E�EI%�`�0�:�����<V:QJ	���D��}@�����]��NU-P����bg�3�ɥҔ���>gRa�ǜ��r���� -;?�3�oh������[�Հ3�R�CB}ȋF���w,1���@~@!������M������h+��G�e*(t�J���]8���,+���+2*��)��A���XW������X	��uMU��I��:�G�~@!����]ta�_�[&�ƍ8��ԍ�:/�"E��Rbi�����b(h� Vg���4/di>Jٜr��n]��{��y+L؇Ń�1M�}f��B'�)��>�B~�w���������DlӋ��.[βQ�������,m"-�9;��6��V���-�+ ��3��pڐEj�.�4c�.L� %C��=��;VwR)��ൈ;�$��ꖙ�_���Wwcg��5�3)�'����WV�9V&�D!�xb@���֬I��ĦD?��M��f�HV�c'J,I{��U`A�Zfd�l*��#j��uN��E܏څ�()�=�Y���o�ϥ��kyH8WUiV��	��m��N����֣y���Ӻ��"&m��GCU#Y�}.��>u��
�52W��J}�Ej����,Xt��V��o���0�Fi�c:�%�spȲ!Z�Q�'E9�g]E���(ط�os�i3���o����Y�i�Q�#��c��S��<�5�\���(�3`��wߦ�)ˤ'x��6������(��~�(I��ٱ�C⺭H4�؉�(������=��w�zߝ��ҿ?TwU�թ�$���Ӭֽ�3'�Y�D    �]F
�'��m�r��\�θ�ZA� \�r�����Q� p�nrZTEZFw�:�е��| �dbf�I'��΁-%��o1�/^x�]`,��8�X�D"��<^���5���	��O�m����Z��CpG�b���	�}���]M�����>���OF~��`h�j��>,c�>���˥L]$1�E�lg}fDP&�3��!͊�)�AeEV�5������Pjn	�b�I�!�"���Z,I������r�y�%T����#C �������j�ޅUԴ.���A��ˆAZ`&E�F��P�,G�^��H�0P�!��E.��F#c��R?���m�x��&�+|�+=���7��YO�s��b(���~p}U�ޛu� �C��FOI���;���H�e6�RIJe^jTh|P���1)xi��,�⧉��1�ע$8><(�۪H�c�8��Jb��Fbfr2~�T�3r�I�͓Za�fv�,ypL�}2���ob]BI$$���ܬduO��gc=j,�� ��Ȅ'J�Ag6�k����}#۾x��G���X��I��gT������|7��2�2�H������@E�������R��Fግ� Atd��=P*�u�����썁>� ��k�\���4�<�9d�����>_�4q������U8������̇i4_��Ɉ�w7+��~�`�D�]M���̈́*��H=�-`*��O�[U[�Y�c���[������N��##	��8Шq�0ij�'|
�6Y�=H��i@� �ik2ǯ%����v��6wk(�{����T�ky¡Z���@g��tή���UHq�K���X{�Ono�������N�MP����t�=�?�������gO�飯g�|���~ʚ���8y�������dQx�*�Ѭ@�Е��@NTR1ѡ��m��X��E��sʠJ��!�t����\|�U�t��Z[�����I�(c��伟�����X�B��S�}xGՁ�Ea��ؙ�VK�^��b��R	;���r�7U��UY�ٮeY���@�J��^��8*v�%}�[-D D�43C$�߽�^J��C/>t5 ���:R��H�dI���/���c�8@��}�U�4�~�XSn�|ըB�T���9e'��Y��YSOCǋ����Q5#�àJ�R���AT툒�N���^�DՎ�8�.�Ud�����Tl�E,v5m�lC���g�y�Y �Sن�ag��HX�8|�WmՎ�Y�,�!.Z�Ϫ�*i�]��(��Uk��U+���d4+� �/j$S�Ƹ������ŀ%�6G1=wqI�ڥ�^s�?\��U^,!�m�j	ϛ)����r����P��[��4�y`?ӆ8�Hr���V#�����h�� �[��e@]���?Yؕ�G�Rk@	�p�� ���l	�ËO�~;y��ތ���vk!G����x1��;{Ve���6XLd ��iQH�(S&��� �.O��a�MF.���>�u��ߣ���Kɇ�^�A��;>JK��S=PY��Q���S���95���8ۂ�N9�Sn�q؀jC�rh�q�A��q�zF	�Z�ήL�]_�3�][�~q��l���p��	�%����-�{�*8�/�	Z�f��`m��R2D�ˣe�~7G��N&��xCP׳	=��W/Ew��`���x��vޏ��s���gO�~��g\L����&d<8�i��L
!���$�Mm+0�q.Y��鼽�~��3>�7�{?R��dq��H�1�om��T��܀�ro�~��h�^�kC$�F�T���lg�Ɵ<��Փ?�@?|~z�J��j����}� V��=���W�S�J�4/
d����:�,7���|�m2~چ�t��w:^���B^˞�v~��=�CXV�������~� eu$7�;k���Hj}$i�}	��*#�RL�%l���Hze�y;S�D��04'��j�����Hq�=A'��*�dӾ>R�IQ���HJTG��R�b+z�T�q��1��M�$��j�q.Ɠ����RI��D�|�L��֢�s�;�\�2-x�U��*��sN�̒����t��tl�tW6QR�Υ��j���׿����L�f�TY)�y�m���<�<��"��P���s޴��ڌteF�9*������\��sz[����ȴxd��1]��w�(��_2Va$8N�\_�b��m�[/fb��I-��6!����N��I�ִ(��k$��m�h�H�2�^h��KQ{������n�@Xg ;�J�V�2���d�bF�>#R��Fw�h*�:v�9B��϶-��m�*���$h�.\��� �L%�hU	Y����#��H��9�P��~#�Ɪ�{�d�~!��H���la�c����t���"MY�ĂzW�^��fN!v��P��R������2�����+b%��sir�/�P/;Sߕ�e��zZV��cT	8�����z)�R�=^�ZrQ�~��*���Rb��u?�ҁz�K��J}gƖ�_8����L�r��x��P��Eo�mg�]��,��ڡX�K�5d��v��R�Q߃�e���5۩cn�,X��t�^��^���wel�������쐭pbȵ���ˎ��c�5Y{��콉׎�ŋ[�Q��ۑ�}Ɩ�_�{�b��ؐN�2���ۤ�q���<fg}��V���"�ip}:�-�����y�jc����z���\bc/�u�hh�R~pS���K�Lb[k�u
����Y���i�ν`��u�"�8Hղ�Ҽ�iT̀6Ȉ�owՔ<?}x,\<��@D�U�����N���O��3�?�v�o5����iD�:Od}���Bf�#mP
m(��ȴ�BFN�6�ܚ������;+���G�F�V�,��v����U,��Xÿ߯z�˚��;������kM��gL�\G�^9�߼���L��O���˩������6��.S_����󷣚t.G�/�K�<B˟��|�B�K�F��d��ek��`�u��D���~�:���l��Z��'�70ճO5�Q�_���y�D�ͳ�M�y΄(&�V	���q�Sp��ڃ���J���G���n4T~�L����f�KVƏ�_:�����BÉ�"#�n�S%�@�i�
M�b�_:�ƫ�3�lrV�Y�y�/�fom�oѳ������}���ai���ɂp��m����h����k��=]Rj�;�<�ȼ�7s��[m�`���������(�CLĕ�ZL�l�36E'�z�>�������|�+|�񘉰�q���&��Yd���*��Idˀ/�0�B��Eh���f]���L쁰k]��Ee���b�A'J��-a�9��y�7hДeN�F�^,G'�4�i�i���4���nKq�b�o4���I���e������l��|v}v�b��D���j��`����>/�6R�7�U����R3��g����s�dƭ�ri~.ߢٛK��K�э�F����d|tu�.&1���γ-E5ZW��3��1LY��2��γR>��M'ٯ~����bz������y���_GoF>9g��QH����4����l|�hƮ�#���G_�I������s��^>���xj�'�&��(��N�%[���_� �;!���+L^�Ȭ�y�
WaE�|�&���M���rt���o���ev�!��K�����	�_G��_�I\��G���$�Hǿ�$)I����6���tl�Ӷ��J��]i�FC�%6�x1�T�6�0��kĦ@��
+�m�M�����y�9�S˗���m_�ѕ3��K�%�[�Z�;'HrY�0�
ˎ:l;�p�?U�E�� Xƃ�W�mZ����̷v���5s 5v�#��# 66�?ʁ�����z=޷�x �T94s�m�cm�#�ȣ��Zä۷�ή3I��"��L�L��[�� ����{%���rIŰ�I���mQ�K���V8��52	[d��c:���Ό��@��%�m�
��/��a�mp,@=@��<r��~<���#�.�)�z�R��٤b�MݰP.lܰ`��v�I3-U?o��v�jV���!���    ����Ne^=@Qu*crG$ �t�}wfm�o�N�A���i֙U+�v���(W+�e�`�-Ĥ��:�:	����ʟ�2��Fo��}|�?=�Ͼ�KR��i��-��w��?���<�1�����$���k�'� S��5�T�|I���#���G ��F�p�3����1>�壷�������N>��Q���HD���2�9S]\���k7�.�[Y���UX�W	ygK�x�������F��^��*�Ѭ뫱�l��y0��b؜����hP���]V"�-F[mg�bv2�����D����h���֚����`*�K��h��(��h�	�C�e�����h&�UF��v��hqǇG�, [�f����s
CZ����h�2Z�6Ł�B�PTF�����(�����h��p݋�'���h�;��ŕ��ґ3��*o'9k-%��]�>��u=��HLI�],dgV��vQh�'�6ӸռN��G�ebL��(��h�P�~���#:����嵏�Z���9�Q����w�zWd��Y}�2�=?:_���׵@�m*��f�ư|�Mkݢim�Ĝ��l{���Y�O�Wb��������g�e1+��í����a8��?�Q�]ġ�F�s�������0=V=N�m��:�O^�����Q�b�#��r\��8��O�*��4���c���|�6V���i��a�T3��.���͹��v~�ܮo>�Y	.�:�LYױ�ɓ|�)�yt_n�6���ȚaWy���0eS3��3����>�[��g<��Jh!z�������݋�0=
;�m"PέR�7\�`�6xMB��?��\��	o���@^wܮ8[����ckX��u�Cs>kİx�l��Ul���_�F�w1�d�@���A��)�_�J웗�������|�����G��#ݣ�����/�"�Ǣ*�W��F�e���7�n&�3�8����)>���Qi]n�Z�#O6.OՁ�OVq\�f��bs��u��q�ȳ�yv��Z�,�X6;A�X�6 _Vʳ��w�=|����b>��c��]��_�7�M�b�F�$���i�~ �ΐ����rym�����K��6P�Bu�l�����x�K��,�[�������3�\��s��
��H?C�𫪞���mwJ�m���������pn�:���n�9ǜ[qp �e��aɲ��v����r<��{�yֶSn��<�v϶��Ww ���k:�F��p�w<��[�ª�aT1쑫��"%5+��mb6Hf� e������-��������o�y����w����Iѱ�	*'��읠��+6ɶ挭�]��f���`2Ѕr$���� !�Bh*�\ 'da̂�\ew�^�߇Q�}�3���m���g�|�����p����|4��ˑZ7+՟�h����4�;��p�'�|iUU#	R\1��N}Z�DZ P9���ع[�L��&5���Bȥ���P{�9?{�k�R��f���
2&�M=���x�l��|�:s^������v����S���� ��TfΝV����&�*J��x�����T|���~���~�j�Tf�9R�E����
at�s̴NC�B��	� �G�A~X�wG[��jhU�ôj��_��^���<$x ����u%Q���;`�1$(�kR!�@���B�:�h�:Yfl���W�C��X/�VwG5~{��0#>=mW�/XyF�:Y�?�������d��=�"
Y{`��m�
S�
� ��+���c.Rr����WNyU��"Ӭ��i�*2Jm��B8Z)C<�pE�:ؔ��^+�_�8�~���ϣZ��,rҌ�^lҊ��,Z���\j�Դ�_�������Xtm|���4}}�~�Vj�je Ԭ��H�c��Fڳ���X�r� �P$l�*��R�鍳�͌�w�I��Me�
}�����pZ��O!�CaA�1��w�<m� �ĺ�N$I�6��������lD��v"�'Z��Ȃ�� �Y�j����D��PXJ�P��^��/������D��,$�nFJ"�[u *:o���a4VM����1��������1���篦��WS��U6M��!fz��>�vq����z)��%����ca@��fiaM�&V� c�	����	V�,��������AyQ�{�y��g���=ٲ�> ��c��* �V4B��X�߀=�{��׾i��w��ۈHv0D2�
u�""^U]<��x�j���iƖj�FlB��Z1��	v�G�\ZM*��E'����2;`��N�@�'��!3��yw��͓O_|�lw,���'�?��}��ɳ'�q����x�l,�b̓/ݡq&k��t�k��Ԫu�J��}zm-/Z𱥀�]��a��/ȯ?����el}�?��Y甔������Um���Y�gN�AX���O�S�=��� ��0�$�ݟYmm�n���pb��3������}����O��4�L�&ɤ��;�������\Ju5� g��Ż���6�Q���t�5ry���!ւ�x-y��
�:ƚ�&�߆�ZG]�Xs5d�pa��=:���5��ga٘��c����]�՝�X �Q�X��u�5�T��b� 麎�&�jv��i����5	S�ДpZvbM�x���eMWe1k�f��P�o��!��CH�2�!��+n+��7]�X/Eñ�o�ר<P�̚����$AӖ>�3N��T��1!R�q���u�^B��he�18��p1u��rv�-���;T���4��ݽ�ߎ��I�O_����ݜ��q���5��s��҆,m��\����Lۼd���&nn���ﾡ�I!��w�=�����~��?������C�ˣ�y����ܼ)��Bn?Q��}��d�_�5#d�e	��R!�E�dH�y����i�kd��J�<���B3p���e�ri
{w@��uߩ� �t���pԟ��1�9zs���ഐ1!�P�>q�m�d��}�!AK��6E`�.N^�~s���脨M�EeYL���)�`��=��%�4�� O�;�av��컣Z������-S����U[� ěV ���>Y˩z�.xWuBU��&!g�j�٭q�knd4�/���*�Kc�_�����ͺ���\�ԙ��c�/Ea��wXX���K�l*+2(�gB�A�����펠�1��l�k7]�V6�3��L�ؕ�P���W+�V�؈��b��vz�C���Gq$��O�Z��V;grp$I%2��(���A���?΋,�`��t��Q���y`_y�]�Ǔ��}�F<g�Z-�l�c�7��5Q�j�"'�9Զ���g�[Z���Z�SU�%�m�g�2�YC$+�pTg,D�d��|��Tf
LȜ7Υ.�6��P����d2eH�Yzwt�ȫ��U7�0:=���t<�M?����Mlی�ۛ���s�c�[���<�V%�f�J4���x��.�$2�l�\�pr��_�a��K���B��C�@Z��L�X�a��;���j�x�z�fj���x7�X�Ѣq&����,s-k�Y}��Yq���P͗�А8��m���%�lp���U�� ח����j:���� G��,�f���]�F�#�ői�����I�M+s#�N�,����T#?R��E�O{����@i�כ��� i��-����;d�e���Ns
g�!E2
�mW�i)�F�QZ���s5������d�gu�������ԡ?ҙ�|Q�ઙ�x�K%��N箉�9P�n@��Mה���5��z]5�k�ˏ�^�ܱ[�R��7f+ks��l���	�����)���ֺä���gl�J�(k:Mf����`��j��'���H�.NsNo��_���� ��<;Τ��LB>�@�}wp�h�x�R��6��EiI���*�M4)g
'��U�3��&��<��,?�N7Շ.p��E��1Et�P�ڿ��_�FQGƭ&��"�G��o�̑�5��d64
��
�i\��c��X� @R���GQ�v|��ʭ�����u��7����ϟ~�VB0�m������� �MĦz0�sZ
�m�k �  f����.^�L��)�w"���oA�j�q���p��l�[Ǫ!R=�BT��a�M�v˝��V,hu.F˘�y�Y��P>�.<P�Ա��c�bO�,���婰��X��<��,�oǯɧ���1'���fas6X��x��?ca�'�}N��k����C������rr�G�ٸ-e,�j��g���!E��e,�Ԙ����\��O��!����O��D��F}�m��%	#ܶ9ɶ��X��K�:l�:M9ɏ.>~u�?zt����Q����.�f�u�� �2vk��	���_����.,�͟-��R�
��yg�q2v�ߖG퇁�G���� i+�O��ѵc؝A���Q��$�u��@�����~@�����Ŗ�M�p��a������y{Wܞ����m�q��nr��a�o�\Y���`5`�ܻ�Q����T�����c��t{�UkS�������ֺ{ӵ�=ve�
�������i�.�Y��"6iف�h��[WD_��Г�_!K7�!	:F�G�c&�\kW�6��r��T�c�fs�Ly������2���\�fS��mj@��y�����T���������Z�c��]��u	1v��;6@������u;����
̴5��	Y-�`ˏ��In��M�����w���;�T����+~�p�����v����-*�����TjS�e	���i�οwQ�zn�N�5���T���+B�Oq:�ޛ�5����Qi��[�k��њ��­������4gC�a	xx�3`��{ݹ=����Yq:��ݫ�k�<��� �.jNc�ԭt��w�J���>���5Q-?��G�E�6�Rݛ&u�*A�C��ڨ��>�uR�����^m+ujj�V~���ZOmڬG���h��k{S���$쵠�!$���]Ԧ�>`[�RS7�9ij�S��ۂ�Q�K�67ۛm�&�����.*Pm��ԧ����ݠz�OcO����hO��P��A[DI)������6��ٲ۾����R|S�}k���p�Edj�ʵ>5��*?�Ҟ�'B�5�#�����V]{D�N=�$�.��m׊��s�]T��v^[i�&���׫�b�v�Z����ڕkC���iW�f_�� ���]ԫ�>`[�US7�Yin�ףniV�Ucg����lo
��K�Ľ�4(Ҁ���"5���N�:�I[�d�T��nY�4�Ҥ�=���I��gI�k�HC�t�6wQ��=+���f���7=����M]6��*uhv�7U���F�;('���]ԥ�N[�Rs��՘���EO�jo|Q~�S�&���bo*֫�jj���Y$�n�l.Ɠ�0]��9�*o�i�; ��E�3�e]ޯ��a6���+�|z}F��`��r��,�=�6:bf��o^I4��g�T�����WaC��2�y8��]��;�	�$x���_���J^$5�"�M�$h�E��1�w�tru1n[�"8_#F�l�����8헅6-�rI����š��6j��zq�N��om[��%��ᇣ�壌��U�".����k���.�w�Eⵐ��K�_n��t��\$��DӞ�\m��)mҤ-����k��_�5��^]�v/|U[�u)�??���t����|f8��>����,���sWw�.��2�0��v+rΏf؝î;���8l��kN� v[q�G�W+��%yl�d�cWr�`'�s\vj�q��~�*g��M��Uǌ����O���~��V���C�t��",
g��������O���Q)��2a�m¸�p�;�y�Ͽ~�ņ)R�)�����S\k[�_t��ZL��5" ����dK;��e܎*�j����/��˓I�3]�j$-7X*k��wp�~ ��y(��ή��
����il��zv�3Ǡә6qe�T�̕a��BJ:A�n.�Y��c�/�W��:FkUP4c�&����MB..+]W%��l����IHKmp3���m�쪙廊�F7�-h�o���ƪ��S������Ke-mEo�#�f�2v��g�P�}��t7�FM��7/�wX��,Vʴl����fY��u.I���Z�ɳ0�`��/F��|�����|�[3F$�/NxBMH�-�_L�&I�Q>z��G�����$�?�����?z?j���w-��ek�9v�7����M�ub���׆Ն.��$��D��[�uz�����4��GW�Ħ���R�)�y[��U)w�E*�E�Ԙ�Ds����\p�K<x���m�      1      x��\�r�:�]�_�~�np�Hy��Qo�Q���<ϳ����U���5�����D�  HӜ�/��{p�b�?��o�����/�	����!�8{S�!��9|o���Ǽ� M��=�f_�s��(�b���}�yN����S����{�������<���
� �%�wsj�9��b>(��u�+4�7�>����w��?{��ˇ0��=�`�[ ��C���]���1���?�v1���7&ޤ�Ji\OĮ���m���-d���0�'�b������h�[�ak2{�B��0���	��nN�������h�@��)���Wh�M�Cx��h�	Z�1�M���������B�c�QOl���<a�7��4{��L�ڎ�d;h8��}���/��l��
��\�=��\~�#��8���C�,��v	�#�<�/�����m��P�T�ʿN+hf�i�aݼ8.�
�ᣫSϖ�s�Vo�=�P슉7�~�9ь�������p�c���o���n���4�|���I.����v˛-�㼖�R[1�9���\О5x��C<��и�><����~$g����C��"X���h��J��(>�@R�L�2�Բ���9�y����Bs\k��I��Ik��7�PwS*�)���~�v�r�!���*�\�tb�D�K��M���Q�@;��R� �3�	�I�]������h'�r�H�P�z��n,5�;(��O��t#�O���O��H�q��*V�\�ݘ�Zj��=��/dɘy��n\���!�p.�؇t�O�C���>����ZS�d�����ܸ��>L%<�<{j7.�JG�$l*�ڍ�>y��<xb!ʕ�
���Y+�=Av�"�&�.����j��D0�?���<{fW*��C*|���7TNTV����A;Q��1���'�A;Q���u hϖډ���1tɇϹ'��&��D���V=0(>�]ʉ���!��g��rpb"���@����58Q���1���ډ���Zc07������q*W����7�c(ډ�-9=5*��h72�y`h�Äo��@�������=��LD���FF[tE1� J=�v#�|��R�'���_E�$50�}x�!��kN��~�����m�~�h�O.�z�Z?���+�-ޢ��P"�h7VJb�T4}��h7VJg�)���g�n�Ddz�b�
57Ȯ�T������ēx��D�#Qa���'Ȯ�\hL8$��3h� ��ƖP�~BG�3��S����/_y����m���R_ߐ�Q܍c.mX�C=0�����̤Ɯ@P��3��p�D��j:�yL��!�3o��'4�-l,��=D��y �j��&:��`ӟix�,���0ͬ�q1Mj�$X�lϬoU3�"f�=�~��{ʲp��^�L�S��1��	��#W�g�#�$��a�1��s&�`m>�m��g��ÁȟYx�́��1m��R��*����0VK&�vv������ȚD*&���v�ǌ��H�1���l>��?���J,��!���}k�0l�J�bږ}�´��?s�%�La�o�e��$הW�g�P�";QPPX�g�հ�\�C.�2��:Y�=O�(6Dv⠰�6�<}��S8��,׵M�$`;_���_�q�൵�+��:$t�7B�z1vs
i�
d�q䠲�WJ`����e�e����C弜7葌#)s6�h��jo�Ь[y��-�j*�}AdG*�<��)�Y�[�!�2)�8�y��c�0����AIV')S|dv��v�K�6ٶ��d��K��N��uf-�GZ��D|��P�a7ALU�pT��DAIF�l�l�m�ij�X������9��0Mm�"�I��*c�J�wɒ\���˪�r�!/V!����' v5���Ģ���ك0�"�	��(��pU���5��D.`C�K����_���@�*����W�0��H-s��U{:�Q8e}��wb�ge.EA��A>It�Z��^�M��HFQ���M�tl]'��}��?A]8L�Nۗ�\��`'bz�]Q�����&�C�Oņm�6sΗ���|'^j*hq�e�M�s��3��r��b�&3";�%ƀ���(Ŗ.K�2���MٟUs�z�1���P��+�/s֤u�p�#��qʳcC��N�4o�=��֮s[���|㨞Ǭ��J�پ1�����P�^V,�u8�=�i����}�	";�'���å]g��E�2C��Up���0�L��91�VhJjL��u�kU�!_J5L��I�}ք�������!x��2�|<vU�&Cr6bIϡmY��)6�du�M|_z�>��O�W�8�}Ȫ�NF.�zGd
R�P��zh-���ZVU=M,�x��6 �-��.�J�����ҭ�US]���r�:�s�P���T��f���U*ձpe��ͼ����s@��S�B�60x�3y��r�M�2����s�򋶣{d�;=�EѕM�-fo�1�e�c�E��}
Zd���m,�b�����GT���mז��2�"���y��C`׎T�A�����:o�HS���D����Y�uP�\�&Pg��m���܂&kؘȢ���ߧ�_�Q #���g9FK�cތe�w2@�����ٶI1�9
�CҶ)�`^T���������q������w��_��=��6���qw3��	�7*<�Ϯ���#aI�'�J^E,���.�E�Gr�����=�%m��o��!�DϦai��S��{զ���*�h׹A��[����yH��z�0�P�g������i��X�m�3�W���gͥy_���n��<��=y��&'����fT�&�~�W�E�-2GU��_z����$�q)^�jkY�N�p�IY�ع�G�3r�W!Tj�Fk����_�y��JȀ5�8é,��,�(,dÔB\
{o�Q!�Q���ϢU�G��礟����)%���v��w7Wp�5c̋e��Q� �j=G`p�����K8k��y�ĶP�m_�Y��BU��
�Z'�g��;��1��J�ٖH�FB��ʫ5
=��1�W{K���TAǢ���!5m�`\� >
�C@�S�Z���x��} ��!Jj54+j�/�x�g�������2�{d��^�'-�i<k-Cw�0'CVL(N;�b���.�gȒ=��R�[[�x랧��`�������Җ��#N�#�w��GRs14'����{��I6�;����2
^[C�"�he�Օ�򤊣s諡Τ����m>p-�B/f��ZO����/�e�h�_��<��l����U29�3lȅ��:�e��3"�qRJ:D��Ei�y�Z(���4f-��M�ˋ0Yz4ǦGNɯ7/�g�gC<�a�iH�8nguc2�~q�$犀�v	���&*Ԛ��!�6�o|�	Kf��hR�F2�Ô�l�0AQ�}�Z�LӾ��pߔ{���ݬ.aQ5�|�]���ISk���J_;�y����~��:y�c20E9�E{�=�&2����.T���0P<=&��V1�w��-�������D�rJm*��Y-��c0m��چ���9�[h ������J�ؚ��n�`:�fۈ�_㹇�WA+s9��y�uڥ���Y�����S�/��C_
�`��z�u�����1�b��#V"��n�Q20��'yUY4�s[�\�}:ȓ-�>��9�{h{������ǂ.����q�V|����U��ȞA�_��U���殛�*ɲ���k���ŉ�{h�:����U~�d��,N����פo�eG.����5ei���3�<G�Q�GrlEV��!�#=�gun�Q�a4���z���V����4��#��P������4�P��׹Pf˅{�gUخrB��nl��z��}5PU���!Q}�k"���*Ї�9�t:F�����CUom_�xYU}6���jQ��Z�Z`�UrmХ����t�|
�~����e�*\�H%Բ���^GmU��9��q�m�A�B��QZ6f�� �
  @��8Ì.�!��ce͊#���Fi�5t6�W�v�$Ey�q���dp@\�(�pA<W6R)��g4���T�ӐG<
�zr��>AhW6*[�5����FPskɩ�W筒z�i�.�άait��|�.t3�m��=,�_�,K��$�Zg^�Ȫ=��E��_%2O��:{�O(�QMS��{7tc�4�?@�����7�л3��9QѾ-��l�&KhU��k�V���.���uЌ��U�6��.ٺF�1x�r�v-��cR�sK�.�Dgޓ�gb��C���z���3:9�:����U��#8�����L�C���J�]��s�n�&�Y̶r:�l/�H��D�F(*���%t�6�������y�1��g[Z�|	�so���SٜJ3̻���e��`L�)*�@�r�e�3t8Z� �0��X]��푲TUWa!������cD�?@W�0Z\Zn��:�]g�q�uW%�B�!��*5u��`��Ð��������q9p�FS�/³I�i�jN*�f�լr��*{L�)�>Q�	�R���T�K�1��*��<; fx��M��Q6ހ ����+zQ���f���e�a �L����<'�m�u�6�v[�m�*P5�%��q�$�J�Wc�%<�<PJ���-· �l�q���8���o#���y��,�#93��d���݈q&�ս���"z�'m��A;${Y�>9��&(ƙ趣���ԛ�W1 $�רƏѫ��>9#Dw&���h��]�G5U��s�Y r^�#ƞC�q�Ҟ����ɟ0Re|0�fY���m�q�ӣ����봼��X}ņ6��ae�"��lơ�y���|����g�7�7��xtNy���j�˾=`�h��T�9�Q�F����(#��Eq��F^�N0x�_�;��XcƬbY7ٖ��j��ݸk�)o��>�Nd!t}�9iK�$۪u	�^|7�^蒖s{ͮg���Cǖz���չL���nܽн�A�RF�씤�H��9�E��<���}7�Zl:#B��u��\w��o�P�ȂU�e��n̽�mށ~A]�T�$�28�3фTE�>�w��N%?�fWWj_����m���臬�s0���������c��]�8?�VK�nS��Yы��z�G75m��ExL��X���"����=��:G[q����Z��P�w�q�L��M�����u�5�˷�������=->�Ihhm�C�vB�~�[��&�{�~�[R#�!W]WV�:����\ug�����+m~�ԗ��U��K�β���A�Lc[.�^��+uĸ����^�q�TBPM>tː/G9��-���wiF��D�%I��0A�.����EIX[_�i&�C�$Pc�}\�}ُ1N�#��ZD5��}��N���ѷ�j%#?�I����c�]D�Q�k�ea���Y�T��Wr���ߞWٺ��0B���&
¼Բ�R�����0P�N�S��w}WEW�����r��c{��H���?	��^[�&�ǿ�v��d)k�P�o�~J�,G��m窟��h�x8y���G�����{Gk܆Uw��iP�ys��ī���F�ƶ�fȻ�%��k#~�Mw�q��_��؃Bu�^N�iqW�q�^g(��]���W�S��i�1�����n�yj���~f��׵�����K�����y�����>��mٻ���<��#�ƶ���߃��v;�^�h��ÐM�4J/��@��y�*��x��&j�d{U��w���/�,2��I}�sM�"�.�L�C��e�)��,'���h�U˖����܊�]g�i^��qP��m)�a۠�ۢێ4�Y���(w��v����6�?Yk�6H��;eT�uL�-����y�����E�40\~������IoV��h?M}��M���T�yO�uJCV��D�0D!�#���w/i�WֿtJ)�qN����G��>dG!!={�Ga�(�) Rpg���6tq��9Ѣ-�ѝ���v_֜�@�[Tnm��8�����ك?�Z��qHQ�8bn|�p�vu�8Acx�h�8��;D$�oD�yu���J{��֮�� ��'R(�p��+J?�t��<_�ʽ}�~b��&��Ŵ��?�ݜ��Ƿ��>QY돌��>�TvX���6K��h�:�OH7P
�����	�I��`H��7���"���q��<'�4�U|N-N꨸�)����2�ٛM�P������y�z1wǱ(�Y��a��L��[\BL�0 ґ�_'�6jO�w���
���6�j�1�q��P�87��&	�"S�ꯔ(	��![����7Z�B���ȦyVuI$8���-�_�`��ҿ��D?�A�R��V�"؜�*�LI���hF����Cq=��t�����T�*a�a�"���up����[f�R~��+�I���XU幌C�|�x�lf�)����%���w��=DG�<A��o���������U=��#���أ^����7Ӫ￩��Ba��}����vp.B�c���uB��?!��X@�dQX�}6�0g��U�d����t����,�pux�C�M�V���y�⼯��è��ǿ��}K��}�>@"�a������3�u�Lh����4�&y\��1�e*{���q�
�����Y�:l}���]=N|��\o,
>F]XxU_��u�L�K�H�ޚ��5�E-R�9����5A�/z�n��^«5���8do�g�(�
������2�9U8��=^__��^�/         e  x��T�n�@];_1ʂ]�����P��PQ��;څc����]�S|?�g&��V�$;3�>�9�rHn����g[ϋ�q1/֤��o�o���j��_���6�6���������7u����![��ߗ���]��YsY=�Y��p�#
��n=�K.���n[�0`01c���h, �ȕ�3��}����Ww�dY6 � Z	V"5
� �pٴq验4�b��}�Ve{��$HSHC�4��Ϫ"Y��?��!�A��\P��H�p_M��yFa���u�r��^����TBx�iW���������P�$(,p��J�([�����1竿��c�\,9CMX��0TI�&ZG�TWe�,<�U�"P��(:�Ԧ�߈�T��q+�`Ք�*:��Eo� ���4x��&�Z�l�y~_W�����ٌ�2���H�^a}#=@�`�ls�{ɚ��;���v�:Z.����io8}���%��[����+�=� (��{�bh"ppo6g�3iARΔ��"��X��_������݂2�eh���"BmX�����9�9�#eZ)�a7�I�z��M�Gy�Ǎ��_�?:G)}�-��*-���H�U�-K)��v�����T�"         �  x�}S�N�@��~�? B����%�%��q�%�g-�%m~;���Qd��g�O�_��]��f���#6��:���7!�$��RA�¶���)_�
_��!$Y9��w�Yeh�B�#_��3���]�b*�"��ڝ����e=R.V�{��ru�3Kl�f|�`v:�ǽ���?
���
m&����(�9Pj4ʼ-|(��u*O%� �d�E��` l6zae� -�N����aro�$]PZ�	�a�Bq�}g��=���������L��P��m����N܎�E��i�b�v|*W���'�|�C��B�q�f���&�8m�+�Q�}�d�\�|���u��I�[K�/B���`�t��Gn�ȭ�Is::���*�V�*��l��	�^M�%N-��n��ܙ���� Zr��vo�Z���-�      5   C   x�ɱ�0����LD�8DB���t'u�ϡ�i��UXR�	WR��?��9��s.��,�      6   +   x�+(��MM���JL����,.)JL�/�*-.M,���qqq ��          j  x���MN�0FדS�I��i뮊*EU;6C�VF��E܇+�Ћa7-��J��qd���}��g��V�jX
n4��V+?�Dc��$,T��	+pv@���xh1��1��W��U�Bn��
B������?���{ý�*���(Ѣ���).�hJLwI���F��HL�8��t<�E�|����oÕ(����j�%�p)�ZV�~�%���!�������c�}��0���J�� ���ڡ�y�ٽ[Xi���뷰��-v���t���sZ�D��H�I�	���0�x�{7y^qY� �nw�M���tZ��F^� ˧�N�4)؄���	l2:|���<e� I�L�(����     