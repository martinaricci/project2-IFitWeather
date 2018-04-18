CREATE DATABASE IFitWeather;

CREATE TABLE users (
  id SERIAL4 PRIMARY KEY,
  username VARCHAR (50),
  password_digest VARCHAR(100)
);

CREATE TABLE activities (
  id SERIAL4 PRIMARY KEY,
  content VARCHAR(400),
  user_id INTEGER NOT NULL,
  FOREIGN KEY(user_id) REFERENCES users (id)
);
