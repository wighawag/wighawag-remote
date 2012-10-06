package com.wighawag.remote.authentification;

import nme.events.Event;
import nme.events.IOErrorEvent;
import nme.events.SecurityErrorEvent;
import nme.net.URLLoader;
import nme.net.URLRequest;
import nme.net.URLLoaderDataFormat;
import nme.net.URLRequestMethod;
import nme.net.URLVariables; 
import hxjson2.JSON;
import haxe.Http;

import hsl.haxe.DirectSignaler;
import hsl.haxe.Signaler;

class PasswordAuthentification 
{
	private var url:String;
	private var userId:String;
	private var password:String;
	
	private var onAuthenticated : Signaler<Dynamic>;

	public function new(url : String, userId : String, password : String)
	{
		this.url = url;
		this.userId = userId;
		this.password = password;
	}
	
	public function connect() : Signaler<Dynamic>
	{
		var request : URLRequest = new URLRequest(url);
		request.method = URLRequestMethod.POST;
		request.data = new URLVariables("userId="+userId+"&password="+password+"&method=signedRequest");
		
		var urlLoader : URLLoader = new URLLoader();
		urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
        urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
		urlLoader.addEventListener(Event.COMPLETE, onComplete);


        try{
            urlLoader.load(request);
        }
        catch(e : Dynamic){
            var timer : haxe.Timer = new haxe.Timer(10);
            timer.run = function(): Void{onError(null);timer.stop();};
        }
		
		onAuthenticated = new DirectSignaler(this);
		return onAuthenticated;
	}
	
	private function onError(?event:Event):Void
	{
        if (event != null){
            trace(event.toString());
        }
		// TODO : for now :
		onAuthenticated.dispatch(null);
	}
	
	private function onComplete(e:Event):Void 
	{
		var data : Dynamic = JSON.parse(e.target.data);
		trace("getting player : " + data);
		onAuthenticated.dispatch(data);
	}
	
}