-- Certificaciones opcionales del técnico.
CREATE TABLE "public"."certificaciones_tecnico" (
  "id"           uuid                     NOT NULL DEFAULT gen_random_uuid(),
  "tecnico_id"   uuid                     NOT NULL,
  "nombre"       text                     NOT NULL,
  "entidad"      text                     NOT NULL,
  "anio"         integer,
  "ruta_archivo" text                     NOT NULL,
  "estado"       text                     NOT NULL DEFAULT 'pendiente'::text,
  "creado_en"    timestamp with time zone NOT NULL DEFAULT now(),
  "revisado_por" uuid,
  "revisado_en"  timestamp with time zone,
  CONSTRAINT "pk_certificaciones_tecnico" PRIMARY KEY (id),
  CONSTRAINT "fk_certificaciones_tecnico" FOREIGN KEY (tecnico_id) REFERENCES public.usuarios(id) ON DELETE CASCADE,
  CONSTRAINT "ck_certificaciones_estado" CHECK ((estado = ANY (ARRAY['pendiente'::text, 'aprobada'::text, 'rechazada'::text]))),
  CONSTRAINT "ck_certificaciones_anio" CHECK (((anio IS NULL) OR ((anio >= 1950) AND (anio <= 2100)))),
  CONSTRAINT "ck_certificaciones_nombre" CHECK ((char_length(btrim(nombre)) >= 3))
);

CREATE INDEX idx_certificaciones_tecnico ON public.certificaciones_tecnico USING btree (tecnico_id);

ALTER TABLE "public"."certificaciones_tecnico" ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE "public"."certificaciones_tecnico" FROM "anon";
REVOKE UPDATE ON TABLE "public"."certificaciones_tecnico" FROM "authenticated";
GRANT SELECT, INSERT, DELETE ON TABLE "public"."certificaciones_tecnico" TO "authenticated";
GRANT UPDATE ("estado", "revisado_por", "revisado_en") ON TABLE "public"."certificaciones_tecnico" TO "authenticated";

-- Cualquiera ve las aprobadas (perfil público); el resto, solo su dueño y el admin.
CREATE POLICY "certificaciones_lectura" ON "public"."certificaciones_tecnico"
  FOR SELECT
  TO "authenticated"
  USING (((estado = 'aprobada'::text) OR (tecnico_id = ( SELECT auth.uid() AS uid)) OR (public.mi_rol() = 'admin'::text)));

CREATE POLICY "certificaciones_insert" ON "public"."certificaciones_tecnico"
  FOR INSERT
  TO "authenticated"
  WITH CHECK (((tecnico_id = ( SELECT auth.uid() AS uid)) AND (public.mi_rol() = 'tecnico'::text) AND (estado = 'pendiente'::text) AND (revisado_por IS NULL) AND (revisado_en IS NULL)));

CREATE POLICY "certificaciones_revision_admin" ON "public"."certificaciones_tecnico"
  FOR UPDATE
  TO "authenticated"
  USING ((public.mi_rol() = 'admin'::text))
  WITH CHECK ((public.mi_rol() = 'admin'::text));

CREATE POLICY "certificaciones_borrar_propio" ON "public"."certificaciones_tecnico"
  FOR DELETE
  TO "authenticated"
  USING ((tecnico_id = ( SELECT auth.uid() AS uid)));
