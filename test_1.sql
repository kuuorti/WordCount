
CREATE SCHEMA IF NOT EXISTS `COMPANY` DEFAULT CHARACTER SET utf8mb4 ;
USE `COMPANY`


CREATE TABLE IF NOT EXISTS `COMPANY`.`Departament` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `NAME` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- ---------------------------------------------------
CREATE TABLE IF NOT EXISTS `COMPANY`.`EMPLOYEE` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `DEPARTAMENT_ID` INT NOT NULL,
  `CHEIF_ID` INT NOT NULL,
  `NAME` VARCHAR(100) NOT NULL,
  `SALARY` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `_idx` (`DEPARTAMENT_ID` ASC) VISIBLE,
  INDEX `empl_idx` (`CHEIF_ID` ASC) VISIBLE,
  INDEX `idx_cheif_id` (`CHEIF_ID` ASC) VISIBLE,
  CONSTRAINT `departament`
    FOREIGN KEY (`DEPARTAMENT_ID`)
    REFERENCES `COMPANY`.`Departament` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `empl`
    FOREIGN KEY (`CHEIF_ID`)
    REFERENCES `COMPANY`.`EMPLOYEE` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SELECT `NAME`, `SALARY`
FROM `EMPLOYEE`
WHERE `SALARY` = (SELECT MAX(`SALARY`) FROM `EMPLOYEE`);


SELECT MAX(level) as max_depth
FROM (
  SELECT 
    @pv := `CHEIF_ID`,
    @lv := 0,
    @id := `ID`,
    @deps := 1 level
  FROM 
    `EMPLOYEE` 
  WHERE 
    `CHEIF_ID` IS NULL 
  UNION ALL 
  SELECT 
    `e`.`CHEIF_ID`, 
    @lv := @lv + 1, 
    `e`.`ID`, 
    @deps := @deps + 1 level
  FROM 
    `EMPLOYEE` `e`
    JOIN `EMPLOYEE` `p` ON `p`.`ID` = `e`.`CHEIF_ID`
    JOIN (SELECT @pv := NULL, @lv := 0, @id := NULL, @deps := 1) tmp 
  WHERE 
    `e`.`CHEIF_ID` = @id
) a;

SELECT 
  `d`.`NAME` as `Department Name`, 
  SUM(`e`.`SALARY`) as `Total Salary`
FROM 
  `EMPLOYEE` `e`
  JOIN `Departament` `d` ON `d`.`ID` = `e`.`DEPARTAMENT_ID`
GROUP BY 
  `d`.`ID`
ORDER BY 
  `Total Salary` DESC
LIMIT 1;


SELECT `NAME`
FROM `EMPLOYEE`
WHERE `NAME` LIKE 'R%n';
