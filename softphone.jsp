<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%
response.setHeader("Cache-Control","no-store");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0L);

if(request.getProtocol().equals("HTTP/1.1"))
	response.setHeader("Cache-Control","no-cache");

String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <base href="<%=basePath%>"/>
    <title>DICC Call Center System</title>
    <link rel="stylesheet" type="text/css" href="js/ext/resources/css/ext-all.css" />
    <style type="text/css">
	    html, body {
	        font:normal 12px verdana;
	        margin:0; padding:0; border:0 none;
	        overflow:hidden;   height:100%;
	        background-color:#f6faff;
	    }
	    body{
	    	background-image:url(/images/top/top.background.jpg);
	    	background-position: left top;
	    	background-repeat: repeat-x;
	    }
	    p {  margin:5px; }
	    .settings { background-image:url(js/ext/examples/shared/icons/fam/folder_wrench.png);  }
	    .nav { background-image:url(js/ext/examples/shared/icons/fam/folder_go.png); }
	    .icon-add { background-image: url(js/images/ext-icons/add.gif) !important; background-repeat: no-repeat; }
	    
    </style>
    <style type="text/css">
		.x-border-layout-ct{
			background-color: #f6faff;
		}
		div.top_content{
			background-image: url(images/top/top.background.banner.jpg);
			background-position: right top;
			background-repeat: no-repeat;
			width: 100%;
			height: 70px;
			overflow: hidden;
		}
		div#topMenuBar{
			text-align: right;
			height: 25px;
		}
		div.callJobStat{
			background-image: url(images/top/callJobStatus/bar.background.jpg);
			background-position: right top;
			background-repeat: repeat-x;
			width: 100%;
			height: 26px;
			overflow: hidden;
		}
		table{
			border-collapse: collapse;
		}
		ul#ulCallJobStat{
			padding: 0 0 0 0;
			margin: 0 0 0 0;
            list-style-type: none;
		}
		ul#ulCallJobStat li{
            float: left;
			margin: 0 0 0 0;
			padding: 0 0 0 0;
            padding-right: 10px;
            font-family: 微软雅黑, Tahoma;
            font-size: 12px;
            color:#5b5b5b;
		}
	</style>
    <script type="text/javascript" src="js/ext/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="js/ext/ext-all.js"></script>
	<script type="text/javascript" src="js/ext/src/locale/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="js/common/Ext.ux.IFrameComponent.js"></script>
    <!--<script type="text/javascript" src="js/common/common_data.js"></script> -->
	<script type="text/javascript" src="js/common/global_functoin.js"></script>
    <script type="text/javascript" src="js/jquery-1.5.1.min.js"></script>
    
	<script type="text/javascript">
	
//==========================================================
// global cti softphone variable
//==========================================================
var ret;
var serverAddr = '10.41.128.33';//'109.254.1.212'  
var serverAddr2 ='10.41.128.33';//'109.254.1.212' 
var extension = '4'; //: ASI//'4';  //CSTA2
var agentId = '${sessionScope.userMaster.userCtiAgentID}'   // '1001'; //document.all.id.value;
var deviceDn = '${sessionScope.userMaster.userCtiNum}' //'2001';//softphone DN//document.all.dn.value;
var callingDn ='${sessionScope.userMaster.userCtiNum}' //'2001';// document.all.dn.value;
var calledDn = '';//document.all.phoneNo.value;
var divertedDn = '';//document.all.phoneNo.value;
var salesGroupCode_Login ='${sessionScope.userMaster.groupMaster.salesGroupCode}' //代理商编码;
var uui = '';//document.all.uui.value;
var uei = '';//document.all.uei.value;
var ci = '';//document.all.ci.value;
var softPhoneCallID = '';
var outboundRtnObject;
var timer1Counter;
var timer2Counter;
var timer3Counter;
var timer4Counter;
var timer5Counter;
var timer6Counter;
var timer7Counter;
var timer8Counter;
var consultationFlag = 'N';
var filePath = '';

var gInOutPageMenuId = 'iframe-MENU001-01';

//==========================================================
// end - global cti softphone variable
//==========================================================
	
//==========================================================
// 防止刷新功能禁用 F5,ESC, Backspace键
//==========================================================
	
/**
 * 防止刷新
 */	
function stopKeyList(){
	//'f5'
	if(event.keyCode == 116 ){
		event.keyCode = 0;
		event.cancelBubble = true;
		event.returnValue = false;
	}
	//esc
	if(event.keyCode == 8 ){
		event.keyCode = 0;
		event.cancelBubble = true;
		event.returnValue = false;
	}
	//back-space
	if(event.keyCode == 27 ) {
		event.keyCode = 0;
		event.cancelBubble = true;
		event.returnValue = false;
	}
} // end function stopKeyList()

document.onkeydown = stopKeyList;

//==========================================================
// end - 防止刷新功能禁用 F5,ESC, Backspace键
//==========================================================

//====================================================================
// 业务现状监控 - 目前有"未决","回访","回拨","点检报告","巡检","Rework","故障预警","投诉"
//====================================================================
/**
 * 业务现状监控 - 未决
 */
function getReservationCallCounter(){
 	Ext.Ajax.request({
		url : '/callcenter/outbound_getReservationCount.action' , method : 'POST',
		callback:function(options,success,response){
			var json = Ext.decode(response.responseText);
			if(json && json.success){
				$('#outboundList1Value').html(json.msg || 0);
			}//end if
		}//  end callback
	}); // end Ext.Ajax.request({
} // end function getReservationCallCounter	


/**
 * 业务现状监控 - 回访
 */
function getHappyOutBoundCallCounter(){
	Ext.Ajax.request({
		url : '/callcenter/outbound_getHappyOutBoundCallCount.action' , method : 'POST',
		callback:function(options,success,response){
			var json = Ext.decode(response.responseText);
			if(json && json.success){
				//document.all.outboundList2Value.innerText = json.msg;
				$('#outboundList2Value').html(json.msg || 0);
			}// end if
		} // end callback
	}); // end request
}// end function getHappyOutBoundCallCounter

/**
 * 业务现状监控 - 回拨
 */
function totalIvrRemainCount(){
    Ext.Ajax.request({
		url : '/callcenter/ivrRecording_totalIvrRemainCount.action' , method : 'POST',
		callback:function(options,success,response){
			var json = Ext.decode(response.responseText);
			if(json && json.success){
				$('#outboundList3Value').html(json.msg || 0);
			} // end if
		} // end callback
	});// end Ext.Ajax.request({
} // end function totalIvrRemainCount()

/**
 * 查询cti中当前等待的客户数
 */
function getWaitPhoneCount(){
    Ext.Ajax.request({
		url : '/report/reportRtb_getWaitPhoneCount.action' , method : 'POST',
		callback:function(options,success,response){
			var json = Ext.decode(response.responseText);
			if(json && json.success){
			 document.all.waitCount.innerText = json.msg;
			} // end if
		} // end callback
	});// end Ext.Ajax.request({
} // end function getWaitPhoneCount()

/**
 * 业务现状监控 - 点检报告
 */
function getRegularInspectionCounter(){
  	Ext.Ajax.request({
		url : '/callcenter/outbound_getPeriodicEnabledCount.action' , method : 'POST',
		callback:function(options,success,response){
			var json = Ext.decode(response.responseText);
			if(json && json.success){
				$('#outboundList4Value').html(json.msg || 0);
			} // end if
		}// end callback
	}); // end request
}// end function getRegularInspectionCounter 


/**
 * 业务现状监控 - 巡检
 */
function getPatrolExamineOrderCount(){
  	Ext.Ajax.request({
		url : '/callcenter/patrol_getPatrolExamineOrderCount.action' , method : 'POST',
		callback:function(options,success,response){
			var json = Ext.decode(response.responseText);
			if(json && json.success){
				$('#outboundList5Value').html(json.msg || 0);
			} // end if
		}// end callback
	}); // end request
}// end function getPatrolExamineOrderCount 

/**
 * 业务现状监控 - Rework
 */
function getReworkOrderCount(){
  	Ext.Ajax.request({
		url : '/callcenter/patrol_getReworkOrderCount.action' , method : 'POST',
		callback:function(options,success,response){
			var json = Ext.decode(response.responseText);
			if(json && json.success){
				$('#outboundList6Value').html(json.msg || 0);
			} // end if
		}// end callback
	}); // end request
}// end function getReworkOrderCount 

/**
 * 业务现状监控 - 故障预警
 */
function getFaultWarningListCount(){
 	Ext.Ajax.request({
		url : '/callcenter/outbound_getFaultWarningListCount.action' , method : 'POST',
		callback:function(options,success,response){
			var json = Ext.decode(response.responseText);
			if(json && json.success){
				$('#outboundList7Value').html(json.msg || 0);
			}//end if
		}//  end callback
	}); // end Ext.Ajax.request({
} // end function getFaultWarningListCount	

/**
 * 业务现状监控 - 投诉
 */
function getVocCallListCount(){
 	Ext.Ajax.request({
		url : '/callcenter/outbound_getVocCallListCount.action' , method : 'POST',
		callback:function(options,success,response){
			var json = Ext.decode(response.responseText);
			if(json && json.success){
				$('#outboundList8Value').html(json.msg || 0);
			}//end if
		}//  end callback
	}); // end Ext.Ajax.request({
} // end function getVocCallListCount	

/**
 * 更新业务状态 -"未决"数,"回访"数,"回拨"数,"点检报告"数,"巡检"数,"Rework"数
 */
function refreshTotalCount(){
	getReservationCallCounter();
	totalIvrRemainCount();
	getHappyOutBoundCallCounter();
	getRegularInspectionCounter();
	getPatrolExamineOrderCount();
	getReworkOrderCount();
	getFaultWarningListCount();
	getVocCallListCount(); 
} // end function refreshTotalCount


/**
 * 更新业务状态 -"未决"数,"回访"数,"回拨"数,"点检报告"数,"巡检"数,"Rework"数
 * 启动Timer 每20分钟更新一次
 */
function OnStartOfCounter(){
	refreshTotalCount();
	//run every 20 minutes
	var intervalTime = 1200000 ;
	timer1Counter = setTimeout("getReservationCallCounter()",intervalTime);
	timer2Counter = setTimeout("totalIvrRemainCount()",intervalTime);
	timer3Counter = setTimeout("getHappyOutBoundCallCounter()",intervalTime);
	timer4Counter = setTimeout("getRegularInspectionCounter()",intervalTime);
	timer5Counter = setTimeout("getPatrolExamineOrderCount()",intervalTime);
	timer6Counter = setTimeout("getReworkOrderCount()",intervalTime);
	timer7Counter = setTimeout("getFaultWarningListCount()",300000);
	timer8Counter = setTimeout("getVocCallListCount()",intervalTime);
	
	//timer7Counter = setInterval("getWaitPhoneCount()",5000);
	
} // end function OnStartOfCounter


/**
 * 删除业务状态Timer -"未决"数,"回访"数,"回拨"数,"点检报告"数,"巡检"数,"Rework"数
 */
function OnExitTimer(){
	clearTimeout(timer1Counter);
	clearTimeout(timer2Counter);
	clearTimeout(timer3Counter);
	clearTimeout(timer4Counter);
	clearTimeout(timer5Counter);
	clearTimeout(timer6Counter);
	clearTimeout(timer8Counter);
	//clearInterval(timer7Counter);
} // end function OnExitTimer

//==========================================================================
// END 业务现状监控 - 目前有"未决","回访","回拨","点检报告","巡检","Rework"
//==========================================================================

	
//============================================================
// VRS(录音)服务器联动部分 
// VOICE FILE MANAGEMENT 
// 有问题联系 - 孙留名
//=============================================================

var strExtension = deviceDn; //????
var strLoginID	 = agentId;	 //CTI ?? ?? ??? ID
var strID		 = agentId;	 //??? ID
var strGroup	 = 400; 	//??? ?? ID
var strName		 = ' ';		//????
var nExtraInfo	 = 0; 		//????/???? ?? ?? ??(Neovoice Client ??? ??? ???? ???)
var sPBXInfo	 = 3; 		//??? ??(1:Definity, 2:Meridian, 3:IPOffice, 4:OfficeServe)


/**
 * NEOClient OCX ??? ??? ????.
 */
function Init(){	
	NEOClient.LogDirectory = "C:\\NEOClient\\Log"; // 指定Log文件夹位置
	var val = NEOClient.InitializeCtrl(strExtension,strLoginID,strID,strGroup,strName,nExtraInfo,sPBXInfo);
	return val;
}


/**
 * NEOClient OCX ?? ??? ????.
 */
function UnInit(){		
	var val = NEOClient.UninitializeCtrl();
	return val;
}

//====================================================================
// OCCUR EVENT
//====================================================================
//
/**
 * NEOClient OCX? ?? ??? ????.
 * return -1: 没有安装        0：已安装
 */
function Load(){	
	var rtnValue = '-1'
	if(!NEOClient.object){
		alert("没有安装NEOClient OCX.请重新登录，若再次登录还是出现此问题，请联系IT部");
		rtnValue = '-1';
	}else{
		//	ADD EVENT						
		NEOClient.attachEvent("ConnectRecordServer", ConnectRecordServer);			//Record Server? ??? ?? ??? ? ??
		NEOClient.attachEvent("DisconnectRecordServer", DisconnectRecordServer);	//Record Server? ??? ??? ?? ?? ? ??
		NEOClient.attachEvent("RecordStatusChanged", RecordStatusChanged);			//Agent ??? ??? ??? ????.
		rtnValue = 0;
	}
	return rtnValue;
} // end function Load

function RecordUpdate(){}
function RecordUpdateEx(){}
function RecordStopSection(){}
function RecordStopEx() {}
function RecordStop(){}
function RecordStartSection(){}
function ExecuteNCScreen(){}
function TerminateNCScreen(){}
function StartCapture(){}
function StopCapture(){}		
function Success_msg(msg){}
function Clear_msg(){}
function ConnectRecordServer(strIP, IPort){}
function DisconnectRecordServer(strIP, IPort){}
	
/**
 * NEOClient OCX Event - Agent ??? ??? ??? ????.
 */	
function RecordStatusChanged(sServerNo, sEventType, strSystemID, strExtension, strBeginTime, strCTILoginID, strAgentName, strEndTime, strANI, strConnID, strFilePath, strDial, IRecTime, slnOutFlag) {

	var msg	= "<< Record Status Changed >>" +'\n'
        	+ "Server No : "		+ sServerNo 	+", Event Type : "		+ sEventType 	+", System ID : "+ strSystemID +'\n' 
		   	+ "Extension : "		+ strExtension 	+", CTI Login ID :"		+ strCTILoginID +", Agent Name :"+ strAgentName +'\n' 
		   	+ "Record Begin Time : "+ strBeginTime 	+", Record End Time :"	+ strEndTime 	+'\n'
		   	+ "ANI : "				+ strANI 		+", Conntction ID: "	+ strConnID 	+", File Path : "+ strFilePath +	", Dial : "	+ strDial  +'\n'
		   	+ "Rec Time : "			+ IRecTime 		+", In/Out Flag :"		+ slnOutFlag;

	filePath = '';
	filePath = new String(strFilePath);
	//replace '\' --> '/'
	filePath = filePath.replace(/\\/g,'/');
	filePath = filePath.replace('.TMP','');
	filePath = filePath.replace('.REC','');

	//若商谈页面已激活的话， 实时传递录音文件信息到商谈页面
	var frames=window.parent.window.document.getElementById(gInOutPageMenuId);
	if (frames != null ){
		//调用商谈页面(inbound.js)的函数 gfn_softphone_setRecordInfo
	  	frames.contentWindow.gfn_softphone_setRecordInfo({ 
		 	strExtension : strExtension , 
		  	strCTILoginID : strCTILoginID , 
		  	strBeginTime : strBeginTime , 
		  	filePath : filePath , 
		  	slnOutFlag : slnOutFlag  
		});
	} // end if
} // end function RecordStatusChanged


/**
 * Record Server? ????.
 * 注册录音服务器配置信息
 * IP及端口信息 当服务器位置变化是需要调整 - 有问题联系孙刘明
 * 注册失败返回 -1 
 */
function AddNVInfo(){	

	var sServerNo	= 0;
	var sServerAddr	= '10.41.128.32';
	var IPort		= '5001';
	
	var val = NEOClient.AddNVInfo(sServerNo, sServerAddr, IPort);
	
	if(val == 0){ //??
		val = NEOClient.ConnectToNV(5000);
	}else{
		val = -1;
	}
	
	return val;	
} // end function AddNVInfo()


/////////////////////////////////////////////////////////////////

//==========================================================
//SHOW CALL LIST
//id='outboundList'
/**
 * 与CTI服务器联动-进行电话呼叫
 * CTI??? ?? , ????
 * @param String number 电话号码
 */
function makeUpCallFromChildSoftPhone(number){
	//MAKE UP CALL : callingDn, calledDn, uui, uei, ci
	calledDn=number || '';
	if (calledDn.trim() != ''){
		Ext.Ajax.request({
			url : '/callcenter/outboundCalling_callingNumber.action' , method : 'POST',
			params : {calledDn : calledDn},
			callback:function(options,success,response){
				var json = Ext.decode(response.responseText);
				if( json != null ){
					if( json.msg != null ){
						if(json.msg == 'SUCCESS'){
					 		calledDn = json.phone ;

							Ext.MessageBox.show({title: '请耐心等待',msg: '正在呼叫中.........', width:300, closable:false});
					    	//callCtmpMethod('ClearConnection');
					    	callCtmpMethod('MakeCall');
						}else{
							if( json.msg != null ){
								alert(json.msg);
							}// end if
						} // end if
					} // end if( json.msg != null )
				} // end if( json != null ){	
			} // end callback
 		});// end ext request
	}// end if
} // end function makeUpCallFromChildSoftPhone


/**
 * 弹出软件话-输入电话号码界面
 * @param String callType 
 * @param String number 电话号码
 */
function popupDialDialog(callType,number){
	calledDn='';
	number = number || '';
	
	var url = '<%=basePath%>' + 'jsp/callcenter/phone_open.jsp';
	var params = 'dialogheight:330px;dialogwidth:240px;' 
			   + 'center=yes,toolbar=no , menubar=no, scrollbars=no, resizable=no,location=no, status=yes';  

   	var rtnObj = window.showModalDialog(url,number,params);
		
	if(callType == 'CALLING' && !!rtnObj){
  		if(outboundRtnObject.selectTab == '8'){
  		//投诉回访
			fnOpenVocHappyCallWindow(true);
  	  	}
  		makeUpCallFromChildSoftPhone(rtnObj);
	}
	
	return rtnObj;
} // end function popupDialDialog



/**
 * 弹出执行回访window窗口
 * @param refreshAble Boolean 是否从新获得总数 
 */
function fnOpenHappyCallWindow(refreshAble){

	if(!!outboundRtnObject){

		if(outboundRtnObject.selectTab == '2'){
			// 2013422 防止录音文件重复
			filePath =  '';			
			 var calltype = outboundRtnObject.calltype || '1';
			// 2013422 防止录音文件重复 end
			 var url = '/callcenter/outbound_loadHappyCallWithQuestions.action' 
		         + '?outboundAssignUniqueID=' + outboundRtnObject.outboundAssignUniqueID 
		         + '&outboundManagerUniqueID=' + outboundRtnObject.outboundManagerUniqueID 
		         + '&callHistoryTransactionCode=' + outboundRtnObject.callHistoryTransactionCode 
		         + '&customerCode=' + outboundRtnObject.customerCode
		         + '&calltype=' + calltype
			 	 + '&outboundCallNumber=' + calledDn;		         
			var params = 'height:650px;width:710px;' 
						+ 'center=yes,toolbar=no , menubar=no, scrollbars=yes, resizable=no,location=no, status=yes';  
		 	window.open(url,"HAPPYY_CALL",params);
		}else if(outboundRtnObject.selectTab == '5'){

			var frames=window.parent.window.document.getElementById(gInOutPageMenuId);
			 
			if (frames != null){
	    		frames.contentWindow.gfn_receive_rework_and_patrol_examine({
	    			reportType:'608',
	    			noticeId:outboundRtnObject.noticeId,
	    			noticeSubId:outboundRtnObject.noticeSubId,
	    			prdType:outboundRtnObject.prdType,
	    			prdsrNum:outboundRtnObject.prdsrNum
	    		});
	    	}//end if (frames != null){
		}else if(outboundRtnObject.selectTab == '6'){

			var frames=window.parent.window.document.getElementById(gInOutPageMenuId);
			 
			if (frames != null){
	    		frames.contentWindow.gfn_receive_rework_and_patrol_examine({
	    			reportType:'603',
	    			noticeId:outboundRtnObject.noticeId,
	    			noticeSubId:outboundRtnObject.noticeSubId,
	    			prdType:outboundRtnObject.prdType,
	    			prdsrNum:outboundRtnObject.prdsrNum
	    		});
	    	}//end if (frames != null){
		}
 		
 	 	outboundRtnObject = null;

 	 	if(refreshAble){
 	 		refreshTotalCount();
 	 	}
	} 
} // end func fnOpenHappyCallWindow

function fnOpenVocHappyCallWindow(refreshAble){
	url='/callcenter/dvoc_forwardVocHappyCallPage.action?callHistoryTransactionCode='+outboundRtnObject.chtid;
	var params = 'height=530,width=935,left=100,top=50,toolbar=no,toolbar=no , menubar=no, scrollbars=yes, resizable=yes,location=no, status=yes'; 
	window.open(url,"VOC_HAPPYY_CALL",params);
}

	
$(function(){ 

	$('li.outboundListType').click(function(){
		var _id  = this.id;
		var _idx = _id.substr('outboundList'.length);
		//alert(_idx);

		var frames =window.parent.window.document.getElementById(gInOutPageMenuId);
	    if (salesGroupCode_Login == "109" ||salesGroupCode_Login == "164"){
		    //alert('salesGroupCode='+salesGroupCode);
		}else{
			if(frames == null){
		   		alert("请先打开商谈界面");
		   		return false;
			}
		}
		var url = '/callcenter/outbound_prelist.action?to='+_idx;
		var params = 'dialogheight:400px;dialogwidth:925px;dialogLeft=100px;dialogTop=150px;toolbar=no , menubar=no, scrollbars=no, resizable=no,location=no, status=yes';  
   
		var paramsObj = {};
		paramsObj.type = _idx ;  
		//下面为何传递popupDialDialog 不理解～～～～～～～～～～
		if(_idx == 1){ //未决
			paramsObj.popupDialDialog = makeUpCallFromChildSoftPhone;
		}else if(_idx == 2){ //OUTBOUND LIST
			paramsObj.popupDialDialog = makeUpCallFromChildSoftPhone;
		}else if(_idx == 3){ //RESERVATION LIST(IRV REC)
			paramsObj.popupDialDialog = popupDialDialog;
		}else if(_idx == 4){ //点检报告
			paramsObj.popupDialDialog = popupDialDialog;
		}else if(_idx == 5){ //巡检
			paramsObj.popupDialDialog = popupDialDialog;
		}else if(_idx == 6){ //Rework
			paramsObj.popupDialDialog = popupDialDialog;
		}

		outboundRtnObject =window.showModalDialog(url,paramsObj,params);

		if(outboundRtnObject != null){
			if(outboundRtnObject.selectTab == '1'){
		    	if(outboundRtnObject.updateTab == '1'){//维修
		    		frames.contentWindow.gfn_callout({ 
						callHistoryTransactionCode : outboundRtnObject.callHistoryTransactionCode,
						type : '1',
						callNo:outboundRtnObject.dialNumber,
						callID : ''//softPhoneCallID
					});
		    	}else if(outboundRtnObject.updateTab == '2'){//咨询
		    		frames.contentWindow.gfn_callout({  
						callHistoryTransactionCode : outboundRtnObject.callHistoryTransactionCode,
						type : '2',
						callNo:outboundRtnObject.dialNumber
						//,callID : ''//softPhoneCallID
					});
		    	}else if(outboundRtnObject.updateTab == '3'){//投诉
		    		frames.contentWindow.gfn_callout({ 
						callHistoryTransactionCode : outboundRtnObject.callHistoryTransactionCode,
						type : '3',
						callNo:outboundRtnObject.dialNumber//,
						//callID : ''//softPhoneCallID
					});
		    	}else if(outboundRtnObject.updateTab == '4'){//定期检点
		    		frames.contentWindow.gfn_callout({ 
						callHistoryTransactionCode : outboundRtnObject.callHistoryTransactionCode,
						type : '4',
						callNo:outboundRtnObject.dialNumber,
						callID : '',//softPhoneCallID
						orderNum : outboundRtnObject.orderNum,
						tab4InputType : 2
					});
		    	}
			}else {  //NEED TO CALLING	
				popupDialDialog('CALLING',outboundRtnObject.dialNumber)
			}


			if(_idx == 1){ //未决
				refreshTotalCount();
			}else if(_idx == 2){ //OUTBOUND LIST
				 
			}else if(_idx == 3){ //RESERVATION LIST(IRV REC)
				refreshTotalCount();
			}else if(_idx == 4){ //点检报告
				
			}else if(_idx == 5){ //巡检
				 
			}else if(_idx == 6){ //Rework
				 
			}		
					
		} // end if(outboundRtnObject != null){
		
	}); // end func $('li.outboundListType').click
}); // end of function



/**
 * 切换CTI服务器状态
 * @param String status 
 * 			ON  : 已登录服务器
 * 			OFF : 未登录服务器
 */
function changeCtiStatus(status){
	if (status=='ON'){
	   	$("img#sp_ctiStatus").attr('src',"/images/top/softphone/back.ctiStatus_01.jpg");
	}else{
		$("img#sp_ctiStatus").attr('src',"/images/top/softphone/back.ctiStatus_02.jpg");
	}
}


/**
 * 切换软段话状态
 * @param String status 
 * 			ON  : 接电话状态
 * 			OFF : 未接电话状态
 */
function changeSoftphoneStatus(status){
	var imageUrl = "";
	if (status=='ON'){
		$("img#sp_lineStatus").attr('src',"/images/top/softphone/back.lineStatus_03.gif");
   	 	
   	 	//??? ???(禁止按键)
   	 	//$('img#sp_btnDial').unbind("click");
		//imageUrl = $('img#sp_btnDial').attr('src');
		//imageUrl = imageUrl.replace('_01','_02');
		//$('img#sp_btnDial').attr('src', imageUrl);
		
   	 	//???? ???(禁止接电话)
   	 	$('img#sp_btnAnswer').unbind("click");
		imageUrl = $('img#sp_btnAnswer').attr('src');
		imageUrl = imageUrl.replace('_01','_02');
		$('img#sp_btnAnswer').attr('src', imageUrl);
   	 	
   	 	//???? ??(激活可挂断电话)
  	//$('img#sp_btnHangup').unbind("click");
	//	$('img#sp_btnHangup').bind("click", function(){sp_btnHangupClick();});
	//	imageUrl = $('img#sp_btnHangup').attr('src');
	//	imageUrl = imageUrl.replace('_02','_01');
	//	$('img#sp_btnHangup').attr('src', imageUrl);

		//????(激活协议)
  		$('img#sp_btnExchange').unbind("click");
		$('img#sp_btnExchange').bind("click", function(){sp_btnExchangeClick();});
		imageUrl = $('img#sp_btnExchange').attr('src');
		imageUrl = imageUrl.replace('_02','_01');
		$('img#sp_btnExchange').attr('src', imageUrl);

		//???? ????(激活离开座位	)
  		//$('img#sp_togLeaving').unbind("click");
		//imageUrl = $('img#sp_togLeaving').attr('src');
		//imageUrl = imageUrl.replace('_02','_01');
		//$('img#sp_togLeaving').attr('src', imageUrl);
		
		//???(AFTER CALL WORK)????(激活后处理)	   	 	
		//$('img#sp_togAfterCallWork').unbind("click");
		
		//?????(激活hold)
		$('img#sp_togHoldding').bind("click", function(){sp_togHolddingClick();});
		imageUrl = '/images/top/softphone/togHoldding_03.jpg';
		$("img#sp_togHoldding").attr('src', imageUrl);
		
   }else{ //???? : ??? ???.
		$("img#sp_lineStatus").attr('src',"/images/top/softphone/back.lineStatus_01.gif");
		spButtonInitial();
		spToggleInitial();
		
		//???? ????(禁止接电话)
  		$('img#sp_btnAnswer').unbind("click");
		imageUrl = $('img#sp_btnAnswer').attr('src');
		imageUrl = imageUrl.replace('_01','_02');
		$('img#sp_btnAnswer').attr('src', imageUrl);

		//???? ? ???(禁止挂断简化)
		//$('img#sp_btnHangup').unbind("click");
		//imageUrl = $('img#sp_btnHangup').attr('src');
		//imageUrl = imageUrl.replace('_01','_02');
		//$('img#sp_btnHangup').attr('src', imageUrl);
		
		//???? ???(禁止离开座位)
		//$('img#sp_togLeaving').bind("click", function(){sp_togLeavingClick();});
  
  		//?? ????(禁止hold)
  		$('img#sp_togHoldding').unbind("click");
		imageUrl = '/images/top/softphone/togHoldding_01.jpg';
		$("img#sp_togHoldding").attr('src', imageUrl);
   }
} // end function changeSoftphoneStatus


	
function ctiServerStart(){
 	try{
     	if(Load() == 0){
    		if(Init() == 0){
    			if(AddNVInfo() == 0){
    		      	Ext.MessageBox.hide();
    		    }else{
            		Ext.MessageBox.hide();
   	         		alert("连接录音服务器出错，请关闭窗口，重新登录");
		  			top.opener = top;
 		  			top.window.close();
    		  	} // end if(AddNVInfo() == 0)	      
    		}else{
    			Ext.MessageBox.hide();
   	         	alert("连接录音服务器出错，请关闭窗口，重新登录");
 		  		top.opener = top;
  		  		top.window.close();
    		} // end if(Init() == 0){
 		}else{
    		Ext.MessageBox.hide();
         	alert("连接录音服务器出错，请关闭窗口，重新登录");
 		  	top.opener = top;
  		  	top.window.close();
    	} // end if(Load() == 0){
    }catch(e){
   		Ext.MessageBox.hide();
      	alert("连接录音服务器出错，请关闭窗口，重新登录");
 		top.opener = top;
  		top.window.close();
    } // end try
    
	try{
	   //CTI INIT & START	
		Ext.MessageBox.show({
           title: '请耐心等待',msg: '正在连接CTI服务器',
           progressText: '若长时间无法连接到CTI服务器时，请关闭所有已打开的浏览器，后重新尝试登录',
           width:600,progress:true,closable:false
       	});

   		changeCtiStatus("OFF");
		callCtmpMethod('OpenServer');
		Ext.MessageBox.updateProgress(200, "CTI正在尝试连接服务器");
		callCtmpMethod('LogOff');
		callCtmpMethod('LogOn');
		Ext.MessageBox.updateProgress(280, "CTI正在准备登录");
		sp_togLeavingClick();
		//UPDATE WHEN The user login the system, The first process is not ready
		//@update by nokang 2012-03-26
		//callCtmpMethod('Ready');
		sp_togLeavingClick();
		Ext.MessageBox.updateProgress(280, "座席正在登录CTI");
		
		//START TIMER
		OnStartOfCounter();
 	}catch(e){
       	 Ext.MessageBox.hide();
         alert("CTI登录失败! 请首先关闭所有已打开的浏览器后，重新登录");
 		 top.opener = top;
  		 top.window.close();
  	} // end try
} // end function ctiServerStart

	 
/////////////////////////////////////////
// softphone button function events
//hidSPEventStatus

// 软电话Event函数
// -1 : WAIT
//  0 : DIALING
//  1 : CALLING
//  9 : HOLDING
//  4 : NOT READY
//  5 : AFTER CALL WORK ???
//-99 : NOT AVAILABLE
/////////////////////////////////////////
/**
 * 初始化软电话按键
 */
function spButtonInitial(){
	$("img.spButton").each(function(){
		var imageUrl = $(this).attr('src');
		imageUrl = imageUrl.replace('_01','_02');
		$(this).attr('src', imageUrl);
	});
		
	imageUrl = $('img#sp_btnDial').attr('src');
	imageUrl = imageUrl.replace('_02','_01');
	$('img#sp_btnDial').attr('src', imageUrl);
		
	$('img#sp_btnHangup').unbind("click");
	$('img#sp_btnHangup').bind("click", function(){sp_btnHangupClick();});
	imageUrl = $('img#sp_btnHangup').attr('src');
	imageUrl = imageUrl.replace('_02','_01');
	$('img#sp_btnHangup').attr('src', imageUrl);
} // end function spButtonInitial()

	
function spToggleInitial(){
	var imageUrl = ""
	
	$('img#sp_togHoldding').unbind("click");
	$('img#sp_togHoldding').bind("click", function(){sp_togHolddingClick();});
	imageUrl = $("img#sp_togHoldding").attr('src');
	imageUrl = imageUrl.replace('_02','_01');
	$("img#sp_togHoldding").attr('src', imageUrl);
	
	imageUrl = $("img#sp_togLeaving").attr('src');
	imageUrl = imageUrl.replace('_02','_01');
	$("img#sp_togLeaving").attr('src', imageUrl);
} // end function spToggleInitial()


/**
 * 按拨号键时调用函数
 */
function sp_btnDialClick(){
	var status = document.getElementById("hidSPEventStatus").value
	popupDialDialog('CALLING');
}


/**
 * 按接听键时调用函数
 */
function sp_btnAnswerClick(){
	var status = document.getElementById("hidSPEventStatus").value
	if(status == '0'){//来电;
		//RECEIVE CALL
		callCtmpMethod('AnswerCall');
	}
} // end function sp_btnAnswerClick()


/**
 * 当调用挂断操作时调用
 * USE : DELIEVER(0), CALLING(1)?? ???
 */
function sp_btnHangupClick(){
	if(consultationFlag == 'Y'){
  		consultationFlag = 'N'
  		callCtmpMethod('Reconnect')
	}else{
		callCtmpMethod('ClearConnection');
	}	
} // end function sp_btnHangupClick()


/**
 * 当调用协议按键时操作
 * ????? ???? ?? ??? number? default? ?????  ?? ????.(商谈)
 */
function sp_btnExchangeClick(number){
	//alert('sp_btnExchangeClick = ' + consultationFlag);
	if(consultationFlag == 'Y'){
		consultationFlag = 'Y';
	   	changeSoftphoneStatus("ON");
	   	callCtmpMethod('Reconnect');
	}else{
		consultationFlag = 'N';
		var rtnValue = popupDialDialog('CONFERENCE',number);
		if(typeof(rtnValue) != 'undefined'){
		  	if(rtnValue.trim() != ''){
			  	///////////////////////////////////////////
			  	//?? ??
			  	//////////////////////////////////////////
		 	 	calledDn=rtnValue.trim();
		  	
			    Ext.Ajax.request({
					url : '/callcenter/outboundCalling_callingNumber.action' , method : 'POST',
					params : {calledDn : calledDn},
					callback:function(options,success,response){
						var json = Ext.decode(response.responseText);
						if(json.msg == 'SUCCESS'){
							calledDn = json.phone
							Ext.MessageBox.show({ title: '请耐心等待', msg: '正在商谈中...', width:300, closable:false });

						  	//??? TRANSFER, CONFERENCE
							$('img#sp_btnTransfer').unbind("click");
							$('img#sp_btnTransfer').bind("click", function(){sp_btnTransferClick();});
							imageUrl = $('img#sp_btnTransfer').attr('src');
							imageUrl = imageUrl.replace('_02','_01');
							$('img#sp_btnTransfer').attr('src', imageUrl);

							$('img#sp_btnConference').unbind("click");
							$('img#sp_btnConference').bind("click", function(){sp_btnConferenceClick();});
							imageUrl = $('img#sp_btnConference').attr('src');
							imageUrl = imageUrl.replace('_02','_01');
							$('img#sp_btnConference').attr('src', imageUrl);

	  						callCtmpMethod('Consultation');
						}else{
							alert(json.msg);
						} // end if
					} // end callback
			 	});// end ext request
			}else{
		  		alert("rtnValue.trim() != '' FALSE")
				return false;
			} // end if(rtnValue.trim() != ''){
		}else{
			alert("请输入电话号码!!!")
			return false;
		} // end if(typeof(rtnValue) != 'undefined'){ else
	} // end if(consultationFlag == 'Y'){ else
} // end function sp_btnExchangeClick(number)
	


/**
 * 当调用3方协议按键时操作
 */
function sp_btnConferenceClick(){
	var status = document.getElementById("hidSPEventStatus").value
	if(status == '1'){//CALLING;
		callCtmpMethod('Conference');
	}else{
	   alert("请稍候，电话正在连接中"+status);
	}		
} // end function sp_btnConferenceClick()


/**
 * 当调用呼叫转移按键时操作
 */
function sp_btnTransferClick(){
	var status = document.getElementById("hidSPEventStatus").value
	if(status == '1'){//CALLING;
		callCtmpMethod('Transfer');
	}else{
	   alert("请稍候，电话正在连接中"+status);
	}		
} ///  end function sp_btnTransferClick()

/**
 * 当调用挂起(Hold)键时调用
 */
function sp_togHolddingClick(obj){
	var status = document.getElementById("hidSPEventStatus").value;
	var imageUrl = "";
	
	switch(status){
	case "1"://???(若当前正在通话中时)
		callCtmpMethod('Hold');//hold
		break;
	case "9":
		spToggleInitial();
		callCtmpMethod('Retrieve');//hold cancel
		break;
	}
} // end function sp_togHolddingClick(obj)


/**
 * 当调用离开键时调用
 */
function sp_togLeavingClick(){
	var status = document.getElementById("hidSPEventStatus").value;
	if ( status != '4' ){
	  	callCtmpMethod('NotReady')
	} else
	{
		callCtmpMethod('Ready');
	}
} // end function sp_togLeavingClick()


/**
 * 当调用后处理键时调用
 */
function sp_togAfterCallWorkClick(){
	var status = document.getElementById("hidSPEventStatus").value;
	if (status=='5'){ //后处理时
		callCtmpMethod('Ready');
	}else{
		callCtmpMethod('NotReady');
	}
} // end function sp_togAfterCallWorkClick()

/////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
//-------------------------------------------------------SOFTPHONE SETTING
function callCtmpMethod(func) {
	// ??? ?? ??(opentide 401,201:doushan)
	document.all.ctmpConnector.setAgentInfo(agentId, "agentData" , "401", deviceDn);
 
	// CAPI function ??
	switch (func){
		case "OpenServer":
			ret = document.all.ctmpConnector.openServer(serverAddr,extension);
			break;
		case "OpenServerHA":
			ret = document.all.ctmpConnector.openServerHA(serverAddr,serverAddr2,extension);
			break;
 		case "CloseServer":
			ret = document.all.ctmpConnector.closeServer();
			break;
		case "MakeCall":
			ret = document.all.ctmpConnector.makeCall(callingDn, calledDn, uui, uei, ci);
			break;
		case "AnswerCall":
			ret = document.all.ctmpConnector.answerCall();
			break;
		case "ClearConnection":
			ret = document.all.ctmpConnector.clearConnection();
			break;
		case "Hold":
			ret = document.all.ctmpConnector.hold();
			break;
		case "Consultation":
			consultationFlag = "Y";
			//TEST
			//uui = '18616316730'
			//if the customer number is exist in the screen shang tan,using parameter
			//	var frames=window.parent.window.document.getElementById(gInOutPageMenuId);
			//	if (frames != null ){
			//		uui = frames.contentWindow.document.getElementById("callInNumber").innerHTML;
			//	}else
			//	   uui = "";
			ret = document.all.ctmpConnector.consultation(calledDn, uui, uei, ci,"0");
			break;
		case "Transfer":
			ret = document.all.ctmpConnector.transfer();
			break;
		case "Conference":
			ret = document.all.ctmpConnector.conference();
			break;
		case "Retrieve":
			ret = document.all.ctmpConnector.retrieve();
			break;
		case "Reconnect":
			ret = document.all.ctmpConnector.reconnect();
			break;
		case "SingleStepTransfer":
			ret = document.all.ctmpConnector.singleStepTransfer(calledDn, uui, uei, ci);
			break;
		case "Divertdirect":
			ret = document.all.ctmpConnector.divertdirect(divertedDn, uui, uei, ci);
			break;
		case "Divertdeflect":
			ret = document.all.ctmpConnector.divertdeflect(divertedDn, uui, uei, ci);
			break;
		case "QueryAgentStatus":
			ret = document.all.ctmpConnector.queryAgentStatus();
			break;
		case "BusyGet":
			ret = document.all.ctmpConnector.agentBusyGet();
			break;
		case "LogOn":
			ret = document.all.ctmpConnector.setFeatureAgentStatus(0);
			break;
		case "LogOff":
			ret = document.all.ctmpConnector.setFeatureAgentStatus(1);
			break;
		case "ReadyGet":
			ret = document.all.ctmpConnector.agentReadyGet();
			break;
		case "Ready":
			ret = document.all.ctmpConnector.setFeatureAgentStatus(3);
			break;
		case "NotReady":
			ret = document.all.ctmpConnector.setFeatureAgentStatus(2);
			break;
		case "AfterCallWork":
			ret = document.all.ctmpConnector.setFeatureAgentStatus(5);
			break;
		case "CampaignListHandle":
			ret = document.all.ctmpConnector.SetCampaignListHandle();
			break;
 	} // end switch
 
	if (ret == 1) {
		document.all.ctmpResult.value = func + " succeeded.\n" + document.all.ctmpResult.value;
	} else {
		document.all.ctmpResult.value = func + " failed["+ret+"].\n" + document.all.ctmpResult.value;
	}
} // end function callCtmpMethod(func)	


function window.onunload(){
	//callCtmpMethod('NotReady');
	callCtmpMethod('LogOff');
	document.all.ctmpConnector.closeServer();
}


function getEventStatus(arg){
	document.all.ctmpResult.value = arg + "\n" + document.all.ctmpResult.value;

	var message = arg;
	var status = "-1";
	var receiveEvent = eval('(' + message + ')'); 
	//alert('getEventStatus >> ' + receiveEvent.EVENT);
	if( receiveEvent.EVENT == 'DELIVER'){
		softPhoneCallID=receiveEvent.CALLID
		var softPhoneEventType=receiveEvent.SELECT
		//IVR RECORDING SEQUENCE--------------------------------------
		//1. 4. 3. 2. 
		//------------------------------------------------------------
		if (softPhoneEventType == '4' ){
			softPhoneEventType = '3';
		}else if(softPhoneEventType=='2'){
			softPhoneEventType = '4';
		}else if(softPhoneEventType=='3'){
			softPhoneEventType = '2';
		}

		var softPhoneCallInNumber=receiveEvent.OTHERPARTY
		var salesGroupCode = receiveEvent.SALESGROUP

		//?????
		$("img#sp_lineStatus").attr('src',"/images/top/softphone/back.lineStatus_02.gif");
		
		//???? ???
		$('img#sp_btnAnswer').unbind("click");
		$('img#sp_btnAnswer').bind("click", function(){sp_btnAnswerClick();});
		imageUrl = $('img#sp_btnAnswer').attr('src');
		imageUrl = imageUrl.replace('_02','_01');
		$('img#sp_btnAnswer').attr('src', imageUrl);

		//???? ? ???
		$('img#sp_btnHangup').unbind("click");
		imageUrl = $('img#sp_btnHangup').attr('src');
		imageUrl = imageUrl.replace('_01','_02');
		$('img#sp_btnHangup').attr('src', imageUrl);

		document.getElementById("hidSPEventStatus").value = "0";
		//?????? ???
		//CALL MAIN FUNCTION
		if (softPhoneCallInNumber.length >= 12 ){
				var tempNumber = softPhoneCallInNumber.split('').reverse().join('');
				var standardNumber = tempNumber.charAt(10);
				//MOBILE
			  	if (standardNumber == '1'){
		   			softPhoneCallInNumber = softPhoneCallInNumber.substr(1,(softPhoneCallInNumber.length-1));
			  	}
			} // end if (softPhoneCallInNumber.length >= 12 ){
			
	  if(salesGroupCode_Login == '109' || salesGroupCode_Login == '164'){
			var url = "http://dx.anhuily.com:8081/cs/callcenter/initService.html?phoneNumber="+ softPhoneCallInNumber +"&seatsId=456&serialNumber=A22533562&serviceTypeId=1&timestamp=20120908104712&sig=0d74432a9fca1b0f";
			var frame_contenInput=window.parent.window.document.getElementById("center_frame");
			frame_contenInput.src=url;
		}
		var frames=window.parent.window.document.getElementById(gInOutPageMenuId);
		if (frames != null){
			//?????? ???
			//CALL MAIN FUNCTION
			/////////////////////////////////////////////
			//TELEPHONE NUMBER CHECK
			/////////////////////////////////////////////
			
			
			/////////////////////////////////////////////
		    //divided by user option
		    if( softPhoneEventType == 8 || softPhoneEventType == 98 ){
		    	frames.contentWindow.gfn_inbound_8({
		    	  	callID:softPhoneCallID,
		    	  	userMobile : softPhoneCallInNumber,
		    	  	salesGroupCode :   salesGroupCode
		    	});
		    }else{
		    	//1~4
			    frames.contentWindow.gfn_callin({
		    		type:softPhoneEventType,
		    		callID:softPhoneCallID,
		    		callInNo:softPhoneCallInNumber,
		    		sgcd:salesGroupCode,
		    		productType:'',
		    		productSerialNumber:''
		    	});
		    }//end esle
		}//if (frames != null ){
	}else if(receiveEvent.EVENT=='READY'){
		//???? ??? ??
		imageUrl = $('img#sp_togLeaving').attr('src');
		imageUrl = imageUrl.replace('_02','_01');
		$('img#sp_togLeaving').attr('src', imageUrl);
		//??? ??? ?? ? ??? ??? ?? ??
		$('img#sp_togAfterCallWork').unbind("click");
		
		var imageUrl = "";
		imageUrl = $("img#sp_togAfterCallWork").attr('src');
		imageUrl = imageUrl.replace('_02','_01');
		$("img#sp_togAfterCallWork").attr('src', imageUrl);
		//??? 2?? ???? ?? ??? ????? READY?
		//??? ? ??? ? ????? READY
		document.getElementById("hidSPEventStatus").value = "-1";
		Ext.MessageBox.hide();
		consultationFlag = 'N';
		var frames=window.parent.window.document.getElementById(gInOutPageMenuId);
		if (frames != null ){
			fnOpenHappyCallWindow(false);
		} 
	}else if(receiveEvent.EVENT=='INIT'){
		Ext.MessageBox.hide();
	}else if(receiveEvent.EVENT=='NOT_READY'){
		imageUrl = $('img#sp_togLeaving').attr('src');
		imageUrl = imageUrl.replace('_01','_02');
		$('img#sp_togLeaving').attr('src', imageUrl);

		document.getElementById("hidSPEventStatus").value = "4";
		Ext.MessageBox.hide();
	}else if(receiveEvent.EVENT=='LOGON'){
	    changeCtiStatus("ON")
		changeSoftphoneStatus('OFF');
		document.getElementById("hidSPEventStatus").value = "-1";
	}else if(receiveEvent.EVENT=='CALLING'){
		softPhoneCallID = "";
		softPhoneCallID=receiveEvent.CALLID;
		var softPhoneEventType='1'; //default
		var softPhoneCallInNumber='';
		var salesGroupCode = '-1'; // default

		//???? ???
		//$('img#sp_btnHangup').unbind("click");
		//$('img#sp_btnHangup').bind("click", function(){sp_btnHangupClick();});
		//imageUrl = $('img#sp_btnHangup').attr('src');
		//imageUrl = imageUrl.replace('_02','_01');
		//$('img#sp_btnHangup').attr('src', imageUrl);
			
		document.getElementById("hidSPEventStatus").value = "-1";
		Ext.MessageBox.hide();
		//NOTIFY NUMBER////////
		var frames=window.parent.window.document.getElementById(gInOutPageMenuId);
		//PARM1 : ?? 	PARM2 : CALL ID 	PARM3 : CALL IN NUMBER
		if (frames != null){
			if(typeof(outboundRtnObject) != 'undefined'){
				if(outboundRtnObject.selectTab == '2' || outboundRtnObject.selectTab == '3' || outboundRtnObject.selectTab == '4'|| outboundRtnObject.selectTab == '5' || outboundRtnObject.selectTab == '6' || outboundRtnObject.selectTab == '8'){

					if(outboundRtnObject.selectTab == '2'){
						//回访
						fnOpenHappyCallWindow(true);
					}
					//RESERVATON CALL
			    	if(outboundRtnObject.selectTab == '3'){
			    		frames.contentWindow.gfn_callin({
			    			type:'1',
    						callID:softPhoneCallID,
    						callInNo:softPhoneCallInNumber,
    						sgcd:outboundRtnObject.salesgCode,
    						productType:outboundRtnObject.prdYype,
    						productSerialNumber:outboundRtnObject.prdsrNum
			    		});
			    	} // end if(outboundRtnObject.selectTab == '3'){
			    	
			    	//定期点检CALL
			    	if(outboundRtnObject.selectTab == '4'){ 
			    		frames.contentWindow.gfn_callin({
		    		  		type:'4',
    						callID:softPhoneCallID,
    						callInNo:outboundRtnObject.dialNumber,
    						sgcd:outboundRtnObject.salesgCode,
    						productType:outboundRtnObject.prdYype,
    						productSerialNumber:outboundRtnObject.prdsrNum,
    						orderNum : '',//outboundRtnObject.orderNum,
    						tab4InputType : 3
			    		});
			    		//frames.contentWindow.gfn_callin('4',softPhoneCallID,outboundRtnObject.dialNumber,'');   
					} // end if(outboundRtnObject.selectTab == '4'){
				}else if(outboundRtnObject.selectTab == '1'){//NORMAL, VOC
					//VOC CALLING : update tab : 3
					//NORMAL NO NEED TO CALLING
					frames.contentWindow.g_callID = softPhoneCallID;
				}else{
					//RESERVATON CALL
					frames.contentWindow.callin('1',softPhoneCallID,softPhoneCallInNumber,salesGroupCode);   
				} // end if(outboundRtnObject.selectTab == '3' || outboundRtnObject.selectTab == '4' || outboundRtnObject.selectTab == '2'){ else
			} // end if(typeof(outboundRtnObject) != 'undefined'){
		} // end if (frames != null){
	}else if(receiveEvent.EVENT=='CONCLEAR'){
		if(consultationFlag == 'Y'){
		   	Ext.MessageBox.hide()	
		   	consultationFlag = 'N';
		   	document.getElementById("hidSPEventStatus").value = "-1";
		    $('img#sp_togAfterCallWork').bind("click", function(){sp_togAfterCallWorkClick();});
		   return false;
		}else{
			Ext.MessageBox.hide();
			//consultationFlag = 'N'
			changeSoftphoneStatus('OFF');
			//ONLY HANG UP
			//??? ???? ?? ???? ??? ???
			if(document.getElementById("hidSPEventStatus").value != "5"){
				callCtmpMethod('AfterCallWork');
			}
			document.getElementById("hidSPEventStatus").value = "-1";
		} // end if(consultationFlag == 'Y'){ else
	}else if(receiveEvent.EVENT=='LOGOFF'){
		changeCtiStatus("OFF")
	    changeSoftphoneStatus('OFF');
	}else if(receiveEvent.EVENT=='ESTABILISHED'){
		document.getElementById("hidSPEventStatus").value = "1";
		//???? CALLING?? ?? ????? ??
		changeSoftphoneStatus('ON');
		
		$('img#sp_btnHangup').unbind("click");
		$('img#sp_btnHangup').bind("click", function(){sp_btnHangupClick();});
		imageUrl = $('img#sp_btnHangup').attr('src');
		imageUrl = imageUrl.replace('_02','_01');
		$('img#sp_btnHangup').attr('src', imageUrl);
		
		Ext.MessageBox.hide();

		var frames=window.parent.window.document.getElementById(gInOutPageMenuId);
		//PARM1 : ?? 	PARM2 : CALL ID 	PARM3 : CALL IN NUMBER
		if (frames != null){
			//alert('ESTABILISHED');
			fnOpenHappyCallWindow(true); 
		} // end if (frames != null){
	}else if( receiveEvent.EVENT=='NO_ANSWER'){
		document.getElementById("hidSPEventStatus").value = "-1";
		Ext.MessageBox.hide();
		var frames=window.parent.window.document.getElementById(gInOutPageMenuId);
		//PARM1 : ?? 	PARM2 : CALL ID 	PARM3 : CALL IN NUMBER
		if (frames != null){
			//alert('NO_ANSWER');
			fnOpenHappyCallWindow(true);
		} // end if (frames != null )
		document.getElementById("hidSPEventStatus").value = "1";
		changeSoftphoneStatus('ON');
	}else if(receiveEvent.EVENT=='HOLD'){
		if(consultationFlag == 'N'){
			imageUrl = $("img#sp_togHoldding").attr('src');
			imageUrl = '/images/top/softphone/togHoldding_02.jpg';
			$("img#sp_togHoldding").attr('src', imageUrl);
	
			document.getElementById("hidSPEventStatus").value = "9";
		}
	}else if(receiveEvent.EVENT=='RETRIVED'){
		if(consultationFlag == 'N'){
			imageUrl = $("img#sp_togHoldding").attr('src');
			imageUrl = '/images/top/softphone/togHoldding_03.jpg';
	
			$("img#sp_togHoldding").attr('src', imageUrl);

			document.getElementById("hidSPEventStatus").value = "1";
		}else{
		   consultationFlag = 'N'
		}
	}else if(receiveEvent.EVENT == 'NETWORK_ERROR' ){
		//document.getElementById("hidSPEventStatus").value = "-1";
		Ext.MessageBox.hide();
		var frames=window.parent.window.document.getElementById(gInOutPageMenuId);
		//PARM1 : ?? 	PARM2 : CALL ID 	PARM3 : CALL IN NUMBER
		if (frames != null ){
			//alert('NO_ANSWER');
			fnOpenHappyCallWindow(false);
		} // end if (frames != null ){
	}else if(receiveEvent.EVENT == 'FAILED' ){
		 document.getElementById("hidSPEventStatus").value = "-1";
		 Ext.MessageBox.show({title: '请耐心等待',msg: 'CTI网络连接超时',width:300,closable:false});
		
		var frames=window.parent.window.document.getElementById(gInOutPageMenuId);
		//PARM1 : ?? 	PARM2 : CALL ID 	PARM3 : CALL IN NUMBER
		if (frames != null ){
			//alert('FAILED');
			fnOpenHappyCallWindow(false);
		} // end if (frames != null ){
		///////////////////	
		//callCtmpMethod('ClearConnection');
		// callCtmpMethod('Ready');
		
		if ( consultationFlag == 'Y'){
		  callCtmpMethod('Reconnect')
		}else{
		   callCtmpMethod('ClearConnection');
		}
	}else if(receiveEvent.EVENT == 'TRANSFER' ){
		//ADD
//		document.getElementById("hidSPEventStatus").value = "8888888";
		changeSoftphoneStatus("OFF");
	//  callCtmpMethod('ClearConnection');
		callCtmpMethod('AfterCallWork');
	}else if(receiveEvent.EVENT == 'CONFERENCE' ){
		document.getElementById("hidSPEventStatus").value = "8888888";
	}else if(receiveEvent.EVENT == 'AFTER_CALLWORK' ){
		Ext.MessageBox.hide();
		var imageUrl = "";
		imageUrl = $("img#sp_togAfterCallWork").attr('src');
		imageUrl = imageUrl.replace('_01','_02');
		$("img#sp_togAfterCallWork").attr('src', imageUrl);
		
		document.getElementById("hidSPEventStatus").value = "5";
		
		//???(AFTER CALL WORK)???
		$('img#sp_togAfterCallWork').bind("click", function(){sp_togAfterCallWorkClick();});
	}else if(receiveEvent.EVENT == 'SPECIAL9' ){ // 无法拨通电话时
		Ext.MessageBox.show({title: '请耐心等待',msg: '你拨打的电话错误或已关机，请确认后再拨。',width:300,closable:false});
		var frames=window.parent.window.document.getElementById(gInOutPageMenuId);
		//PARM1 : ?? 	PARM2 : CALL ID 	PARM3 : CALL IN NUMBER
		if (frames != null ){ 
			fnOpenHappyCallWindow(false);
		} // end if (frames != null ){
	} // end else if(receiveEvent.EVENT == 'SPECIAL9' ){
}

function getAgentStatusEx(queryAgentID, queryAgentMode, queryAgentDN, queryAgentblendMode, queryAgentblockMode, 
						queryAgentTime, queryAgentType){
	document.all.ctmpResult.value = "[agentID:" 		+ queryAgentID 			+ ", " +
									"agentMode:" 		+ queryAgentMode 		+ ", " +
									"agentDN:" 			+ queryAgentDN 			+ ", " +
									"agentblendMode:" 	+ queryAgentblendMode 	+ ", " +
									"agentblockMode:" 	+ queryAgentblockMode 	+ ", " +
									"agentTime:" 		+ queryAgentTime 		+ ", " +
									"agentType:" 		+ queryAgentType 		+ "]\n"+ document.all.ctmpResult.value;
}//end function getAgentStatusEx


function getAgentBusy(agentId, deviceDN, blendMode, continueTime, readCount){
	document.all.ctmpResult.value = "[agentId:" 	+ agentId 		+ ", " +
									"deviceDN:" 	+ deviceDN 		+ ", " +
									"blendMode:" 	+ blendMode 	+ ", " +
									"continueTime:" + continueTime 	+ ", " +
									"readCount:" 	+ readCount 	+ "]\n" + document.all.ctmpResult.value;
} // end function getAgentBusy


function getAgentReady(agentId, deviceDN, blendMode, continueTime, readCount){
	document.all.ctmpResult.value = "[agentId:" 	+ agentId 		+ ", " +
									"deviceDN:" 	+ deviceDN 		+ ", " +
									"blendMode:" 	+ blendMode 	+ ", " +
									"continueTime:" + continueTime 	+ ", " +
									"readCount:" 	+ readCount 	+ "]\n"+ document.all.ctmpResult.value;
}//end function getAgentReady


function WindowClose(){
	OnExitTimer();
	//CLOSE VOICE SERVER
	NEOClient.DisconnectFromNV();
	//CLOSE CTI SERVER
	callCtmpMethod('NotReady');
	callCtmpMethod('LogOff');
	callCtmpMethod('CloseServer');
	
	document.all.ctmpConnector.threadexit();
	document.all.ctmpConnector.closeServer();

	//退出单点登录tiket信息
	var iframe = document.createElement("iframe");
	 //test
	 //iframe.src = 'http://testdoosim.doosaninfracore.com:7003/bokesso/logout?businessSystemId=DOOCC' ;
	 //real
	 iframe.src = 'http://doosim.doosaninfracore.com/sso/logout?businessSystemId=DOOCC' ;
	iframe.style.display = "none";
	document.body.appendChild(iframe);
} // end function WindowClose()


function getAgentReadyStatus(data, readCount){}

//ERROR : MAKECALL
function getShowErrorMessage( errorCode, message ){
   Ext.MessageBox.show({title: errorCode,msg: '您拨打的号码错误',width:300,buttons: Ext.MessageBox.OK });
   callCtmpMethod('Ready');
} // end function getShowErrorMessage


function getClearConnectionClearFail(errorCode){
	//5 --> can ready
	document.getElementById("hidSPEventStatus").value=5;
    $('img#sp_togAfterCallWork').bind("click", function(){sp_togAfterCallWorkClick();});
} // end function getClearConnectionClearFail


function getShowErrorConsultationMessage(errorCode, message){}


function exitByException( message ){
	alert(message);
    window.opener = self;
    self.close();
}


/**
 * 退出系统
 */
function OnLogOut(){


	if(confirm('确定要退出系统吗？') == true){
		WindowClose();
		top.opener = top;
		top.window.close();
	}
	
} // end function OnLogOut()


////////////////////////////////////////////
// THE FUNCTION LIST FOR INTERFACE
////////////////////////////////////////////
function eventForConsultation(number){
	if( typeof(number) != 'undefined' ){
		sp_btnExchangeClick(number);
	}
}


/**
 * 当CTI发送错误信息给Applet时调用此函数
 */
function getEventStatusError(args){
	var frames=window.parent.window.document.getElementById(gInOutPageMenuId);
	//PARM1 : ??
	//PARM2 : CALL ID
	//PARM3 : CALL IN NUMBER
	if (frames != null ){ 
		fnOpenHappyCallWindow(false);
	} //end  if (frames != null ){
	//callCtmpMethod('ClearConnection');
} // end function getEventStatusError(
		
	//-------------------------------------------------------------------------------
	//Q&A
function showQNA(){

	var url = '/action/qna_pre_enter.action';
	var params = 'dialogheight:410px;dialogwidth:815px;' 
		   + 'center=yes,toolbar=no , menubar=no, scrollbars=no, resizable=no,location=no, status=yes';  
	window.showModalDialog(url,'SHOW_POPUP',params);
}
	</script>
</head>
<body onLoad="ctiServerStart();" OnUnload="WindowClose();" onBeforeUnload="WindowClose();" onContextMenu="return false;" >
<div style="display:none;">
	<input type="hidden" id="hidSPEventStatus"/>
	<input type="hidden" id="hidAfterCallWork"/>
</div>
	<div class="top_content"> 
		<input type='hidden' id="ctmpResult" rows="9" cols="90" /> 
    	<table border="0" cellpadding="0" cellspacing="0" width="100%">
    		<tr>
    			<td width="200px" height="70px" align="left" valign="top">
    				<img src="/images/top/back.logo.jpg" align="absmiddle" alt=""></img>
    			</td>
    			<td align="left" valign="middle">
    				<table border="0" cellpadding="0" cellspacing="0" align="left">
    					<tr>
    						<td width="105px" valign="middle" align="left" height="20px">
    							<img id="sp_lineStatus" src="/images/top/softphone/back.lineStatus_01.gif" /></td>	
    						<td width="48px" valign="middle" align="left" rowspan="2">
    							<img id="sp_btnDial" class="spButton" src="/images/top/softphone/btnDial_01.jpg" title='拨号键盘' onClick="sp_btnDialClick()" style="cursor:pointer;" /></td>
    						<td width="48px" valign="middle" align="left" rowspan="2">
    							<img id="sp_btnAnswer" class="spButton" src="/images/top/softphone/btnAnswer_02.jpg" title='接听' style="cursor:pointer;" /></td>
    						<td width="48px" valign="middle" align="left" rowspan="2">
    							<img id="sp_btnHangup" class="spButton" src="/images/top/softphone/btnHangup_01.jpg" title='断开' onClick="sp_btnHangupClick();" style="cursor:pointer;" /></td>
    						<td width="48px" valign="middle" align="left" rowspan="2">
    							<img id="sp_btnExchange" class="spButton" src="/images/top/softphone/exchange_02.gif" title='协议' style="cursor:pointer;" /></td>	
    						<td width="48px" valign="middle" align="left" rowspan="2">
    							<img id="sp_btnConference" class="spButton" src="/images/top/softphone/btnConference_02.jpg" title='3方会议' style="cursor:pointer;" /></td>
    						<td width="58px" valign="middle" align="left" rowspan="2">
    							<img id="sp_btnTransfer" class="spButton" src="/images/top/softphone/btnTransfer_02.jpg" title='呼叫转移' style="cursor:pointer;" /></td>
    						<td width="35px" valign="middle" align="left" rowspan="2">
    							<img id="sp_togHoldding" class="spToggle" src="/images/top/softphone/togHoldding_01.jpg" title='挂起' style="cursor:pointer;" /></td>
    						<td width="34px" valign="middle" align="left" rowspan="2">
    							<img id="sp_togLeaving" class="spToggle" src="/images/top/softphone/togLeaving_01.jpg" title='离开' onClick="sp_togLeavingClick()" style="cursor:pointer;" /></td>
    						<td width="36px" valign="middle" align="left" rowspan="2">
    							<img id="sp_togAfterCallWork" class="spToggle" src="/images/top/softphone/togAfterCallWork_01.jpg" title='后处理' onClick="sp_togAfterCallWorkClick();" style="cursor:pointer;" /></td>
    					</tr>
    					<tr>
    						<td width="105px" valign="middle" align="left" height="20px">
    							<img id="sp_ctiStatus" src="/images/top/softphone/back.ctiStatus_01.jpg" /></td>
    					</tr>
    				</table>
    			</td>
    			<td width="200px" height="70px" align="right" valign="top">
    				<div style="height: 5px; font-size:2px;"></div>
    				<div id="topMenuBar" align="right">
			    		<table border="0" cellpadding="0" cellspacing="0" align="right">
							<tr>
								<td width="56px" valign="top" align="center" height="20px">
									<img src="/images/top/topMenu/top.Home.jpg" style="cursor:pointer;"  /></td>
								<td width="56px" valign="top" align="center">
									<img src="/images/top/topMenu/top.qna.gif" style="cursor:pointer;" id="qna" onClick="showQNA();"/></td>
								<td width="56px" valign="top" align="center">
									<img src="/images/top/topMenu/top.Logout.jpg" style="cursor:pointer;" onClick="OnLogOut()" /></td>
							</tr>
							<tr>
								<td colspan="3" height="40px"  valign="bottom" align="right">
									<div style="padding-right:12px;"><img src="/images/top/systemTitle.jpg" width="141" height="14"/></div>
								</td>
							</tr>
						</table>
			    	</div>
    			</td>
    		</tr>
    	</table>
    </div>
    <div class="callJobStat">
    	<table border="0" cellpadding="0" cellspacing="0" width="100%"
    		style="font-size:12px; color:#212e7f;font-family:微软雅黑, Tahoma;">
    		<tr>
    			<td width="160px" height="26px" align="left" valign="middle">
    				<img src="/images/top/callJobStatus/bar.title.jpg" align="absmiddle" alt=""></img>
    			</td>
    			<td align="left" valign="middle" style="color:#5b5b5b;">
    				<ul id="ulCallJobStat">
    					<li>【</li>
    					<li id='outboundList1' class="outboundListType" style="cursor:pointer;">未 决：<span style="font-weight:bold;cursor:pointer;"><b id='outboundList1Value'>0</b></span></li>
    					<li id='outboundList3' class="outboundListType" style="cursor:pointer;">回 拨：<span style="font-weight:bold;cursor:pointer;"><b id='outboundList3Value'>0</b></span></li>
    					<li id='outboundList2' class="outboundListType" style="cursor:pointer;">回 访：<span style="font-weight:bold;cursor:pointer;"><b id='outboundList2Value'>0</b></span></li>
    					<li id='outboundList4' class="outboundListType" style="cursor:pointer;">点检报告：<span style="font-weight:bold;cursor:pointer;"><b id='outboundList4Value'>0</b></span></li>
    					<li id='outboundList5' class="outboundListType" style="cursor:pointer;">巡 检：<span style="font-weight:bold;cursor:pointer;"><b id='outboundList5Value'>0</b></span></li>
    					<li id='outboundList6' class="outboundListType" style="cursor:pointer;">Rework：<span style="font-weight:bold;cursor:pointer;"><b id='outboundList6Value'>0</b></span></li>
    					<li id='outboundList7' class="outboundListType" style="cursor:pointer;">故障预警：<span style="font-weight:bold;cursor:pointer;"><b id='outboundList7Value'>0</b></span></li>
    					<li id='outboundList8' class="outboundListType" style="cursor:pointer;">投诉：<span style="font-weight:bold;cursor:pointer;"><b id='outboundList8Value'>0</b></span></li>
    					<li>】</li>
    					<li>登陆ID : ${sessionScope.userMaster.userLoginID}&nbsp;(${sessionScope.userMaster.userName})     </li>
    					<li>&nbsp;分机号码 : ${sessionScope.userMaster.userCtiNum}</li>
    					<li style="display: none;">&nbsp 等待客户 :</li>
    					<li id="waitCount"></li>
    				</ul>
    			</td>
    		</tr>
    	</table>
    </div>
</body>
</html>
<!-- 录音文件OXC -->
<object id="NEOClient" style="LEFT: 0px; VISIBILITY: visible; TOP: 0px; Width:0px; Height:0px; "  
codebase="http://doocc.doosaninfracore.com/jsp/callcenter/NeoClient.cab" classid="clsid:9D3942D7-F3B5-40B3-B7C4-8C85D7E97D1E" VIEWASTEXT></object>
<!-- CTI服务器 OXC -->
<applet name="ctmpConnector"  codebase="http://10.41.128.32/jsp/callcenter/." 
code="ctmpApplet" archive="ctmpConnector.jar" mayscript="mayscript" width="0" height="0">
</applet>