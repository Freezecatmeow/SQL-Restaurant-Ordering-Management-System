/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80046 (8.0.46)
 Source Host           : localhost:3306
 Source Schema         : homework

 Target Server Type    : MySQL
 Target Server Version : 80046 (8.0.46)
 File Encoding         : 65001

 Date: 24/05/2026 16:45:57
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `category_id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '分类编号',
  `category_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '分类名称',
  PRIMARY KEY (`category_id`) USING BTREE,
  UNIQUE INDEX `ux_category_name`(`category_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (4, '主食');
INSERT INTO `category` VALUES (2, '凉菜');
INSERT INTO `category` VALUES (3, '汤品');
INSERT INTO `category` VALUES (1, '热菜');

-- ----------------------------
-- Table structure for dining_table
-- ----------------------------
DROP TABLE IF EXISTS `dining_table`;
CREATE TABLE `dining_table`  (
  `table_id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '餐桌编号',
  `table_no` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '桌号（如 A01、B12）',
  `capacity` int UNSIGNED NOT NULL COMMENT '容纳人数',
  `status` tinyint(1) UNSIGNED ZEROFILL NOT NULL COMMENT '0-空闲，1-占用',
  `location` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '位置描述（如\"大厅\"\"包间\"）',
  PRIMARY KEY (`table_id`) USING BTREE,
  UNIQUE INDEX `ux_table_no`(`table_no` ASC) USING BTREE,
  CONSTRAINT `chk_capacity` CHECK (`capacity` > 0),
  CONSTRAINT `chk_status_dining` CHECK (`status` in (0,1))
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of dining_table
-- ----------------------------
INSERT INTO `dining_table` VALUES (1, 'A01', 4, 0, '大厅');
INSERT INTO `dining_table` VALUES (2, 'A02', 6, 0, '大厅');
INSERT INTO `dining_table` VALUES (3, 'B01', 8, 0, '包间');
INSERT INTO `dining_table` VALUES (4, 'B02', 2, 0, '大厅');

-- ----------------------------
-- Table structure for dish
-- ----------------------------
DROP TABLE IF EXISTS `dish`;
CREATE TABLE `dish`  (
  `dish_id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '菜品编号',
  `dish_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '菜品名称',
  `category_id` int UNSIGNED NOT NULL COMMENT '所属分类',
  `price` decimal(10, 2) UNSIGNED NOT NULL COMMENT '单价（元）',
  `description` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '菜品描述',
  `status` tinyint UNSIGNED NOT NULL DEFAULT 1 COMMENT '1-在售，0-下架',
  PRIMARY KEY (`dish_id`) USING BTREE,
  INDEX `out_category_id`(`category_id` ASC) USING BTREE,
  CONSTRAINT `out_category_id` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_price` CHECK (`price` > 0),
  CONSTRAINT `chk_status` CHECK (`status` in (0,1))
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of dish
-- ----------------------------
INSERT INTO `dish` VALUES (1, '鱼香肉丝', 1, 28.00, '经典川味热菜', 1);
INSERT INTO `dish` VALUES (2, '宫保鸡丁', 1, 32.00, '鲜香嫩滑', 1);
INSERT INTO `dish` VALUES (3, '凉拌黄瓜', 2, 8.00, '清爽解腻', 1);
INSERT INTO `dish` VALUES (4, '紫菜蛋花汤', 3, 12.00, '家常汤品', 1);
INSERT INTO `dish` VALUES (5, '米饭', 4, 2.00, '东北大米', 1);

-- ----------------------------
-- Table structure for order_detail
-- ----------------------------
DROP TABLE IF EXISTS `order_detail`;
CREATE TABLE `order_detail`  (
  `detail_id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '明细编号',
  `order_id` int UNSIGNED NOT NULL COMMENT '所属订单',
  `dish_id` int UNSIGNED NOT NULL COMMENT '菜品',
  `quantity` int UNSIGNED NOT NULL COMMENT '数量',
  `subtotal` decimal(10, 2) NOT NULL COMMENT '小计金额',
  PRIMARY KEY (`detail_id`) USING BTREE,
  INDEX `out_order_id`(`order_id` ASC) USING BTREE,
  INDEX `out_dish_id`(`dish_id` ASC) USING BTREE,
  CONSTRAINT `out_dish_id` FOREIGN KEY (`dish_id`) REFERENCES `dish` (`dish_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `out_order_id` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_quantity_order_detail` CHECK (`quantity` > 0)
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of order_detail
-- ----------------------------
INSERT INTO `order_detail` VALUES (2, 1, 1, 2, 56.00);
INSERT INTO `order_detail` VALUES (3, 1, 3, 1, 8.00);
INSERT INTO `order_detail` VALUES (4, 2, 4, 1, 12.00);
INSERT INTO `order_detail` VALUES (5, 2, 5, 5, 10.00);
INSERT INTO `order_detail` VALUES (6, 1, 1, 1, 0.00);

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `order_id` int(10) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT COMMENT '订单编号',
  `table_id` int UNSIGNED NOT NULL COMMENT '所属餐桌',
  `order_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '下单时间',
  `total_amount` decimal(10, 2) UNSIGNED ZEROFILL NULL DEFAULT NULL COMMENT '订单总金额',
  `status` tinyint(1) UNSIGNED ZEROFILL NOT NULL COMMENT '0-点餐中，1-已下单，2-已结账，3-已取消',
  `checkout_time` datetime NULL DEFAULT NULL COMMENT '结账时间',
  `remark` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`order_id`) USING BTREE,
  INDEX `out_dining_table`(`table_id` ASC) USING BTREE,
  CONSTRAINT `out_table_id` FOREIGN KEY (`table_id`) REFERENCES `dining_table` (`table_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_status_status` CHECK (`status` in (0,1,2,3))
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (0000000001, 1, '2026-05-24 16:04:39', 00000068.00, 1, NULL, '少放辣椒');
INSERT INTO `orders` VALUES (0000000002, 2, '2026-05-24 16:04:39', 00000022.00, 2, '2026-05-24 16:04:39', '无备注');

SET FOREIGN_KEY_CHECKS = 1;
