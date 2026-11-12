-- Perfil público del cliente: sus reseñas deben poder leerlas los técnicos.
DROP POLICY IF EXISTS "resenas_lectura" ON "public"."resenas";

CREATE POLICY "resenas_lectura" ON "public"."resenas"
  FOR SELECT
  TO "authenticated"
  USING (true);
