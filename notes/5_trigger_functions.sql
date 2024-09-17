--В PL/pgSQL можно создавать триггерные функции, которые будут вызываться при изменениях данных или событиях в базе данных
-- source: https://postgrespro.ru/docs/postgresql/11/plpgsql-trigger
alter table users
  add column name text;

-- executes ones, do now work when update
update users
set name = concat(first_name, ' ', last_name);


-- sql / pspgsql
CREATE OR REPLACE FUNCTION public.update_users_name()
  RETURNS trigger AS
$BODY$
BEGIN
  NEW.name = concat(NEW.first_name, ' ', NEW.last_name);
  RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
                   COST 100;

CREATE TRIGGER "update_users_name_on_insert_trigger"
  BEFORE insert
  ON users
  FOR EACH ROW
EXECUTE PROCEDURE "update_users_name"();

-- Триггеры при изменении данных
CREATE TRIGGER "update_users_name_on_update_trigger"
  BEFORE UPDATE OF first_name, last_name
  ON users
  FOR EACH ROW
  WHEN ((new.first_name != old.first_name) or (new.last_name != old.last_name))
EXECUTE PROCEDURE "update_users_name"();
-- можно заменить функциональным индексом concat(first_name, ' ', last_name)

-- Триггерная функция для аудита в PL/pgSQL
CREATE OR REPLACE VIEW public.users_alert AS
SELECT
  'There are ' || COUNT(*) || ' users with created_at later than now()' as alert
FROM
  public.users
WHERE
  created_at > NOW();

CREATE OR REPLACE FUNCTION update_users_alert()
  RETURNS TRIGGER AS
$$
BEGIN
  -- Обновление представления происходит автоматически, так как оно основано на запросе
  -- Триггерная функция вызывается при вставке и обновлении в таблицу users
  RETURN NEW; -- Возвращаем новую строку для продолжения вставки
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER users_alert_trigger
  AFTER INSERT OR UPDATE ON public.users
  FOR EACH ROW
EXECUTE FUNCTION update_users_alert();


-- use case
-- перенос данных в новую таблицу 
