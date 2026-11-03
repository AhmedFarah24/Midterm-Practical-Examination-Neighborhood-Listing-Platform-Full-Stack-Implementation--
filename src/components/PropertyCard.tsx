import Link from "next/link";

export type PublicProperty = {
  id: string;
  address: string;
  price: number;
  bedrooms: number;
  bathrooms: number;
  square_feet: number;
  sponsors?: { name: string; tier: "gold" | "silver" | "bronze" }[];
};

export default function PropertyCard({ property }: { property: PublicProperty }) {
  return (
    <article className="rounded-xl border border-slate-200 bg-white p-5 shadow-sm">
      <header>
        <h2 className="text-xl font-semibold">{property.address}</h2>
        <p className="mt-2 text-lg font-bold">
          ${Number(property.price).toLocaleString("en-US")}
        </p>
      </header>
      <ul className="my-4 space-y-1 text-slate-700">
        <li>{property.bedrooms} bedrooms</li>
        <li>{property.bathrooms} bathrooms</li>
        <li>{Number(property.square_feet).toLocaleString("en-US")} square feet</li>
      </ul>
      {property.sponsors && property.sponsors.length > 0 && (
        <section aria-label="Local sponsors" className="mb-4 rounded-lg bg-slate-50 p-3">
          <h3 className="mb-2 text-sm font-semibold">Local sponsors</h3>
          <ul className="space-y-1 text-sm">
            {property.sponsors.map((sponsor, index) => (
              <li key={`${sponsor.name}-${index}`}>
                {sponsor.name} — <span className="capitalize">{sponsor.tier}</span>
              </li>
            ))}
          </ul>
        </section>
      )}
      <Link
        href={`/properties/${property.id}`}
        aria-label={`View details for ${property.address}`}
        className="inline-block rounded-md bg-blue-700 px-4 py-2 font-medium text-white focus-visible:ring-2 focus-visible:ring-offset-2"
      >
        View Details
      </Link>
    </article>
  );
}
