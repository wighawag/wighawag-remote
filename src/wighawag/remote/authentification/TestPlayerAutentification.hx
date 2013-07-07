/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.remote.authentification;

import haxe.Json;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import msignal.Signal;

class TestPlayerAutentification 
{

	private var url:String;
	private var userId:String;
	private var password:String;
	private var testUserId:String;
	
	private var onAuthenticated : Signal1<Dynamic>;
	

	public function new(url : String, userId : String, password : String, testUserId : String)
	{
		this.url = url;
		this.userId = userId;
		this.password = password;
		this.testUserId = testUserId;
	}
	
	public function connect() : Signal1<Dynamic>
	{
		var request : URLRequest = new URLRequest(url);
		request.method = URLRequestMethod.POST;
		request.data = new URLVariables("userId="+userId+"&password="+password+"&testUserId="+testUserId+"&method=signedRequest");
		
		var urlLoader : URLLoader = new URLLoader();
		urlLoader.addEventListener(Event.COMPLETE, onComplete);
		urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		urlLoader.load(request);
		
		onAuthenticated = new Signal1();
		return onAuthenticated;
	}
	
	private function onIOError(e:IOErrorEvent):Void 
	{
		#if flash
		Lib.trace(e);
		#end
		onAuthenticated.dispatch(null);
	}
	
	private function onComplete(e:Event):Void 
	{
		var data : Dynamic = Json.parse(e.target.data);
		onAuthenticated.dispatch(data);
	}
	
}