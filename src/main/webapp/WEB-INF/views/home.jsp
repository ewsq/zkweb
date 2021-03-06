<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<jsp:include page="head.jsp"></jsp:include>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ZkWeb For Zookeeper</title>

<script type="text/javascript" src="resources/zkweb.js"></script>
</head>


<body class="easyui-layout" id="zkweb_body">  

    <div data-options="region:'north',split:true,collapsed:false,border:false,title:'ZK连接配置'" style="height:200px;">
    
	    <center>
	    <table class="easyui-datagrid" id="zkweb_zkcfg" style="height:169px;" allowResize="true"
	           data-options="pagination:true,singleSelect:true,fitColumns:true,rownumbers:true,pageSize:5,pageList: [5, 10, 15]" toolbar="#zkweb_tb" >  
	        <thead>  
	            <tr>  
	                <th data-options="field:'ID'">ID</th>  
	                <th data-options="field:'DESC'">DESC</th>  
	                <th data-options="field:'CONNECTSTR'">CONNECTSTR</th>  
	                <th data-options="field:'SESSIONTIMEOUT'">SESSIONTIMEOUT</th>  
	            </tr>  
	        </thead>  
	    </table> 
	    
	    <div id="zkweb_tb" >    
	    <table border=0 width="100%">
	    	<tr><td>
	    	<a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="javascript:$('#zkweb_add_cfg').window('open');"><span data-locale-html="add">添加</span></a>    
		    <a href="#" class="easyui-linkbutton" iconCls="icon-save" plain="true" onclick="openUpdateWin()"><span data-locale-html="update">更新</span></a>    
		    <a href="#" class="easyui-linkbutton" iconCls="icon-no" plain="true" onclick="openDelWin()"><span data-locale-html="remove">删除</span></a>   
		    <a href="#" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-search'" onclick="setFilter(this)"><span data-locale-html="filter">过滤器</span></a>  
		    <input id="filterValue" type="text" name="filterValue" value="desc like '%%'" data-locale-attr="filterTitle" title="符合sql规范的where条件">
		    <input id="selectIndex" type="hidden" name="selectIndex"/>
		    </td><td align="right">Language:
		    <input type="hidden" id="isfirstopen" value="0"/>
		    <select name='locale' id="locale" class="easyui-combobox">
                <option value='zh-CN'>中文</option>
                <option value='en'>ENG</option>
            </select>
        	</td></tr>
        </table>
		</div>
		
	   	</center>
	   	
		    	
    </div> 
    <div data-options="region:'east',split:true,collapsed:false,title:'Zk状态'" style="width:320px;padding:1px;">
		<div id="jmx">
			<form id="zkstate_showtype_form" method="post" action="">
			<input type="hidden" name="id"/>
			<input type="radio" name="showtype" value="1" checked onchange="ZkStateShowTypeChange(this)"><span data-locale-html="simple">简单</span>
			<input type="radio" name="showtype" value="0" onchange="ZkStateShowTypeChange(this)"><span data-locale-html="detail">详细</span>
			<a id="refresh" href="#" class="easyui-linkbutton" name="refresh" data-options="plain:true,iconCls:'icon-reload'" onclick="ZkStateRefresh(this)" data-locale-attr="fixrefreshtitle" title="0即关闭，手动刷新;>0即定时刷新"><span data-locale-html="fixrefresh">定时刷新</span></a>
			<input id="millisecs" name="millisecs" class="easyui-numberspinner" style="width:43px;height:18px" required="required" data-locale-attr="fixrefreshtitle" title="0即关闭，手动刷新;>0即定时刷新" data-options="value:0,min:0,max:99999,editable:true">(s)
			<input type="hidden" name="refreshObject"/>
			</form>
			
		</div>
<!-- 		<div  class="easyui-panel" data-options=""> -->
			<p id="jmxpanel"><font color="red"><span data-locale-html="eastindication">请选择一个Zookeeper的连接</span></font></p>
<!-- 		</div> -->
		<div id="jmxpropertygrid" class="easyui-propertygrid" 
		data-options="fitColumns:true,striped:true,pagination:false,pagePosition:'bottom',sortName:'name',sortable:true,showGroup:true,scrollbarSize:1"
		style="width:270px;height:90%">  
		</div>
	</div>  
    
    <!--
    
    <div data-options="region:'south',border:false" style="height:50px;background:#A9FACD;padding:10px;">south region</div>  
    -->
	<div data-options="region:'west',split:true,collapsed:false,title:'ZK节点树'" style="width:150px;padding:1px;">
		<ul id="zkTree" class="easyui-tree" style="width:120px;">
    	</ul> 
    	<!-- right -->
    	<div id="mm" class="easyui-menu" style="width:120px;">  
	        <div onclick="javascript:$('#zkweb_add_node').window('open');" data-options="iconCls:'icon-add'"><span data-locale-html="add">添加</span></div>  
	        <div onclick="remove()" data-options="iconCls:'icon-remove'"><span data-locale-html="remove">删除</span></div>  
	        <div class="menu-sep"></div>  
	        <div onclick="expand()"><span data-locale-html="expand">展开</span></div>  
	        <div onclick="collapse()"><span data-locale-html="collips">收起</span></div>  
	        <div class="menu-sep"></div>  
	        <div onclick="expandAll()"><span data-locale-html="expandall">展开所有</span></div>  
	        <div onclick="collapseAll()"><span data-locale-html="collipsall">收起所有</span></div>  
        </div>
     </div>
    
     <div data-options="region:'center',split:true,collapsed:false,border:false" >  <!-- height:170px;overflow: hidden; -->
     	<input type="hidden" id="lastRefreshConn"/>
    	<input type="hidden" id="isDelWelcomeTab" value="0"/>
		<div class="easyui-tabs" id="zkTab" data-options="tools:'#tab-tools',toolPosition:'right',fit:true" >  
		
		    <div id="nodeinfo" title="节点信息" style="padding:10px;">  
		    	<p><font color="red">
		        <ol>
				<li><span data-locale-html="centerindication1">请在上面表中选择一个Zookeeper的连接。</span></li>
		        <li><span data-locale-html="centerindication2">请在左侧点击折叠按钮。</span></li>
		        </ol>
		        </font>
		        </p>
		    </div>   
		</div>  
		<div id="tab-tools">  
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-tip',iconAlign:'left'"><span data-locale-html="connstaterefresh" >连接状态刷新：</span><span id="connstaterefresh"><font color="red">Disconnect</font></span></a>  
        	<a href="javascript:void(0)" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add',iconAlign:'left'" onclick="javascript:$('#zkweb_add_node').window('open');" data-locale-attr="addnodetitle" title="在当前节点下增加节点"><span data-locale-html="addnode">增加新节点</span></a>  
        	<a href="javascript:void(0)" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-remove',iconAlign:'left'" onclick="remove()" data-locale-attr="addnodetitle" title="删除当前节点"><span data-locale-html="removenode">删除当前节点</span></a>  
    	</div>
    </div>  
    <!-- add -->
    <div id="zkweb_add_node" class="easyui-window" title="添加节点" data-options="iconCls:'icon-add',modal:true,closed:true,maximizable:false" style="width:500px;padding:10px;">  
        
        <div style="text-align:center;padding:5px">
        	<span data-locale-html="addwindowlabel">输入节点名称:</span>
       		<input id="zkNodeName" class="easyui-validatebox" type="text" data-options="required:true,tipPosition:'right'"></input> 
        </div>
        
        <div style="text-align:center;padding:5px">
        	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="addzkNode()"><span data-locale-html="save">保存</span></a>
        	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="$('#zkweb_add_node').window('close');" ><span data-locale-html="cancel">取消</span></a>  
        </div>
        
    </div>
    
    <div id="zkweb_add_cfg" class="easyui-window" title="添加配置信息" data-options="iconCls:'icon-add',modal:true,closed:true,maximizable:false" style="width:280px;height:170px;padding:10px;">  
        
        <form id="zkweb_add_cfg_form" method="post" action="zkcfg/addZkCfg">  
		    <table>    
		        <tr>    
		            <td>DESC:</td>    
		            <td><input name="desc" type="text"></input></td>    
		        </tr>    
		        <tr>    
		            <td>CONNECTSTR:</td>    
		            <td><input name="connectstr" type="text"></input></td>    
		        </tr>    
		        <tr>    
		            <td>SESSIONTIMEOUT:</td>    
		            <td><input name="sessiontimeout" type="text"></input></td>    
		        </tr>    
		        <tr>    
		            <td>
		            	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveCfg()"><span data-locale-html="save">保存</span></a>
		            </td>    
		            <td>
		            	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="$('#zkweb_add_cfg').window('close');" ><span data-locale-html="cancel">取消</span></a> 
		            </td>    
		        </tr>    
		    </table>  
		</form>
        
    </div>  
    
    <div id="zkweb_up_cfg" class="easyui-window" title="更新配置信息" data-options="iconCls:'icon-update',modal:true,closed:true,maximizable:false" style="width:280px;height:170px;padding:10px;">  
        
        <form id="zkweb_up_cfg_form" method="post" action="zkcfg/updateZkCfg">  
            <input type="hidden" name="id"/>
		    <table>    
		        <tr>    
		            <td>DESC:</td>    
		            <td><input name="desc" type="text"></input></td>    
		        </tr>    
		        <tr>    
		            <td>CONNECTSTR:</td>    
		            <td><input name="connectstr" type="text"></input></td>    
		        </tr>    
		        <tr>    
		            <td>SESSIONTIMEOUT:</td>    
		            <td><input name="sessiontimeout" type="text"></input></td>    
		        </tr>    
		        <tr>    
		            <td>
		            	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="updateCfg()"><span data-locale-html="save">保存</span></a>
		            </td>    
		            <td>
		            	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="$('#zkweb_up_cfg').window('close');" ><span data-locale-html="cancel">取消</span></a> 
		            </td>    
		        </tr>    
		    </table>  
		</form>
        
    </div>  

</body> 

</html>