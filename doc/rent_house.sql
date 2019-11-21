/*
 Navicat MySQL Data Transfer

 Source Server         : webserver
 Source Server Type    : MySQL
 Source Server Version : 50727
 Source Host           : www.hadoop02.com:3306
 Source Schema         : rent_house

 Target Server Type    : MySQL
 Target Server Version : 50727
 File Encoding         : 65001

 Date: 22/11/2019 07:28:46
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for bill
-- ----------------------------
DROP TABLE IF EXISTS `bill`;
CREATE TABLE `bill`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `last_bill_id` int(11) NULL DEFAULT NULL COMMENT '上一张账单的id',
  `charge_template_room_id` int(11) NOT NULL COMMENT '由哪个charge_template_room记录生成的',
  `cover_degree_start` double NULL DEFAULT NULL COMMENT '本账单从几度开始覆盖，默认是上一张账单的cover_degree_end',
  `cover_degree_end` double NULL DEFAULT NULL COMMENT '本账单覆盖到的度数是多少，只有在unit为度数时有效',
  `cover_when_start` datetime(0) NULL DEFAULT NULL COMMENT '本账单的覆盖从哪一天开始',
  `cover_when_end` datetime(0) NOT NULL COMMENT '本账单cover到哪个日期为止，只有unit为日期时有效',
  `pay_date` datetime(0) NULL DEFAULT NULL COMMENT '支付的日期\r\n            为空时表示未支付',
  `pay_by` int(11) NULL DEFAULT NULL COMMENT '此账单应由谁支付，用户id',
  `status` int(11) NOT NULL DEFAULT 0 COMMENT '此账单的状态\r\n-1 无需处理(入住账单为此值)\r\n0 可采集\r\n1 已保存\r\n2 已审核通过\r\n3 已生成',
  `type` int(2) NOT NULL DEFAULT 0 COMMENT '此账单类型：0 普通账单  1 入住账单  2 搬出账单',
  `bill_set_id` int(11) NULL DEFAULT NULL COMMENT '属于哪个billSet',
  `is_deleted` int(11) NOT NULL DEFAULT 0 COMMENT '此账单是否被删除\r\n            0 未删除\r\n            1 已删除',
  `modify_date` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后修改时间',
  `create_date` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 44 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '账单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bill
-- ----------------------------
INSERT INTO `bill` VALUES (1, NULL, 12, 44, 22, '2019-11-15 08:14:43', '2019-11-17 08:14:47', NULL, NULL, -1, 1, NULL, 0, '2019-11-20 22:43:37', '2019-11-16 08:16:07');
INSERT INTO `bill` VALUES (2, 1, 12, 55, 23, '2019-11-05 08:17:49', '2019-11-17 08:17:52', NULL, NULL, 3, 0, NULL, 0, '2019-11-20 22:42:41', '2019-11-16 08:17:57');
INSERT INTO `bill` VALUES (3, NULL, 13, 12, 44, '2019-11-12 08:18:30', '2019-11-22 08:18:35', NULL, NULL, -1, 1, NULL, 0, '2019-11-20 22:43:35', '2019-11-16 08:18:37');
INSERT INTO `bill` VALUES (4, 3, 13, 445, 222, '2019-11-04 08:18:51', '2019-11-22 08:18:56', NULL, NULL, 3, 0, NULL, 0, '2019-11-20 22:42:48', '2019-11-16 08:18:54');
INSERT INTO `bill` VALUES (5, NULL, 14, 12, 22, '2019-11-28 08:19:11', '2019-11-30 08:19:14', NULL, NULL, -1, 1, NULL, 0, '2019-11-20 22:43:31', '2019-11-16 08:19:16');
INSERT INTO `bill` VALUES (6, 5, 14, 2323, 4412, '2019-10-01 08:19:26', '2019-11-21 08:19:30', NULL, NULL, 3, 0, NULL, 0, '2019-11-20 22:42:49', '2019-11-16 08:19:32');
INSERT INTO `bill` VALUES (15, NULL, 62, NULL, 123, NULL, '2019-11-17 00:00:00', NULL, NULL, -1, 1, NULL, 0, '2019-11-20 22:41:47', '2019-11-17 14:22:06');
INSERT INTO `bill` VALUES (16, NULL, 63, NULL, 444, NULL, '2019-11-22 00:00:00', NULL, NULL, -1, 1, NULL, 0, '2019-11-20 22:41:48', '2019-11-17 14:22:06');
INSERT INTO `bill` VALUES (17, NULL, 62, 123, 1234, '2019-11-17 00:00:00', '2019-11-17 00:00:00', NULL, NULL, -1, 1, NULL, 0, '2019-11-20 22:41:50', '2019-11-17 16:06:29');
INSERT INTO `bill` VALUES (18, NULL, 63, 444, 4444, '2019-11-22 00:00:00', '2019-11-22 00:00:00', NULL, NULL, -1, 1, NULL, 0, '2019-11-20 22:41:52', '2019-11-17 16:06:29');
INSERT INTO `bill` VALUES (31, NULL, 53, NULL, NULL, NULL, '2019-11-17 00:00:00', NULL, NULL, -1, 1, NULL, 0, '2019-11-20 22:41:55', '2019-11-17 16:16:14');
INSERT INTO `bill` VALUES (34, NULL, 53, NULL, NULL, NULL, '2019-11-17 00:00:00', NULL, NULL, -1, 1, NULL, 0, '2019-11-20 22:41:58', '2019-11-17 16:29:52');
INSERT INTO `bill` VALUES (35, NULL, 53, NULL, NULL, NULL, '2019-11-17 00:00:00', NULL, NULL, -1, 1, NULL, 0, '2019-11-20 22:41:59', '2019-11-17 16:29:52');
INSERT INTO `bill` VALUES (36, NULL, 12, NULL, NULL, NULL, '2019-11-17 00:00:00', NULL, NULL, -1, 1, NULL, 0, '2019-11-20 22:42:00', '2019-11-17 16:29:52');
INSERT INTO `bill` VALUES (37, NULL, 65, NULL, 324, NULL, '2019-11-19 00:00:00', NULL, NULL, -1, 1, NULL, 0, '2019-11-20 22:42:02', '2019-11-17 17:52:26');
INSERT INTO `bill` VALUES (38, NULL, 66, NULL, 112, NULL, '2019-11-21 00:00:00', NULL, NULL, -1, 1, NULL, 0, '2019-11-20 22:42:03', '2019-11-17 17:52:26');
INSERT INTO `bill` VALUES (39, NULL, 65, 324, 324, '2019-11-19 00:00:00', '2019-11-22 00:00:00', NULL, NULL, -1, 1, NULL, 0, '2019-11-20 22:42:05', '2019-11-17 17:53:05');
INSERT INTO `bill` VALUES (40, NULL, 41, NULL, 600, NULL, '2019-11-18 00:00:00', NULL, NULL, -1, 1, NULL, 0, '2019-11-20 22:42:06', '2019-11-18 06:39:41');
INSERT INTO `bill` VALUES (41, NULL, 71, NULL, 1411, NULL, '2019-11-19 00:00:00', NULL, NULL, -1, 1, NULL, 0, '2019-11-20 22:42:07', '2019-11-19 22:20:20');
INSERT INTO `bill` VALUES (42, NULL, 72, NULL, 2245, NULL, '2019-11-19 00:00:00', NULL, NULL, -1, 1, NULL, 0, '2019-11-20 22:42:08', '2019-11-19 22:20:20');
INSERT INTO `bill` VALUES (43, NULL, 70, NULL, NULL, NULL, '2019-11-19 00:00:00', NULL, NULL, -1, 1, NULL, 0, '2019-11-20 22:42:09', '2019-11-19 22:20:22');

-- ----------------------------
-- Table structure for bill_set
-- ----------------------------
DROP TABLE IF EXISTS `bill_set`;
CREATE TABLE `bill_set`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `room_id` int(11) NOT NULL COMMENT '账单集所属房间id',
  `bill_set_date` datetime(0) NOT NULL COMMENT '账单集的所属时间如7月1日等，会写在收据右上角',
  `bill_batch_num` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '账单集的编码，用此编码来对账',
  `bill_mode` tinyint(2) NOT NULL DEFAULT 1 COMMENT '账单集模式，0是智能模式，1是精确模式',
  `create_date` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '账单集创建日期',
  `is_delete` int(2) NULL DEFAULT 0 COMMENT '逻辑删除为，0可用，1被删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for charge_template
-- ----------------------------
DROP TABLE IF EXISTS `charge_template`;
CREATE TABLE `charge_template`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `charge_template_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `charge_template_desc` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '',
  `amount_per_unit` decimal(11, 2) NOT NULL COMMENT '每1单位的费用\r\n            ',
  `unit` int(3) NOT NULL COMMENT '费用模板的计量单位\r\n            0 为按度数收费\r\n            1为按天收费\r\n            2 为按月收费\r\n            3 为按年收费',
  `create_date` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `is_deleted` int(11) NOT NULL DEFAULT 0 COMMENT '逻辑删除位\r\n0 启用\r\n1 删除',
  `is_disabled` int(1) NOT NULL DEFAULT 0 COMMENT '是否失效，0 非失效，即可用。1 已失效',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `AK_AK`(`charge_template_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用来描述费用模板' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of charge_template
-- ----------------------------
INSERT INTO `charge_template` VALUES (1, '通用房租', '用于测试的模板', 200.00, 2, '2019-10-05 11:16:18', 0, 0);
INSERT INTO `charge_template` VALUES (2, '通用电费', '普通的电费', 1.50, 0, '2019-10-07 09:49:39', 0, 0);
INSERT INTO `charge_template` VALUES (3, '通用水费', '普通的水费', 3.00, 0, '2019-10-07 09:51:32', 0, 0);
INSERT INTO `charge_template` VALUES (4, '测试删除模板', '一会就把你删了', 1.22, 0, '2019-11-04 07:22:21', 1, 0);

-- ----------------------------
-- Table structure for charge_template_room
-- ----------------------------
DROP TABLE IF EXISTS `charge_template_room`;
CREATE TABLE `charge_template_room`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `charge_template_id` int(11) NOT NULL COMMENT '账单模板id',
  `room_id` int(11) NOT NULL COMMENT '房间id',
  `create_date` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建日期',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 83 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '账单模板和房间中间表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of charge_template_room
-- ----------------------------
INSERT INTO `charge_template_room` VALUES (12, 1, 21, '2019-10-07 09:53:19');
INSERT INTO `charge_template_room` VALUES (13, 2, 21, '2019-10-07 09:53:19');
INSERT INTO `charge_template_room` VALUES (14, 3, 21, '2019-10-07 09:53:19');
INSERT INTO `charge_template_room` VALUES (18, 1, 47, '2019-10-07 10:22:26');
INSERT INTO `charge_template_room` VALUES (19, 2, 47, '2019-10-07 10:22:26');
INSERT INTO `charge_template_room` VALUES (20, 3, 47, '2019-10-07 10:22:26');
INSERT INTO `charge_template_room` VALUES (21, 1, 40, '2019-10-07 10:22:33');
INSERT INTO `charge_template_room` VALUES (22, 2, 40, '2019-10-07 10:22:33');
INSERT INTO `charge_template_room` VALUES (41, 2, 9, '2019-11-05 06:49:52');
INSERT INTO `charge_template_room` VALUES (42, 1, 9, '2019-11-05 06:49:52');
INSERT INTO `charge_template_room` VALUES (53, 1, 8, '2019-11-05 22:29:52');
INSERT INTO `charge_template_room` VALUES (54, 2, 14, '2019-11-05 22:32:41');
INSERT INTO `charge_template_room` VALUES (61, 1, 48, '2019-11-08 23:26:05');
INSERT INTO `charge_template_room` VALUES (62, 2, 48, '2019-11-08 23:26:05');
INSERT INTO `charge_template_room` VALUES (63, 3, 48, '2019-11-08 23:26:05');
INSERT INTO `charge_template_room` VALUES (64, 1, 31, '2019-11-17 17:03:28');
INSERT INTO `charge_template_room` VALUES (65, 2, 31, '2019-11-17 17:03:28');
INSERT INTO `charge_template_room` VALUES (66, 3, 31, '2019-11-17 17:03:28');
INSERT INTO `charge_template_room` VALUES (67, 1, 11, '2019-11-17 17:03:50');
INSERT INTO `charge_template_room` VALUES (68, 2, 11, '2019-11-17 17:03:50');
INSERT INTO `charge_template_room` VALUES (69, 3, 11, '2019-11-17 17:03:50');
INSERT INTO `charge_template_room` VALUES (70, 1, 34, '2019-11-17 17:03:54');
INSERT INTO `charge_template_room` VALUES (71, 2, 34, '2019-11-17 17:03:54');
INSERT INTO `charge_template_room` VALUES (72, 3, 34, '2019-11-17 17:03:54');
INSERT INTO `charge_template_room` VALUES (73, 2, 19, '2019-11-17 17:04:21');
INSERT INTO `charge_template_room` VALUES (74, 3, 19, '2019-11-17 17:04:21');
INSERT INTO `charge_template_room` VALUES (75, 1, 18, '2019-11-17 17:04:40');
INSERT INTO `charge_template_room` VALUES (76, 2, 18, '2019-11-17 17:04:40');
INSERT INTO `charge_template_room` VALUES (77, 3, 18, '2019-11-17 17:04:40');
INSERT INTO `charge_template_room` VALUES (78, 1, 17, '2019-11-17 17:04:45');
INSERT INTO `charge_template_room` VALUES (79, 2, 17, '2019-11-17 17:04:45');
INSERT INTO `charge_template_room` VALUES (80, 1, 35, '2019-11-20 23:06:23');
INSERT INTO `charge_template_room` VALUES (81, 2, 35, '2019-11-20 23:06:23');
INSERT INTO `charge_template_room` VALUES (82, 3, 35, '2019-11-20 23:06:23');

-- ----------------------------
-- Table structure for note
-- ----------------------------
DROP TABLE IF EXISTS `note`;
CREATE TABLE `note`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `note_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注标题',
  `note_content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注内容',
  `note_type` int(11) NULL DEFAULT NULL COMMENT '备注类型\r\n0 房间备注\r\n1 组别备注\r\n2 账单集备注\r\n3 账单备注',
  `note_id` int(11) NULL DEFAULT NULL COMMENT '备注对应的条目的id',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT 'note的创建时间',
  `note_status` int(11) NULL DEFAULT 0 COMMENT 'note的状态\r\n0 待处理\r\n1 已处理',
  `handled_time` datetime(0) NULL DEFAULT NULL COMMENT 'note处理的日期',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for renter
-- ----------------------------
DROP TABLE IF EXISTS `renter`;
CREATE TABLE `renter`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `name` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '姓名',
  `mobile` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '电话号码',
  `wechat_num` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '微信号',
  `education` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '学历\r\n0 无\r\n1 小学\r\n2 初中\r\n3 高中\r\n4 专科\r\n5 本科\r\n6 硕士\r\n7 博士',
  `photo` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '头像',
  `gender` int(2) NOT NULL DEFAULT 1 COMMENT '性别 : 0女  1男',
  `birthday` datetime(0) NULL DEFAULT NULL COMMENT '生日',
  `room_id` int(11) NULL DEFAULT NULL COMMENT '所属房间id',
  `is_primary` int(2) NOT NULL DEFAULT 0 COMMENT '是否签订合同的人，0否，1是',
  `credit_num` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '身份证号',
  `create_date` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建日期',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `AK_AK`(`wechat_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '住户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of renter
-- ----------------------------
INSERT INTO `renter` VALUES (1, '张三', '16099877340', 'hepeng', '高中', NULL, 0, '1990-09-20 00:00:00', 9, 1, '440592827617253', '2019-09-29 22:15:09');
INSERT INTO `renter` VALUES (2, '李四', '283748261823', '283jdi', NULL, NULL, 1, '1990-05-08 00:00:00', 48, 1, '283748291827387300', '2019-10-04 07:27:57');
INSERT INTO `renter` VALUES (3, '王五', '1827384928', '2314', NULL, NULL, 0, '1990-05-08 00:00:00', 8, 1, '1234123', '2019-10-04 07:31:36');
INSERT INTO `renter` VALUES (4, '哈哈', '12423421223', 'widj', NULL, NULL, 0, '2019-10-04 00:00:00', 34, 1, '2423124123123', '2019-10-04 22:54:47');
INSERT INTO `renter` VALUES (9, '新入住人', '123', '123', NULL, NULL, 0, '2019-11-08 00:00:00', 34, 0, '4123', '2019-11-08 22:28:18');
INSERT INTO `renter` VALUES (10, '什么人', '13392096421', '1fff', NULL, NULL, 1, '2017-11-07 00:00:00', 21, 1, '2323', '2019-11-12 21:25:28');
INSERT INTO `renter` VALUES (11, '又是新的人', '14412312423', '23fff', NULL, NULL, 0, '2019-11-13 00:00:00', NULL, 0, '1241234123123', '2019-11-13 21:29:03');
INSERT INTO `renter` VALUES (12, 'abcdefg', '12423123', '4423123', NULL, NULL, 0, '2019-11-13 00:00:00', NULL, 0, '2312312', '2019-11-13 21:32:36');
INSERT INTO `renter` VALUES (13, '什么东西', '412', '23', NULL, NULL, 0, '2019-11-13 00:00:00', NULL, 0, '12', '2019-11-13 21:33:26');
INSERT INTO `renter` VALUES (14, '44', '22', '11', NULL, NULL, 0, '2019-11-13 00:00:00', NULL, 0, '44', '2019-11-13 21:33:41');
INSERT INTO `renter` VALUES (15, '请求', 'qw', 'r', NULL, NULL, 0, '2019-11-13 00:00:00', NULL, 0, 'w', '2019-11-13 21:35:04');
INSERT INTO `renter` VALUES (16, 'fff', '123412', 'qqq', NULL, NULL, 0, '2019-11-13 00:00:00', NULL, 0, 'wwe', '2019-11-13 21:42:37');
INSERT INTO `renter` VALUES (17, '回归测试人', '115', '124', NULL, NULL, 0, '2019-11-19 00:00:00', 34, 0, '123124', '2019-11-19 22:19:55');

-- ----------------------------
-- Table structure for room
-- ----------------------------
DROP TABLE IF EXISTS `room`;
CREATE TABLE `room`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `room_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '房间名称',
  `room_desc` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '房间的详细描述',
  `create_date` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `AK_UK`(`room_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of room
-- ----------------------------
INSERT INTO `room` VALUES (8, '203', '111123', '2019-09-26 06:36:38');
INSERT INTO `room` VALUES (9, '303', '444', '2019-09-28 09:04:58');
INSERT INTO `room` VALUES (11, '404', '没什么描述的', '2019-09-28 10:21:41');
INSERT INTO `room` VALUES (13, '501', '501哈哈', '2019-09-28 11:49:16');
INSERT INTO `room` VALUES (14, '510', '什么嘛', '2019-09-28 11:49:50');
INSERT INTO `room` VALUES (15, '603', '再来点描述', '2019-09-28 19:45:47');
INSERT INTO `room` VALUES (16, '601', '', '2019-09-28 19:59:54');
INSERT INTO `room` VALUES (17, '605', '', '2019-09-28 20:01:22');
INSERT INTO `room` VALUES (18, '606', '', '2019-09-28 20:01:41');
INSERT INTO `room` VALUES (19, '607', '', '2019-09-28 20:02:56');
INSERT INTO `room` VALUES (20, '503', '挖到', '2019-09-28 20:10:58');
INSERT INTO `room` VALUES (21, '302', '来一点描述2323', '2019-09-28 20:11:16');
INSERT INTO `room` VALUES (31, '304', '来点描述', '2019-09-28 20:17:43');
INSERT INTO `room` VALUES (34, '405', '', '2019-09-28 20:20:16');
INSERT INTO `room` VALUES (35, '406', '', '2019-09-28 20:20:26');
INSERT INTO `room` VALUES (36, '开始做分页', '开始吧', '2019-09-28 20:32:13');
INSERT INTO `room` VALUES (40, 'fa', '', '2019-10-02 10:07:36');
INSERT INTO `room` VALUES (47, '发凡', '', '2019-10-02 11:58:43');
INSERT INTO `room` VALUES (48, '202', '什么东西？', '2019-10-06 23:45:43');

-- ----------------------------
-- Table structure for room_group
-- ----------------------------
DROP TABLE IF EXISTS `room_group`;
CREATE TABLE `room_group`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `group_desc` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `group_type` int(11) NOT NULL DEFAULT 0 COMMENT '组别类型\r\n0 住宅\r\n1 厂房\r\n2 其他',
  `create_date` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of room_group
-- ----------------------------
INSERT INTO `room_group` VALUES (20, '二楼', '外面的二楼', 0, '2019-09-24 14:51:23');
INSERT INTO `room_group` VALUES (21, '三楼', '外面那栋的三楼', 0, '2019-09-24 14:51:33');
INSERT INTO `room_group` VALUES (22, '四楼', '外面那栋的四楼', 0, '2019-09-24 14:51:42');
INSERT INTO `room_group` VALUES (23, '五楼', '外面的五楼', 0, '2019-09-25 14:04:33');

-- ----------------------------
-- Table structure for room_schedule_record
-- ----------------------------
DROP TABLE IF EXISTS `room_schedule_record`;
CREATE TABLE `room_schedule_record`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `room_id` int(11) NOT NULL COMMENT '房间id',
  `renter_id` int(11) NOT NULL COMMENT '用户id',
  `move_in_date` datetime(0) NOT NULL COMMENT '搬进来的日期',
  `move_out_date` datetime(0) NULL DEFAULT NULL COMMENT '实际搬走的日期',
  `deposit` double(10, 2) NOT NULL COMMENT '押金',
  `expect_move_out_date` datetime(0) NULL DEFAULT NULL COMMENT '预计搬出日期',
  `contract` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '合同的图片地址',
  `modify_date` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改日期',
  `create_date` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '房间日程记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of room_schedule_record
-- ----------------------------
INSERT INTO `room_schedule_record` VALUES (1, 9, 1, '2019-11-16 00:00:00', NULL, 500.00, '2020-05-16 00:00:00', NULL, '2019-11-16 06:15:26', '2019-11-16 06:15:26');
INSERT INTO `room_schedule_record` VALUES (2, 48, 2, '2019-11-18 00:00:00', NULL, 500.00, '2020-05-18 00:00:00', NULL, '2019-11-17 14:22:27', '2019-11-17 14:22:27');
INSERT INTO `room_schedule_record` VALUES (5, 8, 3, '2019-11-17 00:00:00', NULL, 500.00, '2021-11-17 00:00:00', NULL, '2019-11-17 16:16:14', '2019-11-17 16:16:14');
INSERT INTO `room_schedule_record` VALUES (6, 21, 10, '2019-11-17 00:00:00', NULL, 500.00, '2020-11-17 00:00:00', NULL, '2019-11-17 16:16:25', '2019-11-17 16:16:25');
INSERT INTO `room_schedule_record` VALUES (7, 34, 4, '2019-11-19 00:00:00', NULL, 500.00, '2021-11-19 00:00:00', NULL, '2019-11-19 22:20:22', '2019-11-19 22:20:22');

-- ----------------------------
-- Table structure for room_to_room_group
-- ----------------------------
DROP TABLE IF EXISTS `room_to_room_group`;
CREATE TABLE `room_to_room_group`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `room_id` int(11) NOT NULL COMMENT '房间id',
  `room_group_id` int(11) NOT NULL COMMENT '房间组别id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `AK`(`room_id`, `room_group_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 120 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of room_to_room_group
-- ----------------------------
INSERT INTO `room_to_room_group` VALUES (111, 8, 20);
INSERT INTO `room_to_room_group` VALUES (104, 9, 21);
INSERT INTO `room_to_room_group` VALUES (118, 11, 22);
INSERT INTO `room_to_room_group` VALUES (68, 13, 23);
INSERT INTO `room_to_room_group` VALUES (112, 14, 23);
INSERT INTO `room_to_room_group` VALUES (40, 20, 23);
INSERT INTO `room_to_room_group` VALUES (116, 31, 22);
INSERT INTO `room_to_room_group` VALUES (117, 31, 23);
INSERT INTO `room_to_room_group` VALUES (119, 34, 23);
INSERT INTO `room_to_room_group` VALUES (75, 36, 23);
INSERT INTO `room_to_room_group` VALUES (93, 47, 23);
INSERT INTO `room_to_room_group` VALUES (115, 48, 20);

SET FOREIGN_KEY_CHECKS = 1;
