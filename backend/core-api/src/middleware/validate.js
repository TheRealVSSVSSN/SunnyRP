export default function validate(zodSchema) {
    return (req, res, next) => {
        const parsed = zodSchema.safeParse({ body: req.body, query: req.query, params: req.params });
        if (!parsed.success) {
            return res.status(400).json({ ok: false, error: { code: 'BAD_REQUEST', message: 'Validation failed', details: parsed.error.issues } });
        }
        next();
    };
}