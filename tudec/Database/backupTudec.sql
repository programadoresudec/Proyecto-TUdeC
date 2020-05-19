PGDMP     .                    x            tudec    12.2    12.2 �    /           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            0           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            1           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            2           1262    17662    tudec    DATABASE     �   CREATE DATABASE tudec WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Spanish_Latin America.1252' LC_CTYPE = 'Spanish_Latin America.1252';
    DROP DATABASE tudec;
                postgres    false                        2615    18462    comentarios    SCHEMA        CREATE SCHEMA comentarios;
    DROP SCHEMA comentarios;
                postgres    false            	            2615    18463    cursos    SCHEMA        CREATE SCHEMA cursos;
    DROP SCHEMA cursos;
                postgres    false            
            2615    18464    examenes    SCHEMA        CREATE SCHEMA examenes;
    DROP SCHEMA examenes;
                postgres    false                        2615    18465    mensajes    SCHEMA        CREATE SCHEMA mensajes;
    DROP SCHEMA mensajes;
                postgres    false                        2615    18466    notificaciones    SCHEMA        CREATE SCHEMA notificaciones;
    DROP SCHEMA notificaciones;
                postgres    false                        2615    18467    puntuaciones    SCHEMA        CREATE SCHEMA puntuaciones;
    DROP SCHEMA puntuaciones;
                postgres    false                        2615    18468    reportes    SCHEMA        CREATE SCHEMA reportes;
    DROP SCHEMA reportes;
                postgres    false                        2615    18469 	   seguridad    SCHEMA        CREATE SCHEMA seguridad;
    DROP SCHEMA seguridad;
                postgres    false                        2615    18470    sugerencias    SCHEMA        CREATE SCHEMA sugerencias;
    DROP SCHEMA sugerencias;
                postgres    false                        2615    18471    temas    SCHEMA        CREATE SCHEMA temas;
    DROP SCHEMA temas;
                postgres    false                        2615    18472    usuarios    SCHEMA        CREATE SCHEMA usuarios;
    DROP SCHEMA usuarios;
                postgres    false            �            1255    18473    f_log_auditoria()    FUNCTION     �  CREATE FUNCTION seguridad.f_log_auditoria() RETURNS trigger
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
    	   seguridad          postgres    false    15            �            1259    18475    comentarios    TABLE       CREATE TABLE comentarios.comentarios (
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
       comentarios         heap    postgres    false    8            �            1255    18481 u   field_audit(comentarios.comentarios, comentarios.comentarios, character varying, text, character varying, text, text)    FUNCTION     �  CREATE FUNCTION seguridad.field_audit(_data_new comentarios.comentarios, _data_old comentarios.comentarios, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
    	   seguridad          postgres    false    213    15    213            �            1259    18497    cursos    TABLE     D  CREATE TABLE cursos.cursos (
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
       cursos         heap    postgres    false    9            �            1255    18876 a   field_audit(cursos.cursos, cursos.cursos, character varying, text, character varying, text, text)    FUNCTION     .  CREATE FUNCTION seguridad.field_audit(_data_new cursos.cursos, _data_old cursos.cursos, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
    	   seguridad          postgres    false    15    217    217            �            1259    18505    estados_curso    TABLE     @   CREATE TABLE cursos.estados_curso (
    estado text NOT NULL
);
 !   DROP TABLE cursos.estados_curso;
       cursos         heap    postgres    false    9                       1255    18875 o   field_audit(cursos.estados_curso, cursos.estados_curso, character varying, text, character varying, text, text)    FUNCTION     O  CREATE FUNCTION seguridad.field_audit(_data_new cursos.estados_curso, _data_old cursos.estados_curso, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
    	   seguridad          postgres    false    219    219    15            �            1259    18511    inscripciones_cursos    TABLE     �   CREATE TABLE cursos.inscripciones_cursos (
    id integer NOT NULL,
    fk_nombre_de_usuario text NOT NULL,
    fk_id_curso integer NOT NULL,
    fecha_de_inscripcion date NOT NULL
);
 (   DROP TABLE cursos.inscripciones_cursos;
       cursos         heap    postgres    false    9                       1255    18874 }   field_audit(cursos.inscripciones_cursos, cursos.inscripciones_cursos, character varying, text, character varying, text, text)    FUNCTION     ~	  CREATE FUNCTION seguridad.field_audit(_data_new cursos.inscripciones_cursos, _data_old cursos.inscripciones_cursos, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
    	   seguridad          postgres    false    15    220    220            �            1259    18554    mensajes    TABLE       CREATE TABLE mensajes.mensajes (
    id integer NOT NULL,
    fk_nombre_de_usuario_emisor text NOT NULL,
    fk_nombre_de_usuario_receptor text NOT NULL,
    contenido text NOT NULL,
    imagenes text[],
    fecha timestamp without time zone NOT NULL,
    id_curso integer
);
    DROP TABLE mensajes.mensajes;
       mensajes         heap    postgres    false    11                       1255    18877 i   field_audit(mensajes.mensajes, mensajes.mensajes, character varying, text, character varying, text, text)    FUNCTION     '  CREATE FUNCTION seguridad.field_audit(_data_new mensajes.mensajes, _data_old mensajes.mensajes, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
    	   seguridad          postgres    false    231    15    231            �            1259    18482    usuarios    TABLE     {  CREATE TABLE usuarios.usuarios (
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
       usuarios         heap    postgres    false    18            
           1255    18488 i   field_audit(usuarios.usuarios, usuarios.usuarios, character varying, text, character varying, text, text)    FUNCTION     "  CREATE FUNCTION seguridad.field_audit(_data_new usuarios.usuarios, _data_old usuarios.usuarios, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
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
    	   seguridad          postgres    false    214    15    214            �            1259    18489    comentarios_id_seq    SEQUENCE     �   CREATE SEQUENCE comentarios.comentarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE comentarios.comentarios_id_seq;
       comentarios          postgres    false    213    8            3           0    0    comentarios_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE comentarios.comentarios_id_seq OWNED BY comentarios.comentarios.id;
          comentarios          postgres    false    215            �            1259    18491    areas    TABLE     O   CREATE TABLE cursos.areas (
    area text NOT NULL,
    icono text NOT NULL
);
    DROP TABLE cursos.areas;
       cursos         heap    postgres    false    9            �            1259    18503    cursos_id_seq    SEQUENCE     �   CREATE SEQUENCE cursos.cursos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE cursos.cursos_id_seq;
       cursos          postgres    false    217    9            4           0    0    cursos_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE cursos.cursos_id_seq OWNED BY cursos.cursos.id;
          cursos          postgres    false    218            �            1259    18517    inscripciones_cursos_id_seq    SEQUENCE     �   CREATE SEQUENCE cursos.inscripciones_cursos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE cursos.inscripciones_cursos_id_seq;
       cursos          postgres    false    220    9            5           0    0    inscripciones_cursos_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE cursos.inscripciones_cursos_id_seq OWNED BY cursos.inscripciones_cursos.id;
          cursos          postgres    false    221            �            1259    18519    ejecucion_examen    TABLE       CREATE TABLE examenes.ejecucion_examen (
    id integer NOT NULL,
    fk_nombre_de_usuario text NOT NULL,
    fk_id_examen integer NOT NULL,
    fecha_de_ejecucion timestamp with time zone NOT NULL,
    calificacion integer,
    respuestas text NOT NULL
);
 &   DROP TABLE examenes.ejecucion_examen;
       examenes         heap    postgres    false    10            �            1259    18525    ejecucion_examen_id_seq    SEQUENCE     �   CREATE SEQUENCE examenes.ejecucion_examen_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE examenes.ejecucion_examen_id_seq;
       examenes          postgres    false    222    10            6           0    0    ejecucion_examen_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE examenes.ejecucion_examen_id_seq OWNED BY examenes.ejecucion_examen.id;
          examenes          postgres    false    223            �            1259    18527    examenes    TABLE     q   CREATE TABLE examenes.examenes (
    id integer NOT NULL,
    fk_id_tema integer,
    fecha_fin date NOT NULL
);
    DROP TABLE examenes.examenes;
       examenes         heap    postgres    false    10            �            1259    18530    examenes_id_seq    SEQUENCE     �   CREATE SEQUENCE examenes.examenes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE examenes.examenes_id_seq;
       examenes          postgres    false    224    10            7           0    0    examenes_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE examenes.examenes_id_seq OWNED BY examenes.examenes.id;
          examenes          postgres    false    225            �            1259    18532 	   preguntas    TABLE     �   CREATE TABLE examenes.preguntas (
    id integer NOT NULL,
    fk_id_examen integer NOT NULL,
    fk_tipo_pregunta text NOT NULL,
    pregunta text NOT NULL,
    porcentaje integer NOT NULL
);
    DROP TABLE examenes.preguntas;
       examenes         heap    postgres    false    10            �            1259    18538    preguntas_id_seq    SEQUENCE     �   CREATE SEQUENCE examenes.preguntas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE examenes.preguntas_id_seq;
       examenes          postgres    false    226    10            8           0    0    preguntas_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE examenes.preguntas_id_seq OWNED BY examenes.preguntas.id;
          examenes          postgres    false    227            �            1259    18540 
   respuestas    TABLE     �   CREATE TABLE examenes.respuestas (
    id integer NOT NULL,
    fk_id_preguntas integer NOT NULL,
    respuesta text NOT NULL,
    estado boolean NOT NULL
);
     DROP TABLE examenes.respuestas;
       examenes         heap    postgres    false    10            �            1259    18546    respuestas_id_seq    SEQUENCE     �   CREATE SEQUENCE examenes.respuestas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE examenes.respuestas_id_seq;
       examenes          postgres    false    10    228            9           0    0    respuestas_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE examenes.respuestas_id_seq OWNED BY examenes.respuestas.id;
          examenes          postgres    false    229            �            1259    18548    tipos_pregunta    TABLE     A   CREATE TABLE examenes.tipos_pregunta (
    tipo text NOT NULL
);
 $   DROP TABLE examenes.tipos_pregunta;
       examenes         heap    postgres    false    10            �            1259    18560    mensajes_id_seq    SEQUENCE     �   CREATE SEQUENCE mensajes.mensajes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE mensajes.mensajes_id_seq;
       mensajes          postgres    false    11    231            :           0    0    mensajes_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE mensajes.mensajes_id_seq OWNED BY mensajes.mensajes.id;
          mensajes          postgres    false    232            �            1259    18562    notificaciones    TABLE     �   CREATE TABLE notificaciones.notificaciones (
    id integer NOT NULL,
    mensaje text NOT NULL,
    estado boolean NOT NULL,
    fk_nombre_de_usuario text NOT NULL
);
 *   DROP TABLE notificaciones.notificaciones;
       notificaciones         heap    postgres    false    12            �            1259    18568    notificaciones_id_seq    SEQUENCE     �   CREATE SEQUENCE notificaciones.notificaciones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE notificaciones.notificaciones_id_seq;
       notificaciones          postgres    false    233    12            ;           0    0    notificaciones_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE notificaciones.notificaciones_id_seq OWNED BY notificaciones.notificaciones.id;
          notificaciones          postgres    false    234            �            1259    18570    puntuaciones    TABLE     �   CREATE TABLE puntuaciones.puntuaciones (
    id integer NOT NULL,
    emisor text NOT NULL,
    receptor text NOT NULL,
    puntuacion integer NOT NULL
);
 &   DROP TABLE puntuaciones.puntuaciones;
       puntuaciones         heap    postgres    false    13            �            1259    18576    puntuaciones_id_seq    SEQUENCE     �   CREATE SEQUENCE puntuaciones.puntuaciones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE puntuaciones.puntuaciones_id_seq;
       puntuaciones          postgres    false    235    13            <           0    0    puntuaciones_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE puntuaciones.puntuaciones_id_seq OWNED BY puntuaciones.puntuaciones.id;
          puntuaciones          postgres    false    236            �            1259    18578    motivos    TABLE     <   CREATE TABLE reportes.motivos (
    motivo text NOT NULL
);
    DROP TABLE reportes.motivos;
       reportes         heap    postgres    false    14            �            1259    18584    reportes    TABLE     \  CREATE TABLE reportes.reportes (
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
       reportes         heap    postgres    false    14            �            1259    18590    reportes_id_seq    SEQUENCE     �   CREATE SEQUENCE reportes.reportes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE reportes.reportes_id_seq;
       reportes          postgres    false    238    14            =           0    0    reportes_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE reportes.reportes_id_seq OWNED BY reportes.reportes.id;
          reportes          postgres    false    239            �            1259    18592 	   auditoria    TABLE     L  CREATE TABLE seguridad.auditoria (
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
    	   seguridad         heap    postgres    false    15            >           0    0    TABLE auditoria    COMMENT     b   COMMENT ON TABLE seguridad.auditoria IS 'Tabla que almacena la trazabilidad de la informaicón.';
       	   seguridad          postgres    false    240            ?           0    0    COLUMN auditoria.id    COMMENT     E   COMMENT ON COLUMN seguridad.auditoria.id IS 'campo pk de la tabla ';
       	   seguridad          postgres    false    240            @           0    0    COLUMN auditoria.fecha    COMMENT     [   COMMENT ON COLUMN seguridad.auditoria.fecha IS 'ALmacen ala la fecha de la modificación';
       	   seguridad          postgres    false    240            A           0    0    COLUMN auditoria.accion    COMMENT     g   COMMENT ON COLUMN seguridad.auditoria.accion IS 'Almacena la accion que se ejecuto sobre el registro';
       	   seguridad          postgres    false    240            B           0    0    COLUMN auditoria.schema    COMMENT     n   COMMENT ON COLUMN seguridad.auditoria.schema IS 'Almanena el nomnbre del schema de la tabla que se modifico';
       	   seguridad          postgres    false    240            C           0    0    COLUMN auditoria.tabla    COMMENT     a   COMMENT ON COLUMN seguridad.auditoria.tabla IS 'Almacena el nombre de la tabla que se modifico';
       	   seguridad          postgres    false    240            D           0    0    COLUMN auditoria.session    COMMENT     q   COMMENT ON COLUMN seguridad.auditoria.session IS 'Campo que almacena el id de la session que generó el cambio';
       	   seguridad          postgres    false    240            E           0    0    COLUMN auditoria.user_bd    COMMENT     �   COMMENT ON COLUMN seguridad.auditoria.user_bd IS 'Campo que almacena el user que se autentico en el motor para generar el cmabio';
       	   seguridad          postgres    false    240            F           0    0    COLUMN auditoria.data    COMMENT     e   COMMENT ON COLUMN seguridad.auditoria.data IS 'campo que almacena la modificaicón que se realizó';
       	   seguridad          postgres    false    240            G           0    0    COLUMN auditoria.pk    COMMENT     X   COMMENT ON COLUMN seguridad.auditoria.pk IS 'Campo que identifica el id del registro.';
       	   seguridad          postgres    false    240            �            1259    18598    auditoria_id_seq    SEQUENCE     |   CREATE SEQUENCE seguridad.auditoria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE seguridad.auditoria_id_seq;
    	   seguridad          postgres    false    240    15            H           0    0    auditoria_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE seguridad.auditoria_id_seq OWNED BY seguridad.auditoria.id;
       	   seguridad          postgres    false    241            �            1259    18600    autentication    TABLE     �   CREATE TABLE seguridad.autentication (
    id integer NOT NULL,
    nombre_de_usuario text NOT NULL,
    ip text,
    mac text,
    fecha_inicio timestamp without time zone,
    fecha_fin timestamp without time zone,
    session text
);
 $   DROP TABLE seguridad.autentication;
    	   seguridad         heap    postgres    false    15            �            1259    18606    autentication_id_seq    SEQUENCE     �   CREATE SEQUENCE seguridad.autentication_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE seguridad.autentication_id_seq;
    	   seguridad          postgres    false    242    15            I           0    0    autentication_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE seguridad.autentication_id_seq OWNED BY seguridad.autentication.id;
       	   seguridad          postgres    false    243            �            1259    18608    function_db_view    VIEW     �  CREATE VIEW seguridad.function_db_view AS
 SELECT pp.proname AS b_function,
    oidvectortypes(pp.proargtypes) AS b_type_parameters
   FROM (pg_proc pp
     JOIN pg_namespace pn ON ((pn.oid = pp.pronamespace)))
  WHERE ((pn.nspname)::text <> ALL (ARRAY[('pg_catalog'::character varying)::text, ('information_schema'::character varying)::text, ('admin_control'::character varying)::text, ('vial'::character varying)::text]));
 &   DROP VIEW seguridad.function_db_view;
    	   seguridad          postgres    false    15            �            1259    18613    sugerencias    TABLE     �   CREATE TABLE sugerencias.sugerencias (
    id integer NOT NULL,
    fk_nombre_de_usuario_emisor text,
    contenido text NOT NULL,
    estado boolean NOT NULL,
    imagenes text,
    titulo text NOT NULL,
    fecha timestamp with time zone NOT NULL
);
 $   DROP TABLE sugerencias.sugerencias;
       sugerencias         heap    postgres    false    16            �            1259    18619    sugerencias_id_seq    SEQUENCE     �   CREATE SEQUENCE sugerencias.sugerencias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE sugerencias.sugerencias_id_seq;
       sugerencias          postgres    false    245    16            J           0    0    sugerencias_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE sugerencias.sugerencias_id_seq OWNED BY sugerencias.sugerencias.id;
          sugerencias          postgres    false    246            �            1259    18621    temas    TABLE     �   CREATE TABLE temas.temas (
    id integer NOT NULL,
    fk_id_curso integer NOT NULL,
    titulo text NOT NULL,
    informacion text NOT NULL,
    imagenes text[]
);
    DROP TABLE temas.temas;
       temas         heap    postgres    false    17            �            1259    18627    temas_id_seq    SEQUENCE     �   CREATE SEQUENCE temas.temas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE temas.temas_id_seq;
       temas          postgres    false    247    17            K           0    0    temas_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE temas.temas_id_seq OWNED BY temas.temas.id;
          temas          postgres    false    248            �            1259    18629    estados_usuario    TABLE     D   CREATE TABLE usuarios.estados_usuario (
    estado text NOT NULL
);
 %   DROP TABLE usuarios.estados_usuario;
       usuarios         heap    postgres    false    18            �            1259    18635    roles    TABLE     7   CREATE TABLE usuarios.roles (
    rol text NOT NULL
);
    DROP TABLE usuarios.roles;
       usuarios         heap    postgres    false    18                       2604    18641    comentarios id    DEFAULT     z   ALTER TABLE ONLY comentarios.comentarios ALTER COLUMN id SET DEFAULT nextval('comentarios.comentarios_id_seq'::regclass);
 B   ALTER TABLE comentarios.comentarios ALTER COLUMN id DROP DEFAULT;
       comentarios          postgres    false    215    213                       2604    18642 	   cursos id    DEFAULT     f   ALTER TABLE ONLY cursos.cursos ALTER COLUMN id SET DEFAULT nextval('cursos.cursos_id_seq'::regclass);
 8   ALTER TABLE cursos.cursos ALTER COLUMN id DROP DEFAULT;
       cursos          postgres    false    218    217                       2604    18643    inscripciones_cursos id    DEFAULT     �   ALTER TABLE ONLY cursos.inscripciones_cursos ALTER COLUMN id SET DEFAULT nextval('cursos.inscripciones_cursos_id_seq'::regclass);
 F   ALTER TABLE cursos.inscripciones_cursos ALTER COLUMN id DROP DEFAULT;
       cursos          postgres    false    221    220                       2604    18644    ejecucion_examen id    DEFAULT     ~   ALTER TABLE ONLY examenes.ejecucion_examen ALTER COLUMN id SET DEFAULT nextval('examenes.ejecucion_examen_id_seq'::regclass);
 D   ALTER TABLE examenes.ejecucion_examen ALTER COLUMN id DROP DEFAULT;
       examenes          postgres    false    223    222                       2604    18645    examenes id    DEFAULT     n   ALTER TABLE ONLY examenes.examenes ALTER COLUMN id SET DEFAULT nextval('examenes.examenes_id_seq'::regclass);
 <   ALTER TABLE examenes.examenes ALTER COLUMN id DROP DEFAULT;
       examenes          postgres    false    225    224                       2604    18646    preguntas id    DEFAULT     p   ALTER TABLE ONLY examenes.preguntas ALTER COLUMN id SET DEFAULT nextval('examenes.preguntas_id_seq'::regclass);
 =   ALTER TABLE examenes.preguntas ALTER COLUMN id DROP DEFAULT;
       examenes          postgres    false    227    226                        2604    18647    respuestas id    DEFAULT     r   ALTER TABLE ONLY examenes.respuestas ALTER COLUMN id SET DEFAULT nextval('examenes.respuestas_id_seq'::regclass);
 >   ALTER TABLE examenes.respuestas ALTER COLUMN id DROP DEFAULT;
       examenes          postgres    false    229    228            !           2604    18648    mensajes id    DEFAULT     n   ALTER TABLE ONLY mensajes.mensajes ALTER COLUMN id SET DEFAULT nextval('mensajes.mensajes_id_seq'::regclass);
 <   ALTER TABLE mensajes.mensajes ALTER COLUMN id DROP DEFAULT;
       mensajes          postgres    false    232    231            "           2604    18649    notificaciones id    DEFAULT     �   ALTER TABLE ONLY notificaciones.notificaciones ALTER COLUMN id SET DEFAULT nextval('notificaciones.notificaciones_id_seq'::regclass);
 H   ALTER TABLE notificaciones.notificaciones ALTER COLUMN id DROP DEFAULT;
       notificaciones          postgres    false    234    233            #           2604    18650    puntuaciones id    DEFAULT     ~   ALTER TABLE ONLY puntuaciones.puntuaciones ALTER COLUMN id SET DEFAULT nextval('puntuaciones.puntuaciones_id_seq'::regclass);
 D   ALTER TABLE puntuaciones.puntuaciones ALTER COLUMN id DROP DEFAULT;
       puntuaciones          postgres    false    236    235            $           2604    18651    reportes id    DEFAULT     n   ALTER TABLE ONLY reportes.reportes ALTER COLUMN id SET DEFAULT nextval('reportes.reportes_id_seq'::regclass);
 <   ALTER TABLE reportes.reportes ALTER COLUMN id DROP DEFAULT;
       reportes          postgres    false    239    238            %           2604    18652    auditoria id    DEFAULT     r   ALTER TABLE ONLY seguridad.auditoria ALTER COLUMN id SET DEFAULT nextval('seguridad.auditoria_id_seq'::regclass);
 >   ALTER TABLE seguridad.auditoria ALTER COLUMN id DROP DEFAULT;
    	   seguridad          postgres    false    241    240            &           2604    18653    autentication id    DEFAULT     z   ALTER TABLE ONLY seguridad.autentication ALTER COLUMN id SET DEFAULT nextval('seguridad.autentication_id_seq'::regclass);
 B   ALTER TABLE seguridad.autentication ALTER COLUMN id DROP DEFAULT;
    	   seguridad          postgres    false    243    242            '           2604    18654    sugerencias id    DEFAULT     z   ALTER TABLE ONLY sugerencias.sugerencias ALTER COLUMN id SET DEFAULT nextval('sugerencias.sugerencias_id_seq'::regclass);
 B   ALTER TABLE sugerencias.sugerencias ALTER COLUMN id DROP DEFAULT;
       sugerencias          postgres    false    246    245            (           2604    18655    temas id    DEFAULT     b   ALTER TABLE ONLY temas.temas ALTER COLUMN id SET DEFAULT nextval('temas.temas_id_seq'::regclass);
 6   ALTER TABLE temas.temas ALTER COLUMN id DROP DEFAULT;
       temas          postgres    false    248    247                      0    18475    comentarios 
   TABLE DATA           �   COPY comentarios.comentarios (id, fk_nombre_de_usuario_emisor, fk_id_curso, fk_id_tema, fk_id_comentario, comentario, fecha_envio, imagenes) FROM stdin;
    comentarios          postgres    false    213   "�                0    18491    areas 
   TABLE DATA           ,   COPY cursos.areas (area, icono) FROM stdin;
    cursos          postgres    false    216   ��                0    18497    cursos 
   TABLE DATA           �   COPY cursos.cursos (id, fk_creador, fk_area, fk_estado, nombre, fecha_de_creacion, fecha_de_inicio, codigo_inscripcion, puntuacion, descripcion) FROM stdin;
    cursos          postgres    false    217   *�                0    18505    estados_curso 
   TABLE DATA           /   COPY cursos.estados_curso (estado) FROM stdin;
    cursos          postgres    false    219   '�                0    18511    inscripciones_cursos 
   TABLE DATA           k   COPY cursos.inscripciones_cursos (id, fk_nombre_de_usuario, fk_id_curso, fecha_de_inscripcion) FROM stdin;
    cursos          postgres    false    220   U�                0    18519    ejecucion_examen 
   TABLE DATA           �   COPY examenes.ejecucion_examen (id, fk_nombre_de_usuario, fk_id_examen, fecha_de_ejecucion, calificacion, respuestas) FROM stdin;
    examenes          postgres    false    222   ��                0    18527    examenes 
   TABLE DATA           ?   COPY examenes.examenes (id, fk_id_tema, fecha_fin) FROM stdin;
    examenes          postgres    false    224   c�                0    18532 	   preguntas 
   TABLE DATA           _   COPY examenes.preguntas (id, fk_id_examen, fk_tipo_pregunta, pregunta, porcentaje) FROM stdin;
    examenes          postgres    false    226   ��                0    18540 
   respuestas 
   TABLE DATA           N   COPY examenes.respuestas (id, fk_id_preguntas, respuesta, estado) FROM stdin;
    examenes          postgres    false    228   K�                0    18548    tipos_pregunta 
   TABLE DATA           0   COPY examenes.tipos_pregunta (tipo) FROM stdin;
    examenes          postgres    false    230   ψ                0    18554    mensajes 
   TABLE DATA           �   COPY mensajes.mensajes (id, fk_nombre_de_usuario_emisor, fk_nombre_de_usuario_receptor, contenido, imagenes, fecha, id_curso) FROM stdin;
    mensajes          postgres    false    231   ,�                0    18562    notificaciones 
   TABLE DATA           [   COPY notificaciones.notificaciones (id, mensaje, estado, fk_nombre_de_usuario) FROM stdin;
    notificaciones          postgres    false    233   =�                0    18570    puntuaciones 
   TABLE DATA           N   COPY puntuaciones.puntuaciones (id, emisor, receptor, puntuacion) FROM stdin;
    puntuaciones          postgres    false    235   Z�                 0    18578    motivos 
   TABLE DATA           +   COPY reportes.motivos (motivo) FROM stdin;
    reportes          postgres    false    237   ��      !          0    18584    reportes 
   TABLE DATA           �   COPY reportes.reportes (id, fk_nombre_de_usuario_denunciante, fk_nombre_de_usuario_denunciado, fk_motivo, descripcion, estado, fk_id_comentario, fk_id_mensaje, fecha) FROM stdin;
    reportes          postgres    false    238   �      #          0    18592 	   auditoria 
   TABLE DATA           d   COPY seguridad.auditoria (id, fecha, accion, schema, tabla, session, user_bd, data, pk) FROM stdin;
 	   seguridad          postgres    false    240   ��      %          0    18600    autentication 
   TABLE DATA           l   COPY seguridad.autentication (id, nombre_de_usuario, ip, mac, fecha_inicio, fecha_fin, session) FROM stdin;
 	   seguridad          postgres    false    242   t�      '          0    18613    sugerencias 
   TABLE DATA           w   COPY sugerencias.sugerencias (id, fk_nombre_de_usuario_emisor, contenido, estado, imagenes, titulo, fecha) FROM stdin;
    sugerencias          postgres    false    245   ��      )          0    18621    temas 
   TABLE DATA           N   COPY temas.temas (id, fk_id_curso, titulo, informacion, imagenes) FROM stdin;
    temas          postgres    false    247   L�      +          0    18629    estados_usuario 
   TABLE DATA           3   COPY usuarios.estados_usuario (estado) FROM stdin;
    usuarios          postgres    false    249   ѽ      ,          0    18635    roles 
   TABLE DATA           &   COPY usuarios.roles (rol) FROM stdin;
    usuarios          postgres    false    250   $�      	          0    18482    usuarios 
   TABLE DATA           >  COPY usuarios.usuarios (nombre_de_usuario, fk_rol, fk_estado, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, correo_institucional, pass, fecha_desbloqueo, puntuacion, token, imagen_perfil, fecha_creacion, ultima_modificacion, vencimiento_token, session, descripcion, puntuacion_bloqueo) FROM stdin;
    usuarios          postgres    false    214   _�      L           0    0    comentarios_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('comentarios.comentarios_id_seq', 7, true);
          comentarios          postgres    false    215            M           0    0    cursos_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('cursos.cursos_id_seq', 12, true);
          cursos          postgres    false    218            N           0    0    inscripciones_cursos_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('cursos.inscripciones_cursos_id_seq', 6, true);
          cursos          postgres    false    221            O           0    0    ejecucion_examen_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('examenes.ejecucion_examen_id_seq', 4, true);
          examenes          postgres    false    223            P           0    0    examenes_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('examenes.examenes_id_seq', 1, false);
          examenes          postgres    false    225            Q           0    0    preguntas_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('examenes.preguntas_id_seq', 29, true);
          examenes          postgres    false    227            R           0    0    respuestas_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('examenes.respuestas_id_seq', 30, true);
          examenes          postgres    false    229            S           0    0    mensajes_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('mensajes.mensajes_id_seq', 16, true);
          mensajes          postgres    false    232            T           0    0    notificaciones_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('notificaciones.notificaciones_id_seq', 1, false);
          notificaciones          postgres    false    234            U           0    0    puntuaciones_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('puntuaciones.puntuaciones_id_seq', 8, true);
          puntuaciones          postgres    false    236            V           0    0    reportes_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('reportes.reportes_id_seq', 5, true);
          reportes          postgres    false    239            W           0    0    auditoria_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('seguridad.auditoria_id_seq', 205, true);
       	   seguridad          postgres    false    241            X           0    0    autentication_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('seguridad.autentication_id_seq', 343, true);
       	   seguridad          postgres    false    243            Y           0    0    sugerencias_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('sugerencias.sugerencias_id_seq', 32, true);
          sugerencias          postgres    false    246            Z           0    0    temas_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('temas.temas_id_seq', 3, true);
          temas          postgres    false    248            *           2606    18657    comentarios comentarios_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT comentarios_pkey PRIMARY KEY (id);
 K   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT comentarios_pkey;
       comentarios            postgres    false    213            0           2606    18659    areas areas_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY cursos.areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (area);
 :   ALTER TABLE ONLY cursos.areas DROP CONSTRAINT areas_pkey;
       cursos            postgres    false    216            2           2606    18661    cursos cursos_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT cursos_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT cursos_pkey;
       cursos            postgres    false    217            4           2606    18663    estados_curso estado_curso_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY cursos.estados_curso
    ADD CONSTRAINT estado_curso_pkey PRIMARY KEY (estado);
 I   ALTER TABLE ONLY cursos.estados_curso DROP CONSTRAINT estado_curso_pkey;
       cursos            postgres    false    219            6           2606    18665 .   inscripciones_cursos inscripciones_cursos_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY cursos.inscripciones_cursos
    ADD CONSTRAINT inscripciones_cursos_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY cursos.inscripciones_cursos DROP CONSTRAINT inscripciones_cursos_pkey;
       cursos            postgres    false    220            8           2606    18667 &   ejecucion_examen ejecucion_examen_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY examenes.ejecucion_examen
    ADD CONSTRAINT ejecucion_examen_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY examenes.ejecucion_examen DROP CONSTRAINT ejecucion_examen_pkey;
       examenes            postgres    false    222            :           2606    18669    examenes examenes_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY examenes.examenes
    ADD CONSTRAINT examenes_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY examenes.examenes DROP CONSTRAINT examenes_pkey;
       examenes            postgres    false    224            <           2606    18671    preguntas preguntas_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY examenes.preguntas
    ADD CONSTRAINT preguntas_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY examenes.preguntas DROP CONSTRAINT preguntas_pkey;
       examenes            postgres    false    226            >           2606    18673    respuestas respuestas_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY examenes.respuestas
    ADD CONSTRAINT respuestas_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY examenes.respuestas DROP CONSTRAINT respuestas_pkey;
       examenes            postgres    false    228            @           2606    18675 "   tipos_pregunta tipos_pregunta_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY examenes.tipos_pregunta
    ADD CONSTRAINT tipos_pregunta_pkey PRIMARY KEY (tipo);
 N   ALTER TABLE ONLY examenes.tipos_pregunta DROP CONSTRAINT tipos_pregunta_pkey;
       examenes            postgres    false    230            B           2606    18677    mensajes mensajes_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY mensajes.mensajes
    ADD CONSTRAINT mensajes_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY mensajes.mensajes DROP CONSTRAINT mensajes_pkey;
       mensajes            postgres    false    231            D           2606    18679 "   notificaciones notificaciones_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY notificaciones.notificaciones
    ADD CONSTRAINT notificaciones_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY notificaciones.notificaciones DROP CONSTRAINT notificaciones_pkey;
       notificaciones            postgres    false    233            F           2606    18681    puntuaciones puntuaciones_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY puntuaciones.puntuaciones
    ADD CONSTRAINT puntuaciones_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY puntuaciones.puntuaciones DROP CONSTRAINT puntuaciones_pkey;
       puntuaciones            postgres    false    235            H           2606    18683    motivos motivos_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY reportes.motivos
    ADD CONSTRAINT motivos_pkey PRIMARY KEY (motivo);
 @   ALTER TABLE ONLY reportes.motivos DROP CONSTRAINT motivos_pkey;
       reportes            postgres    false    237            J           2606    18685    reportes reportes_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT reportes_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT reportes_pkey;
       reportes            postgres    false    238            N           2606    18687     autentication autentication_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY seguridad.autentication
    ADD CONSTRAINT autentication_pkey PRIMARY KEY (id);
 M   ALTER TABLE ONLY seguridad.autentication DROP CONSTRAINT autentication_pkey;
    	   seguridad            postgres    false    242            L           2606    18689     auditoria pk_seguridad_auditoria 
   CONSTRAINT     a   ALTER TABLE ONLY seguridad.auditoria
    ADD CONSTRAINT pk_seguridad_auditoria PRIMARY KEY (id);
 M   ALTER TABLE ONLY seguridad.auditoria DROP CONSTRAINT pk_seguridad_auditoria;
    	   seguridad            postgres    false    240            P           2606    18691    sugerencias sugerencias_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY sugerencias.sugerencias
    ADD CONSTRAINT sugerencias_pkey PRIMARY KEY (id);
 K   ALTER TABLE ONLY sugerencias.sugerencias DROP CONSTRAINT sugerencias_pkey;
       sugerencias            postgres    false    245            R           2606    18693    temas temas_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY temas.temas
    ADD CONSTRAINT temas_pkey PRIMARY KEY (id);
 9   ALTER TABLE ONLY temas.temas DROP CONSTRAINT temas_pkey;
       temas            postgres    false    247            T           2606    18695 $   estados_usuario estados_usuario_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY usuarios.estados_usuario
    ADD CONSTRAINT estados_usuario_pkey PRIMARY KEY (estado);
 P   ALTER TABLE ONLY usuarios.estados_usuario DROP CONSTRAINT estados_usuario_pkey;
       usuarios            postgres    false    249            V           2606    18697    roles roles_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY usuarios.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (rol);
 <   ALTER TABLE ONLY usuarios.roles DROP CONSTRAINT roles_pkey;
       usuarios            postgres    false    250            ,           2606    18699 $   usuarios unique_correo_institucional 
   CONSTRAINT     q   ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT unique_correo_institucional UNIQUE (correo_institucional);
 P   ALTER TABLE ONLY usuarios.usuarios DROP CONSTRAINT unique_correo_institucional;
       usuarios            postgres    false    214            .           2606    18701    usuarios usuarios_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (nombre_de_usuario);
 B   ALTER TABLE ONLY usuarios.usuarios DROP CONSTRAINT usuarios_pkey;
       usuarios            postgres    false    214            u           2620    18702 &   comentarios tg_comentarios_comentarios    TRIGGER     �   CREATE TRIGGER tg_comentarios_comentarios AFTER INSERT OR DELETE OR UPDATE ON comentarios.comentarios FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 D   DROP TRIGGER tg_comentarios_comentarios ON comentarios.comentarios;
       comentarios          postgres    false    251    213            w           2620    18703    areas tg_cursos_areas    TRIGGER     �   CREATE TRIGGER tg_cursos_areas AFTER INSERT OR DELETE OR UPDATE ON cursos.areas FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 .   DROP TRIGGER tg_cursos_areas ON cursos.areas;
       cursos          postgres    false    216    251            x           2620    18704    cursos tg_cursos_cursos    TRIGGER     �   CREATE TRIGGER tg_cursos_cursos AFTER INSERT OR DELETE OR UPDATE ON cursos.cursos FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 0   DROP TRIGGER tg_cursos_cursos ON cursos.cursos;
       cursos          postgres    false    217    251            y           2620    18705 %   estados_curso tg_cursos_estados_curso    TRIGGER     �   CREATE TRIGGER tg_cursos_estados_curso AFTER INSERT OR DELETE OR UPDATE ON cursos.estados_curso FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 >   DROP TRIGGER tg_cursos_estados_curso ON cursos.estados_curso;
       cursos          postgres    false    251    219            z           2620    18706 3   inscripciones_cursos tg_cursos_inscripciones_cursos    TRIGGER     �   CREATE TRIGGER tg_cursos_inscripciones_cursos AFTER INSERT OR DELETE OR UPDATE ON cursos.inscripciones_cursos FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 L   DROP TRIGGER tg_cursos_inscripciones_cursos ON cursos.inscripciones_cursos;
       cursos          postgres    false    220    251            {           2620    18707 -   ejecucion_examen tg_examenes_ejecucion_examen    TRIGGER     �   CREATE TRIGGER tg_examenes_ejecucion_examen AFTER INSERT OR DELETE OR UPDATE ON examenes.ejecucion_examen FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 H   DROP TRIGGER tg_examenes_ejecucion_examen ON examenes.ejecucion_examen;
       examenes          postgres    false    251    222            |           2620    18708    examenes tg_examenes_examenes    TRIGGER     �   CREATE TRIGGER tg_examenes_examenes AFTER INSERT OR DELETE OR UPDATE ON examenes.examenes FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 8   DROP TRIGGER tg_examenes_examenes ON examenes.examenes;
       examenes          postgres    false    224    251            }           2620    18709    preguntas tg_examenes_preguntas    TRIGGER     �   CREATE TRIGGER tg_examenes_preguntas AFTER INSERT OR DELETE OR UPDATE ON examenes.preguntas FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 :   DROP TRIGGER tg_examenes_preguntas ON examenes.preguntas;
       examenes          postgres    false    226    251            ~           2620    18710 !   respuestas tg_examenes_respuestas    TRIGGER     �   CREATE TRIGGER tg_examenes_respuestas AFTER INSERT OR DELETE OR UPDATE ON examenes.respuestas FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 <   DROP TRIGGER tg_examenes_respuestas ON examenes.respuestas;
       examenes          postgres    false    251    228                       2620    18711 )   tipos_pregunta tg_examenes_tipos_pregunta    TRIGGER     �   CREATE TRIGGER tg_examenes_tipos_pregunta AFTER INSERT OR DELETE OR UPDATE ON examenes.tipos_pregunta FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 D   DROP TRIGGER tg_examenes_tipos_pregunta ON examenes.tipos_pregunta;
       examenes          postgres    false    230    251            �           2620    18712    mensajes tg_mensajes_mensajes    TRIGGER     �   CREATE TRIGGER tg_mensajes_mensajes AFTER INSERT OR DELETE OR UPDATE ON mensajes.mensajes FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 8   DROP TRIGGER tg_mensajes_mensajes ON mensajes.mensajes;
       mensajes          postgres    false    251    231            �           2620    18713 /   notificaciones tg_notificaciones_notificaciones    TRIGGER     �   CREATE TRIGGER tg_notificaciones_notificaciones AFTER INSERT OR DELETE OR UPDATE ON notificaciones.notificaciones FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 P   DROP TRIGGER tg_notificaciones_notificaciones ON notificaciones.notificaciones;
       notificaciones          postgres    false    251    233            �           2620    18714 )   puntuaciones tg_puntuaciones_puntuaciones    TRIGGER     �   CREATE TRIGGER tg_puntuaciones_puntuaciones AFTER INSERT OR DELETE OR UPDATE ON puntuaciones.puntuaciones FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 H   DROP TRIGGER tg_puntuaciones_puntuaciones ON puntuaciones.puntuaciones;
       puntuaciones          postgres    false    235    251            �           2620    18715    motivos tg_reportes_motivos    TRIGGER     �   CREATE TRIGGER tg_reportes_motivos AFTER INSERT OR DELETE OR UPDATE ON reportes.motivos FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 6   DROP TRIGGER tg_reportes_motivos ON reportes.motivos;
       reportes          postgres    false    251    237            �           2620    18716    reportes tg_reportes_reportes    TRIGGER     �   CREATE TRIGGER tg_reportes_reportes AFTER INSERT OR DELETE OR UPDATE ON reportes.reportes FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 8   DROP TRIGGER tg_reportes_reportes ON reportes.reportes;
       reportes          postgres    false    251    238            �           2620    18717 &   sugerencias tg_sugerencias_sugerencias    TRIGGER     �   CREATE TRIGGER tg_sugerencias_sugerencias AFTER INSERT OR DELETE OR UPDATE ON sugerencias.sugerencias FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 D   DROP TRIGGER tg_sugerencias_sugerencias ON sugerencias.sugerencias;
       sugerencias          postgres    false    245    251            �           2620    18718    temas tg_temas_temas    TRIGGER     �   CREATE TRIGGER tg_temas_temas AFTER INSERT OR DELETE OR UPDATE ON temas.temas FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 ,   DROP TRIGGER tg_temas_temas ON temas.temas;
       temas          postgres    false    247    251            �           2620    18719 +   estados_usuario tg_usuarios_estados_usuario    TRIGGER     �   CREATE TRIGGER tg_usuarios_estados_usuario AFTER INSERT OR DELETE OR UPDATE ON usuarios.estados_usuario FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 F   DROP TRIGGER tg_usuarios_estados_usuario ON usuarios.estados_usuario;
       usuarios          postgres    false    251    249            �           2620    18720    roles tg_usuarios_roles    TRIGGER     �   CREATE TRIGGER tg_usuarios_roles AFTER INSERT OR DELETE OR UPDATE ON usuarios.roles FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 2   DROP TRIGGER tg_usuarios_roles ON usuarios.roles;
       usuarios          postgres    false    250    251            v           2620    18721    usuarios tg_usuarios_usuarios    TRIGGER     �   CREATE TRIGGER tg_usuarios_usuarios AFTER INSERT OR DELETE OR UPDATE ON usuarios.usuarios FOR EACH ROW EXECUTE FUNCTION seguridad.f_log_auditoria();
 8   DROP TRIGGER tg_usuarios_usuarios ON usuarios.usuarios;
       usuarios          postgres    false    214    251            W           2606    18722    comentarios fkcomentario107416    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario107416 FOREIGN KEY (fk_nombre_de_usuario_emisor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario107416;
       comentarios          postgres    false    214    2862    213            X           2606    18727    comentarios fkcomentario298131    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario298131 FOREIGN KEY (fk_id_tema) REFERENCES temas.temas(id);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario298131;
       comentarios          postgres    false    247    2898    213            Y           2606    18732    comentarios fkcomentario605734    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario605734 FOREIGN KEY (fk_id_curso) REFERENCES cursos.cursos(id);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario605734;
       comentarios          postgres    false    217    2866    213            Z           2606    18737    comentarios fkcomentario954929    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario954929 FOREIGN KEY (fk_id_comentario) REFERENCES comentarios.comentarios(id);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario954929;
       comentarios          postgres    false    213    2858    213            ]           2606    18742    cursos fkcursos287281    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT fkcursos287281 FOREIGN KEY (fk_estado) REFERENCES cursos.estados_curso(estado);
 ?   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT fkcursos287281;
       cursos          postgres    false    219    2868    217            ^           2606    18747    cursos fkcursos395447    FK CONSTRAINT     v   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT fkcursos395447 FOREIGN KEY (fk_area) REFERENCES cursos.areas(area);
 ?   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT fkcursos395447;
       cursos          postgres    false    216    2864    217            _           2606    18752    cursos fkcursos742472    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT fkcursos742472 FOREIGN KEY (fk_creador) REFERENCES usuarios.usuarios(nombre_de_usuario);
 ?   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT fkcursos742472;
       cursos          postgres    false    214    2862    217            `           2606    18757 &   inscripciones_cursos fkinscripcio18320    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.inscripciones_cursos
    ADD CONSTRAINT fkinscripcio18320 FOREIGN KEY (fk_id_curso) REFERENCES cursos.cursos(id);
 P   ALTER TABLE ONLY cursos.inscripciones_cursos DROP CONSTRAINT fkinscripcio18320;
       cursos          postgres    false    217    2866    220            a           2606    18762 '   inscripciones_cursos fkinscripcio893145    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.inscripciones_cursos
    ADD CONSTRAINT fkinscripcio893145 FOREIGN KEY (fk_nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 Q   ALTER TABLE ONLY cursos.inscripciones_cursos DROP CONSTRAINT fkinscripcio893145;
       cursos          postgres    false    214    2862    220            b           2606    18767 #   ejecucion_examen fkejecucion_455924    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.ejecucion_examen
    ADD CONSTRAINT fkejecucion_455924 FOREIGN KEY (fk_nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 O   ALTER TABLE ONLY examenes.ejecucion_examen DROP CONSTRAINT fkejecucion_455924;
       examenes          postgres    false    214    2862    222            c           2606    18772 #   ejecucion_examen fkejecucion_678612    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.ejecucion_examen
    ADD CONSTRAINT fkejecucion_678612 FOREIGN KEY (fk_id_examen) REFERENCES examenes.examenes(id);
 O   ALTER TABLE ONLY examenes.ejecucion_examen DROP CONSTRAINT fkejecucion_678612;
       examenes          postgres    false    222    224    2874            d           2606    18777    examenes fkexamenes946263    FK CONSTRAINT     |   ALTER TABLE ONLY examenes.examenes
    ADD CONSTRAINT fkexamenes946263 FOREIGN KEY (fk_id_tema) REFERENCES temas.temas(id);
 E   ALTER TABLE ONLY examenes.examenes DROP CONSTRAINT fkexamenes946263;
       examenes          postgres    false    224    247    2898            e           2606    18782    preguntas fkpreguntas592721    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.preguntas
    ADD CONSTRAINT fkpreguntas592721 FOREIGN KEY (fk_id_examen) REFERENCES examenes.examenes(id);
 G   ALTER TABLE ONLY examenes.preguntas DROP CONSTRAINT fkpreguntas592721;
       examenes          postgres    false    226    2874    224            f           2606    18787    preguntas fkpreguntas985578    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.preguntas
    ADD CONSTRAINT fkpreguntas985578 FOREIGN KEY (fk_tipo_pregunta) REFERENCES examenes.tipos_pregunta(tipo);
 G   ALTER TABLE ONLY examenes.preguntas DROP CONSTRAINT fkpreguntas985578;
       examenes          postgres    false    2880    230    226            g           2606    18792    respuestas fkrespuestas516290    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.respuestas
    ADD CONSTRAINT fkrespuestas516290 FOREIGN KEY (fk_id_preguntas) REFERENCES examenes.preguntas(id);
 I   ALTER TABLE ONLY examenes.respuestas DROP CONSTRAINT fkrespuestas516290;
       examenes          postgres    false    228    2876    226            h           2606    18797    mensajes fkmensajes16841    FK CONSTRAINT     �   ALTER TABLE ONLY mensajes.mensajes
    ADD CONSTRAINT fkmensajes16841 FOREIGN KEY (fk_nombre_de_usuario_receptor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 D   ALTER TABLE ONLY mensajes.mensajes DROP CONSTRAINT fkmensajes16841;
       mensajes          postgres    false    231    2862    214            i           2606    18802    mensajes fkmensajes33437    FK CONSTRAINT     �   ALTER TABLE ONLY mensajes.mensajes
    ADD CONSTRAINT fkmensajes33437 FOREIGN KEY (fk_nombre_de_usuario_emisor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 D   ALTER TABLE ONLY mensajes.mensajes DROP CONSTRAINT fkmensajes33437;
       mensajes          postgres    false    214    2862    231            j           2606    18807 !   notificaciones fknotificaci697604    FK CONSTRAINT     �   ALTER TABLE ONLY notificaciones.notificaciones
    ADD CONSTRAINT fknotificaci697604 FOREIGN KEY (fk_nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 S   ALTER TABLE ONLY notificaciones.notificaciones DROP CONSTRAINT fknotificaci697604;
       notificaciones          postgres    false    233    214    2862            k           2606    18812 %   puntuaciones puntuaciones_emisor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY puntuaciones.puntuaciones
    ADD CONSTRAINT puntuaciones_emisor_fkey FOREIGN KEY (emisor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 U   ALTER TABLE ONLY puntuaciones.puntuaciones DROP CONSTRAINT puntuaciones_emisor_fkey;
       puntuaciones          postgres    false    235    2862    214            l           2606    18817 '   puntuaciones puntuaciones_receptor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY puntuaciones.puntuaciones
    ADD CONSTRAINT puntuaciones_receptor_fkey FOREIGN KEY (receptor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 W   ALTER TABLE ONLY puntuaciones.puntuaciones DROP CONSTRAINT puntuaciones_receptor_fkey;
       puntuaciones          postgres    false    2862    235    214            m           2606    18822    reportes fkreportes338700    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT fkreportes338700 FOREIGN KEY (fk_motivo) REFERENCES reportes.motivos(motivo);
 E   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT fkreportes338700;
       reportes          postgres    false    2888    237    238            n           2606    18827    reportes fkreportes50539    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT fkreportes50539 FOREIGN KEY (fk_nombre_de_usuario_denunciado) REFERENCES usuarios.usuarios(nombre_de_usuario);
 D   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT fkreportes50539;
       reportes          postgres    false    2862    214    238            o           2606    18832    reportes fkreportes843275    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT fkreportes843275 FOREIGN KEY (fk_nombre_de_usuario_denunciante) REFERENCES usuarios.usuarios(nombre_de_usuario);
 E   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT fkreportes843275;
       reportes          postgres    false    238    2862    214            p           2606    18837 '   reportes reportes_fk_id_comentario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT reportes_fk_id_comentario_fkey FOREIGN KEY (fk_id_comentario) REFERENCES comentarios.comentarios(id);
 S   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT reportes_fk_id_comentario_fkey;
       reportes          postgres    false    213    238    2858            q           2606    18842 $   reportes reportes_fk_id_mensaje_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT reportes_fk_id_mensaje_fkey FOREIGN KEY (fk_id_mensaje) REFERENCES mensajes.mensajes(id);
 P   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT reportes_fk_id_mensaje_fkey;
       reportes          postgres    false    2882    231    238            r           2606    18847 '   autentication fk_autentication_usuarios    FK CONSTRAINT     �   ALTER TABLE ONLY seguridad.autentication
    ADD CONSTRAINT fk_autentication_usuarios FOREIGN KEY (nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 T   ALTER TABLE ONLY seguridad.autentication DROP CONSTRAINT fk_autentication_usuarios;
    	   seguridad          postgres    false    242    2862    214            s           2606    18852    sugerencias fksugerencia433827    FK CONSTRAINT     �   ALTER TABLE ONLY sugerencias.sugerencias
    ADD CONSTRAINT fksugerencia433827 FOREIGN KEY (fk_nombre_de_usuario_emisor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 M   ALTER TABLE ONLY sugerencias.sugerencias DROP CONSTRAINT fksugerencia433827;
       sugerencias          postgres    false    214    2862    245            t           2606    18857    temas fktemas249223    FK CONSTRAINT     v   ALTER TABLE ONLY temas.temas
    ADD CONSTRAINT fktemas249223 FOREIGN KEY (fk_id_curso) REFERENCES cursos.cursos(id);
 <   ALTER TABLE ONLY temas.temas DROP CONSTRAINT fktemas249223;
       temas          postgres    false    247    2866    217            [           2606    18862    usuarios fkusuarios355026    FK CONSTRAINT     |   ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT fkusuarios355026 FOREIGN KEY (fk_rol) REFERENCES usuarios.roles(rol);
 E   ALTER TABLE ONLY usuarios.usuarios DROP CONSTRAINT fkusuarios355026;
       usuarios          postgres    false    214    250    2902            \           2606    18867    usuarios fkusuarios94770    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT fkusuarios94770 FOREIGN KEY (fk_estado) REFERENCES usuarios.estados_usuario(estado);
 D   ALTER TABLE ONLY usuarios.usuarios DROP CONSTRAINT fkusuarios94770;
       usuarios          postgres    false    249    2900    214               }   x�3�t+J�K�4�4������ITH���WH-.I,�4202�50�54�rC���BUC�������)A���Sb�T��^b����4�f��7���L/M�150�4ER��[����PlR���� 0�@`         k   x�s�L�K�L,Vp:��839���N?(5���8�X�371=5/�H���/v,JM,�wFסW����T��Ztxm"A��B��d��a3TX�IQ>a`U`�1z\\\ ?�X�         �   x�u�Kj�0�ףS�.cٲ�nhHZ���J�{�
;V���'�)|�j�IW�Y|���y��dFKSkM���%��0m�?v6D��
3,�W,3��5�px����;��o����2j��X2���r�ȯѻ����>#Ҩ*c�a�*���j�z3u�/x6�K�g���c�b?TP�C�$)��4ˎdR�4_"ǉ\ݜD�'�o��9���,���L��G����qt�p'��7l�            x�KL.�,��J͋O-.H-J����� ]@�         4   x�3�t+J�K�4�4202�50�56�2���L/M�150�K��Zp��qqq &v
{         �   x�����0���)jg �D6�$F݀�
��R���b���,�Ht��.���hc�.C�͸����Gn��	Ɨ��|�%(}�#4��Ȫם�ݎ��Q��&㠡�ȶ�e;,���F)e4Z$���屨;ś��g�f�J�@)�,s���%������c]IE�Rt��ĝkSM�g���kW            x�3�4�4204�50�52����� !|         �   x�e�;�0Dk�{)�T���@)hh֎%,m���C�� ዱ�@ �ռ7��R�šL��H�wP&g5B0q�&&��1�;���٬���s}{m.7b/2A>2I�s��Bכ���`Pk���wʚ����RE6�t���)��A_�Ջ.+�;dU�s.��X9Ϥ�/HCT�         t   x�32�42���KO��L-:�6Q!%U!8?��<�(�����$�X��{xaIfrb1gP�)��J�؀�Ȝ3,�(%$k�9�&e���̰ T��8� NP~V������ n/%         M   x��=�+�$� 'U!9?O����D�������D._�\8��1)3�H��d&g���($%gd��s��qqq ��%q           x��TM��0=��UOu<�vDA	-�@/VZeS�z��U��"~=v� ��(�H�����Ð}<��6���m!��=�_���E�� ���(�d���$Y�^�w�,j��#ۇ���U=��������l\vk�����hD�$�BRa2��x����|��D�y!6�q�"C�E޸�F��Z/w!�"ϟ]��,~q{W��W���q3�=>��m}����m��\����ۖ7T��k����5�����>��E|S���w���@@��`�v"`Y���L��_���ۆ�zI9�\��uuZ��iy��y�o�:{��R�]��î��O��R8��jl(QX��d���*l
.���˨�/*tE�ͼ��֍�-��Q:	�W��.���T�#�8���x��P9�a����E�L�O��7�I��j-u`s+�ffص�Q���0�|n��
�¢��%D��$-�/���q�ũ�����ē#�P��j�%b8I#q���o�Q`�            x������ � �         1   x�3�t+J�K��N���4���M,.I-���L/M�150�4����� ��
�          H   x�s/�/N-�L,��OK�+N,VH�Q(-.M,���
p��r��+I��L�W�6� �JI-Rp/*-������ !@�      !   �   x�e�;�0D��)�GA��RD�D*�h�x��7��'�"(کF��� �`���{���B��}"�,�N�N=RL�=a;d�7;�B�P"�2��8�1�qE������e�;�z�f�%��z:�[��Ooxe�H�����}q=ֺ�B�n�6��n2����b��,�UjM�      #      x��}�7��o�)�ؘ?�%���3���x4�����@(��Vw�m��Ğw�G�g�; I5�⥋l%���cZ�"
	|�e&2�#T�>R��'`�Ğ��!���^|���G7�?\�f?��W��.Gׯ�i���>��ѫ�����ӳ'Oo.b^�7i��=yz}�&]�>�K�Scu>�AYT5)q�P���=+��II�`���R�h��4ټy5�<�{�W�Q����]ܜ�O��F�>^ξ�FWi���ć���>䯕�n.�o��j72x�_gQ�ך�y�ë��m���|[��-q�^_>w:���0L�m?��������].���7ñ����t~>����~���F����o�e���ޱ�ė�烋q����j:�-�ޔ�~La�v�.�/_��y&�K�1��2H�{7��y,_����fV�u�s�����My���������ɽ~��W)�T���=����Y7ce����?|��n���)6\�������.C|��%���З�Z����p��Z��?�������S롿��%��7�I��\������]�	K}�S���;$���
�F�W�b����3���?<�&}q���`�ԍJX;�<4�I'}�.���Qۆ1��U]#h�A0y/'�?:��[l�F> �s�g�*����|�	�����'�P��Mz#~Y�
���݈���[��O_�o^|���۷?��󛦡����
j��9�Ⱦ�o��&;H�Sm$+e�'ZL�bm6'����O�ST�kH��n:�L�J4۝)�\��A�D����Ⱦ�&�F���,9��:�ݸ�cw����i�����ͷ_�߮�z�����]"چ"+R�!.�
�	��@�*f�ɿQy�b����G��SP�%�r�ma[����1;s�&|�?�G�����p}M��ݲ>H�RF�nd���揟��V�6������d�����ƚ"�C�ؠ�H
�h)�L�$:x!Қ���v�k�~�d|4?���C��j���V:-���o���s{D���W��������υ��	��H��q ����7�T��s���[?�mb}:{��j��3r�:=)���O���I��ӵ�����.>��=>S��p�*Y/ЂnOH�I�t��8�v3~��r����/|�'�q8��Xa�jl@!��֫d�!k0`��y�=)�̡��@1ӆƉS�f����j���I�Vp��,X�Y#��~X��xg�	�����'���_%����T�����P호�X�Ĉ��d�{q�F��D45�G�} ����� >��5�# G�H�YÊ1ޏ�Gяb��U�.4/�z�) �f/4��E~�G���+�mX�ݠ�����|�?��S>�U99�&� �o��g�u�3�����3<:�=��ɮ8F�B����j�uN�H�x�:36���
����G�vav�o�l �%7p�JA;��L7��}h�&�_�M��X+�+��"l��y�sYix�{�L���]����j�9~�j����/�����N"�A�M��u@�k��@�6�֡��� )���je�c�G��L�t�z�n���������
N�<MAFZ�ُk��v,x�0�$;��&�/��� ̴�^	VSd'�h�*,�u����u:kF�����3.s*���c�[���$��8պN�BR�׵u�Jź	&p��X�(��@Ӹ�1���M�?�o^�5�QG�S��+9��-�HU���^�~�M�=�����Me�`�j���?�#����W�{'>�3�݄�~H|��#�w �;�oL;+�τ+2�ҷ������z<K�H,z�KA���I�y5��&�矙σOt�u?;x�˞�ck�15!������q4�����/����0h�cv�t0dc�R��]1{}�g#<�A��s�G���c�(�l{6iZ��Ҟ!�!��ee��W�mh�R}%l�hg��	�T�?����f-��f�ЋV�۸�z�[��s9h,�Ne'/k��q?E����ﯿ�T�?��ƮZ�r=&���7u�lD�x�������d��H&f���:�3`���y��y��%) ҕ��e	�'pR|�5*����)�\�Ev�v^6@{�R���_ ɯ��J�5`�p]��?���*p94��=T٦i�0�(n�f2M��A̡�u���Q1$�m��$HZ~�.�Fj?�N������ʝ�<3���������U�mv_���$c� ?1����m҂{���u�?�7�!�BA��鍄31�G��ίq��Ɣs���k�9"�uI9+5���L)�B}�@�X��vu�m��DW����=�|���'����A�#|��>#WQƩ���̈́�]��@1���s�m0�����EM0�H�F�I9�m"tYY �<�#%�+��}H�T�9�V�F0��!�{�����wP������e|���<&K����xE�Z0�dk�,�&U�AP�XU�VmȊ��2�X�4 ��q|w���P.`�BVsV��n�:&R�b9A*��m)�M-Q��OM�j�&PR����h�3�J��ߒ�q}�hRR�V�n��fŨ�xf,Յ
�m��XW�l���X��70�5�U� 6ڇ��DgHǐ@;Ɂ?�w��Z2�r,V��!9~1�C(���������?����.�G����1TցQ;n��L�ߦvш�;�&�%Pʘ7�Q��UZ1��gp37M*5w'�?F�G(��NM��C�n�{\��R�?�~� ?�#����ᛖF�*��@i	�0�W21�%bL��&�6:���򔢫]�ɑ�(�"��'�O`E�g��yhZ�C����m-Kg���'�x��E�#|��b+�Z��,�H��E��h���y
I8&N��!gcבּ�+m�f�D^�s}r`|Z�?�������S+�P: ɳjC�l��js��bw���}"��T����U�3��ץ0��_^� ����3��*!���J/XY]�5���E�H�hG��^S���x�dud���^yp"t)%2����_�3g�* �rȔ3cҮ|\�\ET{�Ɏ=;����1��P�L�A���B����@j<QҺv	��3^Qh��6&r��C5u��D�l�l��&���(q����t����6��u����~��]ľG`���a{��G���.G�1�V}�q֋��u�wS�%#�˚�R�<x�1��������=}�-e�ǰ�ʡ�>你�[�.���Bi����'�h��n��ᛶF`9�E[R��%��ht����x� S�|MR!{E�k�PR�=hb͒uez�������RhzI�sˢ��N�����'�x��E�#�vnYL9��$�TK7dul4K�PKF;醤Ί����V���:6B݀O���tt'k��+����Z�yf�gJW��'�/ϼG����~]�/���3�rL/�V�I9�Z0�䵲�r&[��a�=^+w�VR��B)ѕP�d&\6�6�MS��P��׍I��2%�r�~����.\g"��V%.��#3o�����_?���֌�(*;��S�\�l��T&R����B���i�֡�A$%�3^ݠߛ�j+@����Bz��n�eMA�l���#j��:�AQS�qI��F	+�s@"���OPd��syH:�6�93z�Aw�����Ol~�l�����,�1iö�Ue@�����vAkFoE&o��l�,�Z��8g�5YtL��eP�U���*mwN�X�*��lH2�e�h�����R�q��}��~��Mw3��o`������e- [Y��Ǣh�{/����Z\�Zs�R��?��\U[���� ^�hkR��j�QJ�:�$��x[�!yݶ-��DoXso��GX�X���Է�tF���:P�S+ֻ�i��ֽ�
�#pV9U{��-8ž����Q����Q��		�&�p���O�D p���jC���n�B�z��!h7d�ʼ#G��>�bO�?}�a �  ��8�Fu�茸"D�����Q״�e?��~N؞d�5��s|��1
��3Q��"Q�"aG��F�`Tbb�]���4���&4ѣξ©�����&Vl+-��#�ŬX)',U��+3�neŸ�ز��&r'+�0ןz�wzM�2vY*��K2A�n0�Jd4�F��9�\C	0I�)���**�U��P������t�cXay�z��-x#�S���oj�?����T�?�7�
!�Tv:��6N�F[�eė}�
�`�&&�)%O�O��y����u!z����c\��wPR9><(��6���r9��L�5<^��1N.�nG���V�H���
�2���^����8-du��M-#TT%� z73p;��|�5*����IM0�>4Ay���N:��%j�{ʾ�#[<F����80A	�!����l���r� �`�VN��&X��:��;��������;q�ܺ�-�,��A����x� ��U�=�����7F�Td/_v�)��C]C�m��*{�k�TN���["������I���nb��/^O�Yk���A����������;l�D(Q��)��B�1�J&��^lA�ҏ�h��lR�S�-ʦs�o���H�cyp�2$��ik5.*S��xq���	��@&6�7uB��5���+oCI�i����[�ҸK����O��c���@o�ro�9��/z\ݔC]��`�C�'9�w�G*�L|ى�Rv�:ou^������w)�G��g���H�gߌ��~�γ/�(kr����O7�4[4uu�zZ4�Z��8{��C�*ٸ!��qY�� �m����ȵ�!*�=�ڒ��qeL�;�?��wؖL�d���J��d�-7D�bc���|���m�L9lDL�N[�᝴*�|�+�ʩ�G�"� ��R�*;���曶d���rUlג�ICv�!)U%�e�v\�.'Ɋ+��Q��j�jl����$�@A[4(���CW2m	�-����RFұ�?�E�3�
r�d�}��-Z�~WYS�܎|֤%��<k��� �Ϭ��C��\.���,?��)�re ���Hն#L��>{�[�#Pm;�ۑ��Z�]��M��� ,q`��i�@�m�.���2�Ug |�؆���hƑ�Xx��gmю�q�,f?�.Z�gָ-eW�2$]��C��9;"%K&�2	�-C���Ւi�dK\#���-Wl�α�yR��'.�h������>��ص^LP�mo��K�3�/IM*qH�֊���� ���y� �3m�{k�����҆�v���oR@zlhP����άٕ�N֙� =Q�X��(k���8��������g����߭L-D�N�P�K�d�,(�:{�,��&:�2,�M2B^��>w��4
��Ձ�<��|e�����ſ��Kɇ�^�!�;�TF�Ӛ�5]=PY�9Ɠ�'e�\W,�M��i����S0�)��[6�a@��aִ����A����,}f	$���+�Az����Y��;/=O9Ҷ92�d��
���dm�ɅB��1���0Ϛ��g������tM5N�-[p�{."*^UK����˕л9!�O/��_�>��o�p5��+�i�w����t�L �(!rT��DY�lm�R��sI�*�b����<H'd>�
�?vBH����j(U�19\��mR�����-'C�K4Dw���6D+�+��f7Ct��w���?�$�����]���r���I`���)$QY�BJ�V�t���Y+	��%D�h���<��m�����N����C�R�;�Yk'[�> ;��jRN���rc�v@�n�M�u�{��x�%2y�r$�eK�j�TD�ʰ�����-酖&'��B'���`����\�5�n��+t�n�Z�lڗ[W9a�\�0i�U�%}F��X�eKs<��P�c�%OI���8LW������s��w�w���ڭ�z�i�\w^���-�}Y�c����sNm�X}�!�v��cK�mŤ�sE_����S�m���:�:��.�{�,)�>��͆x���G�FU��bm�0����8�K=ҭ	����F����mr��ۣ�u
d>�@f�Gv�8��_���6�E�
�R����e>��;��Ӟ؝z��{�ס�b>�v���M�Z˽Hy[�&�ݏqnB�}�~l��ݼ�-'���n�Gp����?+�7U���O���G��#����eZ{�
������Y��5���XuΞ	�r�e3Th�}Fe�C�Օ���+�h;�O[ҭ�J!-� ��kɴS���V�pۅtb�-AY��v�mЁd[:�ΞtW�����J���S����sh�Ez����Y��;/=L�jYz��dd;Ww��k����Y��;/��`NS[z9C��e��N1wJOj[���]+楟�M�2��ױ��L:H�Jo�J�y`祟:����Yzva��`_��������wmz^z3��m�J��Tֈ�^��Az�Vz�M�-v^z;�~�v�6$,ts:HO[JO���]v^������x�+8�Ϲ������~����2M��^����ܙ-^I�O�m��h��y���,���E0��r	K���]��q��v?�[n[���p�c���rw�[�������,V��툔�����H�e�Xs����w-#n<[e˕�M'�,K�����r�:g�ˈ��dC�%TvoH��Oa^Ѡ�fF�.�j�<?��L��ú*`�b�/н���O>��*����^Q��8�i�n��k�E�o4X�P�9Ҧ��������	)�ӵ�����>�!~o���(���D��Ng��k��UM�g��?�z��5%sO9�/{��s��NS���,�DG�^؍o�mn1�F˝~��YW�<�Oޖ���?�u���m��'8]�8X�Np4��x���#2����g*�<���`t9��jvB�=2y��BSH��ʹm���qk�퓏�$�Ӯ<&�_�>^#�|��j��ca��������ÊpĶ�g��d�p�q�B���JK����J�2�^����erm��8�d�|����A'G�U-A2���X�r����(��"�db)���7ޞ��e��� ͒ͻx51{Sj��~�':`\3���͓833��_��
�u�}�領?z�ɿ�{��{�������b#�<�LFl��VkL���e㶐���7�q�&z<�!��ח��}�{�W[h0�;-��.�L���C{?��z�Jw�r��	��OY0^̖"�̓�ͺ�'Q�z�����b�-���*�t���jI6�#������h�lM�^�Z�2^�X"���C��b�u�����ը�OSHW�����ӹ����t�R�Ȇ�l=L�a��˹։���0e��(���>HsVך�(Mv�[d��GI��I�ƒ�}���t����ͅr5,��u�1�Y�څ1��L��*����Vn�������OF���_�p}}5:{�����t}���o�����o�ʿ|�F�U�_�^^<��}f����0��oh�E�^��ÿ�]]�~6L?J,���_g����5*�9��_��ӅA^\@Y��P��P�+m���=�����!�|�V0���f������F������� ^���_������i��D���TU����#a>��_?��8�M�> ���E�h4l?���)��N��a�sT9w��� eS���2ì�Ͱ�0�E Z`\$��K��3l7��m��=����6�/��
�f%	{�a�ö���K��ů��W�����f�]�`&Y�{�B�5sOj����1���m�r�:Ѹq����o% ��i����.�N;��9F���� ��o�A�˃D�B���o�A��T��V۽�g/^���:�%.Q�#Ͳ}�����(M�ǣp*��R+F�T�";�^l��hs�:���A��+"��pG>k��5��X ?F�+��	�~<���#p�Y.��G�r�9��S�k�����X��k�de�HgY�~�d�9���m��;�Cf�gm�ï�m�N�c�U۩,�;�������m�ʱ�K��q:��UW[j�~����Ǐ�?���      %     x���I�%���U��(A28��`HC>�79��w0�dC]�̢Zd�G>2��?H65������Q�=�Q���o��������F~!��0xQ���c�*~��^�{@�$��O�6n����䘧"�h�I��S#��4/"<�)������cg6}�)"�ԟ�e�ZQwc*�19�E����s�+Z����J�2߳�[� �E���Ǵ���qe3���1&���bF�+[�ў����v	��a/��\�z"��6�F�&?ٲ��R2d������@༉P����ʆ=� Ƅ�iX8�� wc������7$Ð�˵?G��͋O1��7hㄆ�/�<.��M�#�%�ԣ���C�b޲�KHOc�&�&�;L����1R�<�@Ex�?�����JX	SІ<l0���b>�0*T�=ڥX�l� �D���.�sl!7��'�uXfGƚ&����K�\&=���?-�tE��0N��x�v�;��VfT{���Cޡy�D3m��I���!���c��'�28sY�z�(�`�|�{2e�9��-πW�?����q=�}H��YG9��#���O��>N�/G�h'�b�bh��N� "����HK>��LiwGV"�!��h�k��01��௟��xe�d�nH�4�z	̢�/��\��g�P�=�� K���N"�	�$� ����$���	R��I���xgh�%(I�N"�6"���-WO�vS���Ö;A��.��H��Ty�ph�v�yQ�"�c���=�MI�fqa��Ӥ���%�IB�Ӥݴh{<�1�Sx�pӢ�����<ޠݴ�he&-$O��ED[09�F?��M���19��{D�i���h`B���b��%4�5W��E�M�]cR5wU"�ZS����*ELz�O��<�!w�";�8ӈ�D>���h��}2O)%��I�������NJ�.Kx�R�RwR�Eck�=,����;)Ѣq=��I�P˅�m���ah��Z')Z4*���o>���h�Ʈ5s-�i��.;�%���G�}C4�h'1"��5:E��M�X��f�!���t���q&���Y<�v�y�f��@��>̼���Z����s\	B��G����=߯��"��R+��
���3g�y0��S����[�9XJ�=��T	V��=u����*��3�J.�z"���v�'�*57dWMrj��Aj2�t�$�@�m8�dWI
\hl8�HxB�HD��U��(?�Q�������_��������_m4�kIF�0d����W=a�dG���xFg
{f�*�����%Y��}���.A�w�>���̬{��PR+vւv؂�e������Ά+��,�{2XrM9î��q䫈�%O��H����"��
���� ��J~�pC5O)��<��}��C�G�ZQ�UxO6�ZM�1T��_��KS��Q�]�#��
o�TX����$�)LY�UyI ���B�l�L�ɟExOV֤b�Ϯl�QD���d*��J�����Y��d{�b�1�k�ֺ��*y��u��6H��Ȑ�Y��d�d�x�c��3ڦ5�q:,	-E����}��Hv� �eE�{\�3�K�a�gY�T��oYREy�"�I���������`J(��I0$��6:�Cս3����j�p�0Q �c����N�H���R���i}�R���+-��Y�WaF�i�(ǌ�5h;g������-��e-������Űm]��Hv� �6#Iɩ<�n���B���o� Ɇ��Ű�R���F�N�c��8�u��և&^׺�\�9B����Y1̑gz�C:mM����j?��I����$A�AGξY_���X�}ޣxeSE?�M� �I������mހ�cc1e��}��3)��$An�Lu�!����b%"by�N��A�Q�Hv� ��uWրy�Wڲ��>H�]B�r{g�I�Ҟ�F]'�q��|�f�ܒ!	�1�b�(�I�򴹶
J���'�$�@�|��&N�<X��K;V㾶-�(7��~�;�I� �����I���+Z2꺊�}��l�W�h� M=et^��qҥ�Z�B[t��1v�fI��Q��-I��d'a"��&Cka�1���M���1D]]tG�F��q&�1��+ʯο�H�TM������ʆ1K�%o���_�<j����\�&߷���Da5i�eq;����0�����hP�($Kl[I���Ȃm��N�4�����p8י�|�'�nE�[������2�Z���"r&���i���G��]���d'e���A!���d���ЖI��Q�99��!-A�Sm46�0��9�ݸ,[������x��6$�HОrLU�R��Ȗ�,�q$��G�v4� ��Hv��u�i[W��5|��)����t�3_�ߗ������3fdv�|�)E��4O��N4G���K�"���Qg�j�`�9�u�SX��m�1�w����=�Nbff� �ۢ�W���mڧ�H�}(��ߗ�I�j���qr�y��m@�,�޴M��A#�"�����E�ǘ ׍T���V��U֌!�cWɈB����-��谏]��n|~q���կӚ1�-����$cEX�虐�qC8����Pt]���/�ܓ�gR�*����Op>�
��K�������]�ko"��[v��b���R��dE�)a_�݌�}���*<e�u�rv��ߘ	(�kS�Nր��Ĳ,�I�EH�NK$Թ�F��I�:2�#K������&����s��<�"��)�?q��7~�Mp�3� �l��.�xA�$8�v�)'��YS����`��6�p��:F�y���z��
m7��;|��Lѕc���7�~�/�$����rmH��M�P'�!�X�����O�T� ��o��v�X��5R��T|R��Ƣ��(� ��p�\	˗�� ���g|�`�_�Yx�t��1_�riPR����uKd>�\N!�������^����:�`�6�E�.��/~�e)a�lOض��x"��.R=_����O'�%NsV�h��}ڣ# %�5�FL�q�z��wX�˭�����K���%ad��E��^�`]!��>	{v�����%�����Їq��zA���;����}%���L�=��O1�KK%�<��ow?���O��i�xDE�|���c��˥�Mɣy�:���Z�{K���^ɸL�Q�=�b��	_���>�}}�,��h��!NGL�_��y"��=ϐO��7ФU��,.��軲��#��m��4�����]��	K5����w.
�(�0¿x���٠��48-!޷#hf�1�%UARG��4	`�����O�	%�\��:Ů���&�fy��cݡ������Q�"����>q�I���vT7%#U��lr�
��`�Ҫ��D'�^�����
�h��<&�d�>�7!Y�Ё!6(������4e�ω	?�/�Ҁ�w���]�*{|`�w�Z����Vg}4��\]7�YN����7?h�a30�5���{��b�	�'<m�Y���i���+Nh־��{��Oy�      '   �  x��SM��0=����[͌?��J-B��mۃ���*M�$]���1�Ni7�
qY���yC���|�?�fY��eyؑ����_�Wˬ]-_��O��n�����S�5ݟ����_�w��o}���[��+�3!=���6Y���X5�%,@,'�-@9r�����=˲�n�8� $�V��H�B:L�uu�E1`�<�b�"P)��*bd(��zG|GN�#݅���=���ř�LR�4�4&J���&�O�Ӕ�$\Y.(�`$�Ix`3�5L*
�4E���-oo�����1�6��}���}�q�o|U5W@X5)�(B��k�tߧ��I9S����Ǧ.��n�*�X�4��'�^v��ͱ�3P������� I�;��#*%��ߊc ���{_��b3p���I�#-�"���`���f���T�      )   u  x�}R=O�@��_�U��cs�TF��.��td`bc��Nڒ"ĐS|~~~~�꺺��Z����0:��m 3��]�-%
�i��P ݌����4~�-��p������ՉrG�D@0�ԂZV��P(0�:C,IN}�#�鼪6����,�;7~.�+���7�+�AA�!2��D�I���2
�
@N���B�`�y"�P��:�b]A�ҰQ�Y�$�L�^�k�ܛ�-I�Z�BdX(γ�M�ғ��{hw(�e�]Wbם2� 6?&����^˘��q_4n&�����C����q��a;=�d`��v�kQ�i�����(G���MJ�Q�H�0~yJ�HW�Ԙ��s��a����)�7      +   C   x�ɱ�0����LD�8DB���t'u�ϡ�i��UXR�	WR��?��9��s.��,�      ,   +   x�+(��MM���JL����,.)JL�/�*-.M,���qqq ��      	   �  x�}��n� �ϳO�/�^��͞�T����FI#����`�.ؕ���O=��b��M��F�F���ϼ���G�փ��������K��5V&B翌&�x� e9<|��(�	UJ�H�bZ���mG�	B��捤צ�]�����t��Ccj�/�zt�:�a�13z�j=�v@`��+Ɨ�ؤ�y�U.� vԟ��-���Lw��s�9���vgB� ����_���,.�QP&�%�7�o(̈́*y���*�E��M�?^a�"�u6��PoGt�,D��i��J���8��8_z�(�$�lɹ���[S�!����ak������6��̑��M��M~��i}?uɊ��hbo.�Yȱ����0`�0���Z;�%�y�����j�}������{����(�8�C�J�%6�����R2��Y-I�WMmj�dU�L���&95�XQ��j�Ȇ��`YQ)Ne?d���	}���     