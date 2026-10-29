import "server-only";
import { cookies } from "next/headers";
import { createServerClient } from "@supabase/ssr";
export async function createClient(){
  const url=process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key=process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
  if(!url||!key) throw new Error("Missing Supabase public environment variables");
  const store=await cookies();
  return createServerClient(url,key,{cookies:{getAll(){return store.getAll()},setAll(items){try{items.forEach(({name,value,options})=>store.set(name,value,options))}catch{/* Server Component cannot set cookies; route handlers can. */}}}});
}
