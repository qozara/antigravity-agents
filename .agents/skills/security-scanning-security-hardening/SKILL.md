---
name: security-scanning-security-hardening
description: Code hardening, dependency vulnerability scanning, secure headers, CORS, CSRF, and injection prevention. Use when hardening endpoints, middleware, and application configurations against exploit vectors.
---

# Application Security Hardening

## Hardening Guidelines
1. **HTTP Security Headers:**
   - Configure CSP (Content Security Policy), HSTS, X-Content-Type-Options, and X-Frame-Options.
2. **CORS & CSRF Protections:**
   - Restrict allowed origins to trusted domains.
   - Validate anti-CSRF tokens or SameSite cookie attributes on state-changing requests.
3. **Input Sanitization & Output Encoding:**
   - Sanitize HTML inputs to prevent XSS.
   - Parameterize all database queries.
