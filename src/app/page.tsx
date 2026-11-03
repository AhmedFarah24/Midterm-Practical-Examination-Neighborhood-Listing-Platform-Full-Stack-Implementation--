import PropertyCard, { type PublicProperty } from "@/components/PropertyCard";
import { createClient } from "@/lib/supabaseServer";

export const dynamic = "force-dynamic";

type ListingRow = Omit<PublicProperty, "sponsors"> & {
  property_sponsors: { sponsors: { name: string; tier: "gold" | "silver" | "bronze" } | null }[] | null;
};

export default async function Home() {
  let properties: PublicProperty[] = [];
  let message = "";
  try {
    const db = await createClient();
    const { data, error } = await db
      .from("properties")
      .select("id,address,price,bedrooms,bathrooms,square_feet,property_sponsors(sponsors(name,tier))")
      .eq("status", "approved")
      .order("created_at", { ascending: false });
    if (error) throw error;
    properties = ((data ?? []) as unknown as ListingRow[]).map(({ property_sponsors, ...property }) => ({
      ...property,
      sponsors: (property_sponsors ?? []).flatMap(({ sponsors }) => sponsors ? [sponsors] : []),
    }));
  } catch {
    message = "Listings are temporarily unavailable. Check the Supabase configuration.";
  }
  return (
    <main className="mx-auto max-w-6xl px-5 py-10">
      <h1 className="text-3xl font-bold">Explore neighborhood properties</h1>
      <p className="my-4 text-slate-600">
        Browse verified listings, see active local sponsors, and ask about a property privately.
      </p>
      {message ? (
        <p role="alert">{message}</p>
      ) : properties.length ? (
        <section aria-label="Approved properties" className="grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-3">
          {properties.map((property) => <PropertyCard key={property.id} property={property} />)}
        </section>
      ) : (
        <p>No approved listings are available yet.</p>
      )}
    </main>
  );
}
