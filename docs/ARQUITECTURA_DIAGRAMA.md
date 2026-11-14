# ChauchaApp: diagramas de arquitectura

Los diagramas están en Mermaid. GitHub los dibuja solo al abrir este archivo;
también se pueden pegar en https://mermaid.live para exportarlos como PNG o SVG.

## 1. Vista general

```mermaid
flowchart TB
  APP["App Flutter<br/>Web y Android (un solo código)"]

  subgraph Supabase["Supabase (backend)"]
    direction TB
    subgraph Servicios[" "]
      direction LR
      AUTH["Auth<br/>correo + contraseña"]
      API["API REST / RPC"]
      RT["Realtime<br/>chat y avisos en vivo"]
      ST["Storage<br/>fotos y documentos"]
    end

    subgraph PG["PostgreSQL"]
      direction LR
      TBL["Tablas + RLS"]
      TRG["Triggers<br/>reglas de negocio"]
      GIS["PostGIS<br/>distancias"]
      GIST["btree_gist<br/>sin choques de horario"]
      CRON["pg_cron<br/>tareas programadas"]
      NET["pg_net + Vault<br/>webhook seguro"]
    end

    subgraph EF["Edge Functions"]
      direction LR
      F1["validar-foto-rostro<br/>comparar-rostro-cedula"]
      F3["enviar-push"]
    end
  end

  subgraph Externos["Servicios externos"]
    direction LR
    GEM["Google Gemini<br/>IA de visión"]
    FCM["Firebase Cloud Messaging<br/>push"]
    OSM["OpenStreetMap<br/>mapas"]
  end

  APP --> AUTH
  APP --> API
  APP <--> RT
  APP --> ST
  APP --> F1
  APP --> OSM

  API --> TBL --> TRG
  TRG --> GIS
  TRG --> GIST
  CRON --> TRG
  TRG --> NET --> F3 --> FCM
  FCM -. "notificación con la app cerrada" .-> APP
  F1 --> GEM
```

## 2. Cómo llega una notificación push

```mermaid
sequenceDiagram
  autonumber
  participant C as Cliente (app)
  participant DB as PostgreSQL
  participant N as pg_net
  participant EF as Edge Function enviar-push
  participant F as Firebase (FCM)
  participant T as Técnico (app cerrada)

  C->>DB: envía un mensaje (INSERT en mensajes)
  DB->>DB: trigger crea la fila en notificaciones
  DB->>N: trigger trg_notificacion_push
  N->>EF: POST con el secreto de Vault
  EF->>DB: valida el secreto y busca los tokens del técnico
  EF->>F: envía el aviso (FCM HTTP v1)
  F-->>T: notificación del sistema
  T->>T: al tocarla, abre la pestaña correcta
```

## 3. Vida de una solicitud

```mermaid
stateDiagram-v2
  [*] --> abierta: el cliente publica
  abierta --> cotizada: un técnico postula
  cotizada --> aceptada: el cliente acepta el ticket (día y hora)
  aceptada --> por_confirmar: el técnico marca terminado
  por_confirmar --> completada: el cliente confirma
  completada --> [*]: reseñas, puntos y sanciones

  abierta --> cancelada: el cliente cancela
  cotizada --> cancelada: expira a los 30 días (pg_cron)
  aceptada --> cotizada: se cancela el ticket aceptado
  aceptada --> cancelada
  por_confirmar --> cancelada
```

## 4. Tareas programadas (pg_cron)

```mermaid
flowchart TB
  A["00:00 Ecuador<br/>expirar-solicitudes"] --> A1["Cancela abiertas o cotizadas<br/>con más de 30 días y avisa al cliente"]
  B["00:30 Ecuador<br/>recalcular-reputacion"] --> B1["Bono de rango del técnico<br/>(+500 m por reseña excelente en 90 días)"]
  B --> B2["Cliente VIP<br/>(5 cierres en 90 días, sin reseñas malas)"]
  C["Cada hora<br/>avisar-fin-sanciones"] --> C1["Avisa a quien terminó<br/>su suspensión de 7 días"]
```
