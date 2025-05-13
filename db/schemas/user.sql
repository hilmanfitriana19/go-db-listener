CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);


CREATE OR REPLACE FUNCTION notify_user_change()
RETURNS TRIGGER AS $$
DECLARE
    payload JSON;
BEGIN
    payload = json_build_object(
        'operation', TG_OP,
        'table', TG_TABLE_NAME,
        'id', NEW.id,
        'name', NEW.name,
        'email', NEW.email
    );

    PERFORM pg_notify('user_changes', payload::text);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER user_change_trigger
AFTER INSERT OR UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION notify_user_change();
