PGDMP     .                    x            tudec    11.7    11.7 �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            �           1262    16393    tudec    DATABASE     �   CREATE DATABASE tudec WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Spanish_Colombia.1252' LC_CTYPE = 'Spanish_Colombia.1252';
    DROP DATABASE tudec;
             postgres    false                        2615    16403    comentarios    SCHEMA        CREATE SCHEMA comentarios;
    DROP SCHEMA comentarios;
             postgres    false                        2615    16397    cursos    SCHEMA        CREATE SCHEMA cursos;
    DROP SCHEMA cursos;
             postgres    false            	            2615    16398    examenes    SCHEMA        CREATE SCHEMA examenes;
    DROP SCHEMA examenes;
             postgres    false                        2615    16401    mensajes    SCHEMA        CREATE SCHEMA mensajes;
    DROP SCHEMA mensajes;
             postgres    false            
            2615    16395    notificaciones    SCHEMA        CREATE SCHEMA notificaciones;
    DROP SCHEMA notificaciones;
             postgres    false                        2615    16396    reportes    SCHEMA        CREATE SCHEMA reportes;
    DROP SCHEMA reportes;
             postgres    false                        2615    16400    sugerencias    SCHEMA        CREATE SCHEMA sugerencias;
    DROP SCHEMA sugerencias;
             postgres    false                        2615    16399    temas    SCHEMA        CREATE SCHEMA temas;
    DROP SCHEMA temas;
             postgres    false                        2615    16394    usuarios    SCHEMA        CREATE SCHEMA usuarios;
    DROP SCHEMA usuarios;
             postgres    false            �            1259    16765    comentarios    TABLE       CREATE TABLE comentarios.comentarios (
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
       comentarios         postgres    false    6            �            1259    16763    comentarios_id_seq    SEQUENCE     �   CREATE SEQUENCE comentarios.comentarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE comentarios.comentarios_id_seq;
       comentarios       postgres    false    6    235            �           0    0    comentarios_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE comentarios.comentarios_id_seq OWNED BY comentarios.comentarios.id;
            comentarios       postgres    false    234            �            1259    16496    areas    TABLE     O   CREATE TABLE cursos.areas (
    area text NOT NULL,
    icono text NOT NULL
);
    DROP TABLE cursos.areas;
       cursos         postgres    false    13            �            1259    16564    cursos    TABLE     .  CREATE TABLE cursos.cursos (
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
       cursos         postgres    false    13            �            1259    16562    cursos_id_seq    SEQUENCE     �   CREATE SEQUENCE cursos.cursos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE cursos.cursos_id_seq;
       cursos       postgres    false    13    216            �           0    0    cursos_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE cursos.cursos_id_seq OWNED BY cursos.cursos.id;
            cursos       postgres    false    215            �            1259    16554    estados_curso    TABLE     @   CREATE TABLE cursos.estados_curso (
    estado text NOT NULL
);
 !   DROP TABLE cursos.estados_curso;
       cursos         postgres    false    13            �            1259    16590    inscripciones_cursos    TABLE     �   CREATE TABLE cursos.inscripciones_cursos (
    id integer NOT NULL,
    fk_nombre_de_usuario text NOT NULL,
    fk_id_curso integer NOT NULL,
    fecha_de_inscripcion date NOT NULL
);
 (   DROP TABLE cursos.inscripciones_cursos;
       cursos         postgres    false    13            �            1259    16588    inscripciones_cursos_id_seq    SEQUENCE     �   CREATE SEQUENCE cursos.inscripciones_cursos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE cursos.inscripciones_cursos_id_seq;
       cursos       postgres    false    13    218            �           0    0    inscripciones_cursos_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE cursos.inscripciones_cursos_id_seq OWNED BY cursos.inscripciones_cursos.id;
            cursos       postgres    false    217            �            1259    16686    ejecucion_examen    TABLE     �   CREATE TABLE examenes.ejecucion_examen (
    id integer NOT NULL,
    fk_nombre_de_usuario text NOT NULL,
    fk_id_examen integer NOT NULL,
    fecha_de_ejecucion date NOT NULL,
    calificacion integer NOT NULL
);
 &   DROP TABLE examenes.ejecucion_examen;
       examenes         postgres    false    9            �            1259    16684    ejecucion_examen_id_seq    SEQUENCE     �   CREATE SEQUENCE examenes.ejecucion_examen_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE examenes.ejecucion_examen_id_seq;
       examenes       postgres    false    9    229            �           0    0    ejecucion_examen_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE examenes.ejecucion_examen_id_seq OWNED BY examenes.ejecucion_examen.id;
            examenes       postgres    false    228            �            1259    16628    examenes    TABLE     �   CREATE TABLE examenes.examenes (
    id integer NOT NULL,
    fk_id_tema integer NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_fin date NOT NULL
);
    DROP TABLE examenes.examenes;
       examenes         postgres    false    9            �            1259    16626    examenes_id_seq    SEQUENCE     �   CREATE SEQUENCE examenes.examenes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE examenes.examenes_id_seq;
       examenes       postgres    false    9    222            �           0    0    examenes_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE examenes.examenes_id_seq OWNED BY examenes.examenes.id;
            examenes       postgres    false    221            �            1259    16649 	   preguntas    TABLE     �   CREATE TABLE examenes.preguntas (
    id integer NOT NULL,
    fk_id_examen integer NOT NULL,
    fk_tipo_pregunta text NOT NULL,
    pregunta text NOT NULL,
    porcentaje integer NOT NULL
);
    DROP TABLE examenes.preguntas;
       examenes         postgres    false    9            �            1259    16647    preguntas_id_seq    SEQUENCE     �   CREATE SEQUENCE examenes.preguntas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE examenes.preguntas_id_seq;
       examenes       postgres    false    9    225            �           0    0    preguntas_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE examenes.preguntas_id_seq OWNED BY examenes.preguntas.id;
            examenes       postgres    false    224            �            1259    16670 
   respuestas    TABLE     �   CREATE TABLE examenes.respuestas (
    id integer NOT NULL,
    fk_id_preguntas integer NOT NULL,
    respuesta text NOT NULL
);
     DROP TABLE examenes.respuestas;
       examenes         postgres    false    9            �            1259    16668    respuestas_id_seq    SEQUENCE     �   CREATE SEQUENCE examenes.respuestas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE examenes.respuestas_id_seq;
       examenes       postgres    false    9    227            �           0    0    respuestas_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE examenes.respuestas_id_seq OWNED BY examenes.respuestas.id;
            examenes       postgres    false    226            �            1259    16639    tipos_pregunta    TABLE     A   CREATE TABLE examenes.tipos_pregunta (
    tipo text NOT NULL
);
 $   DROP TABLE examenes.tipos_pregunta;
       examenes         postgres    false    9            �            1259    16723    mensajes    TABLE     �   CREATE TABLE mensajes.mensajes (
    id integer NOT NULL,
    fk_nombre_de_usuario_emisor text NOT NULL,
    fk_nombre_de_usuario_receptor text NOT NULL,
    contenido text NOT NULL,
    imagenes text[]
);
    DROP TABLE mensajes.mensajes;
       mensajes         postgres    false    12            �            1259    16721    mensajes_id_seq    SEQUENCE     �   CREATE SEQUENCE mensajes.mensajes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE mensajes.mensajes_id_seq;
       mensajes       postgres    false    233    12            �           0    0    mensajes_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE mensajes.mensajes_id_seq OWNED BY mensajes.mensajes.id;
            mensajes       postgres    false    232            �            1259    16448    notificaciones    TABLE     �   CREATE TABLE notificaciones.notificaciones (
    id integer NOT NULL,
    mensaje text NOT NULL,
    estado boolean NOT NULL,
    fk_nombre_de_usuario text NOT NULL
);
 *   DROP TABLE notificaciones.notificaciones;
       notificaciones         postgres    false    10            �            1259    16446    notificaciones_id_seq    SEQUENCE     �   CREATE SEQUENCE notificaciones.notificaciones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE notificaciones.notificaciones_id_seq;
       notificaciones       postgres    false    209    10            �           0    0    notificaciones_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE notificaciones.notificaciones_id_seq OWNED BY notificaciones.notificaciones.id;
            notificaciones       postgres    false    208            �            1259    16462    motivos    TABLE     <   CREATE TABLE reportes.motivos (
    motivo text NOT NULL
);
    DROP TABLE reportes.motivos;
       reportes         postgres    false    16            �            1259    16472    reportes    TABLE     J  CREATE TABLE reportes.reportes (
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
       reportes         postgres    false    16            �            1259    16470    reportes_id_seq    SEQUENCE     �   CREATE SEQUENCE reportes.reportes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE reportes.reportes_id_seq;
       reportes       postgres    false    16    212            �           0    0    reportes_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE reportes.reportes_id_seq OWNED BY reportes.reportes.id;
            reportes       postgres    false    211            �            1259    16707    sugerencias    TABLE     �   CREATE TABLE sugerencias.sugerencias (
    id integer NOT NULL,
    fk_nombre_de_usuario_emisor text,
    contenido text NOT NULL,
    estado boolean NOT NULL,
    imagenes text[]
);
 $   DROP TABLE sugerencias.sugerencias;
       sugerencias         postgres    false    14            �            1259    16705    sugerencias_id_seq    SEQUENCE     �   CREATE SEQUENCE sugerencias.sugerencias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE sugerencias.sugerencias_id_seq;
       sugerencias       postgres    false    14    231            �           0    0    sugerencias_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE sugerencias.sugerencias_id_seq OWNED BY sugerencias.sugerencias.id;
            sugerencias       postgres    false    230            �            1259    16611    temas    TABLE     �   CREATE TABLE temas.temas (
    id integer NOT NULL,
    fk_id_curso integer NOT NULL,
    titulo text NOT NULL,
    informacion text NOT NULL,
    imagenes text[]
);
    DROP TABLE temas.temas;
       temas         postgres    false    15            �            1259    16609    temas_id_seq    SEQUENCE     �   CREATE SEQUENCE temas.temas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE temas.temas_id_seq;
       temas       postgres    false    15    220            �           0    0    temas_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE temas.temas_id_seq OWNED BY temas.temas.id;
            temas       postgres    false    219            �            1259    16404    estados_usuario    TABLE     D   CREATE TABLE usuarios.estados_usuario (
    estado text NOT NULL
);
 %   DROP TABLE usuarios.estados_usuario;
       usuarios         postgres    false    7            �            1259    16412    roles    TABLE     7   CREATE TABLE usuarios.roles (
    rol text NOT NULL
);
    DROP TABLE usuarios.roles;
       usuarios         postgres    false    7            �            1259    16428    usuarios    TABLE     �  CREATE TABLE usuarios.usuarios (
    nombre_de_usuario text NOT NULL,
    fk_rol text NOT NULL,
    fk_estado text NOT NULL,
    primer_nombre text NOT NULL,
    segundo_nombre text,
    primer_apellido text NOT NULL,
    segundo_apellido text,
    correo_institucional text NOT NULL,
    pass text NOT NULL,
    fecha_desbloqueo date NOT NULL,
    puntuacion integer,
    token text NOT NULL,
    imagen_perfil text,
    fecha_creacion date NOT NULL
);
    DROP TABLE usuarios.usuarios;
       usuarios         postgres    false    7                       2604    16768    comentarios id    DEFAULT     z   ALTER TABLE ONLY comentarios.comentarios ALTER COLUMN id SET DEFAULT nextval('comentarios.comentarios_id_seq'::regclass);
 B   ALTER TABLE comentarios.comentarios ALTER COLUMN id DROP DEFAULT;
       comentarios       postgres    false    234    235    235            �
           2604    16567 	   cursos id    DEFAULT     f   ALTER TABLE ONLY cursos.cursos ALTER COLUMN id SET DEFAULT nextval('cursos.cursos_id_seq'::regclass);
 8   ALTER TABLE cursos.cursos ALTER COLUMN id DROP DEFAULT;
       cursos       postgres    false    216    215    216            �
           2604    16593    inscripciones_cursos id    DEFAULT     �   ALTER TABLE ONLY cursos.inscripciones_cursos ALTER COLUMN id SET DEFAULT nextval('cursos.inscripciones_cursos_id_seq'::regclass);
 F   ALTER TABLE cursos.inscripciones_cursos ALTER COLUMN id DROP DEFAULT;
       cursos       postgres    false    218    217    218            �
           2604    16689    ejecucion_examen id    DEFAULT     ~   ALTER TABLE ONLY examenes.ejecucion_examen ALTER COLUMN id SET DEFAULT nextval('examenes.ejecucion_examen_id_seq'::regclass);
 D   ALTER TABLE examenes.ejecucion_examen ALTER COLUMN id DROP DEFAULT;
       examenes       postgres    false    228    229    229            �
           2604    16631    examenes id    DEFAULT     n   ALTER TABLE ONLY examenes.examenes ALTER COLUMN id SET DEFAULT nextval('examenes.examenes_id_seq'::regclass);
 <   ALTER TABLE examenes.examenes ALTER COLUMN id DROP DEFAULT;
       examenes       postgres    false    221    222    222            �
           2604    16652    preguntas id    DEFAULT     p   ALTER TABLE ONLY examenes.preguntas ALTER COLUMN id SET DEFAULT nextval('examenes.preguntas_id_seq'::regclass);
 =   ALTER TABLE examenes.preguntas ALTER COLUMN id DROP DEFAULT;
       examenes       postgres    false    224    225    225            �
           2604    16673    respuestas id    DEFAULT     r   ALTER TABLE ONLY examenes.respuestas ALTER COLUMN id SET DEFAULT nextval('examenes.respuestas_id_seq'::regclass);
 >   ALTER TABLE examenes.respuestas ALTER COLUMN id DROP DEFAULT;
       examenes       postgres    false    226    227    227                        2604    16726    mensajes id    DEFAULT     n   ALTER TABLE ONLY mensajes.mensajes ALTER COLUMN id SET DEFAULT nextval('mensajes.mensajes_id_seq'::regclass);
 <   ALTER TABLE mensajes.mensajes ALTER COLUMN id DROP DEFAULT;
       mensajes       postgres    false    232    233    233            �
           2604    16451    notificaciones id    DEFAULT     �   ALTER TABLE ONLY notificaciones.notificaciones ALTER COLUMN id SET DEFAULT nextval('notificaciones.notificaciones_id_seq'::regclass);
 H   ALTER TABLE notificaciones.notificaciones ALTER COLUMN id DROP DEFAULT;
       notificaciones       postgres    false    208    209    209            �
           2604    16475    reportes id    DEFAULT     n   ALTER TABLE ONLY reportes.reportes ALTER COLUMN id SET DEFAULT nextval('reportes.reportes_id_seq'::regclass);
 <   ALTER TABLE reportes.reportes ALTER COLUMN id DROP DEFAULT;
       reportes       postgres    false    211    212    212            �
           2604    16710    sugerencias id    DEFAULT     z   ALTER TABLE ONLY sugerencias.sugerencias ALTER COLUMN id SET DEFAULT nextval('sugerencias.sugerencias_id_seq'::regclass);
 B   ALTER TABLE sugerencias.sugerencias ALTER COLUMN id DROP DEFAULT;
       sugerencias       postgres    false    230    231    231            �
           2604    16614    temas id    DEFAULT     b   ALTER TABLE ONLY temas.temas ALTER COLUMN id SET DEFAULT nextval('temas.temas_id_seq'::regclass);
 6   ALTER TABLE temas.temas ALTER COLUMN id DROP DEFAULT;
       temas       postgres    false    219    220    220            �          0    16765    comentarios 
   TABLE DATA               �   COPY comentarios.comentarios (id, fk_nombre_de_usuario_emisor, fk_id_curso, fk_id_tema, fk_id_comentario, comentario, fecha_envio, imagenes) FROM stdin;
    comentarios       postgres    false    235   M�       �          0    16496    areas 
   TABLE DATA               ,   COPY cursos.areas (area, icono) FROM stdin;
    cursos       postgres    false    213   j�       �          0    16564    cursos 
   TABLE DATA               �   COPY cursos.cursos (id, fk_creador, fk_area, fk_estado, nombre, fecha_de_creacion, fecha_de_inicio, codigo_inscripcion, puntuacion) FROM stdin;
    cursos       postgres    false    216   �       �          0    16554    estados_curso 
   TABLE DATA               /   COPY cursos.estados_curso (estado) FROM stdin;
    cursos       postgres    false    214   ��       �          0    16590    inscripciones_cursos 
   TABLE DATA               k   COPY cursos.inscripciones_cursos (id, fk_nombre_de_usuario, fk_id_curso, fecha_de_inscripcion) FROM stdin;
    cursos       postgres    false    218   ɫ       �          0    16686    ejecucion_examen 
   TABLE DATA               v   COPY examenes.ejecucion_examen (id, fk_nombre_de_usuario, fk_id_examen, fecha_de_ejecucion, calificacion) FROM stdin;
    examenes       postgres    false    229   �       �          0    16628    examenes 
   TABLE DATA               M   COPY examenes.examenes (id, fk_id_tema, fecha_inicio, fecha_fin) FROM stdin;
    examenes       postgres    false    222   !�       �          0    16649 	   preguntas 
   TABLE DATA               _   COPY examenes.preguntas (id, fk_id_examen, fk_tipo_pregunta, pregunta, porcentaje) FROM stdin;
    examenes       postgres    false    225   >�       �          0    16670 
   respuestas 
   TABLE DATA               F   COPY examenes.respuestas (id, fk_id_preguntas, respuesta) FROM stdin;
    examenes       postgres    false    227   [�       �          0    16639    tipos_pregunta 
   TABLE DATA               0   COPY examenes.tipos_pregunta (tipo) FROM stdin;
    examenes       postgres    false    223   x�       �          0    16723    mensajes 
   TABLE DATA               y   COPY mensajes.mensajes (id, fk_nombre_de_usuario_emisor, fk_nombre_de_usuario_receptor, contenido, imagenes) FROM stdin;
    mensajes       postgres    false    233   ��       �          0    16448    notificaciones 
   TABLE DATA               [   COPY notificaciones.notificaciones (id, mensaje, estado, fk_nombre_de_usuario) FROM stdin;
    notificaciones       postgres    false    209   ��       �          0    16462    motivos 
   TABLE DATA               +   COPY reportes.motivos (motivo) FROM stdin;
    reportes       postgres    false    210   Ϭ       �          0    16472    reportes 
   TABLE DATA               �   COPY reportes.reportes (id, fk_nombre_de_usuario_denunciante, fk_nombre_de_usuario_denunciado, fk_motivo, descripcion, estado, fk_id_comentario, fk_id_mensaje, imagenes) FROM stdin;
    reportes       postgres    false    212   �       �          0    16707    sugerencias 
   TABLE DATA               h   COPY sugerencias.sugerencias (id, fk_nombre_de_usuario_emisor, contenido, estado, imagenes) FROM stdin;
    sugerencias       postgres    false    231   	�       �          0    16611    temas 
   TABLE DATA               N   COPY temas.temas (id, fk_id_curso, titulo, informacion, imagenes) FROM stdin;
    temas       postgres    false    220   &�       �          0    16404    estados_usuario 
   TABLE DATA               3   COPY usuarios.estados_usuario (estado) FROM stdin;
    usuarios       postgres    false    205   C�       �          0    16412    roles 
   TABLE DATA               &   COPY usuarios.roles (rol) FROM stdin;
    usuarios       postgres    false    206   g�       �          0    16428    usuarios 
   TABLE DATA               �   COPY usuarios.usuarios (nombre_de_usuario, fk_rol, fk_estado, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, correo_institucional, pass, fecha_desbloqueo, puntuacion, token, imagen_perfil, fecha_creacion) FROM stdin;
    usuarios       postgres    false    207   ��       �           0    0    comentarios_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('comentarios.comentarios_id_seq', 1, false);
            comentarios       postgres    false    234            �           0    0    cursos_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('cursos.cursos_id_seq', 8, true);
            cursos       postgres    false    215            �           0    0    inscripciones_cursos_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('cursos.inscripciones_cursos_id_seq', 2, true);
            cursos       postgres    false    217            �           0    0    ejecucion_examen_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('examenes.ejecucion_examen_id_seq', 1, false);
            examenes       postgres    false    228            �           0    0    examenes_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('examenes.examenes_id_seq', 1, false);
            examenes       postgres    false    221            �           0    0    preguntas_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('examenes.preguntas_id_seq', 1, false);
            examenes       postgres    false    224            �           0    0    respuestas_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('examenes.respuestas_id_seq', 1, false);
            examenes       postgres    false    226            �           0    0    mensajes_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('mensajes.mensajes_id_seq', 1, false);
            mensajes       postgres    false    232            �           0    0    notificaciones_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('notificaciones.notificaciones_id_seq', 1, false);
            notificaciones       postgres    false    208            �           0    0    reportes_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('reportes.reportes_id_seq', 1, false);
            reportes       postgres    false    211            �           0    0    sugerencias_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('sugerencias.sugerencias_id_seq', 1, false);
            sugerencias       postgres    false    230            �           0    0    temas_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('temas.temas_id_seq', 1, false);
            temas       postgres    false    219            '           2606    16773    comentarios comentarios_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT comentarios_pkey PRIMARY KEY (id);
 K   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT comentarios_pkey;
       comentarios         postgres    false    235                       2606    16503    areas areas_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY cursos.areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (area);
 :   ALTER TABLE ONLY cursos.areas DROP CONSTRAINT areas_pkey;
       cursos         postgres    false    213                       2606    16572    cursos cursos_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT cursos_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT cursos_pkey;
       cursos         postgres    false    216                       2606    16561    estados_curso estado_curso_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY cursos.estados_curso
    ADD CONSTRAINT estado_curso_pkey PRIMARY KEY (estado);
 I   ALTER TABLE ONLY cursos.estados_curso DROP CONSTRAINT estado_curso_pkey;
       cursos         postgres    false    214                       2606    16598 .   inscripciones_cursos inscripciones_cursos_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY cursos.inscripciones_cursos
    ADD CONSTRAINT inscripciones_cursos_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY cursos.inscripciones_cursos DROP CONSTRAINT inscripciones_cursos_pkey;
       cursos         postgres    false    218            !           2606    16694 &   ejecucion_examen ejecucion_examen_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY examenes.ejecucion_examen
    ADD CONSTRAINT ejecucion_examen_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY examenes.ejecucion_examen DROP CONSTRAINT ejecucion_examen_pkey;
       examenes         postgres    false    229                       2606    16633    examenes examenes_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY examenes.examenes
    ADD CONSTRAINT examenes_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY examenes.examenes DROP CONSTRAINT examenes_pkey;
       examenes         postgres    false    222                       2606    16657    preguntas preguntas_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY examenes.preguntas
    ADD CONSTRAINT preguntas_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY examenes.preguntas DROP CONSTRAINT preguntas_pkey;
       examenes         postgres    false    225                       2606    16678    respuestas respuestas_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY examenes.respuestas
    ADD CONSTRAINT respuestas_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY examenes.respuestas DROP CONSTRAINT respuestas_pkey;
       examenes         postgres    false    227                       2606    16646 "   tipos_pregunta tipos_pregunta_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY examenes.tipos_pregunta
    ADD CONSTRAINT tipos_pregunta_pkey PRIMARY KEY (tipo);
 N   ALTER TABLE ONLY examenes.tipos_pregunta DROP CONSTRAINT tipos_pregunta_pkey;
       examenes         postgres    false    223            %           2606    16731    mensajes mensajes_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY mensajes.mensajes
    ADD CONSTRAINT mensajes_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY mensajes.mensajes DROP CONSTRAINT mensajes_pkey;
       mensajes         postgres    false    233            	           2606    16456 "   notificaciones notificaciones_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY notificaciones.notificaciones
    ADD CONSTRAINT notificaciones_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY notificaciones.notificaciones DROP CONSTRAINT notificaciones_pkey;
       notificaciones         postgres    false    209                       2606    16469    motivos motivos_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY reportes.motivos
    ADD CONSTRAINT motivos_pkey PRIMARY KEY (motivo);
 @   ALTER TABLE ONLY reportes.motivos DROP CONSTRAINT motivos_pkey;
       reportes         postgres    false    210                       2606    16480    reportes reportes_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT reportes_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT reportes_pkey;
       reportes         postgres    false    212            #           2606    16715    sugerencias sugerencias_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY sugerencias.sugerencias
    ADD CONSTRAINT sugerencias_pkey PRIMARY KEY (id);
 K   ALTER TABLE ONLY sugerencias.sugerencias DROP CONSTRAINT sugerencias_pkey;
       sugerencias         postgres    false    231                       2606    16619    temas temas_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY temas.temas
    ADD CONSTRAINT temas_pkey PRIMARY KEY (id);
 9   ALTER TABLE ONLY temas.temas DROP CONSTRAINT temas_pkey;
       temas         postgres    false    220                       2606    16411 $   estados_usuario estados_usuario_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY usuarios.estados_usuario
    ADD CONSTRAINT estados_usuario_pkey PRIMARY KEY (estado);
 P   ALTER TABLE ONLY usuarios.estados_usuario DROP CONSTRAINT estados_usuario_pkey;
       usuarios         postgres    false    205                       2606    16419    roles roles_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY usuarios.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (rol);
 <   ALTER TABLE ONLY usuarios.roles DROP CONSTRAINT roles_pkey;
       usuarios         postgres    false    206                       2606    16435    usuarios usuarios_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (nombre_de_usuario);
 B   ALTER TABLE ONLY usuarios.usuarios DROP CONSTRAINT usuarios_pkey;
       usuarios         postgres    false    207            B           2606    16789    comentarios fkcomentario107416    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario107416 FOREIGN KEY (fk_nombre_de_usuario_emisor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario107416;
       comentarios       postgres    false    235    2823    207            A           2606    16784    comentarios fkcomentario298131    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario298131 FOREIGN KEY (fk_id_tema) REFERENCES temas.temas(id);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario298131;
       comentarios       postgres    false    235    220    2839            @           2606    16779    comentarios fkcomentario605734    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario605734 FOREIGN KEY (fk_id_curso) REFERENCES cursos.cursos(id);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario605734;
       comentarios       postgres    false    235    216    2835            ?           2606    16774    comentarios fkcomentario954929    FK CONSTRAINT     �   ALTER TABLE ONLY comentarios.comentarios
    ADD CONSTRAINT fkcomentario954929 FOREIGN KEY (fk_id_comentario) REFERENCES comentarios.comentarios(id);
 M   ALTER TABLE ONLY comentarios.comentarios DROP CONSTRAINT fkcomentario954929;
       comentarios       postgres    false    2855    235    235            2           2606    16583    cursos fkcursos287281    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT fkcursos287281 FOREIGN KEY (fk_estado) REFERENCES cursos.estados_curso(estado);
 ?   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT fkcursos287281;
       cursos       postgres    false    216    2833    214            1           2606    16578    cursos fkcursos395447    FK CONSTRAINT     v   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT fkcursos395447 FOREIGN KEY (fk_area) REFERENCES cursos.areas(area);
 ?   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT fkcursos395447;
       cursos       postgres    false    213    216    2831            0           2606    16573    cursos fkcursos742472    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.cursos
    ADD CONSTRAINT fkcursos742472 FOREIGN KEY (fk_creador) REFERENCES usuarios.usuarios(nombre_de_usuario);
 ?   ALTER TABLE ONLY cursos.cursos DROP CONSTRAINT fkcursos742472;
       cursos       postgres    false    2823    216    207            4           2606    16604 &   inscripciones_cursos fkinscripcio18320    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.inscripciones_cursos
    ADD CONSTRAINT fkinscripcio18320 FOREIGN KEY (fk_id_curso) REFERENCES cursos.cursos(id);
 P   ALTER TABLE ONLY cursos.inscripciones_cursos DROP CONSTRAINT fkinscripcio18320;
       cursos       postgres    false    2835    218    216            3           2606    16599 '   inscripciones_cursos fkinscripcio893145    FK CONSTRAINT     �   ALTER TABLE ONLY cursos.inscripciones_cursos
    ADD CONSTRAINT fkinscripcio893145 FOREIGN KEY (fk_nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 Q   ALTER TABLE ONLY cursos.inscripciones_cursos DROP CONSTRAINT fkinscripcio893145;
       cursos       postgres    false    2823    207    218            :           2606    16695 #   ejecucion_examen fkejecucion_455924    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.ejecucion_examen
    ADD CONSTRAINT fkejecucion_455924 FOREIGN KEY (fk_nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 O   ALTER TABLE ONLY examenes.ejecucion_examen DROP CONSTRAINT fkejecucion_455924;
       examenes       postgres    false    229    207    2823            ;           2606    16700 #   ejecucion_examen fkejecucion_678612    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.ejecucion_examen
    ADD CONSTRAINT fkejecucion_678612 FOREIGN KEY (fk_id_examen) REFERENCES examenes.examenes(id);
 O   ALTER TABLE ONLY examenes.ejecucion_examen DROP CONSTRAINT fkejecucion_678612;
       examenes       postgres    false    229    222    2841            6           2606    16634    examenes fkexamenes946263    FK CONSTRAINT     |   ALTER TABLE ONLY examenes.examenes
    ADD CONSTRAINT fkexamenes946263 FOREIGN KEY (fk_id_tema) REFERENCES temas.temas(id);
 E   ALTER TABLE ONLY examenes.examenes DROP CONSTRAINT fkexamenes946263;
       examenes       postgres    false    222    2839    220            7           2606    16658    preguntas fkpreguntas592721    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.preguntas
    ADD CONSTRAINT fkpreguntas592721 FOREIGN KEY (fk_id_examen) REFERENCES examenes.examenes(id);
 G   ALTER TABLE ONLY examenes.preguntas DROP CONSTRAINT fkpreguntas592721;
       examenes       postgres    false    222    225    2841            8           2606    16663    preguntas fkpreguntas985578    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.preguntas
    ADD CONSTRAINT fkpreguntas985578 FOREIGN KEY (fk_tipo_pregunta) REFERENCES examenes.tipos_pregunta(tipo);
 G   ALTER TABLE ONLY examenes.preguntas DROP CONSTRAINT fkpreguntas985578;
       examenes       postgres    false    2843    223    225            9           2606    16679    respuestas fkrespuestas516290    FK CONSTRAINT     �   ALTER TABLE ONLY examenes.respuestas
    ADD CONSTRAINT fkrespuestas516290 FOREIGN KEY (fk_id_preguntas) REFERENCES examenes.preguntas(id);
 I   ALTER TABLE ONLY examenes.respuestas DROP CONSTRAINT fkrespuestas516290;
       examenes       postgres    false    2845    225    227            >           2606    16737    mensajes fkmensajes16841    FK CONSTRAINT     �   ALTER TABLE ONLY mensajes.mensajes
    ADD CONSTRAINT fkmensajes16841 FOREIGN KEY (fk_nombre_de_usuario_receptor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 D   ALTER TABLE ONLY mensajes.mensajes DROP CONSTRAINT fkmensajes16841;
       mensajes       postgres    false    2823    207    233            =           2606    16732    mensajes fkmensajes33437    FK CONSTRAINT     �   ALTER TABLE ONLY mensajes.mensajes
    ADD CONSTRAINT fkmensajes33437 FOREIGN KEY (fk_nombre_de_usuario_emisor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 D   ALTER TABLE ONLY mensajes.mensajes DROP CONSTRAINT fkmensajes33437;
       mensajes       postgres    false    233    2823    207            *           2606    16457 !   notificaciones fknotificaci697604    FK CONSTRAINT     �   ALTER TABLE ONLY notificaciones.notificaciones
    ADD CONSTRAINT fknotificaci697604 FOREIGN KEY (fk_nombre_de_usuario) REFERENCES usuarios.usuarios(nombre_de_usuario);
 S   ALTER TABLE ONLY notificaciones.notificaciones DROP CONSTRAINT fknotificaci697604;
       notificaciones       postgres    false    2823    207    209            -           2606    16491    reportes fkreportes338700    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT fkreportes338700 FOREIGN KEY (fk_motivo) REFERENCES reportes.motivos(motivo);
 E   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT fkreportes338700;
       reportes       postgres    false    212    2827    210            ,           2606    16486    reportes fkreportes50539    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT fkreportes50539 FOREIGN KEY (fk_nombre_de_usuario_denunciado) REFERENCES usuarios.usuarios(nombre_de_usuario);
 D   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT fkreportes50539;
       reportes       postgres    false    2823    212    207            +           2606    16481    reportes fkreportes843275    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT fkreportes843275 FOREIGN KEY (fk_nombre_de_usuario_denunciante) REFERENCES usuarios.usuarios(nombre_de_usuario);
 E   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT fkreportes843275;
       reportes       postgres    false    212    2823    207            .           2606    16893 '   reportes reportes_fk_id_comentario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT reportes_fk_id_comentario_fkey FOREIGN KEY (fk_id_comentario) REFERENCES comentarios.comentarios(id);
 S   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT reportes_fk_id_comentario_fkey;
       reportes       postgres    false    235    2855    212            /           2606    16898 $   reportes reportes_fk_id_mensaje_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY reportes.reportes
    ADD CONSTRAINT reportes_fk_id_mensaje_fkey FOREIGN KEY (fk_id_mensaje) REFERENCES mensajes.mensajes(id);
 P   ALTER TABLE ONLY reportes.reportes DROP CONSTRAINT reportes_fk_id_mensaje_fkey;
       reportes       postgres    false    2853    212    233            <           2606    16716    sugerencias fksugerencia433827    FK CONSTRAINT     �   ALTER TABLE ONLY sugerencias.sugerencias
    ADD CONSTRAINT fksugerencia433827 FOREIGN KEY (fk_nombre_de_usuario_emisor) REFERENCES usuarios.usuarios(nombre_de_usuario);
 M   ALTER TABLE ONLY sugerencias.sugerencias DROP CONSTRAINT fksugerencia433827;
       sugerencias       postgres    false    231    207    2823            5           2606    16620    temas fktemas249223    FK CONSTRAINT     v   ALTER TABLE ONLY temas.temas
    ADD CONSTRAINT fktemas249223 FOREIGN KEY (fk_id_curso) REFERENCES cursos.cursos(id);
 <   ALTER TABLE ONLY temas.temas DROP CONSTRAINT fktemas249223;
       temas       postgres    false    216    2835    220            )           2606    16441    usuarios fkusuarios355026    FK CONSTRAINT     |   ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT fkusuarios355026 FOREIGN KEY (fk_rol) REFERENCES usuarios.roles(rol);
 E   ALTER TABLE ONLY usuarios.usuarios DROP CONSTRAINT fkusuarios355026;
       usuarios       postgres    false    206    207    2821            (           2606    16436    usuarios fkusuarios94770    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT fkusuarios94770 FOREIGN KEY (fk_estado) REFERENCES usuarios.estados_usuario(estado);
 D   ALTER TABLE ONLY usuarios.usuarios DROP CONSTRAINT fkusuarios94770;
       usuarios       postgres    false    205    2819    207            �      x������ � �      �   k   x�s�L�K�L,Vp:��839���N?(5���8�X�371=5/�H���/v,JM,�wFסW����T��Ztxm"A��B��d��a3TX�IQ>a`U`�1z\\\ ?�X�      �   �   x�u�A
�0EדS��i�4]+�"���MH[ZH��� ��sB���,�"��S��f�aC�`Ʉd=�Y�ؑ��f�%���X���l�r��`z�?��0:O�M���q�"E�#
��#������]�w4QES�EĶS E5��ѻ�wq\�7!��#�^F�hN�,V���J�$EG�      �      x�KL.�,������ �9      �   +   x�3�t+J�K�4�4202�50�56�2�
BM��+F��� �#	^      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x�KL.�,������ �9      �   +   x�+(��MM���JL����,.)JL�/�*-.M,���qqq ��      �   �   x�m�1n�0Eg�.1dY��-E�MR����Z����:�F:��X�Y� ���o���RH�v�	67�wa���1��r��'x�Ӵ.�D"H+�Je�v	Jj����j	��j��-K�1�|�b�#�Kt�>��]~2�&����{]:��?�[�L��-�F�3Z����>�z��3��< r�7��O_�g��{�j�s�t����v�6��\q��W�pg~     