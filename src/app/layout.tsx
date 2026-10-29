import Link from "next/link";
import type { Metadata } from "next";
import "./globals.css";
export const metadata: Metadata = { title:"Neighborhood Listing Platform", description:"Discover approved properties and send private inquiries." };
export default function RootLayout({children}:{children:React.ReactNode}) { return <html lang="en"><body><header className="bg-slate-900 p-5 text-white"><nav aria-label="Main navigation" className="mx-auto max-w-6xl"><Link href="/" className="font-semibold">Neighborhood Listing Platform</Link></nav></header>{children}<footer className="mx-auto max-w-6xl p-6 text-sm text-slate-600">Property listings and inquiries</footer></body></html> }
