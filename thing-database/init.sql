CREATE TABLE things (
  id VARCHAR(50) PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

INSERT INTO things (id, name) VALUES 
  ('1', 'First Thing'),
  ('2', 'Second Thing'),
  ('3', 'Third Thing');