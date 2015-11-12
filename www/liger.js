

var LIGER = {
    
    ////PAGE.openPage('Second Page', 'secondPage', {'test1': 'test2'}, {});
    //openPage: function(title, page, args, options) { LIGER.openPage(title, page, args, options); },
    
	openPage: function(title, page, args, options) {
       
      
		if (options === undefined){
			options = {};
		}
        
        //js端为了与native进行通信所封装的方法。最终会在UCCDVURLProtocol 拦截相关请求
        
        /**
         Cordova JS 端请求方法的格式：
         
          successCallback : 成功回调方法
          failCallback    : 失败回调方法
          server          : 所要请求的服务名字
          action          : 所要请求的服务具体操作
          actionArgs      : 请求操作所带的参数
         cordova.exec(successCallback, failCallback, service, action, actionArgs);
         */
        
        
   
		cordova.exec(null, null, "Liger", "openPage", [ title, page, args, options ]);
        
        //js端先初步处理下数据
        
        /*
         JS 端处理请求                                                     cordova.js（github 地址）
         function iOSExec() {
         ...
         // 生成一个 callbackId 的唯一标识，并把此标志与成功、失败回调方法一起保存在 JS 端
         // Register the callbacks and add the callbackId to the positional
         // arguments if given.
         if (successCallback || failCallback) {
         callbackId = service + cordova.callbackId++;
         cordova.callbacks[callbackId] =
         {success:successCallback, fail:failCallback};
         }
         
         actionArgs = massageArgsJsToNative(actionArgs);
         
         // 把 callbackId，service，action，actionArgs 保持到 commandQueue 中
         // 这四个参数就是最后发给原生代码的数据
         var command = [callbackId, service, action, actionArgs];
         commandQueue.push(JSON.stringify(command));
         ...
         }
         
         // 获取请求的数据，包括 callbackId, service, action, actionArgs
         iOSExec.nativeFetchMessages = function() {
         // Each entry in commandQueue is a JSON string already.
         if (!commandQueue.length) {
         return '';
         }
         var json = '[' + commandQueue.join(',') + ']';
         commandQueue.length = 0;
         return json;
         };
         
         */
        
        
        //最终native原生代码拿到 callbackId、service、action 及 actionArgs 后，会做以下的处理：
        
        /*
         1.根据 service 参数找到对应的插件类
         2.根据 action 参数找到插件类中对应的处理方法，并把 actionArgs 作为处理方法请求参数的一部分传给处理方法
         3.处理完成后，把处理结果及 callbackId 返回给 JS 端，JS 端收到后会根据 callbackId 找到回调方法，并把处理结果传给回调方法
         
         
         关键代码：
         
         Objective-C 返回结果给JS端                           CDVCommandDelegateImpl.m（github 地址）
         - (void)sendPluginResult:(CDVPluginResult*)result callbackId:(NSString*)callbackId
         {
         CDV_EXEC_LOG(@"Exec(%@): Sending result. Status=%@", callbackId, result.status);
         // This occurs when there is are no win/fail callbacks for the call.
         if ([@"INVALID" isEqualToString : callbackId]) {
         return;
         }
         int status = [result.status intValue];
         BOOL keepCallback = [result.keepCallback boolValue];
         NSString* argumentsAsJSON = [result argumentsAsJSON];
         
         // 将请求的处理结果及 callbackId 通过调用 JS 方法返回给 JS 端
         NSString* js = [NSString stringWithFormat:
         @"cordova.require('cordova/exec').nativeCallback('%@',%d,%@,%d)",
         callbackId, status, argumentsAsJSON, keepCallback];
         
         [self evalJsHelper:js];
         }
         
         

         JS 端根据 callbackId 回调                              cordova.js（github 地址）
         
         // 根据 callbackId 及是否成功标识，找到回调方法，并把处理结果传给回调方法
         callbackFromNative: function(callbackId, success, status, args, keepCallback) {
         var callback = cordova.callbacks[callbackId];
         if (callback) {
         if (success && status == cordova.callbackStatus.OK) {
         callback.success && callback.success.apply(null, args);
         } else if (!success) {
         callback.fail && callback.fail.apply(null, args);
         }
         
         // Clear callback if not expecting any more results
         if (!keepCallback) {
         delete cordova.callbacks[callbackId];
         }
         }
         }
         */
        
        
	},

	closePage: function() {
		cordova.exec(null, null, "Liger", "closePage", []);
	},

	closeToPage: function(page) {
		cordova.exec(null, null, "Liger", "closePage", [page]);
	},

	updateParent: function(args) {
		cordova.exec(null, null, "Liger", "updateParent", [null, args]);
	},

	updateParentPage: function(page, args) {
		cordova.exec(null, null, "Liger", "updateParent", [page, args]);
	},

	childUpdates: function(args){
		PAGE.childUpdates(args);
	},
	
	openPageArguments: function(args) {
		PAGE.args = args;
	},

	getPageArgs: function(){
		cordova.exec(
			function(args){ 
				PAGE.gotPageArgs(args);
			}, 
			function(error) { 
				return false;
			}, "Liger", "getPageArgs", []);
	},

	openDialog: function(page, args, options){
		if (options === undefined){
			options = {};
		}
		cordova.exec(null, null, "Liger", "openDialog", [ page, args, options ]);
	},

	openDialogWithTitle: function(title, page, args, options) {
		if (options === undefined){
			options = {};
		}
		cordova.exec(null, null, "Liger", "openDialogWithTitle", [ title, page, args, options ]); 
	},

	closeDialog: function(args) {
		cordova.exec(null, null, "Liger", "closeDialog", [args]);
	},

	closeDialogArguments: function(args){
        PAGE.closeDialogArguments(args);
	},
	
	toolbar: function(items) {
		cordova.exec(null, null, "Liger", "toolbar", [items]);
	}
};
               
               
                  module.exports = LIGER;


