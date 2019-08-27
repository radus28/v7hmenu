{*+**********************************************************************************
* The contents of this file are subject to the vtiger CRM Public License Version 1.1
* ("License"); You may not use this file except in compliance with the License
* The Original Code is: vtiger CRM Open Source
* The Initial Developer of the Original Code is vtiger.
* Portions created by vtiger are Copyright (C) vtiger.
* All Rights Reserved.
************************************************************************************}

{strip}
    {include file="modules/Vtiger/Header.tpl"}

    {assign var=APP_IMAGE_MAP value=Vtiger_MenuStructure_Model::getAppIcons()}
    {assign var="topMenus" value=$MENU_STRUCTURE->getTop()}
    {assign var="moreMenus" value=$MENU_STRUCTURE->getMore()}
    {assign var=NUMBER_OF_PARENT_TABS value = count(array_keys($moreMenus))}
    <nav class="navbar navbar-default navbar-fixed-top app-fixed-navbar">
        <div class="container-fluid global-nav">
            <div class="row">
                <div class="col-lg-3 col-md-3 col-sm-3 app-navigator-container">
                    <div class="row">
                        <div id="appnavigator" class="col-sm-2 col-xs-2 cursorPointer app-switcher-container" data-app-class="{if $MODULE eq 'Home' || !$MODULE}fa-dashboard{else}{$APP_IMAGE_MAP[$SELECTED_MENU_CATEGORY]}{/if}">
                            <div class="row app-navigator">
                                <span class="app-icon fa fa-bars"></span>
                            </div>
                        </div>
                        <div class="logo-container col-lg-9 col-md-9 col-sm-9 col-xs-9">
                            <div class="row">
                                <a href="index.php" class="company-logo">
                                    <img src="{$COMPANY_LOGO->get('imagepath')}" alt="{$COMPANY_LOGO->get('alt')}"/>
                                </a>
                            </div>
                        </div>  
                    </div>
                </div>
                <div class="col-md-6 col-lg-6 hidden-sm hidden-xs">
                    <div class="navbar" class="collapse navbar-collapse navbar-right global-actions" id="topMenus" style="height:40px;margin-bottom:0px;">
                        <div class="navbar-inner" id="nav-inner" style="height: 40px;">
                            <ul class="nav navbar-nav modulesList" id="largeNav" style="width:max-content;max-width: calc(100% - 36px) !important;height: 40px; overflow: hidden;">
                                <li class="tabs">
                                    <a class="alignMiddle {if $MODULE eq 'Home'} selected {/if}" href="{$HOME_MODULE_MODEL->getDefaultUrl()}"><img src="{'layouts/v7/skins/images/Home.png'}" alt="{vtranslate('LBL_HOME',$moduleName)}" title="{vtranslate('LBL_HOME',$moduleName)}" /></a>
                                </li>
                                {foreach key=moduleName item=moduleModel from=$topMenus name=topmenu}
                                    {assign var='translatedModuleLabel' value=vtranslate($moduleModel->get('label'),$moduleName)}

                                    {assign var="topmenuClassName" value="tabs"}
                                    {* Make sure to keep selected + few menu persistently and rest responsive *}
                                    {if $smarty.foreach.topmenu.index > $MENU_TOPITEMS_LIMIT && $MENU_SELECTED_MODULENAME != $moduleName}
                                        {assign var="topmenuClassName" value="tabs opttabs"}
                                    {/if}

                                    <li class="{$topmenuClassName}">
                                        <a id="menubar_item_{$moduleName}" href="{$moduleModel->getDefaultUrl()}" {if $MODULE eq $moduleName} class="selected" {/if} style="color:#000;padding: 9px 6px;"><strong>{$translatedModuleLabel}</strong></a>
                                    </li>
                                {/foreach}
                            </ul>
                            <ul class="nav navbar-nav" style="color:#000;">
                                <li class="dropdown">
                                    <a class="dropdown-toggle" data-toggle="dropdown" aria-expanded="true" href="#" role="button" style="color:#000;">
                                        <strong>{vtranslate('LBL_ALL',$MODULE)}&nbsp;</strong>
                                        <b class="caret"></b>
                                    </a>
                                    <div class="cusmenu-dropdown dropdown-menu" role="menu" aria-labelledby="dropdownMenu1"> 
                                        <div class=" col-lg-12 customMenu"> 
                                            {assign var=COUNTER value=0}
                                            {foreach key=parent item=moduleList from=$moreMenus name=more}
                                                {if $COUNTER == 0}
                                                    <div class="row">
                                                    {/if}
                                                    {assign var=COUNTER value=$COUNTER+1}
                                                    <div class="col-lg-3 col-md-3 menuContainer Block1">
                                                        <strong>{vtranslate("LBL_$parent",$moduleName)}</strong><hr>
                                                        {foreach key=moduleName item=moduleModel from=$moduleList}
                                                            {assign var='translatedModuleLabel' value=vtranslate($moduleModel->get('label'),$moduleName)}
                                                            <label><a class="" id="menubar_item_{$moduleName}" href="{$moduleModel->getDefaultUrl()}">{$translatedModuleLabel}</a></label><br/>

                                                        {/foreach}
                                                    </div> 
                                                    {if $COUNTER == 4}
                                                    </div>
                                                    {assign var=COUNTER value=0}
                                                {/if}
                                            {/foreach}
                                        </div> 
                                    </div> 
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div id="navbar" class="col-sm-6 col-md-3 col-lg-3 collapse navbar-collapse navbar-right global-actions">
                    <ul class="nav navbar-nav">
                        <li>
                            <div class="dropdown">
                                <div class="dropdown-toggle" data-toggle="dropdown" aria-expanded="true">
                                    <a href="#" id="menubar_quickCreate" class="qc-button fa fa-plus-circle" title="{vtranslate('LBL_QUICK_CREATE',$MODULE)}" aria-hidden="true"></a>
                                </div>
                                <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1" style="width:500px;">
                                    <li class="title" style="padding: 5px 0 0 15px;">
                                        <strong>{vtranslate('LBL_QUICK_CREATE',$MODULE)}</strong>
                                    </li>
                                    <hr/>
                                    <li id="quickCreateModules" style="padding: 0 5px;">
                                        <div class="col-lg-12" style="padding-bottom:15px;">
                                            {foreach key=moduleName item=moduleModel from=$QUICK_CREATE_MODULES}
                                                {if $moduleModel->isPermitted('CreateView') || $moduleModel->isPermitted('EditView')}
                                                    {assign var='quickCreateModule' value=$moduleModel->isQuickCreateSupported()}
                                                    {assign var='singularLabel' value=$moduleModel->getSingularLabelKey()}
                                                    {assign var=hideDiv value={!$moduleModel->isPermitted('CreateView') && $moduleModel->isPermitted('EditView')}}
                                                    {if $quickCreateModule == '1'}
                                                        {if $count % 3 == 0}
                                                            <div class="row">
                                                            {/if}
                                                            {* Adding two links,Event and Task if module is Calendar *}
                                                            {if $singularLabel == 'SINGLE_Calendar'}
                                                                {assign var='singularLabel' value='LBL_TASK'}
                                                                <div class="{if $hideDiv}create_restricted_{$moduleModel->getName()} hide{else}col-lg-4{/if}">
                                                                    <a id="menubar_quickCreate_Events" class="quickCreateModule" data-name="Events"
                                                                       data-url="index.php?module=Events&view=QuickCreateAjax" href="javascript:void(0)">{$moduleModel->getModuleIcon('Event')}<span class="quick-create-module">{vtranslate('LBL_EVENT',$moduleName)}</span></a>
                                                                </div>
                                                                {if $count % 3 == 2}
                                                                </div>
                                                                <br>
                                                                <div class="row">
                                                                {/if}
                                                                <div class="{if $hideDiv}create_restricted_{$moduleModel->getName()} hide{else}col-lg-4{/if}">
                                                                    <a id="menubar_quickCreate_{$moduleModel->getName()}" class="quickCreateModule" data-name="{$moduleModel->getName()}"
                                                                       data-url="{$moduleModel->getQuickCreateUrl()}" href="javascript:void(0)">{$moduleModel->getModuleIcon('Task')}<span class="quick-create-module">{vtranslate($singularLabel,$moduleName)}</span></a>
                                                                </div>
                                                                {if !$hideDiv}
                                                                    {assign var='count' value=$count+1}
                                                                {/if}
                                                            {else if $singularLabel == 'SINGLE_Documents'}
                                                                <div class="{if $hideDiv}create_restricted_{$moduleModel->getName()} hide{else}col-lg-4{/if} dropdown">
                                                                    <a id="menubar_quickCreate_{$moduleModel->getName()}" class="quickCreateModuleSubmenu dropdown-toggle" data-name="{$moduleModel->getName()}" data-toggle="dropdown" 
                                                                       data-url="{$moduleModel->getQuickCreateUrl()}" href="javascript:void(0)">
                                                                        {$moduleModel->getModuleIcon()}
                                                                        <span class="quick-create-module">
                                                                            {vtranslate($singularLabel,$moduleName)}
                                                                            <i class="fa fa-caret-down quickcreateMoreDropdownAction"></i>
                                                                        </span>
                                                                    </a>
                                                                    <ul class="dropdown-menu quickcreateMoreDropdown" aria-labelledby="menubar_quickCreate_{$moduleModel->getName()}">
                                                                        <li class="dropdown-header"><i class="fa fa-upload"></i> {vtranslate('LBL_FILE_UPLOAD', $moduleName)}</li>
                                                                        <li id="VtigerAction">
                                                                            <a href="javascript:Documents_Index_Js.uploadTo('Vtiger')">
                                                                                <img style="  margin-top: -3px;margin-right: 4%;" title="Vtiger" alt="Vtiger" src="layouts/v7/skins//images/Vtiger.png">
                                                                                {vtranslate('LBL_TO_SERVICE', $moduleName, {vtranslate('LBL_VTIGER', $moduleName)})}
                                                                            </a>
                                                                        </li>
                                                                        <li class="dropdown-header"><i class="fa fa-link"></i> {vtranslate('LBL_LINK_EXTERNAL_DOCUMENT', $moduleName)}</li>
                                                                        <li id="shareDocument"><a href="javascript:Documents_Index_Js.createDocument('E')">&nbsp;<i class="fa fa-external-link"></i>&nbsp;&nbsp; {vtranslate('LBL_FROM_SERVICE', $moduleName, {vtranslate('LBL_FILE_URL', $moduleName)})}</a></li>
                                                                        <li role="separator" class="divider"></li>
                                                                        <li id="createDocument"><a href="javascript:Documents_Index_Js.createDocument('W')"><i class="fa fa-file-text"></i> {vtranslate('LBL_CREATE_NEW', $moduleName, {vtranslate('SINGLE_Documents', $moduleName)})}</a></li>
                                                                    </ul>
                                                                </div>
                                                            {else}
                                                                <div class="{if $hideDiv}create_restricted_{$moduleModel->getName()} hide{else}col-lg-4{/if}">
                                                                    <a id="menubar_quickCreate_{$moduleModel->getName()}" class="quickCreateModule" data-name="{$moduleModel->getName()}"
                                                                       data-url="{$moduleModel->getQuickCreateUrl()}" href="javascript:void(0)">
                                                                        {$moduleModel->getModuleIcon()}
                                                                        <span class="quick-create-module">{vtranslate($singularLabel,$moduleName)}</span>
                                                                    </a>
                                                                </div>
                                                            {/if}
                                                            {if $count % 3 == 2}
                                                            </div>
                                                            <br>
                                                        {/if}
                                                        {if !$hideDiv}
                                                            {assign var='count' value=$count+1}
                                                        {/if}
                                                    {/if}
                                                {/if}
                                            {/foreach}
                                        </div>
                                    </li>
                                </ul>
                            </div>
                        </li>
                        {assign var=USER_PRIVILEGES_MODEL value=Users_Privileges_Model::getCurrentUserPrivilegesModel()}
                        {assign var=CALENDAR_MODULE_MODEL value=Vtiger_Module_Model::getInstance('Calendar')}
                        {if $USER_PRIVILEGES_MODEL->hasModulePermission($CALENDAR_MODULE_MODEL->getId())}
                            <li><div><a href="index.php?module=Calendar&view={$CALENDAR_MODULE_MODEL->getDefaultViewName()}" class="fa fa-calendar" title="{vtranslate('Calendar','Calendar')}" aria-hidden="true"></a></div></li>
                                    {/if}
                                    {assign var=REPORTS_MODULE_MODEL value=Vtiger_Module_Model::getInstance('Reports')}
                                    {if $USER_PRIVILEGES_MODEL->hasModulePermission($REPORTS_MODULE_MODEL->getId())}
                            <li><div><a href="index.php?module=Reports&view=List" class="fa fa-bar-chart" title="{vtranslate('Reports','Reports')}" aria-hidden="true"></a></div></li>
                                    {/if}
                                    {if $USER_PRIVILEGES_MODEL->hasModulePermission($CALENDAR_MODULE_MODEL->getId())}
                            <li><div><a href="#" class="taskManagement vicon vicon-task" title="{vtranslate('Tasks','Vtiger')}" aria-hidden="true"></a></div></li>
                                    {/if}
                        <li class="dropdown">
                            <div style="margin-top: 15px;">
                                <a href="#" class="userName dropdown-toggle" data-toggle="dropdown" role="button">
                                    <span class="fa fa-user" aria-hidden="true" title="{$USER_MODEL->get('first_name')} {$USER_MODEL->get('last_name')}
                                          ({$USER_MODEL->get('user_name')})"></span>
                                    <span class="link-text-xs-only hidden-lg hidden-md hidden-sm">{$USER_MODEL->getName()}</span>
                                </a>
                                <div class="dropdown-menu logout-content" role="menu">
                                    <div class="row">
                                        <div class="col-lg-4 col-sm-4">
                                            <div class="profile-img-container">
                                                {assign var=IMAGE_DETAILS value=$USER_MODEL->getImageDetails()}
                                                {if $IMAGE_DETAILS neq '' && $IMAGE_DETAILS[0] neq '' && $IMAGE_DETAILS[0].path eq ''}
                                                    <i class='vicon-vtigeruser' style="font-size:90px"></i>
                                                {else}
                                                    {foreach item=IMAGE_INFO from=$IMAGE_DETAILS}
                                                        {if !empty($IMAGE_INFO.path) && !empty({$IMAGE_INFO.orgname})}
                                                            <img src="{$IMAGE_INFO.path}_{$IMAGE_INFO.orgname}" width="100px" height="100px">
                                                        {/if}
                                                    {/foreach}
                                                {/if}
                                            </div>
                                        </div>
                                        <div class="col-lg-8 col-sm-8">
                                            <div class="profile-container">
                                                <h4>{$USER_MODEL->get('first_name')} {$USER_MODEL->get('last_name')}</h4>
                                                <h5 class="textOverflowEllipsis" title='{$USER_MODEL->get('user_name')}'>{$USER_MODEL->get('user_name')}</h5>
                                                <p>{$USER_MODEL->getUserRoleName()}</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="logout-footer clearfix">
                                        <hr style="margin: 10px 0 !important">
                                        <div class="">
                                            <span class="pull-left">
                                                <span class="fa fa-cogs"></span>
                                                <a id="menubar_item_right_LBL_MY_PREFERENCES" href="{$USER_MODEL->getPreferenceDetailViewUrl()}">{vtranslate('LBL_MY_PREFERENCES')}</a>
                                            </span>
                                            <span class="pull-right">
                                                <span class="fa fa-power-off"></span>
                                                <a id="menubar_item_right_LBL_SIGN_OUT" href="index.php?module=Users&action=Logout">{vtranslate('LBL_SIGN_OUT')}</a>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    {/strip}