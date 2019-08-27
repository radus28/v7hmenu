<?php
include_once 'config.inc.php';
include_once 'include/database/PearDatabase.php';

$adb = PearDatabase::getInstance();

// To add a settings link
echo "Start to add horizontal menu settings ....<br/>";
$fieldid = $adb->getUniqueID('vtiger_settings_field');
$adb->pquery("INSERT INTO vtiger_settings_field(fieldid, blockid, name, iconpath, description, linkto, sequence, active, pinned)
            VALUES(?,?,?,?,?,?,?,?,?)", array($fieldid, 8, 'LBL_HORIZONTAL_MANU_EDITOR', 'menueditor.png', 'LBL_HORIZONTAL_MENU_DESC', 'index.php?module=MenuEditor&parent=Settings&view=HorizontalIndex&type=horizontal', 9, 0, 0));
$fieldid = $adb->getUniqueID('vtiger_settings_field');
$adb->pquery("INSERT INTO vtiger_settings_field(fieldid, blockid, name, iconpath, description, linkto, sequence, active, pinned)
            VALUES(?,?,?,?,?,?,?,?,?)", array($fieldid, 8, 'LBL_ALL_MENU', 'menueditor.png', 'LBL_ALL_MENU_DESC', 'index.php?module=MenuEditor&parent=Settings&view=AllIndex&type=all', 9, 0, 0));
echo "Horizontal menu settings added ....<br/><br/>";

echo 'Create "vtiger_allmenu" table....<br/><br/>';
$tableSql = "CREATE TABLE IF NOT EXISTS `vtiger_allmenu` (
  `tabid` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;";
$adb->query($tableSql);

echo 'Insert tab data...';
$sql = "SELECT tabid FROM vtiger_tab where vtiger_tab.isentitytype = '1' order by `name`";
$adb = \PearDatabase::getInstance();
$result1 = $adb->pquery($sql,array());
$count = 1;
for($i=0;$i <= $adb->num_rows($result1);$i++){
    $seq = $i+1;
    $tabid = $adb->query_result($result1,$i);
    $insertQuery = "INSERT INTO vtiger_allmenu(`tabid`,`position`) value('$tabid',$seq)";
    $adb->query($insertQuery);
}
