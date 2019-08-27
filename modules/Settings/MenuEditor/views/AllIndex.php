<?php
/*+**********************************************************************************
 * The contents of this file are subject to the vtiger CRM Public License Version 1.1
 * ("License"); You may not use this file except in compliance with the License
 * The Original Code is:  vtiger CRM Open Source
 * The Initial Developer of the Original Code is vtiger.
 * Portions created by vtiger are Copyright (C) vtiger.
 * All Rights Reserved.
 ************************************************************************************/

class Settings_MenuEditor_AllIndex_View extends Settings_Vtiger_Index_View {

	public function process(Vtiger_Request $request) {
		$allModelsList = Vtiger_Menu_Model::getAll(true);
		$menuModelStructure = Vtiger_MenuStructure_Model::getInstanceFromMenuList($allModelsList);
		$moduleName = $request->getModule();
		$qualifiedModuleName = $request->getModule(false);
		
		$viewer = $this->getViewer($request);
		$viewer->assign('ALL_MODULES', $menuModelStructure->getMore());
		$viewer->assign('SELECTED_MODULES', $menuModelStructure->allMenuSelected());
		$viewer->assign('MODULE_NAME', $moduleName);
		
		$viewer->view('AllMenuIndex.tpl', $qualifiedModuleName);
	}
    
    	/**
	 * Function to get the list of Script models to be included
	 * @param Vtiger_Request $request
	 * @return <Array> - List of Vtiger_JsScript_Model instances
	 */
	function getHeaderScripts(Vtiger_Request $request) {
		$headerScriptInstances = parent::getHeaderScripts($request);
		$moduleName = $request->getModule();

		$jsFileNames = array(
			"modules.Settings.$moduleName.resources.AllMenuEditor",
		);

		$jsScriptInstances = $this->checkAndConvertJsScripts($jsFileNames);
		$headerScriptInstances = array_merge($headerScriptInstances, $jsScriptInstances);
		return $headerScriptInstances;
	}
}
