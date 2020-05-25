PGDMP         !                 x            tudec    11.6    12.2 �               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    17093    tudec    DATABASE     w   CREATE DATABASE tudec WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';
    DROP DATABASE tudec;
                isw1    false                       0    0    DATABASE tudec    ACL     s   REVOKE CONNECT,TEMPORARY ON DATABASE tudec FROM PUBLIC;
GRANT ALL ON DATABASE tudec TO tutorias WITH GRANT OPTION;
                   isw1    false    4120                        2615    20272    comentarios    SCHEMA        CREATE SCHEMA comentarios;
    DROP SCHEMA comentarios;
                tutorias    false            	            2615    20273    cursos    SCHEMA        CREATE SCHEMA cursos;
    DROP SCHEMA cursos;
                tutorias    false            
            2615    20274    examenes    SCHEMA        CREATE SCHEMA examenes;
    DROP SCHEMA examenes;
                tutorias    false                        2615    20275    mensajes    SCHEMA        CREATE SCHEMA mensajes;
    DROP SCHEMA mensajes;
                tutorias    false                        2615    20276    notificaciones    SCHEMA        CREATE SCHEMA notificaciones;
    DROP SCHEMA notificaciones;
                tutorias    false                       0    0    SCHEMA public    ACL     �   REVOKE ALL ON SCHEMA public FROM rdsadmin;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO isw1;
GRANT ALL ON SCHEMA public TO PUBLIC;
                   isw1    false    7                        2615    20277    puntuaciones    SCHEMA        CREATE SCHEMA puntuaciones;
    DROP SCHEMA puntuaciones;
                tutorias    false                        2615    20278    reportes    SCHEMA        CREATE SCHEMA reportes;
    DROP SCHEMA reportes;
                tutorias    false                        2615    20279 	   seguridad    SCHEMA        CREATE SCHEMA seguridad;
    DROP SCHEMA seguridad;
                tutorias    false                        2615    20280    sugerencias    SCHEMA        CREATE SCHEMA sugerencias;
    DROP SCHEMA sugerencias;
                tutorias    false                        2615    20281    temas    SCHEMA        CREATE SCHEMA temas;
    DROP SCHEMA temas;
                tutorias    false                        2615    20282    usuarios    SCHEMA        CREATE SCHEMA usuarios;
    DROP SCHEMA usuarios;
                tutorias    false                       1255    20283    f_log_auditoria()    FUNCTION     �  CREATE FUNCTION seguridad.f_log_auditoria() RETURNS trigger
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
    	   seguridad          tutorias    false    15            �            1259    20285    comentarios    TABLE     &  CREATE TABLE comentarios.comentarios (
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
       comentarios            tutorias    false    8                       1255    20291 u   field_audit(comentarios.comentarios, comentarios.comentarios, character varying, text, character varying, text, text)    FUNCTION     �  CREATE FUNCTION seguridad.field_audit(_data_new comentarios.comentarios, _data_old comentarios.comentarios, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
    	   seguridad          tutorias    false    15    207    207            �            1259    20292    cursos    TABLE     D  CREATE TABLE cursos.cursos (
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
       cursos            tutorias    false    9                       1255    20298 a   field_audit(cursos.cursos, cursos.cursos, character varying, text, character varying, text, text)    FUNCTION     .  CREATE FUNCTION seguridad.field_audit(_data_new cursos.cursos, _data_old cursos.cursos, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
    	   seguridad          tutorias    false    208    15    208            �            1259    20299    estados_curso    TABLE     @   CREATE TABLE cursos.estados_curso (
    estado text NOT NULL
);
 !   DROP TABLE cursos.estados_curso;
       cursos            tutorias    false    9                       1255    20305 o   field_audit(cursos.estados_curso, cursos.estados_curso, character varying, text, character varying, text, text)    FUNCTION     O  CREATE FUNCTION seguridad.field_audit(_data_new cursos.estados_curso, _data_old cursos.estados_curso, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
    	   seguridad          tutorias    false    209    15    209            �            1259    20306    inscripciones_cursos    TABLE     �   CREATE TABLE cursos.inscripciones_cursos (
    id integer NOT NULL,
    fk_nombre_de_usuario text NOT NULL,
    fk_id_curso integer NOT NULL,
    fecha_de_inscripcion date NOT NULL
);
 (   DROP TABLE cursos.inscripciones_cursos;
       cursos            tutorias    false    9                       1255    20312 }   field_audit(cursos.inscripciones_cursos, cursos.inscripciones_cursos, character varying, text, character varying, text, text)    FUNCTION     ~	  CREATE FUNCTION seguridad.field_audit(_data_new cursos.inscripciones_cursos, _data_old cursos.inscripciones_cursos, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
    	   seguridad          tutorias    false    210    210    15            �            1259    20313    ejecucion_examen    TABLE     �   CREATE TABLE examenes.ejecucion_examen (
    id integer NOT NULL,
    fk_nombre_de_usuario text NOT NULL,
    fk_id_examen integer NOT NULL,
    fecha_de_ejecucion timestamp with time zone NOT NULL,
    calificacion text,
    respuestas text NOT NULL
);
 &   DROP TABLE examenes.ejecucion_examen;
       examenes            tutorias    false    10                       1255    20319 y   field_audit(examenes.ejecucion_examen, examenes.ejecucion_examen, character varying, text, character varying, text, text)    FUNCTION     �  CREATE FUNCTION seguridad.field_audit(_data_new examenes.ejecucion_examen, _data_old examenes.ejecucion_examen, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
    	   seguridad          tutorias    false    15    211    211            �            1259    20320    examenes    TABLE     q   CREATE TABLE examenes.examenes (
    id integer NOT NULL,
    fk_id_tema integer,
    fecha_fin date NOT NULL
);
    DROP TABLE examenes.examenes;
       examenes            tutorias    false    10                       1255    20323 i   field_audit(examenes.examenes, examenes.examenes, character varying, text, character varying, text, text)    FUNCTION     �  CREATE FUNCTION seguridad.field_audit(_data_new examenes.examenes, _data_old examenes.examenes, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
    	   seguridad          tutorias    false    212    15    212            �            1259    20324 	   preguntas    TABLE     �   CREATE TABLE examenes.preguntas (
    id integer NOT NULL,
    fk_id_examen integer NOT NULL,
    fk_tipo_pregunta text NOT NULL,
    pregunta text NOT NULL,
    porcentaje integer NOT NULL
);
    DROP TABLE examenes.preguntas;
       examenes            tutorias    false    10                       1255    20330 k   field_audit(examenes.preguntas, examenes.preguntas, character varying, text, character varying, text, text)    FUNCTION     T
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
    	   seguridad          tutorias    false    213    15    213            �            1259    20331 
   respuestas    TABLE     �   CREATE TABLE examenes.respuestas (
    id integer NOT NULL,
    fk_id_preguntas integer NOT NULL,
    respuesta text NOT NULL,
    estado boolean NOT NULL
);
     DROP TABLE examenes.respuestas;
       examenes            tutorias    false    10                       1255    20337 m   field_audit(examenes.respuestas, examenes.respuestas, character varying, text, character varying, text, text)    FUNCTION     �  CREATE FUNCTION seguridad.field_audit(_data_new examenes.respuestas, _data_old examenes.respuestas, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
    	   seguridad          tutorias    false    214    214    15            �            1259    20338    mensajes    TABLE       CREATE TABLE mensajes.mensajes (
    id integer NOT NULL,
    fk_nombre_de_usuario_emisor text NOT NULL,
    fk_nombre_de_usuario_receptor text NOT NULL,
    contenido text NOT NULL,
    imagenes text[],
    fecha timestamp without time zone NOT NULL,
    id_curso integer
);
    DROP TABLE mensajes.mensajes;
       mensajes            tutorias    false    11                       1255    20344 i   field_audit(mensajes.mensajes, mensajes.mensajes, character varying, text, character varying, text, text)    FUNCTION     '  CREATE FUNCTION seguridad.field_audit(_data_new mensajes.mensajes, _data_old mensajes.mensajes, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
    	   seguridad          tutorias    false    215    215    15            �            1259    20345    puntuaciones    TABLE     �   CREATE TABLE puntuaciones.puntuaciones (
    id integer NOT NULL,
    emisor text NOT NULL,
    receptor text NOT NULL,
    puntuacion integer NOT NULL
);
 &   DROP TABLE puntuaciones.puntuaciones;
       puntuaciones            tutorias    false    13                       1255    20351 y   field_audit(puntuaciones.puntuaciones, puntuaciones.puntuaciones, character varying, text, character varying, text, text)    FUNCTION     j  CREATE FUNCTION seguridad.field_audit(_data_new puntuaciones.puntuaciones, _data_old puntuaciones.puntuaciones, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('emisor_anterior', _data_old.emisor)::jsonb;
				_datos := _datos || json_build_object('receptor_anterior', _data_old.receptor)::jsonb;
				_datos := _datos || json_build_object('puntuacion_anterior', _data_old.puntuacion)::jsonb;
				
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
    	   seguridad          tutorias    false    216    216    15            �            1259    23084    motivos    TABLE     �   CREATE TABLE reportes.motivos (
    motivo text NOT NULL,
    dias_para_reportar integer NOT NULL,
    puntuacion_para_el_bloqueo integer NOT NULL
);
    DROP TABLE reportes.motivos;
       reportes            tutorias    false    14                       1255    23093 g   field_audit(reportes.motivos, reportes.motivos, character varying, text, character varying, text, text)    FUNCTION     A  CREATE FUNCTION seguridad.field_audit(_data_new reportes.motivos, _data_old reportes.motivos, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
    	   seguridad          tutorias    false    244    15    244            �            1259    20418    reportes    TABLE     \  CREATE TABLE reportes.reportes (
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
       reportes            tutorias    false    14                       1255    23075 i   field_audit(reportes.reportes, reportes.reportes, character varying, text, character varying, text, text)    FUNCTION     �  CREATE FUNCTION seguridad.field_audit(_data_new reportes.reportes, _data_old reportes.reportes, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
    	   seguridad          tutorias    false    233    15    233            �            1259    20352    sugerencias    TABLE     �   CREATE TABLE sugerencias.sugerencias (
    id integer NOT NULL,
    fk_nombre_de_usuario_emisor text,
    contenido text NOT NULL,
    estado boolean NOT NULL,
    imagenes text,
    titulo text NOT NULL,
    fecha timestamp with time zone NOT NULL
);
 $   DROP TABLE sugerencias.sugerencias;
       sugerencias            tutorias    false    16            
           1255    20358 u   field_audit(sugerencias.sugerencias, sugerencias.sugerencias, character varying, text, character varying, text, text)    FUNCTION     ?  CREATE FUNCTION seguridad.field_audit(_data_new sugerencias.sugerencias, _data_old sugerencias.sugerencias, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
    	   seguridad          tutorias    false    217    15    217            �            1259    20359    temas    TABLE     �   CREATE TABLE temas.temas (
    id integer NOT NULL,
    fk_id_curso integer NOT NULL,
    titulo text NOT NULL,
    informacion text NOT NULL,
    imagenes text[]
);
    DROP TABLE temas.temas;
       temas            tutorias    false    17            	           1255    20365 ]   field_audit(temas.temas, temas.temas, character varying, text, character varying, text, text)    FUNCTION     �	  CREATE FUNCTION seguridad.field_audit(_data_new temas.temas, _data_old temas.temas, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
    	   seguridad          tutorias    false    218    218    15            �            1259    20366    usuarios    TABLE     {  CREATE TABLE usuarios.usuarios (
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
       usuarios            tutorias    false    18                       1255    20372 i   field_audit(usuarios.usuarios, usuarios.usuarios, character varying, text, character varying, text, text)    FUNCTION     "  CREATE FUNCTION seguridad.field_audit(_data_new usuarios.usuarios, _data_old usuarios.usuarios, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
    	   seguridad          tutorias    false    219    219    15                       1255    22733 9   f_eliminar_usuarios_con_token_vencido_estado_activacion()    FUNCTION       CREATE FUNCTION usuarios.f_eliminar_usuarios_con_token_vencido_estado_activacion() RETURNS SETOF void
    LANGUAGE plpgsql
    AS $$

begin
	
	DELETE FROM usuarios.usuarios
	WHERE 
	fk_estado = 'espera de activacion' and vencimiento_token<current_timestamp;
	end

$$;
 R   DROP FUNCTION usuarios.f_eliminar_usuarios_con_token_vencido_estado_activacion();
       usuarios          tutorias    false    18            �            1259    20373    comentarios_id_seq    SEQUENCE     �   CREATE SEQUENCE comentarios.comentarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE comentarios.comentarios_id_seq;
       comentarios          tutorias    false    207    8                       0    0    comentarios_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE comentarios.comentarios_id_seq OWNED BY comentarios.comentarios.id;
          comentarios          tutorias    false    220            �            1259    20375    areas    TABLE     O   CREATE TABLE cursos.areas (
    area text NOT NULL,
    icono text NOT NULL
);
    DROP TABLE cursos.areas;
       cursos            tutorias    false    9            �            1259    20381    cursos_id_seq    SEQUENCE     �   CREATE SEQUENCE cursos.cursos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE cursos.cursos_id_seq;
       cursos          tutorias    false    9    208                       0    0    cursos_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE cursos.cursos_id_seq OWNED BY cursos.cursos.id;
          cursos          tutorias    false    222            �            1259    20383    inscripciones_cursos_id_seq    SEQUENCE     �   CREATE SEQUENCE cursos.inscripciones_cursos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE cursos.inscripciones_cursos_id_seq;
       cursos          tutorias    false    210    9                       0    0    inscripciones_cursos_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE cursos.inscripciones_cursos_id_seq OWNED BY cursos.inscripciones_cursos.id;
          cursos          tutorias    false    223            �            1259    20385    ejecucion_examen_id_seq    SEQUENCE     �   CREATE SEQUENCE examenes.ejecucion_examen_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE examenes.ejecucion_examen_id_seq;
       examenes          tutorias    false    10    211                       0    0    ejecucion_examen_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE examenes.ejecucion_examen_id_seq OWNED BY examenes.ejecucion_examen.id;
          examenes          tutorias    false    224            �            1259    20387    examenes_id_seq    SEQUENCE     �   CREATE SEQUENCE examenes.examenes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE examenes.examenes_id_seq;
       examenes          tutorias    false    10    212                       0    0    examenes_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE examenes.examenes_id_seq OWNED BY examenes.examenes.id;
          examenes          tutorias    false    225            �            1259    20389    preguntas_id_seq    SEQUENCE     �   CREATE SEQUENCE examenes.preguntas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE examenes.preguntas_id_seq;
       examenes          tutorias    false    10    213                        0    0    preguntas_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE examenes.preguntas_id_seq OWNED BY examenes.preguntas.id;
          examenes          tutorias    false    226            �            1259    20391    respuestas_id_seq    SEQUENCE     �   CREATE SEQUENCE examenes.respuestas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE examenes.respuestas_id_seq;
       examenes          tutorias    false    214    10            !           0    0    respuestas_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE examenes.respuestas_id_seq OWNED BY examenes.respuestas.id;
          examenes          tutorias    false    227            �            1259    20394    tipos_pregunta    TABLE     A   CREATE TABLE examenes.tipos_pregunta (
    tipo text NOT NULL
);
 $   DROP TABLE examenes.tipos_pregunta;
       examenes            tutorias    false    10            �            1259    20400    mensajes_id_seq    SEQUENCE     �   CREATE SEQUENCE mensajes.mensajes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE mensajes.mensajes_id_seq;
       mensajes          tutorias    false    11    215            "           0    0    mensajes_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE mensajes.mensajes_id_seq OWNED BY mensajes.mensajes.id;
          mensajes          tutorias    false    229            �            1259    20402    notificaciones    TABLE     �   CREATE TABLE notificaciones.notificaciones (
    id integer NOT NULL,
    mensaje text NOT NULL,
    estado boolean NOT NULL,
    fk_nombre_de_usuario text NOT NULL,
    fecha timestamp without time zone NOT NULL
);
 *   DROP TABLE notificaciones.notificaciones;
       notificaciones            tutorias    false    12            �            1259    20408    notificaciones_id_seq    SEQUENCE     �   CREATE SEQUENCE notificaciones.notificaciones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE notificaciones.notificaciones_id_seq;
       notificaciones          tutorias    false    12    230            #           0    0    notificaciones_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE notificaciones.notificaciones_id_seq OWNED BY notificaciones.notificaciones.id;
          notificaciones          tutorias    false    231            �            1259    20410    puntuaciones_id_seq    SEQUENCE     �   CREATE SEQUENCE puntuaciones.puntuaciones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE puntuaciones.puntuaciones_id_seq;
       puntuaciones          tutorias    false    216    13            $           0    0    puntuaciones_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE puntuaciones.puntuaciones_id_seq OWNED BY puntuaciones.puntuaciones.id;
          puntuaciones          tutorias    false    232            �            1259    20424    reportes_id_seq    SEQUENCE     �   CREATE SEQUENCE reportes.reportes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE reportes.reportes_id_seq;
       reportes          tutorias    false    233    14            %           0    0    reportes_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE reportes.reportes_id_seq OWNED BY reportes.reportes.id;
          reportes          tutorias    false    234            �            1259    20426 	   auditoria    TABLE     L  CREATE TABLE seguridad.auditoria (
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
    	   seguridad            tutorias    false    15            &           0    0    TABLE auditoria    COMMENT     b   COMMENT ON TABLE seguridad.auditoria IS 'Tabla que almacena la trazabilidad de la informaicón.';
       	   seguridad          tutorias    false    235            '           0    0    COLUMN auditoria.id    COMMENT     E   COMMENT ON COLUMN seguridad.auditoria.id IS 'campo pk de la tabla ';
       	   seguridad          tutorias    false    235            (           0    0    COLUMN auditoria.fecha    COMMENT     [   COMMENT ON COLUMN seguridad.auditoria.fecha IS 'ALmacen ala la fecha de la modificación';
       	   seguridad          tutorias    false    235            )           0    0    COLUMN auditoria.accion    COMMENT     g   COMMENT ON COLUMN seguridad.auditoria.accion IS 'Almacena la accion que se ejecuto sobre el registro';
       	   seguridad          tutorias    false    235            *           0    0    COLUMN auditoria.schema    COMMENT     n   COMMENT ON COLUMN seguridad.auditoria.schema IS 'Almanena el nomnbre del schema de la tabla que se modifico';
       	   seguridad          tutorias    false    235            +           0    0    COLUMN auditoria.tabla    COMMENT     a   COMMENT ON COLUMN seguridad.auditoria.tabla IS 'Almacena el nombre de la tabla que se modifico';
       	   seguridad          tutorias    false    235            ,           0    0    COLUMN auditoria.session    COMMENT     q   COMMENT ON COLUMN seguridad.auditoria.session IS 'Campo que almacena el id de la session que generó el cambio';
       	   seguridad          tutorias    false    235            -           0    0    COLUMN auditoria.user_bd    COMMENT     �   COMMENT ON COLUMN seguridad.auditoria.user_bd IS 'Campo que almacena el user que se autentico en el motor para generar el cmabio';
       	   seguridad          tutorias    false    235            .           0    0    COLUMN auditoria.data    COMMENT     e   COMMENT ON COLUMN seguridad.auditoria.data IS 'campo que almacena la modificaicón que se realizó';
       	   seguridad          tutorias    false    235            /           0    0    COLUMN auditoria.pk    COMMENT     X   COMMENT ON COLUMN seguridad.auditoria.pk IS 'Campo que identifica el id del registro.';
       	   seguridad          tutorias    false    235            �            1259    20432    auditoria_id_seq    SEQUENCE     |   CREATE SEQUENCE seguridad.auditoria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE seguridad.auditoria_id_seq;
    	   seguridad          tutorias    false    15    235            0           0    0    auditoria_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE seguridad.auditoria_id_seq OWNED BY seguridad.auditoria.id;
       	   seguridad          tutorias    false    236            �            1259    20434    autentication    TABLE     �   CREATE TABLE seguridad.autentication (
    id integer NOT NULL,
    nombre_de_usuario text NOT NULL,
    ip text,
    mac text,
    fecha_inicio timestamp without time zone,
    fecha_fin timestamp without time zone,
    session text
);
 $   DROP TABLE seguridad.autentication;
    	   seguridad            tutorias    false    15            �            1259    20440    autentication_id_seq    SEQUENCE     �   CREATE SEQUENCE seguridad.autentication_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE seguridad.autentication_id_seq;
    	   seguridad          tutorias    false    15    237            1           0    0    autentication_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE seguridad.autentication_id_seq OWNED BY seguridad.autentication.id;
       	   seguridad          tutorias    false    238            �            1259    20442    function_db_view    VIEW     �  CREATE VIEW seguridad.function_db_view AS
 SELECT pp.proname AS b_function,
    oidvectortypes(pp.proargtypes) AS b_type_parameters
   FROM (pg_proc pp
     JOIN pg_namespace pn ON ((pn.oid = pp.pronamespace)))
  WHERE ((pn.nspname)::text <> ALL (ARRAY[('pg_catalog'::character varying)::text, ('information_schema'::character varying)::text, ('admin_control'::character varying)::text, ('vial'::character varying)::text]));
 &   DROP VIEW seguridad.function_db_view;
    	   seguridad          tutorias    false    15            �            1259    20447    sugerencias_id_seq    SEQUENCE     �   CREATE SEQUENCE sugerencias.sugerencias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE sugerencias.sugerencias_id_seq;
       sugerencias          tutorias    false    217    16            2           0    0    sugerencias_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE sugerencias.sugerencias_id_seq OWNED BY sugerencias.sugerencias.id;
          sugerencias          tutorias    false    240            �            1259    20449    temas_id_seq    SEQUENCE     �   CREATE SEQUENCE temas.temas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE temas.temas_id_seq;
       temas          tutorias    false    218    17            3           0    0    temas_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE temas.temas_id_seq OWNED BY temas.temas.id;
          temas          tutorias    false    241            �            1259    20451    estados_usuario    TABLE     D   CREATE TABLE usuarios.estados_usuario (
    estado text NOT NULL
);
 %   DROP TABLE usuarios.estados_usuario;
       usuarios            tutorias    false    18            �            1259    20457    roles    TABLE     7   CREATE TABLE usuarios.roles (
    rol text NOT NULL
);
    DROP TABLE usuarios.roles;
       usuarios            tutorias    false    18                       2604    20463    comentarios id    DEFAULT     z   ALTER TABLE ONLY comentarios.comentarios ALTER COLUMN id SET DEFAULT nextval('comentarios.comentarios_id_seq'::regclass);
 B   ALTER TABLE comentarios.comentarios ALTER COLUMN id DROP DEFAULT;
       comentarios          tutorias    false    220    207                       2604    20464 	   cursos id    DEFAULT     f   ALTER TABLE ONLY cursos.cursos ALTER COLUMN id SET DEFAULT nextval('cursos.cursos_id_seq'::regclass);
 8   ALTER TABLE cursos.cursos ALTER COLUMN id DROP DEFAULT;
       cursos          tutorias    false    222    208                       2604    20465    inscripciones_cursos id    DEFAULT     �   ALTER TABLE ONLY cursos.inscripciones_cursos ALTER COLUMN id SET DEFAULT nextval('cursos.inscripciones_cursos_id_seq'::regclass);
 F   ALTER TABLE cursos.inscripciones_cursos ALTER COLUMN id DROP DEFAULT;
       cursos          tutorias    false    223    210            	           2604    20466    ejecucion_examen id    DEFAULT     ~   ALTER TABLE ONLY examenes.ejecucion_examen ALTER COLUMN id SET DEFAULT nextval('examenes.ejecucion_examen_id_seq'::regclass);
 D   ALTER TABLE examenes.ejecucion_examen ALTER COLUMN id DROP DEFAULT;
       examenes          tutorias    false    224    211            
           2604    20467    examenes id    DEFAULT     n   ALTER TABLE ONLY examenes.examenes ALTER COLUMN id SET DEFAULT nextval('examenes.examenes_id_seq'::regclass);
 <   ALTER TABLE examenes.examenes ALTER COLUMN id DROP DEFAULT;
       examenes          tutorias    false    225    212                       2604    20468    preguntas id    DEFAULT     p   ALTER TABLE ONLY examenes.preguntas ALTER COLUMN id SET DEFAULT nextval('examenes.preguntas_id_seq'::regclass);
 =   ALTER TABLE examenes.preguntas ALTER COLUMN id DROP DEFAULT;
       examenes          tutorias    false    226    213                       2604    20469    respuestas id    DEFAULT     r   ALTER TABLE ONLY examenes.respuestas ALTER COLUMN id SET DEFAULT nextval('examenes.respuestas_id_seq'::regclass);
 >   ALTER TABLE examenes.respuestas ALTER COLUMN id DROP DEFAULT;
       examenes          tutorias    false    227    214                       2604    20470    mensajes id    DEFAULT     n   ALTER TABLE ONLY mensajes.mensajes ALTER COLUMN id SET DEFAULT nextval('mensajes.mensajes_id_seq'::regclass);
 <   ALTER TABLE mensajes.mensajes ALTER COLUMN id DROP DEFAULT;
       mensajes          tutorias    false    229    215                       2604    20471    notificaciones id    DEFAULT     �   ALTER TABLE ONLY notificaciones.notificaciones ALTER COLUMN id SET DEFAULT nextval('notificaciones.notificaciones_id_seq'::regclass);
 H   ALTER TABLE notificaciones.notificaciones ALTER COLUMN id DROP DEFAULT;
       notificaciones          tutorias    false    231    230                       2604    20472    puntuaciones id    DEFAULT     ~   ALTER TABLE ONLY puntuaciones.puntuaciones ALTER COLUMN id SET DEFAULT nextval('puntuaciones.puntuaciones_id_seq'::regclass);
 D   ALTER TABLE puntuaciones.puntuaciones ALTER COLUMN id DROP DEFAULT;
       puntuaciones          tutorias    false    232    216                       2604    20473    reportes id    DEFAULT     n   ALTER TABLE ONLY reportes.reportes ALTER COLUMN id SET DEFAULT nextval('reportes.reportes_id_seq'::regclass);
 <   ALTER TABLE reportes.reportes ALTER COLUMN id DROP DEFAULT;
       reportes          tutorias    false    234    233                       2604    20474    auditoria id    DEFAULT     r   ALTER TABLE ONLY seguridad.auditoria ALTER COLUMN id SET DEFAULT nextval('seguridad.auditoria_id_seq'::regclass);
 >   ALTER TABLE seguridad.auditoria ALTER COLUMN id DROP DEFAULT;
    	   seguridad          tutorias    false    236    235                       2604    20475    autentication id    DEFAULT     z   ALTER TABLE ONLY seguridad.autentication ALTER COLUMN id SET DEFAULT nextval('seguridad.autentication_id_seq'::regclass);
 B   ALTER TABLE seguridad.autentication ALTER COLUMN id DROP DEFAULT;
    	   seguridad          tutorias    false    238    237                       2604    20476    sugerencias id    DEFAULT     z   ALTER TABLE ONLY sugerencias.sugerencias ALTER COLUMN id SET DEFAULT nextval('sugerencias.sugerencias_id_seq'::regclass);
 B   ALTER TABLE sugerencias.sugerencias ALTER COLUMN id DROP DEFAULT;
       sugerencias          tutorias    false    240    217                       2604    20477    temas id    DEFAULT     b   ALTER TABLE ONLY temas.temas ALTER COLUMN id SET DEFAULT nextval('temas.temas_id_seq'::regclass);
 6   ALTER TABLE temas.temas ALTER COLUMN id DROP DEFAULT;
       temas          tutorias    false    241    218            �          0    20285    comentarios 
   TABLE DATA           �   COPY comentarios.comentarios (id, fk_nombre_de_usuario_emisor, fk_id_curso, fk_id_tema, fk_id_comentario, comentario, fecha_envio, imagenes) FROM stdin;
    comentarios          tutorias    false    207   ^�      �          0    20375    areas 
   TABLE DATA           ,   COPY cursos.areas (area, icono) FROM stdin;
    cursos          tutorias    false    221   {�      �          0    20292    cursos 
   TABLE DATA           �   COPY cursos.cursos (id, fk_creador, fk_area, fk_estado, nombre, fecha_de_creacion, fecha_de_inicio, codigo_inscripcion, puntuacion, descripcion) FROM stdin;
    cursos          tutorias    false    208   ��      �          0    20299    estados_curso 
   TABLE DATA           /   COPY cursos.estados_curso (estado) FROM stdin;
    cursos          tutorias    false    209   ��      �          0    20306    inscripciones_cursos 
   TABLE DATA           k   COPY cursos.inscripciones_cursos (id, fk_nombre_de_usuario, fk_id_curso, fecha_de_inscripcion) FROM stdin;
    cursos          tutorias    false    210   �      �          0    20313    ejecucion_examen 
   TABLE DATA           �   COPY examenes.ejecucion_examen (id, fk_nombre_de_usuario, fk_id_examen, fecha_de_ejecucion, calificacion, respuestas) FROM stdin;
    examenes          tutorias    false    211   p�      �          0    20320    examenes 
   TABLE DATA           ?   COPY examenes.examenes (id, fk_id_tema, fecha_fin) FROM stdin;
    examenes          tutorias    false    212   c�      �          0    20324 	   preguntas 
   TABLE DATA           _   COPY examenes.preguntas (id, fk_id_examen, fk_tipo_pregunta, pregunta, porcentaje) FROM stdin;
    examenes          tutorias    false    213   ��      �          0    20331 
   respuestas 
   TABLE DATA           N   COPY examenes.respuestas (id, fk_id_preguntas, respuesta, estado) FROM stdin;
    examenes          tutorias    false    214   s�                0    20394    tipos_pregunta 
   TABLE DATA           0   COPY examenes.tipos_pregunta (tipo) FROM stdin;
    examenes          tutorias    false    228   �      �          0    20338    mensajes 
   TABLE DATA           �   COPY mensajes.mensajes (id, fk_nombre_de_usuario_emisor, fk_nombre_de_usuario_receptor, contenido, imagenes, fecha, id_curso) FROM stdin;
    mensajes          tutorias    false    215   l�                0    20402    notificaciones 
   TABLE DATA           b   COPY notificaciones.notificaciones (id, mensaje, estado, fk_nombre_de_usuario, fecha) FROM stdin;
    notificaciones          tutorias    false    230   ��      �          0    20345    puntuaciones 
   TABLE DATA           N   COPY puntuaciones.puntuaciones (id, emisor, receptor, puntuacion) FROM stdin;
    puntuaciones          tutorias    false    216   ��                0    23084    motivos 
   TABLE DATA           [   COPY reportes.motivos (motivo, dias_para_reportar, puntuacion_para_el_bloqueo) FROM stdin;
    reportes          tutorias    false    244                    0    20418    reportes 
   TABLE DATA           �   COPY reportes.reportes (id, fk_nombre_de_usuario_denunciante, fk_nombre_de_usuario_denunciado, fk_motivo, descripcion, estado, fk_id_comentario, fk_id_mensaje, fecha) FROM stdin;
    reportes          tutorias    false    233   �       
          0    20426 	   auditoria 
   TABLE DATA           d   COPY seguridad.auditoria (id, fecha, accion, schema, tabla, session, user_bd, data, pk) FROM stdin;
 	   seguridad          tutorias    false    235   �                 0    20434    autentication 
   TABLE DATA           l   COPY seguridad.autentication (id, nombre_de_usuario, ip, mac, fecha_inicio, fecha_fin, session) FROM stdin;
 	   seguridad          tutorias    false    237   �7      �          0    20352    sugerencias 
   TABLE DATA           w   COPY sugerencias.sugerencias (id, fk_nombre_de_usuario_emisor, contenido, estado, imagenes, titulo, fecha) FROM stdin;
    sugerencias          tutorias    false    217   "R      �          0    20359    temas 
   TABLE DATA           N   COPY temas.temas (id, fk_id_curso, titulo, informacion, imagenes) FROM stdin;
    temas          tutorias    false    218   uT                0    20451    estados_usuario 
   TABLE DATA           3   COPY usuarios.estados_usuario (estado) FROM stdin;
    usuarios          tutorias    false    242   7V                0    20457    roles 
   TABLE DATA           &   COPY usuarios.roles (rol) FROM stdin;
    usuarios          tutorias    false    243   �V      �          0    20366    usuarios 
   TABLE DATA           >  COPY usuarios.usuarios (nombre_de_usuario, fk_rol, fk_estado, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, correo_institucional, pass, fecha_desbloqueo, puntuacion, token, imagen_perfil, fecha_creacion, ultima_modificacion, vencimiento_token, session, descripcion, puntuacion_bloqueo) FROM stdin;
    usuarios          tutorias    false    219   �V      4           0    0    comentarios_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('comentarios.comentarios_id_seq', 9, true);
          comentarios          tutorias    false    220            5           0    0    cursos_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('cursos.cursos_id_seq', 21, true);
          cursos          tutorias    false    222            6           0    0    inscripciones_cursos_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('cursos.inscripciones_cursos_id_seq', 8, true);
          cursos          tutorias    false    223            7           0    0    ejecucion_examen_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('examenes.ejecucion_examen_id_seq', 5, true);
          examenes          tutorias    false    224            8           0    0    examenes_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('examenes.examenes_id_seq', 1, true);
          examenes          tutorias    false    225            9           0    0    preguntas_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('examenes.preguntas_id_seq', 30, true);
          examenes          tutorias    false    226            :           0    0    respuestas_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('examenes.respuestas_id_seq', 32, true);
          examenes          tutorias    false    227            ;           0    0    mensajes_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('mensajes.mensajes_id_seq', 19, true);
          mensajes          tutorias    false    229            <           0    0    notificaciones_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('notificaciones.notificaciones_id_seq', 1, false);
          notificaciones          tutorias    false    231            =           0    0    puntuaciones_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('puntuaciones.puntuaciones_id_seq', 8, true);
          puntuaciones          tutorias    false    232            >           0    0    reportes_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('reportes.reportes_id_seq', 5, true);
          reportes          tutorias    false    234            ?           0    0    auditoria_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('seguridad.auditoria_id_seq', 338, true);
       	   seguridad          tutorias    false    236            @           0    0    autentication_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('seguridad.autentication_id_seq', 447, true);
       	   seguridad          tutorias    false    238            A           0    0    sugerencias_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('sugerencias.sugerencias_id_seq', 38, true);
          sugerencias          tutorias    false    240            B           0    0    temas_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('temas.temas_id_seq', 8, true);
          temas          tutorias    false    241                       2606    20481    comentarios comentarios_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT comentarios_pkey PRIMARY KEY (id);
 K   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT comentarios_pkey;
       comentarios            tutorias    false    207            2           2606    20483    areas areas_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY cursos.areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (area);
 :   ALTER TABLE ONLY cursos.areas DROP CONSTRAINT areas_pkey;
       cursos            tutorias    false    221                       2606    20485    cursos cursos_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT cursos_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT cursos_pkey;
       cursos            tutorias    false    208                       2606    20487    estados_curso estado_curso_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY cursos.estados_curso
    ADD CONSTRAINT estado_curso_pkey PRIMARY KEY (estado);
 I   ALTER TABLE ONLY cursos.estados_curso DROP CONSTRAINT estado_curso_pkey;
       cursos            tutorias    false    209                       2606    20489 .   inscripciones_cursos inscripciones_cursos_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY cursos.inscripciones_cursos
    ADD CONSTRAINT inscripciones_cursos_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY cursos.inscripciones_cursos DROP CONSTRAINT inscripciones_cursos_pkey;
       cursos            tutorias    false    210                       2606    20491 &   ejecucion_examen ejecucion_examen_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY examenes.ejecucion_examen
    ADD CONSTRAINT ejecucion_examen_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY examenes.ejecucion_examen DROP CONSTRAINT ejecucion_examen_pkey;
       examenes            tutorias    false    211                        2606    20493    examenes examenes_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY examenes.examenes
    ADD CONSTRAINT examenes_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY examenes.examenes DROP CONSTRAINT examenes_pkey;
       examenes            tutorias    false    212            "           2606    20495    preguntas preguntas_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY examenes.preguntas
    ADD CONSTRAINT preguntas_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY examenes.preguntas DROP CONSTRAINT preguntas_pkey;
       examenes            tutorias    false    213            $           2606    20497    respuestas respuestas_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY examenes.respuestas
    ADD CONSTRAINT respuestas_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY examenes.respuestas DROP CONSTRAINT respuestas_pkey;
       examenes            tutorias    false    214            4           2606    20499 "   tipos_pregunta tipos_pregunta_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY examenes.tipos_pregunta
    ADD CONSTRAINT tipos_pregunta_pkey PRIMARY KEY (tipo);
 N   ALTER TABLE ONLY examenes.tipos_pregunta DROP CONSTRAINT tipos_pregunta_pkey;
       examenes            tutorias    false    228            &           2606    20501    mensajes mensajes_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY mensajes.mensajes
    ADD CONSTRAINT mensajes_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY mensajes.mensajes DROP CONSTRAINT mensajes_pkey;
       mensajes            tutorias    false    215            6           2606    20503 "   notificaciones notificaciones_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY notificaciones.notificaciones
    ADD CONSTRAINT notificaciones_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY notificaciones.notificaciones DROP CONSTRAINT notificaciones_pkey;
       notificaciones            tutorias    false    230            (           2606    20505    puntuaciones puntuaciones_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY puntuaciones.puntuaciones
    ADD CONSTRAINT puntuaciones_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY puntuaciones.puntuaciones DROP CONSTRAINT puntuaciones_pkey;
       puntuaciones            tutorias    false    216            B           2606    23091    motivos motivos_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY reportes.motivos
    ADD CONSTRAINT motivos_pkey PRIMARY KEY (motivo);
 @   ALTER TABLE ONLY reportes.motivos DROP CONSTRAINT motivos_pkey;
       reportes            tutorias    false    244            8           2606    20509    reportes reportes_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT reportes_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT reportes_pkey;
       reportes            tutorias    false    233            <           2606    20511     autentication autentication_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY seguridad.autentication
    ADD CONSTRAINT autentication_pkey PRIMARY KEY (id);
 M   ALTER TABLE ONLY seguridad.autentication DROP CONSTRAINT autentication_pkey;
    	   seguridad            tutorias    false    237            :           2606    20513     auditoria pk_seguridad_auditoria 
   CONSTRAINT     a   ALTER TABLE ONLY seguridad.auditoria
    ADD CONSTRAINT pk_seguridad_auditoria PRIMARY KEY (id);
 M   ALTER TABLE ONLY seguridad.auditoria DROP CONSTRAINT pk_seguridad_auditoria;
    	   seguridad            tutorias    false    235            *           2606    20516    sugerencias sugerencias_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY sugerencias.sugerencias
    ADD CONSTRAINT sugerencias_pkey PRIMARY KEY (id);
 K   ALTER TABLE ONLY sugerencias.sugerencias DROP CONSTRAINT sugerencias_pkey;
       sugerencias            tutorias    false    217            ,           2606    20518    temas temas_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY temas.temas
    ADD CONSTRAINT temas_pkey PRIMARY KEY (id);
 9   ALTER TABLE ONLY temas.temas DROP CONSTRAINT temas_pkey;
       temas            tutorias    false    218            >           2606    20520 $   estados_usuario estados_usuario_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY usuarios.estados_usuario
    ADD CONSTRAINT estados_usuario_pkey PRIMARY KEY (estado);
 P   ALTER TABLE ONLY usuarios.estados_usuario DROP CONSTRAINT estados_usuario_pkey;
       usuarios            tutorias    false    242            @           2606    20522    roles roles_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY usuarios.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (rol);
 <   ALTER TABLE ONLY usuarios.roles DROP CONSTRAINT roles_pkey;
       usuarios            tutorias    false    243            .           2606    20524 $   usuarios unique_correo_institucional 
   CONSTRAINT     q   ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT unique_correo_institucional UNIQUE (correo_institucional);
 P   ALTER TABLE ONLY usuarios.usuarios DROP CONSTRAINT unique_correo_institucional;
       usuarios            tutorias    false    219            0           2606    20526    usuarios usuarios_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (nombre_de_usuario);
 B   ALTER TABLE ONLY usuarios.usuarios DROP CONSTRAINT usuarios_pkey;
       usuarios            tutorias    false    219            `           2620    20527 &   comentarios tg_comentarios_comentarios    TRIGGER     �   CREATE TRIGGER tg_comentarios_comentarios AFTER INSERT OR DELETE OR UPDATE ON comentarios.comentarios FOR EACH ROW EXECUTE PROCEDURE seguridad.f_log_auditoria();
 D   DROP TRIGGER tg_comentarios_comentarios ON comentarios.comentarios;
       comentarios          tutorias    false    257    207            m           2620    20528    areas tg_cursos_areas    TRIGGER     �   CREATE TRIGGER tg_cursos_areas AFTER INSERT OR DELETE OR UPDATE ON cursos.areas FOR EACH ROW EXECUTE PROCEDURE seguridad.f_log_auditoria();
 .   DROP TRIGGER tg_cursos_areas ON cursos.areas;
       cursos          tutorias    false    221    257            a           2620    20529    cursos tg_cursos_cursos    TRIGGER     �   CREATE TRIGGER tg_cursos_cursos AFTER INSERT OR DELETE OR UPDATE ON cursos.cursos FOR EACH ROW EXECUTE PROCEDURE seguridad.f_log_auditoria();
 0   DROP TRIGGER tg_cursos_cursos ON cursos.cursos;
       cursos          tutorias    false    257    208            b           2620    20530 %   estados_curso tg_cursos_estados_curso    TRIGGER     �   CREATE TRIGGER tg_cursos_estados_curso AFTER INSERT OR DELETE OR UPDATE ON cursos.estados_curso FOR EACH ROW EXECUTE PROCEDURE seguridad.f_log_auditoria();
 >   DROP TRIGGER tg_cursos_estados_curso ON cursos.estados_curso;
       cursos          tutorias    false    209    257            c           2620    20531 3   inscripciones_cursos tg_cursos_inscripciones_cursos    TRIGGER     �   CREATE TRIGGER tg_cursos_inscripciones_cursos AFTER INSERT OR DELETE OR UPDATE ON cursos.inscripciones_cursos FOR EACH ROW EXECUTE PROCEDURE seguridad.f_log_auditoria();
 L   DROP TRIGGER tg_cursos_inscripciones_cursos ON cursos.inscripciones_cursos;
       cursos          tutorias    false    210    257            d           2620    20532 -   ejecucion_examen tg_examenes_ejecucion_examen    TRIGGER     �   CREATE TRIGGER tg_examenes_ejecucion_examen AFTER INSERT OR DELETE OR UPDATE ON examenes.ejecucion_examen FOR EACH ROW EXECUTE PROCEDURE seguridad.f_log_auditoria();
 H   DROP TRIGGER tg_examenes_ejecucion_examen ON examenes.ejecucion_examen;
       examenes          tutorias    false    211    257            e           2620    20533    examenes tg_examenes_examenes    TRIGGER     �   CREATE TRIGGER tg_examenes_examenes AFTER INSERT OR DELETE OR UPDATE ON examenes.examenes FOR EACH ROW EXECUTE PROCEDURE seguridad.f_log_auditoria();
 8   DROP TRIGGER tg_examenes_examenes ON examenes.examenes;
       examenes          tutorias    false    212    257            f           2620    20534    preguntas tg_examenes_preguntas    TRIGGER     �   CREATE TRIGGER tg_examenes_preguntas AFTER INSERT OR DELETE OR UPDATE ON examenes.preguntas FOR EACH ROW EXECUTE PROCEDURE seguridad.f_log_auditoria();
 :   DROP TRIGGER tg_examenes_preguntas ON examenes.preguntas;
       examenes          tutorias    false    257    213            g           2620    20535 !   respuestas tg_examenes_respuestas    TRIGGER     �   CREATE TRIGGER tg_examenes_respuestas AFTER INSERT OR DELETE OR UPDATE ON examenes.respuestas FOR EACH ROW EXECUTE PROCEDURE seguridad.f_log_auditoria();
 <   DROP TRIGGER tg_examenes_respuestas ON examenes.respuestas;
       examenes          tutorias    false    257    214            n           2620    20536 )   tipos_pregunta tg_examenes_tipos_pregunta    TRIGGER     �   CREATE TRIGGER tg_examenes_tipos_pregunta AFTER INSERT OR DELETE OR UPDATE ON examenes.tipos_pregunta FOR EACH ROW EXECUTE PROCEDURE seguridad.f_log_auditoria();
 D   DROP TRIGGER tg_examenes_tipos_pregunta ON examenes.tipos_pregunta;
       examenes          tutorias    false    257    228            h           2620    20537    mensajes tg_mensajes_mensajes    TRIGGER     �   CREATE TRIGGER tg_mensajes_mensajes AFTER INSERT OR DELETE OR UPDATE ON mensajes.mensajes FOR EACH ROW EXECUTE PROCEDURE seguridad.f_log_auditoria();
 8   DROP TRIGGER tg_mensajes_mensajes ON mensajes.mensajes;
       mensajes          tutorias    false    257    215            o           2620    20538 /   notificaciones tg_notificaciones_notificaciones    TRIGGER     �   CREATE TRIGGER tg_notificaciones_notificaciones AFTER INSERT OR DELETE OR UPDATE ON notificaciones.notificaciones FOR EACH ROW EXECUTE PROCEDURE seguridad.f_log_auditoria();
 P   DROP TRIGGER tg_notificaciones_notificaciones ON notificaciones.notificaciones;
       notificaciones          tutorias    false    257    230            i           2620    20539 )   puntuaciones tg_puntuaciones_puntuaciones    TRIGGER     �   CREATE TRIGGER tg_puntuaciones_puntuaciones AFTER INSERT OR DELETE OR UPDATE ON puntuaciones.puntuaciones FOR EACH ROW EXECUTE PROCEDURE seguridad.f_log_auditoria();
 H   DROP TRIGGER tg_puntuaciones_puntuaciones ON puntuaciones.puntuaciones;
       puntuaciones          tutorias    false    216    257            s           2620    23092    motivos tg_reportes_motivos    TRIGGER     �   CREATE TRIGGER tg_reportes_motivos AFTER INSERT OR DELETE OR UPDATE ON reportes.motivos FOR EACH ROW EXECUTE PROCEDURE seguridad.f_log_auditoria();
 6   DROP TRIGGER tg_reportes_motivos ON reportes.motivos;
       reportes          tutorias    false    244    257            p           2620    20541    reportes tg_reportes_reportes    TRIGGER     �   CREATE TRIGGER tg_reportes_reportes AFTER INSERT OR DELETE OR UPDATE ON reportes.reportes FOR EACH ROW EXECUTE PROCEDURE seguridad.f_log_auditoria();
 8   DROP TRIGGER tg_reportes_reportes ON reportes.reportes;
       reportes          tutorias    false    233    257            j           2620    20542 &   sugerencias tg_sugerencias_sugerencias    TRIGGER     �   CREATE TRIGGER tg_sugerencias_sugerencias AFTER INSERT OR DELETE OR UPDATE ON sugerencias.sugerencias FOR EACH ROW EXECUTE PROCEDURE seguridad.f_log_auditoria();
 D   DROP TRIGGER tg_sugerencias_sugerencias ON sugerencias.sugerencias;
       sugerencias          tutorias    false    257    217            k           2620    20543    temas tg_temas_temas    TRIGGER     �   CREATE TRIGGER tg_temas_temas AFTER INSERT OR DELETE OR UPDATE ON temas.temas FOR EACH ROW EXECUTE PROCEDURE seguridad.f_log_auditoria();
 ,   DROP TRIGGER tg_temas_temas ON temas.temas;
       temas          tutorias    false    257    218            q           2620    20544 +   estados_usuario tg_usuarios_estados_usuario    TRIGGER     �   CREATE TRIGGER tg_usuarios_estados_usuario AFTER INSERT OR DELETE OR UPDATE ON usuarios.estados_usuario FOR EACH ROW EXECUTE PROCEDURE seguridad.f_log_auditoria();
 F   DROP TRIGGER tg_usuarios_estados_usuario ON usuarios.estados_usuario;
       usuarios          tutorias    false    242    257            r           2620    20545    roles tg_usuarios_roles    TRIGGER     �   CREATE TRIGGER tg_usuarios_roles AFTER INSERT OR DELETE OR UPDATE ON usuarios.roles FOR EACH ROW EXECUTE PROCEDURE seguridad.f_log_auditoria();
 2   DROP TRIGGER tg_usuarios_roles ON usuarios.roles;
       usuarios          tutorias    false    257    243            l           2620    20546    usuarios tg_usuarios_usuarios    TRIGGER     �   CREATE TRIGGER tg_usuarios_usuarios AFTER INSERT OR DELETE OR UPDATE ON usuarios.usuarios FOR EACH ROW EXECUTE PROCEDURE seguridad.f_log_auditoria();
 8   DROP TRIGGER tg_usuarios_usuarios ON usuarios.usuarios;
       usuarios          tutorias    false    219    257            C           2606    20547    comentarios fkcomentario107416    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario107416 FOREIGN KEY (fk_nombre_de_usuario_emisor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario107416;
       comentarios          tutorias    false    3888    207    219            D           2606    20552    comentarios fkcomentario298131    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario298131 FOREIGN KEY (fk_id_tema) REFERENCES temas.temas(id);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario298131;
       comentarios          tutorias    false    3884    207    218            E           2606    20557    comentarios fkcomentario605734    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario605734 FOREIGN KEY (fk_id_curso) REFERENCES cursos.cursos(id);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario605734;
       comentarios          tutorias    false    3864    208    207            F           2606    20562    comentarios fkcomentario954929    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario954929 FOREIGN KEY (fk_id_comentario) REFERENCES comentarios.comentarios(id);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario954929;
       comentarios          tutorias    false    207    3862    207            G           2606    20567    cursos fkcursos287281    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT fkcursos287281 FOREIGN KEY (fk_estado) REFERENCES cursos.estados_curso(estado);
 ?   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT fkcursos287281;
       cursos          tutorias    false    3866    209    208            H           2606    20572    cursos fkcursos395447    FK CONSTRAINT     v   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT fkcursos395447 FOREIGN KEY (fk_area) REFERENCES cursos.areas(area);
 ?   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT fkcursos395447;
       cursos          tutorias    false    208    221    3890            I           2606    20577    cursos fkcursos742472    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT fkcursos742472 FOREIGN KEY (fk_creador) REFERENCES usuarios.usuarios(nombre_de_usuario);
 ?   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT fkcursos742472;
       cursos          tutorias    false    219    3888    208            J           2606    20582 &   inscripciones_cursos fkinscripcio18320    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.inscripciones_cursos
    ADD CONSTRAINT fkinscripcio18320 FOREIGN KEY (fk_id_curso) REFERENCES cursos.cursos(id);
 P   ALTER TABLE ONLY cursos.inscripciones_cursos DROP CONSTRAINT fkinscripcio18320;
       cursos          tutorias    false    3864    210    208            K           2606    20587 '   inscripciones_cursos fkinscripcio893145    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.inscripciones_cursos
    ADD CONSTRAINT fkinscripcio893145 FOREIGN KEY (fk_nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 Q   ALTER TABLE ONLY cursos.inscripciones_cursos DROP CONSTRAINT fkinscripcio893145;
       cursos          tutorias    false    219    210    3888            L           2606    20592 #   ejecucion_examen fkejecucion_455924    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.ejecucion_examen
    ADD CONSTRAINT fkejecucion_455924 FOREIGN KEY (fk_nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 O   ALTER TABLE ONLY examenes.ejecucion_examen DROP CONSTRAINT fkejecucion_455924;
       examenes          tutorias    false    211    219    3888            M           2606    20597 #   ejecucion_examen fkejecucion_678612    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.ejecucion_examen
    ADD CONSTRAINT fkejecucion_678612 FOREIGN KEY (fk_id_examen) REFERENCES examenes.examenes(id);
 O   ALTER TABLE ONLY examenes.ejecucion_examen DROP CONSTRAINT fkejecucion_678612;
       examenes          tutorias    false    212    211    3872            N           2606    20602    examenes fkexamenes946263    FK CONSTRAINT     |   ALTER TABLE ONLY examenes.examenes
    ADD CONSTRAINT fkexamenes946263 FOREIGN KEY (fk_id_tema) REFERENCES temas.temas(id);
 E   ALTER TABLE ONLY examenes.examenes DROP CONSTRAINT fkexamenes946263;
       examenes          tutorias    false    212    218    3884            O           2606    20607    preguntas fkpreguntas592721    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.preguntas
    ADD CONSTRAINT fkpreguntas592721 FOREIGN KEY (fk_id_examen) REFERENCES examenes.examenes(id);
 G   ALTER TABLE ONLY examenes.preguntas DROP CONSTRAINT fkpreguntas592721;
       examenes          tutorias    false    213    212    3872            P           2606    20612    preguntas fkpreguntas985578    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.preguntas
    ADD CONSTRAINT fkpreguntas985578 FOREIGN KEY (fk_tipo_pregunta) REFERENCES examenes.tipos_pregunta(tipo);
 G   ALTER TABLE ONLY examenes.preguntas DROP CONSTRAINT fkpreguntas985578;
       examenes          tutorias    false    213    228    3892            Q           2606    20617    respuestas fkrespuestas516290    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.respuestas
    ADD CONSTRAINT fkrespuestas516290 FOREIGN KEY (fk_id_preguntas) REFERENCES examenes.preguntas(id);
 I   ALTER TABLE ONLY examenes.respuestas DROP CONSTRAINT fkrespuestas516290;
       examenes          tutorias    false    213    214    3874            R           2606    20622    mensajes fkmensajes16841    FK CONSTRAINT     �   ALTER TABLE ONLY mensajes.mensajes
    ADD CONSTRAINT fkmensajes16841 FOREIGN KEY (fk_nombre_de_usuario_receptor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 D   ALTER TABLE ONLY mensajes.mensajes DROP CONSTRAINT fkmensajes16841;
       mensajes          tutorias    false    219    215    3888            S           2606    20627    mensajes fkmensajes33437    FK CONSTRAINT     �   ALTER TABLE ONLY mensajes.mensajes
    ADD CONSTRAINT fkmensajes33437 FOREIGN KEY (fk_nombre_de_usuario_emisor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 D   ALTER TABLE ONLY mensajes.mensajes DROP CONSTRAINT fkmensajes33437;
       mensajes          tutorias    false    215    219    3888            Z           2606    20632 !   notificaciones fknotificaci697604    FK CONSTRAINT     �   ALTER TABLE ONLY notificaciones.notificaciones
    ADD CONSTRAINT fknotificaci697604 FOREIGN KEY (fk_nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 S   ALTER TABLE ONLY notificaciones.notificaciones DROP CONSTRAINT fknotificaci697604;
       notificaciones          tutorias    false    230    219    3888            T           2606    20637 %   puntuaciones puntuaciones_emisor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY puntuaciones.puntuaciones
    ADD CONSTRAINT puntuaciones_emisor_fkey FOREIGN KEY (emisor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 U   ALTER TABLE ONLY puntuaciones.puntuaciones DROP CONSTRAINT puntuaciones_emisor_fkey;
       puntuaciones          tutorias    false    219    216    3888            U           2606    20642 '   puntuaciones puntuaciones_receptor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY puntuaciones.puntuaciones
    ADD CONSTRAINT puntuaciones_receptor_fkey FOREIGN KEY (receptor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 W   ALTER TABLE ONLY puntuaciones.puntuaciones DROP CONSTRAINT puntuaciones_receptor_fkey;
       puntuaciones          tutorias    false    219    216    3888            [           2606    20652    reportes fkreportes50539    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT fkreportes50539 FOREIGN KEY (fk_nombre_de_usuario_denunciado) REFERENCES usuarios.usuarios(nombre_de_usuario);
 D   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT fkreportes50539;
       reportes          tutorias    false    219    233    3888            \           2606    20657    reportes fkreportes843275    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT fkreportes843275 FOREIGN KEY (fk_nombre_de_usuario_denunciante) REFERENCES usuarios.usuarios(nombre_de_usuario);
 E   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT fkreportes843275;
       reportes          tutorias    false    233    3888    219            ]           2606    20662 '   reportes reportes_fk_id_comentario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT reportes_fk_id_comentario_fkey FOREIGN KEY (fk_id_comentario) REFERENCES comentarios.comentarios(id);
 S   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT reportes_fk_id_comentario_fkey;
       reportes          tutorias    false    3862    207    233            ^           2606    20667 $   reportes reportes_fk_id_mensaje_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT reportes_fk_id_mensaje_fkey FOREIGN KEY (fk_id_mensaje) REFERENCES mensajes.mensajes(id);
 P   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT reportes_fk_id_mensaje_fkey;
       reportes          tutorias    false    233    215    3878            _           2606    20672 '   autentication fk_autentication_usuarios    FK CONSTRAINT     �   ALTER TABLE ONLY seguridad.autentication
    ADD CONSTRAINT fk_autentication_usuarios FOREIGN KEY (nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 T   ALTER TABLE ONLY seguridad.autentication DROP CONSTRAINT fk_autentication_usuarios;
    	   seguridad          tutorias    false    219    237    3888            V           2606    20677    sugerencias fksugerencia433827    FK CONSTRAINT     �   ALTER TABLE ONLY sugerencias.sugerencias
    ADD CONSTRAINT fksugerencia433827 FOREIGN KEY (fk_nombre_de_usuario_emisor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 M   ALTER TABLE ONLY sugerencias.sugerencias DROP CONSTRAINT fksugerencia433827;
       sugerencias          tutorias    false    217    3888    219            W           2606    20682    temas fktemas249223    FK CONSTRAINT     v   ALTER TABLE ONLY temas.temas
    ADD CONSTRAINT fktemas249223 FOREIGN KEY (fk_id_curso) REFERENCES cursos.cursos(id);
 <   ALTER TABLE ONLY temas.temas DROP CONSTRAINT fktemas249223;
       temas          tutorias    false    208    218    3864            X           2606    20687    usuarios fkusuarios355026    FK CONSTRAINT     |   ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT fkusuarios355026 FOREIGN KEY (fk_rol) REFERENCES usuarios.roles(rol);
 E   ALTER TABLE ONLY usuarios.usuarios DROP CONSTRAINT fkusuarios355026;
       usuarios          tutorias    false    219    243    3904            Y           2606    20692    usuarios fkusuarios94770    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT fkusuarios94770 FOREIGN KEY (fk_estado) REFERENCES usuarios.estados_usuario(estado);
 D   ALTER TABLE ONLY usuarios.usuarios DROP CONSTRAINT fkusuarios94770;
       usuarios          tutorias    false    3902    242    219            �      x������ � �      �   k   x�s�L�K�L,Vp:��839���N?(5���8�X�371=5/�H���/v,JM,�wFסW����T��Ztxm"A��B��d��a3TX�IQ>a`U`�1z\\\ ?�X�      �   �  x��SKn�0\?�Bu�Ԑԇ̶F۸A��Ac�P�-і�@����z
_,�%�n!5%po�}���(��,%��a�bT"��VO.��u�PL��?�-}�b� ��)"��$Uz}`�hi��G�LqC��#�|]WzO�ն�BG��b{|��\d��§J�iG��)ͣ��emّO�R
���c�p!�B#���6��0�I��R�ʵp�n���MeT����s�jn�&V�{����	����h/�^����-dw��r+,�@$:��p��Y��1������KD���ξ9�l6��4�bW�ID��e���3��֝nI�s:q`�"|m���QԻ��D��<p�p�d)p��p��!�����4ަl���*�ۗ��!��5���p0<Gg����φ#���I /��2�Q*Ls�x�����"��5�Ek6qk���g{��L���e2Hc��9���(����3~}o���}x�zo�B5      �      x�KL.�,��J͋O-.H-J����� ]@�      �   A   x�3�t+J�K�4�4202�50�56�2���L/M�150�K��Zp�#IX KX I"$,�b���� q�f      �   �   x����N�0@g�+�W����i�l���2��^e��IX?ֵ?F����,'�I�����6��	)�T��#r�U��A-W� d�#�Į����`������yǪ6��)`eYt}7�~zH����sSp��{�����I��F��6����C�����C��a����_�_�&4γg���IeǮ�D%�d��輞���:k��2[�|)>���X�}F)� _@��      �   )   x�3�4�4204�50�52�2� r�tLu��b���� d�|      �   �   x���;�0Dk�{��O���ڱ���v�}(�B$r1�DA9�y3��Ddb�w�چh�����&�آxܷ�����.���b��o�ɭR%�"'�GN�g*���U&�K�ب�š}��KeM��f��i��9Rz�ڶ��d/^�I�CV�aε�� Fƙ��=�sM0���tN|�<��a$�|�k�      �   �   x�32�42���KO��L-:�6Q!%U!8?��<�(�����$�X��{xaIfrb1gP�)��J�؀�Ȝ3,�(%$k�9�&e���̰ T��8� NP~V��gl�	��Z\P�Z\��`3B3����� -I/�         M   x��=�+�$� 'U!9?O����D�������D._�\8��1)3�H��d&g���($%gd��s��qqq ��%q      �   ?  x���]o�0��ɯ�M�����UI�m�7��T��#n�m���ô�L��>~���,E�N����ocI�
������k���H���8��E�e,.|=��߫�d��5�M[�uV5y*���}��s�ɭ�n�b�.��J���Ri�\bf���m�-�K@eRf�Q'�4	54yv%i����m�M�����|�z��CA�zU���S|�����g���4��7�M�N����u�p�mQ��ȿ\pG�U��kh�E����z��40P����	XgJPa�0��#v��u���s��?�d�CA��؝���7�z94u�~��V��MѦ�>��Sct���q	��L5�l��9k�2���Bj��':�+&؎�b'ክግ�©>��XA����^��0����p��#r��B�^χ���( 4��j��Ԋ���q.u\�9t��ā�Z�����p���s�Uo��t���8�*P�9Θ�� }�W��b��,���Ao��(G���1jNv�<���f��b��r'1�q��I�/��r�7��n���l6����3            x������ � �      �   1   x����M,.I-���L/M�150�4�2�t+J�K��N���4����� �z
�         \   x�s/�/N-�L,�4�4��OK�+N,VH�Q(-.M,���4�4�
p��4�4�r��+I��L�W�6��44�4kII-Rp/*-�	�r��qqq ���            x������ � �      
      x��}[wɑ�s���j���3v)#2#/�w�m�ܶ�*�=�����,
I� )�{����؇9�6���6 �B�P�� M]�)�����5#�(~!�/@��=%{
:��|���_���fz�'��t�ŷ�p5�^�M���xt�ӗ�7�����ɣ��<L���0y��G��7�r�CЙut(��2�sE*9/�@�"�J�L"Ϭ�>��i�Rb�x�r2>/�p>���i�NG���.o����k���
ӫ0�'y8������cq�����ٿ���.�/�?V�Ϋ?���.�����"���[�Q8��&�W�e6	�c?ZR>�3&�xm?����V�x��
����d�o��4=��&��S�}�����G��1����q+Kzz.���(\^�_V�y��3����A?ws~ʹ|y1�G�(��u6�Lx������&>��+S���MƋ�Y_�I擐�$����?�|�+��N��&����_?���O�q������&�.��G�^y�:��~���叶`���Vy}���^~�F�/?����7�}��ͬ�>�5�/�$ k�� ��l)�󭕄��lY����jk	w����1\�������}~7��{M�i!�N�VR���s�5^��
�r��"M��3��==����{��-Ԩ�����O�L�3��}�����p��p��<��.(������^�?������O��ݟ^��:;�(
t2(�p�Rv)��1�!_����)�b��l���yj�? ����B��u���)1�����M��b�����p�
��H�``o*򠈝�DYGr7�⮾�~�,�^O��ͯ��"��데.�� I�}�S@D[�\	)|!U�V�F˃L}&r��`�����WX�`*����Xo+�M�T�Dicv��&�.?�#�?`��`}I�ݺ<˃F�n`]����>�F�����'�����m}�r�y*s@���LM��<3�ҙ')�Vڦ2u�k/~�`�`~�OHB2�����m�h��6}k��둻p����·����{kO�N�:%J�0��o����ZQ�:�׾O.|Y$���h�أz���<'Q�60��Fg7ᜄx��g\{k���'�!O@�
m8km^Њl�A�AB�D�q���������������v2R��V��R,@�B�[/��BZ�f�pS/�SJe)���6lf9�Q��d��X�Z�P�����p�x��N�<,Ypjg������z���wʯ���@VDA©�	�b��Eca�B$'3�'��֨���dZ���>J��%X�f�3c��&��������|?t��~����;�j��B�[�������_晟�ik�Z�6�T���g��K:��#|���q�,3����Ț�f�������u�2G[�!�v��@��Y�U(
6��afă����h���!���5��f�eq���q�-��n��vK��-��k��w0`ځ�B�p~%7���c�8ZS~7Ah��Y�4��l��
������ϧ��(&o>>�⛿~Qc��!5hT���t�!攧�
 �6X�Tg�-<f�Y-,?hT��4w�ZY=�ݲ��� Zy�;��0���IM��cڷdv[av��� ��v��&~_��X�>��f!���VF�FQXS���݇uZK�p�������sǿ쎾�F����(�����4�$J!|�:�-D���T�k���HH֐�¥��o�_���~s$gZL�E>�;Frb���H�b/p?͋&��
�S��LbP���HN.��Gf���^��;��V���χ���mK��ȷp�1լ�>%�(��!)}�)n8P�F�3"�	�T��PwS
zi������1	^~����>��<6� ��3ߞl7��2��ň:�f�]㎹������t��W�O_�ˑ�ѐ�G�uf��SҼ���B�B�f����3i&�P*�Σ���<#��,�XG(�QA���&V	K�,�B�����\���rgE���+����S��%8���<t���l)�y?XJjcԝ��F�D����/oކ�^>�ϿS/
[	s=�</��/�T�u�����P#H�����&dd���0�hq�c��$f�ڂ<��~���@
uȠ�
[��	Lς�ŝ���^�����G �u,���|��/����T�8e�� eK�(����6���ZISdX8��SKi�5�p�Y /�e+�2J3�V�	��9zwѺ�F's~�䌰��ej��*{�TDB���=ƣG&@�C�k���M�ֲ0��u� � ����u#�g�RRyt�
R�W8oLl$�5`�JLQ�ʺ ��E!�J��Gj���ي��Դ���-6\����{>{��������B�|W�u*]"�O펭���MQ��3���@���[Y�"��L0�c!�vp�3t,,�?X���#[ab-�C�RT��j�hC�uM������(�f	�H�Ω�OV*�M�3�u��I��J/=m)b�	R�1+eEC�}���\�a]��$�(i�~��R�@�C.3���.�4.yNV1cra#��&�\����>5��F���0x�3�+��� �*5\ȪG�~�h�SRb-����b��xV�Je��u�0�u�(����j����P�[!��Y����Hr*�hG��Cz�����ia�b_�@�Cb�j�]���bwO@o������ki#�>U$B��u`Ď�,���ۤ.7d�cG�R����<oB!�����B)�<ˀ+$(��"Ě������ي�v��C�������i!�pF}�L� �G�-ea8�7� �J�!��P����I�gF{�1ϔ4J�@��r�
��2�.ui���IX�+� ����l%�w��yh���v1����V�p�ezd��?>�o#��[��	j��=P_�\g�i�^f�TT�l9����k�Ж%#&��ӌ��H�}����#�Z��A^�*K�sՉCm�8,��{d��?�P}K�ح�f�լ	���{�~�F��{�z�]B�H�Z�BO�X/J@�庠<GS8���Z搱�|����.�^xp*+�D2�A����?Z=fN�K@*M�L9+������c��WD�#c?�#�c-�0=�dE
$�K&�@��xCQ#�
/e�:u�ʝ�Bf�#���*e�E���r�X�Yv�)�&d�~��=��J��~�=�diUeiy�t��v�ˉ�{��� ���m�8`�����Oj1���zr��4�}7�ϙT��1�*�<x�1H�������=��[������J�C^4�t��c���Q(-�����-��N�|S���]����A�J�
�R�`~� �?>ˊ 2���J5z@
�{��"������ �V�Ao]S��2�xB@Y���{d��?>�o#�~5�L&6$��81D�FZ�Z��Lf)1�K]HJY0�y �3�~o��� 
�lN9�G��U��ϙ<�&l��Aj����I�E
��3����|��F��9C%�DlӋ��>)g��������r�6��ݜ=^K[^K+)�xCE�J �A2��iQ���"K3���R2$��ÿйcq'�2x^��'�W�L���ӧϾ8��Dm&g\O�k'�"�ps�L��Bx�G����l�ER���j���)/�U`߉KR� ���
,H�B�L�L�B�yD�1��i�����]ȋB�ڳC����^���������sU�fň�0��q�����X���=�����М��?1i��U�d������eZ+���\Iod�*1X���qΒ
�`I�y�Z⡡���;�m���K�0��!ˆh%�O������,5�������s�i;�70�o���ݬK����(���`�3�T�<OsM.W� ��K��X%�ݷ)z�2�	C^d�M�x8�v?�Ae��<r%bv,���n+M"v�7J��P�G�~@���R�9h��á���@�NM$)��f����9	�
'R�2R�,8�|l_�    �;��zv���
�, ��
����X_���Cv�Ӣ��2���	���w�Au #�N:);�������x�a��X��8�T�D"�a/Z]˚���F�a[-ns��P��V�P��K?g7�)�m��o�Ǔ��I8�5V%|v�1q���E�r)S�I�g^;�Y����wtH��p�dPY��G���Ce��+��k�9[i�p�\�^ͬŒ�X˖�1��hBUl<2BK�4�qư��zZQ�:�*J,;b��AZ`&E�F��P�,{�^��H�0P�!��E.��F#c��R?���}�x��&�;|�+=���7��YO�s�E�z��\?\�A��{�.�cu��An��Th뼓����~�$]fs-��T��F��%�y�����I�r/~�x#Zp�J��Ãb����>��	�$�u�k8f�'�G�@u>#W����<Y�f0�3�C���}P�����u%��T z75p��՜�5"�2�z�&X4�A�Y�	O�*L��l�)�6'�%�F*�}��4��� s.�$�!��2���K��n�)ENe��
0�5��;+���=`����������A����x{�T���=�����#|H���F��	��gi
yjs0���/ %��}��i���g���p�
�m�?�<��Q|�/'#f�����F�~�.�/��h�
�o�T1�#u/��W�~��ت��R�:[����w�NPubL�I�kǁ�����xr���i�ރ4ya|�tR0��&s�zP��,&д,ྙ[}I��%l�������j��G�X��I�����Y���d������yr{��2櫁�8��d#��q�zz��9�ǟΞ��_Ξ�f1�����%9y}u��ɦ�0���٢��UVF�
 -Bە�r�:�����E����H�=_TWF�{ȅ1��!/7�aue:&��֖��&���@�%�k[;9�����L�T!�کS�Qu�xQX�F)v&��\�WVF�TA��h������UY�ٶeY���@�J��N��8*v�%m�{�D Dei f�H��{��"P]D���V�,F��H�&"��9�￬.M�"&�������Kc�w�51�v�w�*K��TY�5���r�]��5�4t���:i~U5;�� (թ�DU�(���Z癩@T��Cl�ZE�ی�
�J�fZ��b[����6Ta;�~&a���=�m��6F���ň��{�V����"���ἵavMU�&ٔH�Im��}ݵ���%�Y���na��x_#��H6�5�l�w��.,��9�a蹉K�>M�6���ŋ]��b�A�F��|�J�t~��0~(-�m@���: �n��M�!�6��m$��H��:�o)@�$hPW���O�6庭u)5 Os8�P�d�s;������LN��<��wo��S�Z�<:��4^̠bfϪ�������D�;-
ie�Cғ ����<L�����Eqއ���kt���)���k>hV�ag�G�!c�T6a�TT��x�fG�)mZ{N�~G��`�Ql�[e�2��R��ڴ����b���zF	�Z�֦L�ջ���֫oK�����:��w�pZ�i.��'���3���%iv?ք�+ �A��<zP��wSq������&�P��lB0��Kќ��,@o1�g������\���ųg�����&�]��C��2�δ�L&��Q���reS[�
�`�DV�&k@:o����~��V�6�w`�G���,��4����Q�����QZяQm��w��$��J��Z���������&����_����5���n�>E �b�@I��+��B	%t���YKr�R�W@N��6?nEt>��Z��!oy�Z;?{��!,�Ilylc�x�[����:��ǝ5���Hj}$i�|�	u�*#�RL�%l��b$�2Ҽ���p"�J6��i�����H1�����:y�j_)�夨uu�|$%�#�S�c1�G*Ḋ����&ޒ�9�x����$~ks�x��|{�E�X���sLk�s�:΂-G.}���*�f���9':F��#�b:re:6&ݕM��u)a���ڭhG���.��*S��%UV
�!�-I�����QĐ�J�vtN��]���̈ �3Ge���0]��U~�Gk���y���l?��]���eV�K�*,�D �������֋�؝fR�=�MH-&��Se�5��]���<fI��}��	��Y)j�dX��m�Gp�:��W�覒��%�3���J�4�}}XOS�թ�y���оx�i�E۴��$-�)H�8�}����AT�J<Ѫ�h[W�/Fҕ�b/������F2՜��9]2\7��lu$��a6���1�p@]� Z[�m���fb�zW]���͜Bl��Y��zl����-��b}��XȤm]��f�m��V/[��-a˫_T�iY]=��J��ķ�����������mK.ʫ_8�
�4���)r폷�X=t]�i��ք-�~a`�*���K$�+�Z����z�z�m�.��,V_�C�n�kȶ/�m�z�z�n�[^�]�~Mw�"Z�9-V/;�^�֫oK����^���C���>����/[���-�d-��^��&^;�/��[}WkG���[^�Bߛ}?�ņto�i��%�X�3T�1;�k���c���H����D�\���;���YV��z��r��č�\�bC;����M]:F�Z���pcw��u�5x9d�u/0r]�H�#R5�_6�0���&ѻeWM���'����3kD� ;k<���/>�h*>��o��VS�Q8�0�A���D��.df�Ӗ�Іr-�L�,d�tj3̭ɉ?�.���b�~kth����l�z�]ł��5�����0�,)�=�C [���K���l|�k��H��c��ݻ�τ���o?����?��{���:��|>��p�vT���h���aɻGh����/Eh}���h:�,_�l������b�2��/öA�w}��-�&�J����z��({�/K���<ڴ��g?��˜�x!��{��';w��('V*K)�h�jj��T~��&W]��%���?�}s蠛C���0�(�(2���9եhs⚠�&E1�/[��͙k��rVV���._����,Vߢg������y���a�����b឵����Z�ӓ�~��)c�t�I�����QG�e��S�^k�*��oX��d�x�FYb"�<֠�g��*:����o�m�E@��\����L�M�CEv?���Y�ڳ��?�X����Vfc�$�Z�{%n^��[Y��E�EE[Ŝ�N�GwR�js�_��� )˘~�X�Ni�X�f��p�b�-ٽ����ڧ'!W�����G�������	C�����Q7;;V���y����HG���n_�F�ʘ^��6[k���؞�%5nM�J�s���T��T��n�4�*��g㓛Kr5���u{��ȪQ������a�*m���f��,嗣����$���������>~�vtv��C��ћ�O.��x�f���0M��!�_>��k��>����aF����������������Ix;����s͚�e鿠 �;!��W�V���Y���B�x��M#���nf���-�>�gh�B���B.��4-ˡwc�����W��3$q�����
���O �9�$y�֛�|��_?ֱ1NӦ/ ��ٕ�h4t�b�u��K�����갖@�
��AvX�v;lZ�p\���W�C<E��|�����]9c��;"�e
�u
�q�$�5��l)ö���Se��P����?�z�ݶ��<���-�Y2{c�4��4`e㺣�$����Г�� ć�L�B3��8�4��4Z�E?D������pv�HR'�0	v&� R�Zm{���?���)v�J%�V'���n4y�s*-��{aT ��B�P�$��� :Ǵ�9 [(������/�bW�|9|tk�a�CXK#G�cY��A��市��(U��M:!�I��y�ra�<�ݸ%�'�k��y�sV��u��-���,�t�`    ]Gt*�
�CU�2wD Kwݷ'���nx�����f�I�riWG)�|�b[���B����A�7ga2�l�|�)ܬ��/Q.1�Ʒ�����+Y�O;���K�����'�y<�#����GI�m���wnA���[̩~��r�O/ߎ|��#����?� �s��|��Ww�6~����W�L'�������,���Ȩ�Luse46(��Ex�lneg�'7a�_%�m��ݶ�n�DbPm;�{1���F������n��@T�ns"��Au4�wY��wm��!����HB��6�G��!&J[k�����.�V�龣@�1&�)�]rۏ����xW����ڏf*�Ō�&�Av�VG������"���\e�X-l؋��\���&-�y1(�����h��pۋ�'���h�m���?����N��������>uf�����^\L��],dgR��v�iv_�ݰ�����Ÿn���SYLd[J�v�L�rYS���I������\�������(L~���Y��+vV���o.O.�&��@õ-�p�
4��>�1,�r�Z�hZ-1�c?�N;�jv����Xz�j�]�F���Ʋ�����v�{ߊ�������.��r#�9��\�du������6d���������||?Xk/��e>8�,Ɠ��B}�ͳ�Xn.9���=<wZf�[̝j��������9�Y�����S��ಫ�˔u��>�����{���i�)+��6��1�S65S^p?3~����S�E�|Ƴ˪���Ìm͌��ټ8ӓ�s�MK �s�T�WZ0g�]B�����\~�	�@�vܮ8[����ckX��m��f|ֈa�TY-�$X��܌*�j<�b���%��wS��zu�o^^���/�_���}�?:'���������xu?U	^q��Y��(�,>�[�ݧ7/�#?����)~}���Ҿܑ�DG�lܞ�3��b��.���������"϶���L�3j}�,c���b�� |��R��?����f�/�����f&�~��6���!�$��I����G�N�?j��[��\Y��$i�(T{�6ꚪj�w/0k�l��
�,\?C��M���{��p����3��jY0�(�v�������H�;��r��i��v�9�܊�x*�G�K�����7��It�kγ6�r+?��A�c<�کO^��w�'o�a��5n;W���G��q�<TX1�"��-r�5-R���oJ�B2�� (k�?ŘO��H���*\��{T��}S��O�?3�*Y���S)TN,K�[AQ�>W��m�[��ԃͼRA�d��H����AB��T�)�@N�����ʎ�^�߇Q�]�3���m��گ��$*���;a��l���h~�g�#�nV�?�1�v�y�w�/G��On�� �*6z�л`(-
���ȉ�@�r���s���-�Mj�^�(!�^zB�����Ɨ��~ɘ��d�L��x|9� �)��u�沘��./�v���v��� ��DfN�F����&�*J�Qy����G�����O3�6??���H��x'r�̋,ӹ�����i��<��*R:��0�� �GZڷjh�ôj��[��N��<$x �hk��u!Q���;`wQ$(�jR!l@���B�:�h�:Yfl���W�]��X/�V�#���=���7�g,<��}��߇����xr~6���r���=����6J��J��U��D�L��}.Rr���WNyU��"�,��i�*2Jm��B8Z)C<�pE�:ؔ��A*�_����~���fQ-NIf�I�o��I�J�?-al~.�Aڔݯ�U�
�k���m_��O�ׇ���c�(8V+i P�6:"1���+iϊWc�˅�B��i�ؿK�7�63�c��k�2~k�ʐ�����mp��O!�CaA�1��3���^�Hb��I'�$�����~��fs6��H;�-D^dA��Hpֱhi��3�����&�y`����y����* ��$3ɶ����H�F�����lb�զ~S��Q���*��o�tQ���篦��WS��U6M��!��z��>�vq���Bz)��%����ca@��fiaM�*V� c�	����	V�,������a�AyQ��y��g�i=޲�> �4c��
 �V4B��X�߂=�{`ï�i��w��ۊH�7D2�
u�""�U�<��x�j���iF�j�FlB��Z1��	6�zG�\ZM*��E'����2`��N�@�%��!3��yGd�����/��z,���G�>��9�����3�����=�z,�b̃/��q�k��t�k��Ԫu�H��}zM-/𱡀�ݎ�n��/ȯ�<���e�|�?��Y�������a��z-ݒ*ϔr������1�>y6|��!��!�I�1�;����+��D/�#fl�	������'ϟN4�D�ɤ��;+�����9��j�A��s�w).�]m�����Nk��>�mC�9�Z�D�4�v�5�MF����ڎ�fj����*{ �c�j���$²27m�X�Y�(�[��@2���Χ�kb�����Aҵc�K��$�� m�b�8L�CS�i�z�5�!\�5m�Ŭq��].B���ۆXc0Z!��4��X㯘V��o���^:��c.�r�Qy�h�5&3YI��m�ef���u�zgc@ �2��B���½� ���cp�c�b�R��l@[*!GT���<�����ߎ��A��_������-�q���5�u3��܆�m��\����L��d���&&7AZ�5ohkB������1���O��ۚ����x��?��{���w���B��e���_�-�K���l��,a�)��PTXA�D��m )�v�F����4�ӌ,�(47�.��KS���7�}�����ћ��Q�fϸ�����J�۵���	�����sl&�f�c	Z�7	wq�������N&Dm`-
�bU{N�����`{���Tj�<�x�ٵJ��hy�c����Lݧ�gVmՂToZ��g�0d-��i��]�U����Q��f���X\���FFs����A�D1�Q�Ep;%�H�֥w��B����|)
ˆ���2�f^bfPY�AA>�z<zq�?���؈��_�A�b��Ұ��t�`�Ůd����1���Fl��Фw����y<�=y�"�J����9���#I*�9LEdl�� ����rv�l� <����=dI�L��w��	�o���c{�E&nխfi�rC�M��4����(��B��J,��8n'���a�"Y@��:e!
g%+�\�2S`B�q.u������h}p$�)[8@����㑑�"���F�����ܟ���t?���f2Z4�mRo�^�Q{���oy����\��5St*(����a�:�]�T�TK��s��M�e�vU�)/-!2vYi�<#0cm����x���M���(���1;+���c9F�pę��.G��-�Ig���f�i6�C5^@C�;W�kw���ܳ$��%�����n/m����t��cn��ObU#Xq�.A#��`�gEZ� <�C�s�d����H�S+ou0*U��ŏ��@E����QY��)��z[�=�!̾�3�+js^#w�Ӝ�YkH��Lj���UcZ�Ţc���\M����??��n7��^y��:�G�0�.j\5��q�T�t�ț�jԋ�t��{�@���:C���bc�x���˛;��V�ڸ��hem�s�t�0!�)X61�v��Z��4�����WIeM�I����O����T1�����iN�������t5D:��`ÙT��I�g�Ȳ�.MO[@j��f��c�(-ɠ5��B�@�r�p���Z_�I.�i����~j��t��>t��5�-�)�CE�����(L�r3�22nT�� �>���?�3Grl�ܫ�V��(�F+(^��]�Z ��[�E�����+w�6�90��j��7����ϟ��ZB0�m������i/�MĦz0�sZ
�]�k��4   ���^��HW]��?���ol�����Y, ^�!�^�d��8V�"ՇR��"yak��1��Ԋ��E���4�0���ǞÅ� 1t�%�X�ؓ3K�<V��|�s��As�v�j|j�;qyc��)Я:g�����f�|���$���<m�<�B������/g~t���B�R�:Zzvo�JR��^ƲE�@��y�Tͭ�����?�/��L$�����ֱ�]�0���l����P޾���ZgSL�W�zu����W'''���uX2n�@�I$�I��؝I�|&hN"~	�n����3}vh�j>�BUh��;���{��4j>�4Z��MI;�h|��n���L����ꄍ%�3L��;7�^��?����1��������V1�?o�۱�v��P~��=���]���:lwm�+KW�L�zl�{��1V��H5��]���nG�jl�[~�u_�Y��Zw0Y��cW����Q����a�v�Q�:��M�|WDS7���"�
V������Y���D�)�x<�3A�V�6�a�j-�^Oe;�n�wWɔ�����.SZ���m65�Q�Цv䋙�J��7���G���R7Z��)��c�=�a�c�cD��_w36u�]���F�!��l���>ɍp��U��v@swXY�C�GqZo��bg��9�A��8mm�� R�{,&Rۚ-K��N=v�=Fq�Гp'q���(?��9aG1�Тp�)�	N���	NS��x��B����e�����i�,�(9ۚ&9[�K��k��>�����M}q7N�ָ�
N����KN�R�Qr6vM�Iv6�N]q�6�O�(AMMT��5�Qm���T��=U%�!����ڊ��_'�c����v�MM���4�Y�(M��h{õi��sm0qj�|M %\�[~�4m���,m���'��u���m��V�I��7L��t	��
Hz��t�T�j'�o����nP�gcO����HO��P�頭-�������wIcߞ-��	l��4H�MM����׀����+�N���7W����\��IW�2;�����Z��0H]�ƶ]+j���]�(\��y�$YۄjK_������k�O�6�j�-=����;Xށ?�c˯c��}�v�M��VxesC��uC[��6vk�����-]�$Z �A�z�u����=�n��"L��'��(5u˪_c'I��3k0Ij�<K��#b����9F����Ц�6+���ণ<mlsS��"J-��&J���H|�$=6�8FY���b'Y���b�gkhy�Q��_��l��b���j1��uꃁ�Z�S�zɪ;!�����:L�_l�ʻmZ��/�^�"�ɲ���q�0b{ǕQ>�=#�O0�|��"�=�6:ab�\��I2���P�����GaK�7EZ�py�T�w6��n� �6N+y�Tϛ��m���7�"���ɳ��ոi�����1�e����r|��i�,t��,���(��ysh�ٝ7�ل��֦�_��y�?)�Q>��X����������q���.�0^9D.	�k.�͹H��M9��ض�)m��sJ��5��W�L�c��E`��ډ�K�����?����]��1Й�\� t6���E�g���nO]ꗺe6La��v'
t.Of؟®=��p�L�5��
��(�5{�7+J�%7���H`���2��N�����vg����U�.l��^_����啟���1����:�����ZOEX�Tmӽ��������RP�a²݄q1�u������-S�vS��)V������6�h7Y��l�j�Vݻ�'K��~�|�����`            x��\�r�:�]�_�~�np�Hy��Qo�Q���<ϳ����U���5�����D�  (Ӝ�/��{p�b�?��o�����/�	����!�8{S�!��9|o���Ǽ� M��=�f_�s��(�b���}�yN����S����{�������<���
� �%�wsj�9��b>(��u�+4�7�>����w��?{��ˇ0��=�`�[ ��C�~����ޘy�J���`�����o�{�4�'b�A��6�Y�2H�|�U�]��b�?	��4�-ܰ5�=�H!�|�V�i�Pp7�~�s��{S
4y \e����u�+�����[���-ߘ���C�`��Cs���R��1ʨ'���l���x�~�=yl&]mGh�4��>NȈ��bw����KDa.�Ϟl0�߇��;0�����P#��]�����&�<�K�d\��.Pa�K���봂fƘ>�����R!��>�:�l�<Wh�&ك	Ů�x��w�͸y��'~�;�-��{��z8���X�M�'���7�>��-o����ZJm����U�sA{��5����B�z��𸾞:.�����bV\I֊`=S�v�)F+�bL��P̷I]�2�ˬR�/���x�B;8�q�&aP�:$��k�xB�M����o�^�c�eF؅����f����r�Ӊ!�I/E�6�;�/���v"�@? �g�h'�"4ڻ@��I��'�N$�d�D%�p���XjHwP�Ɵ�t#�O���O��H�q��*V�\�ݘ�Zj��=��/dɘy��n\���!�p.�؇t�O�C���>����ZS�d�����ܸ��>L%<�<{j7.�JG�$l*�ڍ�>y��<xb!ʕ�
���Y+�=Av�"�&�.����j��D0�?���<{fW*��C*|���*'*
�ŅAh�yϠ��HИ}����Ϡ��H��:��gK��DR������O\�rb"Acj���.��D����`�3Ob981��A
D�H�O���H���TĿ|�DF��i�1�OYY|��Ɏ8����c��1��DF��������	��<04b�a�7�B��|JX�ia�Bv&"YJ�v#�-���g���@��Q��y�P)�h��"[��><���5'�|��n�D�ˉ6B�����'W�@
��l���Ji��(s0�H�ڍ��X)��@_b�ڍ���n��<�ٍ��L��P�]��ٕ��Sy_z>��xϕ�(r$*l_q�ٕ���	�d�|� ��*��O��}��y��?ٟ��+��׿�����4Z�kY��8��҆�<�P�P!���x��Lj�	�*9���L�y��c�Ǆ�a�W�?��Y�zB�О��Ƃn��A�ə2��)j�C�F0����ȒX��̚�Ӥ6H�������V5Ӟ!�g�#�7!q���,g�e��>ў��P�=rEf�=�OҚ&���:gr�����VIzV[?������H���	)�9�򺨘c�d2n�paǈȟIx��I�b�/.oq��)�t�`.����c��3	�B��:kط�	ö�T(�mٗ.L۰��3o�Q�q����v�Q6m�J�qMy]�qvE_ ���s\kϕ<��, �,��u�󴎋bCd'
Kn����W^>��X�r]�Mf����UG^G���p�CBG!y#�X�c7����@�G*+}�v��}_6^�y	y=�Q��y�q��8r�2g��V���ͺ�'�آ:��r��>�Dv���#y�➵��.���C��i>�] �L1N�du�2��Gf�oG�t�l�mk�IVk���DA�^g�}�u�M���vqD�T�GE�N�dt����:�������8�Y���-";Q���"0���y�,Ʌ�ʹ�)�`�ba";QPQz��y`W�HʍA,�(��=��,�>�ى��W%H^^C.˰�N��0dQ��)���U�N��R�h1|}U
�|��2G=�Y��c�S�'Q|'zV�R���ӐD'�%H�eN�$��dU���TO��u��/�ԅÄ�}��UY�v"�G����H}�7��|*6�h���s�lt�;�RSA��@�(�l*��S?�Q��CG��K�0�ى��,(�0|m-F)�tY��?Ǹo�������󝈉������\]���&���X�SQ��S�R�w"�y���I�v����g5�kG�<f��'�T�����i������r`)�ù�L�@eg�Lى�>i=�?�.�:�D-2ؗ����s/ֆ�ez�̉��B+PRcZĬ\���R�a�m8O��&T���L�v����l����㱫�4��Kzm�:��N��'�Co��ғ���~Z׽��Q�CV�u2rq�;"�P���
]�Ck�.(ֲ��ib���~��m�7Dv��U���n孚�zN�������<���4��6cF�,��P���s(�5l�e�H�О"����р�{��륗�8o*��u��^��x�_��#��y虅�((��l�-h1{���/���,B��S�"��cc)��<��>��^��h��,�����������B �N��
^�g<�y;E���N'$�=G�Ȋ���]�R7�:�$oC�G�4Y��D��>�Bƈ��uH�<�1Z���f,���i� Z��?�ȶM�q�Q�~��-H�*�����,}ߏ[���-�(�v�B�8�	ε�8D$xh������OؿQ�}v�^n�	K�=W��q�P�[��hy��z�cD�����m���C҉�M�$�6+�����M��U~Ѯs��Y���).����a6�0��')#.ƥ��\����g4�bQ�̚K����݀y�{�R�M<N2Q�6ͨ�Mv�<T���[d���W��`�5DI�R�l�ֲ4���d����s�g�N�B�Ԁ��:��o+������U��kq�SYN�YVQXȆ)��.����B
�Ek�E"�$�΃�I?�Q�-RJ(7`s���n��2kƘ��ɣ.A4�$z����S�p� ��m�
۾�J!:؅����N�%�
Qw(��c>�3d��-�(��vÕWkz �c���2��)VU�4��E1�!5�`\� >
�C@�S�Z���x��} ��!Jj54+j�/�x�g�������2�{d��^�'-�i<k-Cw�0'CVL(N;�b���.�gȒ=��R�[[�x랧��`�������ґ��#N�#�w��GRs14'����{��I6�;����2
^[C�"�he�Օ�򤊣s諡Τ����m>p-�B/f��ZO���ĝ��2s��/�w��A���j�*����B�i��2m���8)%]�AѢ��<D-��S^��A�&��E�,=�c�#��ׇ���ڻ!� :��4������1Qw0ɹ"��]B�&��J ���qȣ��y��>�T���0�##LPs_?��$Ӵo>:&�7�/}~7�K�ETM�s�+E�v����G����׉m^�=cA�m�N��LC�|�t�����@꽅��h�2O�	��U���+�|jy�=��=Ѹ��D���yz�E��E��L[.��a%Bq����ߠ����3��,����-�N9��6"��x��UA��\N$?�F�{�v�:�{�#m*��ꋋd�З�4���^�A�v�tL���~��՟��E�h��h��I^�� �FM��V0q��dK��O}q���^#�}!����K5��v����x���5�g���u�5��Ǵ���J�l�>�.!Bq��ڣ�m�1s�'Y�<����Ǣ,�5�xّ���e�{hMY���$�Q�[�#q���HO��]�[hi�}��笯�U�s|6ͮ�H�9�Fspc#�2�?(u�u.��r����Y��܇��э����T������
�r?$��|Mds�~�}���SH�kL��2�:T������U�g�窱��;���%�FG%�]�/]>O�ʧ`���JYV�"����PB-��]��q�V%[�C���ft�>!�+�e�a�_�d -
  ��3���z9Q֬�1x�l�YCw#}ek�KR�g���L�E���se#��9m����5��X��<�Q(֓3��	B��Qٺ����5��[KN�:o�\лNkv�vfK��v��	m��a�����`Y�v� ���8��EV��Y<�(Z�l�*�y�_�a�CB9�j��u޻��At�:�n��B��|/�DE��,�ڲe�,�U�~���Z�J»ls�K�A3�vV��C�d�a���a۵@��I��-���yO���%�S�Φ��7���� �WA.��Hξ��2-{�+XwtE���m�Xf1������#]G����ЮB��}�<��{r���a��LB�mi!�%\νEp�Nes*�0��Rj��.�1٦����U����h�t{� �bu�g�G�rPU]���V�b�j�]� ]��<hqi�=��XwI�U�q�]��{e��?�����6�C�^�g�*w[����eMy<��&IW��v�9]�\<0�1W���ث�5a�T��4D'��J���S/mļ���J�� �ᕎ6]^G�x���#tv��E9F���~�s�����2�ߣ;�\�UB�U���m���@�<ȗlOH��ƙ��+U_����@)���8Գ]0�1�q&��I#��F\��R�YGrff��J����L��{ק���Q������e���Cn��g�ێtRSo�^Ā��r\�7�WU}rF��Lt���3v�TE��ig��yY�{"��9$K{��K\7�H�����eɂ��i<��N��Fj�����b��x������.f,�	�W�m�^��;�a�џ����`��G������F��K՞c5n佐mn�2�]]7�n��T���y�xk̘U,�&۲1C��@��w-8�t��g�m�,���8'm	�d[�. Ջ���]Ғcn����y�c��R�c2��:�	SRߍ��w5(\�(�����נ:��(��'9����\�Mb�Ch|0�.��.��mS*Y��a�ݍ���;�/�K��*��`Yz�#��j�Hѧ�nԽЩ�G���B�k��ݸs����rf�!u�PWҥQt��C"���R�۔�uV�"ꦞ��MM[t�l�+�$}��ଫ}O氎��V�#���{%��]}�A)��cS�38��Ge�EiM�����l+��iO��s�4�6���P��������B�^G��Ԉz��UוչNm�!=�9W�Y�',m�JE�����0s�!�R���k�d�5�ؖ˸y�J1��6��N*!��&�eȗ#��O�����4��C�����^��J��?�Q��{�I��*	�X�h�l_�c���*�Q�yw������}x��9��Z����s�1=f��uQy�ZeYX�;FiV"ճ���,��U��%�_���t����0/��D��s�/a1������]�U�'\P{��q��c{��H���?	��^G�&�ǿ�;�~���5`(�7z�%p����6�s�O�z4a<�<@|�#|{m���5nê�;��4�Ƽ�9�n�U���F�ƶ�fȻ�%��k#~�M���ӿڗ��4��9����L���PtG�tU[�8�r��c^ϙ�__���v䩱�
����`\�J
¦�.���~������f<w۲ߎC�������+j~ڷ����BF'��lڤQzi�b����Ty5��4Q�'۫�w��w�$Iw��O�ۓk�1tq�fJ�2��]��B��"�r�n��>�![�l�PLO.����0���>���0j�-e8l�y[tۑ�2kr��>�.�0���!��!�b����v��*��I��۠��y9�_T�����f��O�R�<��z8��ꂣ�^�F:OS�leS(�!�o��s�ҐjA7Q?Q���{��K���/݂R����)��%���QHH�^�Q�6�b
��ل�d��}8��hі���Ju�i�/k�x��-*��ZC��w~Q:���J���8��s�17>N�
F��h��1<�[�T�"���7"鼺����J{��֮����'R(�p��O��~J��}�_y� �{�>���*p�&��Ŵ��7�nNG���vj����G����>�TvX���6K��h�:�OH7P
����{�I��`H��7���"���q��<'�4�U|N-N꨸�)����2�ٛM�P������y�z1wǱ(�Y��a��L��[\BL�0 ҕ�_'�6jO�w���
�
�m(��c���{	��qn�M҇L���R�$��l�Fr�����
��E6��0��K"�1u�n���c?�)�+q��J��D.�	k�.��).�r̔{�f�)1��<D�c�Ng�L��.�q^g)�=�e�b�� ��!�qc�4ɾ���<�qhÕ���ͬ�9ŷ��߸$�����[���(O���)�����3||U�����#���񵇩�ʹ��o*l�P�j<G�c��n�����Z?�N�С��C�92/Y�e�M;�cg-Y��d�9x�70�\���e�����}��8��$�0*(���olj�>g_���`�~;��=^__��+�O      �   C  x��T�n�0=�_A��Kaf����5P)R���&Zbm�dX�џ�W��*�����SS����7�!��ξ��]3-��lZ=.H�)ލߌg��f6�g]�}L���sx��~�6����G��߿����uQ����V�t/���^�����^5�eL@L'�[4�r�Jɷ #�C���<Tw�9� $�[	V"5
��p�v�����#����f��y՝b�2I��(�>n\]f�g�/�q�� \Y.(�`$�Ax�&���<��LS�:�w9w���{=��dZ�Q��~���Us�]� � ��R"����A�x��_�~랋%'h��
C�Dn�u�N��M]%��өjBY�P�b�r�Z�雐���|<Z5g�J3;d9X#���8Ɇ d�B	�b6<h���U���lN�r8 ES�*{�EnP-��8�\�^\[�;����{�%����2���􎾿��x�~^�N�t�]���� a0�3x�bl"r�o�g�3iARΔ��"��X�#\��gˡ����rL�@4��2�QmX��Ձ�s�s(GʴR:A�
nۣ���*�&$�����h����      �   �  x�}S�N�@��~�? B����%�%��q�%�g-�%m~;���Qd��g�O�_��]��f���#6��:���7!�$��RA�¶���)_�
_��!$Y9��w�Yeh�B�#_��3���]�b*�"��ڝ����e=R.V�{��ru�3Kl�f|�`v:�ǽ���?
���
m&����(�9Pj4ʼ-|(��u*O%� �d�E��` l6zae� -�N����aro�$]PZ�	�a�Bq�}g��=���������L��P��m����N܎�E��i�b�v|*W���'�|�C��B�q�f���&�8m�+�Q�}�d�\�|���u��I�[K�/B���`�t��Gn�ȭ�Is::���*�V�*��l��	�^M�%N-��n��ܙ���� Zr��vo�Z���-�         C   x�ɱ�0����LD�8DB���t'u�ϡ�i��UXR�	WR��?��9��s.��,�         +   x�+(��MM���JL����,.)JL�/�*-.M,���qqq ��      �   j  x���MN�0FדS�I��i뮊*EU;6C�VF��E܇+�Ћa7-��J��qd���}��g��V�jX
n4��V+?�Dc��$,T��	+pv@���xh1��1��W��U�Bn��
B������?���{ý�*���(Ѣ���).�hJLwI���F��HL�8��t<�E�|����oÕ(����j�%�p)�ZV�~�%���!�������c�}��0���J�� ���ڡ�y�ٽ[Xi���뷰��-v���t���sZ�D��H�I�	���0�x�{7y^qY� �nw�M���tZ��F^� ˧�N�4)؄���	l2:|���<e� I�L�(����     