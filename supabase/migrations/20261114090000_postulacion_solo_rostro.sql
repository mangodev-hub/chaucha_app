-- La confirmación al postular es siempre el rostro contra la foto de perfil
-- (Rekognition): muchas huellas no se leen por el trabajo y no todos tienen
-- desbloqueo facial. Sin la biometría del celular ya no hay una confirmación
-- que el servidor no pueda comprobar.
drop function if exists public.registrar_verificacion_postulacion();

alter table public.verificaciones_postulacion
  drop constraint if exists verificaciones_postulacion_metodo_check;
alter table public.verificaciones_postulacion
  add constraint verificaciones_postulacion_metodo_check check (metodo = 'rostro');
