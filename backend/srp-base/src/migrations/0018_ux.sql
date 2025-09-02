CREATE TABLE IF NOT EXISTS chat_messages (
  id INT PRIMARY KEY AUTO_INCREMENT,
  character_id INT NOT NULL,
  message TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (character_id) REFERENCES characters(id)
);

CREATE TABLE IF NOT EXISTS votes (
  id INT PRIMARY KEY AUTO_INCREMENT,
  question TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ends_at TIMESTAMP NULL
);

CREATE TABLE IF NOT EXISTS vote_options (
  id INT PRIMARY KEY AUTO_INCREMENT,
  vote_id INT NOT NULL,
  option_text VARCHAR(128) NOT NULL,
  count INT NOT NULL DEFAULT 0,
  FOREIGN KEY (vote_id) REFERENCES votes(id)
);

CREATE TABLE IF NOT EXISTS vote_responses (
  vote_id INT NOT NULL,
  character_id INT NOT NULL,
  option_id INT NOT NULL,
  PRIMARY KEY (vote_id, character_id),
  FOREIGN KEY (vote_id) REFERENCES votes(id),
  FOREIGN KEY (option_id) REFERENCES vote_options(id)
);
