import { Router } from 'express';
import { z } from 'zod';
import { idempotency } from '../middleware/idempotency.js';
import { authToken, requireScope } from '../middleware/tokenAuth.js';
import { createRole, addRolePermission, listRoles } from '../repositories/roles.js';

const router = Router();
router.use(authToken);

router.get('/', requireScope('roles:read'), async (req, res, next) => {
  try {
    const roles = await listRoles();
    res.json(roles);
  } catch (err) {
    next(err);
  }
});

router.post('/', idempotency, requireScope('roles:write'), async (req, res, next) => {
  try {
    const body = z.object({ name: z.string().min(1), description: z.string().optional() }).parse(req.body);
    const role = await createRole(body.name, body.description || null);
    res.status(201).json(role);
  } catch (err) {
    next(err);
  }
});

router.post('/:roleId/permissions', idempotency, requireScope('roles:write'), async (req, res, next) => {
  try {
    const roleId = z.coerce.number().int().positive().parse(req.params.roleId);
    const body = z.object({ scope: z.string().min(1) }).parse(req.body);
    await addRolePermission(roleId, body.scope);
    res.status(204).end();
  } catch (err) {
    next(err);
  }
});

export default router;
