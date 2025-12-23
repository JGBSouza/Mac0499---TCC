CREATE TABLE IF NOT EXISTS "patch" (
  "id" INTEGER,
  "title" TEXT NOT NULL,
  "author_email" TEXT,
  "status" VARCHAR(50) DEFAULT ('SENT') NOT NULL,
  "commit_hash" TEXT,
  "created_at" TEXT DEFAULT (datetime('now','localtime')),
  "contribution_id" INTEGER NOT NULL,
  CHECK ("status" IN ('SENT', 'APPROVED', 'MERGED', 'REVIEWED', 'REJECTED')),
  PRIMARY KEY("id"),
  FOREIGN KEY ("contribution_id") REFERENCES "contribution"("id") ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "contribution" (
  "id" INTEGER,
  "title" TEXT NOT NULL,
  "created_at" TEXT DEFAULT (datetime('now','localtime')),
  "last_interaction_at" TEXT DEFAULT (datetime('now','localtime')),
  "status" VARCHAR(50) DEFAULT ('SENT') NOT NULL,
  "author_email" TEXT NOT NULL,
  "repository_id" INTEGER,
  UNIQUE("title", "author_email")
  PRIMARY KEY("id"),
  FOREIGN KEY ("repository_id") REFERENCES "repository"("id") ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "submission" (
  "id" INTEGER,
  "contribution_id" INTEGER NOT NULL,
  "send_by" TEXT NOT NULL,
  "created_at" TEXT DEFAULT (datetime('now','localtime')),
  PRIMARY KEY("id"),
  FOREIGN KEY ("contribution_id") REFERENCES "contribution"("id") ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "patch_submission" (
  "patch_id" INTEGER NOT NULL,
  "submission_id" INTEGER NOT NULL,
  "message_id" TEXT NOT NULL,
  "created_at" TEXT DEFAULT (datetime('now','localtime')),
  PRIMARY KEY ("patch_id", "submission_id", "message_id"),
  FOREIGN KEY ("submission_id") REFERENCES "submission"("id") ON DELETE CASCADE,
  FOREIGN KEY ("patch_id") REFERENCES "patch"("id") ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "repository" (
  "id" INTEGER,
  "created_at" TEXT DEFAULT (datetime('now','localtime')),
  "name" TEXT NOT NULL,
  "origin_url" TEXT NOT NULL UNIQUE,
  PRIMARY KEY("id")
);

CREATE TABLE IF NOT EXISTS "repository_maintainer" (
  "id" INTEGER,
  "repository_id" INTEGER NOT NULL,
  "contact_id" INTEGER NOT NULL,
  PRIMARY KEY("id"),
  UNIQUE ("repository_id", "contact_id"),
  FOREIGN KEY ("repository_id") REFERENCES "repository"("id") ON DELETE CASCADE,
  FOREIGN KEY ("contact_id") REFERENCES "email_contact"("id") ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "email_contact" (
    "id" INTEGER NOT NULL UNIQUE,
    "name" VARCHAR(100) NOT NULL,
    "email" VARCHAR(100) NOT NULL UNIQUE,
    "created_at" TEXT DEFAULT (date('now', 'localtime')),
    PRIMARY KEY("id")
);