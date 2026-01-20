-- ============================================
-- Performance Optimization Indexes
-- Add composite indexes to improve dashboard query performance
-- ============================================

-- Add composite index for status + created_at (for today/week/month order counts)
-- Check if index exists before creating
SET @exist := (SELECT COUNT(*) FROM information_schema.statistics 
               WHERE table_schema = DATABASE() 
               AND table_name = 'orders1' 
               AND index_name = 'idx_status_created');
SET @sqlstmt := IF(@exist > 0, 'SELECT ''Index idx_status_created already exists''', 
                'CREATE INDEX idx_status_created ON orders1(status, created_at)');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Add composite index for status + delivered_at (for delivered orders filtering)
SET @exist := (SELECT COUNT(*) FROM information_schema.statistics 
               WHERE table_schema = DATABASE() 
               AND table_name = 'orders1' 
               AND index_name = 'idx_status_delivered');
SET @sqlstmt := IF(@exist > 0, 'SELECT ''Index idx_status_delivered already exists''', 
                'CREATE INDEX idx_status_delivered ON orders1(status, delivered_at)');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Add composite index for status + cancelled_at (for cancelled orders filtering)
SET @exist := (SELECT COUNT(*) FROM information_schema.statistics 
               WHERE table_schema = DATABASE() 
               AND table_name = 'orders1' 
               AND index_name = 'idx_status_cancelled');
SET @sqlstmt := IF(@exist > 0, 'SELECT ''Index idx_status_cancelled already exists''', 
                'CREATE INDEX idx_status_cancelled ON orders1(status, cancelled_at)');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Add composite index for role + created_at on users1 (for new user statistics)
SET @exist := (SELECT COUNT(*) FROM information_schema.statistics 
               WHERE table_schema = DATABASE() 
               AND table_name = 'users1' 
               AND index_name = 'idx_role_created');
SET @sqlstmt := IF(@exist > 0, 'SELECT ''Index idx_role_created already exists''', 
                'CREATE INDEX idx_role_created ON users1(role, created_at)');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Add composite index for role + username on users1 (for driver dropdowns)
SET @exist := (SELECT COUNT(*) FROM information_schema.statistics 
               WHERE table_schema = DATABASE() 
               AND table_name = 'users1' 
               AND index_name = 'idx_role_username');
SET @sqlstmt := IF(@exist > 0, 'SELECT ''Index idx_role_username already exists''', 
                'CREATE INDEX idx_role_username ON users1(role, username)');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Show created indexes
SELECT 'Performance indexes created successfully!' as Status;
SHOW INDEX FROM orders1 WHERE Key_name LIKE 'idx_status%';
SHOW INDEX FROM users1 WHERE Key_name = 'idx_role_created';
