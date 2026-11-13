"""Genera los datos de prueba de ChauchaApp (50 usuarios y sus historias).

Salida en este mismo directorio:
  usuarios.json        cuentas (id, email, rol, foto)
  01_usuarios.sql      auth.users + auth.identities (el trigger crea perfiles)
  02_perfiles.sql      fotos, verificación manual, ubicación, oficios, tarifas
  03_flujos_N.sql      solicitudes, postulaciones, chats, tickets, cierres, reseñas
  04_fechas.sql        reparte las fechas en el pasado para que haya historial
  99_limpiar.sql       borra todo lo sembrado
"""
import json
import os
import random
import sys
import unicodedata
import uuid
from pathlib import Path

R = random.Random(2026)
AQUI = Path(__file__).parent
DOMINIO = 'semilla.chaucha.app'
# La contraseña de las cuentas de prueba NO va en el repo (es público y las
# cuentas viven en la base real): se pasa por variable de entorno.
CLAVE = os.environ.get('SEMILLA_CLAVE') or sys.exit('Define SEMILLA_CLAVE con la contraseña de las cuentas de prueba.')

# Caras generadas (thispersondoesnotexist), ya clasificadas a ojo.
CARAS_H = ['02', '05', '07', '21', '22', '26', '27', '30', '33', '35', '36', '40', '44', '54', '66',
           '31', '37', '38', '39', '43', '45', '57', '63', '64', '65']
CARAS_M = ['08', '16', '18', '28', '56',
           '03', '04', '06', '10', '12', '13', '14', '15', '17', '23', '29', '32', '34', '42', '47',
           '48', '49', '50', '51', '53']

NOMBRES_H = ['Andrés', 'Carlos', 'Diego', 'Fernando', 'Gabriel', 'Javier', 'Jorge', 'José Luis',
             'Juan Carlos', 'Luis', 'Marco', 'Mateo', 'Miguel', 'Pablo', 'Patricio', 'Ricardo',
             'Santiago', 'Sebastián', 'Xavier', 'Wilson', 'Edison', 'Byron', 'Christian', 'Freddy',
             'Hernán']
NOMBRES_M = ['Ana', 'Andrea', 'Belén', 'Carla', 'Carolina', 'Cristina', 'Daniela', 'Diana',
             'Gabriela', 'Jessica', 'Johanna', 'Karina', 'Lorena', 'María José', 'María Fernanda',
             'Mónica', 'Paola', 'Paulina', 'Silvia', 'Sofía', 'Valeria', 'Verónica', 'Ximena',
             'Estefanía', 'Camila']
APELLIDOS = ['Andrade', 'Benítez', 'Cevallos', 'Chávez', 'Espinosa', 'Guerrero', 'Herrera',
             'Jácome', 'León', 'Mora', 'Naranjo', 'Ortiz', 'Paredes', 'Pazmiño', 'Proaño',
             'Quishpe', 'Ruiz', 'Salazar', 'Tapia', 'Torres', 'Vásconez', 'Villacís', 'Yépez',
             'Zambrano', 'Carrera', 'Cueva', 'Morales', 'Gallegos', 'Almeida', 'Calderón']

BARRIOS = ['La Carolina', 'Iñaquito', 'La Mariscal', 'El Batán', 'Bellavista', 'La Floresta',
           'Quito Tennis', 'El Inca', 'San Carlos', 'La Kennedy', 'Monteserrín', 'Guápulo',
           'El Condado', 'La Vicentina', 'Las Casas', 'La Gasca', 'Rumipamba', 'Jipijapa']

# Oficios que se usan en las historias (id -> textos).
OFICIOS = {
    1: ('Plomería', [
        'Se rompió la llave de paso de la cocina y gotea sin parar.',
        'El inodoro no deja de correr agua desde ayer.',
        'Hay una fuga debajo del lavamanos del baño principal.',
        'La ducha casi no tiene presión, creo que es la tubería.',
    ], 'Reviso la tubería y cambio el empaque o la llave si hace falta. Llevo repuestos comunes.'),
    2: ('Electricidad', [
        'Se fue la luz en la mitad del departamento y el breaker se baja solo.',
        'Necesito instalar tres tomacorrientes nuevos en la sala.',
        'Los focos del pasillo parpadean y huele a quemado en el interruptor.',
        'Quiero cambiar el tablero eléctrico, es muy antiguo.',
    ], 'Hago una revisión del circuito con multímetro, ubico la falla y la corrijo con material certificado.'),
    3: ('Albañilería', [
        'Se cuarteó una pared del patio y entra humedad.',
        'Necesito resanar el filo de las gradas de entrada.',
        'Quiero levantar un muro pequeño para la lavandería.',
    ], 'Evalúo la estructura, preparo la superficie y reparo con mortero adecuado.'),
    4: ('Carpintería', [
        'La puerta del dormitorio no cierra, está descuadrada.',
        'Necesito arreglar las bisagras de los muebles de cocina.',
        'Quiero un mueble de madera a medida para el televisor.',
    ], 'Ajusto bisagras y cepillo la madera donde roza. Si es a medida, tomo medidas y cotizo.'),
    5: ('Pintura', [
        'Quiero pintar la sala y el comedor, unos 40 m².',
        'Hay manchas de humedad en el techo del baño que quiero tapar.',
        'Pintar la fachada de la casa, dos pisos.',
    ], 'Limpio, sello las manchas y aplico dos manos. La pintura la eligen ustedes.'),
    6: ('Cerrajería', [
        'Me quedé fuera de la casa, se trabó la cerradura principal.',
        'Quiero cambiar la chapa de la puerta de entrada por una de seguridad.',
    ], 'Abro sin dañar la puerta y, si quieren, cambio el cilindro en el mismo momento.'),
    7: ('Calefones', [
        'El calefón se prende y se apaga a los pocos minutos.',
        'El calefón no enciende, hace clic pero no prende la llama.',
        'Mantenimiento del calefón, hace dos años que no lo revisan.',
    ], 'Reviso el sensor de llama, limpio el quemador y verifico la presión del gas.'),
    8: ('Línea Blanca', [
        'La lavadora no centrifuga y deja la ropa empapada.',
        'La refrigeradora no enfría la parte de abajo.',
        'La secadora hace un ruido fuerte al girar.',
    ], 'Diagnostico la falla en sitio. Si es repuesto, les paso el precio antes de cambiarlo.'),
    9: ('Limpieza', [
        'Limpieza profunda del departamento antes de la mudanza.',
        'Limpieza de alfombras y muebles de la sala.',
    ], 'Llevo equipo e insumos. Calculo unas 4 horas según el tamaño.'),
    10: ('Jardinería', [
        'Cortar el césped y podar los arbustos del jardín.',
        'Quiero sembrar plantas en las jardineras de la entrada.',
    ], 'Corto, podo y dejo todo limpio. Llevo mis herramientas.'),
    15: ('Aire acondicionado', [
        'El aire acondicionado de la oficina gotea agua.',
        'Mantenimiento de dos equipos split.',
    ], 'Limpio filtros y serpentines y reviso el drenaje y el gas.'),
    17: ('Instalación de cámaras', [
        'Quiero instalar 4 cámaras de seguridad en la casa.',
        'Una cámara dejó de grabar y no aparece en el celular.',
    ], 'Reviso el cableado y la configuración del grabador. Dejo todo en la app del celular.'),
    20: ('Mantenimiento general', [
        'Varias cositas: colgar cuadros, cambiar focos y arreglar una repisa.',
        'Revisar goteras del techo antes del invierno.',
    ], 'Hago todo en una sola visita. Llevo taladro, escalera y material básico.'),
}

CHAT_CLIENTE = [
    'Hola, buenas. Vi su propuesta, ¿me puede contar un poco más?',
    'Hola, ¿cuándo podría venir a ver?',
    'Buenas tardes, ¿el precio incluye la revisión?',
]
CHAT_TECNICO = [
    'Hola, claro. Primero hago una revisión y le explico qué hay que hacer.',
    'Buenas, sí. Puedo pasar esta semana, usted me dice el horario.',
    'Hola, sí incluye. Si hace falta material se lo detallo antes.',
]
CHAT_CLIENTE_2 = [
    'Perfecto, me parece bien. ¿Me manda el ticket con la fecha?',
    'Listo, entonces le espero. Mándeme el ticket por favor.',
    'Ok, de acuerdo. ¿Qué día tiene libre?',
]
CHAT_TECNICO_2 = [
    'Ya le envío el ticket. Cualquier cosa me escribe por aquí.',
    'Le mando el ticket ahora mismo.',
    'Tengo espacio, le envío la propuesta de fecha.',
]
CHAT_CIERRE_T = ['Listo, ya quedó funcionando. Gracias por la confianza.',
                 'Trabajo terminado. Cualquier novedad me avisa.']
CHAT_CIERRE_C = ['Muchas gracias, quedó muy bien.', 'Gracias, todo perfecto.']

COMENT_T_BIEN = ['Muy puntual y explicó todo.', 'Excelente trabajo, lo recomiendo.',
                 'Dejó todo limpio y funcionando.', 'Buen precio y muy amable.',
                 'Resolvió el problema rápido.', None, None]
COMENT_C_BIEN = ['Muy amable, todo claro.', 'Cliente puntual y respetuoso.', None, None, None]
COMENT_NEUTRO = ['Cumplió, aunque llegó un poco tarde.', 'Trabajo cumplido.']
COMENT_MALO_T = 'Llegó tarde y no terminó el trabajo.'

ETQ_T_BIEN = ['Puntual', 'Trabajo limpio', 'Buen trato', 'Buen precio', 'Resolvió el problema',
              'Buena comunicación']
ETQ_C_BIEN = ['Amable', 'Explicó bien el problema', 'Estuvo disponible', 'Respetuoso', 'Acceso fácil']


def ascii(s):
    return unicodedata.normalize('NFKD', s).encode('ascii', 'ignore').decode().lower()


def q(s):
    return 'null' if s is None else "'" + str(s).replace("'", "''") + "'"


def cedula(usadas):
    while True:
        base = [1, 7, R.randint(0, 5)] + [R.randint(0, 9) for _ in range(6)]
        suma = 0
        for i, d in enumerate(base):
            v = d * (2 if i % 2 == 0 else 1)
            suma += v - 9 if v > 9 else v
        c = ''.join(map(str, base)) + str((10 - suma % 10) % 10)
        if c not in usadas:
            usadas.add(c)
            return c


def punto():
    # Centro-norte de Quito, ~5 km alrededor de La Carolina.
    return (round(R.uniform(-0.215, -0.150), 5), round(R.uniform(-78.505, -78.460), 5))


def geo(p):
    return f"st_setsrid(st_makepoint({p[1]}, {p[0]}), 4326)::geography"


def como(uid):
    return (f"select set_config('request.jwt.claims', '{{\"sub\":\"{uid}\",\"role\":\"authenticated\"}}', true), "
            f"set_config('request.jwt.claim.sub', '{uid}', true);")


SIN_SESION = "select set_config('request.jwt.claims', '', true), set_config('request.jwt.claim.sub', '', true);"


def hora_ec(dias, horas):
    """Timestamp a `dias` desde hoy (Ecuador) a las `horas` (puede ser negativo)."""
    return (f"((date_trunc('day', now() at time zone 'America/Guayaquil') "
            f"+ interval '{dias} days' + interval '{horas} hours') at time zone 'America/Guayaquil')")


# ---------------------------------------------------------------- usuarios
usadas = set()
usuarios = []
nombres_h = NOMBRES_H[:]
nombres_m = NOMBRES_M[:]
R.shuffle(nombres_h)
R.shuffle(nombres_m)


def crear(rol, cara, nombre):
    ap = R.sample(APELLIDOS, 2)
    u = {
        'id': str(uuid.uuid4()), 'rol': rol, 'nombres': nombre, 'apellidos': ' '.join(ap),
        'cedula': cedula(usadas), 'cara': f'cara_{cara}.jpg', 'punto': punto(),
    }
    base = f"{ascii(nombre.split()[0])}.{ascii(ap[0])}"
    email = f'{base}@{DOMINIO}'
    n = 2
    while any(x['email'] == email for x in usuarios):
        email = f'{base}{n}@{DOMINIO}'
        n += 1
    u['email'] = email
    usuarios.append(u)
    return u


tecnicos = ([crear('tecnico', c, nombres_h.pop()) for c in CARAS_H[:15]]
            + [crear('tecnico', c, nombres_m.pop()) for c in CARAS_M[:5]])
clientes = ([crear('cliente', c, nombres_h.pop()) for c in CARAS_H[15:25]]
            + [crear('cliente', c, nombres_m.pop()) for c in CARAS_M[5:25]])
R.shuffle(clientes)

OF_IDS = list(OFICIOS)
for i, t in enumerate(tecnicos):
    principal = OF_IDS[i % len(OF_IDS)]
    extras = R.sample([o for o in OF_IDS if o != principal], R.choice([0, 1, 2]))
    t['oficios'] = [principal] + extras
    t['tarifa'] = R.choice([15, 18, 20, 20, 25, 25, 30, 35])
    t['rango'] = R.choice([8000, 10000, 12000, 15000])

# ------------------------------------------------------------ 01 usuarios
l = ['-- 01: cuentas de prueba. El trigger trg_auth_nuevo_usuario crea usuarios,',
     '-- identidades y perfiles_tecnicos a partir de raw_user_meta_data.', 'begin;']
for u in usuarios:
    meta = json.dumps({'rol': u['rol'], 'cedula': u['cedula'], 'nombres': u['nombres'],
                       'apellidos': u['apellidos'], 'ciudad': 'Quito'}, ensure_ascii=False)
    l.append(
        "insert into auth.users (instance_id, id, aud, role, email, encrypted_password, "
        "email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, "
        "confirmation_token, recovery_token, email_change_token_new, email_change, "
        "email_change_token_current, phone_change, phone_change_token, reauthentication_token) values ("
        f"'00000000-0000-0000-0000-000000000000', '{u['id']}', 'authenticated', 'authenticated', "
        f"{q(u['email'])}, extensions.crypt({q(CLAVE)}, extensions.gen_salt('bf')), now(), "
        "'{\"provider\":\"email\",\"providers\":[\"email\"]}', "
        f"{q(meta)}::jsonb, now() - interval '{R.randint(100, 160)} days', now(), "
        "'', '', '', '', '', '', '', '');")
    ident = json.dumps({'sub': u['id'], 'email': u['email'], 'email_verified': True})
    l.append(
        "insert into auth.identities (provider_id, user_id, identity_data, provider, "
        f"last_sign_in_at, created_at, updated_at) values ('{u['id']}', '{u['id']}', "
        f"{q(ident)}::jsonb, 'email', now(), now(), now());")
l.append('commit;')
(AQUI / '01_usuarios.sql').write_text('\n'.join(l) + '\n')

# ------------------------------------------------------------ 02 perfiles
l = ['-- 02: foto validada, verificación manual (revisión del admin), ubicación,',
     '-- tarifa, rango y oficios.', 'begin;']
for u in usuarios:
    l.append(
        f"update usuarios set foto_perfil_ruta = '{u['id']}/perfil.jpg', foto_rostro_validada = true, "
        f"verificado_manual = true, ubicacion_registro = {geo(u['punto'])}, "
        f"creado_en = (select created_at from auth.users where id = '{u['id']}') "
        f"where id = '{u['id']}';")
for t in tecnicos:
    l.append(
        f"update perfiles_tecnicos set tarifa_base = {t['tarifa']}, rango_cobertura_m = {t['rango']}, "
        f"ubicacion_actual = {geo(t['punto'])} where usuario_id = '{t['id']}';")
    for o in t['oficios']:
        l.append(f"insert into tecnico_oficios (tecnico_id, oficio_id) values ('{t['id']}', {o});")
for u in usuarios:
    l.append(f"select public.recalcular_verificacion('{u['id']}');")
l.append('commit;')
(AQUI / '02_perfiles.sql').write_text('\n'.join(l) + '\n')

# ------------------------------------------------------------ historias
# Tipos: G completada+reseñas, F por_confirmar, E aceptada (visita futura),
# D ticket enviado, C chat abierto, B postulaciones, A abierta, H cancelada.
plan = ['G'] * 28 + ['F'] * 3 + ['E'] * 8 + ['D'] * 5 + ['C'] * 6 + ['B'] * 6 + ['A'] * 10 + ['H'] * 3

# Dos clientes VIP (5 cierres cada uno en los últimos 90 días).
vip = clientes[:2]
asignacion = []
for tipo in plan:
    asignacion.append([tipo, None])
g_idx = [i for i, a in enumerate(asignacion) if a[0] == 'G']
for k, i in enumerate(g_idx[:10]):
    asignacion[i][1] = vip[k % 2]
resto = clientes[2:]
for a in asignacion:
    if a[1] is None:
        a[1] = R.choice(resto)

ocupado_t = {}   # tecnico -> set((dia, hora))
ocupado_c = {}
malas_recibidas = {}
slot_tmp = [0]   # contador global de horas lejanas (para tickets que luego se mueven al pasado)


def slot_libre(t, c, dias, horas):
    R.shuffle(dias)
    for d in dias:
        for h in R.sample(horas, len(horas)):
            if (d, h) not in ocupado_t.setdefault(t['id'], set()) and (d, h) not in ocupado_c.setdefault(c['id'], set()):
                ocupado_t[t['id']].add((d, h))
                ocupado_c[c['id']].add((d, h))
                return d, h
    raise RuntimeError('sin horario libre')


def tecnicos_para(oficio, n):
    aptos = [t for t in tecnicos if oficio in t['oficios']]
    if len(aptos) < n:
        aptos += R.sample([t for t in tecnicos if t not in aptos], n - len(aptos))
    return R.sample(aptos, n)


historias = []
fechas = ['-- 04: fechas en el pasado para que haya historial creíble.', 'begin;']
for tipo, cliente in asignacion:
    oficio = R.choice(OF_IDS)
    nombre_of, descripciones, explicacion = OFICIOS[oficio]
    sol = str(uuid.uuid4())
    p = cliente['punto']
    lugar = (round(p[0] + R.uniform(-0.004, 0.004), 5), round(p[1] + R.uniform(-0.004, 0.004), 5))
    h = {'tipo': tipo, 'sol': sol, 'cliente': cliente, 'oficio': oficio, 'sql': []}
    s = h['sql']
    s.append(f"-- {tipo}: {nombre_of} para {cliente['nombres']}")
    s.append(SIN_SESION)
    s.append(
        "insert into solicitudes_servicio (id, cliente_id, oficio_id, descripcion, ubicacion, direccion_referencia) "
        f"values ('{sol}', '{cliente['id']}', {oficio}, {q(R.choice(descripciones))}, {geo(lugar)}, "
        f"{q(R.choice(BARRIOS) + ', cerca de ' + R.choice(['la esquina', 'el parque', 'la panadería', 'la tienda']))});")

    n_post = {'A': 0, 'H': 0, 'B': R.choice([1, 2, 3]), 'C': R.choice([1, 2]), 'D': R.choice([1, 2]),
              'E': R.choice([1, 2, 3]), 'F': R.choice([1, 2]), 'G': R.choice([1, 2, 3])}[tipo]
    elegidos = tecnicos_para(oficio, n_post) if n_post else []
    cots = {}
    for t in elegidos:
        cid = str(uuid.uuid4())
        cots[t['id']] = cid
        s.append(f"insert into cotizaciones (id, solicitud_id, tecnico_id, detalle) values "
                 f"('{cid}', '{sol}', '{t['id']}', {q(explicacion)});")

    # Antigüedad de la solicitud (para 04).
    if tipo == 'G':
        dia_servicio = None
    if tipo == 'H':
        s.append(f"update solicitudes_servicio set estado = 'cancelada' where id = '{sol}';")

    if tipo in 'CDEFG':
        t = elegidos[0]
        cid = cots[t['id']]
        h['tecnico'] = t
        s.append(como(cliente['id']))
        s.append(f"select public.iniciar_chat('{sol}', '{t['id']}');")
        conv = f"(select id from conversaciones where solicitud_id = '{sol}' and tecnico_id = '{t['id']}')"
        lineas = [(cliente, R.choice(CHAT_CLIENTE)), (t, R.choice(CHAT_TECNICO))]
        if tipo != 'C' or R.random() < 0.5:
            lineas += [(cliente, R.choice(CHAT_CLIENTE_2)), (t, R.choice(CHAT_TECNICO_2))]
        h['lineas'] = lineas
        for k, (autor, texto) in enumerate(lineas):
            # Hora provisional ordenada (04 la reemplaza); el cierre queda al final.
            s.append(f"insert into mensajes (conversacion_id, autor_id, contenido, enviado_en) select {conv}, "
                     f"'{autor['id']}', {q(texto)}, now() - interval '{20 - k} minutes';")

        if tipo in 'DEFG':
            precio = t['tarifa'] + R.choice([0, 0, 5, 10])
            if tipo == 'D':
                d, hh = slot_libre(t, cliente, list(range(2, 9)), [9, 10, 11, 14, 15, 16])
                fecha = hora_ec(d, hh)
            elif tipo == 'E':
                d, hh = slot_libre(t, cliente, list(range(1, 8)), [9, 10, 11, 14, 15, 16, 17])
                fecha = hora_ec(d, hh)
            else:
                # Temporal, lejano y único; 04 lo mueve al pasado.
                slot_tmp[0] += 2
                fecha = f"(now() + interval '60 days' + interval '{slot_tmp[0]} hours')"
            s.append(como(t['id']))
            s.append(f"select public.enviar_tarifa('{cid}', {precio}, 0, {fecha});")
            h['precio'] = precio

        if tipo in 'EFG':
            s.append(como(cliente['id']))
            s.append(f"select public.aceptar_cotizacion('{cid}');")

        if tipo in 'FG':
            if tipo == 'F':
                d, hh = slot_libre(t, cliente, [-1, -2], [9, 10, 11, 14, 15, 16])
            else:
                d, hh = slot_libre(t, cliente, list(range(-75, -2)), [9, 10, 11, 14, 15, 16])
            S = hora_ec(d, hh)
            h['S'] = S
            s.append(SIN_SESION)
            # Mover la visita al pasado y reescribir los mensajes del sistema.
            fechas.append(f"-- {tipo} {sol}")
            fechas.append(
                f"update cotizaciones set fecha_servicio = {S}, inicio_visita = {S}, "
                f"fin_visita = {S} + interval '1 hour', creado_en = {S} - interval '3 days' + interval '3 hours' "
                f"where id = '{cid}';")
            fechas.append(
                f"update cotizaciones set creado_en = {S} - interval '3 days' + interval '{R.randint(4, 20)} hours' "
                f"where solicitud_id = '{sol}' and id <> '{cid}';")
            fechas.append(f"update solicitudes_servicio set creado_en = {S} - interval '3 days' where id = '{sol}';")
            fechas.append(f"update conversaciones set creado_en = {S} - interval '3 days' + interval '4 hours' "
                          f"where solicitud_id = '{sol}';")
            for k in range(len(lineas)):
                fechas.append(
                    f"update mensajes set enviado_en = {S} - interval '3 days' + interval '4 hours' "
                    f"+ interval '{k * 7 + 2} minutes' where id = (select id from mensajes where conversacion_id = {conv} "
                    f"and tipo = 'texto' order by enviado_en, id offset {k} limit 1);")
            txt_fecha = f"to_char({S} at time zone 'America/Guayaquil', 'DD/MM/YYYY \"a las\" HH24:MI')"
            fechas.append(
                f"update mensajes set enviado_en = {S} - interval '2 days', "
                f"contenido = format('Ticket enviado: precio de la visita $%s, para el %s.', '{precio}.00', {txt_fecha}), "
                f"datos = datos || jsonb_build_object('fecha_servicio', {S}) "
                f"where conversacion_id = {conv} and datos->>'accion' = 'tarifa_enviada';")
            fechas.append(
                f"update mensajes set enviado_en = {S} - interval '2 days' + interval '1 hour', "
                f"contenido = format('El cliente confirmo el servicio para el %s por un total de $%s. Ya pueden coordinar los detalles.', {txt_fecha}, '{precio}.00'), "
                f"datos = datos || jsonb_build_object('fecha_servicio', {S}) "
                f"where conversacion_id = {conv} and datos->>'accion' = 'tarifa_aceptada';")
            fechas.append(
                f"update notificaciones set leida = true, creada_en = {S} - interval '2 days' "
                f"where usuario_id in ('{cliente['id']}', '{t['id']}') and referencia_id in "
                f"(select '{sol}'::uuid union select id from cotizaciones where solicitud_id = '{sol}' "
                f"union select id from conversaciones where solicitud_id = '{sol}');")

            # El técnico marca terminado; en G el cliente confirma.
            s.append(f"update solicitudes_servicio set estado = 'por_confirmar' where id = '{sol}';")
            s.append(f"insert into mensajes (conversacion_id, autor_id, contenido) select {conv}, "
                     f"'{t['id']}', {q(R.choice(CHAT_CIERRE_T))};")
            fechas.append(
                f"update mensajes set enviado_en = {S} + interval '90 minutes' where conversacion_id = {conv} "
                f"and autor_id = '{t['id']}' and contenido in ({', '.join(q(x) for x in CHAT_CIERRE_T)});")

        if tipo == 'G':
            s.append(f"update solicitudes_servicio set estado = 'completada' where id = '{sol}';")
            s.append(f"insert into mensajes (conversacion_id, autor_id, contenido) select {conv}, "
                     f"'{cliente['id']}', {q(R.choice(CHAT_CIERRE_C))};")
            fechas.append(
                f"update mensajes set enviado_en = {S} + interval '3 hours' where conversacion_id = {conv} "
                f"and autor_id = '{cliente['id']}' and contenido in ({', '.join(q(x) for x in CHAT_CIERRE_C)});")
            fechas.append(
                f"update eventos set creado_en = {S} + interval '3 hours' where tipo = 'negocio_cerrado' "
                f"and payload->>'solicitud_id' = '{sol}';")

            # Reseñas: casi todas buenas; como mucho UNA mala por persona
            # (con 2 llegaría el aviso de sanción).
            def nota(dest):
                r = R.random()
                if r < 0.04 and malas_recibidas.get(dest['id'], 0) == 0:
                    malas_recibidas[dest['id']] = 1
                    return R.choice([1, 2])
                if r < 0.12:
                    return 3
                return 4 if r < 0.30 else 5

            for autor, dest, para_tecnico in [(cliente, t, True), (t, cliente, False)]:
                n = nota(dest)
                if n >= 4:
                    etq = R.sample(ETQ_T_BIEN if para_tecnico else ETQ_C_BIEN, R.choice([1, 2, 3]))
                    com = R.choice(COMENT_T_BIEN if para_tecnico else COMENT_C_BIEN)
                elif n == 3:
                    etq, com = [], R.choice(COMENT_NEUTRO)
                else:
                    etq = ['Llegó tarde', 'Trabajo incompleto'] if para_tecnico else ['Tiempo de espera']
                    com = COMENT_MALO_T if para_tecnico else 'No estuvo a la hora acordada.'
                etq_sql = 'array[' + ', '.join(q(e) for e in etq) + ']::text[]' if etq else "'{}'::text[]"
                s.append(f"insert into resenas (solicitud_id, autor_id, destinatario_id, calificacion, comentario, etiquetas) "
                         f"values ('{sol}', '{autor['id']}', '{dest['id']}', {n}, {q(com)}, {etq_sql});")
            fechas.append(f"update resenas set creado_en = {S} + interval '{R.randint(4, 30)} hours' "
                          f"where solicitud_id = '{sol}';")
            fechas.append(
                f"update historial_puntos set creado_en = {S} + interval '1 day' where solicitud_id = '{sol}';")
            fechas.append(
                f"update notificaciones set leida = true, creada_en = {S} + interval '3 hours' "
                f"where referencia_id = '{sol}';")

    if tipo in 'ABCDEH':
        horas = R.randint(2, 72) if tipo in 'ABC' else R.randint(24, 96)
        fechas.append(f"update solicitudes_servicio set creado_en = now() - interval '{horas} hours' where id = '{sol}';")
        fechas.append(f"update cotizaciones set creado_en = now() - interval '{horas} hours' + interval '{R.randint(1, 3)} hours' "
                      f"where solicitud_id = '{sol}';")
        if tipo in 'CDE':
            conv = f"(select id from conversaciones where solicitud_id = '{sol}' and tecnico_id = '{h['tecnico']['id']}')"
            base = max(horas - 4, 1)
            fechas.append(f"update conversaciones set creado_en = now() - interval '{base} hours' where solicitud_id = '{sol}';")
            for k in range(len(h['lineas'])):
                fechas.append(
                    f"update mensajes set enviado_en = now() - interval '{base} hours' + interval '{k * 9 + 3} minutes' "
                    f"where id = (select id from mensajes where conversacion_id = {conv} and tipo = 'texto' "
                    f"order by enviado_en, id offset {k} limit 1);")
            fechas.append(f"update mensajes set enviado_en = now() - interval '{base} hours' + interval '50 minutes' "
                          f"where conversacion_id = {conv} and datos->>'accion' = 'tarifa_enviada';")
            fechas.append(f"update mensajes set enviado_en = now() - interval '{base} hours' + interval '2 hours' "
                          f"where conversacion_id = {conv} and datos->>'accion' = 'tarifa_aceptada';")
    historias.append(h)

fechas.append("update notificaciones n set leida = true where n.usuario_id in "
              "(select id from usuarios u join auth.users a using (id) where a.email like '%@" + DOMINIO + "') "
              "and n.creada_en < now() - interval '3 days';")
fechas.append('select public.recalcular_reputacion_reciente();')
fechas.append('commit;')
(AQUI / '04_fechas.sql').write_text('\n'.join(fechas) + '\n')

# Flujos en lotes (cada lote es una transacción).
lote, n = [], 1
for i, h in enumerate(historias, 1):
    lote += h['sql']
    if i % 12 == 0 or i == len(historias):
        (AQUI / f'03_flujos_{n}.sql').write_text('begin;\n' + '\n'.join(lote) + '\n' + SIN_SESION + '\ncommit;\n')
        lote, n = [], n + 1

# Limpieza.
(AQUI / '99_limpiar.sql').write_text(f"""-- Borra todo lo sembrado (cuentas @{DOMINIO} y lo que cuelga de ellas).
begin;
create temp table _ids on commit drop as
  select id from auth.users where email like '%@{DOMINIO}';
delete from resenas where autor_id in (select id from _ids) or destinatario_id in (select id from _ids);
delete from mensajes where conversacion_id in (select c.id from conversaciones c join solicitudes_servicio s on s.id = c.solicitud_id where s.cliente_id in (select id from _ids) or c.tecnico_id in (select id from _ids));
delete from conversaciones where tecnico_id in (select id from _ids) or solicitud_id in (select id from solicitudes_servicio where cliente_id in (select id from _ids));
delete from comisiones where cotizacion_id in (select id from cotizaciones where tecnico_id in (select id from _ids) or solicitud_id in (select id from solicitudes_servicio where cliente_id in (select id from _ids)));
delete from cotizaciones where tecnico_id in (select id from _ids) or solicitud_id in (select id from solicitudes_servicio where cliente_id in (select id from _ids));
delete from historial_puntos where tecnico_id in (select id from _ids);
delete from solicitudes_servicio where cliente_id in (select id from _ids);
delete from eventos where payload->>'tecnico_id' in (select id::text from _ids);
delete from auth.users where id in (select id from _ids);
commit;
""")

(AQUI / 'usuarios.json').write_text(json.dumps(
    [{k: u[k] for k in ('id', 'email', 'rol', 'nombres', 'apellidos', 'cara')} for u in usuarios],
    ensure_ascii=False, indent=1))
print('usuarios:', len(usuarios), 'tecnicos:', len(tecnicos), 'clientes:', len(clientes))
print('historias:', {t: plan.count(t) for t in 'ABCDEFGH'})
print('archivos:', sorted(p.name for p in AQUI.glob('*.sql')))
