select * from usuarios;
#tables
CREATE table usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  login VARCHAR(50) UNIQUE NOT NULL,
  senha VARCHAR(255) NOT NULL
);

CREATE TABLE log (
  id INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT NOT NULL,
  acao VARCHAR(100) NOT NULL,
  detalhes TEXT,
  data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

CREATE TABLE motor (
  id INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT NOT NULL,
  velocidade INT NOT NULL,
  status varchar(20) not null,
  data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);


#procedures

DELIMITER $$
CREATE PROCEDURE inserir_dados_usuario (
    IN p_nome VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_login VARCHAR(50),
    IN p_senha VARCHAR(255)
)
BEGIN
    IF p_nome IS NULL OR p_email IS NULL OR p_senha IS NULL OR p_login IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Campos obrigatórios não foram informados';
    END IF;

    INSERT INTO usuarios (nome, email, login, senha)
    VALUES (p_nome, p_email, p_login, p_senha);
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE AtualizarDadosUsuario (
    IN p_id INT,
    IN p_novo_email VARCHAR(100),
    IN p_novo_nome VARCHAR(50),
    IN p_novo_login VARCHAR(50),
    IN p_nova_senha VARCHAR(255)
)
BEGIN
    UPDATE usuarios
    SET 
        email = COALESCE(NULLIF(p_novo_email, ''), email),
        nome = COALESCE(NULLIF(p_novo_nome, ''), nome),
		login = COALESCE(NULLIF(p_novo_login, ''), login),
        senha = COALESCE(NULLIF(p_nova_senha, ''), senha)
    WHERE id = p_id;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE DeletarUsuario(
    IN p_id INT
)
BEGIN
    DELETE FROM usuarios WHERE id = p_id;
END $$

DELIMITER ;

DELIMITER$$
CREATE PROCEDURE RegistrarLog(
    IN p_usuario_id INT,
    IN p_acao VARCHAR(100),
    IN p_detalhes TEXT
)
BEGIN
    INSERT INTO log (usuario_id, acao, detalhes)
    VALUES (p_usuario_id, p_acao, p_detalhes);
    END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE RegistrarLogMotor (
  IN p_usuario_id INT,
  IN p_velocidade INT,
  IN p_status varchar(20)
)
BEGIN
  INSERT INTO motor (usuario_id, velocidade, status)
  VALUES (p_usuario_id, p_velocidade, p_status);
END$$

DELIMITER ;
