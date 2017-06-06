DROP TABLE IF EXISTS user;
CREATE TABLE user (
    id               INTEGER PRIMARY KEY,
    username         VARCHAR(100) UNIQUE NOT NULL,
    full_name        VARCHAR(100),
    email            VARCHAR(100),
    password         VARCHAR(255),
    registered_date  DATE,
    verified         BOOLEAN DEFAULT FALSE
);

