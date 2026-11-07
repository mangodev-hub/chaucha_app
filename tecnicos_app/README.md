# Técnicos a domicilio · Frontend (Flutter)

Proyecto EAGLEDEV 2026. App móvil (Android) y web con un solo código,
conectada a Supabase. Arquitectura MVVM por módulos con gestor de estados
propio (ver ADRs del frontend).

## Ejecutar

```bash
cp env.example.json env.json   # y completa tus valores
flutter pub get
flutter run -d chrome --web-port=3000 --dart-define-from-file=env.json
```

## Calidad

```bash
flutter analyze
flutter test
bash scripts/verificar_adr.sh
```

## Avance por pasos

| Paso | Contenido | Estado |
|---|---|---|
| 1 | Esqueleto, `core/` (estado, validadores, geo, router, Supabase) | ✅ |
| 2 | Autenticación, sesión y roles | ✅ |
| — | **Prototipo completo** (cliente, técnico, cotizaciones, chat, perfil) | ✅ ver `docs/PROTOTIPO.md` |

Detalle de cada paso en `docs/pasos/`.
