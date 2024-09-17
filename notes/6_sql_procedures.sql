create or replace function get_user_clients(_user_id integer) returns TABLE(client_id integer)
  cost 10
  rows 100
  language plpgsql
as $$
BEGIN
  RETURN QUERY
    select t.client_id from user_client_link as t where user_id=_user_id;
END
$$;


select * from get_user_clients(1)
