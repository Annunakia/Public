-- ============================================================
-- 06_consolidacion_persistencia.sql
-- Consolida scores de 4 canales y actualiza RELACION_PERSONA_UBICACION
-- Fuente: P0027_UBI_ORDENAMIENTO_111.TPT + P0027_UBI_ORDENAMIENTO_130.TPT
-- ============================================================
-- Input: bdm_datos.score_ordenamiento (ya poblada por 02-05)
-- Output: UPDATE bdm_datos.relacion_persona_ubicacion.orden_prioridad
-- ============================================================

-- PASO 1: Guardar orden anterior y marcar fecha
UPDATE bdm_datos.relacion_persona_ubicacion
SET orden_prioridad = NULL,
    fecha_relacion_persona_ubicaci = CURRENT_DATE
WHERE cod_dw_persona_ubic IN (
  SELECT cod_dw_persona_ubic FROM bdm_datos.score_ordenamiento
);

-- PASO 2: Asignar nuevo orden (lugar del scoring)
UPDATE bdm_datos.relacion_persona_ubicacion
SET orden_prioridad = s.lugar
FROM bdm_datos.score_ordenamiento s
WHERE bdm_datos.relacion_persona_ubicacion.cod_dw_persona_ubic = s.cod_dw_persona_ubic;

ANALYZE bdm_datos.relacion_persona_ubicacion;
