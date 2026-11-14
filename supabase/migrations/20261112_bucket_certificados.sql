-- Bucket privado para certificados (JPG, PNG o PDF, máx.
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'certificados', 'certificados', false, 5242880,
  ARRAY['image/jpeg', 'image/png', 'application/pdf']
)
ON CONFLICT (id) DO NOTHING;

-- El técnico sube a su carpeta (<uid>/archivo).
CREATE POLICY "certificados_subir_propio" ON storage.objects
  FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'certificados'
    AND (storage.foldername(name))[1] = (SELECT auth.uid())::text
    AND public.mi_rol() = 'tecnico'
  );

-- Lo ve su dueño y el admin (para revisarlo con URL firmada).
CREATE POLICY "certificados_leer" ON storage.objects
  FOR SELECT
  TO authenticated
  USING (
    bucket_id = 'certificados'
    AND ((storage.foldername(name))[1] = (SELECT auth.uid())::text
         OR public.mi_rol() = 'admin')
  );

CREATE POLICY "certificados_borrar_propio" ON storage.objects
  FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'certificados'
    AND (storage.foldername(name))[1] = (SELECT auth.uid())::text
  );
