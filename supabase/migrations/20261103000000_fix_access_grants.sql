-- Follow-up migration: safe to apply after the original October 29 exam migration.
-- Correct grants for anonymous listing policies and administrator functionality.
GRANT EXECUTE ON FUNCTION public.is_platform_admin() TO anon, authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.profiles TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.property_sponsors TO authenticated;
DROP POLICY IF EXISTS "admin links update" ON public.property_sponsors;
CREATE POLICY "admin links update" ON public.property_sponsors
  FOR UPDATE TO authenticated
  USING (public.is_platform_admin())
  WITH CHECK (public.is_platform_admin());
