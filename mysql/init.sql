-- OpenClaw Database Initialization Script
-- This script runs automatically when MySQL container starts for the first time

-- Create additional tables if needed
CREATE TABLE IF NOT EXISTS `system_config` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `config_key` VARCHAR(100) NOT NULL,
  `config_value` TEXT,
  `description` VARCHAR(500),
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_config_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default configuration
INSERT INTO `system_config` (`config_key`, `config_value`, `description`) VALUES
('system.name', 'OpenClaw', 'System name'),
('system.version', '1.0.0', 'System version'),
('system.maintenance', 'false', 'Maintenance mode flag')
ON DUPLICATE KEY UPDATE `config_value` = VALUES(`config_value`);
