package com.wighawag.remote.authentification;

import nme.events.Event;
import nme.events.IOErrorEvent;
import nme.Lib;
import nme.net.URLLoader;
import nme.net.URLRequest;
import nme.net.URLLoaderDataFormat;
import nme.net.URLRequestMethod;
import nme.net.URLVariables;
import hxjson2.JSON;
import haxe.Http;

import hsl.haxe.DirectSignaler;
import hsl.haxe.Signaler;

class TestPlayerAutentification 
{

	private var url:String;
	private var userId:String;
	private var password:String;
	private var testUserId:String;
	
	private var onAuthenticated : Signaler<Dynamic>;
	

	public function new(url : String, userId : String, password : String, testUserId : String)
	{
		this.url = url;
		this.userId = userId;
		this.password = password;
		this.testUserId = testUserId;
	}
	
	public function connect() : Signaler<Dynamic>
	{
		var request : URLRequest = new URLRequest(url);
		request.method = URLRequestMethod.POST;
		request.data = new URLVariables("userId="+userId+"&password="+password+"&testUserId="+testUserId+"&method=signedRequest");
		
		var urlLoader : URLLoader = new URLLoader();
		urlLoader.addEventListener(Event.COMPLETE, onComplete);
		urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		urlLoader.load(request);
		
		onAuthenticated = new DirectSignaler(this);
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
		var data : Dynamic = JSON.parse(e.target.data);
		onAuthenticated.dispatch(data);
	}
	
}