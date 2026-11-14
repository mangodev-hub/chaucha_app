-- Publicidad: la app se financia con anuncios.
CREATE TABLE IF NOT EXISTS public.anuncios (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  titulo text NOT NULL CHECK (char_length(titulo) BETWEEN 1 AND 80),
  descripcion text NOT NULL DEFAULT '' CHECK (char_length(descripcion) <= 160),
  imagen_ruta text,
  url_destino text CHECK (url_destino IS NULL OR url_destino ~* '^https?://'),
  ubicacion text NOT NULL DEFAULT 'home_cliente',
  activo boolean NOT NULL DEFAULT true,
  fecha_inicio timestamptz,
  fecha_fin timestamptz,
  creado_en timestamptz NOT NULL DEFAULT now(),
  CHECK (fecha_fin IS NULL OR fecha_inicio IS NULL OR fecha_fin > fecha_inicio)
);

CREATE INDEX IF NOT EXISTS anuncios_ubicacion_activos_idx
  ON public.anuncios (ubicacion) WHERE activo;

ALTER TABLE public.anuncios ENABLE ROW LEVEL SECURITY;

-- Solo lectura para usuarios autenticados, y solo lo activo y vigente.
CREATE POLICY "anuncios_leer_vigentes" ON public.anuncios
  FOR SELECT
  TO authenticated
  USING (
    activo
    AND (fecha_inicio IS NULL OR fecha_inicio <= now())
    AND (fecha_fin IS NULL OR fecha_fin >= now())
  );

REVOKE INSERT, UPDATE, DELETE ON public.anuncios FROM anon, authenticated;
GRANT SELECT ON public.anuncios TO authenticated;

-- Bucket público para las imágenes (JPG, PNG o WebP, máx.
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'anuncios', 'anuncios', true, 1048576,
  ARRAY['image/jpeg', 'image/png', 'image/webp']
)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "anuncios_subir_admin" ON storage.objects
  FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'anuncios' AND public.mi_rol() = 'admin');

CREATE POLICY "anuncios_borrar_admin" ON storage.objects
  FOR DELETE
  TO authenticated
  USING (bucket_id = 'anuncios' AND public.mi_rol() = 'admin');
