/**
 * Minimal schema validator for plain objects.
 */
export function validate(schema, data) {
  for (const [key, rule] of Object.entries(schema)) {
    if (rule.required && data[key] === undefined) {
      return false;
    }
    if (data[key] !== undefined && typeof data[key] !== rule.type) {
      return false;
    }
  }
  return true;
}

export function assertValid(schema, data) {
  if (!validate(schema, data)) {
    const err = new Error('validation_error');
    err.status = 400;
    throw err;
  }
}
