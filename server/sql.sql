CREATE TABLE "users"(
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  email VARCHAR(255),
  password VARCHAR(255),
  locale VARCHAR(20) default 'en-US'
);

CREATE TABLE "category"(
  id SERIAL PRIMARY KEY,
  title VARCHAR(255),
  user_id INTEGER REFERENCES "users" (id)
);

CREATE TABLE "token"(
  id SERIAL PRIMARY KEY,
  token VARCHAR(255),
  user_id INTEGER REFERENCES "users" (id),
  expires BIGINT
);

CREATE TABLE "record"(
  id SERIAL PRIMARY KEY,
  title VARCHAR(255),
  amount INTEGER,
  income BOOLEAN,
  user_id INTEGER REFERENCES "users" (id),
  category_id INTEGER REFERENCES "category" (id)
);

ALTER TABLE token ALTER COLUMN expires TYPE bigint;

SELECT SUM(record.amount), category.title
FROM "record"
RIGHT JOIN "category" ON record.category_id = category.id
WHERE record.user_id = 2 AND record.income = TRUE
GROUP BY category.id;

SELECT category.title, SUM(record.amount) FROM "category" LEFT JOIN "record" ON record.category_id = category.id WHERE record.user_id = 2 AND record.income = TRUE GROUP BY category.id;

ALTER TABLE "users" ADD COLUMN locale VARCHAR(20) default 'en-US';
