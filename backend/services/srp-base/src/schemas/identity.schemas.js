// src/schemas/identity.schemas.js
import { z } from 'zod';

export const PlayerLinkRequestSchema = z.object({
    primary: z.enum(['license', 'steam', 'discord']),
    identifiers: z.array(z.string().min(3)).min(1),
    ip: z.string().min(3).optional()
});

export const PermissionsPathSchema = z.object({
    playerId: z.string().min(1)
});