<?php

/* +***********************************************************************************
 * The contents of this file are subject to the vtiger CRM Public License Version 1.0
 * ("License"); You may not use this file except in compliance with the License
 * The Original Code is:  vtiger CRM Open Source
 * The Initial Developer of the Original Code is vtiger.
 * Portions created by vtiger are Copyright (C) vtiger.
 * All Rights Reserved.
 * *********************************************************************************** */

class Settings_MenuEditor_Module_Model extends Settings_Vtiger_Module_Model {

    var $name = 'MenuEditor';

    /**
     * Function to save the menu structure
     */
    public function saveMenuStruncture() {
        $db = PearDatabase::getInstance();
        $selectedModulesList = $this->get('selectedModulesList');

        $updateQuery = "UPDATE vtiger_tab SET tabsequence = CASE tabid ";

        foreach ($selectedModulesList as $sequence => $tabId) {
            $updateQuery .= " WHEN $tabId THEN $sequence ";
        }
        $updateQuery .= "ELSE -1 END";

        $db->pquery($updateQuery, array());
    }
    
    public function saveAllMenuStruncture()
    {
        $db = PearDatabase::getInstance();
        $selectedModulesList = $this->get('selectedModulesList');
        $deleteQuery = "DELETE from vtiger_allmenu";
        $db->query($deleteQuery);

        foreach ($selectedModulesList as $sequence => $tabId) {
            $insertQuery = "INSERT INTO vtiger_allmenu(`tabid`,`position`) values('$tabId',$sequence)";
            $db->query($insertQuery);
        }
    }

    /**
     * Function to get all the modules which are hidden for an app
     * @param <string> $appName
     * @return <array> $modules
     */
    public static function getHiddenModulesForApp($appName) {
        $db = PearDatabase::getInstance();
        $modules = array();
        $result = $db->pquery('SELECT tabid FROM vtiger_app2tab WHERE appname = ? AND visible = ?', array($appName, 0));
        $count = $db->num_rows($result);
        if ($count > 0) {
            for ($i = 0; $i < $count; $i++) {
                $tabid = $db->query_result($result, $i, 'tabid');
                $moduleName = getTabModuleName($tabid);
                $moduleInstance = Vtiger_Module_Model::getInstance($moduleName);
                if ($moduleInstance->isActive()) {
                    $modules[$moduleName] = $moduleName;
                }
            }
        }

        return $modules;
    }

    /**
     * 
     * @param type $flat added by Sutharsan for yussuki "ALL" menu
     * @return type
     */
    public static function getAllVisibleModules($flat = false) {
        $modules = array();
        $presence = array('0', '2');
        $db = PearDatabase::getInstance();
        $result = $db->pquery('SELECT * FROM vtiger_app2tab WHERE visible = ? ORDER BY appname,sequence', array(1));
        $count = $db->num_rows($result);
        $userPrivModel = Users_Privileges_Model::getCurrentUserPrivilegesModel();
        if ($count > 0) {
            for ($i = 0; $i < $count; $i++) {
                $tabid = $db->query_result($result, $i, 'tabid');
                $moduleName = getTabModuleName($tabid);
                $moduleModel = Vtiger_Module_Model::getInstance($moduleName);
                if (empty($moduleModel)) {
                    continue;
                }

                $sequence = $db->query_result($result, $i, 'sequence');
                $appname = $db->query_result($result, $i, 'appname');
                $moduleModel->set('app2tab_sequence', $sequence);
                if (($userPrivModel->isAdminUser() ||
                        $userPrivModel->hasGlobalReadPermission() ||
                        $userPrivModel->hasModulePermission($moduleModel->getId())) && in_array($moduleModel->get('presence'), $presence)) {
                    if ($flat)// to get all unizue modules fot "ALL" menu sutharsan 
                        $modules[$moduleName] = $moduleModel;
                    else
                        $modules[$appname][$moduleName] = $moduleModel;
                }
            }
        }

        return $modules;
    }
        public static function getAllMenuVisibleModules($flat = false) {
        $modules = array();
        $presence = array('0', '2');
        $db = PearDatabase::getInstance();
        $result = $db->pquery('SELECT * FROM vtiger_app2tab inner join vtiger_allmenu allmenu on allmenu.tabid=vtiger_app2tab.tabid WHERE vtiger_app2tab.visible = ? ORDER BY allmenu.position', array(1));
        $count = $db->num_rows($result);
        $userPrivModel = Users_Privileges_Model::getCurrentUserPrivilegesModel();
        if ($count > 0) {
            for ($i = 0; $i < $count; $i++) {
                $tabid = $db->query_result($result, $i, 'tabid');
                $moduleName = getTabModuleName($tabid);
                $moduleModel = Vtiger_Module_Model::getInstance($moduleName);
                if (empty($moduleModel)) {
                    continue;
                }

                $sequence = $db->query_result($result, $i, 'sequence');
                $appname = $db->query_result($result, $i, 'appname');
                $moduleModel->set('app2tab_sequence', $sequence);
                if (($userPrivModel->isAdminUser() ||
                        $userPrivModel->hasGlobalReadPermission() ||
                        $userPrivModel->hasModulePermission($moduleModel->getId())) && in_array($moduleModel->get('presence'), $presence)) {
                    if ($flat)// to get all unizue modules fot "ALL" menu sutharsan 
                        $modules[$moduleName] = $moduleModel;
                    else
                        $modules[$appname][$moduleName] = $moduleModel;
                }
            }
        }
        return $modules;
    }

    public static function addModuleToApp($moduleName, $parent) {
        if (empty($moduleName) || empty($parent))
            return;

        $db = PearDatabase::getInstance();
        $parent = strtoupper($parent);
        $oldToNewAppMapping = Vtiger_MenuStructure_Model::getOldToNewAppMapping();
        if (!empty($oldToNewAppMapping[$parent])) {
            $parent = $oldToNewAppMapping[$parent];
        }

        $ignoredModules = Vtiger_MenuStructure_Model::getIgnoredModules();
        if (!in_array($moduleName, $ignoredModules)) {
            $moduleModel = Vtiger_Module_Model::getInstance($moduleName);
            $result = $db->pquery('SELECT * FROM vtiger_app2tab WHERE tabid = ? AND appname = ?', array($moduleModel->getId(), $parent));

            $sequence = self::getMaxSequenceForApp($parent) + 1;
            if ($db->num_rows($result) == 0) {
                $db->pquery('INSERT INTO vtiger_app2tab(tabid,appname,sequence) VALUES(?,?,?)', array($moduleModel->getId(), $parent, $sequence));
            }
        }
    }

    public static function updateModuleApp($moduleName, $parent, $oldParent = false) {
        $db = PearDatabase::getInstance();

        $parent = strtoupper($parent);
        $oldToNewAppMapping = Vtiger_MenuStructure_Model::getOldToNewAppMapping();
        if (!empty($oldToNewAppMapping[$parent])) {
            $parent = $oldToNewAppMapping[$parent];
        }

        $moduleModel = Vtiger_Module_Model::getInstance($moduleName);

        $query = "UPDATE vtiger_app2tab SET appname=? WHERE tabid=?";
        $params = array($parent, $moduleModel->getId());
        if ($oldParent) {
            $query .= ' AND appname=?';
            array_push($params, strtoupper($oldParent));
        }
        $db->pquery($query, $params);
    }

    /**
     * Function to get the max sequence number for an app
     * @param <string> $appName
     * @return <integer>
     */
    public static function getMaxSequenceForApp($appName) {
        $db = PearDatabase::getInstance();
        $result = $db->pquery('SELECT MAX(sequence) AS maxsequence FROM vtiger_app2tab WHERE appname=?', array($appName));
        $sequence = 0;
        if ($db->num_rows($result) > 0) {
            $sequence = $db->query_result($result, 0, 'maxsequence');
        }

        return $sequence;
    }
    
        /**
	 * Function to get Index view Url
	 * @return <String> URL
	 */
	public function getHorizontalIndexViewUrl() {
		return 'index.php?module='.$this->getName().'&parent='.$this->getParentName().'&view=HorizontalIndex';
	}
       /**
	 * Function to get Index view Url
	 * @return <String> URL
	 */
	public function getAllMenuIndexViewUrl() {
		return 'index.php?module='.$this->getName().'&parent='.$this->getParentName().'&view=AllIndex';
	}
}
