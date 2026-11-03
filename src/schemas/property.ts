import { z } from "zod";
export const propertySchema=z.strictObject({address:z.string().trim().min(5),price:z.number().finite().nonnegative(),bedrooms:z.number().int().nonnegative(),bathrooms:z.number().finite().nonnegative(),square_feet:z.number().int().positive()});
export type PropertyInput=z.infer<typeof propertySchema>;
export const inquirySchema=z.strictObject({property_id:z.string().uuid(),inquirer_email:z.email(),message:z.string().trim().min(10)});
