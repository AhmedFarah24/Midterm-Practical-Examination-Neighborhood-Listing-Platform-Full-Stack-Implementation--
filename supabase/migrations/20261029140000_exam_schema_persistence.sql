-- Midterm practical: apply once to a fresh Supabase project.
CREATE TABLE public.profiles (
 id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
 role TEXT NOT NULL CHECK(role IN ('admin','property_owner','sponsor','public')),
 created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text,now())
);
CREATE TABLE public.sponsors (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
 name TEXT NOT NULL CHECK(char_length(name)>=2),
 tier TEXT NOT NULL CHECK(tier IN ('gold','silver','bronze')),
 active_status BOOLEAN NOT NULL DEFAULT true,
 created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text,now())
);
CREATE TABLE public.properties (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
 owner_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE RESTRICT,
 address TEXT NOT NULL,
 price NUMERIC(12,2) NOT NULL CHECK(price>=0),
 bedrooms INTEGER NOT NULL CHECK(bedrooms>=0),
 bathrooms NUMERIC(3,1) NOT NULL CHECK(bathrooms>=0),
 square_feet INTEGER NOT NULL CHECK(square_feet>0),
 status TEXT NOT NULL DEFAULT 'draft' CHECK(status IN ('draft','pending','approved','rejected')),
 created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text,now())
);
CREATE TABLE public.property_sponsors (
 property_id UUID REFERENCES public.properties(id) ON DELETE CASCADE,
 sponsor_id UUID REFERENCES public.sponsors(id) ON DELETE CASCADE,
 PRIMARY KEY(property_id,sponsor_id)
);
CREATE TABLE public.inquiries (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
 property_id UUID NOT NULL REFERENCES public.properties(id) ON DELETE CASCADE,
 inquirer_email TEXT NOT NULL CHECK(inquirer_email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
 message TEXT NOT NULL CHECK(char_length(message)>=10),
 created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text,now())
);
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sponsors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.properties ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.property_sponsors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.inquiries ENABLE ROW LEVEL SECURITY;
-- Helper uses definer privileges to prevent recursive policies while only exposing whether current user is an administrator.
CREATE FUNCTION public.is_platform_admin() RETURNS BOOLEAN
LANGUAGE sql STABLE SECURITY DEFINER SET search_path=''
AS $$ SELECT EXISTS(SELECT 1 FROM public.profiles WHERE id=auth.uid() AND role='admin') $$;
REVOKE ALL ON FUNCTION public.is_platform_admin() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.is_platform_admin() TO authenticated;
-- Ensure only trusted administrators can create privileged profiles.
CREATE POLICY "own or admin profile read" ON public.profiles FOR SELECT TO authenticated
USING(id=auth.uid() OR public.is_platform_admin());
CREATE POLICY "admin profile insert" ON public.profiles FOR INSERT TO authenticated
WITH CHECK(public.is_platform_admin());
CREATE POLICY "admin profile update" ON public.profiles FOR UPDATE TO authenticated
USING(public.is_platform_admin()) WITH CHECK(public.is_platform_admin());
CREATE POLICY "admin profile delete" ON public.profiles FOR DELETE TO authenticated
USING(public.is_platform_admin());
CREATE POLICY "public active sponsors" ON public.sponsors FOR SELECT TO anon,authenticated USING(active_status OR public.is_platform_admin());
CREATE POLICY "admin sponsor insert" ON public.sponsors FOR INSERT TO authenticated WITH CHECK(public.is_platform_admin());
CREATE POLICY "admin sponsor update" ON public.sponsors FOR UPDATE TO authenticated USING(public.is_platform_admin()) WITH CHECK(public.is_platform_admin());
CREATE POLICY "admin sponsor delete" ON public.sponsors FOR DELETE TO authenticated USING(public.is_platform_admin());
CREATE POLICY "approved or own properties" ON public.properties FOR SELECT TO anon,authenticated
USING(status='approved' OR (auth.uid() IS NOT NULL AND owner_id=auth.uid()) OR public.is_platform_admin());
CREATE POLICY "owner draft insert" ON public.properties FOR INSERT TO authenticated
WITH CHECK(owner_id=auth.uid() AND status='draft' AND EXISTS(SELECT 1 FROM public.profiles WHERE id=auth.uid() AND role='property_owner') OR public.is_platform_admin());
-- Only draft/rejected listings may be modified by owners. Owners cannot self-approve.
CREATE POLICY "owner limited update" ON public.properties FOR UPDATE TO authenticated
USING((owner_id=auth.uid() AND status IN ('draft','rejected')) OR public.is_platform_admin())
WITH CHECK((owner_id=auth.uid() AND status IN ('draft','pending','rejected')) OR public.is_platform_admin());
CREATE POLICY "owner limited delete" ON public.properties FOR DELETE TO authenticated
USING((owner_id=auth.uid() AND status IN ('draft','rejected')) OR public.is_platform_admin());
CREATE POLICY "public property sponsors" ON public.property_sponsors FOR SELECT TO anon,authenticated
USING((EXISTS(SELECT 1 FROM public.properties p WHERE p.id=property_id AND p.status='approved')
 AND EXISTS(SELECT 1 FROM public.sponsors s WHERE s.id=sponsor_id AND s.active_status)) OR public.is_platform_admin());
CREATE POLICY "admin links insert" ON public.property_sponsors FOR INSERT TO authenticated WITH CHECK(public.is_platform_admin());
CREATE POLICY "admin links delete" ON public.property_sponsors FOR DELETE TO authenticated USING(public.is_platform_admin());
-- Grant read of zero inquiries to anonymous/public roles.
CREATE POLICY "inquiry insert approved listing" ON public.inquiries FOR INSERT TO anon,authenticated
WITH CHECK(EXISTS(SELECT 1 FROM public.properties p WHERE p.id=property_id AND p.status='approved'));
CREATE POLICY "owner or admin inquiry read" ON public.inquiries FOR SELECT TO authenticated
USING(public.is_platform_admin() OR EXISTS(SELECT 1 FROM public.properties p WHERE p.id=property_id AND p.owner_id=auth.uid()));
CREATE POLICY "admin inquiry update" ON public.inquiries FOR UPDATE TO authenticated USING(public.is_platform_admin()) WITH CHECK(public.is_platform_admin());
CREATE POLICY "admin inquiry delete" ON public.inquiries FOR DELETE TO authenticated USING(public.is_platform_admin());
-- Access to the exposed tables is still governed by RLS.
GRANT SELECT ON public.profiles TO authenticated;
GRANT SELECT,INSERT,UPDATE,DELETE ON public.properties TO authenticated;
GRANT SELECT ON public.properties TO anon;
GRANT SELECT,INSERT,UPDATE,DELETE ON public.sponsors TO authenticated;
GRANT SELECT ON public.sponsors TO anon;
GRANT SELECT,INSERT,DELETE ON public.property_sponsors TO authenticated;
GRANT SELECT ON public.property_sponsors TO anon;
GRANT INSERT ON public.inquiries TO anon,authenticated;
GRANT SELECT,UPDATE,DELETE ON public.inquiries TO authenticated;
-- Bootstrap the first administrator using a trusted elevated dashboard operation, never client-exposed credentials.
