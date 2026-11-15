# Lar Certo — desenvolvimento (não publicar como produção)
## Estado real
- Interface e quiz de 8 etapas: implementados em JS, ainda sem testes automatizados.
- Checkout Stripe: endpoint Pages Functions criado, somente aceita `sk_test_`; frontend ainda não conectado.
- Webhook: assinatura HMAC validada, valor/moeda/plano/pedido verificados; RPC SQL transacional criada, ainda não aplicada nem testada.
- Supabase: migrações preparadas, NÃO aplicadas. Antes de executar, inspecionar tabelas e políticas existentes. Não aplicar cegamente.
- Auth, upload, painel admin, entrega, emails, portfólio com pares autorizados, políticas jurídicas e visual 3D final: pendentes.
## Secrets Cloudflare Pages (configurar apenas no painel seguro)
`SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`, `STRIPE_SECRET_KEY` (somente teste), `STRIPE_WEBHOOK_SECRET`, `PUBLIC_SITE_URL`.
Nunca colocar service role ou segredo Stripe em `VITE_*`, arquivos versionados ou mensagens.
## Testes obrigatórios antes do merge
1. `npm ci && npm run build`, verificar navegador desktop/mobile e console.
2. Executar migrações em ambiente de staging, verificar RLS com dois usuários e sem autenticação.
3. Integrar login real no frontend e passar JWT Supabase para POST `/api/checkout`.
4. Verificar Stripe test checkout, webhook assinado, evento duplicado, pagamento cancelado e falha.
5. Verificar isolamento de arquivos, liberação somente após pagamento confirmado.
6. Revisar termos, privacidade, reembolso e consentimento.
7. Só então considerar merge e deploy.
## Aviso
Os preços do catálogo no backend são fonte autoritativa; migrar para configuração administrativa segura antes de operação comercial.
