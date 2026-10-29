import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabaseServer";
import { inquirySchema } from "@/schemas/property";

export async function POST(request: Request) {
  let body: unknown;

  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON" }, { status: 400 });
  }

  const parsed = inquirySchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json(
      { error: "Validation failed", details: parsed.error.flatten() },
      { status: 400 }
    );
  }

  try {
    const db = await createClient();
    const { data: listing, error: listingError } = await db
      .from("properties")
      .select("id")
      .eq("id", parsed.data.property_id)
      .eq("status", "approved")
      .maybeSingle();

    if (listingError || !listing) {
      return NextResponse.json({ error: "Property not available" }, { status: 404 });
    }

    const { error } = await db.from("inquiries").insert(parsed.data);
    if (error) {
      return NextResponse.json({ error: "Unable to submit inquiry" }, { status: 500 });
    }

    return NextResponse.json({ message: "Inquiry submitted" }, { status: 201 });
  } catch {
    return NextResponse.json({ error: "Server unavailable" }, { status: 500 });
  }
}
