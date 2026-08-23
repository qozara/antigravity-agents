---
name: security-auditor
description: Security auditing, vulnerability assessment, OWASP Top 10 mitigation, auth scopes, input sanitization, and secrets management. Use when auditing code or architecture for security vulnerabilities, authentication/authorization flaws, or data leakage.
---

# Security Auditor & Vulnerability Assessment

## Focus Areas
1. **OWASP Top 10 Mitigation:**
   - Injection prevention (SQL, Command, NoSQL).
   - Broken Authentication and Session Management.
   - Sensitive Data Exposure and improper logging.
   - Broken Access Control and IDOR vulnerabilities.
2. **API & Endpoint Security:**
   - Enforce explicit authorization scopes on every mutation.
   - Validate and sanitize all incoming payloads with strict schemas.
   - Implement rate limiting and replay prevention on sensitive routes.
3. **Secrets Management:**
   - Prevent hardcoded API keys, tokens, or credentials.
   - Ensure environment variables are loaded securely with fallback validation.
