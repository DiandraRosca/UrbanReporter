# Supabase Email Templates

Go to **Supabase Dashboard → Authentication → Email Templates** and update each template.

---

## ✅ 1. Reset Password (Resetare parolă) - DONE

```html
<!DOCTYPE html>
<html lang="ro">
<head>
    <meta charset="UTF-8" />
    <title>Resetare parolă</title>
</head>
<body style="margin: 0; padding: 0; background-color: #1f1f23; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; color: #e5e7eb;">
    <table width="100%" cellpadding="0" cellspacing="0" style="background-color: #1f1f23; padding: 40px 0">
        <tr>
            <td align="center">
                <table width="100%" cellpadding="0" cellspacing="0" style="max-width: 600px; background-color: #111113; border-radius: 12px; padding: 40px;">
                    <!-- Header -->
                    <tr>
                        <td style="text-align: center; padding-bottom: 24px">
                            <h1 style="margin: 0; font-size: 26px; font-weight: 700; color: #ffffff;">Resetare parolă 🔐</h1>
                        </td>
                    </tr>
                    <!-- Content -->
                    <tr>
                        <td style="font-size: 16px; line-height: 1.6; color: #d1d5db">
                            <p style="margin-top: 0">Salut,</p>
                            <p>Am primit o solicitare de resetare a parolei pentru contul tău Raportare Urbană. Apasă pe butonul de mai jos pentru a seta o parolă nouă.</p>
                        </td>
                    </tr>
                    <!-- Button -->
                    <tr>
                        <td align="center" style="padding: 30px 0">
                            <a href="{{ .ConfirmationURL }}" style="background-color: #7c3aed; color: #ffffff; text-decoration: none; padding: 14px 28px; border-radius: 8px; font-size: 16px; font-weight: 600; display: inline-block;">Resetează parola</a>
                        </td>
                    </tr>
                    <!-- Fallback link -->
                    <tr>
                        <td style="font-size: 14px; line-height: 1.6; color: #9ca3af">
                            <p>Dacă butonul nu funcționează, copiază și deschide acest link în browser:</p>
                            <p style="word-break: break-all; background-color: #1f1f23; padding: 12px; border-radius: 6px; color: #c4b5fd;">{{ .ConfirmationURL }}</p>
                            <p style="margin-top: 16px"><strong>Atenție:</strong> acest link expiră în <strong>10 minute</strong>.</p>
                            <p>Dacă nu ai solicitat resetarea parolei, poți ignora acest email. Parola ta va rămâne neschimbată.</p>
                        </td>
                    </tr>
                    <!-- Footer -->
                    <tr>
                        <td style="border-top: 1px solid #2a2a30; margin-top: 32px; padding-top: 24px; font-size: 14px; color: #9ca3af; text-align: center;">
                            <p style="margin: 0">Cu respect,<br /><strong style="color: #e5e7eb">Echipa Raportare Urbană</strong></p>
                        </td>
                    </tr>
                </table>
                <!-- Footer note -->
                <p style="margin-top: 24px; font-size: 12px; color: #6b7280;">© {{ .CurrentYear }} Raportare Urbană. Toate drepturile rezervate.</p>
            </td>
        </tr>
    </table>
</body>
</html>
```

---

## Required Supabase Settings

In **Authentication → URL Configuration**:
- **Site URL**: `urbanreporter://auth`
- **Redirect URLs**: Add `urbanreporter://auth`

---

## How It Works

1. User taps "Ai uitat parola?" in app
2. Enters email → Supabase sends reset email
3. User clicks link in email → Opens Supabase verification URL
4. Supabase verifies token → Redirects to `urbanreporter://auth`
5. App detects `AuthChangeEvent.passwordRecovery`
6. App shows "Set new password" screen
7. User enters new password → Done!

No database tables needed - Supabase handles token storage internally.
