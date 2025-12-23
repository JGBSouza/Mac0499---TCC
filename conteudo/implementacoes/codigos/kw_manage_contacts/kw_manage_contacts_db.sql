-- Table containing the kw email groups infos
CREATE TABLE IF NOT EXISTS "email_group" (
    "id" INTEGER NOT NULL UNIQUE,
    "name" VARCHAR(50) NOT NULL UNIQUE,
    "created_at" TEXT DEFAULT (date('now', 'localtime')),
    PRIMARY KEY("id")
);

-- Table containing the kw email contacts infos
CREATE TABLE IF NOT EXISTS "email_contact" (
    "id" INTEGER NOT NULL UNIQUE,
    "name" VARCHAR(100) NOT NULL,
    "email" VARCHAR(100) NOT NULL UNIQUE,
    "created_at" TEXT DEFAULT (date('now', 'localtime')),
    PRIMARY KEY("id")
);

-- Table containing the association between a kw email group and it's contacts
CREATE TABLE IF NOT EXISTS "email_contact_group" (
    "contact_id" INTEGER,
    "group_id" INTEGER,
    PRIMARY KEY ("contact_id", "group_id"),
    FOREIGN KEY ("contact_id") REFERENCES "email_contact"("id") ON DELETE CASCADE,
    FOREIGN KEY ("group_id") REFERENCES "email_group"("id") ON DELETE CASCADE
);

CREATE TRIGGER IF NOT EXISTS "delete_contact_if_no_group"
AFTER DELETE ON "email_contact_group"
FOR EACH ROW
WHEN (SELECT COUNT(*) FROM "email_contact_group" WHERE "contact_id" = OLD.contact_id) = 0
BEGIN
    DELETE FROM "email_contact" WHERE "id" = OLD.contact_id;
END;