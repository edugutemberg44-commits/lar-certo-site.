import {json,supa,userFromToken,stripe,catalog} from './_lib.js';
export async function onRequestPost({request,env}){
 if(!env.SUPABASE_URL||!env.SUPABASE_SERVICE_ROLE_KEY||!env.STRIPE_SECRET_KEY||!env.PUBLIC_SITE_URL)return json({error:'Pagamento temporariamente indisponível.'},503);
 if(!env.STRIPE_SECRET_KEY.startsWith('sk_test_'))return json({error:'Cobranças reais desativadas até a validação completa.'},503);
 const user=await userFromToken(env,request);if(!user)return json({error:'Entre na sua conta para continuar.'},401);
 let body;try{body=await request.json()}catch{return json({error:'Dados inválidos.'},400)}
 const plan=catalog[body?.plan];if(!plan)return json({error:'Plano inválido.'},400);
 const base=env.PUBLIC_SITE_URL.replace(/\/$/,'');if(!/^https:\/\//.test(base))return json({error:'Configuração de domínio inválida.'},503);
 try{
 const rows=await supa(env,'service_orders',{method:'POST',headers:{Prefer:'return=representation'},body:JSON.stringify({customer_id:user.id,plan:body.plan,amount:plan.amount,currency:'brl',payment_status:'pending',production_status:'awaiting_payment'})});
 const order=rows[0];
 const answers=body.answers&&typeof body.answers==='object'&&!Array.isArray(body.answers)?body.answers:{};
 await supa(env,'quiz_responses',{method:'POST',body:JSON.stringify({order_id:order.id,customer_id:user.id,answers})});
 const session=await stripe(env,'checkout/sessions',{
 mode:'payment',success_url:base+'/minha-conta?checkout=retorno',cancel_url:base+'/escolher-plano?cancelado=1',
 client_reference_id:order.id,'metadata[order_id]':order.id,'metadata[user_id]':user.id,'metadata[plan]':body.plan,
 'line_items[0][price_data][currency]':'brl','line_items[0][price_data][unit_amount]':String(plan.amount),
 'line_items[0][price_data][product_data][name]':plan.label,'line_items[0][quantity]':'1',
 'payment_method_types[0]':'card'
 });
 await supa(env,'service_orders?id=eq.'+encodeURIComponent(order.id),{method:'PATCH',body:JSON.stringify({stripe_checkout_session_id:session.id})});
 return json({url:session.url});
 }catch(e){return json({error:'Não foi possível iniciar o pagamento. Tente novamente.'},502)}
}
