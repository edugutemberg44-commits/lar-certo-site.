import {json,supa,catalog} from './_lib.js';
const decoder=new TextEncoder();
async function validSignature(raw,header,secret){
 const parts=Object.fromEntries((header||'').split(',').map(x=>x.split('=',2)));const t=Number(parts.t);
 if(!Number.isSafeInteger(t)||Math.abs(Date.now()/1000-t)>300||!parts.v1)return false;
 const key=await crypto.subtle.importKey('raw',decoder.encode(secret),{name:'HMAC',hash:'SHA-256'},false,['sign']);
 const signature=new Uint8Array(await crypto.subtle.sign('HMAC',key,decoder.encode(t+'.'+raw)));
 const received=parts.v1.toLowerCase();if(!/^[a-f0-9]{64}$/.test(received))return false;
 const expected=Array.from(signature,b=>b.toString(16).padStart(2,'0')).join('');
 let mismatch=0;for(let i=0;i<64;i++)mismatch|=expected.charCodeAt(i)^received.charCodeAt(i);return mismatch===0;
}
export async function onRequestPost({request,env}){
 if(!env.STRIPE_WEBHOOK_SECRET||!env.SUPABASE_URL||!env.SUPABASE_SERVICE_ROLE_KEY)return json({error:'Not configured'},503);
 const raw=await request.text();if(!(await validSignature(raw,request.headers.get('stripe-signature'),env.STRIPE_WEBHOOK_SECRET)))return json({error:'Invalid signature'},400);
 let event;try{event=JSON.parse(raw)}catch{return json({error:'Invalid event'},400)}
 if(event.type!=='checkout.session.completed'&&event.type!=='checkout.session.async_payment_succeeded')return json({received:true});
 const session=event.data?.object;const orderId=session?.metadata?.order_id;
 if(!/^[a-f0-9-]{36}$/i.test(orderId||''))return json({error:'Invalid order'},400);
 try{
 const rows=await supa(env,'service_orders?id=eq.'+encodeURIComponent(orderId)+'&select=id,plan,amount,currency,payment_status,stripe_checkout_session_id,customer_id');
 const order=rows[0];if(!order)return json({error:'Unknown order'},404);
 const plan=catalog[order.plan];
 if(!plan||session.id!==order.stripe_checkout_session_id||session.payment_status!=='paid'||session.currency!=='brl'||session.amount_total!==order.amount||order.amount!==plan.amount||session.metadata.user_id!==order.customer_id)return json({error:'Payment verification failed'},400);
 // Transactional SQL RPC enforces event idempotency and order transition atomically.
 await supa(env,'rpc/confirm_larcerto_payment',{method:'POST',body:JSON.stringify({p_event_id:event.id,p_event_type:event.type,p_order_id:order.id,p_payment_intent:typeof session.payment_intent==='string'?session.payment_intent:null})});
 return json({received:true});
 }catch(e){return json({error:'Temporary processing failure'},500)}
}
