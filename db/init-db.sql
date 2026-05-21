SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

CREATE DATABASE IF NOT EXISTS luceeapp;
USE luceeapp;

DROP TABLE IF EXISTS kanban_card_list;
DROP TABLE IF EXISTS kanban_card;
DROP TABLE IF EXISTS kanban_list;
DROP TABLE IF EXISTS author;
DROP TABLE IF EXISTS kanban;

CREATE TABLE IF NOT EXISTS kanban (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description VARCHAR(1024) DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS author (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) DEFAULT NULL,
  avatar LONGBLOB DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS kanban_list (
  id INT AUTO_INCREMENT PRIMARY KEY,
  kanban_id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  description VARCHAR(1024) DEFAULT NULL,
  list_order INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_kanban_list_kanban FOREIGN KEY (kanban_id) REFERENCES kanban(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS kanban_card (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  author_id INT NOT NULL,
  due_date DATE DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_kanban_card_author FOREIGN KEY (author_id) REFERENCES author(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS kanban_card_list (
  id INT AUTO_INCREMENT PRIMARY KEY,
  kanban_card_id INT NOT NULL,
  kanban_list_id INT NOT NULL,
  card_order INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_kanban_card_list_card FOREIGN KEY (kanban_card_id) REFERENCES kanban_card(id) ON DELETE CASCADE,
  CONSTRAINT fk_kanban_card_list_list FOREIGN KEY (kanban_list_id) REFERENCES kanban_list(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Sample example data matching the static examples in src/index.cfm
INSERT INTO kanban (name, description) VALUES ('Example Kanban','Kanban de exemplo para demonstração');
SET @kanban_id = LAST_INSERT_ID();

INSERT INTO kanban_list (kanban_id, name, description, list_order) VALUES
(@kanban_id, '📑 Pendentes', 'Tarefas pendentes', 1),
(@kanban_id, '🚀 Fazendo', 'Tarefas em andamento', 2);
SET @list1 = (SELECT id FROM kanban_list WHERE kanban_id = @kanban_id AND name = '📑 Pendentes' LIMIT 1);
SET @list2 = (SELECT id FROM kanban_list WHERE kanban_id = @kanban_id AND name = '🚀 Fazendo' LIMIT 1);

INSERT INTO author (name, email) VALUES
('Diego Smarrini','diego@example.com'),
('Gustavo Silva','gustavo@example.com'),
('Pedro Henrique','pedro@example.com');
SET @auth1 = (SELECT id FROM author WHERE name = 'Diego Smarrini' LIMIT 1);
SET @auth2 = (SELECT id FROM author WHERE name = 'Gustavo Silva' LIMIT 1);
SET @auth3 = (SELECT id FROM author WHERE name = 'Pedro Henrique' LIMIT 1);

INSERT INTO kanban_card (title, description, author_id, due_date) VALUES
('Implementar autenticação OAuth2 no servidor Lucee e testar conexão com o banco', 'Descrição do card de autenticação OAuth2', @auth1, '2026-05-15'),
('Ajustar Dockerfile para otimizar o cache das camadas do Node.js', 'Descrição do ajuste do Dockerfile', @auth2, '2026-05-14'),
('Integrar SortableJS', 'Adicionar arrastar e soltar com SortableJS', @auth3, NULL);

SET @card1 = (SELECT id FROM kanban_card WHERE title = 'Implementar autenticação OAuth2 no servidor Lucee e testar conexão com o banco' LIMIT 1);
SET @card2 = (SELECT id FROM kanban_card WHERE title = 'Ajustar Dockerfile para otimizar o cache das camadas do Node.js' LIMIT 1);
SET @card3 = (SELECT id FROM kanban_card WHERE title = 'Integrar SortableJS' LIMIT 1);

INSERT INTO kanban_card_list (kanban_card_id, kanban_list_id, card_order) VALUES
(@card1, @list1, 1),
(@card2, @list1, 2),
(@card3, @list2, 1);
