-- Executar após a migração inicial, sob role privilegiada.
-- Garante idempotência do evento e atualização do pedido na mesma transação.
create or replace function public.confirm_larcerto_payment(
 p_event_id text,p_event_type text,p_order_id uuid,p_payment_intent text default null
) returns boolean language plpgsql security definer set search_path='' as $$
declare inserted_count integer;
begin
 if p_event_id is null or length(p_event_id)>255 or p_event_type not in ('checkout.session.completed','checkout.session.async_payment_succeeded') then raise exception 'invalid event'; end if;
 insert into public.payment_events(stripe_event_id,event_type,order_id)
 values(p_event_id,p_event_type,p_order_id)
 on conflict(stripe_event_id) do nothing;
 get diagnostics inserted_count=row_count;
 if inserted_count=0 then return false; end if;
 update public.service_orders set payment_status='paid',production_status=case when production_status='awaiting_payment' then 'awaiting_photos' else production_status end,stripe_payment_intent_id=coalesce(p_payment_intent,stripe_payment_intent_id),updated_at=now()
 where id=p_order_id and payment_status in ('pending','paid');
 if not found then raise exception 'order cannot be confirmed'; end if;
 return true;
end $$;
revoke all on function public.confirm_larcerto_payment(text,text,uuid,text) from public,anon,authenticated;
grant execute on function public.confirm_larcerto_payment(text,text,uuid,text) to service_role;
