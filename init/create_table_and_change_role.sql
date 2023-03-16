-- create table
CREATE TABLE memos(
  id UUID NOT NULL,
  title VARCHAR(50),
  content TEXT,
  PRIMARY KEY(id)
);

-- change role
GRANT ALL PRIVILEGES ON memos To memo_user;
