# Configurare Email Confirmare Supabase

## Pași pentru configurare în Supabase Dashboard

### 1. Configurare Redirect URL

1. Mergi la **Supabase Dashboard** → **Authentication** → **URL Configuration**
2. La **Site URL** pune: `urbanreporter://auth`
3. La **Redirect URLs** adaugă:
   - `urbanreporter://auth`
   - `urbanreporter://auth/callback`

### 2. Configurare Email Template (Opțional - pentru email în română)

1. Mergi la **Authentication** → **Email Templates**
2. Selectează **Confirm signup**
3. Înlocuiește conținutul cu:

**Subject:**
```
Confirmă contul tău - Raportare Urbană
```

**Body:**
```html
<h2>Bine ai venit la Raportare Urbană!</h2>

<p>Salut,</p>

<p>Mulțumim pentru înregistrare. Te rugăm să confirmi adresa de email făcând click pe butonul de mai jos:</p>

<p>
  <a href="{{ .ConfirmationURL }}" style="background-color: #4CAF50; color: white; padding: 14px 20px; text-decoration: none; border-radius: 4px; display: inline-block;">
    Confirmă Contul
  </a>
</p>

<p>Sau copiază acest link în browser:</p>
<p>{{ .ConfirmationURL }}</p>

<p><strong>Atenție:</strong> Acest link expiră în 10 minute.</p>

<p>Dacă nu ai creat un cont, poți ignora acest email.</p>

<p>Cu respect,<br>Echipa Raportare Urbană</p>
```

### 3. Configurare Expirare Token (10 minute)

1. Mergi la **Authentication** → **Email Templates**
2. La **Confirm signup**, setează **Token expiry** la `600` secunde (10 minute)

### 4. Verificare Setări Email

1. Mergi la **Project Settings** → **Authentication**
2. Asigură-te că **Enable email confirmations** este activat
3. La **Mailer OTP Expiration** setează `600` (10 minute)

---

## Testare

1. Înregistrează un utilizator nou în aplicație
2. Verifică emailul primit
3. Click pe link-ul de confirmare
4. Aplicația ar trebui să se deschidă și să te autentifice automat

## Troubleshooting

**Link-ul nu deschide aplicația:**
- Verifică că ai instalat ultima versiune a APK-ului
- Pe unele telefoane trebuie să setezi aplicația ca default pentru link-uri `urbanreporter://`

**Email nu ajunge:**
- Verifică folderul Spam
- Verifică că Resend API key este configurat corect în Supabase
